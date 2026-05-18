defmodule E2eWeb.AvatarTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.AvatarModel, as: Avatar
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :avatar

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "basic  -  cat avatar shows image", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Avatar, :avatar, :anatomy)
        |> Avatar.wait_section_avatar_ready("avatar-anatomy-basic")
        |> Avatar.wait_host_avatar_ready("avatar-cat")

      assert Avatar.avatar_image_visible?(session, "avatar-cat")
    end

    feature "custom slots  -  fallback text is visible", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Avatar, :avatar, :anatomy)
        |> Avatar.wait_section_avatar_ready("avatar-anatomy-custom-slots")

      assert_has(session, css("section#avatar-anatomy-custom-slots", text: "AB"))
    end
  end

  describe "api" do
    feature "set src (binding)  -  alternate image loads", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Avatar, :avatar, :api)
        |> Avatar.wait_host_avatar_ready("api-set-src-client")

      session
      |> Avatar.click_in_section("avatar-api-set-src-binding", "Set alternate")
      |> Avatar.wait_host_avatar_ready("api-set-src-client", timeout: 10_000)

      assert Avatar.avatar_image_visible?(session, "api-set-src-client")
    end

    feature "set src (server)  -  primary image loads", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Avatar, :avatar, :api)
        |> Avatar.prepare_live_form()
        |> Avatar.wait_host_avatar_ready("api-set-src-server")

      session
      |> Avatar.click_in_section("avatar-api-set-src-server", "Set primary")

      assert Avatar.avatar_image_visible?(session, "api-set-src-server")
    end
  end

  describe "events" do
    feature "status change  -  url update appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Avatar, :avatar, :events)
        |> Avatar.prepare_live_form()
        |> Avatar.wait_host_avatar_ready("avatar-events")

      before = Avatar.log_row_count(session, "avatar-events-log")

      session
      |> Avatar.set_events_src("https://corex-ui.com/pwa-192x192.png")
      |> Avatar.wait_log_rows_grew("avatar-events-log", before, timeout: 12_000)
    end
  end
end
