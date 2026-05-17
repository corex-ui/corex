defmodule Corex.PinInputTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.PinInput
  alias Corex.PinInput.Connect

  describe "pin_input/1" do
    test "renders" do
      html = render_component(&PinInput.pin_input/1, id: "pin-basic", name: "pin", count: 4)
      assert html =~ ~r/data-scope="pin-input"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders full options" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input
              id="pin-full"
              name="otp"
              count={4}
              value="12"
              otp
              mask
              type="alphanumeric"
              placeholder="○"
              invalid
              errors={["Invalid code"]}
              select_on_focus
            >
              <:label>Enter code</:label>
              <:error :let={msg}>{msg}</:error>
            </PinInput.pin_input>
            """
          end,
          %{}
        )

      assert html =~ "Invalid code"
      assert html =~ "○"
      assert html =~ ~s(data-select-on-focus)
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "pin-input:test-pin"
      assert result["data-scope"] == "pin-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "pin-input:test-pin:label"
    end
  end

  describe "pin_input/1 form field" do
    test "renders from form field" do
      form = Phoenix.Component.to_form(%{"code" => "12"}, as: :user)

      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input field={@form[:code]} count={4}>
              <:label>Code</:label>
            </PinInput.pin_input>
            """
          end,
          %{form: form}
        )

      assert html =~ "Code"
      assert html =~ ~s(data-scope="pin-input")
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = PinInput.set_value("pin-1", "1234")
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = PinInput.set_value(socket, "pin-1", "1234")
    end
  end
end
