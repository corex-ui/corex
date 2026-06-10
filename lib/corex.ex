defmodule Corex do
  @moduledoc false

  @components %{
    accordion:
      {Corex.Accordion,
       [
         accordion: 1,
         accordion_root: 1,
         accordion_item: 1,
         accordion_trigger: 1,
         accordion_indicator: 1,
         accordion_content: 1,
         accordion_skeleton: 1
       ]},
    action: {Corex.Action, [action: 1]},
    angle_slider:
      {Corex.AngleSlider,
       [
         angle_slider: 1,
         angle_slider_root: 1,
         angle_slider_label: 1,
         angle_slider_control: 1,
         angle_slider_thumb: 1,
         angle_slider_value_text: 1,
         angle_slider_value: 1,
         angle_slider_text: 1,
         angle_slider_marker_group: 1,
         angle_slider_marker: 1,
         angle_slider_hidden_input: 1,
         angle_slider_skeleton: 1
       ]},
    avatar: {Corex.Avatar, [avatar: 1, avatar_skeleton: 1]},
    badge: {Corex.Badge, [badge: 1]},
    carousel:
      {Corex.Carousel,
       [
         carousel: 1,
         carousel_root: 1,
         carousel_item_group: 1,
         carousel_item: 1,
         carousel_control: 1,
         carousel_prev_trigger: 1,
         carousel_next_trigger: 1,
         carousel_indicator_group: 1,
         carousel_indicator: 1
       ]},
    checkbox: {Corex.Checkbox, [checkbox: 1, checkbox_skeleton: 1]},
    clipboard: {Corex.Clipboard, [clipboard: 1]},
    code: {Corex.Code, [code: 1]},
    collapsible: {Corex.Collapsible, [collapsible: 1, collapsible_skeleton: 1]},
    combobox: {Corex.Combobox, [combobox: 1]},
    color_picker: {Corex.ColorPicker, [color_picker: 1]},
    data_table: {Corex.DataTable, [data_table: 1]},
    data_list: {Corex.DataList, [data_list: 1]},
    date_picker: {Corex.DatePicker, [date_picker: 1]},
    dialog:
      {Corex.Dialog, [dialog: 1, dialog_title: 1, dialog_description: 1, dialog_close_trigger: 1]},
    editable: {Corex.Editable, [editable: 1]},
    file_upload: {Corex.FileUpload, [file_upload: 1]},
    file_upload_live: {Corex.FileUploadLive, [file_upload_live: 1]},
    floating_panel: {Corex.FloatingPanel, [floating_panel: 1]},
    heroicon: {Corex.Heroicon, [heroicon: 1]},
    native_input: {Corex.NativeInput, [native_input: 1]},
    hidden_input: {Corex.HiddenInput, [hidden_input: 1]},
    listbox: {Corex.Listbox, [listbox: 1]},
    h1: {Corex.Typography.H1, [h1: 1]},
    h2: {Corex.Typography.H2, [h2: 1]},
    h3: {Corex.Typography.H3, [h3: 1]},
    h4: {Corex.Typography.H4, [h4: 1]},
    p: {Corex.Typography.P, [p: 1]},
    lead: {Corex.Typography.Lead, [lead: 1]},
    small: {Corex.Typography.Small, [small: 1]},
    kbd: {Corex.Typography.Kbd, [kbd: 1]},
    blockquote: {Corex.Typography.Blockquote, [blockquote: 1]},
    list: {Corex.Typography.ListBox, [list: 1]},
    form: {Corex.Typography.Form, [form: 1]},
    layout_heading: {Corex.Layout.Heading, [layout_heading: 1]},
    box: {Corex.Layout.Box, [box: 1]},
    stack: {Corex.Layout.Stack, [stack: 1]},
    row: {Corex.Layout.Row, [row: 1]},
    grid: {Corex.Layout.Grid, [grid: 1]},
    container: {Corex.Layout.Container, [container: 1]},
    spacer: {Corex.Layout.Spacer, [spacer: 1]},
    divider: {Corex.Layout.Divider, [divider: 1]},
    icon: {Corex.Icon, [icon: 1]},
    marquee: {Corex.Marquee, [marquee: 1]},
    menu: {Corex.Menu, [menu: 1]},
    navigate: {Corex.Navigate, [navigate: 1]},
    number_input: {Corex.NumberInput, [number_input: 1]},
    pagination: {Corex.Pagination, [pagination: 1]},
    password_input: {Corex.PasswordInput, [password_input: 1]},
    pin_input: {Corex.PinInput, [pin_input: 1]},
    radio_group: {Corex.RadioGroup, [radio_group: 1]},
    select: {Corex.Select, [select: 1]},
    signature_pad: {Corex.SignaturePad, [signature_pad: 1]},
    switch: {Corex.Switch, [switch: 1]},
    tabs:
      {Corex.Tabs,
       [
         tabs: 1,
         tabs_root: 1,
         tabs_list: 1,
         tabs_trigger: 1,
         tabs_indicator: 1,
         tabs_content: 1,
         tabs_skeleton: 1
       ]},
    tags_input: {Corex.TagsInput, [tags_input: 1]},
    timer: {Corex.Timer, [timer: 1, timer_skeleton: 1]},
    tooltip: {Corex.Tooltip, [tooltip: 1]},
    toast:
      {Corex.Toast,
       [
         toast_group: 1,
         toast_client_error: 1,
         toast_server_error: 1,
         toast_connected: 1,
         toast_disconnected: 1
       ]},
    toggle: {Corex.Toggle, [toggle: 1]},
    toggle_group: {Corex.ToggleGroup, [toggle_group: 1]},
    tree_view:
      {Corex.TreeView,
       [
         tree_view: 1,
         tree_view_root: 1,
         tree_view_branch: 1,
         tree_view_branch_trigger: 1,
         tree_view_branch_indicator: 1,
         tree_view_branch_content: 1,
         tree_view_item: 1,
         tree_view_item_indicator: 1,
         tree_view_markup_item: 1,
         tree_view_markup_branch: 1,
         tree_view_skeleton: 1
       ]}
  }

  defmacro __using__(opts \\ []) do
    only = Keyword.get(opts, :only, :all)
    except = Keyword.get(opts, :except, [])
    prefix = Keyword.get(opts, :prefix)

    # Filter components based on only/except
    selected_components =
      @components
      |> Enum.filter(fn {component_name, _} ->
        include?(component_name, only, except)
      end)

    if prefix do
      # Generate wrapper functions with prefix
      wrappers =
        for {_component_name, {mod, functions}} <- selected_components,
            {func_name, arity} <- functions do
          prefixed_name = :"#{prefix}_#{func_name}"

          # Generate the appropriate number of arguments
          args = Macro.generate_arguments(arity, __MODULE__)

          quote do
            defdelegate unquote(prefixed_name)(unquote_splicing(args)),
              to: unquote(mod),
              as: unquote(func_name)
          end
        end

      # Generate aliases
      aliases =
        for {_component_name, {mod, _functions}} <- selected_components do
          quote do
            alias unquote(mod)
          end
        end

      quote do
        unquote_splicing(wrappers)
        unquote_splicing(aliases)
      end
    else
      # Normal import without prefix
      imports =
        for {_component_name, {mod, functions}} <- selected_components do
          quote do
            import unquote(mod), only: unquote(functions)
          end
        end

      aliases =
        for {_component_name, {mod, _functions}} <- selected_components do
          quote do
            alias unquote(mod)
          end
        end

      quote do
        unquote_splicing(imports)
        unquote_splicing(aliases)
      end
    end
  end

  defp include?(_name, :all, []), do: true
  defp include?(name, :all, except), do: name not in except
  defp include?(name, only, _except) when is_list(only), do: name in only

  @doc "Returns sorted ids from the component registry for MCP and tooling."
  def component_ids do
    @components |> Map.keys() |> Enum.sort()
  end

  @doc "Resolves a registered component id to module and function-component metadata."
  def component_spec(id) when is_atom(id) do
    case Map.fetch(@components, id) do
      {:ok, {mod, functions}} ->
        fns =
          Enum.map(functions, fn {name, arity} ->
            %{name: name, arity: arity}
          end)

        {:ok,
         %{
           id: id,
           module: inspect(mod),
           function_components: fns
         }}

      :error ->
        :error
    end
  end

  @doc """
  Mix compiler (from the optional `:corex_design` package) that regenerates the
  Tailwind CSS bundle. Append to a host app's `compilers/0`:

      compilers: [:phoenix_live_view] ++ Mix.compilers() ++ Corex.compilers()

  Or without LiveView:

      compilers: Mix.compilers() ++ Corex.compilers()

  `:corex_design` requires OTP 27+.

  Icons are handled by the Heroicons Tailwind plugin (`mix corex.heroicon`), not
  a Corex compiler.
  """
  def compilers, do: [:corex_design]

  @doc """
  Phoenix endpoint watcher that rebuilds design CSS when host config changes:

      watchers: Corex.watchers() ++ [esbuild: {...}]

  The watcher reloads `config/*.exs` and recompiles the design bundle. Tailwind
  `--watch` and LiveReloader handle CSS output refresh in the browser.

  Add `:corex_design` to `reloadable_compilers` so recipe edits rebuild on the
  next request during code reload:

      reloadable_compilers: [:gettext] ++ Mix.compilers() ++ [:corex_design]
  """
  def watchers do
    [
      corex_design: {Corex.Design, :install_and_run, [~w(--watch)]}
    ]
  end

  @doc "Maps a string MCP component id to its implementing module when registered."
  def component_module_for_mcp_id(id) when is_binary(id) do
    allowed = MapSet.new(for a <- component_ids(), do: to_string(a))

    if MapSet.member?(allowed, id) do
      atom_id = String.to_existing_atom(id)

      case Map.fetch(@components, atom_id) do
        {:ok, {mod, _}} -> {:ok, mod}
        :error -> :error
      end
    else
      :error
    end
  end
end
