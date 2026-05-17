defmodule Corex.ConnectIgnoreCoverageTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.ColorPicker.Anatomy, as: CP
  alias Corex.ColorPicker.Connect, as: ColorConnect
  alias Corex.Collapsible.Anatomy.{Content, Root, Trigger}
  alias Corex.Collapsible.Connect, as: CollConnect
  alias Corex.FileUpload.Connect, as: FileConnect
  alias Corex.Pagination.Anatomy.{NextTrigger, PrevTrigger}
  alias Corex.Pagination.Anatomy.Root, as: PaginationRoot
  alias Corex.Pagination.Connect, as: PageConnect
  alias Corex.TagsInput.Connect, as: TagsConnect
  alias Corex.Timer.Anatomy.{Props, Separator}
  alias Corex.Timer.Connect, as: TimerConnect
  alias Corex.TreeView.Connect, as: TreeConnect
  alias Corex.Combobox.Connect, as: ComboboxConnect
  alias Corex.DatePicker.Anatomy, as: DP
  alias Corex.DatePicker.Connect, as: DateConnect
  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label}
  alias Corex.PinInput.Anatomy.Root, as: PinRoot
  alias Corex.PinInput.Connect, as: PinConnect
  alias Corex.SignaturePad.Connect, as: SigConnect
  alias Corex.Toggle.Connect, as: ToggleConnect
  alias Phoenix.LiveView.JS

  describe "ColorPicker.Connect" do
    test "ignore and attr helpers" do
      id = "cp"
      dir = "ltr"

      trigger = %CP.Trigger{
        id: id,
        disabled: false,
        read_only: false,
        invalid: false,
        open: true,
        dir: dir
      }

      assert %JS{} = ColorConnect.ignore_trigger(trigger)
      assert ColorConnect.trigger(trigger)["data-state"] == "open"

      assert %JS{} = ColorConnect.ignore_hidden_input(%CP.HiddenInput{id: id, name: "color"})

      assert %JS{} =
               ColorConnect.ignore_transparency_grid(%CP.TransparencyGrid{id: id, size: "8px"})

      assert %JS{} =
               ColorConnect.ignore_preset_swatch(%CP.PresetSwatch{
                 id: id,
                 value: "#000",
                 index: 0
               })

      assert %JS{} =
               ColorConnect.ignore_channel_input(%CP.ChannelInput{
                 picker_id: id,
                 qualifier: "channel",
                 channel: "red"
               })

      assert ColorConnect.channel_slider(%CP.ChannelSlider{picker_id: id, channel: "hue"})[
               "data-part"
             ] == "channel-slider"
    end
  end

  describe "FileUpload.Connect" do
    test "ignore helpers accept maps" do
      id = "fu"
      base = %{id: id, dir: "ltr"}

      for fun <- [
            &FileConnect.ignore_root/1,
            &FileConnect.ignore_label/1,
            &FileConnect.ignore_dropzone/1,
            &FileConnect.ignore_hidden_input/1,
            &FileConnect.ignore_input_sentinel/1,
            &FileConnect.ignore_trigger/1
          ] do
        assert %JS{} = fun.(base)
      end

      assert %JS{} = FileConnect.ignore_item_group(Map.put(base, :type, "accepted"))
    end
  end

  describe "Pagination.Connect" do
    test "ignore helpers" do
      root = %PaginationRoot{id: "pg", dir: "ltr"}
      prev = %PrevTrigger{id: "pg", dir: "ltr", disabled: false}

      assert %JS{} = PageConnect.ignore_root(root)
      assert %JS{} = PageConnect.ignore_prev_trigger(prev)

      assert %JS{} =
               PageConnect.ignore_next_trigger(%NextTrigger{id: "pg", dir: "ltr", disabled: true})
    end
  end

  describe "TagsInput.Connect" do
    test "ignore helpers accept maps" do
      base = %{id: "tags", dir: "ltr", orientation: "horizontal"}

      for fun <- [
            &TagsConnect.ignore_root/1,
            &TagsConnect.ignore_label/1,
            &TagsConnect.ignore_control/1,
            &TagsConnect.ignore_main_input/1,
            &TagsConnect.ignore_hidden_input/1,
            &TagsConnect.ignore_value_input/1
          ] do
        assert %JS{} = fun.(base)
      end
    end
  end

  describe "TreeView.Connect" do
    test "ignore helpers accept maps" do
      base = %{
        id: "tree",
        dir: "ltr",
        value: "n",
        disabled: false,
        index_path: [0],
        expanded: true
      }

      for fun <- [
            &TreeConnect.ignore_root/1,
            &TreeConnect.ignore_label/1,
            &TreeConnect.ignore_tree/1,
            &TreeConnect.ignore_item/1,
            &TreeConnect.ignore_branch/1,
            &TreeConnect.ignore_branch_trigger/1,
            &TreeConnect.ignore_branch_content/1,
            &TreeConnect.ignore_branch_indicator/1,
            &TreeConnect.ignore_branch_text/1,
            &TreeConnect.ignore_item_text/1,
            &TreeConnect.ignore_item_indicator/1,
            &TreeConnect.ignore_branch_indent_guide/1
          ] do
        assert %JS{} = fun.(base)
      end
    end
  end

  describe "Timer.Connect extras" do
    test "props and remaining segments" do
      id = "t-extra"

      props =
        TimerConnect.props(%Props{
          id: id,
          countdown: true,
          start_ms: 1000,
          target_ms: 0,
          auto_start: false,
          interval: 500,
          dir: "ltr",
          orientation: "vertical",
          on_tick: nil,
          on_tick_client: nil,
          on_complete: nil,
          on_complete_client: nil
        })

      assert props["data-countdown"] == ""

      assert TimerConnect.separator(%Separator{id: "timer:#{id}:s", hidden: false})["data-part"] ==
               "separator"
    end
  end

  describe "Toggle and Collapsible" do
    test "ignore helpers" do
      assert %JS{} =
               ToggleConnect.ignore_root(%{id: "tog", dir: "ltr", pressed: true, disabled: false})

      assert %JS{} =
               ToggleConnect.ignore_indicator(%{
                 id: "tog",
                 dir: "ltr",
                 pressed: false,
                 disabled: true
               })

      assert ToggleConnect.root(%{id: "tog", dir: "ltr", pressed: true, disabled: false})[
               "data-state"
             ] == "on"

      trigger = %Trigger{id: "col-t", dir: "ltr", open: true, disabled: false}
      content = %Content{id: "col-c", dir: "ltr", open: true, disabled: false}
      assert %JS{} = CollConnect.ignore_root(%Root{id: "col", dir: "ltr", open: true})
      assert %JS{} = CollConnect.ignore_trigger(trigger)
      assert %JS{} = CollConnect.ignore_content(content)
    end
  end

  describe "DatePicker.Connect" do
    test "ignore and attr helpers" do
      id = "dp"
      dir = "ltr"

      assert %JS{} = DateConnect.ignore_root(%DP.Root{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_label(%DP.Label{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_control(%DP.Control{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_input(%DP.Input{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_trigger(%DP.Trigger{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_positioner(%DP.Positioner{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_content(%DP.Content{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_view_prev(%{id: id, view: "day"})
      assert %JS{} = DateConnect.ignore_view_next(%{id: id, view: "month"})
      assert %JS{} = DateConnect.ignore_view_trigger(%{id: id, view: "year"})
      assert %JS{} = DateConnect.ignore_decade(%DP.Decade{id: id, dir: dir})
      assert %JS{} = DateConnect.ignore_error(%DP.Error{id: id, index: 0})
    end
  end

  describe "Combobox.Connect" do
    test "ignore helpers accept maps" do
      id = "cb"

      base = %{
        id: id,
        dir: "ltr",
        disabled: false,
        value: "a",
        group_id: "g1",
        html_for: "cb:g1",
        item: %{value: "a"}
      }

      for fun <- [
            &ComboboxConnect.ignore_root/1,
            &ComboboxConnect.ignore_label/1,
            &ComboboxConnect.ignore_control/1,
            &ComboboxConnect.ignore_input/1,
            &ComboboxConnect.ignore_trigger/1,
            &ComboboxConnect.ignore_clear_trigger/1,
            &ComboboxConnect.ignore_positioner/1,
            &ComboboxConnect.ignore_content/1,
            &ComboboxConnect.ignore_list/1,
            &ComboboxConnect.ignore_item_group/1,
            &ComboboxConnect.ignore_item_group_label/1,
            &ComboboxConnect.ignore_item/1,
            &ComboboxConnect.ignore_item_text/1,
            &ComboboxConnect.ignore_item_indicator/1,
            &ComboboxConnect.ignore_empty/1
          ] do
        assert %JS{} = fun.(base)
      end
    end
  end

  describe "PinInput.Connect" do
    test "ignore helpers" do
      id = "pin"

      assert %JS{} = PinConnect.ignore_root(%PinRoot{id: id})
      assert %JS{} = PinConnect.ignore_label(%Label{id: id})
      assert %JS{} = PinConnect.ignore_hidden_input(%HiddenInput{id: id, name: "pin", value: "1"})
      assert %JS{} = PinConnect.ignore_control(%Control{id: id})
      assert %JS{} = PinConnect.ignore_input(%Input{id: id, index: 0, aria_label: "Digit 1"})
    end
  end

  describe "SignaturePad.Connect" do
    test "ignore helpers" do
      alias Corex.SignaturePad.Anatomy.{
        ClearTrigger,
        Control,
        Error,
        Guide,
        HiddenInput,
        Label,
        Path,
        Root,
        Segment
      }

      id = "sig"
      dir = "ltr"

      assert %JS{} = SigConnect.ignore_root(%Root{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_label(%Label{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_control(%Control{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_segment(%Segment{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_path(%Path{id: id, index: 0})
      assert %JS{} = SigConnect.ignore_guide(%Guide{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_clear_trigger(%ClearTrigger{id: id, dir: dir})
      assert %JS{} = SigConnect.ignore_hidden_input(%HiddenInput{id: id, dir: dir, name: "sig"})
      assert %JS{} = SigConnect.ignore_error(%Error{id: id, index: 0})
    end
  end
end
