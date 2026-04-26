defmodule Mix.Corex.Install.Options do
  @moduledoc false

  alias Mix.Corex.Install.ManualInstallHint

  def validate_opts!(opts) do
    if opts[:designex] == true and opts[:no_design] == true do
      Mix.raise(
        "--designex requires design. Remove `--no-design` or disable `--designex`." <>
          "\n\n" <> ManualInstallHint.hint()
      )
    end

    if t = opts[:theme] do
      themes = parse_colon_list(t)
      valid = ~w(neo uno duo leo)

      case themes -- valid do
        [] ->
          :ok

        bad ->
          Mix.raise(
            "--theme must use neo, uno, duo, leo. Got: #{inspect(bad)}" <>
              "\n\n" <> ManualInstallHint.hint()
          )
      end
    end

    :ok
  end

  def parse_colon_list(nil), do: []
  def parse_colon_list(""), do: []

  def parse_colon_list(s) when is_binary(s) do
    s |> String.split(":", trim: true) |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
  end

  def themes_from_opts(opts) do
    case opts[:theme] do
      nil -> []
      "" -> []
      s -> parse_colon_list(s)
    end
  end

  def design_on?(opts), do: opts[:no_design] != true
end
