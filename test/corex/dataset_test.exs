defmodule Corex.DatasetTest do
  use ExUnit.Case, async: true

  alias Corex.Dataset

  describe "bool_str/1" do
    test "encodes booleans" do
      assert Dataset.bool_str(true) == "true"
      assert Dataset.bool_str(false) == "false"
    end
  end

  describe "put_string/3" do
    test "skips nil" do
      assert Dataset.put_string(%{}, "k", nil) == %{}
    end

    test "puts string value" do
      assert Dataset.put_string(%{}, "k", 1) == %{"k" => "1"}
    end
  end

  describe "encode_json/1" do
    test "returns nil for nil" do
      assert Dataset.encode_json(nil) == nil
    end

    test "encodes map" do
      assert Dataset.encode_json(%{a: 1}) == "{\"a\":1}"
    end
  end
end
