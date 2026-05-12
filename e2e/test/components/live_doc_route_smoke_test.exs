defmodule E2eWeb.LiveDocRouteSmokeTest do
  use E2eWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @allowed_last ~w(playground api patterns animation controlled)

  test "doc playground, api, patterns, animation, and controlled LiveViews mount", %{conn: conn} do
    routes =
      E2eWeb.DocA11yRoutes.all()
      |> Enum.filter(fn {path, _} ->
        last = path |> String.split("/") |> List.last()
        last in @allowed_last
      end)

    for {doc_path, root_sel} <- routes do
      assert {:ok, _view, html} = live(conn, doc_path, on_error: :warn)
      id = String.trim_leading(root_sel, "#")
      assert html =~ ~s(id="#{id}")
    end
  end
end
