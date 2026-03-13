defmodule Corex.SelectTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Select.Connect

  describe "select/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_select/1, [])
      assert html =~ ~r/data-scope="select"/
      assert html =~ ~r/data-part="root"/
    end

    test "has data-js=pending on root" do
      html = render_component(&CorexTest.ComponentHelpers.render_select/1, [])
      assert html =~ ~r/data-js="pending"/
    end

    test "controlled select has data-value" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_controlled_multiple/1, [])
      assert html =~ ~r/data-value="a"/
    end

    test "uncontrolled select with value has data-default-value" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_uncontrolled_value/1, [])
      assert html =~ ~r/data-default-value="a"/
    end

    test "with field from form has correct name and id" do
      html = render_component(&CorexTest.ComponentHelpers.render_select_with_field/1, [])
      assert html =~ ~r/name="user\[country\]"/
      assert html =~ ~r/id="user_country"/
    end

    test "uses placeholder for aria-label and placeholder span when no selection" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_select_with_opts/1,
          placeholder: "Select an option"
        )

      assert html =~ ~r/aria-label="Select an option"/
      assert html =~ "Select an option"
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
        items: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["id"] == "test-select"
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-value"] == "a"
    end

    test "returns props with redirect" do
      assigns = %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        redirect: true
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-redirect"] != nil
    end

    test "returns props with positioning" do
      assigns = %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        positioning: %{placement: "bottom"}
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-positioning"] =~ "placement"
    end

    test "returns props with on_value_change" do
      assigns = %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        on_value_change: "phx-value-change"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-on-value-change"] == "phx-value-change"
    end

    test "returns props with on_value_change_client" do
      assigns = %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        controlled: false,
        value: [],
        dir: "ltr",
        on_value_change_client: "on-change-client"
      }

      result = Connect.props(Map.merge(default_select_props(), assigns))
      assert result["data-on-value-change-client"] == "on-change-client"
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
  end

  defp default_select_props do
    %{
      id: "test-select",
      items: [%{id: "a", label: "A"}],
      invalid: false,
      read_only: false,
      disabled: false,
      name: nil,
      placeholder: nil,
      close_on_select: true,
      loop_focus: false,
      multiple: false,
      form: nil,
      required: false,
      value: [],
      controlled: false,
      dir: "ltr",
      positioning: nil,
      on_value_change: nil,
      on_value_change_client: nil,
      redirect: false,
      redirect_new_tab: false
    }
  end
end
