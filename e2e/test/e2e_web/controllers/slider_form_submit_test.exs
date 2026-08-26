defmodule E2eWeb.SliderFormSubmitTest do
  use E2eWeb.ConnCase

  setup do
    Localize.put_locale(:en)
    :ok
  end

  defp post_form(params) do
    build_conn()
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
    |> post(~p"/slider/form", params)
  end

  test "POST ecto form with volume over 90 redirects with numeric flash" do
    conn = post_form(%{"slider_ecto" => %{"volume" => "95"}})

    assert redirected_to(conn) == ~p"/slider/form#slider-form-ecto"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: volume=95"
    refute Phoenix.Flash.get(conn.assigns.flash, :info) =~ "volume=\"95\""
  end

  test "POST ecto form with volume not over 90 re-renders validation error" do
    conn = post_form(%{"slider_ecto" => %{"volume" => "45"}})

    html = html_response(conn, 200)
    assert html =~ "must be over 90"
    assert html =~ "slider-form-ecto"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST ecto range form with high over 90 redirects with numeric flash" do
    conn = post_form(%{"slider_ecto_range" => %{"volume" => ["20", "95"]}})

    assert redirected_to(conn) == ~p"/slider/form#slider-form-ecto-range"
    assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Submitted: volume=[20.0, 95.0]"
  end

  test "POST ecto range form with high not over 90 re-renders validation error" do
    conn = post_form(%{"slider_ecto_range" => %{"volume" => ["20", "80"]}})

    html = html_response(conn, 200)
    assert html =~ "must be over 90"
    assert html =~ "slider-form-ecto-range"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end
end
