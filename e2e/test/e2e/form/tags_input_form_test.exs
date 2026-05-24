defmodule E2e.Form.TagsInputFormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component

  alias E2e.Form.TagsInputForm

  test "to_form exposes tags field name and id for changeset form" do
    cs = TagsInputForm.changeset(%TagsInputForm{}, %{})
    f = to_form(cs, as: :tags_input_changeset, id: "tags-input-changeset-form")
    assert f[:tags].name == "tags_input_changeset[tags]"
    assert f[:tags].id == "tags-input-changeset-form_tags"
  end

  test "to_form exposes tags field when using changeset_validate with changeset as" do
    cs = TagsInputForm.changeset_validate(%TagsInputForm{}, %{})
    f = to_form(cs, as: :tags_input_changeset, id: "tags-input-changeset-form")
    assert f[:tags].name == "tags_input_changeset[tags]"
  end

  test "changeset applies tags list" do
    cs = TagsInputForm.changeset(%TagsInputForm{}, %{"tags" => ["a", "b", "c"]})
    assert cs.valid?
    assert Ecto.Changeset.apply_changes(cs).tags == ["a", "b", "c"]
  end

  test "changeset_validate rejects semicolons in tag values" do
    cs = TagsInputForm.changeset_validate(%TagsInputForm{}, %{"tags" => ["a;b"]})
    refute cs.valid?
  end

  test "changeset_validate accepts tag list" do
    cs = TagsInputForm.changeset_validate(%TagsInputForm{}, %{"tags" => ["a", "b", "c"]})
    assert cs.valid?
  end

  test "changeset rejects more than three tags" do
    cs = TagsInputForm.changeset(%TagsInputForm{}, %{"tags" => ["a", "b", "c", "d"]})
    refute cs.valid?
    assert {"must have at most 3 tags", _} = Keyword.fetch!(cs.errors, :tags)
  end

  test "changeset_validate rejects more than three tags" do
    cs = TagsInputForm.changeset_validate(%TagsInputForm{}, %{"tags" => ["a", "b", "c", "d"]})
    refute cs.valid?
    assert {"must have at most 3 tags", _} = Keyword.fetch!(cs.errors, :tags)
  end

  test "changeset_validate rejects empty tags list from array submit" do
    cs = TagsInputForm.changeset_validate(%TagsInputForm{}, %{"tags" => [""]})
    refute cs.valid?
    assert {"can't be blank", _} = Keyword.fetch!(cs.errors, :tags)
  end
end
