defmodule Corex.New.Cli do
  @moduledoc false

  @elixir_requirement "~> 1.17"

  # Flags that need the live `corex_design` dep / multi-theme CSS — not the static neo/light export.
  @design_dependent_flags [:mode, :theme, :a11y]

  # Flags that auto-enable `--design` when design is unset (includes lang for Design chrome).
  @design_auto_enable_flags [:mode, :theme, :lang, :a11y]

  def elixir_version_check!(installer_version) do
    unless Version.match?(System.version(), @elixir_requirement) do
      Mix.raise(
        "Corex v#{installer_version} requires Elixir #{@elixir_requirement}\n " <>
          "You have #{System.version()}. Please update accordingly"
      )
    end
  end

  def validate_corex_flags!(opts) do
    Enum.each(@design_dependent_flags, &validate_design_flag!(opts, &1))
    validate_dev_flag!(opts[:dev])
    :ok
  end

  defp validate_design_flag!(opts, flag) do
    case {opts[flag], opts[:design]} do
      {true, false} ->
        Mix.raise(
          "--#{flag} requires design. Remove `--no-design` (design will auto-enable for `--#{flag}`)."
        )

      _other ->
        :ok
    end
  end

  defp validate_dev_flag!(nil), do: :ok

  defp validate_dev_flag!(path) when is_binary(path) do
    case String.trim(path) do
      "" -> Mix.raise("--dev requires a non-empty path (for example: --dev ../corex)")
      trimmed -> validate_dev_path!(trimmed)
    end
  end

  defp validate_dev_flag!(_path), do: :ok

  @doc """
  Auto-enable `--design` when `--mode`, `--theme`, `--lang`, or `--a11y` is set
  and design was not explicitly chosen. Explicit `--no-design` is respected for
  `--lang`; `--mode` / `--theme` / `--a11y` still conflict via `validate_corex_flags!/1`.
  Prints a one-line notice unless `notify: false` is passed.
  """
  def maybe_auto_enable_design(opts, notify_opts \\ []) when is_list(opts) do
    enable_design(opts, needs_design?(opts), Keyword.get(opts, :design), notify_opts)
  end

  defp needs_design?(opts), do: Enum.any?(@design_auto_enable_flags, &(opts[&1] == true))

  defp enable_design(opts, false, _design, _notify_opts), do: opts
  defp enable_design(opts, true, design, _notify_opts) when is_boolean(design), do: opts

  defp enable_design(opts, true, _design, notify_opts) do
    notify_auto_design(Keyword.get(notify_opts, :notify, true))
    Keyword.put(opts, :design, true)
  end

  defp notify_auto_design(true) do
    Mix.shell().info(
      "* Corex: enabling --design because --mode/--theme/--lang/--a11y was set; pass --no-design to opt out (not valid with --mode/--theme/--a11y)."
    )
  end

  defp notify_auto_design(_notify), do: :ok

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
    Path.relative_to_cwd(path)
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
