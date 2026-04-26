defmodule Mix.Corex.Install.Design do
  @moduledoc false

  alias Mix.Corex.Install.Templates

  def maybe_schedule_design(igniter, opts) do
    if opts[:no_design] do
      igniter
    else
      args =
        if opts[:designex] do
          ["--force", "--designex"]
        else
          ["--force"]
        end

      igniter
      |> patch_assets_app_css_for_corex_design()
      |> then(&delete_phx_daisyui_vendor_if_present/1)
      |> Igniter.add_task("corex.design", args)
    end
  end

  def delete_phx_daisyui_vendor_if_present(igniter) do
    for rel <- ["assets/vendor/daisyui.js", "assets/vendor/daisyui-theme.js"], reduce: igniter do
      acc ->
        p = Path.expand(rel)

        if file_exists_in_project_root?(p) do
          _ = File.rm(p)
        end

        acc
    end
  end

  def patch_assets_app_css_for_corex_design(igniter) do
    path = Path.join(["assets", "css", "app.css"])
    b = Templates.design_imports_block()

    igniter = Igniter.include_existing_file(igniter, path)

    if Igniter.exists?(igniter, path) do
      Igniter.update_file(igniter, path, fn source ->
        content = source.content
        content = strip_daisy_plugin_region_from_app_css(content)

        if design_css_imports_current?(content) do
          %{source | content: content}
        else
          c =
            if String.contains?(content, "corex:design-imports") do
              Regex.replace(
                ~r{/\* corex:design-imports \*/\s*(?:@import[^;]+;\s*)+}m,
                content,
                b <> "\n",
                global: false
              )
            else
              String.trim_trailing(content) <> "\n\n" <> b <> "\n"
            end

          %{source | content: c}
        end
      end)
    else
      msg =
        "Corex design was enabled but `assets/css/app.css` was not found. Add these imports:\n\n" <>
          String.replace(b, "/* corex:design-imports */", "") <> "\n"

      Igniter.add_notice(igniter, msg)
    end
  end

  def strip_daisy_plugin_region_from_app_css(content) do
    out =
      cond do
        String.contains?(content, "/* Add variants") ->
          Regex.replace(
            ~r/(?:\n|^)\/\* daisyUI Tailwind Plugin\..*?(?=\n\/\* Add variants)/s,
            content,
            "\n"
          )

        String.contains?(content, "@custom-variant phx-click-loading") ->
          Regex.replace(
            ~r/(?:\n|^)\/\* daisyUI.*?(?=\n@custom-variant phx-click-loading)/s,
            content,
            "\n"
          )

        true ->
          content
      end

    maybe_strip_daisyui_vendor_plugin_residue(out)
  end

  defp maybe_strip_daisyui_vendor_plugin_residue(content) do
    if String.contains?(content, "vendor/daisyui") and
         String.contains?(content, "@custom-variant phx-click-loading") and
         String.contains?(content, "/* daisyUI") do
      Regex.replace(
        ~r/(?:\n|^)\/\* daisyUI.*?(?=\n@custom-variant phx-click-loading)/s,
        content,
        "\n"
      )
    else
      content
    end
  end

  defp design_css_imports_current?(content) do
    String.contains?(content, "corex/components/typo.css") and
      String.contains?(content, "../corex/main.css") and
      String.contains?(content, "corex:design-imports")
  end

  defp file_exists_in_project_root?(p), do: File.exists?(p)
end
