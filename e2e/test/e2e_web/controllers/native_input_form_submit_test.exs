defmodule E2eWeb.NativeInputFormSubmitTest do
  use E2eWeb.ConnCase

  setup do
    Localize.put_locale(:en)
    :ok
  end

  defp post_form(params) do
    build_conn()
    |> Plug.Conn.put_private(:plug_skip_csrf_protection, true)
    |> post(~p"/native-input/form", params)
  end

  test "POST ecto form with empty fields re-renders with validation error" do
    conn = post_form(%{"profile_ecto" => %{}})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    assert html =~ "native-input-form-ecto"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST with no form field params re-renders ecto validation error" do
    conn = post_form(%{})

    html = html_response(conn, 200)
    assert html =~ "can&#39;t be blank"
    refute Phoenix.Flash.get(conn.assigns.flash, :info)
  end

  test "POST ecto form with valid profile redirects with flash including size" do
    conn =
      post_form(%{
        "profile_ecto" => E2e.Form.NativeInputProfile.valid_attrs()
      })

    assert redirected_to(conn) == ~p"/native-input/form#native-input-form-ecto"
    flash = Phoenix.Flash.get(conn.assigns.flash, :info)
    assert flash =~ "size="
    assert flash =~ "name="
  end

  test "POST native form with radio size redirects with flash" do
    conn =
      post_form(%{
        "profile" => %{
          "name" => "Ada",
          "email" => "ada@ex.com",
          "size" => "m",
          "agree" => "true"
        }
      })

    assert redirected_to(conn) == ~p"/native-input/form#native-input-form-native"
    flash = Phoenix.Flash.get(conn.assigns.flash, :info)
    assert flash =~ "size="
  end
end
