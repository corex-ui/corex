defmodule E2eWeb.DatePickerTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.DatePickerModel, as: DatePicker

  @moduletag :date_picker

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section mounts and exposes inputs", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, DatePicker, :date_picker, :anatomy)

      Enum.reduce(DatePicker.anatomy_section_ids(), session, fn section_id, sess ->
        sess =
          sess
          |> DatePicker.wait_section_date_picker_ready(section_id)
          |> DatePicker.open_date_picker_in_section(section_id)

        assert_has(
          sess,
          css(
            ~s|section##{section_id} [data-scope="date-picker"][data-part="content"][data-state="open"]|,
            visible: :any
          )
        )

        DatePicker.close_date_picker_in_section(sess, section_id)
      end)
    end
  end

  describe "api" do
    feature "set value (binding)  -  January 15 updates input", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :api)
        |> DatePicker.wait_root_date_picker_ready("date-picker-api-sv-client")

      session
      |> DatePicker.click_button_in_section(
        "date-picker-api-set-value-binding",
        "Set to 2024-01-15"
      )
      |> DatePicker.wait_input_value_in_section(
        "date-picker-api-set-value-binding",
        "2024-01-15",
        timeout: 8_000
      )
    end

    feature "set value (js)  -  January 15 via CustomEvent", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :api)
        |> DatePicker.wait_root_date_picker_ready("date-picker-api-sv-js")

      session
      |> DatePicker.click_button_in_section(
        "date-picker-api-set-value-js",
        "Set to 2024-01-15"
      )
      |> DatePicker.wait_input_value_in_section(
        "date-picker-api-set-value-js",
        "2024-01-15",
        timeout: 8_000
      )
    end

    feature "set value (server)  -  January 15 via LiveView", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :api)
        |> DatePicker.prepare_live_form()
        |> DatePicker.wait_root_date_picker_ready("date-picker-api-sv-server")

      session
      |> DatePicker.click_button_in_section(
        "date-picker-api-set-value-server",
        "Set to 2024-01-15"
      )
      |> DatePicker.wait_input_value_in_section(
        "date-picker-api-set-value-server",
        "2024-01-15",
        timeout: 8_000
      )
    end
  end

  describe "events" do
    feature "server  -  opening calendar appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :events)
        |> DatePicker.prepare_live_form()
        |> DatePicker.wait_root_date_picker_ready("date-picker-e-so")

      refute has?(session, css("#date-picker-events-log-so tr[data-part='row']"))

      session
      |> DatePicker.open_date_picker_by_host_id("date-picker-e-so")
      |> DatePicker.wait_for_has(css("#date-picker-events-log-so tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end

    feature "client  -  opening calendar appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :events)
        |> DatePicker.prepare_live_form()
        |> DatePicker.wait_root_date_picker_ready("date-picker-e-co")

      refute DatePicker.date_picker_events_client_open_log_has_row?(session)

      session
      |> DatePicker.open_date_picker_by_host_id("date-picker-e-co")
      |> DatePicker.wait_for_has(css("#date-picker-events-log-co tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(DatePicker, :date_picker, :playground)
      |> DatePicker.wait_playground_date_picker_ready()
    end
  end
end
