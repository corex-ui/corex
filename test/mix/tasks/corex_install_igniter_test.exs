defmodule Mix.Tasks.Corex.InstallIgniterTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Corex.Install, as: CorexInstall

  test "igniter install task is composed for igniter.add_extension and group corex" do
    %Igniter.Mix.Task.Info{group: group, composes: composes, schema: schema} =
      CorexInstall.info([], :igniter)

    assert group == :corex
    assert composes == ["igniter.add_extension"]
    assert Keyword.has_key?(schema, :theme)
    assert Keyword.has_key?(schema, :design)
    assert Keyword.has_key?(schema, :designex)
    assert Keyword.has_key?(schema, :mode)
    assert Keyword.has_key?(schema, :lang)
    assert Keyword.has_key?(schema, :mcp)
    refute Keyword.has_key?(schema, :replace)
  end
end
