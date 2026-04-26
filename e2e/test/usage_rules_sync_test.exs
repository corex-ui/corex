defmodule E2e.UsageRulesSyncTest do
  use ExUnit.Case, async: false

  @e2e_root Path.expand("..", __DIR__)

  setup do
    File.rm_rf(Path.join(@e2e_root, ".claude"))
    :ok
  end

  test "mix usage_rules.sync materializes corex package skill" do
    assert {_, 0} =
             System.cmd(
               "mix",
               ["usage_rules.sync", "--yes"],
               cd: @e2e_root,
               stderr_to_stdout: true
             )

    skill = Path.join([@e2e_root, ".claude", "skills", "corex", "SKILL.md"])
    assert File.exists?(skill)
    assert File.read!(skill) =~ "managed-by: usage-rules"
  end
end
