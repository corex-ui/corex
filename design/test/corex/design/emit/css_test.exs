defmodule Corex.Design.Emit.CssTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Emit.Css

  doctest Corex.Design.Emit.Css

  defp flat(iodata), do: IO.iodata_to_binary(iodata)

  describe "declaration/2" do
    test "renders a number without the caller stringifying it" do
      assert flat(Css.declaration("theme-spacing", 0.25)) == "  --theme-spacing: 0.25;"
    end
  end

  describe "block/2" do
    test "joins declarations with newlines inside the selector" do
      assert flat(Css.block(".button", [Css.declaration("a", "1"), Css.declaration("b", "2")])) ==
               ".button {\n  --a: 1;\n  --b: 2;\n}\n"
    end
  end

  describe "theme_inline/1" do
    test "wraps declarations in the Tailwind entry point" do
      assert flat(Css.theme_inline([Css.forward("radius-md", "theme-radius-md")])) ==
               "@theme inline {\n  --radius-md: var(--theme-radius-md);\n}\n"
    end
  end

  describe "document/1" do
    test "prefixes the generated-file banner" do
      assert flat(Css.document(["body {}\n"])) ==
               "/**\n * Do not edit directly, this file was auto-generated.\n */\n\nbody {}\n"
    end
  end

  describe "imports/1" do
    test "terminates each import with a newline" do
      assert flat(Css.imports(["./main.css", "./theme/uno.css"])) ==
               ~s(@import "./main.css";\n@import "./theme/uno.css";\n)
    end

    test "renders nothing for no paths" do
      assert flat(Css.imports([])) == ""
    end
  end

  test "emitters return iodata rather than a flattened binary" do
    refute is_binary(Css.block(".a", [Css.declaration("b", "1")]))
  end
end
