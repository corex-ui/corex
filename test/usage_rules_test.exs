defmodule Corex.UsageRulesTest do
  use ExUnit.Case, async: true

  @repo_root Path.expand("..", __DIR__)

  test "usage rules author files exist" do
    assert File.exists?(Path.join(@repo_root, "usage-rules.md"))
    assert File.exists?(Path.join(@repo_root, "usage-rules/skills/corex/SKILL.md"))
  end

  test "hex package files list usage rules paths" do
    files = Mix.Project.config()[:package][:files]
    assert "usage-rules.md" in files

    assert Enum.any?(
             files,
             &String.ends_with?(&1, "usage-rules/skills/corex/SKILL.md")
           )
  end

  test "hex package files include lib and corex.install task is present on disk" do
    files = Mix.Project.config()[:package][:files]
    assert "lib" in files
    assert File.exists?(Path.join(@repo_root, "lib/mix/tasks/corex.install.ex"))
  end

  test "mix usage_rules.sync exits successfully" do
    assert {_, 0} =
             System.cmd(
               "mix",
               ["usage_rules.sync", "--yes"],
               cd: @repo_root,
               stderr_to_stdout: true
             )
  end
end
