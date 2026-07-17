defmodule E2eWeb.PaginationWallabyTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.PaginationModel, as: Pagination

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal section changes page on click", %{session: session} do
      section = "pagination-anatomy-minimal"

      session
      |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :anatomy)
      |> Pagination.wait_pagination_in_section(section, "pagination-anatomy")
      |> Pagination.click_page_in_section(section, 2)
      |> Pagination.assert_item_selected_in_section(section, 2)
    end
  end

  describe "style" do
    feature "each section renders pagination controls", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Pagination, :pagination, :style)

      Enum.each(Pagination.style_section_ids(), fn section_id ->
        assert_has(
          session,
          css("##{section_id} [data-scope='pagination'][data-part='item']", minimum: 1)
        )
      end)
    end
  end

  describe "api" do
    feature "client binding set page buttons update selection", %{session: session} do
      section = "pagination-api-client-binding"

      session
      |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :api)
      |> Pagination.prepare_live_form()
      |> Pagination.wait_pagination_in_section(section, "pagination-api-bind")
      |> Pagination.click_in_section(section, "9")
      |> Pagination.assert_item_selected_in_section(section, 9)
    end

    feature "server push page 3 updates selection", %{session: session} do
      section = "pagination-api-server"

      session
      |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :api)
      |> Pagination.prepare_live_form()
      |> Pagination.wait_pagination_in_section(section, "pagination-api-srv")
      |> Pagination.click_in_section(section, "Page 3")
      |> Pagination.assert_item_selected_in_section(section, 3)
    end
  end

  describe "events" do
    feature "server section page change logs a row", %{session: session} do
      section = "pagination-events-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :events)
        |> Pagination.prepare_live_form()
        |> Pagination.wait_pagination_in_section(section, "pagination-events-server")

      refute Pagination.events_server_log_has_row?(session)

      session
      |> Pagination.click_page_in_section(section, 2)
      |> Pagination.wait_for_has(
        css("#pagination-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )
    end

    feature "client section renders pagination", %{session: session} do
      section = "pagination-events-client-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :events)
        |> Pagination.prepare_live_form()

      Pagination.wait_pagination_in_section(session, section, "pagination-events-client")
    end
  end

  describe "patterns" do
    feature "controlled section updates current page label", %{session: session} do
      section = "pagination-patterns-controlled-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :patterns)
        |> Pagination.prepare_live_form()
        |> Pagination.wait_pagination_in_section(section, "pagination-patterns-controlled")
        |> Pagination.click_page_in_section(section, 3)

      assert_has(session, css("##{section}", text: "Current page: 3"))
    end

    feature "patch section renders post list", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :patterns)
        |> Pagination.prepare_live_form()

      assert_has(session, css("#pagination-patterns-patch-section li", minimum: 1))
    end

    feature "server section updates posts on page change", %{session: session} do
      section = "pagination-patterns-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :patterns)
        |> Pagination.prepare_live_form()
        |> Pagination.wait_pagination_in_section(section, "pagination-patterns-server")
        |> Pagination.click_page_in_section(section, 2)

      assert_has(session, css("##{section}", text: "Zag.js under the hood"))
    end

    feature "client section renders post list", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Pagination, :pagination, :patterns)
        |> Pagination.prepare_live_form()

      assert_has(session, css("#pagination-patterns-client-list li", minimum: 1))
    end
  end
end
