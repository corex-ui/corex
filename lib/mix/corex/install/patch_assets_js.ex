defmodule Mix.Corex.Install.PatchAssetsJs do
  @moduledoc false

  @parser Module.concat([:IgniterJs, :Parsers, :Javascript, :Parser])
  @corex_import_text "import corex from \"corex\"\n"

  @spec apply(String.t()) :: String.t()
  def apply(content) when is_binary(content) do
    if System.get_env("COREX_PATCH_ASSETS_JS_REGEX") in ~w(1 true) do
      apply_with_regex(content)
    else
      apply_igniter_or_regex(content)
    end
  end

  defp apply_igniter_or_regex(content) do
    if igniter_js_parser_available?() do
      case apply_with_igniter_js(content) do
        {:ok, out} -> out
        :error -> apply_with_regex(content)
      end
    else
      apply_with_regex(content)
    end
  end

  defp igniter_js_parser_available? do
    Code.ensure_loaded?(@parser)
  end

  defp apply_with_igniter_js(content) do
    with {:ok, c1} <- igniter_ensure_corex_import(content),
         {:ok, c2} <- igniter_ensure_corex_hooks(c1) do
      {:ok, c2}
    else
      :error -> :error
    end
  end

  defp igniter_ensure_corex_import(content) do
    p = @parser

    if corex_import_present_in_ast?(p, content) do
      {:ok, content}
    else
      case p.insert_imports(content, @corex_import_text, :content) do
        {:ok, :insert_imports, out} -> {:ok, out}
        _ -> :error
      end
    end
  end

  defp corex_import_present_in_ast?(p, content) do
    p.module_imported?(content, "import corex from \"corex\"", :content)
  end

  defp igniter_ensure_corex_hooks(content) do
    p = @parser

    if not colocated_install?(content) or hooks_object_has_corex_spread?(content) do
      {:ok, content}
    else
      case p.extend_hook_object(content, ["...corex"], :content) do
        {:ok, :extend_hook_object, out} -> {:ok, out}
        _ -> :error
      end
    end
  end

  defp colocated_install?(content) do
    String.contains?(content, "colocatedHooks")
  end

  defp apply_with_regex(content) do
    content
    |> maybe_add_corex_import()
    |> maybe_add_corex_hooks()
  end

  defp has_corex_import?(content) do
    Regex.match?(~r/^\s*import\s+corex\s+from\s+['"]corex['"]/m, content)
  end

  defp maybe_add_corex_import(content) do
    if has_corex_import?(content) do
      content
    else
      c = insert_corex_import_after_liveview(content)
      if c == content, do: insert_corex_import_after_phoenix_html(c), else: c
    end
  end

  defp insert_corex_import_after_liveview(content) do
    Regex.replace(
      ~r/^((?![\s]*\/\/)([\s]*import[^;\n]*\bLiveSocket\b[^;\n]*from\s*['"]phoenix_live_view['"][^\n]*\n))/m,
      content,
      "\\1import corex from \"corex\"\n"
    )
  end

  defp insert_corex_import_after_phoenix_html(content) do
    Regex.replace(
      ~r/^(import\s+['"]phoenix_html['"]\n)/m,
      content,
      "\\1import corex from \"corex\"\n"
    )
  end

  defp hooks_object_has_corex_spread?(content) do
    Regex.match?(~r/hooks:\s*\{[^}]*\.\.\.corex\b/um, content)
  end

  defp maybe_add_corex_hooks(content) do
    if hooks_object_has_corex_spread?(content) or not colocated_install?(content) do
      content
    else
      c = add_hooks_for_multiline_comma_spread(content)
      if c == content, do: add_hooks_for_tight_oneline_spread(c), else: c
    end
  end

  defp add_hooks_for_multiline_comma_spread(content) do
    Regex.replace(
      ~r/(hooks:\s*\{)(\s*)(\.\.\.colocatedHooks,)([\n\s]*)\}/um,
      content,
      "\\1\\2\\3 ...corex,\\4}",
      global: false
    )
  end

  defp add_hooks_for_tight_oneline_spread(content) do
    Regex.replace(
      ~r/(hooks:\s*\{\s*)(\.\.\.colocatedHooks)\s*\}/u,
      content,
      "\\1\\2, ...corex}"
    )
  end
end
