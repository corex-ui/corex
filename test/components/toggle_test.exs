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

  describe "toggle_pressed/3" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Toggle.toggle_pressed(socket, "tid")
    end
  end

  describe "Connect.props/1" do
    test "controlled pressed true and false" do
      base = %{
        id: "t",
        disabled: false,
        dir: "ltr",
        on_pressed_change: nil,
        on_pressed_change_client: nil
      }

      on = Connect.props(Map.merge(base, %{controlled: true, pressed: true}))
      assert on["data-controlled"] == ""
      assert on["data-pressed"] == "true"
      assert on["data-default-pressed"] == nil

      off = Connect.props(Map.merge(base, %{controlled: true, pressed: false}))
      assert off["data-pressed"] == "false"
    end

    test "uncontrolled omits data-pressed and sets default when pressed" do
      p =
        Connect.props(%{
          id: "t",
          controlled: false,
          pressed: true,
          disabled: false,
          dir: "rtl",
          on_pressed_change: nil,
          on_pressed_change_client: nil
        })

      assert p["data-pressed"] == nil
      assert p["data-default-pressed"] == "true"
      assert p["data-dir"] == "rtl"
    end

    test "includes event attributes" do
      p =
        Connect.props(%{
          id: "t",
          controlled: false,
          pressed: false,
          disabled: true,
          dir: "ltr",
          on_pressed_change: "pc",
          on_pressed_change_client: "pcc"
        })

      assert p["data-disabled"] == ""
      assert p["data-on-pressed-change"] == "pc"
      assert p["data-on-pressed-change-client"] == "pcc"
    end
  end

  describe "Connect.root/1" do
    test "returns root attrs" do
      r = Connect.root(%{id: "x", dir: "ltr", pressed: true, disabled: false})
      assert r["data-scope"] == "toggle"
      assert r["data-part"] == "root"
      assert r["data-state"] == "on"
    end

    test "off state and disabled" do
      r = Connect.root(%{id: "x", dir: "ltr", pressed: false, disabled: true})
      assert r["data-state"] == "off"
      assert r["data-disabled"] == true
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attrs for on and off" do
      on = Connect.indicator(%{id: "x", dir: "ltr", pressed: true, disabled: false})
      assert on["data-part"] == "indicator"
      assert on["data-state"] == "on"

      off = Connect.indicator(%{id: "x", dir: "ltr", pressed: false, disabled: false})
      assert off["data-state"] == "off"
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

    test "renders indicator slot and event attrs" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Toggle.toggle
              id="tog-full"
              class="toggle"
              on_pressed_change="toggle_pressed_changed"
            >
              <:indicator><span data-indicator>B</span></:indicator>
              Bold
            </Corex.Toggle.toggle>
            """
          end,
          %{}
        )

      assert html =~ "data-indicator"
      assert html =~ ~r/data-on-pressed-change="toggle_pressed_changed"/
    end
  end
end
