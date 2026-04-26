defmodule Corex.New.Cli do
  @moduledoc false

  def elixir_version_check!(installer_version) do
    unless Version.match?(System.version(), "~> 1.17") do
      Mix.raise(
        "Corex v#{installer_version} requires at least Elixir v1.17\n " <>
          "You have #{System.version()}. Please update accordingly"
      )
    end
  end

  def validate_corex_flags!(opts) do
    if opts[:designex] && opts[:no_design] do
      Mix.raise("--designex requires design. Remove `--no-design` or disable `--designex`.")
    end

    case opts[:dev_corex] do
      nil ->
        :ok

      v when is_binary(v) ->
        if String.trim(v) == "" do
          Mix.raise("--dev_corex requires a non-empty path (for example: --dev_corex ../corex)")
        end

      _ ->
        :ok
    end

    if opts[:theme] && opts[:theme] != "" do
      themes =
        opts[:theme]
        |> String.split(":", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))

      valid = ["neo", "uno", "duo", "leo"]
      invalid = themes -- valid

      if invalid != [] do
        Mix.raise(
          "--theme must be colon-separated names from neo, uno, duo, leo. Got: #{inspect(invalid)}"
        )
      end
    end

    :ok
  end

  def validate_phx_new_flags!(opts) do
    forbidden =
      []
      |> then(fn acc -> if opts[:assets] == false, do: ["--no-assets" | acc], else: acc end)
      |> then(fn acc -> if opts[:esbuild] == false, do: ["--no-esbuild" | acc], else: acc end)
      |> then(fn acc -> if opts[:html] == false, do: ["--no-html" | acc], else: acc end)
      |> then(fn acc -> if opts[:ecto] == false, do: ["--no-ecto" | acc], else: acc end)
      |> then(fn acc ->
        design_on? = opts[:no_design] != true
        if design_on? and opts[:tailwind] == false, do: ["--no-tailwind" | acc], else: acc
      end)
      |> Enum.reverse()

    if forbidden != [] do
      Mix.raise("""
      Unsupported Phoenix generator flags: #{Enum.join(forbidden, ", ")}.

      Corex requires a standard Phoenix HTML/assets setup (esbuild + HTML) and requires Ecto in generated apps.
      If you need a highly customized Phoenix app, generate it first with `mix phx.new`, then run `mix igniter.install corex`.
      """)
    end

    :ok
  end

  def relative_to_cwd_hint(path) when is_binary(path) do
    case Path.relative_to_cwd(path) do
      {:error, _} -> path
      rel -> rel
    end
  end

  def confirm_install_path!(path) do
    if File.dir?(path) and
         not Mix.shell().yes?(
           "The directory #{path} already exists. Are you sure you want to continue?"
         ) do
      Mix.raise("Please select another directory for installation.")
    end
  end
end
