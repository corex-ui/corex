defmodule Mix.Corex.Install.Build do
  @moduledoc false

  alias Mix.Corex.Install.PatchAssetsJs

  def patch_esbuild_config(igniter, _app) do
    path = "config/config.exs"

    Igniter.update_file(igniter, path, fn source ->
      content = source.content
      patched = Mix.Corex.Install.EsbuildFlags.insert_into_config(content)

      if patched == content and String.contains?(content, "config :esbuild") and
           not String.contains?(content, "--format=esm") do
        {:warning,
         "Could not add esbuild ESM flags automatically. Ensure your esbuild args include `--format=esm --splitting` so dynamic `import()` works."}
      else
        %{source | content: patched}
      end
    end)
  end

  def patch_assets_js(igniter) do
    path = "assets/js/app.js"
    igniter = Igniter.include_existing_file(igniter, path)

    Igniter.update_file(igniter, path, fn source ->
      content = source.content
      patched = PatchAssetsJs.apply(content)

      if patched == content and
           not Regex.match?(~r/^\s*import\s+corex\s+from\s+['"]corex['"]/m, content) do
        {:notice,
         "Could not patch `assets/js/app.js` automatically. Add:\n\nimport corex from \"corex\"\n\nand ensure your LiveSocket hooks include `...corex`."}
      else
        %{source | content: patched}
      end
    end)
  end
end
