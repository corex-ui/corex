defmodule E2eWeb.DataListTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.DataListModel, as: DataList

  feature "anatomy minimal section renders Lorem", %{session: session} do
    session
    |> DataList.visit_ready("/en/data-list/anatomy", css("#data-list-anatomy-minimal"))
    |> DataList.see_content("Lorem ipsum dolor sit amet")
  end

  feature "playground renders Lorem", %{session: session} do
    session
    |> DataList.visit_ready("/en/data-list/playground")
    |> DataList.see_content("Lorem ipsum dolor sit amet")
  end
end
