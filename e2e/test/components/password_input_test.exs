defmodule E2eWeb.PasswordInputTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.PasswordInputModel, as: PasswordInput

  @moduletag :password_input

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section accepts typed password", %{session: session} do
      session =
        ComponentBehaviorSpec.visit_ready(session, PasswordInput, :password_input, :anatomy)

      Enum.reduce(PasswordInput.anatomy_section_ids(), session, fn section_id, sess ->
        sess
        |> PasswordInput.wait_section_password_input_ready(section_id)
        |> PasswordInput.fill_input_in_section(section_id, "secret")
        |> PasswordInput.wait_input_value_in_section(section_id, "secret", timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "binding  -  Show reveals password text", %{session: session} do
      section = "password-input-api-binding-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(PasswordInput, :password_input, :api)
        |> PasswordInput.wait_section_password_input_ready(section)
        |> PasswordInput.fill_input_in_section(section, "secret")
        |> PasswordInput.click_button_in_section(section, "Show")

      assert_has(
        session,
        css(
          ~s|section##{section} [data-scope="password-input"][data-part="input"][type="text"]|,
          visible: :any
        )
      )
    end

    feature "server  -  Show via LiveView reveals password text", %{session: session} do
      section = "password-input-api-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(PasswordInput, :password_input, :api)
        |> PasswordInput.prepare_live_form()
        |> PasswordInput.wait_section_password_input_ready(section)
        |> PasswordInput.click_button_in_section(section, "Show")

      assert_has(
        session,
        css(
          ~s|section##{section} [data-scope="password-input"][data-part="input"][type="text"]|,
          visible: :any
        )
      )
    end
  end

  describe "events" do
    feature "server  -  visibility change appends log row", %{session: session} do
      section = "password-input-events-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(PasswordInput, :password_input, :events)
        |> PasswordInput.prepare_live_form()
        |> PasswordInput.wait_section_password_input_ready(section)

      before = PasswordInput.log_row_count(session, "password-input-events-log-server")

      session
      |> PasswordInput.click_visibility_trigger_in_section(section)
      |> PasswordInput.wait_log_rows_grew("password-input-events-log-server", before,
        timeout: 10_000
      )
    end
  end
end
