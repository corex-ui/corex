defmodule Corex.Install.DesignCssStripTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Design

  @marker "/* corex:design-imports */"

  test "sync_corex_block preserves blank line before Add variants comment" do
    css = """
    @import "tailwindcss" source(none);
    @plugin "../vendor/heroicons";

    #{@marker}
    @import "dummy-between-markers";
    #{@marker}

    /* Add variants based on LiveView classes */
    @custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);
    """

    body = Design.design_imports_inner_body([])

    full_block =
      """
      #{@marker}
      #{body}
      #{@marker}
      """
      |> String.trim()

    out = Design.sync_corex_block(css, full_block)

    assert out =~ ~r/\n\n\/\*\s*Add variants based on LiveView classes/
  end

  test "design_imports_inner_body adds toggle-group import when --mode" do
    out = Design.design_imports_inner_body(mode: true)
    assert out =~ ~s(@import "../corex/components/toggle-group.css")
    refute out =~ ~s(@import "../corex/components/select.css")
  end

  test "design_imports_inner_body adds select import when --theme or --lang" do
    assert Design.design_imports_inner_body(theme: true) =~
             ~s(@import "../corex/components/select.css")

    assert Design.design_imports_inner_body(lang: true) =~
             ~s(@import "../corex/components/select.css")

    refute Design.design_imports_inner_body([]) =~ ~s(@import "../corex/components/select.css")
  end

  test "design_imports_inner_body adds both imports when mode and theme" do
    out = Design.design_imports_inner_body(mode: true, theme: true)
    assert out =~ ~s(toggle-group.css)
    assert out =~ ~s(select.css)
  end

  test "sample phx.new daisy stack + dark variant is stripped for Corex design patch shape" do
    css = """
    @import "tailwindcss" source(none);
    @plugin "../vendor/heroicons";

    /* daisyUI Tailwind Plugin. You can update this file */
    @plugin "../vendor/daisyui" {
      themes: false;
    }

    /* daisyUI theme plugin. */
    @plugin "../vendor/daisyui-theme" {
      name: "dark";
    }

    @plugin "../vendor/daisyui-theme" {
      name: "light";
    }

    /* Add variants based on LiveView classes */
    @custom-variant phx-click-loading (.phx-click-loading&, .phx-click-loading &);

    /* Use the data attribute for dark mode  */
    @custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));

    """

    cleaned = Design.strip_stock_css_before_corex_design(css)

    refute cleaned =~ "daisyui"
    refute cleaned =~ "daisyUI"
    assert cleaned =~ "data-mode=dark"
    refute cleaned =~ "data-theme=dark"
    assert cleaned =~ "phx-click-loading"
  end
end
