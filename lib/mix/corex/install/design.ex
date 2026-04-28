defmodule Mix.Corex.Install.Design do
  @moduledoc false

  alias Mix.Corex.Install.{Config, Templates}

  @import_toggle_group ~s(@import "../corex/components/toggle-group.css";)
  @import_select ~s(@import "../corex/components/select.css";)

  @marker "/* corex:design-imports */"

  @design_target_root "assets/corex"

  def add_design_files(igniter, opts) do
    if Config.design_on?(opts) do
      igniter
      |> delete_phx_daisyui_vendor_if_present()
      |> copy_design_files(opts)
    else
      igniter
    end
  end

  def delete_phx_daisyui_vendor_if_present(igniter) do
    for rel <- ["assets/vendor/daisyui.js", "assets/vendor/daisyui-theme.js"], reduce: igniter do
      acc ->
        if File.exists?(Path.expand(rel)) do
          Igniter.rm(acc, rel)
        else
          acc
        end
    end
  end

  defp copy_design_files(igniter, opts) do
    designex? = Keyword.get(opts, :designex, false)

    case design_source_root() do
      nil ->
        igniter

      source_root ->
        sources = list_design_sources(source_root, designex?)

        Enum.reduce(sources, igniter, &copy_design_source_into_igniter/2)
    end
  end

  defp copy_design_source_into_igniter({abs_source, rel_target}, acc) do
    case File.read(abs_source) do
      {:ok, contents} ->
        Igniter.create_new_file(acc, rel_target, contents, on_exists: :skip)

      _ ->
        acc
    end
  end

  defp design_source_root do
    case :code.priv_dir(:corex) do
      {:error, _} ->
        nil

      priv ->
        candidate = Path.join(priv, "design")
        if File.dir?(candidate), do: candidate, else: nil
    end
  end

  defp list_design_sources(source_root, designex?) do
    source_root
    |> Path.join("**")
    |> Path.wildcard(match_dot: false)
    |> Enum.filter(&File.regular?/1)
    |> Enum.reject(fn abs ->
      not designex? and inside_design_tokens_dir?(abs, source_root)
    end)
    |> Enum.map(fn abs ->
      rel = Path.relative_to(abs, source_root)
      {abs, Path.join(@design_target_root, rel)}
    end)
  end

  defp inside_design_tokens_dir?(abs_path, source_root) do
    rel = Path.relative_to(abs_path, source_root)
    parts = Path.split(rel)
    match?(["design" | _], parts)
  end

  def strip_stock_css_before_corex_design(css) when is_binary(css) do
    strip_stock_tailwind_daisy_before_corex(css)
  end

  def patch_assets_app_css_for_corex_design(igniter, opts) do
    path = Path.join(["assets", "css", "app.css"])

    igniter
    |> Igniter.update_file(path, fn source ->
      css = Rewrite.Source.get(source, :content)
      updated = sync_corex_block(css, opts)
      Rewrite.Source.update(source, :content, updated)
    end)
  end

  def design_imports_inner_body(opts) when is_list(opts) do
    themes = Config.themes_from_opts(opts)
    i18n? = Keyword.get(opts, :lang, false)

    base =
      Templates.design_imports_block()
      |> String.replace("__THEME__", "neo")
      |> String.replace(@marker, "")
      |> String.trim()

    extras =
      []
      |> then(fn acc ->
        if opts[:mode] == true, do: acc ++ [@import_toggle_group], else: acc
      end)
      |> then(fn acc ->
        if i18n? or themes != [], do: acc ++ [@import_select], else: acc
      end)

    case extras do
      [] ->
        base

      lines ->
        base <> "\n" <> Enum.join(lines, "\n")
    end
  end

  defp wrapped_block(body) do
    body = String.trim(body)

    """
    #{@marker}
    #{body}
    #{@marker}
    """
    |> String.trim()
  end

  def sync_corex_block(css, opts) when is_list(opts) do
    esc = Regex.escape(@marker)
    pair_re = ~r/#{esc}[\s\S]*?#{esc}/m

    old_components =
      case Regex.run(pair_re, css) do
        [region | _] -> extract_component_import_lines(region)
        _ -> []
      end

    merged_body = merge_design_imports_inner_body(opts, old_components)
    full_block = wrapped_block(merged_body)

    cleaned =
      css
      |> strip_stock_css_before_corex_design()
      |> then(&Regex.replace(pair_re, &1, "", global: true))
      |> String.replace(@marker, "", global: true)
      |> String.replace(~r/\n{3,}/, "\n\n", global: true)
      |> String.trim()

    inject_block(cleaned, full_block)
  end

  defp merge_design_imports_inner_body(opts, old_component_lines) when is_list(opts) do
    fresh = design_imports_inner_body(opts)
    fresh_lines = String.split(fresh, "\n")

    fresh_base_lines =
      Enum.reject(fresh_lines, &component_import_line?/1)

    fresh_components = Enum.filter(fresh_lines, &component_import_line?/1)

    merged_components =
      (old_component_lines ++ fresh_components)
      |> Enum.uniq()
      |> sort_component_import_lines()

    fresh_base = fresh_base_lines |> Enum.join("\n") |> String.trim()

    case merged_components do
      [] -> fresh_base
      cs -> fresh_base <> "\n" <> Enum.join(cs, "\n")
    end
  end

  defp extract_component_import_lines(region) when is_binary(region) do
    region
    |> String.split("\n")
    |> Enum.filter(&component_import_line?/1)
  end

  defp component_import_line?(line) do
    t = String.trim(line)
    String.starts_with?(t, "@import") and String.contains?(t, "corex/components/")
  end

  defp sort_component_import_lines(lines) do
    trimmed = Enum.map(lines, &String.trim/1)
    order = [@import_toggle_group, @import_select]

    ranked = Enum.filter(order, &(&1 in trimmed))

    rest =
      trimmed
      |> Enum.reject(&(&1 in order))
      |> Enum.sort()

    ranked ++ rest
  end

  defp strip_stock_tailwind_daisy_before_corex(css) do
    css
    |> strip_daisy_tailwind_plugin_comment_section()
    |> repeatedly_strip_vendor_plugin(~s(@plugin "../vendor/daisyui"))
    |> repeatedly_strip_vendor_plugin(~s(@plugin "../vendor/daisyui-theme"))
    |> repeatedly_strip_vendor_plugin(~s(@plugin '../vendor/daisyui'))
    |> repeatedly_strip_vendor_plugin(~s(@plugin '../vendor/daisyui-theme'))
    |> rewrite_dark_variant_to_data_mode()
  end

  defp strip_daisy_tailwind_plugin_comment_section(css) do
    re =
      ~r/\r?\n\/\*\s*daisyUI Tailwind Plugin[\s\S]*?(?=\r?\n\/\*\s*Add variants based on LiveView classes)/

    case Regex.replace(re, css, "", global: false) do
      ^css -> css
      out -> out
    end
  end

  defp repeatedly_strip_vendor_plugin(css, needle) do
    case strip_braced_at_plugin(css, needle) do
      ^css -> css
      next -> repeatedly_strip_vendor_plugin(next, needle)
    end
  end

  defp strip_braced_at_plugin(css, needle) do
    case :binary.match(css, needle) do
      {start, len} ->
        after_needle = binary_part(css, start + len, byte_size(css) - start - len)

        case String.trim_leading(after_needle) do
          "{" <> tail ->
            rest_after_block = skip_balanced_braces(tail, 1)
            binary_part(css, 0, start) <> String.trim_leading(rest_after_block)

          _ ->
            css
        end

      :nomatch ->
        css
    end
  end

  defp skip_balanced_braces(<<?{, rest::binary>>, depth) do
    skip_balanced_braces(rest, depth + 1)
  end

  defp skip_balanced_braces(<<?}, rest::binary>>, 1) do
    rest
  end

  defp skip_balanced_braces(<<?}, rest::binary>>, depth) when depth > 1 do
    skip_balanced_braces(rest, depth - 1)
  end

  defp skip_balanced_braces(<<_byte, rest::binary>>, depth) do
    skip_balanced_braces(rest, depth)
  end

  defp skip_balanced_braces(<<>>, _depth), do: ""

  defp rewrite_dark_variant_to_data_mode(css) do
    css
    |> String.replace(
      "@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));",
      "@custom-variant dark (&:where([data-mode=dark], [data-mode=dark] *));"
    )
    |> String.replace(
      "@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *))",
      "@custom-variant dark (&:where([data-mode=dark], [data-mode=dark] *))"
    )
  end

  defp inject_block(css, full_block) do
    c =
      Regex.replace(
        ~r/(@plugin\s+["'][^"']*vendor\/heroicons[^"']*["'][^\n]*\n)/m,
        css,
        "\\1\n#{full_block}\n",
        global: false
      )

    c =
      if c == css do
        Regex.replace(
          ~r/(@import\s+["']tailwindcss["'][^\n]*\n)/m,
          c,
          "\\1\n#{full_block}\n",
          global: false
        )
      else
        c
      end

    if c == css do
      String.trim_trailing(c) <> "\n\n" <> full_block <> "\n"
    else
      c
    end
  end
end
