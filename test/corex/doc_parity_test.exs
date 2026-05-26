defmodule Corex.DocParityTest do
  use ExUnit.Case, async: true

  alias Corex.DocParity

  @parity_components ~W(
    checkbox
    switch
    select
    combobox
    accordion
    tabs
    dialog
    action
    navigate
  )

  test "anatomy minimal snippets match e2e demo code for core components" do
    results =
      DocParity.run(sections: [:anatomy], components: @parity_components)

    failures =
      results
      |> DocParity.failures()
      |> Enum.filter(fn r -> String.contains?(r.section, "minimal") end)

    assert failures == [],
           DocParity.report(results)
  end

  test "registered snippets contain no ellipsis placeholders" do
    results = DocParity.run(sections: [:anatomy, :form], components: @parity_components)

    ellipsis =
      Enum.filter(results, &(&1.status == :ellipsis))

    assert ellipsis == [],
           "ellipsis in snippets:\n#{DocParity.report(ellipsis)}"
  end

  @tag :parity_report
  test "print full parity report (mix test --only parity_report)" do
    results = DocParity.run()
    IO.puts(DocParity.report(results))
    assert DocParity.failures(results) == []
  end
end
