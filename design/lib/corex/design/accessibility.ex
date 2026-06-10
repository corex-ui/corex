defmodule Corex.Design.Accessibility.Level do
  @moduledoc false

  @levels ~w(a aa aaa)a

  def levels, do: @levels

  def normalize(level) when is_atom(level) do
    if level in @levels do
      level
    else
      raise ArgumentError,
            "accessibility level must be one of #{inspect(@levels)}, got: #{inspect(level)}"
    end
  end

  def normalize(level) when is_binary(level) do
    downcased = String.downcase(level)

    case Enum.find(@levels, fn l -> Atom.to_string(l) == downcased end) do
      nil ->
        raise ArgumentError,
              "accessibility level must be one of #{inspect(@levels)}, got: #{inspect(level)}"

      atom ->
        atom
    end
  end

  def normalize(nil), do: :aa

  def text_ratio(level) do
    case normalize(level) do
      :a -> 3.0
      :aa -> 4.5
      :aaa -> 7.0
    end
  end

  def non_text_ratio(_level), do: 3.0

  def non_text_generation_ratio(level) do
    non_text_ratio(level) + 0.05
  end

  def text_generation_ratio(level) do
    text_ratio(level) + 0.05
  end

  def text_contrast_target(level, preset_ratio) when is_number(preset_ratio) do
    preset = preset_ratio * 1.0
    floor = text_generation_ratio(level)

    case normalize(level) do
      :a -> min(preset, floor)
      _ -> max(preset, floor)
    end
  end

  def to_string(level), do: level |> normalize() |> Atom.to_string()
end

defmodule Corex.Design.Accessibility.CriteriaMap do
  @moduledoc false

  def references_for_ratio(ratio) when is_number(ratio) do
    sc = wcag_success_criteria(ratio)

    %{
      "wcag_sc" => sc,
      "en301549" => "9.2.1.3.2",
      "section508" => Enum.at(sc, 0, "WCAG2AA-1.4.3")
    }
  end

  defp wcag_success_criteria(ratio) when ratio >= 7.0, do: ["1.4.6", "1.4.3"]
  defp wcag_success_criteria(ratio) when ratio >= 4.5, do: ["1.4.3"]
  defp wcag_success_criteria(ratio) when ratio >= 3.0, do: ["1.4.3"]
  defp wcag_success_criteria(_), do: ["1.4.3"]
end

