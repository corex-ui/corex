defmodule Corex.CodeTest do
  use CorexTest.ComponentCase, async: true

  describe "code/1" do
    test "renders plain code" do
      result = render_component(&Corex.Code.code/1, code: "def hello, do: :world")
      assert [_] = find_in_html(result, ~s([data-scope="code"][data-part="root"]))
      assert [_] = find_in_html(result, ~s([data-part="content"]))
      assert [_] = find_in_html(result, "pre")
      assert [_] = find_in_html(result, "code")
    end

    test "renders code with elixir syntax highlighting" do
      result =
        render_component(&Corex.Code.code/1,
          code: "defmodule Hello do\n  def world, do: :ok\nend",
          language: :elixir
        )

      assert find_in_html(result, ~s([data-scope="code"])) != []
    end

    test "escapes code when language has no lexer" do
      result =
        render_component(&Corex.Code.code/1,
          code: "<script>alert(1)</script>",
          language: :unknown
        )

      assert result =~ "&lt;script&gt;"
    end
  end
end
