defmodule Corex.MCP.Tools.Components do
  @moduledoc false

  alias Corex.MCP.ComponentDocs
  alias Corex.MCP.CorexAvailable
  alias Corex.MCP.Json
  alias Corex.MCP.ToolError
  alias Corex.MCP.Tools.Design

  @max_id_length 64

  @data_builders %{
    "accordion" => ["Corex.Content.new/1"],
    "tabs" => ["Corex.Content.new/1"],
    "data_list" => ["Corex.Content.new/1"],
    "select" => ["Corex.List.new/1"],
    "combobox" => ["Corex.List.new/1"],
    "listbox" => ["Corex.List.new/1"],
    "menu" => ["Corex.Tree.new/1"],
    "tree_view" => ["Corex.Tree.new/1"],
    "carousel" => ["Corex.Image.new/2"]
  }

  @api_name_prefixes ~w(set_ clear_ open close dismiss create update remove select_)

  def tools do
    [
      %{
        name: "list_components",
        description:
          "List all Corex component ids from the package registry (snake_case strings, e.g. accordion, date_picker). Includes form_capable ids and value models.",
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
        Return structured component metadata: module, hook, events, api, data_builders, form, attrs/slots, and design modifiers when corex_design is loaded.
        Pass id as snake_case (date_picker) or kebab-case (date-picker). Set include_docs true for full moduledoc (omitted by default).
        """,
        inputSchema: %{
          type: "object",
          required: ["id"],
          properties: %{
            id: %{
              type: "string",
              description: "Component id, e.g. accordion, date_picker, or date-picker"
            },
            include_docs: %{
              type: "boolean",
              description: "Include full module markdown docs (default false)."
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

      form_capable =
        ids
        |> Enum.map(&{&1, form_meta_for_id(&1)})
        |> Enum.filter(fn {_id, form} -> form.supports_field end)
        |> Enum.map(fn {id, form} -> Map.put(form, :id, id) end)

      {:ok,
       Json.encode!(%{
         components: ids,
         form_capable: form_capable
       })}
    end
  end

  def list_components(_), do: ToolError.invalid_arguments("list_components", "no arguments")

  def get_component(%{"id" => id} = args)
      when is_binary(id) and byte_size(id) <= @max_id_length do
    extra_keys = Map.keys(args) -- ["id", "include_docs"]

    cond do
      extra_keys != [] ->
        ToolError.invalid_arguments(
          "get_component",
          "required id; optional include_docs boolean"
        )

      true ->
        include_docs? = truthy?(Map.get(args, "include_docs", false))
        do_get_component(id, include_docs?)
    end
  end

  def get_component(_) do
    ToolError.invalid_arguments(
      "get_component",
      "required id: string of at most #{@max_id_length} bytes, e.g. accordion or date-picker"
    )
  end

  defp do_get_component(raw_id, include_docs?) do
    with :ok <- CorexAvailable.ensure_corex(),
         {:ok, snake_id} <- normalize_mcp_id(raw_id),
         {:ok, mod} <- CorexAvailable.call(:component_module_for_mcp_id, [snake_id]),
         atom_id = String.to_existing_atom(snake_id),
         {:ok, spec} <- CorexAvailable.call(:component_spec, [atom_id]) do
      primary = primary_function_meta(mod, atom_id)
      attrs = serialize_attrs(primary.attrs)
      slots = serialize_slots(primary.slots)

      payload =
        spec
        |> Map.put(:id, snake_id)
        |> Map.put(
          :function_components,
          enrich_function_components(mod, spec.function_components)
        )
        |> Map.put(:attrs, attrs)
        |> Map.put(:slots, slots)
        |> Map.put(:hook, hook_name(snake_id, mod))
        |> Map.put(:events, events_from_attrs(attrs))
        |> Map.put(:api, api_functions(mod))
        |> Map.put(:data_builders, Map.get(@data_builders, snake_id, []))
        |> Map.put(:form, form_from_attrs(attrs))
        |> Map.merge(Design.design_enrichment(snake_id))

      payload =
        if include_docs? do
          ComponentDocs.enrich(payload, mod)
        else
          payload
          |> Map.put(:docs, nil)
          |> Map.put(:docs_note, "Pass include_docs: true for full module documentation.")
          |> Map.merge(source_meta(mod))
        end

      {:ok, Json.encode!(payload)}
    else
      :error -> ToolError.unknown_id("get_component", raw_id, "list_components")
      {:error, _} = error -> error
    end
  end

  defp normalize_mcp_id(id) when is_binary(id) do
    snake = String.replace(id, "-", "_")
    allowed = MapSet.new(for a <- CorexAvailable.call(:component_ids), do: to_string(a))

    if MapSet.member?(allowed, snake) do
      {:ok, snake}
    else
      :error
    end
  end

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
      attrs: meta_get(meta, :attrs, []),
      slots: meta_get(meta, :slots, [])
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
    attrs
    |> Enum.reject(&hidden_attr?/1)
    |> Enum.map(fn attr ->
      %{
        name: attr_name(attr),
        type: attr_type(attr),
        required: meta_get(attr, :required, false),
        doc: meta_get(attr, :doc, nil),
        default: default_from_opts(meta_get(attr, :opts, [])),
        values: values_from_opts(meta_get(attr, :opts, []))
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

  defp hidden_attr?(attr) do
    meta_get(attr, :doc, true) == false
  end

  defp events_from_attrs(attrs) do
    server =
      for %{name: name} <- attrs,
          is_binary(name) or is_atom(name),
          name = to_string(name),
          String.starts_with?(name, "on_"),
          not String.ends_with?(name, "_client"),
          do: name

    client =
      for %{name: name} <- attrs,
          is_binary(name) or is_atom(name),
          name = to_string(name),
          String.ends_with?(name, "_client"),
          do: name

    %{server: Enum.sort(server), client: Enum.sort(client)}
  end

  defp form_from_attrs(attrs) do
    names = for %{name: n} <- attrs, do: to_string(n)
    supports? = "field" in names

    value_model =
      cond do
        "checked" in names -> "checked"
        "pressed" in names -> "pressed"
        "selected" in names -> "selected"
        "value" in names -> "value"
        true -> nil
      end

    %{supports_field: supports?, value_model: value_model}
  end

  defp form_meta_for_id(id) do
    with {:ok, mod} <- CorexAvailable.call(:component_module_for_mcp_id, [id]),
         atom_id = String.to_existing_atom(id),
         {:ok, _} <- CorexAvailable.call(:component_spec, [atom_id]) do
      primary = primary_function_meta(mod, atom_id)
      form_from_attrs(serialize_attrs(primary.attrs))
    else
      _ -> %{supports_field: false, value_model: nil}
    end
  end

  defp api_functions(mod) do
    case Code.ensure_loaded(mod) do
      {:module, ^mod} ->
        heex =
          if function_exported?(mod, :__components__, 0) do
            MapSet.new(Map.keys(mod.__components__()))
          else
            MapSet.new()
          end

        mod.__info__(:functions)
        |> Enum.filter(fn {name, arity} ->
          arity in 2..4 and not MapSet.member?(heex, name) and api_name?(name)
        end)
        |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
        |> Enum.map(fn {name, arities} ->
          %{name: to_string(name), arities: Enum.sort(arities)}
        end)
        |> Enum.sort_by(& &1.name)

      _ ->
        []
    end
  end

  defp api_name?(name) do
    s = Atom.to_string(name)
    Enum.any?(@api_name_prefixes, &String.starts_with?(s, &1))
  end

  defp hook_name(snake_id, _mod), do: Macro.camelize(snake_id)

  defp source_meta(mod) do
    enriched = ComponentDocs.enrich(%{}, mod)

    %{
      source_path: Map.get(enriched, :source_path),
      source_line: Map.get(enriched, :source_line)
    }
  end

  defp truthy?(true), do: true
  defp truthy?("true"), do: true
  defp truthy?(_), do: false

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

  defp values_from_opts(opts) when is_list(opts) do
    case Keyword.get(opts, :values) do
      values when is_list(values) -> Enum.map(values, &to_string/1)
      _ -> nil
    end
  end

  defp values_from_opts(_), do: nil
end
