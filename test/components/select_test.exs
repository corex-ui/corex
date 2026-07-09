defmodule Corex.SelectTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Select.Connect
  alias Test.Support.ConnectProps

  describe "select/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_select/1, [])
      assert html =~ ~r/data-scope="select"/
      assert html =~ ~r/data-part="root"/
    end

    test "controlled select has data-value" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_controlled_multiple/1, [])
      assert html =~ ~r/data-value="a"/
    end

    test "select with value only in default attr has data-default-value" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_uncontrolled_value/1, [])
      assert html =~ ~r/data-default-value="a"/
    end

    test "with field from form has correct name and id" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_with_field/1, [])
      assert html =~ ~r/name="user\[country\]"/
      assert html =~ ~r/id="user_country"/
    end

    test "with field from form renders defaultValue connect attrs" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_with_field/1, [])
      assert html =~ ~r/data-form-field="true"/
      assert html =~ ~r/data-default-value="\[\&quot;fra\&quot;\]"/
      refute html =~ ~r/id="user_country"[^>]*data-controlled=""/
    end

    test "uses placeholder for aria-label and placeholder span when no selection" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_select_with_opts/1,
          placeholder: "Select"
        )

      assert html =~ ~r/aria-label="Select"/
      assert html =~ "Select"
    end

    test "uses custom placeholder when provided" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_select_with_opts/1,
          placeholder: "Choose one"
        )

      assert html =~ "Choose one"
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-select", invalid: false, read_only: false}
      result = Connect.root(assigns)
      assert result["id"] == "select:test-select"
      assert result["data-scope"] == "select"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{
        id: "test-select",
        dir: "ltr",
        required: false,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.label(assigns)
      assert result["id"] == "select:test-select:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-select", dir: "ltr", disabled: false, invalid: false}
      result = Connect.control(assigns)
      assert result["id"] == "select:test-select:control"
      assert result["data-scope"] == "select"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes" do
      assigns = %{id: "test-select", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["data-part"] == "positioner"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-select", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["data-part"] == "content"
    end
  end

  describe "Connect.props/1" do
    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["id"] == "test-select"
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-value"] == "a"
      assert result["data-default-value"] == nil
      assert result["data-controlled"] == ""
    end

    test "returns props for form field without controlled" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        form_field: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-default-value"] == "[\"a\"]"
      assert result["data-value"] == nil
      refute result["data-controlled"]
      assert result["data-form-field"] == "true"
    end

    test "returns props for form field with controlled" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: true,
        form_field: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-value"] == "a"
      assert result["data-default-value"] == nil
      assert result["data-controlled"] == ""
      assert result["data-form-field"] == "true"
    end

    test "returns props with redirect" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        redirect: true
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-redirect"] != nil
    end

    test "returns props with positioning" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        positioning: %Corex.Positioning{placement: "bottom"}
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-position-placement"] == "bottom"
    end

    test "returns props with on_value_change" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        on_value_change: "phx-value-change"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-on-value-change"] == "phx-value-change"
    end

    test "returns props with on_value_change_client" do
      assigns = %{
        id: "test-select",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        on_value_change_client: "on-change-client"
      }

      result = Connect.props(Map.merge(ConnectProps.default_select(), assigns))
      assert result["data-on-value-change-client"] == "on-change-client"
    end
  end

  describe "Connect.item/1" do
    test "emits no redirect/to/new-tab attrs by default" do
      assigns = %{id: "s", value: "a", dir: "ltr", orientation: "vertical"}
      result = Connect.item(assigns)
      refute Map.has_key?(result, "data-to")
      refute Map.has_key?(result, "data-redirect")
      refute Map.has_key?(result, "data-new-tab")
    end

    test "emits data-to / data-redirect (atom mode) / data-new-tab" do
      assigns = %{
        id: "s",
        value: "a",
        dir: "ltr",
        orientation: "vertical",
        to: "/foo",
        redirect: :patch,
        new_tab: true
      }

      result = Connect.item(assigns)
      assert result["data-to"] == "/foo"
      assert result["data-redirect"] == "patch"
      assert Map.has_key?(result, "data-new-tab")
    end

    test "emits data-redirect=\"false\" when redirect is false" do
      assigns = %{
        id: "s",
        value: "a",
        dir: "ltr",
        orientation: "vertical",
        redirect: false
      }

      result = Connect.item(assigns)
      assert result["data-redirect"] == "false"
    end
  end

  describe "select/1 with options" do
    test "renders with controlled and multiple" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_controlled_multiple/1, [])
      assert html =~ ~r/data-scope="select"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with grouped collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_grouped/1, [])
      assert html =~ ~r/data-scope="select"/
    end

    test "hidden form input ignores LiveView patches to value and uses text type for used_input tracking" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :country,
        id: "user_country",
        name: "user[country]",
        value: "fra",
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Select.select field={@field} items={[%{label: "France", value: "fra"}]}>
              <:trigger>v</:trigger>
            </Corex.Select.select>
            """
          end,
          assigns
        )

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="user\[country\]")(?=[^>]*\bvalue="fra")[^>]*\bdata-part="value-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\bdata-part="value-input")[^>]*\bphx-mounted="[^"]*ignore_attrs[^"]*value/
    end

    test "multiple field form uses hidden select name[] and omits value-input name" do
      form = %Phoenix.HTML.Form{id: "post", name: "post", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :tags,
        id: "post_tags",
        name: "post[tags]",
        value: ["option1"],
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Select.select
              field={@field}
              multiple
              items={[%{label: "Option 1", value: "option1"}, %{label: "Option 2", value: "option2"}]}
            >
              <:trigger>Tags</:trigger>
            </Corex.Select.select>
            """
          end,
          assigns
        )

      assert html =~ ~r/name="post\[tags\]\[\]"/
      assert html =~ ~r/data-hidden-select-name="post\[tags\]\[\]"/
      assert html =~ ~r/data-part="hidden-select"/
      refute html =~ ~r/data-part="value-input"[^>]*name="post\[tags\]"/
    end
  end
end
