defmodule E2eWeb.DocRoutesA11yTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.SiteModel

  a11y = E2eWeb.DocA11yRoutes.all()

  for {path, ready} <- Enum.reject(a11y, fn {p, _} -> String.contains?(p, "/accordion/") end) do
    @path path
    @ready ready

    feature "a11y doc #{@path}", %{session: session} do
      SiteModel.visit_and_check_a11y(session, @path, css(@ready))
    end
  end

  for {path, ready} <- Enum.filter(a11y, fn {p, _} -> String.contains?(p, "/accordion/") end) do
    @path path
    @ready ready
    @tag :skip

    feature "a11y doc #{@path}", %{session: session} do
      SiteModel.visit_and_check_a11y(session, @path, css(@ready))
    end
  end
end
