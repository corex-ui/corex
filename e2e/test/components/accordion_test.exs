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
  end
end
