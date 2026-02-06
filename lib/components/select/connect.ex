defmodule Corex.Select.Connect do
  @moduledoc false
  alias Corex.Select.Anatomy.{Props, Root, Label, Control, Positioner, Content}

  import Corex.Helpers,
    only: [get_boolean: 1, validate_value!: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-collection" => Corex.Json.encode!(validate_collection!(assigns.collection)),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-placeholder" => assigns.placeholder,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-dir" => assigns.dir,
      "data-loop-focus" => get_boolean(assigns.loop_focus),
      "data-multiple" => get_boolean(assigns.multiple),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-read-only" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-bubble" => get_boolean(assigns.bubble),
      "data-positioning" =>
        if assigns.positioning do
          Corex.Json.encode!(assigns.positioning)
        else
          nil
        end
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "root"
      # "id" => "select:#{assigns.id}"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            # "id" => "select:#{assigns.id}",
            # "data-invalid" => get_boolean(assigns.invalid),
            # "data-readonly" => get_boolean(assigns.read_only)
          }
        )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "label"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            "dir" => assigns.dir,
            "id" => "select:#{assigns.id}:label",
            "data-required" => get_boolean(assigns.required),
            "data-disabled" => get_boolean(assigns.disabled),
            "data-invalid" => get_boolean(assigns.invalid),
            "data-readonly" => get_boolean(assigns.read_only)
          }
        )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "control"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            "dir" => assigns.dir,
            "id" => "select:#{assigns.id}:control",
            "data-disabled" => get_boolean(assigns.disabled),
            "data-invalid" => get_boolean(assigns.invalid)
          }
        )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "positioner"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            "dir" => assigns.dir,
            "style" => "display: none;",
            "id" => "select:#{assigns.id}:positioner"
          }
        )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    base = %{
      "data-scope" => "select",
      "data-part" => "content"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(
          base,
          %{
            "dir" => assigns.dir,
            "id" => "select:#{assigns.id}:content",
            "tabindex" => -1,
            "role" => "listbox",
            "hidden" => "true",
            "aria-labelledby" => "select:#{assigns.id}:label"
          }
        )
  end

  defp validate_collection!(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.Collection.Item{} = item ->
        item

      %{id: _, label: _} = map ->
        struct(Corex.Collection.Item, map)

      other ->
        raise ArgumentError, """
        <.select> items must be Corex.Collection.Item or maps with :id and :label.

        Got:
        #{inspect(other)}
        """
    end)
  end
end
