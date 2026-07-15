defmodule Corex.UrlTest do
  use ExUnit.Case, async: true

  alias Corex.Url

  describe "allowed_href?/1" do
    test "allows relative paths and http(s)" do
      assert Url.allowed_href?("/items")
      assert Url.allowed_href?("./relative")
      assert Url.allowed_href?("?page=2")
      assert Url.allowed_href?("https://example.com/path")
      assert Url.allowed_href?("http://localhost:4000")
    end

    test "rejects empty, protocol-relative, and dangerous schemes" do
      refute Url.allowed_href?("")
      refute Url.allowed_href?("   ")
      refute Url.allowed_href?("//evil.example")
      refute Url.allowed_href?("javascript:alert(1)")
      refute Url.allowed_href?("data:text/html,hi")
      refute Url.allowed_href?("vbscript:msgbox")
    end

    test "rejects non-string input" do
      refute Url.allowed_href?(nil)
      refute Url.allowed_href?(123)
    end
  end

  describe "put_data_to/2" do
    test "puts data-to when href is allowed" do
      assert Url.put_data_to(%{"id" => "x"}, "/items") == %{"id" => "x", "data-to" => "/items"}
    end

    test "leaves map unchanged when href is disallowed" do
      assert Url.put_data_to(%{"id" => "x"}, "javascript:alert(1)") == %{"id" => "x"}
      assert Url.put_data_to(%{"id" => "x"}, nil) == %{"id" => "x"}
    end
  end
end
