defmodule Corex.DatePickerTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.DatePicker
  alias Corex.DatePicker.Connect

  describe "date_picker/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_date_picker/1, [])
      assert html =~ ~r/data-scope="date-picker"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = DatePicker.set_value("my-date-picker", "2025-02-22")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = DatePicker.set_value(socket, "my-date-picker", "2025-02-22")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect" do
    test "root/1 returns root attributes" do
      result = Connect.root(%{id: "test-dp", dir: "ltr"})
      assert result["id"] == "date-picker:test-dp"
      assert result["data-part"] == "root"
    end

    test "label/1 returns label attributes" do
      result = Connect.label(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "label"
      assert result["htmlFor"] == "date-picker:test-dp:input:0"
    end

    test "control/1 returns control attributes" do
      result = Connect.control(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "control"
    end

    test "input/1 returns input attributes" do
      result = Connect.input(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "input"
    end

    test "trigger/1 returns trigger attributes" do
      result = Connect.trigger(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "trigger"
    end

    test "positioner/1 returns positioner attributes" do
      result = Connect.positioner(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "positioner"
    end

    test "content/1 returns content attributes" do
      result = Connect.content(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "content"
      assert result["hidden"] == true
    end

    test "props/1 returns props when uncontrolled" do
      assigns = %{
        id: "test-dp",
        controlled: false,
        value: "2025-02-22",
        locale: "en",
        time_zone: "UTC",
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_props(), assigns))
      assert result["data-default-value"] == "2025-02-22"
      assert result["data-value"] == nil
    end

    test "props/1 returns props when controlled" do
      assigns = %{
        id: "test-dp",
        controlled: true,
        value: "2025-02-22",
        locale: "en",
        time_zone: "UTC",
        dir: "ltr"
      }

      result = Connect.props(Map.merge(default_props(), assigns))
      assert result["data-default-value"] == nil
      assert result["data-value"] == "2025-02-22"
    end
  end

  defp default_props do
    %{
      name: nil,
      disabled: false,
      read_only: false,
      required: false,
      invalid: false,
      outside_day_selectable: false,
      close_on_select: nil,
      min: nil,
      max: nil,
      focused_value: nil,
      num_of_months: nil,
      start_of_week: nil,
      fixed_weeks: nil,
      selection_mode: nil,
      placeholder: nil,
      default_view: nil,
      min_view: nil,
      max_view: nil,
      positioning: nil,
      on_value_change: nil,
      on_focus_change: nil,
      on_view_change: nil,
      on_visible_range_change: nil,
      on_open_change: nil,
      trigger_aria_label: nil,
      input_aria_label: nil
    }
  end
end
