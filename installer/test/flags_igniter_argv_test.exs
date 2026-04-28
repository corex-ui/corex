defmodule Corex.New.FlagsIgniterArgvTest do
  use ExUnit.Case, async: true

  alias Corex.New.{Flags, IgniterArgv, PhxWrapper}

  test "phx_new_cli_opts drops keys that only go to igniter.install" do
    o =
      Flags.phx_new_cli_opts(
        mode: true,
        dev_corex: "/x",
        theme: true,
        umbrella: true
      )

    refute Keyword.has_key?(o, :mode)
    refute Keyword.has_key?(o, :dev_corex)
    refute Keyword.has_key?(o, :theme)
    assert o[:umbrella] == true
  end

  test "build_phx_new_argv from phx-only opts never includes corex-style flags" do
    argv =
      [mode: true, theme: true, mcp: false, dev_corex: "/c"]
      |> Flags.phx_new_cli_opts()
      |> PhxWrapper.build_phx_new_with_args()

    s = Enum.join(argv, " ")
    refute String.contains?(s, "corex")
  end

  test "igniter argv uses --corex.* (Igniter group disambiguation)" do
    a =
      [mcp: false, mode: true, theme: true, lang: true]
      |> Flags.igniter_install_opts()
      |> IgniterArgv.to_argv()
      |> Enum.join(" ")

    assert a =~ "corex.no-mcp"
    assert a =~ "corex.mode"
    assert a =~ "corex.theme"
    assert a =~ "corex.lang"
    refute a =~ "corex.replace"
  end

  test "igniter argv --corex.no-design when :design is false" do
    argv = IgniterArgv.to_argv(Flags.igniter_install_opts(design: false))
    assert "--corex.no-design" in argv
  end

  test "igniter argv includes --corex.no-design and --corex.no-mcp; dev_corex never in argv" do
    argv =
      IgniterArgv.to_argv(
        Flags.igniter_install_opts(
          dev_corex: "/tmp/corex",
          mcp: false,
          design: false
        )
      )

    assert "--corex.no-design" in argv
    assert "--corex.no-mcp" in argv
    refute Enum.any?(argv, &String.contains?(&1, "dev"))
    refute "dev_corex" in argv
  end

  test "Flags.igniter_install_opts no longer includes :replace" do
    refute :replace in Keyword.keys(Flags.igniter_install_opts([]))
    refute :replace in Keyword.keys(Flags.igniter_install_opts(mode: true, design: false))
  end
end
