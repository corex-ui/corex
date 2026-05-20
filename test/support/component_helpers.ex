defmodule CorexTest.ComponentHelpers do
  @moduledoc false

  use Phoenix.Component

  import Corex.Accordion
  import Corex.Action
  import Corex.Avatar
  import Corex.Carousel
  import Corex.Checkbox
  import Corex.Clipboard
  import Corex.ColorPicker
  import Corex.Collapsible
  import Corex.Combobox
  import Corex.DatePicker
  import Corex.Dialog
  import Corex.Editable
  import Corex.FileUpload
  import Corex.FileUploadLive
  import Corex.FloatingPanel
  import Corex.Heroicon
  import Corex.Listbox
  import Corex.Marquee
  import Corex.Menu
  import Corex.Navigate
  import Corex.Pagination
  import Corex.PasswordInput
  import Corex.RadioGroup
  import Corex.Select
  import Corex.SignaturePad
  import Corex.Switch
  import Corex.Tabs
  import Corex.TagsInput
  import Corex.Timer
  import Corex.Toggle
  import Corex.ToggleGroup
  import Corex.TreeView

  def render_accordion(assigns) do
    assigns =
      assigns
      |> assign_new(:items, fn -> Corex.Content.new([%{label: "T1", content: "C1"}]) end)
      |> assign_new(:orientation, fn -> "vertical" end)
      |> assign_new(:collapsible, fn -> true end)
      |> assign_new(:multiple, fn -> true end)
      |> assign_new(:dir, fn -> nil end)

    ~H"""
    <.accordion id="test-accordion"  items={@items} orientation={@orientation} collapsible={@collapsible} multiple={@multiple} dir={@dir} />
    """
  end

  def render_accordion_with_indicator(assigns) do
    assigns =
      assign_new(assigns, :items, fn -> Corex.Content.new([%{label: "T1", content: "C1"}]) end)

    ~H"""
    <.accordion id="test-accordion"  items={@items}>
      <:indicator :let={_item}><span data-indicator>!</span></:indicator>
    </.accordion>
    """
  end

  def render_accordion_with_custom_slots(assigns) do
    assigns =
      assign_new(assigns, :items, fn -> Corex.Content.new([%{label: "T1", content: "C1"}]) end)

    ~H"""
    <.accordion id="test-accordion"  items={@items}>
      <:trigger :let={_item}><span data-trigger>Custom</span></:trigger>
      <:content :let={_item}><span data-content>Custom content</span></:content>
    </.accordion>
    """
  end

  def render_avatar(assigns) do
    ~H"""
    <.avatar id="test-avatar" ><:fallback>JD</:fallback></.avatar>
    """
  end

  def render_carousel(assigns) do
    ~H"""
    <.carousel id="test-carousel"  items={[Corex.Image.new("/img1.jpg", alt: "Slide")]}>
      <:prev_trigger>Prev</:prev_trigger>
      <:next_trigger>Next</:next_trigger>
    </.carousel>
    """
  end

  def render_checkbox(assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn -> false end)
      |> assign_new(:name, fn -> "cb-#{System.unique_integer([:positive])}" end)

    ~H"""
    <.checkbox id="test-checkbox"  checked={@checked} name={@name}>
      <:label>Label</:label>
    </.checkbox>
    """
  end

  def render_clipboard(assigns) do
    ~H"""
    <.clipboard id="test-clipboard"  value={Map.get(assigns, :value, "text")}>
      <:label>Copy</:label>
      <:copy><span>C</span></:copy>
      <:copied><span>OK</span></:copied>
    </.clipboard>
    """
  end

  def render_collapsible(assigns) do
    ~H"""
    <.collapsible id="test-collapsible"  open={true}>
      <:trigger>Toggle</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def render_collapsible_with_closed_surface(assigns) do
    ~H"""
    <.collapsible id="test-collapsible"  open={true}>
      <:trigger>Toggle</:trigger>
      <:content>Content</:content>
      <:closed><span data-closed-marker>Closed surface</span></:closed>
    </.collapsible>
    """
  end

  def render_collapsible_with_let_slots(assigns) do
    assigns = assign_new(assigns, :open, fn -> false end)

    ~H"""
    <.collapsible id="test-collapsible"  open={@open}>
      <:trigger :let={c}><%= if c.open, do: "Collapse", else: "Expand" %></:trigger>
      <:content :let={_c}>Panel</:content>
      <:closed :let={c}>
        <span data-closed-state={if c.open, do: "open", else: "closed"}>▼</span>
      </:closed>
    </.collapsible>
    """
  end

  def render_combobox(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={[]}>
      <:empty>No items</:empty>
      <:trigger>Select</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_items(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "a", label: "A"}])}>
      <:empty>No results</:empty>
      <:trigger>Select</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_item_slot(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "x", label: "X"}])}>
      <:empty>None</:empty>
      <:item :let={item}>{item.label}!</:item>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_clear_and_indicator(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "b", label: "B"}])}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
      <:clear_trigger>Clear</:clear_trigger>
      <:item_indicator>Check</:item_indicator>
    </.combobox>
    """
  end

  def render_combobox_grouped(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "e1", label: "E1", group: "Europe"}, %{value: "a1", label: "A1", group: "Asia"}])}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_filter_false(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "c", label: "C"}])} filter={false}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_default_multiple(assigns) do
    ~H"""
    <.combobox id="test-combobox"  items={Corex.List.new([%{value: "m1", label: "M1"}, %{value: "m2", label: "M2"}])} value={["m1"]} multiple>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
    </.combobox>
    """
  end

  def render_combobox_with_errors(assigns) do
    ~H"""
    <.combobox items={[]} id="cb" errors={["Required"]}>
      <:empty>None</:empty>
      <:trigger>Open</:trigger>
      <:error :let={msg}>{msg}</:error>
    </.combobox>
    """
  end

  def render_date_picker(assigns) do
    ~H"""
    <.date_picker id="test-date-picker">
      <:label>Date</:label>
      <:trigger>Pick date</:trigger>
      <:prev_trigger>Prev</:prev_trigger>
      <:next_trigger>Next</:next_trigger>
    </.date_picker>
    """
  end

  def render_color_picker(assigns) do
    ~H"""
    <.color_picker id={Map.get(assigns, :id, "cp-h")} label="Color" />
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
    <.editable id="test-editable"  value="text">
      <:label>Label</:label>
      <:edit_trigger>Edit</:edit_trigger>
      <:submit_trigger>Save</:submit_trigger>
      <:cancel_trigger>Cancel</:cancel_trigger>
    </.editable>
    """
  end

  def render_editable_with_translation(assigns) do
    ~H"""
    <.editable id="test-editable"  value="text" translation={@translation}>
      <:label>Label</:label>
      <:edit_trigger>Edit</:edit_trigger>
      <:submit_trigger>Save</:submit_trigger>
      <:cancel_trigger>Cancel</:cancel_trigger>
    </.editable>
    """
  end

  def render_editable_with_errors(assigns) do
    ~H"""
    <.editable id="test-editable"  value="text" errors={["can't be blank"]}>
      <:label>Label</:label>
      <:error :let={msg}>{msg}</:error>
      <:edit_trigger>Edit</:edit_trigger>
      <:submit_trigger>Save</:submit_trigger>
      <:cancel_trigger>Cancel</:cancel_trigger>
    </.editable>
    """
  end

  def render_floating_panel(assigns) do
    ~H"""
    <.floating_panel id="test-floating-panel">
      <:trigger>
        <span data-open>Open</span>
        <span data-closed>Closed</span>
      </:trigger>
      <:title>Title</:title>
      <:minimize_trigger>Min</:minimize_trigger>
      <:maximize_trigger>Max</:maximize_trigger>
      <:default_trigger>Default</:default_trigger>
      <:close_trigger>Close</:close_trigger>
      <:content>Content</:content>
    </.floating_panel>
    """
  end

  def render_floating_panel_without_stage_triggers(assigns) do
    ~H"""
    <.floating_panel id="fp-no-stage">
      <:trigger>
        <span data-open>Open</span>
        <span data-closed>Closed</span>
      </:trigger>
      <:title>No stages</:title>
      <:close_trigger>Close</:close_trigger>
      <:content>Content</:content>
    </.floating_panel>
    """
  end

  def render_listbox(assigns) do
    ~H"""
    <.listbox id="test-listbox"  items={Corex.List.new([%{label: "A", value: "a"}])} />
    """
  end

  def render_listbox_grouped(assigns) do
    ~H"""
    <.listbox id="test-listbox"  items={Corex.List.new([%{label: "E1", value: "e1", group: "Europe"}, %{label: "A1", value: "a1", group: "Asia"}])} />
    """
  end

  def render_listbox_list_items(assigns) do
    ~H"""
    <.listbox id="test-listbox"  items={Corex.List.new([%Corex.List.Item{value: "li-1", label: "Item 1"}, %Corex.List.Item{value: "li-2", label: "Item 2"}])} />
    """
  end

  def render_listbox_controlled(assigns) do
    ~H"""
    <.listbox id="test-listbox"  items={Corex.List.new([%{label: "A", value: "a"}])} controlled value={["a"]} />
    """
  end

  def render_marquee(assigns) do
    ~H"""
    <.marquee id="test-marquee"  items={[%{id: "1"}]} duration={10}>
      <:item :let={_item}>Item</:item>
    </.marquee>
    """
  end

  def render_menu(assigns) do
    ~H"""
    <.menu id="test-menu"  items={Corex.Tree.new([%{label: "Item", value: "1"}])}>
      <:trigger>Menu</:trigger>
    </.menu>
    """
  end

  def render_menu_grouped(assigns) do
    ~H"""
    <.menu id="test-menu-grouped" items={
      Corex.Tree.new([
        %{label: "A1", value: "a1", group: "Group A"},
        %{label: "A2", value: "a2", group: "Group A"},
        %{label: "B1", value: "b1", group: "Group B"}
      ])
    }>
      <:trigger>Menu</:trigger>
    </.menu>
    """
  end

  def render_menu_nested(assigns) do
    ~H"""
    <.menu id="test-menu-nested" items={
      Corex.Tree.new([
        %{label: "Share", value: "share", children: [%{label: "Messages", value: "messages"}]}
      ])
    }>
      <:trigger>Menu</:trigger>
      <:nested_indicator>→</:nested_indicator>
    </.menu>
    """
  end

  def render_menu_with_loading(assigns) do
    ~H"""
    <.menu id="test-menu"  items={Corex.Tree.new([%{label: "Item", value: "1"}])}>
      <:trigger>Menu</:trigger>
    </.menu>
    """
  end

  def render_select(assigns) do
    ~H"""
    <.select id="test-select"  items={Corex.List.new([%{label: "A", value: "a"}])}>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_with_opts(assigns) do
    ~H"""
    <.select
      id="test-select-opts"
      items={Corex.List.new([%{label: "A", value: "a"}])}
      translation={%Corex.Select.Translation{placeholder: @placeholder}}
    >
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_controlled_multiple(assigns) do
    ~H"""
    <.select id="test-select"  items={Corex.List.new([%{label: "A", value: "a"}, %{label: "B", value: "b"}])} controlled value={["a"]} multiple>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_grouped(assigns) do
    ~H"""
    <.select id="test-select"  items={Corex.List.new([%{label: "E1", value: "e1", group: "Europe"}, %{label: "A1", value: "a1", group: "Asia"}])}>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_uncontrolled_value(assigns) do
    ~H"""
    <.select id="test-select"  items={Corex.List.new([%{label: "A", value: "a"}])} value={["a"]}>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_select_with_field(assigns) do
    form = Phoenix.Component.to_form(%{"country" => "fra"}, as: :user)
    field = form[:country]

    assigns = assign(assigns, :field, field)

    ~H"""
    <.select field={@field} items={Corex.List.new([%{value: "fra", label: "France"}, %{value: "deu", label: "Germany"}])}>
      <:trigger>Select</:trigger>
    </.select>
    """
  end

  def render_tabs(assigns) do
    assigns = assign_new(assigns, :orientation, fn -> "vertical" end)

    ~H"""
    <.tabs
      id="test-tabs-orient"
      items={Corex.Content.new([%{value: "tab-1", label: "Tab1", content: "C1"}])}
      orientation={@orientation}
    />
    """
  end

  def render_tabs_with_indicator(assigns) do
    assigns =
      assign_new(assigns, :items, fn ->
        Corex.Content.new([%{value: "tab-1", label: "T1", content: "C1"}])
      end)

    ~H"""
    <.tabs id="test-tabs"  items={@items} />
    """
  end

  def render_tabs_items_with_custom_slots(assigns) do
    assigns =
      assign_new(assigns, :items, fn ->
        Corex.Content.new([
          %{value: "a", label: "A", content: "A content"},
          %{value: "b", label: "B", content: "B content"}
        ])
      end)

    ~H"""
    <.tabs id="items-custom-tabs" items={@items} value="item-0">
      <:trigger :let={item}>{item.label}</:trigger>
      <:content :let={item}>{item.content}</:content>
    </.tabs>
    """
  end

  def render_timer(assigns) do
    ~H"""
    <.timer id="test-timer"  start_ms={60_000}>
      <:start_trigger>Start</:start_trigger>
      <:pause_trigger>Pause</:pause_trigger>
      <:resume_trigger>Resume</:resume_trigger>
      <:reset_trigger>Reset</:reset_trigger>
    </.timer>
    """
  end

  def render_timer_paused(assigns) do
    ~H"""
    <.timer id="test-timer"  start_ms={60_000} auto_start={false}>
      <:start_trigger>Start</:start_trigger>
      <:pause_trigger>Pause</:pause_trigger>
      <:resume_trigger>Resume</:resume_trigger>
      <:reset_trigger>Reset</:reset_trigger>
    </.timer>
    """
  end

  def render_signature_pad(assigns) do
    ~H"""
    <.signature_pad id="test-signature-pad"  name="sig">
      <:label>Sign</:label>
      <:clear_trigger>Clear</:clear_trigger>
    </.signature_pad>
    """
  end

  def render_switch(assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn -> false end)
      |> assign_new(:name, fn -> "sw-#{System.unique_integer([:positive])}" end)

    ~H"""
    <.switch id="test-switch"  checked={@checked} name={@name}>
      <:label>Label</:label>
    </.switch>
    """
  end

  def render_signature_pad_controlled(assigns) do
    ~H"""
    <.signature_pad id="sig-pad" paths={[]}>
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
    <.signature_pad id="test-signature-pad"  field={@field}>
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

  def render_toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "toggle-test" end)
      |> assign_new(:controlled, fn -> false end)
      |> assign_new(:pressed, fn -> false end)

    ~H"""
    <.toggle id={@id} controlled={@controlled} pressed={@pressed}>
      Label
    </.toggle>
    """
  end

  def render_tags_input(assigns) do
    assigns = assign_new(assigns, :value, fn -> ["alpha", "beta"] end)

    ~H"""
    <.tags_input id="tags-test" value={@value} name="keywords">
      <:label>Keywords</:label>
      <:close><.heroicon name="hero-x-mark" /></:close>
    </.tags_input>
    """
  end

  def render_pagination(assigns) do
    assigns =
      assigns
      |> assign_new(:count, fn -> 50 end)
      |> assign_new(:page_size, fn -> 10 end)
      |> assign_new(:page, fn -> 1 end)

    ~H"""
    <.pagination id="pagination-test" count={@count} page={@page} page_size={@page_size} class="pagination">
      <:prev><span>Prev</span></:prev>
      <:next><span>Next</span></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def render_pagination_link_patch(assigns) do
    assigns =
      assigns
      |> assign_new(:count, fn -> 50 end)
      |> assign_new(:page_size, fn -> 10 end)
      |> assign_new(:page, fn -> 1 end)

    ~H"""
    <.pagination
      id="pagination-link-patch"
      count={@count}
      page={@page}
      page_size={@page_size}
      class="pagination"
      type={:link}
      to="/items"
      redirect={:patch}
    >
      <:prev><span>Prev</span></:prev>
      <:next><span>Next</span></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def render_toggle_group(assigns) do
    ~H"""
    <.toggle_group id="test-toggle-group">
      <:item value="a">A</:item>
      <:item value="b">B</:item>
    </.toggle_group>
    """
  end

  def render_tree_view(assigns) do
    ~H"""
    <.tree_view id="tree-test" items={Corex.Tree.new([%{label: "Item", value: "1"}])} />
    """
  end

  def render_tree_view_with_branch(assigns) do
    ~H"""
    <.tree_view id="tree-branch" items={
      Corex.Tree.new([
        %{label: "Parent", value: "p", children: [%{label: "Child", value: "c"}]}
      ])
    } />
    """
  end

  def render_tree_view_controlled(assigns) do
    ~H"""
    <.tree_view
      id="tree-ctrl"
      items={Corex.Tree.new([%{label: "Item", value: "1"}])}
      controlled
      expanded_value={[]}
      value={[]}
    />
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
    <.navigate to={@to} type="href" replace={true}>Link</.navigate>
    """
  end

  def render_navigate_with_replace(assigns) do
    ~H"""
    <.navigate to={@to} type="navigate" replace={true}>Link</.navigate>
    """
  end

  def render_navigate_method(assigns) do
    ~H"""
    <.navigate to={@to} type="navigate" method="post">Link</.navigate>
    """
  end

  def render_navigate_with_method(assigns) do
    ~H"""
    <.navigate to={@to} type="href" method="post">Link</.navigate>
    """
  end

  def render_file_upload_minimal(assigns) do
    _ = assigns

    ~H"""
    <.file_upload id="test-file-upload"  name="doc">
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def render_file_upload_full(assigns) do
    ~H"""
    <.file_upload id="file-upload-test-full" name="document" class="file-upload">
      <:label>Attachment</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def render_file_upload_with_field(assigns) do
    form = Phoenix.Component.to_form(%{"avatar" => nil}, as: :user)
    field = form[:avatar]
    assigns = assign(assigns, :field, field)

    ~H"""
    <.file_upload id="test-file-upload"  field={@field} class="file-upload">
      <:label>Avatar</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload>
    """
  end

  def render_file_upload_with_close(assigns) do
    _ = assigns

    ~H"""
    <.file_upload id="file-upload-test-close" name="doc" class="file-upload">
      <:label>Files</:label>
      <:close>
        <.heroicon name="hero-x-mark" data-test-close />
      </:close>
    </.file_upload>
    """
  end

  def render_file_upload_live_minimal(assigns) do
    _ = assigns

    upload = %Phoenix.LiveView.UploadConfig{
      name: :attachment,
      ref: "phx-test-ref",
      entries: [],
      errors: [],
      max_entries: 1,
      max_file_size: 8_000_000,
      chunk_size: 64_000,
      chunk_timeout: 10_000,
      accept: :any,
      acceptable_types: MapSet.new(),
      acceptable_exts: MapSet.new(),
      external: false,
      allowed?: true,
      auto_upload?: false,
      progress_event: nil,
      writer: nil,
      cid: nil,
      client_key: "ck",
      entry_refs_to_pids: %{},
      entry_refs_to_metas: %{}
    }

    assigns = assign(assigns, :upload, upload)

    ~H"""
    <.file_upload_live upload={@upload} field={:attachment} id="file-upload-live-test">
      <:label>Files</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
    </.file_upload_live>
    """
  end

  def render_password_input_full(assigns) do
    ~H"""
    <.password_input id="test-password-input"  name="pass">
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
    <.password_input id="test-password-input"  field={@field}>
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
