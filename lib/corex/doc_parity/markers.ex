defmodule Corex.DocParity.Markers do
  @moduledoc false

  @anatomy_markers %{
    "timer" => %{
      "countdown" => ["anatomy_countdown_code"],
      "interval tick" => ["anatomy_timing_code"],
      "minimal" => ["anatomy_minimal_code"],
      "with triggers" => ["anatomy_with_triggers_code"]
    },
    "tooltip" => %{
      "minimal" => ["anatomy_minimal_code"],
      "placement" => ["anatomy_placement_code"],
      "with arrow" => ["anatomy_with_arrow_code"]
    },
    "pin_input" => %{"basic" => ["minimal_code"]},
    "password_input" => %{
      "custom error" => ["invalid_code"],
      "minimal" => ["minimal_code"]
    },
    "dialog" => %{
      "actions in content" => ["actions_code"],
      "minimal" => ["minimal_code"],
      "title and description" => ["with_title_description_code"]
    },
    "avatar" => %{
      "fallback" => ["anatomy_fallback_code"],
      "pending" => ["anatomy_pending_code"],
      "value slot" => ["anatomy_value_code"]
    },
    "action" => %{"minimal" => ["anatomy_minimal_code"]},
    "data_list" => %{
      "custom slots" => ["custom_slots_code"],
      "empty" => ["empty_code"],
      "manual slots" => ["manual_slots_code"],
      "minimal" => ["minimal_code"]
    },
    "collapsible" => %{
      "custom slots" => ["custom_slots_code"],
      "minimal" => ["anatomy_basic_code"],
      "with indicator" => ["with_indicator_code"]
    },
    "checkbox" => %{
      "indeterminate" => ["indeterminate_code"],
      "invalid" => ["invalid_code"],
      "label and indicator" => ["labeled_code"],
      "minimal" => ["minimal_code"]
    },
    "tags_input" => %{
      "minimal" => ["minimal_code"],
      "translation" => ["with_translation_code"],
      "with label" => ["with_label_code"]
    },
    "data_table" => %{
      "actions" => ["anatomy_with_action_code"],
      "basic" => ["anatomy_minimal_code"],
      "row click" => ["anatomy_row_click_code"],
      "selectable" => ["anatomy_selectable_code"],
      "sortable" => ["anatomy_sortable_code"],
      "streaming" => ["anatomy_streaming_code"],
      "with database" => ["anatomy_with_database_code"]
    },
    "switch" => %{
      "minimal" => ["minimal_code"],
      "with label" => ["with_label_code"]
    },
    "clipboard" => %{
      "minimal" => ["minimal_code"],
      "trigger only" => ["trigger_only_code"]
    },
    "marquee" => %{
      "custom slots" => ["anatomy_custom_slots_code"],
      "minimal" => ["anatomy_minimal_code"]
    },
    "native_input" => %{
      "basic" => ["anatomy_basic_code"],
      "checkbox, select, radio" => ["anatomy_other_code"],
      "textarea (icon slot ignored)" => ["anatomy_textarea_code"],
      "with form field" => ["form_field_code"],
      "with icon" => ["anatomy_with_icon_code"]
    },
    "date_picker" => %{"basic usage" => ["minimal_code"]},
    "code" => %{
      "basic usage" => ["basic_usage_code"],
      "loading from a file" => ["from_file_code"],
      "multi-line with heredoc" => ["multiline_code"]
    },
    "accordion" => %{
      "compound" => ["compound_code"],
      "custom slots" => ["custom_slots_code"],
      "manual slots" => ["manual_slots_code"],
      "minimal" => ["minimal_code"],
      "with slots" => ["with_indicator_code"]
    },
    "toggle_group" => %{
      "minimal" => ["anatomy_minimal_code"],
      "single selection" => ["anatomy_single_selection_code"],
      "with indicator" => ["anatomy_indicator_code"]
    },
    "navigate" => %{"minimal" => ["anatomy_minimal_code"]},
    "signature_pad" => %{
      "basic usage" => ["minimal_code"],
      "custom drawing options" => ["with_presets_code"],
      "with callback" => ["with_label_code"]
    },
    "angle_slider" => %{
      "basic" => ["minimal_code"],
      "with marks" => ["with_label_code"]
    },
    "combobox" => %{
      "extended" => ["extended_code"],
      "extended grouped" => ["extended_grouped_code"],
      "grouped" => ["grouped_code"],
      "minimal" => ["minimal_code"]
    },
    "carousel" => %{
      "compound" => ["anatomy_compound_code"],
      "custom content" => ["anatomy_custom_content_code"],
      "images" => ["anatomy_images_code"]
    },
    "floating_panel" => %{"basic" => ["anatomy_basic_code"]},
    "pagination" => %{
      "controlled page" => ["anatomy_controlled_code"],
      "minimal" => ["anatomy_minimal_code"],
      "translation" => ["translation_code"]
    },
    "tabs" => %{
      "basic" => ["anatomy_basic_code"],
      "custom" => ["anatomy_custom_code"],
      "with indicator" => ["anatomy_indicator_code"]
    },
    "select" => %{
      "custom" => ["extended_code"],
      "custom grouped" => ["extended_grouped_code"],
      "grouped" => ["grouped_code"],
      "minimal" => ["minimal_code"]
    },
    "tree_view" => %{
      "basic" => ["anatomy_minimal_code"],
      "compound" => ["anatomy_compound_code"],
      "custom slots" => ["anatomy_custom_slots_code"],
      "with indicator" => ["anatomy_with_indicator_code"],
      "with label" => ["anatomy_with_label_code"]
    },
    "radio_group" => %{
      "invalid" => ["invalid_code"],
      "minimal" => ["minimal_code"],
      "read-only" => ["read_only_code"],
      "with indicator" => ["indicator_code"]
    },
    "toast" => %{
      "flash defaults" => ["flash_defaults_code"],
      "layout flash" => ["layout_flash_code"]
    },
    "file_upload_live" => %{
      "custom slots" => ["live_anatomy_custom_slots_code"],
      "form with submit" => ["live_form_with_submit_code"],
      "minimal" => ["live_anatomy_minimal_code"],
      "with label" => ["live_anatomy_with_label_code"]
    },
    "toggle" => %{
      "dual label" => ["dual_label_code"],
      "minimal" => ["minimal_code"],
      "with indicator" => ["with_indicator_code"]
    },
    "menu" => %{
      "grouped items" => ["anatomy_grouped_code"],
      "list" => ["anatomy_minimal_code"],
      "nested menu" => ["anatomy_nested_code"],
      "nested menu with custom indicator" => ["nested_menu_code"]
    },
    "file_upload" => %{
      "custom slots" => ["anatomy_custom_slots_code"],
      "minimal" => ["anatomy_minimal_code"],
      "multipart form (controller)" => ["anatomy_multipart_code"],
      "with label" => ["anatomy_with_label_code"]
    },
    "color_picker" => %{"basic" => ["minimal_code"]},
    "listbox" => %{
      "custom item slot" => ["anatomy_extended_code"],
      "grouped" => ["anatomy_grouped_code"],
      "minimal" => ["anatomy_minimal_code"],
      "with indicator" => ["anatomy_with_indicator_code"]
    },
    "editable" => %{"basic" => ["minimal_code"]},
    "number_input" => %{
      "min, max, step" => ["min_max_default_code"],
      "minimal" => ["anatomy_minimal_quantity_code"]
    }
  }

  def anatomy(slug, heading) do
    key = String.downcase(heading)

    case Map.get(@anatomy_markers, slug) do
      %{^key => fns} -> {:ok, fns}
      _ -> :error
    end
  end

  def anatomy_markers, do: @anatomy_markers
end
