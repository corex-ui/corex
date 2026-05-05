defmodule Corex.FileUpload.Connect do
  @moduledoc false
  import Corex.Helpers, only: [get_boolean: 1]

  alias Corex.Selectors

  alias Corex.FileUpload.Anatomy.{
    Dropzone,
    HiddenInput,
    InputSentinel,
    ItemGroup,
    Label,
    Props,
    Root,
    Trigger
  }

  alias Phoenix.LiveView.JS

  defp zid(id), do: "file:#{id}"

  defp maybe_put_int(map, _key, nil), do: map

  defp maybe_put_int(map, key, value) when is_integer(value) do
    Map.put(map, key, Integer.to_string(value))
  end

  defp maybe_put_int(map, _key, _value), do: map

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-read-only" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => Map.get(assigns, :dir, "ltr"),
      "data-max-files" => Integer.to_string(assigns.max_files),
      "data-allow-drop" => if(assigns.allow_drop, do: "true", else: "false"),
      "data-prevent-document-drop" =>
        if(assigns.prevent_document_drop, do: "true", else: "false"),
      "data-accept" => assigns.accept,
      "data-directory" => get_boolean(assigns.directory),
      "data-on-file-change" => assigns.on_file_change,
      "data-on-file-change-client" => assigns.on_file_change_client,
      "data-on-file-accept" => assigns.on_file_accept,
      "data-on-file-accept-client" => assigns.on_file_accept_client,
      "data-on-file-reject" => assigns.on_file_reject,
      "data-on-file-reject-client" => assigns.on_file_reject_client,
      "data-translation-dropzone" => assigns.dropzone
    }
    |> maybe_put_int("data-max-file-size", assigns.max_file_size)
    |> maybe_put_int("data-min-file-size", assigns.min_file_size)
    |> Map.reject(fn {_k, v} -> is_nil(v) end)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(), to: Selectors.css_id(zid(assigns.id)))
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(), to: Selectors.css_id("#{zid(assigns.id)}:label"))
  end

  def ignore_dropzone(assigns) do
    JS.ignore_attributes(Dropzone.ignored_attrs(),
      to: Selectors.css_id("#{zid(assigns.id)}:dropzone")
    )
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("#{zid(assigns.id)}:input")
    )
  end

  def ignore_input_sentinel(assigns) do
    JS.ignore_attributes(InputSentinel.ignored_attrs(),
      to: Selectors.css_id("#{zid(assigns.id)}:sentinel")
    )
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("#{zid(assigns.id)}:trigger")
    )
  end

  def ignore_item_group(assigns) do
    JS.ignore_attributes(ItemGroup.ignored_attrs(),
      to: Selectors.css_id("#{zid(assigns.id)}:item-group:#{assigns.type}")
    )
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "file-upload",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => zid(assigns.id)
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "file-upload",
      "data-part" => "label",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "#{zid(assigns.id)}:label",
      "for" => "#{zid(assigns.id)}:input"
    }
  end

  @spec dropzone(Dropzone.t()) :: map()
  def dropzone(assigns) do
    %{
      "data-scope" => "file-upload",
      "data-part" => "dropzone",
      "id" => "#{zid(assigns.id)}:dropzone"
    }
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    base = %{
      "data-scope" => "file-upload",
      "data-part" => "hidden-input",
      "type" => "file",
      "id" => "#{zid(assigns.id)}:input",
      "disabled" => get_boolean(assigns.disabled),
      "name" => assigns.name,
      "form" => assigns.form
    }

    Map.reject(base, fn {_k, v} -> is_nil(v) end)
  end

  @spec input_sentinel(InputSentinel.t()) :: map()
  def input_sentinel(assigns) do
    base = %{
      "type" => "hidden",
      "name" => assigns.name,
      "form" => assigns.form,
      "value" => "",
      "id" => "#{zid(assigns.id)}:sentinel",
      "data-scope" => "file-upload",
      "data-part" => "hidden-input-sentinel",
      "data-corex-file-upload-sentinel" => ""
    }

    Map.reject(base, fn {_k, v} -> is_nil(v) end)
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "file-upload",
      "data-part" => "trigger",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "type" => "button",
      "id" => "#{zid(assigns.id)}:trigger"
    }
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "file-upload",
      "data-part" => "item-group",
      "data-file-type" => assigns.type,
      "data-type" => assigns.type,
      "id" => "#{zid(assigns.id)}:item-group:#{assigns.type}",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-disabled" => get_boolean(Map.get(assigns, :disabled, false))
    }
    |> Map.reject(fn {_k, v} -> is_nil(v) end)
  end
end
