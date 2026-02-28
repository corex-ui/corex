defmodule Corex.FormTest.Schema do
  use Ecto.Schema

  embedded_schema do
    field(:name, :string)
  end
end

defmodule Corex.FormTest do
  use ExUnit.Case, async: true

  alias Corex.Form
  alias Corex.FormTest.Schema
  import Phoenix.Component

  describe "get_form_id/1" do
    test "returns id from Ecto.Changeset" do
      changeset = Ecto.Changeset.change(%Schema{})
      id = Form.get_form_id(changeset)
      assert is_binary(id)
      assert id == Phoenix.Component.to_form(changeset).id
    end

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
