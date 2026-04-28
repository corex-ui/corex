defmodule Mix.Corex.Install.TemplatesTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Templates

  test "app_css_for_corex/1 uses theme in theme import path" do
    c = Templates.app_css_for_corex("uno")
    assert c =~ ~s(@import "../corex/theme/uno.css";)
    assert c =~ ~s(@import "../corex/main.css";)
    assert c =~ "corex:design-imports"
  end

  test "design_imports_block/0 loads design import snippet" do
    b = Templates.design_imports_block()
    assert b =~ "main.css"
    assert b =~ "typo.css"
  end
end
