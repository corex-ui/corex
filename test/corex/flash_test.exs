defmodule Corex.FlashTest do
  use ExUnit.Case, async: true

  alias Corex.Flash
  alias Corex.Flash.{Error, Info}

  test "Flash module loads" do
    assert Code.ensure_loaded?(Flash)
    assert function_exported?(Info, :__struct__, 1)
    assert function_exported?(Error, :__struct__, 1)
  end

  test "Info struct" do
    info = %Info{title: "Saved", type: :success, duration: 5000}
    assert info.title == "Saved"
    assert info.type == :success
    assert info.duration == 5000
  end

  test "Error struct" do
    error = %Error{title: "Problem", type: :error, duration: :infinity}
    assert error.title == "Problem"
    assert error.duration == :infinity
  end
end
