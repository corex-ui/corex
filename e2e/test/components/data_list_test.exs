defmodule E2eWeb.DataListTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.DataListModel, as: DataList

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - DataList has no A11y violations", %{session: session} do
      session
      |> DataList.goto(@mode)
      |> DataList.check_accessibility()
    end

    feature "#{@mode} - DataList renders content", %{session: session} do
      session
      |> DataList.goto(@mode)
      |> DataList.see_content("Alice")
    end
  end
end