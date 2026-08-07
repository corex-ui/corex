defmodule E2eWeb.TagsInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby
  @moduletag :tags_input

  alias E2eWeb.TagsInputModel, as: TagsInput

  describe "static controller" do
    feature "phoenix form submit with default tags shows flash", %{session: session} do
      session
      |> TagsInput.goto_form(:static)
      |> TagsInput.wait_form_tags_input_ready("tags-input-form-phoenix")
      |> TagsInput.submit_form(:static, :phoenix)
      |> TagsInput.see_flash("tags=")
    end

    feature "tags input form has no A11y violations", %{session: session} do
      session
      |> TagsInput.goto_form(:static)
      |> TagsInput.check_accessibility()
    end
  end

  describe "live" do
    feature "phoenix form submit shows success toast", %{session: session} do
      session
      |> TagsInput.goto_form(:live)
      |> TagsInput.wait_form_tags_input_ready("tags-input-live-form-phoenix")
      |> TagsInput.submit_form(:live, :phoenix)
      |> TagsInput.see_flash("tags=")
    end

    feature "tags input live form has no A11y violations", %{session: session} do
      session
      |> TagsInput.goto_form(:live)
      |> TagsInput.check_accessibility()
    end
  end
end
