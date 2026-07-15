defmodule Corex.RadioGroupTest do
  use CorexTest.ComponentCase, async: true
  use Phoenix.Component

  import Corex.RadioGroup

  alias Corex.RadioGroup
  alias Corex.RadioGroup.Connect

  defp radio_group_form_field_with_errors(assigns) do
    ~H"""
    <.radio_group
      field={@field}
      class="radio-group"
      items={[{"a", "A"}]}
    >
      <:error :let={msg}>{msg}</:error>
    </.radio_group>
    """
  end

  defp radio_group_form_field_with_invalid_styling(assigns) do
    ~H"""
    <.radio_group
      field={@field}
      class="radio-group"
      items={[{"a", "A"}]}
      auto_invalid
    >
      <:error :let={msg}>{msg}</:error>
    </.radio_group>
    """
  end

  describe "radio_group/1" do
    test "renders" do
      html =
        render_component(&RadioGroup.radio_group/1,
          id: "test-radio-group",
          items: [["a", "Option A"]]
        )

      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with items as maps" do
      html =
        render_component(&RadioGroup.radio_group/1,
          id: "test-radio-group",
          items: [%{value: "a", label: "A"}, %{value: "b", label: "B", disabled: true}]
        )

      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/Option A|A/
    end

    test "renders with item_control slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_radio_group_with_indicator/1, [])
      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/Option A/
      assert html =~ ~r/Option B/
    end

    test "renders with controlled" do
      html = render_component(&CorexTest.ComponentHelpers.render_radio_group_controlled/1, [])
      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/data-controlled/
    end

    test "renders with custom item slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_radio_group_with_item_slot/1, [])
      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/data-value="x"/
      assert html =~ ~r/X/
    end

    test "renders with form" do
      html = render_component(&CorexTest.ComponentHelpers.render_radio_group_with_form/1, [])
      assert html =~ ~r/data-scope="radio-group"/
      assert html =~ ~r/data-form/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = RadioGroup.set_value("my-radio-group", "lorem")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = RadioGroup.set_value(socket, "my-radio-group", "duis")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "clear_value/1" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = RadioGroup.clear_value("my-radio-group")
    end
  end

  describe "clear_value/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = RadioGroup.clear_value(socket, "my-radio-group")
    end
  end

  describe "focus/1" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = RadioGroup.focus("my-radio-group")
    end
  end

  describe "focus/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = RadioGroup.focus(socket, "my-radio-group")
    end
  end

  describe "value/1" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = RadioGroup.value("my-radio-group")
    end
  end

  describe "value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = RadioGroup.value(socket, "my-radio-group")
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes without label" do
      assigns = %{id: "test-radio", dir: "ltr", orientation: "vertical", has_label: false}
      result = Connect.root(assigns)
      assert result["id"] == "radio-group:test-radio"
      assert result["data-scope"] == "radio-group"
      assert result["data-part"] == "root"
      assert result["role"] == "radiogroup"
      assert result["data-orientation"] == "vertical"
      refute Map.has_key?(result, "aria-labelledby")
    end

    test "includes aria-labelledby when has_label is true" do
      assigns = %{id: "test-radio", dir: "ltr", orientation: "vertical", has_label: true}
      result = Connect.root(assigns)
      assert result["aria-labelledby"] == "radio-group:test-radio:label"
    end

    test "computes root with horizontal orientation" do
      assigns = %{id: "test-radio", dir: "ltr", orientation: "horizontal", has_label: false}
      result = Connect.root(assigns)
      assert result["data-orientation"] == "horizontal"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-radio", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "radio-group:test-radio:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes" do
      assigns = %{id: "test-radio", dir: "ltr"}
      result = Connect.indicator(assigns)
      assert result["id"] == "radio-group:test-radio:indicator"
      assert result["data-part"] == "indicator"
      assert result["hidden"] == ""
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes when unchecked" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        disabled: false,
        invalid: false,
        checked: false
      }

      result = Connect.item(assigns)
      assert result["id"] == "radio-group:test-radio:item:opt-1"
      assert result["data-value"] == "opt-1"
      assert result["data-state"] == "unchecked"
    end

    test "returns item attributes when checked" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        disabled: false,
        invalid: false,
        checked: true
      }

      result = Connect.item(assigns)
      assert result["data-state"] == "checked"
    end
  end

  describe "Connect.item_control/1" do
    test "returns item control attributes" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        disabled: false,
        invalid: false,
        checked: false
      }

      result = Connect.item_control(assigns)
      assert result["id"] == "radio-group:test-radio:item-control:opt-1"
      assert result["data-value"] == "opt-1"
    end
  end

  describe "Connect.item_text/1" do
    test "returns item text attributes" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        disabled: false,
        invalid: false
      }

      result = Connect.item_text(assigns)
      assert result["id"] == "radio-group:test-radio:item-text:opt-1"
      assert result["data-part"] == "item-text"
      assert result["data-value"] == "opt-1"
    end
  end

  describe "Connect.item_hidden_input/1" do
    test "returns item hidden input attributes" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        name: "choice",
        form: nil,
        disabled: false,
        invalid: false,
        checked: false
      }

      result = Connect.item_hidden_input(assigns)
      assert result["id"] == "radio-group:test-radio:item-hidden-input:opt-1"
      assert result["type"] == "radio"
      assert result["value"] == "opt-1"
      assert result["name"] == "choice"
    end

    test "omits name when name is nil" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        name: nil,
        form: nil,
        disabled: false,
        invalid: false,
        checked: false
      }

      result = Connect.item_hidden_input(assigns)
      refute Map.has_key?(result, "name")
    end
  end

  describe "Connect.value_input/1" do
    test "returns value input attributes" do
      assigns = %{
        id: "test-radio",
        dir: "ltr",
        orientation: "vertical"
      }

      result = Connect.value_input(assigns)
      assert result["id"] == "radio-group:test-radio:value-input"
      assert result["data-part"] == "value-input"
      assert result["type"] == "text"
      assert result["hidden"] == "true"
      refute Map.has_key?(result, "name")
      refute Map.has_key?(result, "form")
    end
  end

  describe "radio_group/1 form field" do
    test "renders value-input and shows errors when field is used" do
      changeset =
        {%{}, %{choice: :string}}
        |> Ecto.Changeset.cast(%{"choice" => ""}, [:choice])
        |> Ecto.Changeset.validate_required([:choice])
        |> Map.put(:action, :validate)

      form = Phoenix.Component.to_form(changeset, as: :user, action: :validate)
      field = form[:choice]

      html = render_component(&radio_group_form_field_with_errors/1, %{field: field})

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="user\[choice\]")(?=[^>]*\bdata-part="value-input")/

      assert html =~ ~r/data-part="error"/
      assert html =~ "blank"
      refute html =~ ~r/\bdata-invalid=""/
    end

    test "sets data-invalid when auto_invalid and field has visible errors" do
      changeset =
        {%{}, %{choice: :string}}
        |> Ecto.Changeset.cast(%{"choice" => ""}, [:choice])
        |> Ecto.Changeset.validate_required([:choice])
        |> Map.put(:action, :validate)

      form = Phoenix.Component.to_form(changeset, as: :user, action: :validate)
      field = form[:choice]

      html = render_component(&radio_group_form_field_with_invalid_styling/1, %{field: field})

      assert html =~ ~S(data-invalid="")
    end

    test "keeps unused field errors hidden after sibling unused params" do
      changeset =
        {%{}, %{choice: :string, name: :string}}
        |> Ecto.Changeset.cast(%{"_unused_choice" => "", "name" => "Ada"}, [:choice, :name])
        |> Ecto.Changeset.validate_required([:choice])
        |> Map.put(:action, :validate)

      form = Phoenix.Component.to_form(changeset, as: :user, action: :validate)
      field = form[:choice]
      refute Phoenix.Component.used_input?(field)

      html = render_component(&radio_group_form_field_with_errors/1, %{field: field})

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="user\[choice\]")(?=[^>]*\bdata-part="value-input")/

      refute html =~ ~r/data-part="error"/
      refute html =~ "data-field-used"
    end
  end

  describe "Connect.props/1" do
    test "returns props when controlled" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        controlled: true,
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        invalid: false,
        read_only: false,
        name: nil,
        form: nil,
        required: false,
        on_value_change: nil,
        on_value_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-value"] == "opt-1"
      assert result["data-default-value"] == nil
      assert result["data-controlled"] == ""
    end

    test "returns props when form_field" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        form_field: true,
        controlled: false,
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        invalid: false,
        read_only: false,
        name: "user[choice]",
        form: nil,
        required: false,
        on_value_change: nil,
        on_value_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == "opt-1"
      assert result["data-value"] == nil
      assert result["data-form-field"] == "true"
    end

    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-radio",
        value: "opt-1",
        controlled: false,
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        invalid: false,
        read_only: false,
        name: nil,
        form: nil,
        required: false,
        on_value_change: nil,
        on_value_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == "opt-1"
    end
  end
end
