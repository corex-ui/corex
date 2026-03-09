defmodule E2eWeb.CheckboxControlledLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest

  @locale "en"

  describe "CheckboxControlledLive" do
    test "mounts and renders correctly", %{conn: conn} do
      {:ok, _live, html} = live(conn, ~p"/#{@locale}/live/checkbox/controlled")

      assert html =~ "Checkbox"
      assert html =~ "Controlled Live View"
      assert html =~ "Controlled State: false"

      # The checkbox should be unchecked initially
      assert html =~ ~s(data-checked="") == false
    end

    test "handles check_all and uncheck_all events", %{conn: conn} do
      {:ok, live, _html} = live(conn, ~p"/#{@locale}/live/checkbox/controlled")

      # Initial state
      assert render(live) =~ "Controlled State: false"

      # Click Check All
      html =
        live
        |> element("button", "Set Checked to True")
        |> render_click()

      assert html =~ "Controlled State: true"
      assert html =~ ~s(data-checked="")

      # Click Uncheck All
      html =
        live
        |> element("button", "Set Checked to False")
        |> render_click()

      assert html =~ "Controlled State: false"
      refute html =~ ~s(data-checked="")
    end

    test "handles client change events", %{conn: conn} do
      {:ok, live, _html} = live(conn, ~p"/#{@locale}/live/checkbox/controlled")

      # Simulate client sending check true
      html =
        live
        |> element("#controlled-checkbox")
        |> render_hook("change", %{"checked" => true, "id" => "controlled-checkbox"})

      assert html =~ "Controlled State: true"
      assert html =~ ~s(data-checked="")

      # Simulate client sending check false
      html =
        live
        |> element("#controlled-checkbox")
        |> render_hook("change", %{"checked" => false, "id" => "controlled-checkbox"})

      assert html =~ "Controlled State: false"
      refute html =~ ~s(data-checked="")
    end
  end
end
