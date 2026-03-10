defmodule Mix.Tasks.Corex.Gen.AuthTest do
  use ExUnit.Case

  alias Mix.Tasks.Corex.Gen.Auth

  test "run/1 raises on missing arguments" do
    assert_raise Mix.Error,
                 ~r/Invalid arguments\n\nmix corex.gen.auth expects a context module name/,
                 fn -> Auth.run(["Accounts"]) end
  end

  test "raise_with_help/1 raises Mix.Error" do
    assert_raise Mix.Error, ~r/my message/, fn ->
      Auth.raise_with_help("my message")
    end
  end
end
