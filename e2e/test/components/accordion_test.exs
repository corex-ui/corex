# test/components/accordion_test.exs
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

    feature "#{@mode} - Clicking on the accordion trigger opens the accordion content", %{
      session: session
    } do
      session
      |> Accordion.goto(@mode)
      |> Accordion.dont_see_content("item-0")
      |> Accordion.click_trigger("item-0")
      |> Accordion.see_content("item-0")
    end

    feature "#{@mode} - Space key opens accordion after focus", %{session: session} do
      session
      |> Accordion.goto(@mode)
      |> Accordion.dont_see_content("item-1")
      |> Accordion.click_trigger("item-1")
      |> Accordion.press_space()
      |> Accordion.dont_see_content("item-1")
    end

    feature "#{@mode} - Enter key opens accordion after focus", %{session: session} do
      session
      |> Accordion.goto(@mode)
      |> Accordion.dont_see_content("item-2")
      |> Accordion.click_trigger("item-2")
      |> Accordion.press_enter()
      |> Accordion.dont_see_content("item-2")
    end
  end
end
