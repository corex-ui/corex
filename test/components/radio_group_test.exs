defmodule Corex.RadioGroupTest do
  use ExUnit.Case, async: true

  alias Corex.RadioGroup.Connect

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
  end
end
