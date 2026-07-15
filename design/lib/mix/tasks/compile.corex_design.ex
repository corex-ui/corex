defmodule Mix.Tasks.Compile.CorexDesign do
  use Mix.Task.Compiler

  @shortdoc "Regenerates the Corex design bundle when config or the design package changes"

  @moduledoc """
  Advanced: rebuild Design CSS on `mix compile` when `:corex_design` is in `compilers`.

  Most apps instead run `mix corex.design.build` from `assets.build` / `assets.deploy`
  (see Corex Manual installation). Optional compilers setup:

      def project do
        [
          compilers: Mix.compilers() ++ [:corex_design],
          ...
        ]
      end

  On every `mix compile` the compiler hashes the resolved `config :corex_design`
  and the installed `corex_design` version. When that signature changes (or the
  output directory is missing) it re-runs the same pipeline as
  `mix corex.design.build`: config validation, the WCAG contrast gate, and bundle
  generation into the configured `output` directory. Otherwise it is a no-op.
  """

  @manifest "compile.corex_design"

  @impl true
  def run(_argv) do
    manifest = manifest_path()
    signature = current_signature()

    cond do
      not File.dir?(Corex.Design.output_path()) ->
        build!(manifest, signature)

      previous_signature(manifest) != signature ->
        build!(manifest, signature)

      true ->
        {:noop, []}
    end
  end

  @impl true
  def manifests, do: [manifest_path()]

  @impl true
  def clean do
    File.rm(manifest_path())
    :ok
  end

  defp build!(manifest, signature) do
    Corex.Design.Config.validate!()

    for warning <- Corex.Design.Tokens.Contrast.check!() do
      Mix.shell().info([
        :yellow,
        "warning: ",
        :reset,
        "corex_design contrast [#{warning.theme}/#{warning.mode}] #{warning.fg} on " <>
          "#{warning.bg}: #{Float.round(warning.ratio, 2)}:1 (target #{warning.target}:1)"
      ])
    end

    Corex.Design.compile(log: false)
    write_manifest(manifest, signature)
    Mix.shell().info("Regenerated Corex design bundle (config changed)")
    {:ok, []}
  rescue
    error in ArgumentError ->
      Mix.raise("corex_design compile failed: " <> Exception.message(error))
  end

  defp current_signature do
    config = Corex.Design.design_config()
    version = Application.spec(:corex_design, :vsn)
    :erlang.phash2({config, version})
  end

  defp previous_signature(manifest) do
    case File.read(manifest) do
      {:ok, contents} ->
        case Integer.parse(String.trim(contents)) do
          {value, _} -> value
          :error -> nil
        end

      _ ->
        nil
    end
  end

  defp write_manifest(manifest, signature) do
    File.mkdir_p!(Path.dirname(manifest))
    File.write!(manifest, Integer.to_string(signature))
  end

  defp manifest_path do
    Path.join(Mix.Project.manifest_path(), @manifest)
  end
end
