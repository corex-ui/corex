defmodule E2eWeb.ToastTest do
  @moduledoc """
  Toast pilot Wallaby suite.

  Behavior map (what, where):

  | Page | Features |
  | --- | --- |
  | playground | Submit Create toast, assert toast visible |
  | api | Server create Info, toast visible; dismiss and count drop |
  | anatomy | Visit, assert toast host ready |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby
  @moduletag :toast

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.ToastModel, as: Toast

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "playground" do
    feature "submit Create toast renders a toast", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :playground)
        |> Toast.wait_toast_host_ready()
        |> Toast.create_via_playground()

      Toast.assert_toast_visible(session)
    end

    feature "created toast contains the title text", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :playground)
        |> Toast.wait_toast_host_ready()
        |> Toast.create_via_playground()

      Toast.assert_toast_visible_with_text(session, "Saved")
    end
  end

  describe "api" do
    feature "server create Info shows a toast", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :api)
        |> Toast.wait_toast_host_ready()
        |> Toast.click_server_info()

      Toast.assert_toast_visible(session)
      Toast.assert_toast_visible_with_text(session, "Info")
    end

    feature "dismiss removes the toast", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :api)
        |> Toast.wait_toast_host_ready()
        |> Toast.click_server_info()

      Toast.assert_toast_visible(session)
      before = Toast.toast_count(session)

      if Toast.has_close_trigger?(session) do
        session
        |> Toast.dismiss_first_toast()
        |> Toast.wait_toast_gone(before)

        assert Toast.toast_count(session) < before
      end
    end

    feature "stacked dismiss leaves remaining toast closable", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :api)
        |> Toast.wait_toast_host_ready()
        |> Toast.click_server_info()
        |> Toast.click_server_info()

      Toast.assert_toast_visible(session)
      Toast.wait_toast_root_count(session, 2)
      assert Toast.toast_root_count(session) >= 2

      before = Toast.toast_root_count(session)

      session =
        session
        |> Toast.dismiss_first_toast()
        |> Toast.wait(500)

      Toast.wait_toast_root_count(session, before - 1)
      assert Toast.toast_root_count(session) == before - 1
      assert Toast.has_close_trigger?(session)

      session
      |> Toast.dismiss_first_toast()
      |> Toast.wait(500)

      Toast.wait_toast_root_count(session, 0)
      assert Toast.toast_root_count(session) == 0
    end
  end

  describe "anatomy" do
    feature "page loads with toast host ready", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toast, :toast, :anatomy)

      assert_has(session, css("#toast-anatomy-page"))
      Toast.wait_toast_host_ready(session)
    end
  end
end
