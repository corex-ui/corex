defmodule Corex.MCP.Tools.Components do
  @moduledoc false

  alias Corex.MCP.ComponentDocs
  alias Corex.MCP.CorexAvailable
  alias Corex.MCP.Json
  alias Corex.MCP.Tools.Design

  @max_id_length 64
  @unknown_id_message "Unknown component id. Use list_components for valid ids."

  def tools do
    [
      %{
        name: "list_components",
        description:
          "List all Corex component ids from the package registry (atoms serialized as strings, e.g. accordion, date_picker).",
        inputSchema: %{
          type: "object",
          properties: %{}
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &list_components/1
      },
      %{
        name: "get_component",
        description: """
        Return the Elixir module, function components with attrs/slots when available, design modifiers when corex_design is loaded, optional markdown module docs, and source path.
        Pass id as from list_components (e.g. accordion, date_picker).
        """,
        inputSchema: %{
          type: "object",
          required: ["id"],
          properties: %{
            id: %{
              type: "string",
              description: "Component id, e.g. accordion or data_table"
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &get_component/1
      }
    ]
  end

  def list_components(%{} = args) when map_size(args) == 0 do
    with :ok <- CorexAvailable.ensure_corex() do
      ids = Enum.map(CorexAvailable.call(:component_ids), &to_string/1)
      {:ok, Json.encode!(%{components: ids})}
    end
  end

  def list_components(_), do: {:error, :invalid_arguments}

  def get_component(%{"id" => id} = args)
      when is_binary(id) and byte_size(id) <= @max_id_length and map_size(args) == 1 do
    with :ok <- CorexAvailable.ensure_corex(),
         {:ok, mod} <- CorexAvailable.call(:component_module_for_mcp_id, [id]),
         atom_id = String.to_existing_atom(id),
         {:ok, spec} <- CorexAvailable.call(:component_spec, [atom_id]) do
      primary = primary_function_meta(mod, atom_id)

      spec
      |> Map.put(:function_components, enrich_function_components(mod, spec.function_components))
      |> Map.put(:attrs, primary.attrs)
      |> Map.put(:slots, primary.slots)
      |> Map.merge(Design.design_enrichment(id))
      |> ComponentDocs.enrich(mod)
      |> Json.encode!()
      |> then(&{:ok, &1})
    else
      :error -> {:error, @unknown_id_message}
      {:error, _} = error -> error
    end
  end

  def get_component(_), do: {:error, :invalid_arguments}

  defp enrich_function_components(mod, function_components) do
    comps = component_meta(mod)

    Enum.map(function_components, fn %{name: name, arity: arity} ->
      meta = Map.get(comps, name, %{})

      %{
        name: name,
        arity: arity,
        attrs: serialize_attrs(Map.get(meta, :attrs, [])),
        slots: serialize_slots(Map.get(meta, :slots, []))
      }
    end)
  end

  defp primary_function_meta(mod, atom_id) do
    comps = component_meta(mod)
    meta = Map.get(comps, atom_id) || comps |> Map.values() |> List.first() || %{}

    %{
      attrs: serialize_attrs(meta_get(meta, :attrs, [])),
      slots: serialize_slots(meta_get(meta, :slots, []))
    }
  end

  defp component_meta(mod) do
    case Code.ensure_loaded(mod) do
      {:module, ^mod} ->
        if function_exported?(mod, :__components__, 0) do
          mod.__components__()
        else
          %{}
        end

      _ ->
        %{}
    end
  end

  defp serialize_attrs(attrs) when is_list(attrs) do
    Enum.map(attrs, fn attr ->
      %{
        name: attr_name(attr),
        type: attr_type(attr),
        required: meta_get(attr, :required, false),
        doc: meta_get(attr, :doc, nil),
        default: default_from_opts(meta_get(attr, :opts, []))
      }
    end)
  end

  defp serialize_attrs(_), do: []

  defp serialize_slots(slots) when is_list(slots) do
    Enum.map(slots, fn slot ->
      %{
        name: meta_get(slot, :name, nil),
        required: meta_get(slot, :required, false),
        doc: meta_get(slot, :doc, nil),
        attrs: serialize_attrs(meta_get(slot, :attrs, []))
      }
    end)
  end

  defp serialize_slots(_), do: []

  defp meta_get(%{} = map, key, default), do: Map.get(map, key, default)
  defp meta_get(_, _key, default), do: default

  defp attr_name(attr) when is_map(attr), do: Map.get(attr, :name)
  defp attr_name(_), do: nil

  defp attr_type(attr) when is_map(attr) do
    case Map.get(attr, :type) do
      type when is_atom(type) -> to_string(type)
      type when not is_nil(type) -> inspect(type)
      _ -> nil
    end
  end

  defp attr_type(_), do: nil

  defp default_from_opts(opts) when is_list(opts) do
    case Keyword.get(opts, :default) do
      nil -> nil
      value -> inspect(value)
    end
  end

  defp default_from_opts(_), do: nil
end
