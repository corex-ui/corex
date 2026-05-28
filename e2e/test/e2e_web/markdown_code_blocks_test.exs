defmodule E2eWeb.MarkdownCodeBlocksTest do
  use ExUnit.Case, async: true

  test "fenced javascript keeps line breaks in highlighted output" do
    body = """
    ```javascript
    import { Socket } from "phoenix"
    import { LiveSocket } from "phoenix_live_view"
    ```
    """

    html = E2eWeb.Markdown.to_html!(body)

    assert html =~ "phoenix"
    assert html =~ "phoenix_live_view"
    assert html =~ "<br"
    assert html =~ "import"
    assert html =~ "LiveSocket"
    assert html =~ ~r/import[\s\S]*Socket[\s\S]*<br\s*\/?>[\s\S]*import[\s\S]*LiveSocket/s
  end

  test "fenced heex uses HEEx lexer token classes" do
    body = """
    ```heex
    <.accordion id={@id}>
      <:trigger>{@label}</:trigger>
    </.accordion>
    ```
    """

    html = E2eWeb.Markdown.to_html!(body)

    assert html =~ "accordion"
    assert html =~ ~r/class="[^"]+"/
    refute html =~ ~r/<span class="">/
  end

  test "inline backticks use Corex code with inline attribute" do
    body = "Use `sdfsdf` and `<:item :let={item}>` in prose."

    html = E2eWeb.Markdown.to_html!(body)

    assert html =~ ~S(data-scope="code")
    assert html =~ ~S(data-part="root")
    assert html =~ "sdfsdf"
    assert html =~ ":item"
    refute html =~ "blog__inline-code"
  end

  test "inline HEEx keeps spaces between attributes" do
    body = "I typed `<.accordion id=\"faq\" items={@topics} />` and moved on."

    html = E2eWeb.Markdown.to_html!(body)

    nbsp = <<0x00A0::utf8>>
    assert html =~ ".accordion"
    assert html =~ ~s(<span class="w">#{nbsp}</span>)
    refute html =~ ".accordionid="
    refute html =~ ~s(<span class="w"></span>)
  end
end
