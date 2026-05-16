defmodule Corex.TagsInput.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.TagsInput.Translation, as: TagsInputTranslation

  alias Corex.TagsInput.Anatomy.{
    Control,
    HiddenInput,
    Label,
    MainInput,
    Props,
    Root,
    SsrItem,
    SsrItemDeleteTrigger,
    SsrItemInput,
    SsrItemPreview,
    SsrItemText,
    ValueInput
  }

  import Corex.Helpers,
    only: [get_boolean: 1, validate_value!: 1, maybe_put_data_dir_from: 2, maybe_put_dir_from: 2]

  alias Phoenix.LiveView.JS

  @spec tag_item_dom_id(String.t(), String.t(), non_neg_integer()) :: String.t()
  def tag_item_dom_id(root_id, value, index) do
    "tags-input:#{root_id}:tag:#{value}:#{index}"
  end

  defp tag_delete_dom_id(root_id, value, index),
    do: tag_item_dom_id(root_id, value, index) <> ":delete-btn"

  defp tag_input_dom_id(root_id, value, index),
    do: tag_item_dom_id(root_id, value, index) <> ":input"

  defp tag_text_dom_id(root_id, index), do: "tags-input:#{root_id}:tag-text:#{index}"

  defp ssr_item_row_id(root_id, index), do: "tags-input:#{root_id}:ssr-item:#{index}"

  defp put_item_data_disabled(attrs, false), do: attrs
  defp put_item_data_disabled(attrs, true), do: Map.put(attrs, "data-disabled", "")

  @spec ssr_item(SsrItem.t()) :: map()
  def ssr_item(%SsrItem{} = a) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "item",
      "data-value" => a.value,
      "id" => ssr_item_row_id(a.root_id, a.index)
    }
    |> maybe_put_dir_from(a)
    |> put_item_data_disabled(a.disabled)
  end

  def ignore_ssr_item(%SsrItem{} = a) do
    JS.ignore_attributes(SsrItem.ignored_attrs(),
      to: Selectors.css_id(ssr_item_row_id(a.root_id, a.index))
    )
  end

  @spec ssr_item_preview(SsrItemPreview.t()) :: map()
  def ssr_item_preview(%SsrItemPreview{} = a) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "item-preview",
      "id" => tag_item_dom_id(a.root_id, a.value, a.index),
      "data-value" => a.value
    }
    |> maybe_put_dir_from(a)
    |> put_item_data_disabled(a.disabled)
  end

  def ignore_ssr_item_preview(%SsrItemPreview{} = a) do
    JS.ignore_attributes(SsrItemPreview.ignored_attrs(),
      to: Selectors.css_id(tag_item_dom_id(a.root_id, a.value, a.index))
    )
  end

  @spec ssr_item_text(SsrItemText.t()) :: map()
  def ssr_item_text(%SsrItemText{} = a) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "item-text",
      "id" => tag_text_dom_id(a.root_id, a.index)
    }
  end

  def ignore_ssr_item_text(%SsrItemText{} = a) do
    JS.ignore_attributes(SsrItemText.ignored_attrs(),
      to: Selectors.css_id(tag_text_dom_id(a.root_id, a.index))
    )
  end

  @spec ssr_item_delete_trigger(SsrItemDeleteTrigger.t()) :: map()
  def ssr_item_delete_trigger(%SsrItemDeleteTrigger{} = a) do
    base =
      %{
        "data-scope" => "tags-input",
        "data-part" => "item-delete-trigger",
        "type" => "button",
        "id" => tag_delete_dom_id(a.root_id, a.value, a.index),
        "tabindex" => "-1",
        "aria-disabled" => if(a.disabled, do: "true", else: "false"),
        "aria-label" => a.aria_label
      }
      |> maybe_put_dir_from(a)
      |> put_item_data_disabled(a.disabled)

    if a.disabled, do: Map.put(base, "disabled", true), else: base
  end

  def ignore_ssr_item_delete_trigger(%SsrItemDeleteTrigger{} = a) do
    JS.ignore_attributes(SsrItemDeleteTrigger.ignored_attrs(),
      to: Selectors.css_id(tag_delete_dom_id(a.root_id, a.value, a.index))
    )
  end

  @spec ssr_item_input(SsrItemInput.t()) :: map()
  def ssr_item_input(%SsrItemInput{} = a) do
    base =
      %{
        "data-scope" => "tags-input",
        "data-part" => "item-input",
        "type" => "text",
        "id" => tag_input_dom_id(a.root_id, a.value, a.index),
        "tabindex" => "-1",
        "hidden" => true
      }
      |> maybe_put_dir_from(a)
      |> maybe_put_aria_label(a.aria_label)

    if a.disabled, do: Map.put(base, "disabled", true), else: base
  end

  defp maybe_put_aria_label(attrs, nil), do: attrs

  defp maybe_put_aria_label(attrs, label) when is_binary(label),
    do: Map.put(attrs, "aria-label", label)

  def ignore_ssr_item_input(%SsrItemInput{} = a) do
    JS.ignore_attributes(SsrItemInput.ignored_attrs(),
      to: Selectors.css_id(tag_input_dom_id(a.root_id, a.value, a.index))
    )
  end

  defp tags_json(tags) when is_list(tags), do: Jason.encode!(validate_value!(tags))

  @spec props(Props.t()) :: map()
  def props(assigns) do
    value = validate_value!(assigns.value)

    assigns
    |> base_hook_props(value)
    |> put_data_max(assigns.max)
    |> put_data_delimiter(assigns.delimiter)
    |> put_data_blur_behavior(assigns.blur_behavior)
    |> put_data_editable(assigns.editable)
    |> maybe_put_data_dir_from(assigns)
    |> Map.put("data-translation", translation_json(assigns))
  end

  defp base_hook_props(assigns, value) do
    %{
      "data-controlled" => get_boolean(assigns.controlled),
      "data-tags" => if(assigns.controlled, do: tags_json(value)),
      "data-default-tags" => if(!assigns.controlled, do: tags_json(value)),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-read-only" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-add-on-paste" => get_boolean(assigns.add_on_paste),
      "data-allow-duplicates" => get_boolean(assigns.allow_duplicates),
      "data-allow-overflow" => get_boolean(assigns.allow_overflow),
      "data-auto-focus" => get_boolean(assigns.auto_focus),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-input-value-change" => assigns.on_input_value_change,
      "data-on-input-value-change-client" => assigns.on_input_value_change_client,
      "data-on-highlight-change" => assigns.on_highlight_change,
      "data-on-highlight-change-client" => assigns.on_highlight_change_client,
      "data-on-value-invalid" => assigns.on_value_invalid,
      "data-on-value-invalid-client" => assigns.on_value_invalid_client
    }
  end

  defp put_data_max(attrs, n) when is_integer(n) and n > 0,
    do: Map.put(attrs, "data-max", to_string(n))

  defp put_data_max(attrs, _), do: attrs

  defp put_data_delimiter(attrs, s) when is_binary(s) and s != "",
    do: Map.put(attrs, "data-delimiter", s)

  defp put_data_delimiter(attrs, _), do: attrs

  defp put_data_blur_behavior(attrs, b) when b in ["add", "clear"],
    do: Map.put(attrs, "data-blur-behavior", b)

  defp put_data_blur_behavior(attrs, _), do: attrs

  defp put_data_editable(attrs, true), do: Map.put(attrs, "data-editable", "true")
  defp put_data_editable(attrs, false), do: Map.put(attrs, "data-editable", "false")
  defp put_data_editable(attrs, _), do: attrs

  defp translation_json(assigns) do
    case Map.get(assigns, :translation) do
      %TagsInputTranslation{} = t ->
        t
        |> TagsInputTranslation.to_camel_map()
        |> Enum.reject(fn {_, v} -> v in [nil, ""] end)
        |> Map.new()
        |> then(fn
          m when map_size(m) == 0 -> nil
          m -> Corex.Json.encode!(m)
        end)

      _ ->
        nil
    end
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "root",
      "id" => "tags-input:#{assigns.id}"
    }
    |> maybe_put_dir_from(assigns)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "label",
      "id" => "tags-input:#{assigns.id}:label"
    }
    |> maybe_put_dir_from(assigns)
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}:label")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "control",
      "id" => "tags-input:#{assigns.id}:control"
    }
    |> maybe_put_dir_from(assigns)
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}:control")
    )
  end

  @spec main_input(MainInput.t()) :: map()
  def main_input(assigns) do
    base =
      %{
        "data-scope" => "tags-input",
        "data-part" => "input",
        "id" => "tags-input:#{assigns.id}:input"
      }
      |> maybe_put_dir_from(assigns)

    case Map.get(assigns, :placeholder) do
      nil -> base
      "" -> base
      p when is_binary(p) -> Map.put(base, "placeholder", p)
      _ -> base
    end
  end

  def ignore_main_input(assigns) do
    JS.ignore_attributes(MainInput.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}:input")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "hidden-input",
      "type" => "text",
      "hidden" => true,
      "id" => "tags-input:#{assigns.id}:hidden-input"
    }
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}:hidden-input")
    )
  end

  @spec value_input(ValueInput.t()) :: map()
  def value_input(assigns) do
    %{
      "data-scope" => "tags-input",
      "data-part" => "value-input",
      "type" => "hidden",
      "id" => "tags-input:#{assigns.id}:value-input"
    }
    |> maybe_put_dir_from(assigns)
  end

  def ignore_value_input(assigns) do
    JS.ignore_attributes(ValueInput.ignored_attrs(),
      to: Selectors.css_id("tags-input:#{assigns.id}:value-input")
    )
  end
end
