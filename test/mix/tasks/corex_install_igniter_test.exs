defmodule Mix.Tasks.Corex.InstallIgniterTest do
  use ExUnit.Case, async: true

  test "igniter install task is composed for igniter.add_extension and group corex" do
    %Igniter.Mix.Task.Info{group: group, composes: composes, schema: schema} =
      Mix.Tasks.Corex.Install.info([], :igniter)

    assert group == :corex
    assert composes == ["igniter.add_extension"]
    assert Keyword.has_key?(schema, :replace)
    assert Keyword.has_key?(schema, :theme)
  end
end
