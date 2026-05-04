defmodule E2eWeb.DataListTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.DataListModel, as: DataList

  feature "anatomy renders Alice", %{session: session} do
    session
    |> DataList.visit_ready("/en/data-list/anatomy", css("#data-list-anatomy-page"))
    |> DataList.see_content("Alice")
  end

  feature "anatomy items API section renders repository label", %{session: session} do
    session
    |> DataList.visit_ready("/en/data-list/anatomy", css("#data-list-anatomy-items-api"))
    |> DataList.see_content("Repository")
  end
end
