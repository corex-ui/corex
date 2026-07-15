defmodule Corex.New.Tableau.PostGenerateTest do
  use ExUnit.Case, async: false

  import Corex.New.MixHelper

  alias Corex.New.Tableau.PostGenerate

  setup do
    flush()
    :ok
  end

  describe "init_git/1" do
    test "is a no-op in a directory that's already a git repo" do
      in_tmp("tableau git already", fn ->
        File.mkdir_p!(".git")
        assert :ok == (PostGenerate.init_git(File.cwd!()) || :ok)
      end)
    end

    test "skips git initialization when git is unavailable" do
      previous = System.get_env("PATH")

      try do
        System.put_env("PATH", "")
        path = Path.join(System.tmp_dir!(), "corex_tableau_no_git_#{:rand.uniform(999_999)}")
        File.mkdir_p!(path)

        PostGenerate.init_git(path)
        refute File.exists?(Path.join(path, ".git"))
      after
        if previous, do: System.put_env("PATH", previous), else: System.delete_env("PATH")
      end
    end

    test "initializes git outside the corex checkout" do
      case System.find_executable("git") do
        nil ->
          :ok

        _git ->
          path = Path.join(System.tmp_dir!(), "corex_tableau_git_#{:rand.uniform(999_999)}")
          File.rm_rf!(path)
          File.mkdir_p!(path)

          try do
            PostGenerate.init_git(path)
            assert File.dir?(Path.join(path, ".git"))
          after
            File.rm_rf!(path)
          end
      end
    end
  end

  describe "prompt_install/2" do
    test "prints next steps without running deps.get when install is false" do
      in_tmp("tableau prompt no install", fn ->
        PostGenerate.prompt_install(File.cwd!(), install: false, design: true)

        output = shell_info_text()
        assert output =~ "mix deps.get"
        assert output =~ "mix corex.design.build"
        assert output =~ "mix setup"
        assert output =~ "mix assets.build"
        assert output =~ "mix tableau.server"
        assert output =~ "mix build"
      end)
    end

    test "omits design.build when design is false and install is false" do
      in_tmp("tableau prompt no design", fn ->
        PostGenerate.prompt_install(File.cwd!(), install: false, design: false)

        output = shell_info_text()
        assert output =~ "mix deps.get"
        refute output =~ "mix corex.design.build"
        assert output =~ "mix tableau.server"
      end)
    end

    test "prompts for install when the option is omitted" do
      in_tmp("tableau prompt lazy", fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        PostGenerate.prompt_install(File.cwd!(), design: true)

        assert_received {:mix_shell, :yes?, ["\nFetch and install dependencies?"]}
      end)
    end
  end

  describe "run/2" do
    test "init_git and next steps with install false" do
      in_tmp("tableau post generate run", fn ->
        File.mkdir_p!(".git")

        PostGenerate.run(File.cwd!(), install: false, design: true)

        output = shell_info_text()
        assert output =~ "mix deps.get"
        assert output =~ "mix tableau.server"
      end)
    end

    test "next steps include localize.download_locales when lang is true" do
      in_tmp("tableau post generate lang", fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        PostGenerate.run(File.cwd!(), lang: true, design: true, install: false)

        output = shell_info_text()
        assert output =~ "mix localize.download_locales en fr ar"
        assert output =~ "mix setup"
        assert output =~ "mix tableau.server"
      end)
    end

    test "next steps omit localize when lang is false" do
      in_tmp("tableau post generate no lang", fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        PostGenerate.run(File.cwd!(), lang: false, design: true, install: false)

        output = shell_info_text()
        refute output =~ "localize.download_locales"
      end)
    end
  end

  defp shell_info_text(timeout \\ 50) do
    timeout
    |> shell_info_parts([])
    |> Enum.join("\n")
  end

  defp shell_info_parts(timeout, acc) do
    receive do
      {:mix_shell, :info, [msg]} when is_binary(msg) ->
        shell_info_parts(timeout, [msg | acc])

      {:mix_shell, :info, _} ->
        shell_info_parts(timeout, acc)

      _ ->
        shell_info_parts(timeout, acc)
    after
      timeout -> acc
    end
  end
end
