defmodule Corex.SelectorsTest do
  use ExUnit.Case, async: true

  alias Corex.Selectors

  test "css_id/1 prefixes hash and escapes special characters" do
    assert Selectors.css_id("my-id") == "#my-id"
    assert Selectors.css_id("1start") == "#\\31 start"
    assert Selectors.css_id("a.b") == "#a\\.b"
  end
end
