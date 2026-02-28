defmodule Corex.IgniterTest do
  use ExUnit.Case, async: true

  @moduletag :requires_igniter

  describe "validate_opts!/1" do
    @tag :requires_igniter
    test "accepts valid theme" do
      Corex.Igniter.validate_opts!(theme: "neo:uno")
    end

    test "raises when theme has fewer than 2 values" do
      assert_raise Mix.Error, ~r/--theme requires at least 2 values/, fn ->
        Corex.Igniter.validate_opts!(theme: "neo")
      end
    end

    @tag :requires_igniter
    @tag :requires_igniter
    test "accepts valid languages" do
      Corex.Igniter.validate_opts!(languages: "en:fr:ar")
    end

    test "raises when languages has fewer than 2 values" do
      assert_raise Mix.Error, ~r/--languages requires at least 2 values/, fn ->
        Corex.Igniter.validate_opts!(languages: "en")
      end
    end

    @tag :requires_igniter
    @tag :requires_igniter
    test "accepts empty opts" do
      Corex.Igniter.validate_opts!([])
    end
  end
end
