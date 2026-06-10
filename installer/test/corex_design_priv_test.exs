defmodule Corex.New.CorexDesignPrivTest do
  use ExUnit.Case, async: true

  test "installer/priv/corex_design does not exist" do
    refute File.exists?(Path.expand("../priv/corex_design", __DIR__))
  end
end
