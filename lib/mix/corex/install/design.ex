defmodule Mix.Corex.Install.Design do
  @moduledoc false

  alias Mix.Corex.Install.{Config, Templates}

  @marker "/* corex:design-imports */"

  def maybe_schedule_design(igniter, opts) do
    if Config.design_on?(opts) do
      args = if opts[:designex], do: ["--designex"], else: []

      igniter
      |> then(&delete_phx_daisyui_vendor_if_present/1)
      |> Igniter.add_task("corex.design", args)
    else
      igniter
    end
  end

  def delete_phx_daisyui_vendor_if_present(igniter) do
    for rel <- ["assets/vendor/daisyui.js", "assets/vendor/daisyui-theme.js"], reduce: igniter do
      acc ->
        p = Path.expand(rel)

        if File.exists?(p) do
          File.rm(p)
        end

        acc
    end
  end

  def patch_assets_app_css_for_corex_design(igniter, _opts) do
    path = Path.join(["assets", "css", "app.css"])

    body =
      Templates.design_imports_block()
      |> String.replace("__THEME__", "neo")
      |> String.replace(@marker, "")
      |> String.trim()

    block = wrapped_block(body)

    igniter
    |> Igniter.update_file(path, fn source ->
      css = Rewrite.Source.get(source, :content)
      updated = sync_corex_block(css, block)
      Rewrite.Source.update(source, :content, updated)
    end)
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

  defp sync_corex_block(css, full_block) do
    esc = Regex.escape(@marker)
    pair_re = ~r/[\s\n]*#{esc}[\s\n]*[\s\S]*?[\s\n]*#{esc}[\s\n]*/m

    cleaned =
      css
      |> then(&Regex.replace(pair_re, &1, "\n", global: true))
      |> String.replace(@marker, "", global: true)
      |> String.replace(~r/\n{3,}/, "\n\n", global: true)
      |> String.trim()

    inject_block(cleaned, full_block)
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
