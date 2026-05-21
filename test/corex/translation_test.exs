defmodule Corex.SampleTranslation do
  use Corex.Translation, fields: [title: "Title", hint: "Hint"]
end

defmodule Corex.TranslationTest do
  use ExUnit.Case, async: true

  alias Corex.SampleTranslation
  alias Corex.Toast.Action
  alias Corex.Translation
  alias Phoenix.LiveView.JS

  describe "Corex.Translation.resolve_with_overrides/3" do
    test "ignores nil and empty overrides" do
      t =
        Translation.resolve_with_overrides(
          SampleTranslation,
          %SampleTranslation{title: "A"},
          %{hint: nil, title: ""}
        )

      assert t.title == "A"
      assert t.hint == "Hint"
    end
  end

  describe "Corex.Translation.take/2" do
    test "nil uses default" do
      assert Translation.take(nil, "default") == "default"
    end

    test "empty string uses default" do
      assert Translation.take("", "default") == "default"
    end

    test "value wins over default" do
      assert Translation.take("custom", "default") == "custom"
    end
  end

  describe "Corex.Toast.Action" do
    test "builds struct with required keys and optional class" do
      js = JS.push("evt")
      action = %Action{label: "Undo", js: js, class: "toast-action"}
      assert action.label == "Undo"
      assert action.class == "toast-action"
      assert %JS{} = action.js
    end

    test "enforces keys" do
      assert_raise ArgumentError, fn ->
        struct!(Action, label: "only")
      end
    end
  end
end
