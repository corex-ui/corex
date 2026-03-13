defmodule E2eWeb.AccordionTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.AccordionModel, as: Accordion

  for mode <- [
        :static,
        :live,
        "/en/playground/accordion",
        "/en/controlled/accordion",
        "/en/async/accordion"
      ] do
    @mode mode

    feature "#{@mode} - Accordion has no A11y violations", %{session: session} do
      session
      |> Accordion.goto(@mode)
      |> Accordion.wait(500)
      |> Accordion.check_accessibility()
    end

    feature "#{@mode} - Clicking accordion item shows content", %{session: session} do
      session =
        session
        |> Accordion.goto(@mode)
        |> Accordion.wait(300)

      content_initially_visible =
        Accordion.content_visible?(session, "Consectetur adipiscing elit")

      session =
        if content_initially_visible do
          session
          |> Accordion.click_item("Lorem ipsum dolor sit amet")
          |> Accordion.wait(200)
          |> Accordion.click_item("Lorem ipsum dolor sit amet")
        else
          Accordion.click_item(session, "Lorem ipsum dolor sit amet")
        end

      Accordion.see_content(session, "Consectetur adipiscing elit")
    end
  end
end
