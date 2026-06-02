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
    if opts[:designex] && opts[:design] == false do
      Mix.raise("--designex requires design. Remove `--no-design` or disable `--designex`.")
    end

    if opts[:mode] == true and opts[:design] == false do
      Mix.raise(
        "--mode requires design. Remove `--no-design` (design will auto-enable for `--mode`)."
      )
    end

    if opts[:theme] == true and opts[:design] == false do
      Mix.raise(
        "--theme requires design. Remove `--no-design` (design will auto-enable for `--theme`)."
      )
    end

    case opts[:dev] do
      nil ->
        :ok

      v when is_binary(v) ->
        trimmed = String.trim(v)

        if trimmed == "" do
          Mix.raise("--dev requires a non-empty path (for example: --dev ../corex)")
        else
          validate_dev_path!(trimmed)
        end

      _ ->
        :ok
    end

    :ok
  end

  @doc """
  Auto-enable `--design` when `--mode`, `--theme`, or `--designex` is set
  (matching the install task behavior). `--lang` does **not** auto-enable design.
  Prints a one-line notice unless `notify: false` is passed.
  """
  def maybe_auto_enable_design(opts, notify_opts \\ []) when is_list(opts) do
    notify? = Keyword.get(notify_opts, :notify, true)
    needs_design? = opts[:mode] == true or opts[:theme] == true or opts[:designex] == true

    cond do
      not needs_design? ->
        opts

      Keyword.get(opts, :design) == true ->
        opts

      Keyword.get(opts, :design) == false and needs_design? ->
        opts

      true ->
        if notify? do
          Mix.shell().info(
            "* Corex: enabling --design because --mode/--theme/--designex was set; pass --no-design to opt out."
          )
        end

        Keyword.put(opts, :design, true)
    end
  end

  def validate_phx_new_flags!(opts) do
    forbidden =
      []
      |> then(fn acc -> if opts[:ecto] == false, do: ["--no-ecto" | acc], else: acc end)
      |> then(fn acc ->
        if opts[:lang] == true and opts[:gettext] == false,
          do: ["--no-gettext" | acc],
          else: acc
      end)
      |> Enum.reverse()

    if forbidden != [] do
      Mix.raise("""
      Unsupported Phoenix generator flags: #{Enum.join(forbidden, ", ")}.

      Corex requires Ecto in generated apps. `--lang` requires Phoenix Gettext (cannot use `--no-gettext`).
      If you need a highly customized Phoenix app, generate it first with `mix phx.new`, then follow `guides/manual_installation.md`.
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

  def validate_dev_path!(path) when is_binary(path) do
    if String.match?(path, ~r/["\r\n\x00]/) do
      Mix.raise("""
      --dev path contains invalid characters.

      Provide a filesystem path without quotes or newlines.
      """)
    end

    :ok
  end
end
