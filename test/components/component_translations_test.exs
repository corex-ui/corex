defmodule Corex.ComponentTranslationsTest do
  use ExUnit.Case, async: true

  alias Corex.ColorPicker.Translation, as: ColorPickerTranslation
  alias Corex.Combobox.Translation, as: ComboboxTranslation
  alias Corex.DataTable.Translation, as: DataTableTranslation
  alias Corex.DatePicker.Translation, as: DatePickerTranslation
  alias Corex.Dialog.Translation, as: DialogTranslation
  alias Corex.Editable.Translation, as: EditableTranslation
  alias Corex.FileUpload.Translation, as: FileUploadTranslation
  alias Corex.FloatingPanel.Translation, as: FloatingPanelTranslation
  alias Corex.NumberInput.Translation, as: NumberInputTranslation
  alias Corex.Pagination.Translation, as: PaginationTranslation
  alias Corex.PasswordInput.Translation, as: PasswordInputTranslation
  alias Corex.PinInput.Translation, as: PinInputTranslation
  alias Corex.Select.Translation, as: SelectTranslation
  alias Corex.TagsInput.Translation, as: TagsInputTranslation
  alias Corex.Timer.Translation, as: TimerTranslation
  alias Corex.Toast.Translation, as: ToastTranslation

  describe "Dialog.Translation" do
    test "resolve nil and partial" do
      t = DialogTranslation.resolve(nil)
      assert t.close == "Close"
      assert t.label == "Dialog"

      partial =
        DialogTranslation.resolve(%DialogTranslation{
          close: "Dismiss",
          label: "Modal"
        })

      assert partial.close == "Dismiss"
      assert partial.label == "Modal"
    end
  end

  describe "Corex.Translation.resolve_with_overrides/3" do
    test "merges attr overrides after defaults" do
      t =
        Corex.Translation.resolve_with_overrides(
          DialogTranslation,
          nil,
          %{label: "Custom", close: nil}
        )

      assert t.label == "Custom"
      assert t.close == "Close"
    end

    test "partial translation plus overrides" do
      t =
        Corex.Translation.resolve_with_overrides(
          DialogTranslation,
          %DialogTranslation{close: "Dismiss"},
          %{label: "Modal"}
        )

      assert t.close == "Dismiss"
      assert t.label == "Modal"
    end
  end

  describe "Toast.Translation" do
    test "resolve nil and partial" do
      assert ToastTranslation.resolve(nil).info == "Info"
      assert ToastTranslation.resolve(%ToastTranslation{error: "Failed"}).error == "Failed"
    end
  end

  describe "PasswordInput.Translation" do
    test "resolve nil and partial" do
      t = PasswordInputTranslation.resolve(nil)
      assert t.toggle_visibility =~ "visibility"

      partial =
        PasswordInputTranslation.resolve(%PasswordInputTranslation{
          toggle_visibility: "Show"
        })

      assert partial.toggle_visibility == "Show"
    end
  end

  describe "PinInput.Translation" do
    test "resolve nil and partial" do
      t = PinInputTranslation.resolve(nil)
      assert t.digit =~ "%{digit}"

      partial = PinInputTranslation.resolve(%PinInputTranslation{digit: "Cell %{digit}"})
      assert partial.digit == "Cell %{digit}"
    end
  end

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

    test "resolve partial struct merges defaults" do
      t = TimerTranslation.resolve(%TimerTranslation{area_label: "Countdown"})
      assert t.area_label == "Countdown"
      assert TimerTranslation.to_camel_map(t) == %{"areaLabel" => "Countdown"}
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

  describe "ColorPicker.Translation" do
    test "resolve nil returns defaults" do
      t = ColorPickerTranslation.resolve(nil)
      assert t.hex == "Hex color value"
      assert t.alpha == "Alpha (opacity) value"
    end

    test "resolve partial struct merges" do
      t = ColorPickerTranslation.resolve(%ColorPickerTranslation{hex: "Hex code"})
      assert t.hex == "Hex code"
      assert t.alpha == "Alpha (opacity) value"
    end
  end

  describe "DataTable.Translation" do
    test "resolve nil returns defaults" do
      t = DataTableTranslation.resolve(nil)
      assert t.actions == "Actions"
      assert t.select_all == "Select all"
      assert t.select_row == "Select row"
    end

    test "resolve partial struct merges" do
      t = DataTableTranslation.resolve(%DataTableTranslation{actions: "Options"})
      assert t.actions == "Options"
      assert t.select_all == "Select all"
    end
  end

  describe "Editable.Translation" do
    test "resolve nil returns defaults" do
      t = EditableTranslation.resolve(nil)
      assert t.input == "editable input"
      assert t.edit == "edit"
      assert t.submit == "submit"
      assert t.cancel == "cancel"
    end

    test "resolve partial struct merges" do
      t = EditableTranslation.resolve(%EditableTranslation{edit: "Edit text", submit: "Save"})
      assert t.edit == "Edit text"
      assert t.submit == "Save"
      assert t.cancel == "cancel"
    end
  end

  describe "FileUpload.Translation" do
    test "resolve nil returns defaults" do
      t = FileUploadTranslation.resolve(nil)
      assert t.dropzone == "Drag your file(s) here"
      assert t.open == "Upload file(s)"
    end

    test "resolve partial struct merges" do
      t = FileUploadTranslation.resolve(%FileUploadTranslation{dropzone: "Drop files here"})
      assert t.dropzone == "Drop files here"
      assert t.open == "Upload file(s)"
    end
  end

  describe "FloatingPanel.Translation" do
    test "resolve nil returns defaults" do
      t = FloatingPanelTranslation.resolve(nil)
      assert t.minimize == "Minimize window"
      assert t.maximize == "Maximize window"
      assert t.restore == "Restore window"
      assert t.close == "Close window"
    end

    test "resolve partial struct merges" do
      t =
        FloatingPanelTranslation.resolve(%FloatingPanelTranslation{
          minimize: "Minimize",
          close: "Close panel"
        })

      assert t.minimize == "Minimize"
      assert t.close == "Close panel"
      assert t.maximize == "Maximize window"
    end
  end

  describe "NumberInput.Translation" do
    test "resolve nil returns defaults" do
      t = NumberInputTranslation.resolve(nil)
      assert t.decrease == "Decrease value"
      assert t.increase == "Increase value"
    end

    test "resolve partial struct merges" do
      t = NumberInputTranslation.resolve(%NumberInputTranslation{decrease: "Less"})
      assert t.decrease == "Less"
      assert t.increase == "Increase value"
    end
  end
end
