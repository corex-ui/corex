defmodule Corex.GettextTest do
  use ExUnit.Case, async: false

  describe "backend/1" do
    test "returns nil when not configured" do
      Application.delete_env(:corex, :gettext_backend)
      assert Corex.Gettext.backend() == nil
    end
  end

  describe "gettext/2" do
    test "returns msg when backend is nil" do
      Application.delete_env(:corex, :gettext_backend)
      assert Corex.Gettext.gettext("Hello") == "Hello"
      assert Corex.Gettext.gettext("World", []) == "World"
    end

    test "translates when backend is configured" do
      Application.put_env(:corex, :gettext_backend, CorexTest.Gettext)
      assert Corex.Gettext.gettext("Hello") == "Hello"
      Application.delete_env(:corex, :gettext_backend)
    end
  end

  describe "translate_error/1" do
    test "returns msg when backend is nil" do
      Application.delete_env(:corex, :gettext_backend)
      assert Corex.Gettext.translate_error({"Error", []}) == "Error"
    end

    test "uses dngettext when count present and backend configured" do
      Application.put_env(:corex, :gettext_backend, CorexTest.Gettext)
      result = Corex.Gettext.translate_error({"1 file", [count: 2]})
      assert is_binary(result)
      Application.delete_env(:corex, :gettext_backend)
    end

    test "uses dgettext when count absent and backend configured" do
      Application.put_env(:corex, :gettext_backend, CorexTest.Gettext)
      result = Corex.Gettext.translate_error({"Invalid", []})
      assert result == "Invalid"
      Application.delete_env(:corex, :gettext_backend)
    end
  end
end
