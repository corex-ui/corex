defmodule Corex.Design.Tokens.Contrast do
  @moduledoc false

  alias Corex.Design.Filter
  alias Corex.Design.Tokens.Colors

  @text_ratio 4.5
  @ui_ratio 3.0

  @doc """
  WCAG 2.x contrast ratio between two hex colors, delegated to the `color`
  package.
  """
  def ratio(fg_hex, bg_hex) when is_binary(fg_hex) and is_binary(bg_hex) do
    Color.Contrast.wcag_ratio(fg_hex, bg_hex)
  end

  @doc """
  Audits generated color tokens for every theme/mode and returns a list of
  violations. Each violation is a map with theme, mode, fg, bg, pair labels,
  achieved ratio, target ratio, and severity (`:error` for informational text
  pairs, `:warning` for WCAG-exempt disabled/muted pairs).
  """
  def audit(colors \\ Colors.generate()) do
    for {{theme, mode}, tokens} <- colors,
        pair <- pairs(mode),
        violation = check_pair(theme, mode, tokens, pair),
        violation != nil do
      violation
    end
  end

  @doc """
  Runs `audit/1` and raises when any `:error` severity violation is found.
  Warnings are returned for the caller to log.
  """
  def check!(colors \\ Colors.generate()) do
    violations = audit(colors)
    {errors, warnings} = Enum.split_with(violations, &(&1.severity == :error))

    if errors != [] do
      raise ArgumentError, "Corex design contrast check failed:\n\n" <> format(errors)
    end

    warnings
  end

  def format(violations) do
    Enum.map_join(violations, "\n", fn v ->
      "  [#{v.theme}/#{v.mode}] #{v.fg} on #{v.bg}: " <>
        "#{Float.round(v.ratio, 2)}:1 (need #{v.target}:1) -- #{v.label}"
    end)
  end

  defp check_pair(theme, mode, tokens, {fg_role, bg_role, target, severity, label}) do
    with {:ok, fg} <- fetch(tokens, fg_role),
         {:ok, bg} <- fetch(tokens, bg_role) do
      achieved = ratio(fg, bg)

      if achieved + 1.0e-4 < target do
        %{
          theme: theme,
          mode: mode,
          fg: "#{fg_role} (#{fg})",
          bg: "#{bg_role} (#{bg})",
          ratio: achieved,
          target: target,
          severity: severity,
          label: label
        }
      end
    else
      _ -> nil
    end
  end

  defp fetch(tokens, role), do: Map.fetch(tokens, role)

  defp pairs(_mode) do
    base_pairs() ++ role_pairs()
  end

  defp base_pairs do
    [
      {"ink", "root", @text_ratio, :error, "body text on page"},
      {"ink", "layer", @text_ratio, :error, "body text on raised surface"},
      {"ink-muted", "root", @text_ratio, :error, "muted text on page"},
      {"link", "root", @text_ratio, :error, "link text on page"},
      {"ink", "ui", @text_ratio, :error, "neutral control text"},
      {"ink", "ui-hover", @text_ratio, :error, "neutral control text (hover)"},
      {"ink", "ui-active", @text_ratio, :error, "neutral control text (active/open)"},
      {"ink-muted", "ui-muted", @ui_ratio, :warning, "disabled neutral control text"}
    ]
  end

  defp role_pairs do
    for role <- roles(), pair <- role_pair_specs(role) do
      pair
    end
  end

  defp role_pair_specs(role) do
    [
      {"#{role}-contrast", role, @text_ratio, :error, "#{role} solid text"},
      {"#{role}-contrast", "#{role}-hover", @text_ratio, :error, "#{role} solid text (hover)"},
      {"#{role}-contrast", "#{role}-active", @text_ratio, :error, "#{role} solid text (active)"},
      {"#{role}-text", "ui", @text_ratio, :error, "#{role} text on neutral control"},
      {"#{role}-contrast", "#{role}-muted", @ui_ratio, :warning, "#{role} disabled solid text"}
    ]
  end

  defp roles do
    Filter.semantics()
    |> Enum.map(&to_string/1)
    |> Enum.reject(&(&1 == "base"))
  end
end
