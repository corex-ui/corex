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

    test "ignores non-string dev values" do
      assert :ok == Cli.validate_corex_flags!(dev: 123)
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

    test "returns a relative path when inside cwd" do
      Corex.New.MixHelper.in_tmp("relative hint", fn ->
        File.mkdir_p!("nested")
        assert "nested" == Cli.relative_to_cwd_hint("nested")
      end)
    end
  end

  describe "validate_phx_new_flags!/1" do
    test "rejects --no-ecto" do
      assert_raise Mix.Error, ~r/--no-ecto/, fn ->
        Cli.validate_phx_new_flags!(ecto: false)
      end
    end

    test "rejects --no-gettext with --lang" do
      assert_raise Mix.Error, ~r/--no-gettext/, fn ->
        Cli.validate_phx_new_flags!(lang: true, gettext: false)
      end
    end
  end

  describe "validate_corex_flags!/1 extra branches" do
    test "rejects mode without design when design is explicitly false" do
      assert_raise Mix.Error, ~r/--mode requires design/, fn ->
        Cli.validate_corex_flags!(mode: true, design: false)
      end
    end

    test "rejects theme without design when design is explicitly false" do
      assert_raise Mix.Error, ~r/--theme requires design/, fn ->
        Cli.validate_corex_flags!(theme: true, design: false)
      end
    end
  end

  describe "maybe_auto_enable_design notifications" do
    test "notifies and enables design for designex" do
      opts = Cli.maybe_auto_enable_design(designex: true)
      assert Keyword.fetch!(opts, :design) == true

      assert_received {:mix_shell, :info,
                       [
                         "* Corex: enabling --design because --mode/--theme/--designex was set; pass --no-design to opt out."
                       ]}
    end

    test "leaves opts unchanged when design is explicitly false and mode is set" do
      opts = Cli.maybe_auto_enable_design([mode: true, design: false], notify: false)
      assert opts[:design] == false
    end
  end

  describe "confirm_install_path!/1" do
    test "continues when user accepts an existing directory" do
      Corex.New.MixHelper.in_tmp("confirm accept", fn ->
        File.mkdir_p!("exists")
        send(self(), {:mix_shell_input, :yes?, true})

        Cli.confirm_install_path!(Path.expand("exists"))
      end)
    end

    test "raises when user declines an existing directory" do
      Corex.New.MixHelper.in_tmp("confirm decline", fn ->
        File.mkdir_p!("exists")
        send(self(), {:mix_shell_input, :yes?, false})

        assert_raise Mix.Error, ~r/Please select another directory/, fn ->
          Cli.confirm_install_path!(Path.expand("exists"))
        end
      end)
    end
  end
end
