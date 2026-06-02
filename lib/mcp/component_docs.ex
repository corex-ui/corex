defmodule Corex.MCP.ComponentDocs do
  @moduledoc false

  alias Corex.MCP

  def enrich(spec, mod) do
    case Code.fetch_docs(mod) do
      {:docs_v1, line, _beam_lang, format, doc_blob, meta, _} ->
        source_path = resolve_source_path(meta, mod)

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
      path when is_binary(path) and path != "" -> path
      _ -> compile_source_path(mod)
    end
  end

  defp source_path_from_meta(%{} = meta) do
    meta
    |> Map.new(fn {key, value} -> {to_string(key), value} end)
    |> Map.get("source_path")
    |> relative_source_path()
  end

  defp source_path_from_meta(_), do: nil

  defp compile_source_path(mod) do
    with list when is_list(list) <- mod.module_info(:compile),
         src when not is_nil(src) <- Keyword.get(list, :source) do
      relative_source_path(src)
    end
  end

  defp relative_source_path(path) when is_list(path),
    do: relative_source_path(List.to_string(path))

  defp relative_source_path(path) when is_binary(path) do
    abs = Path.expand(path)
    root = Path.expand(MCP.root())

    cond do
      abs == root -> "."
      String.starts_with?(abs, root <> "/") -> Path.relative_to(abs, root)
      true -> Path.basename(abs)
    end
  end

  defp relative_source_path(_), do: nil

  defp moduledoc_markdown(%{"en" => content}, "text/markdown", mod)
       when is_binary(content) do
    {:ok, "# #{inspect(mod)}\n\n#{content}"}
  end

  defp moduledoc_markdown(%{"en" => content}, format, mod) when is_binary(content) do
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
