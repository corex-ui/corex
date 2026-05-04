defmodule Corex.New.CliTest do
  use ExUnit.Case, async: true

  alias Corex.New.Cli

  describe "validate_corex_flags!/1" do
    test "allows designex when design is true" do
      assert :ok == Cli.validate_corex_flags!(designex: true, design: true)
    end

    test "rejects designex when design is false" do
      assert_raise Mix.Error, fn ->
        Cli.validate_corex_flags!(designex: true, design: false)
      end
    end

    test "rejects empty --dev path" do
      assert_raise Mix.Error, fn ->
        Cli.validate_corex_flags!(dev: "   ")
      end
    end
  end

  describe "maybe_auto_enable_design/2" do
    test "enables design when mode is true and design unset" do
      opts = Cli.maybe_auto_enable_design([mode: true], notify: false)
      assert Keyword.fetch!(opts, :design) == true
    end

    test "does not enable design for lang only" do
      opts = Cli.maybe_auto_enable_design([lang: true], notify: false)
      refute Keyword.has_key?(opts, :design)
    end
  end

  describe "relative_to_cwd_hint/1" do
    test "returns path on relative_to error" do
      assert "/abs/outside" == Cli.relative_to_cwd_hint("/abs/outside")
    end
  end
end
