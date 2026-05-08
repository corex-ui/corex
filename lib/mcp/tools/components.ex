# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit

defmodule Corex.MCP.Tools.Components do
  @moduledoc false

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
        Return the Elixir module, function component names/arity, optional markdown module docs, source path when known, and docs_note when docs are absent or non-markdown.
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

  def list_components(_args) do
    ids = for id <- Corex.component_ids(), do: to_string(id)
    {:ok, Corex.Json.encode!(%{"components" => ids})}
  end

  def get_component(%{"id" => id}) when is_binary(id) do
    case Corex.component_module_for_mcp_id(id) do
      {:ok, mod} ->
        {:ok, spec} = Corex.component_spec(String.to_existing_atom(id))
        payload = enrich_with_docs(spec, mod)
        {:ok, Corex.Json.encode!(payload)}

      :error ->
        {:error, "Unknown component id. Use list_components for valid ids."}
    end
  end

  def get_component(_), do: {:error, :invalid_arguments}

  defp enrich_with_docs(spec, mod) do
    case Code.fetch_docs(mod) do
      {:docs_v1, line, _beam_lang, format, doc_blob, meta, _} ->
        meta_map =
          case meta do
            %{} = m -> m
            _ -> %{}
          end

        source_path = resolve_source_path(meta_map, mod)

        case moduledoc_markdown(doc_blob, format, mod) do
          {:ok, docs} ->
            spec
            |> Map.put(:docs, docs)
            |> Map.put(:docs_note, nil)
            |> Map.put(:source_path, source_path)
            |> Map.put(:source_line, line)

          {:missing, note} ->
            spec
            |> Map.put(:docs, nil)
            |> Map.put(:docs_note, note)
            |> Map.put(:source_path, source_path)
            |> Map.put(:source_line, line)
        end

      _ ->
        spec
        |> Map.put(:docs, nil)
        |> Map.put(
          :docs_note,
          "Code.fetch_docs/1 returned no documentation bundle for this module."
        )
        |> Map.put(:source_path, nil)
        |> Map.put(:source_line, nil)
    end
  end

  defp resolve_source_path(meta, mod) do
    case source_path_from_meta(meta) do
      p when is_binary(p) and p != "" -> p
      _ -> compile_source_path(mod)
    end
  end

  defp source_path_from_meta(meta) when is_map(meta) do
    meta = Map.new(meta, fn {k, v} -> {to_string(k), v} end)
    normalize_source_path_string(Map.get(meta, "source_path"))
  end

  defp compile_source_path(mod) do
    with list when is_list(list) <- mod.module_info(:compile),
         src when not is_nil(src) <- Keyword.get(list, :source) do
      normalize_source_path_string(src)
    else
      _ -> nil
    end
  end

  defp normalize_source_path_string(p) when is_list(p), do: List.to_string(p)
  defp normalize_source_path_string(p) when is_binary(p), do: p
  defp normalize_source_path_string(_), do: nil

  defp moduledoc_markdown(%{"en" => content}, "text/markdown", mod)
       when is_binary(content) do
    {:ok, "# #{inspect(mod)}\n\n#{content}"}
  end

  defp moduledoc_markdown(%{"en" => content}, format, mod)
       when is_binary(content) do
    {:ok,
     "# #{inspect(mod)}\n\n#{content}" <>
       "\n\n_(documentation format: #{inspect(format)}, not text/markdown)_\n"}
  end

  defp moduledoc_markdown(:hidden, _format, _mod) do
    {:missing, "Module documentation is hidden (@moduledoc false)."}
  end

  defp moduledoc_markdown(:none, _format, _mod) do
    {:missing, "No module-level documentation."}
  end

  defp moduledoc_markdown(_, _format, _mod) do
    {:missing, "Module documentation format or shape is not recognized."}
  end
end
