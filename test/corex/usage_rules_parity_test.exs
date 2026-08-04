defmodule Corex.UsageRulesParityTest do
  use ExUnit.Case, async: true

  @root Path.expand("../..", __DIR__)
  @installation_skill Path.join(@root, "usage-rules/skills/corex-installation/SKILL.md")
  @components_skill Path.join(@root, "usage-rules/skills/corex-components/SKILL.md")
  @components_rule Path.join(@root, "usage-rules/components.md")

  @expected_builders %{
    "Corex.Content.new/1" => ~W(accordion tabs data_list),
    "Corex.List.new/1" => ~W(select combobox listbox),
    "Corex.Tree.new/1" => ~W(menu tree_view)
  }

  test "installation skill pins corex ~> 0.2" do
    body = File.read!(@installation_skill)
    assert body =~ ~r/\{\:corex,\s*"~>\s*0\.2/
    refute body =~ ~r/\{\:corex,\s*"~>\s*0\.1/
    assert body =~ "mix corex.design.build"
    refute body =~ ~r/mix corex\.design\b(?!\.)/
  end

  test "components skill and rule builder maps match library contract" do
    for path <- [@components_skill, @components_rule] do
      body = File.read!(path)

      for {builder, ids} <- @expected_builders do
        assert body =~ builder, "#{path} missing #{builder}"

        line =
          body
          |> String.split("\n")
          |> Enum.find(&String.contains?(&1, builder))

        assert line, "#{path} has no table row for #{builder}"

        for id <- ids do
          assert String.contains?(line, id),
                 "#{path} #{builder} row missing #{id}: #{line}"
        end

        refute String.contains?(line, "tree-view"),
               "#{path} must use snake_case MCP id tree_view, not tree-view"

        refute String.contains?(line, "data-list"),
               "#{path} must use snake_case MCP id data_list, not data-list"
      end

      refute body =~ ~r/Corex\.List\.new\/1\s*\|\s*.*menu/,
             "#{path} must not list menu under Corex.List"
    end
  end

  test "Content moduledoc lists DataList with Accordion and Tabs" do
    content = File.read!(Path.join(@root, "lib/corex/content.ex"))
    assert content =~ "Corex.DataList.html"
    assert content =~ "Corex.Accordion.html"
    assert content =~ "Corex.Tabs.html"
  end
end
