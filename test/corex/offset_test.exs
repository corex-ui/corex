defmodule Corex.OffsetTest do
  use ExUnit.Case, async: true

  alias Corex.Offset

  test "defaults" do
    assert %Offset{} == %Offset{main_axis: nil, cross_axis: nil}
  end

  test "custom axes" do
    assert %Offset{main_axis: 4, cross_axis: -2}.main_axis == 4
  end

  test "module exposes struct" do
    assert %{main_axis: nil, cross_axis: nil} = struct(Offset)
  end
end
