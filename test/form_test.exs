defmodule Corex.FormTest do
  use ExUnit.Case, async: true

  alias Corex.Form
  import Phoenix.Component

  describe "get_form_id/1" do
    test "returns id from Phoenix.HTML.Form" do
      form = to_form(%{}, as: :user)
      assert Form.get_form_id(form) == form.id
      assert is_binary(Form.get_form_id(form))
    end

    test "raises for invalid input" do
      assert_raise ArgumentError, ~r/expected Ecto.Changeset or Phoenix.HTML.Form/, fn ->
        Form.get_form_id(%{})
      end

      assert_raise ArgumentError, ~r/expected Ecto.Changeset or Phoenix.HTML.Form/, fn ->
        Form.get_form_id("not a form")
      end
    end
  end
end
