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

      assert result =~ ~r/data-default-value="\[&quot;m1&quot;\]"/
      assert result =~ ~r/data-multiple/
    end

    test "renders with errors" do
      html = render_component(&CorexTest.ComponentHelpers.render_combobox_with_errors/1, [])
      assert html =~ ~r/data-part="error"/
      assert html =~ ~r/Required/
    end

    test "renders with allow_custom_value and selection_behavior attrs" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox
              id="cb-attrs"
              allow_custom_value={true}
              selection_behavior="preserve"
              clear_on_empty={true}
              items={Corex.List.new([%{label: "A", value: "a"}])}
            >
              <:trigger>Pick</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          %{}
        )

      assert html =~ ~S/data-allow-custom-value/
      assert html =~ ~S/data-selection-behavior="preserve"/
      assert html =~ ~S/data-clear-on-empty/
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
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="\[\&quot;fra\&quot;\]"/
    end

    test "empty form field value encodes empty selection and hides clear trigger" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :country,
        id: "user_country",
        name: "user[country]",
        value: "",
        errors: []
      }

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
              <:clear_trigger>clear</:clear_trigger>
            </Corex.Combobox.combobox>
            """
          end,
          %{field: field}
        )

      refute html =~ ~r/\bdata-default-value=/
      assert html =~ ~r/data-part="hidden-input"[^>]*value=""/
      assert html =~ ~r/data-part="clear-trigger"/
      assert html =~ ~r/<button hidden[^>]*data-part="clear-trigger"/
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
          fn assigns ->
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
          fn assigns ->
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
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="\[\&quot;unknown_id\&quot;\]"/
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
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox multiple={true} field={@field} items={[%{value: "fra", label: "France"}, %{value: "bel", label: "Belgium"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-default-value="\[\&quot;fra\&quot;,\&quot;bel\&quot;\]"/
    end

    test "multiple form field omits submit name on empty sentinel when unused" do
      import Ecto.Changeset

      cs =
        {%{}, %{country: {:array, :string}}}
        |> cast(%{}, [:country])
        |> Map.put(:action, :validate)

      form = to_form(cs, as: :user, id: "user-form", action: :validate)
      assigns = %{field: form[:country]}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox multiple={true} field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          assigns
        )

      assert html =~ ~r/data-part="array-input"[^>]*data-empty/
      refute html =~ ~r/name="user\[country\]\[\]"[^>]*data-empty/
    end

    test "multiple form field names empty sentinel when field is used" do
      import Ecto.Changeset

      cs =
        {%{}, %{country: {:array, :string}}}
        |> cast(%{"country" => [""]}, [:country])
        |> Map.put(:action, :validate)

      form = to_form(cs, as: :user, id: "user-form", action: :validate)
      field = form[:country]
      assert used_input?(field)

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Combobox.combobox multiple={true} field={@field} items={[%{value: "fra", label: "France"}]}>
              <:trigger>v</:trigger>
            </Corex.Combobox.combobox>
            """
          end,
          %{field: field}
        )

      assert html =~ "data-field-used"
      assert html =~ ~r/data-empty[^>]*name="user\[country\]\[\]"/
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

  describe "Connect.trigger/1" do
    test "returns trigger attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", dir: "ltr", disabled: false, invalid: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "combobox:test-combobox:toggle-btn"
    end
  end

  describe "Connect.clear_trigger/1" do
    test "returns clear trigger attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", dir: "ltr", disabled: false, invalid: false}
      result = Connect.clear_trigger(assigns)
      assert result["id"] == "combobox:test-combobox:clear-btn"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["data-part"] == "positioner"
      assert result["id"] == "combobox:test-combobox:popper"
    end
  end

  describe "Connect.item_group/1" do
    test "returns item group attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", group_id: "group-1", dir: "ltr"}
      result = Connect.item_group(assigns)
      assert result["id"] == "combobox:test-combobox:optgroup:group-1"
    end
  end

  describe "Connect.item_group_label/1" do
    test "returns item group label attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", html_for: "group-1", dir: "ltr"}
      result = Connect.item_group_label(assigns)
      assert result["id"] == "combobox:test-combobox:optgroup-label:group-1"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes with zag-aligned id" do
      assigns = %{id: "test-combobox", value: "a", dir: "ltr"}
      result = Connect.item(assigns)
      assert result["id"] == "combobox:test-combobox:option:a"
    end

    test "omits data-to for disallowed href" do
      result =
        Connect.item(%{
          id: "test-combobox",
          value: "a",
          dir: "ltr",
          to: "javascript:alert(1)"
        })

      refute Map.has_key?(result, "data-to")
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
      assert result["data-default-value"] == ~s(["a"])
      assert result["data-value"] == nil
      assert result["data-controlled"] == nil
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = Corex.Combobox.set_open("my-combobox", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = Corex.Combobox.set_open("my-combobox", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Corex.Combobox.set_open(socket, "my-combobox", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end
end
