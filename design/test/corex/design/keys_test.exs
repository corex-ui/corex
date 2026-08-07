defmodule Corex.Design.KeysTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Keys

  describe "get/3" do
    test "returns false when the atom key is present" do
      assert Keys.get(%{enabled: false}, :enabled, :MISSING) == false
    end

    test "returns false when the string key is present" do
      assert Keys.get(%{"enabled" => false}, :enabled, :MISSING) == false
    end

    test "returns nil when the key is present with nil" do
      assert Keys.get(%{x: nil}, :x, :MISSING) == nil
    end

    test "returns zero and empty string when present" do
      assert Keys.get(%{n: 0}, :n, :MISSING) == 0
      assert Keys.get(%{name: ""}, :name, :MISSING) == ""
    end

    test "returns default when the key is missing" do
      assert Keys.get(%{}, :enabled, :MISSING) == :MISSING
    end

    test "prefers the atom key over the string key" do
      map = Map.put(%{"enabled" => false}, :enabled, true)
      assert Keys.get(map, :enabled, :MISSING) == true
    end
  end
end
