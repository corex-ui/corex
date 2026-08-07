defmodule Corex.Api.RespondToTest do
  use ExUnit.Case, async: true

  alias Corex.Api.RespondTo
  alias Phoenix.LiveView.JS

  describe "respond_to_fields/1" do
    test "defaults to the server target" do
      assert RespondTo.respond_to_fields([]) == %{respond_to: "server"}
    end

    test "stringifies a known target" do
      assert RespondTo.respond_to_fields(respond_to: :both) == %{respond_to: "both"}
      assert RespondTo.respond_to_fields(respond_to: :client) == %{respond_to: "client"}
    end

    test "raises on an unknown target" do
      assert_raise ArgumentError, ~r/expected :both, :server, or :client/, fn ->
        RespondTo.respond_to_fields(respond_to: :invalid)
      end
    end
  end

  describe "push_set_value/4" do
    test "pushes event with id and value" do
      socket = %Phoenix.LiveView.Socket{}

      assert %Phoenix.LiveView.Socket{} =
               RespondTo.push_set_value(socket, "my_event", "cmp-1", ["a", "b"])
    end
  end

  describe "push_set_open/4" do
    test "pushes event with id and open" do
      socket = %Phoenix.LiveView.Socket{}

      assert %Phoenix.LiveView.Socket{} =
               RespondTo.push_set_open(socket, "my_event", "cmp-1", true)
    end
  end

  describe "dispatch_set_value/3" do
    test "returns JS dispatch struct" do
      js = RespondTo.dispatch_set_value("cmp-1", ["x"], "corex:test:set-value")
      assert %JS{} = js
    end
  end

  describe "dispatch_set_open/3" do
    test "returns JS dispatch struct" do
      js = RespondTo.dispatch_set_open("cmp-1", false, "corex:test:set-open")
      assert %JS{} = js
    end
  end
end
