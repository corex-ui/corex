defmodule Corex.New.PostGenerateTest do
  use ExUnit.Case, async: false

  import MixHelper

  alias Corex.New.PostGenerate

  setup do
    flush()
    :ok
  end

  describe "copy_cached_build/1" do
    test "is a no-op when COREX_NEW_CACHE_DIR is unset" do
      in_tmp(:no_cache, fn ->
        assert :ok == PostGenerate.copy_cached_build(File.cwd!())
      end)
    end

    test "copies cache contents when COREX_NEW_CACHE_DIR is set" do
      in_tmp(:with_cache, fn ->
        cache = Path.join(File.cwd!(), "cache")
        project = Path.join(File.cwd!(), "project")
        File.mkdir_p!(cache)
        File.mkdir_p!(project)
        File.write!(Path.join(cache, "marker.txt"), "cached\n")
        System.put_env("COREX_NEW_CACHE_DIR", cache)

        on_exit(fn -> System.delete_env("COREX_NEW_CACHE_DIR") end)

        PostGenerate.copy_cached_build(project)

        assert File.read!(Path.join(project, "marker.txt")) == "cached\n"
      end)
    end
  end

  describe "init_git/1" do
    test "is a no-op in a directory that's already a git repo" do
      in_tmp(:git_already, fn ->
        File.mkdir_p!(".git")
        assert :ok == (PostGenerate.init_git(File.cwd!()) || :ok)
      end)
    end

    test "skips git initialization when git is unavailable" do
      previous = System.get_env("PATH")

      try do
        System.put_env("PATH", "")
        path = Path.join(System.tmp_dir!(), "corex_new_no_git_#{:rand.uniform(999_999)}")
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
          path = Path.join(System.tmp_dir!(), "corex_new_git_#{:rand.uniform(999_999)}")
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

  describe "prompt_install/3" do
    test "prints next steps without running deps.get when install is false" do
      in_tmp(:prompt_no_install, fn ->
        PostGenerate.prompt_install(File.cwd!(), File.cwd!(),
          install: false,
          ecto: true,
          lang: false
        )

        output = shell_info_text()
        assert output =~ "mix deps.get"
        assert output =~ "mix phx.server"
      end)
    end

    test "prompts for install when the option is omitted" do
      in_tmp(:prompt_lazy, fn ->
        send(self(), {:mix_shell_input, :yes?, false})

        PostGenerate.prompt_install(File.cwd!(), File.cwd!(), ecto: false, lang: false)

        assert_received {:mix_shell, :yes?, ["\nFetch and install dependencies?"]}
      end)
    end

    test "runs deps.get when install is true" do
      in_tmp(:prompt_install, fn ->
        MixHelper.write_minimal_mix!()

        PostGenerate.prompt_install(File.cwd!(), File.cwd!(),
          install: true,
          ecto: false,
          lang: false
        )

        output = shell_info_text(200)
        assert output =~ "mix deps.get"
      end)
    end

    test "includes localize steps when lang is true" do
      in_tmp(:prompt_lang, fn ->
        PostGenerate.prompt_install(File.cwd!(), File.cwd!(),
          install: false,
          ecto: false,
          lang: true
        )

        output = shell_info_text()
        assert output =~ "mix localize.download_locales"
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
