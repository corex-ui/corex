defmodule Corex.TabsDirInspectTest do
  use CorexTest.ComponentCase, async: true

  test "renders without dir when nil" do
    html = render_component(&Corex.Tabs.tabs/1, %{
      id: "t",
      items: Corex.Content.new([%{label: "A", content: "B"}]),
      dir: nil
    })

    refute html =~ ~s(dir="ltr")
    refute html =~ ~s(dir="rtl")
    refute html =~ ~s(data-dir="ltr")
    refute html =~ ~s(data-dir="rtl")
  end
end
