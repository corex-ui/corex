defmodule E2eWeb.DocAuthoringTest do
  use ExUnit.Case, async: true

  alias E2eWeb.DocAuthoring

  test "disable_markup_on_page? for style paths and ids" do
    assert DocAuthoring.disable_markup_on_page?(path: "/accordion/style")
    assert DocAuthoring.disable_markup_on_page?(id: "accordion-style-page")
    assert DocAuthoring.disable_markup_on_page?(path: "/action/style")
    assert DocAuthoring.disable_markup_on_page?(id: "action-style-page")
    refute DocAuthoring.disable_markup_on_page?(path: "/accordion/anatomy")
    refute DocAuthoring.disable_markup_on_page?(id: "accordion-anatomy-page")
    refute DocAuthoring.disable_markup_on_page?(path: "/action/anatomy")
    refute DocAuthoring.disable_markup_on_page?(id: "action-anatomy-page")
  end
end
