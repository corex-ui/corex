defmodule Corex.Design.Accessibility.ContrastReportTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Accessibility.ContrastReport
  alias Corex.Design.Accessibility.Report.JSON
  alias Corex.Design.Accessibility.Report.Markdown

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> restore_env(original) end)
    CorexDesign.TestConfig.put([])
    :ok
  end

  defp restore_env(env), do: CorexDesign.TestConfig.restore(env)

  test "builds report for neo light with pair rows" do
    [report] =
      ContrastReport.run(theme: "neo", mode: "light")

    assert report.theme == "neo"
    assert report.mode == "light"
    assert report.pairs_total > 0
    assert is_binary(JSON.encode!(report))
    assert Markdown.render(report) =~ "design token"
  end

  test "strict_fail? only when text pairs fail" do
    reports = [%{text_pairs_failing: 1}]
    assert ContrastReport.strict_fail?(reports)
    refute ContrastReport.strict_fail?([%{text_pairs_failing: 0}])
  end
end
