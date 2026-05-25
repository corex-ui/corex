defmodule Corex.ComboboxTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Combobox.Connect
  alias Test.Support.ConnectProps

  describe "combobox/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox/1, [])
      assert html =~ ~r/data-scope="combobox"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with collection and empty slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_items/1, [])
      assert html =~ ~r/data-part="empty"/
      assert html =~ ~r/data-part="item".*data-value="a"/
      assert html =~ ~r/A/
    end

    test "renders with custom item slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_item_slot/1, [])
      assert html =~ ~r/data-part="item-text"/
      assert html =~ ~r/X!/
    end

    test "renders clear_trigger in the dom when slot is set so the client can toggle visibility" do
      html =
        render_component(
          &CorexTest.ComponentHelpers.render_combobox_with_clear_and_indicator/1,
          []
        )

      assert html =~ ~r/data-part="clear-trigger"/
      assert html =~ ~r/hidden/
      assert html =~ ~r/data-part="item-indicator"/
    end

    test "renders with grouped collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_grouped/1, [])
      assert html =~ ~r/data-part="item-group"/
      assert html =~ ~r/item-group-label/
    end

    test "renders with filter false" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_filter_false/1, [])
      assert html =~ ~r/data-scope="combobox"/
      assert html =~ ~r/data-value="c"/
    end

    test "renders with multiple and initial value" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_combobox_default_multiple/1, [])

      assert result =~ ~r/data-default-value="m1"/
      assert result =~ ~r/data-multiple/
    end

    test "renders with errors" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_errors/1, [])
      assert html =~ ~r/data-part="error"/
      assert html =~ ~r/Required/
    end

    test "renders open combobox" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox
              id="cb-open"
              open
              value="a"
              items={Corex.List.new([%{label: "A", value: "a"}, %{label: "B", value: "b"}])}
            >
              <:trigger>Pick</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-part="positioner")
    end

    test "Connect.props with filter false sets data-filter to nil" do
      assigns =
        Map.merge(ConnectProps.default_combobox(), %{
          id: "test",
          items: [%{value: "a", label: "A"}],
          value: [],
          dir: "ltr",
          filter: false
        })

      result = Connect.props(assigns)
      assert result["data-filter"] == nil
    end

    test "renders with field as string value matching label" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :country,
        id: "user_country",
        name: "user[country]",
        value: "France",
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="fra"/
    end

    test "visible input renders selected label as value attribute to survive morphdom patches" do
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
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/<input\b[^>]*\bvalue="France"[^>]*\bdata-part="input"/
    end

    test "visible input renders empty value attribute when no selection" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox id="cb" items={[%{value: "a", label: "A"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          %{}
        )

      assert html =~ ~r/<input\b[^>]*\bvalue=""[^>]*\bdata-part="input"/
    end

    test "hidden form input ignores LiveView patches to value (hook owns submitted value)" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :currency,
        id: "user_currency",
        name: "user[currency]",
        value: "eur",
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "eur", label: "Euro"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="user\[currency\]")(?=[^>]*\bvalue="eur")[^>]*\bdata-part="hidden-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\bdata-part="hidden-input")[^>]*\bphx-mounted="[^"]*ignore_attrs[^"]*value/

      refute html =~ "data-name=\"user[currency]\""
      refute html =~ "data-form=\"user\""
    end

    test "renders with field as string value without matching collection" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :country,
        id: "user_country",
        name: "user[country]",
        value: "unknown_id",
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="unknown_id"/
    end

    test "renders with field as multiple values" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :country,
        id: "user_country",
        name: "user[country]",
        value: ["fra", "bel"],
        errors: []
      }

      assigns = %{field: field}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.Combobox.combobox multiple={true} field={@field} items={[%{value: "fra", label: "France"}, %{value: "bel", label: "Belgium"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="fra,bel"/
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-combobox", invalid: false, read_only: false}
      result = Connect.root(assigns)
      assert result["id"] == "combobox:test-combobox"
      assert result["data-scope"] == "combobox"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{
        id: "test-combobox",
        dir: "ltr",
        required: false,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.label(assigns)
      assert result["id"] == "combobox:test-combobox:label"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-combobox", dir: "ltr", disabled: false, invalid: false}
      result = Connect.control(assigns)
      assert result["id"] == "combobox:test-combobox:control"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes" do
      assigns = %{
        id: "test-combobox",
        dir: "ltr",
        disabled: false,
        invalid: false,
        placeholder: nil,
        auto_focus: false
      }

      result = Connect.input(assigns)
      assert result["data-part"] == "input"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes" do
      assigns = %{id: "test-combobox", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["data-part"] == "positioner"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-combobox", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["data-part"] == "content"
    end
  end

  describe "Connect.props/1" do
    test "returns props with data-default-value for selection" do
      assigns = %{
        id: "test-combobox",
        items: [%{value: "a", label: "A"}],
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(ConnectProps.default_combobox(), assigns))
      assert result["data-default-value"] == "a"
      assert result["data-value"] == nil
      assert result["data-controlled"] == nil
    end
  end
end
