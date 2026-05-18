defmodule Corex.ComponentTranslationsTest do
  use ExUnit.Case, async: true

  alias Corex.Combobox.Translation, as: ComboboxTranslation
  alias Corex.DatePicker.Translation, as: DatePickerTranslation
  alias Corex.Pagination.Translation, as: PaginationTranslation
  alias Corex.Select.Translation, as: SelectTranslation
  alias Corex.TagsInput.Translation, as: TagsInputTranslation
  alias Corex.Timer.Translation, as: TimerTranslation

  describe "Combobox.Translation" do
    test "resolve nil returns defaults" do
      t = ComboboxTranslation.resolve(nil)
      assert t.placeholder == "Select"
      assert t.empty == "No results"
    end

    test "resolve partial struct merges" do
      t = ComboboxTranslation.resolve(%ComboboxTranslation{placeholder: "Pick"})
      assert t.placeholder == "Pick"
      assert t.empty == "No results"
    end

    test "resolve map merges" do
      t = ComboboxTranslation.resolve(%{trigger: "Open"})
      assert t.trigger == "Open"
      assert t.placeholder == "Select"
    end
  end

  describe "Select.Translation" do
    test "resolve nil and partial" do
      assert SelectTranslation.resolve(nil).placeholder == "Select"
      assert SelectTranslation.resolve(%SelectTranslation{placeholder: "X"}).placeholder == "X"
    end
  end

  describe "TagsInput.Translation" do
    test "resolve and helpers" do
      t = TagsInputTranslation.resolve(nil)
      assert t.placeholder =~ "tag"
      assert TagsInputTranslation.format_tag("Delete %{tag}", "a") == "Delete a"
      assert is_map(TagsInputTranslation.to_camel_map(t))
    end

    test "partial override" do
      t = TagsInputTranslation.resolve(%TagsInputTranslation{placeholder: "Keywords"})
      assert t.placeholder == "Keywords"
    end
  end

  describe "Timer.Translation" do
    test "resolve and to_camel_map" do
      t = TimerTranslation.resolve(nil)
      assert t.area_label == "Timer"
      assert TimerTranslation.to_camel_map(t) == %{"areaLabel" => "Timer"}
    end
  end

  describe "Pagination.Translation" do
    test "resolve and to_camel_map" do
      t = PaginationTranslation.resolve(nil)
      assert t.root_label == "Pagination"
      map = PaginationTranslation.to_camel_map(t)
      assert map["prevTriggerLabel"] == "Previous page"
    end

    test "partial override" do
      t =
        PaginationTranslation.resolve(%PaginationTranslation{
          next_trigger_label: "Next"
        })

      assert t.next_trigger_label == "Next"
      assert t.prev_trigger_label == "Previous page"
    end
  end

  describe "DatePicker.Translation" do
    test "resolve nil and partial" do
      t = DatePickerTranslation.resolve(nil)
      assert t.input == "Select date"
      assert is_binary(t.open_calendar)

      partial =
        DatePickerTranslation.resolve(%DatePickerTranslation{input: "Pick a day"})

      assert partial.input == "Pick a day"
      assert partial.range_start == "From"
    end

    test "to_camel_map includes keys" do
      t = DatePickerTranslation.resolve(nil)
      map = DatePickerTranslation.to_camel_map(t)
      assert map["openCalendar"] == t.open_calendar
      assert map["rangeEnd"] == t.range_end
    end
  end
end
