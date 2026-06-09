defmodule Corex.CodeTest do
  use CorexTest.ComponentCase, async: true

  describe "code/1" do
    test "renders plain code" do
      result = render_component(&Corex.Code.code/1, code: "def hello, do: :world")
      assert [_] = find_in_html(result, ~S([data-scope="code"][data-part="root"]))
      assert [_] = find_in_html(result, ~S([data-part="content"]))
      assert [_] = find_in_html(result, "pre")
      assert [_] = find_in_html(result, "code")
    end

    test "renders code with elixir syntax highlighting" do
      result =
        render_component(&Corex.Code.code/1,
          code: "defmodule Hello do\n  def world, do: :ok\nend",
          language: :elixir
        )

      assert find_in_html(result, ~S([data-scope="code"])) != []
      assert result =~ ~S(<span class="kd">defmodule</span>)
    end

    test "escapes code when language has no lexer" do
      result =
        render_component(&Corex.Code.code/1,
          code: "<script>alert(1)</script>",
          language: :unknown
        )

      assert result =~ "&lt;script&gt;"
    end

    test "applies host sizing data attributes" do
      result =
        render_component(&Corex.Code.code/1,
          code: "def hello, do: :world",
          max_width: "none",
          max_height: "lg",
          width: "full"
        )

      assert result =~ ~S(code--max-w-none)
      assert result =~ ~S(code--max-h-lg)
      assert result =~ ~S(code--w-full)
    end

    test "highlights multiline heex with makeup output only" do
      result =
        render_component(&Corex.Code.code/1,
          code: "<.accordion\n  items={@items}\n/>",
          language: :heex
        )

      refute result =~ ~S(data-part="line")
      assert result =~ ~S(<span class="nf">.accordion</span>)
      assert result =~ ~S(<span class="w">&nbsp;&nbsp;</span><span class="na">items</span>)
    end

    test "preserve_makeup_whitespace converts whitespace-only w spans" do
      html = ~S(<span class="w">  </span><span class="na">items</span>)
      assert Corex.Code.preserve_makeup_whitespace(html) =~ ~S(<span class="w">&nbsp;&nbsp;</span>)
    end
  end
end
