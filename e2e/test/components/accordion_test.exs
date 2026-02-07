defmodule E2eWeb.AccordionTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.AccordionModel, as: Accordion

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Accordion has no A11y violations", %{session: session} do
      session
      |> Accordion.goto(@mode)
      |> Accordion.check_accessibility()
    end

    feature "#{@mode} - Clicking accordion item shows content", %{session: session} do
      session =
        session
        |> Accordion.goto(@mode)
        |> Accordion.wait(300)

      # Verify content is initially not visible
      refute Accordion.content_visible?(session, "Consectetur adipiscing elit")

      # Click on the accordion item trigger
      session = Accordion.click_item(session, "Lorem ipsum dolor sit amet")

      # Wait for the accordion to expand and content to become visible
      # The see_content function will wait and check
      Accordion.see_content(session, "Consectetur adipiscing elit")
    end
  end
end
