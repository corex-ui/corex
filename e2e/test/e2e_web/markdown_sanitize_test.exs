defmodule E2eWeb.MarkdownSanitizeTest do
  use ExUnit.Case, async: true

  test "drops script tags from markdown HTML" do
    html = E2eWeb.Markdown.to_html!("Hello <script>alert(1)</script> world")
    refute html =~ "<script"
    assert html =~ "Hello"
    assert html =~ "world"
  end

  test "strips javascript: urls" do
    html = E2eWeb.Markdown.to_html!("[x](javascript:alert(1))")
    refute html =~ "javascript:"
  end
end
