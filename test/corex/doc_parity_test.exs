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
    layout_heading
    box
    stack
    form
    h1
    badge
  )

  @layout_typography_components ~W(
    layout_heading
    box
    stack
    row
    grid
    container
    form
    h1
    h2
    p
    badge
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

  test "layout and typography anatomy sections resolve component sources" do
    results =
      DocParity.run(sections: [:anatomy], components: @layout_typography_components)

    missing_moduledoc =
      Enum.filter(results, &(&1.status == :missing_moduledoc))

    assert missing_moduledoc == [],
           "layout/typography moduledoc paths:\n#{DocParity.report(missing_moduledoc)}"
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
