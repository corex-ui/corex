defmodule E2eWeb.CarouselTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CarouselModel, as: Carousel
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :carousel

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section advances to the next slide", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Carousel, :carousel, :anatomy)

      Enum.reduce(Carousel.anatomy_section_ids(), session, fn section_id, sess ->
        host = Carousel.host_id_for_anatomy_section(section_id)

        sess
        |> Carousel.wait_section_carousel_ready(section_id)
        |> Carousel.click_next_in_host(host)
        |> Carousel.wait_indicator_current_at(host, 1, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "client binding  -  Next advances slide", %{session: session} do
      host = "api-carousel-play-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Carousel, :carousel, :api)
        |> Carousel.wait_host_carousel_ready(host)

      session
      |> Carousel.click_in_section("carousel-api-client-binding", "Next")
      |> Carousel.wait_indicator_current_at(host, 1, timeout: 8_000)
    end

    feature "server  -  Next advances slide", %{session: session} do
      host = "api-carousel-play-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Carousel, :carousel, :api)
        |> Carousel.prepare_live_form()
        |> Carousel.wait_host_carousel_ready(host)

      session
      |> Carousel.click_in_section("carousel-api-server", "Next")
      |> Carousel.wait_indicator_current_at(host, 1, timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  next slide appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Carousel, :carousel, :events)
        |> Carousel.prepare_live_form()
        |> Carousel.wait_host_carousel_ready("carousel-events-server")

      refute Carousel.carousel_events_server_log_has_row?(session)

      session
      |> Carousel.click_next_in_host("carousel-events-server")
      |> Carousel.wait_for_has(
        css("#carousel-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )

      assert Carousel.carousel_events_server_log_has_row?(session)
    end
  end
end
