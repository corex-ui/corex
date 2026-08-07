defmodule Corex.Design.ConfigTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Config

  describe "validate!/1" do
    test "accepts a config with no scale overrides" do
      assert :ok = Config.validate!(default_theme: :neo, default_mode: :light)
    end

    test "accepts scale overrides as a keyword list" do
      assert :ok = Config.validate!(scales: [radius: [md: 0.625]])
    end

    test "accepts density as a space alias" do
      assert :ok = Config.validate!(scales: [density: [md: 3]])
    end

    test "reports a scales value that is not a keyword list" do
      assert_raise ArgumentError, ~r/:scales option: expected keyword list/, fn ->
        Config.validate!(scales: %{radius: %{md: 0.625}})
      end
    end

    test "reports an unknown scale axis" do
      assert_raise ArgumentError, ~r/unknown axis/, fn ->
        Config.validate!(scales: [nope: [md: 1.0]])
      end
    end

    test "accepts accessibility false true and axis lists" do
      assert :ok = Config.validate!(accessibility: false)
      assert :ok = Config.validate!(accessibility: true)
      assert :ok = Config.validate!(accessibility: [:text, :motion])
    end

    test "reports invalid accessibility axes" do
      assert_raise ArgumentError, ~r/accessibility/, fn ->
        Config.validate!(accessibility: [:nope])
      end
    end

    test "reports invalid accessibility values" do
      assert_raise ArgumentError, ~r/accessibility/, fn ->
        Config.validate!(accessibility: "yes")
      end
    end
  end

  describe "resolved/1" do
    test "applies the theme and mode defaults" do
      resolved = Config.resolved([])

      assert resolved.default_theme == :uno
      assert resolved.default_mode == :light
      assert resolved.scales == []
    end

    test "reads scale overrides as given" do
      assert Config.resolved(scales: [radius: [md: 0.625]]).scales == [radius: [md: 0.625]]
    end

    test "reads an explicit nil scales as no overrides" do
      assert Config.resolved(scales: nil).scales == []
    end
  end
end