defmodule Corex.Design.Accessibility.ContrastReport do
  @moduledoc false

  alias Corex.Design.Accessibility.CriteriaMap
  alias Corex.Design.Accessibility.Level
  alias Corex.Design.Semantics
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors

  @cli_targets %{
    "aa" => %{text: 4.5, non_text: 3.0},
    "aa_large" => %{text: 3.0, non_text: 3.0},
    "aaa" => %{text: 7.0, non_text: 3.0}
  }

  def pairs do
    ink_surface =
      for bg <- ~w(root layer ui ui-hover ui-muted)a,
          fg <- ~w(ui-ink ui-ink-muted)a do
        {fg, bg, :text}
      end

    semantic_ink =
      for role <- Semantics.atoms(),
          fg = "ui-ink-#{role}",
          bg <- ~w(root)a do
        {fg, bg, :text}
      end

    semantic_solid =
      for role <- Semantics.atoms() do
        {Atom.to_string(role), "#{role}-ink", :text}
      end

    other = [
      {"link", "root", :text},
      {"border", "ui", :non_text_aesthetic},
      {"outline", "ui", :non_text_aesthetic}
    ]

    List.flatten([ink_surface, semantic_ink, semantic_solid, other])
    |> Enum.uniq_by(fn {fg, bg, _} -> {fg, bg} end)
  end

  def run(opts \\ []) do
    themes = themes_filter(opts)
    modes = modes_filter(opts)
    colors = Colors.generate()
    cli_target = Keyword.get(opts, :target)

    for {theme, mode} <- theme_mode_keys(colors, themes, modes) do
      map = Map.fetch!(colors, {theme, mode})
      level = Theme.accessibility_level(theme, mode)
      build_report(theme, mode, map, level, cli_target)
    end
  end

  defp theme_mode_keys(colors, themes, modes) do
    colors
    |> Map.keys()
    |> Enum.filter(fn {t, m} -> t in themes and m in modes end)
    |> Enum.sort()
  end

  defp themes_filter(opts) do
    case Keyword.get_values(opts, :theme) do
      [] ->
        Theme.theme_ids()

      ids ->
        ids |> Enum.flat_map(&List.wrap/1) |> Enum.map(&normalize_theme_id/1)
    end
  end

  defp modes_filter(opts) do
    case Keyword.get_values(opts, :mode) do
      [] ->
        Theme.modes()

      modes ->
        modes |> Enum.flat_map(&List.wrap/1) |> Enum.map(&normalize_mode/1)
    end
  end

  defp normalize_theme_id(id) when is_atom(id), do: id

  defp normalize_theme_id(id) when is_binary(id) do
    String.to_existing_atom(id)
  rescue
    ArgumentError -> String.to_atom(id)
  end

  defp normalize_mode(m) when is_atom(m), do: m

  defp normalize_mode(m) when is_binary(m) do
    String.to_existing_atom(m)
  rescue
    ArgumentError -> String.to_atom(m)
  end

  defp build_report(theme, mode, color_map, level, cli_target) do
    thresholds = thresholds_for(level, cli_target)

    rows =
      pairs()
      |> Enum.map(&evaluate_pair(&1, color_map, level, thresholds))
      |> Enum.reject(&is_nil/1)

    failures = Enum.filter(rows, &(!&1.passes_target))
    text_failures = Enum.filter(failures, &(&1.pair_kind == "text"))

    %{
      theme: Atom.to_string(theme),
      mode: Atom.to_string(mode),
      accessibility_level: Level.to_string(level),
      target: cli_target || Level.to_string(level),
      thresholds: %{
        text: thresholds.text,
        non_text: thresholds.non_text
      },
      generated_at: DateTime.utc_now() |> DateTime.to_iso8601(),
      pairs_total: length(rows),
      pairs_passing: length(rows) - length(failures),
      pairs_failing: length(failures),
      text_pairs_failing: length(text_failures),
      scope: "design_tokens_only",
      pairs: rows,
      failures: failures,
      text_failures: text_failures
    }
  end

  defp thresholds_for(level, nil) do
    %{text: Level.text_ratio(level), non_text: Level.non_text_ratio(level)}
  end

  defp thresholds_for(_level, cli) when is_binary(cli) do
    case Map.fetch(@cli_targets, cli) do
      {:ok, t} -> t
      :error -> raise ArgumentError, "unknown --target #{inspect(cli)}"
    end
  end

  defp evaluate_pair({fg, bg, :non_text_aesthetic}, color_map, level, _thresholds) do
    with fg_hex when is_binary(fg_hex) <- Map.get(color_map, fg),
         bg_hex when is_binary(bg_hex) <- Map.get(color_map, bg) do
      ratio = Float.round(Color.Contrast.wcag_ratio(fg_hex, bg_hex), 2)
      wcag_level = Color.Contrast.wcag_level(fg_hex, bg_hex) |> Atom.to_string()
      reference_threshold = Level.non_text_ratio(level)

      %{
        foreground: fg,
        background: bg,
        pair_kind: "non_text_aesthetic",
        fg_hex: fg_hex,
        bg_hex: bg_hex,
        wcag_ratio: ratio,
        wcag_level: wcag_level,
        threshold: reference_threshold,
        accessibility_level: Level.to_string(level),
        passes_target: true,
        references: CriteriaMap.references_for_ratio(ratio)
      }
    else
      _ -> nil
    end
  end

  defp evaluate_pair({fg, bg, kind}, color_map, level, thresholds) do
    threshold = Map.fetch!(thresholds, kind)

    with fg_hex when is_binary(fg_hex) <- Map.get(color_map, fg),
         bg_hex when is_binary(bg_hex) <- Map.get(color_map, bg) do
      ratio = Float.round(Color.Contrast.wcag_ratio(fg_hex, bg_hex), 2)
      wcag_level = Color.Contrast.wcag_level(fg_hex, bg_hex) |> Atom.to_string()

      %{
        foreground: fg,
        background: bg,
        pair_kind: Atom.to_string(kind),
        fg_hex: fg_hex,
        bg_hex: bg_hex,
        wcag_ratio: ratio,
        wcag_level: wcag_level,
        threshold: threshold,
        accessibility_level: Level.to_string(level),
        passes_target: ratio >= threshold,
        references: CriteriaMap.references_for_ratio(ratio)
      }
    else
      _ -> nil
    end
  end

  def strict_fail?(reports) do
    Enum.any?(reports, fn r -> r.text_pairs_failing > 0 end)
  end
end

defmodule Corex.Design.Accessibility.Report.JSON do
  @moduledoc false

  def encode!(report) do
    Jason.encode!(report, pretty: true)
  end

  def write!(report, path) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, encode!(report))
  end
end

defmodule Corex.Design.Accessibility.Report.Markdown do
  @moduledoc false

  def render(report) do
    [
      "# Design token contrast: #{report.theme} / #{report.mode}",
      "",
      "Scope: design token evidence only. Not a full product accessibility audit.",
      "",
      summary_table(report),
      "",
      failures_section(report),
      "",
      "## All pairs",
      "",
      pairs_table(report.pairs)
    ]
    |> Enum.join("\n")
  end

  def write!(report, path) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, render(report))
  end

  defp summary_table(report) do
    [
      "| Field | Value |",
      "| --- | --- |",
      "| Target | #{report.target} |",
      "| Generated | #{report.generated_at} |",
      "| Total pairs | #{report.pairs_total} |",
      "| Passing | #{report.pairs_passing} |",
      "| Failing | #{report.pairs_failing} |"
    ]
    |> Enum.join("\n")
  end

  defp failures_section(%{pairs_failing: 0}), do: "## Failures\n\nNone."

  defp failures_section(report) do
    (["## Failures", ""] ++ [pairs_table(report.failures)])
    |> Enum.join("\n")
  end

  defp pairs_table(rows) do
    header =
      "| Foreground | Background | Ratio | Level | Pass | FG | BG |\n| --- | --- | ---: | --- | --- | --- | --- |"

    body =
      Enum.map(rows, fn row ->
        pass = if row.passes_target, do: "yes", else: "no"

        "| #{row.foreground} | #{row.background} | #{row.wcag_ratio} | #{row.wcag_level} | #{pass} | #{row.fg_hex} | #{row.bg_hex} |"
      end)

    Enum.join([header | body], "\n")
  end
end
