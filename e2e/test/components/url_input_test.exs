defmodule E2eWeb.UrlInputTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.UrlInputModel, as: UrlInput

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - URL input has no A11y violations", %{session: session} do
      session
      |> UrlInput.goto(@mode)
      |> UrlInput.check_accessibility()
    end
  end
end
