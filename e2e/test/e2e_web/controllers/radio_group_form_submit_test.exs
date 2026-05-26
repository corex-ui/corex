defmodule E2eWeb.RadioGroupFormSubmitTest do
  use E2eWeb.ConnCase

  setup do
    Localize.put_locale(:en)
    :ok
  end

  defp post_form(params) do
    build_conn()
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
    |> post(~p"/radio-group/form", params)
  end

  test "POST ecto form with empty choice re-renders with validation error" do
    conn = post_form(%{"radio_group_ecto" => %{"choice" => ""}})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    assert html =~ "radio-group-form-ecto"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST with no form field params re-renders ecto validation error" do
    conn = post_form(%{})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST ecto form with valid choice redirects with flash" do
    conn = post_form(%{"radio_group_ecto" => %{"choice" => "duis"}})

    assert redirected_to(conn) == ~p"/radio-group/form#radio-group-form-ecto"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "duis"
  end
end
