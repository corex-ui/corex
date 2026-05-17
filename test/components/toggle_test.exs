defmodule Corex.ToggleTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  alias Corex.Toggle
  alias Corex.Toggle.Connect

  describe "toggle/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_toggle/1, [])
      assert html =~ ~r/data-scope="toggle"/
      assert html =~ ~r/phx-hook="Toggle"/
    end

    test "controlled pressed true sets data-pressed" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_toggle/1,
          controlled: true,
          pressed: true
        )

      assert html =~ ~r/data-controlled/
      assert html =~ ~r/data-pressed="true"/
    end

    test "uncontrolled pressed default uses data-default-pressed" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_toggle/1,
          controlled: false,
          pressed: true
        )

      assert html =~ ~r/data-default-pressed="true"/
    end
  end

  describe "set_pressed/2" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = Toggle.set_pressed("tid", true)
    end
  end

  describe "set_pressed/3" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Toggle.set_pressed(socket, "tid", false)
    end
  end

  describe "toggle_pressed/1" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = Toggle.toggle_pressed("tid")
    end
  end

  describe "Connect.root/1" do
    test "returns root attrs" do
      r = Connect.root(%{id: "x", dir: "ltr", pressed: true, disabled: false})
      assert r["data-scope"] == "toggle"
      assert r["data-part"] == "root"
      assert r["data-state"] == "on"
    end
  end

  describe "Connect ignore helpers" do
    test "returns JS for ignore functions" do
      base = %{id: "tog", dir: "ltr", pressed: false, disabled: true}
      assert %Phoenix.LiveView.JS{} = Connect.ignore_root(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_indicator(base)
    end
  end

  describe "toggle disabled" do
    test "renders disabled state" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Toggle.toggle id="tog-off" disabled aria_label="Off">
              Off
            </Corex.Toggle.toggle>
            """
          end,
          %{}
        )

      assert html =~ "data-disabled"
    end
  end
end
