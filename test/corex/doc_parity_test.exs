defmodule Corex.DocParityTest do
  use ExUnit.Case, async: true

  alias Corex.DocParity

  test "anatomy and form snippets match e2e demos for all components" do
    results = DocParity.run(sections: [:anatomy, :form])

    assert DocParity.failures(results) == [],
           DocParity.report(results)
  end

  test "registered snippets contain no ellipsis placeholders" do
    results = DocParity.run(sections: [:anatomy, :form])

    ellipsis =
      Enum.filter(results, &(&1.status == :ellipsis))

    assert ellipsis == [],
           "ellipsis in snippets:\n#{DocParity.report(ellipsis)}"
  end

  test "component Style docs prefer corex.css umbrella import" do
    results = DocParity.css_style_results()

    assert DocParity.failures(results) == [],
           DocParity.report(results)
  end

  @tag :parity_report
  test "print full parity report (mix test --only parity_report)" do
    results = DocParity.run()
    IO.puts(DocParity.report(results))
    assert DocParity.failures(results) == []
  end
end
