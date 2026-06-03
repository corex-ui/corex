defmodule Corex.Design.Accessibility.ContrastReportStrictTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Accessibility.ContrastReport
  alias Corex.Design.Tokens.Colors

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> restore_env(original) end)
    CorexDesign.TestConfig.put([])
    :ok
  end

  defp restore_env(env), do: CorexDesign.TestConfig.restore(env)

  test "built-in presets pass text pairs at aa without --target" do
    reports = ContrastReport.run()
    assert length(reports) == 8
    refute ContrastReport.strict_fail?(reports)

    for report <- reports do
      assert report.accessibility_level == "aa"
      assert report.target == "aa"
      assert report.thresholds.text == 4.5
      assert report.text_pairs_failing == 0,
             "#{report.theme} #{report.mode} text failures: #{inspect(report.text_failures)}"
    end
  end

  test "border and outline pairs are non_text_aesthetic and never fail strict" do
    [report | _] = ContrastReport.run(theme: :neo, mode: :light)

    for fg <- ["border", "outline"] do
      pair = Enum.find(report.pairs, &(&1.foreground == fg and &1.background == "ui"))
      assert pair.pair_kind == "non_text_aesthetic"
      assert pair.passes_target
      assert pair.wcag_ratio < 3.0
    end

    refute ContrastReport.strict_fail?([report])
  end

  test "global :a lowers ink contrast versus :aa for the same preset" do
    aa = ink_on_root_ratio([])
    a = ink_on_root_ratio(accessibility_level: :a)
    assert a < aa
    assert a >= 3.0
    assert a <= 3.2

    reports = ContrastReport.run()
    refute ContrastReport.strict_fail?(reports)
  end

  defp ink_on_root_ratio(config) do
    CorexDesign.TestConfig.put(config)
    colors = Colors.generate()
    ink = colors[{:neo, :light}]["ui-ink"]
    root = colors[{:neo, :light}]["root"]
    Float.round(Color.Contrast.wcag_ratio(ink, root), 2)
  end
end
