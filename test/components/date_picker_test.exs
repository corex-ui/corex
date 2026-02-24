defmodule Corex.DatePickerTest do
  use ExUnit.Case, async: true

  alias Corex.DatePicker

  describe "set_value/2" do
    test "returns JS command" do
      js = DatePicker.set_value("my-date-picker", "2025-02-22")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = DatePicker.set_value(socket, "my-date-picker", "2025-02-22")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end
end
