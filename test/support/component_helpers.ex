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
  import Corex.PasswordInput
  import Corex.RadioGroup
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

  def render_combobox_with_items(assigns) do
    ~H"""
    <.combobox collection={[%{id: "a", label: "A"}]}>
      <:empty>No results</:empty>
      <:trigger>Select</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_item_slot(assigns) do
    ~H"""
    <.combobox collection={[%{id: "x", label: "X"}]}>
      <:empty>None</:empty>
      <:item :let={item}>{item.label}!</:item>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_clear_and_indicator(assigns) do
    ~H"""
    <.combobox collection={[%{id: "b", label: "B"}]}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
      <:clear_trigger>Clear</:clear_trigger>
      <:item_indicator>Check</:item_indicator>
    </.combobox>
    """
  end

  def render_combobox_grouped(assigns) do
    ~H"""
    <.combobox collection={[%{id: "e1", label: "E1", group: "Europe"}, %{id: "a1", label: "A1", group: "Asia"}]}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_filter_false(assigns) do
    ~H"""
    <.combobox collection={[%{id: "c", label: "C"}]} filter={false}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_controlled_multiple(assigns) do
    ~H"""
    <.combobox collection={[%{id: "m1", label: "M1"}, %{id: "m2", label: "M2"}]} controlled value={["m1"]} multiple>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_errors(assigns) do
    ~H"""
    <.combobox collection={[]} id="cb" errors={["Required"]}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
      <:error :let={msg}>{msg}</:error>
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

  def render_dialog_nested_slots(assigns) do
    ~H"""
    <.dialog id="dialog-nested">
      <:trigger>Open</:trigger>
      <:content>
        <.dialog_title id="dialog-nested">Nested Title</.dialog_title>
        <.dialog_description id="dialog-nested">Nested desc</.dialog_description>
        <p>Body</p>
        <.dialog_close_trigger id="dialog-nested">×</.dialog_close_trigger>
      </:content>
    </.dialog>
    """
  end

  def render_dialog_controlled(assigns) do
    ~H"""
    <.dialog id="test-dialog-ctrl" controlled open={false}>
      <:trigger>Open</:trigger>
      <:title>Title</:title>
      <:description>Description</:description>
      <:content><p>Content</p></:content>
      <:close_trigger>Close</:close_trigger>
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

  def render_listbox_grouped(assigns) do
    ~H"""
    <.listbox collection={[%{label: "E1", id: "e1", group: "Europe"}, %{label: "A1", id: "a1", group: "Asia"}]} />
    """
  end

  def render_listbox_list_items(assigns) do
    ~H"""
    <.listbox collection={[%Corex.List.Item{id: "li-1", label: "Item 1"}, %Corex.List.Item{id: "li-2", label: "Item 2"}]} />
    """
  end

  def render_listbox_controlled(assigns) do
    ~H"""
    <.listbox collection={[%{label: "A", id: "a"}]} controlled value={["a"]} />
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

  def render_menu_grouped(assigns) do
    ~H"""
    <.menu items={Corex.Tree.new([ [label: "A1", id: "a1", group: "Group A"], [label: "A2", id: "a2", group: "Group A"], [label: "B1", id: "b1", group: "Group B"] ])}>
      <:trigger>Menu</:trigger>
    </.menu>
    """
  end

  def render_menu_nested(assigns) do
    ~H"""
    <.menu items={Corex.Tree.new([ [label: "Share", id: "share", children: [ [label: "Messages", id: "messages"] ] ] ])}>
      <:trigger>Menu</:trigger>
      <:nested_indicator>→</:nested_indicator>
    </.menu>
    """
  end

  def render_menu_controlled(assigns) do
    ~H"""
    <.menu items={Corex.Tree.new([ [label: "Item", id: "1"] ])} controlled open={false}>
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

  def render_select_controlled_multiple(assigns) do
    ~H"""
    <.select collection={[%{label: "A", id: "a"}, %{label: "B", id: "b"}]} controlled value={["a"]} multiple>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_grouped(assigns) do
    ~H"""
    <.select collection={[%{label: "E1", id: "e1", group: "Europe"}, %{label: "A1", id: "a1", group: "Asia"}]}>
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

  def render_signature_pad_controlled(assigns) do
    ~H"""
    <.signature_pad id="sig-pad" controlled paths={[]}>
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_signature_pad_drawing_opts(assigns) do
    ~H"""
    <.signature_pad id="sig-pad" drawing_fill="blue" drawing_size={3} drawing_simulate_pressure>
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_signature_pad_on_draw_end(assigns) do
    ~H"""
    <.signature_pad id="sig-pad" on_draw_end="signature_drawn">
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_signature_pad_with_field(assigns) do
    params = Map.get(assigns, :params, %{"signature" => nil})
    form = Phoenix.Component.to_form(params, as: :user)
    field = form[:signature]

    assigns = assign(assigns, :field, field)

    ~H"""
    <.signature_pad field={@field}>
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_signature_pad_with_paths(assigns) do
    ~H"""
    <.signature_pad id="sig-paths" paths={@paths}>
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_signature_pad_with_errors(assigns) do
    ~H"""
    <.signature_pad id="sig-err" errors={["Required"]}>
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
      <:error :let={msg}>{msg}</:error>
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

  def render_tree_view_with_branch(assigns) do
    ~H"""
    <.tree_view id="tree-branch" items={Corex.Tree.new([ [label: "Parent", id: "p", children: [ [label: "Child", id: "c"] ] ] ])} />
    """
  end

  def render_tree_view_controlled(assigns) do
    ~H"""
    <.tree_view id="tree-ctrl" items={Corex.Tree.new([ [label: "Item", id: "1"] ])} controlled expanded_value={[]} value={[]} />
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

  def render_navigate_replace(assigns) do
    ~H"""
    <.navigate to={@to} type="href" replace>Link</.navigate>
    """
  end

  def render_navigate_method(assigns) do
    ~H"""
    <.navigate to={@to} type="navigate" method="post">Link</.navigate>
    """
  end

  def render_password_input_full(assigns) do
    ~H"""
    <.password_input name="pass">
      <:label>Password</:label>
      <:visible_indicator>Show</:visible_indicator>
      <:hidden_indicator>Hide</:hidden_indicator>
      <:error :let={msg}>{msg}</:error>
    </.password_input>
    """
  end

  def render_password_input_with_field(assigns) do
    form = Phoenix.Component.to_form(%{"password" => nil}, as: :user)
    field = form[:password]
    assigns = assign(assigns, :field, field)

    ~H"""
    <.password_input field={@field}>
      <:label>Password</:label>
      <:visible_indicator>Show</:visible_indicator>
      <:hidden_indicator>Hide</:hidden_indicator>
      <:error :let={msg}>{msg}</:error>
    </.password_input>
    """
  end

  def render_radio_group_with_indicator(assigns) do
    ~H"""
    <.radio_group id="rg-ind" name="choice" items={[["a", "Option A"], ["b", "Option B"]]}>
      <:label>Choose</:label>
      <:item_control><span data-check>✓</span></:item_control>
    </.radio_group>
    """
  end

  def render_radio_group_controlled(assigns) do
    ~H"""
    <.radio_group id="rg-ctrl" name="choice" items={[["a", "A"]]} controlled value="a">
      <:label>Choose</:label>
    </.radio_group>
    """
  end

  def render_radio_group_with_item_slot(assigns) do
    ~H"""
    <.radio_group id="rg-item" name="choice" items={[["x", "X"], ["y", "Y"]]}>
      <:label>Choose</:label>
      <:item :let={item}>
        <span data-value={item.value}>{item.label}</span>
      </:item>
    </.radio_group>
    """
  end

  def render_radio_group_with_form(assigns) do
    ~H"""
    <.radio_group id="rg-form" name="choice" form="my-form" items={[["a", "A"]]}>
      <:label>Choose</:label>
    </.radio_group>
    """
  end

  def render_navigate_external_patch(assigns) do
    ~H"""
    <.navigate to={@to} type="patch" external>Link</.navigate>
    """
  end
end
