defmodule E2eWeb.CarouselTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.CarouselModel, as: Carousel

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Carousel has no A11y violations", %{session: session} do
      session
      |> Carousel.goto(@mode)
      |> Carousel.check_accessibility()
    end
  end
end
