defmodule Corex.DatePickerTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.DatePicker
  alias Corex.DatePicker.Connect
  alias Corex.DatePicker.Translation, as: DatePickerTranslation

  describe "date_picker/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_date_picker/1, [])
      assert html =~ ~r/data-scope="date-picker"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
      assert html =~ ~r/phx-mounted=/
    end
  end

  describe "date_picker/1 direct rendering" do
    test "renders directly with all attributes and translations" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.DatePicker.date_picker
              id="dp1"
              name="dp_name"
              value={["2025-01-01", "2025-01-02"]}
              controlled={true}
              locale="fr-FR"
              time_zone="Europe/Paris"
              disabled={true}
              read_only={true}
              min="2025-01-01"
              max="2025-12-31"
              selection_mode="multiple"
              format="DD/MM/YYYY"
              start_of_week={1}
              fixed_weeks={true}
              close_on_select={false}
              dir="rtl"
              on_value_change="change"
              on_value_change_client="change_client"
            >
              <:label>Date</:label>
            </Corex.DatePicker.date_picker>
            """
          end,
          %{}
        )

      assert html =~ "Date"
      assert html =~ "dp_name"
      assert html =~ "data-disabled"
      assert html =~ "data-locale=\"fr-FR\""
      assert html =~ "data-time-zone=\"Europe/Paris\""
      assert html =~ "data-selection-mode=\"multiple\""
    end
  end

  describe "date_picker/1 with field" do
    test "normalizes Date structs and other types" do
      form = Phoenix.Component.to_form(%{"d1" => ~D[2025-01-01], "d2" => 123}, as: :user)

      html1 =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.DatePicker.date_picker field={@form[:d1]} />
            """
          end,
          %{form: form}
        )

      assert html1 =~ "data-default-value=\"2025-01-01\""

      html2 =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.DatePicker.date_picker field={@form[:d2]} />
            """
          end,
          %{form: form}
        )

      assert html2 =~ "data-scope=\"date-picker\""
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
      assert result["data-state"] == "closed"
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
      assert result["id"] == "date-picker:test-dp:input:0"
    end

    test "trigger/1 returns trigger attributes" do
      result = Connect.trigger(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "trigger"
    end

    test "positioner/1 returns positioner attributes" do
      result = Connect.positioner(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "positioner"
      assert result["style"] =~ "translate3d(0, -100vh, 0)"
      assert result["style"] =~ "position: fixed"
    end

    test "content/1 returns content attributes" do
      result = Connect.content(%{id: "test-dp", dir: "ltr"})
      assert result["data-part"] == "content"
      assert result["hidden"] == true
      assert result["data-state"] == "closed"
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

    test "props/1 encodes data-translation when a translation is present" do
      assigns = %{
        id: "test-dp",
        controlled: false,
        value: "2025-02-22",
        locale: "en",
        time_zone: "UTC",
        dir: "ltr",
        translation: Corex.DatePicker.default_translation()
      }

      result = Connect.props(Map.merge(default_props(), assigns))
      assert is_binary(result["data-translation"])
      assert result["data-translation"] =~ "openCalendar"
    end

    test "props/1 encodes translation open_calendar, close_calendar, and input in data-translation JSON" do
      base = DatePicker.default_translation()

      translation = %DatePickerTranslation{
        base
        | open_calendar: "Pick a date",
          close_calendar: "Pick a date",
          input: "Event date"
      }

      assigns = %{
        id: "test-dp",
        controlled: false,
        value: "2025-02-22",
        locale: "en",
        time_zone: "UTC",
        dir: "ltr",
        translation: translation
      }

      result = Connect.props(Map.merge(default_props(), assigns))
      decoded = Jason.decode!(result["data-translation"])
      assert decoded["openCalendar"] == "Pick a date"
      assert decoded["closeCalendar"] == "Pick a date"
      assert decoded["input"] == "Event date"
    end

    test "props/1 includes flattened positioning" do
      assigns = %{
        id: "test-dp",
        controlled: false,
        value: "2025-02-22",
        locale: "en",
        time_zone: "UTC",
        dir: "ltr",
        positioning: %Corex.Positioning{strategy: "absolute", placement: "top-start", gutter: 12}
      }

      result = Connect.props(Map.merge(default_props(), assigns))
      assert result["data-position-strategy"] == "absolute"
      assert result["data-position-placement"] == "top-start"
      assert result["data-position-gutter"] == "12"
      refute result["data-positioning"]
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
      start_of_week: nil,
      fixed_weeks: nil,
      selection_mode: nil,
      placeholder: nil,
      view: nil,
      min_view: nil,
      max_view: nil,
      positioning: nil,
      on_value_change: nil,
      on_focus_change: nil,
      on_view_change: nil,
      on_visible_range_change: nil,
      on_open_change: nil,
      on_value_change_client: nil,
      on_open_change_client: nil,
      max_selected_dates: nil,
      translation: nil
    }
  end
end
