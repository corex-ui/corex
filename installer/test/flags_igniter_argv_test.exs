defmodule Corex.New.FlagsIgniterArgvTest do
  use ExUnit.Case, async: true

  alias Corex.New.{Flags, IgniterArgv, PhxWrapper}

  test "phx_new_cli_opts drops keys that only go to igniter.install" do
    o =
      Flags.phx_new_cli_opts(
        mode: true,
        dev_corex: "/x",
        theme: "neo",
        umbrella: true,
        skills: false
      )

    refute Keyword.has_key?(o, :mode)
    refute Keyword.has_key?(o, :dev_corex)
    refute Keyword.has_key?(o, :theme)
    assert o[:umbrella] == true
    assert o[:skills] == false
  end

  test "build_phx_new_argv from phx-only opts never includes corex-style flags" do
    argv =
      [mode: true, theme: "neo", mcp: false, dev_corex: "/c"]
      |> Flags.phx_new_cli_opts()
      |> PhxWrapper.build_phx_new_with_args()

    s = Enum.join(argv, " ")
    refute String.contains?(s, "corex")
  end

  test "igniter argv uses --corex.* (Igniter group disambiguation)" do
    a =
      [mcp: false, skills: true, mode: true, theme: "neo:leo", replace: true, lang: true]
      |> Flags.igniter_install_opts()
      |> IgniterArgv.to_argv()
      |> Enum.join(" ")

    assert a =~ "corex.no-mcp"
    assert a =~ "corex.mode"
    assert a =~ "corex.theme"
    assert a =~ "corex.lang"
    assert a =~ "corex.replace"
  end

  test "igniter argv omits --corex.replace when :replace is false (e.g. --no-replace)" do
    argv =
      [replace: false, mode: true]
      |> Flags.igniter_install_opts()
      |> IgniterArgv.to_argv()

    refute "--corex.replace" in argv
    assert "--corex.mode" in argv
  end

  test "igniter argv --corex.no-design when :no_design is true" do
    argv = IgniterArgv.to_argv(Flags.igniter_install_opts(no_design: true, replace: true))
    assert "--corex.no-design" in argv
  end

  test "igniter argv includes --corex.no-design and --corex.no-mcp; dev_corex never in argv" do
    argv =
      IgniterArgv.to_argv(
        Flags.igniter_install_opts(
          dev_corex: "/tmp/corex",
          mcp: false,
          no_design: true
        )
      )

    assert "--corex.no-design" in argv
    assert "--corex.no-mcp" in argv
    refute Enum.any?(argv, &String.contains?(&1, "dev"))
    refute "dev_corex" in argv
  end

  test "Flags.igniter_install_opts defaults replace true and applies no_replace" do
    assert :replace in Keyword.keys(Flags.igniter_install_opts([]))
    assert Keyword.get(Flags.igniter_install_opts([]), :replace) == true

    assert Keyword.get(Flags.igniter_install_opts(no_replace: true), :replace) == false
  end
end
