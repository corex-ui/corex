defmodule E2eWeb.HomeA11yTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby
  @moduletag :a11y
  @moduletag timeout: 120_000

  import Wallaby.Query

  alias E2eWeb.SiteModel

  feature "a11y homepage", %{session: session} do
    session
    |> SiteModel.visit_ready("/", css("#home-hero-heading", visible: :any))
    |> assert_has(css("#home", visible: :any))
    |> assert_has(css("#home-hero-interactive", visible: :any))
    |> assert_has(css("#hero-accordion", visible: :any))
    |> assert_has(css("#hero-events-table", visible: :any))
    |> assert_has(css("#home-footer", visible: :any))
    |> SiteModel.check_accessibility()
  end
end
