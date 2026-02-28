defmodule CorexTest.ComponentHelpers do
  @moduledoc false

  use Phoenix.Component

  import Corex.Accordion
  import Corex.Action
  import Corex.Avatar
  import Corex.Carousel
  import Corex.Clipboard
  import Corex.Collapsible
  import Corex.Combobox
  import Corex.DatePicker
  import Corex.Dialog
  import Corex.Editable
  import Corex.FloatingPanel
  import Corex.Listbox
  import Corex.Marquee
  import Corex.Menu
  import Corex.Navigate
  import Corex.Select
  import Corex.SignaturePad
  import Corex.Tabs
  import Corex.Timer
  import Corex.ToggleGroup
  import Corex.TreeView

  def render_accordion(assigns) do
    assigns =
      assigns
      |> assign_new(:items, fn -> Corex.Content.new([[trigger: "T1", content: "C1"]]) end)
      |> assign_new(:orientation, fn -> "vertical" end)
      |> assign_new(:collapsible, fn -> true end)
      |> assign_new(:multiple, fn -> true end)
      |> assign_new(:dir, fn -> nil end)

    ~H"""
    <.accordion items={@items} orientation={@orientation} collapsible={@collapsible} multiple={@multiple} dir={@dir} />
    """
  end

  def render_accordion_with_indicator(assigns) do
    assigns =
      assign_new(assigns, :items, fn -> Corex.Content.new([[trigger: "T1", content: "C1"]]) end)

    ~H"""
    <.accordion items={@items}>
      <:indicator :let={_item}><span data-indicator>!</span></:indicator>
    </.accordion>
    """
  end

  def render_accordion_with_custom_slots(assigns) do
    assigns =
      assign_new(assigns, :items, fn -> Corex.Content.new([[trigger: "T1", content: "C1"]]) end)

    ~H"""
    <.accordion items={@items}>
      <:trigger :let={_item}><span data-trigger>Custom</span></:trigger>
      <:content :let={_item}><span data-content>Custom content</span></:content>
    </.accordion>
    """
  end

  def render_avatar(assigns) do
    ~H"""
    <.avatar><:fallback>JD</:fallback></.avatar>
    """
  end

  def render_carousel(assigns) do
    ~H"""
    <.carousel items={["/img1.jpg"]}>
      <:prev_trigger>Prev</:prev_trigger>
      <:next_trigger>Next</:next_trigger>
    </.carousel>
    """
  end

  def render_clipboard(assigns) do
    ~H"""
    <.clipboard value={Map.get(assigns, :value, "text")}>
      <:label>Copy</:label>
      <:trigger>Copy</:trigger>
    </.clipboard>
    """
  end

  def render_collapsible(assigns) do
    ~H"""
    <.collapsible open={true}>
      <:trigger>Toggle</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def render_combobox(assigns) do
    ~H"""
    <.combobox collection={[]}>
      <:empty>No items</:empty>
      <:trigger>Select</:trigger>
    </.combobox>
    """
  end

  def render_date_picker(assigns) do
    ~H"""
    <.date_picker>
      <:label>Date</:label>
      <:trigger>Pick date</:trigger>
    </.date_picker>
    """
  end

  def render_dialog(assigns) do
    ~H"""
    <.dialog id="test-dialog">
      <:trigger>Open</:trigger>
      <:content>Dialog content</:content>
    </.dialog>
    """
  end

  def render_editable(assigns) do
    ~H"""
    <.editable value="text">
      <:label>Label</:label>
      <:edit_trigger>Edit</:edit_trigger>
      <:submit_trigger>Save</:submit_trigger>
      <:cancel_trigger>Cancel</:cancel_trigger>
    </.editable>
    """
  end

  def render_floating_panel(assigns) do
    ~H"""
    <.floating_panel>
      <:open_trigger>Open</:open_trigger>
      <:closed_trigger>Closed</:closed_trigger>
      <:minimize_trigger>Min</:minimize_trigger>
      <:maximize_trigger>Max</:maximize_trigger>
      <:default_trigger>Default</:default_trigger>
      <:close_trigger>Close</:close_trigger>
      <:content>Content</:content>
    </.floating_panel>
    """
  end

  def render_listbox(assigns) do
    ~H"""
    <.listbox collection={[%{label: "A", id: "a"}]} />
    """
  end

  def render_marquee(assigns) do
    ~H"""
    <.marquee items={[%{id: "1"}]} duration={10}>
      <:item :let={_item}>Item</:item>
    </.marquee>
    """
  end

  def render_menu(assigns) do
    ~H"""
    <.menu items={Corex.Tree.new([ [label: "Item", id: "1"] ])}>
      <:trigger>Menu</:trigger>
    </.menu>
    """
  end

  def render_select(assigns) do
    ~H"""
    <.select collection={[%{label: "A", id: "a"}]}>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_tabs(assigns) do
    assigns = assign_new(assigns, :orientation, fn -> "vertical" end)

    ~H"""
    <.tabs items={Corex.Content.new([ [trigger: "Tab1", content: "C1"] ])} orientation={@orientation} />
    """
  end

  def render_tabs_trigger(assigns) do
    assigns =
      assign(assigns, :item, %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-1"],
        disabled: false,
        orientation: "vertical",
        dir: "ltr"
      })

    ~H"""
    <.tabs_trigger item={@item}>Tab 1</.tabs_trigger>
    """
  end

  def render_tabs_content(assigns) do
    assigns =
      assign(assigns, :item, %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-1"],
        disabled: false,
        orientation: "vertical",
        dir: "ltr"
      })

    ~H"""
    <.tabs_content item={@item}>Content 1</.tabs_content>
    """
  end

  def render_tabs_custom_slots_only(assigns) do
    ~H"""
    <.tabs id="custom-tabs" value="tab-2">
      <:trigger value="tab-1">Tab 1</:trigger>
      <:trigger value="tab-2">Tab 2</:trigger>
      <:content value="tab-1">Content 1</:content>
      <:content value="tab-2">Content 2</:content>
    </.tabs>
    """
  end

  def render_tabs_items_with_custom_slots(assigns) do
    assigns =
      assign_new(assigns, :items, fn ->
        Corex.Content.new([
          [trigger: "A", content: "A content"],
          [trigger: "B", content: "B content"]
        ])
      end)

    ~H"""
    <.tabs id="items-custom-tabs" items={@items} value="item-0">
      <:trigger :let={item}>{item.data.trigger}</:trigger>
      <:content :let={item}>{item.data.content}</:content>
    </.tabs>
    """
  end

  def render_timer(assigns) do
    ~H"""
    <.timer start_ms={60_000}>
      <:start_trigger>Start</:start_trigger>
      <:pause_trigger>Pause</:pause_trigger>
      <:resume_trigger>Resume</:resume_trigger>
      <:reset_trigger>Reset</:reset_trigger>
    </.timer>
    """
  end

  def render_signature_pad(assigns) do
    ~H"""
    <.signature_pad name="sig">
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_toggle_group(assigns) do
    ~H"""
    <.toggle_group>
      <:item value="a">A</:item>
      <:item value="b">B</:item>
    </.toggle_group>
    """
  end

  def render_tree_view(assigns) do
    ~H"""
    <.tree_view id="tree-test" items={Corex.Tree.new([ [label: "Item", id: "1"] ])} />
    """
  end

  def render_action(assigns) do
    ~H"""
    <.action>Click</.action>
    """
  end

  def render_action_with_opts(assigns) do
    ~H"""
    <.action type={@type} aria_label={@aria_label} disabled={@disabled}>Save</.action>
    """
  end

  def render_navigate(assigns) do
    ~H"""
    <.navigate to={@to} type={@type} external={@external} download={@download} aria_label={@aria_label}>
      Link text
    </.navigate>
    """
  end
end
