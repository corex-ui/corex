defmodule E2eWeb.AdminLiveTest do
  use E2eWeb.ConnCase

  import Phoenix.LiveViewTest
  import E2e.AccountsFixtures

  @valid_signature_path "M0,0L1,1Z"
  @create_attrs %{
    name: "some name",
    country: "fra",
    birth_date: "1990-01-15",
    signature: [@valid_signature_path],
    terms: true,
    level: 5,
    currency: "eur",
    tags: ["alpha", "beta"]
  }
  @update_attrs %{
    name: "some updated name",
    country: "deu",
    birth_date: "1995-06-20",
    terms: true,
    level: 3,
    currency: "usd",
    tags: ["gamma", "delta"]
  }
  @invalid_attrs %{
    name: "",
    country: "",
    birth_date: nil,
    signature: [],
    terms: false,
    level: 1,
    currency: "",
    tags: [""]
  }
  @invalid_attrs_edit %{
    name: "",
    country: "fra",
    birth_date: "1990-01-15",
    terms: false,
    level: 5,
    currency: "eur",
    tags: ["alpha", "beta"]
  }

  defp create_admin(_) do
    admin = admin_fixture()

    %{admin: admin}
  end

  defp signature_field_value(%{signature: s}) when is_list(s), do: s
  defp signature_field_value(%{signature: s}) when is_binary(s), do: [s]

  defp admin_http_params(attrs) do
    attrs
    |> Map.new(fn
      {k, v} when is_atom(k) ->
        key = Atom.to_string(k)

        val =
          cond do
            key == "terms" and is_boolean(v) -> if(v, do: "true", else: "false")
            key == "level" and is_integer(v) -> Integer.to_string(v)
            key == "birth_date" and is_nil(v) -> ""
            true -> v
          end

        {key, val}

      other ->
        other
    end)
  end

  describe "Index" do
    setup [:create_admin]

    test "lists all admins", %{conn: conn, admin: admin} do
      {_index_live, html} = live_ok!(conn, ~p"/admins")

      assert html =~ "Listing Admins"
      assert html =~ admin.name
    end

    test "saves new admin", %{conn: conn} do
      {index_live, _html} = live_ok!(conn, ~p"/admins")

      {form_live, _} =
        index_live
        |> element("a", "New Admin")
        |> render_click()
        |> follow_redirect(conn, ~p"/admins/new")
        |> unwrap_live_redirect!()

      assert render(form_live) =~ "New Admin"

      assert render_change(form_live, "validate", %{"admin" => admin_http_params(@invalid_attrs)}) =~
               "can&#39;t be blank"

      create_params = admin_http_params(@create_attrs)

      form_live
      |> render_change("validate", %{"admin" => create_params})

      {index_live, _html} =
        form_live
        |> render_submit("save", %{"admin" => create_params})
        |> follow_redirect(conn, ~p"/admins")
        |> unwrap_live_redirect!()

      html = render(index_live)
      assert html =~ "Admin created successfully"
      assert html =~ "some name"
    end

    test "updates admin in listing", %{conn: conn, admin: admin} do
      {index_live, _html} = live_ok!(conn, ~p"/admins")

      {form_live, _html} =
        index_live
        |> element("#admins-#{admin.id} [aria-label^='Edit']")
        |> render_click()
        |> follow_redirect(conn, ~p"/admins/#{admin}/edit")
        |> unwrap_live_redirect!()

      assert render(form_live) =~ "Edit Admin"

      invalid_edit = Map.put(@invalid_attrs_edit, :signature, signature_field_value(admin))

      assert render_change(form_live, "validate", %{"admin" => admin_http_params(invalid_edit)}) =~
               "can&#39;t be blank"

      update_attrs =
        @update_attrs
        |> Map.put(:signature, signature_field_value(admin))
        |> admin_http_params()

      form_live
      |> render_change("validate", %{"admin" => update_attrs})

      {index_live, _html} =
        form_live
        |> render_submit("save", %{"admin" => update_attrs})
        |> follow_redirect(conn, ~p"/admins")
        |> unwrap_live_redirect!()

      html = render(index_live)
      assert html =~ "Admin updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes admin in listing", %{conn: conn, admin: admin} do
      {index_live, _html} = live_ok!(conn, ~p"/admins")

      index_live
      |> element("#admin-delete-#{admin.id}-confirm")
      |> render_click()

      refute has_element?(index_live, "#admins-#{admin.id}")
    end

    test "deletes admin from edit page", %{conn: conn, admin: admin} do
      {form_live, _html} = live_ok!(conn, ~p"/admins/#{admin}/edit")

      form_live
      |> element("#admin-delete-#{admin.id}-confirm")
      |> render_click()

      assert_redirect(form_live, ~p"/admins")
    end
  end

  describe "Show" do
    setup [:create_admin]

    test "displays admin", %{conn: conn, admin: admin} do
      {_show_live, html} = live_ok!(conn, ~p"/admins/#{admin}")

      assert html =~ "Show Admin"
      assert html =~ admin.name
    end

    test "updates admin and returns to show", %{conn: conn, admin: admin} do
      {show_live, _html} = live_ok!(conn, ~p"/admins/#{admin}")

      {form_live, _} =
        show_live
        |> element("a", "Edit")
        |> render_click()
        |> follow_redirect(conn, ~p"/admins/#{admin}/edit?return_to=show")
        |> unwrap_live_redirect!()

      assert render(form_live) =~ "Edit Admin"

      invalid_edit =
        @invalid_attrs_edit
        |> Map.put(:signature, signature_field_value(admin))
        |> admin_http_params()

      assert render_change(form_live, "validate", %{"admin" => invalid_edit}) =~
               "can&#39;t be blank"

      update_attrs =
        @update_attrs
        |> Map.put(:signature, signature_field_value(admin))
        |> admin_http_params()

      form_live
      |> render_change("validate", %{"admin" => update_attrs})

      {show_live, _html} =
        form_live
        |> render_submit("save", %{"admin" => update_attrs})
        |> follow_redirect(conn, ~p"/admins/#{admin}")
        |> unwrap_live_redirect!()

      html = render(show_live)
      assert html =~ "Admin updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes admin from show page", %{conn: conn, admin: admin} do
      {show_live, _html} = live_ok!(conn, ~p"/admins/#{admin}")

      show_live
      |> element("#admin-delete-#{admin.id}-confirm")
      |> render_click()

      assert_redirect(show_live, ~p"/admins")
    end
  end

  describe "Number input morphdom regression" do
    test "level value survives sibling field validation", %{conn: conn} do
      {form_live, _} = live_ok!(conn, ~p"/admins/new")

      attrs = %{
        "name" => "",
        "country" => "fra",
        "birth_date" => "1990-01-15",
        "signature" => [@valid_signature_path],
        "terms" => "false",
        "level" => "42",
        "currency" => "eur",
        "tags" => ["alpha", "beta"]
      }

      html = render_change(form_live, "validate", %{"admin" => attrs})

      assert html =~ ~r/<input\b[^>]*\bvalue="42"[^>]*\bdata-part="input"/
    end
  end

  describe "hidden-input used_input regression" do
    test "validate on name only does not show errors on untouched select combobox or tags", %{
      conn: conn
    } do
      {form_live, _html} = live_ok!(conn, ~p"/admins/new")

      html =
        render_change(form_live, "validate", %{
          "admin" => %{
            "name" => "h",
            "country" => "",
            "currency" => "",
            "tags" => [""],
            "birth_date" => "",
            "signature" => [],
            "terms" => "false",
            "level" => "1",
            "_unused_country" => "",
            "_unused_currency" => "",
            "_unused_tags" => "",
            "_unused_birth_date" => "",
            "_unused_signature" => "",
            "_unused_terms" => ""
          }
        })

      refute html =~ "can&#39;t be blank"
    end

    test "select and combobox values survive sibling field validation", %{conn: conn} do
      {form_live, _} = live_ok!(conn, ~p"/admins/new")

      attrs = %{
        "name" => "updated",
        "country" => "fra",
        "currency" => "eur",
        "tags" => ["alpha", "beta"],
        "birth_date" => "",
        "signature" => [],
        "terms" => "false",
        "level" => "1",
        "_unused_birth_date" => "",
        "_unused_signature" => "",
        "_unused_terms" => ""
      }

      html = render_change(form_live, "validate", %{"admin" => attrs})

      assert html =~
               ~r/<input\b(?=[^>]*\bname="admin\[country\]")(?=[^>]*\bvalue="fra")[^>]*\bdata-part="value-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\bname="admin\[currency\]")(?=[^>]*\bvalue="eur")[^>]*\bdata-part="hidden-input"/

      refute html =~ "can&#39;t be blank"
    end

    test "form value inputs use text type so LiveView can track unused fields", %{conn: conn} do
      {form_live, _} = live_ok!(conn, ~p"/admins/new")
      html = render(form_live)

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="admin\[country\]")[^>]*\bdata-part="value-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="admin\[currency\]")[^>]*\bdata-part="hidden-input"/

      assert html =~ ~S|data-submit-name="admin[tags][]"|
      assert html =~ ~S|data-submit-name="admin[signature][]"|
      refute html =~ ~S|name="admin[_unused_tags]"|
      refute html =~ ~S|name="admin[_unused_signature]"|

      refute html =~
               ~r/<input\b(?=[^>]*\bdata-empty)(?=[^>]*\bname="admin\[tags\]\[\]")/

      refute html =~
               ~r/<input\b(?=[^>]*\bdata-empty)(?=[^>]*\bname="admin\[signature\]\[\]")/

      refute html =~
               ~r/<input\b(?=[^>]*\btype="hidden")(?=[^>]*\bname="admin\[(country|currency)\]")/
    end
  end

  describe "save validation" do
    test "validate shows tags and signature errors when those fields are used", %{conn: conn} do
      {form_live, _html} = live_ok!(conn, ~p"/admins/new")

      html =
        render_change(form_live, "validate", %{
          "admin" => %{
            "name" => "",
            "country" => "",
            "currency" => "",
            "tags" => [""],
            "birth_date" => "",
            "signature" => [""],
            "terms" => "false",
            "level" => "1"
          }
        })

      assert html =~ "can&#39;t be blank"
      assert html =~ "data-field-used"
    end

    test "invalid save re-renders with validate action and errors for used fields", %{conn: conn} do
      {form_live, _html} = live_ok!(conn, ~p"/admins/new")

      html =
        render_submit(form_live, "save", %{
          "admin" => %{
            "name" => "",
            "country" => "",
            "currency" => "",
            "tags" => [],
            "birth_date" => "",
            "signature" => [],
            "terms" => "false",
            "level" => "1"
          }
        })

      assert html =~ "can&#39;t be blank"
      refute html =~ "Admin created successfully"
    end

    test "invalid save without admin params does not create admin", %{conn: conn} do
      {form_live, _html} = live_ok!(conn, ~p"/admins/new")

      html = render_submit(form_live, "save", %{})

      refute html =~ "Admin created successfully"
      assert html =~ "Save Admin"
    end

    test "save accepts list signature params from HTTP shape", %{conn: conn} do
      {form_live, _} = live_ok!(conn, ~p"/admins/new")

      attrs = %{
        "name" => "array submit",
        "country" => "fra",
        "birth_date" => "1990-01-15",
        "signature" => [@valid_signature_path],
        "terms" => "true",
        "level" => "3",
        "currency" => "eur",
        "tags" => ["alpha"]
      }

      form_live
      |> render_change("validate", %{"admin" => attrs})

      {index_live, _html} =
        form_live
        |> render_submit("save", %{"admin" => attrs})
        |> follow_redirect(conn, ~p"/admins")
        |> unwrap_live_redirect!()

      assert render(index_live) =~ "Admin created successfully"
      assert render(index_live) =~ "array submit"
    end
  end
end
