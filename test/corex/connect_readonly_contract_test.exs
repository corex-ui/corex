defmodule Corex.ConnectReadonlyContractTest do
  use ExUnit.Case, async: true

  test "hook connect modules do not emit data-read-only on props" do
    root = Path.expand("../../lib/components", __DIR__)

    for path <- Path.wildcard(Path.join(root, "**/connect.ex")) do
      content = File.read!(path)

      if content =~ "def props" do
        refute content =~ ~S("data-read-only"),
               "#{path} must use data-readonly, not data-read-only"
      end
    end
  end
end
