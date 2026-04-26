defmodule Corex.Install.MixProjectUsageRulesTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.MixProjectUsageRules

  @phx_18_sample ~S"""
  defmodule Phxtest.MixProject do
    use Mix.Project

    def project do
      [
        app: :phxtest,
        version: "0.1.0",
        elixir: "~> 1.15",
        elixirc_paths: elixirc_paths(Mix.env()),
        start_permanent: Mix.env() == :prod,
        aliases: aliases(),
        deps: deps(),
        compilers: [:phoenix_live_view] ++ Mix.compilers()
      ]
    end

    defp elixirc_paths(_), do: ["lib"]

    defp deps do
      [
        {:phoenix, "~> 1.8.5"},
        {:bandit, "~> 1.5"}
      ]
    end

    defp aliases do
      [setup: ["deps.get"]]
    end
  end
  """

  test "adds usage_rules to project, inserts defp, idempotent" do
    out = MixProjectUsageRules.apply(@phx_18_sample)
    assert out =~ "usage_rules: usage_rules(),"
    assert out =~ "defp usage_rules do"
    assert out =~ ~s{location: ".claude/skills"}
    assert out =~ "package_skills: [:corex]"
    assert MixProjectUsageRules.apply(out) == out
  end
end
