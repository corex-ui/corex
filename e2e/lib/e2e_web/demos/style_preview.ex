defmodule E2eWeb.Demos.StylePreview do
  @moduledoc false

  use E2eWeb, :html

  alias E2eWeb.Demos.StylePlayground, as: SP

  @previews %{
    angle_slider: {E2eWeb.Demos.AngleSliderDemo, :minimal_example},
    carousel: {E2eWeb.Demos.CarouselDemo, :minimal_example},
    collapsible: {E2eWeb.Demos.CollapsibleDemo, :minimal_example},
    color_picker: {E2eWeb.Demos.ColorPickerDemo, :minimal_example},
    combobox: {E2eWeb.Demos.ComboboxDemo, :minimal_example},
    data_list: {E2eWeb.Demos.DataListDemo, :minimal_example},
    date_picker: {E2eWeb.Demos.DatePickerDemo, :minimal_example},
    dialog: {E2eWeb.Demos.DialogDemo, :minimal_example},
    editable: {E2eWeb.Demos.EditableDemo, :minimal_example},
    file_upload: {E2eWeb.Demos.FileUploadDemo, :minimal_example},
    floating_panel: {E2eWeb.Demos.FloatingPanelDemo, :minimal_example},
    listbox: {E2eWeb.Demos.ListboxDemo, :minimal_example},
    menu: {E2eWeb.Demos.MenuDemo, :minimal_example},
    native_input: {E2eWeb.Demos.NativeInputDemo, :minimal_example},
    number_input: {E2eWeb.Demos.NumberInputDemo, :minimal_example},
    pagination: {E2eWeb.Demos.PaginationDemo, :minimal_example},
    password_input: {E2eWeb.Demos.PasswordInputDemo, :minimal_example},
    pin_input: {E2eWeb.Demos.PinInputDemo, :minimal_example},
    radio_group: {E2eWeb.Demos.RadioGroupDemo, :minimal_example},
    signature_pad: {E2eWeb.Demos.SignatureDemo, :minimal_example},
    tabs: {E2eWeb.Demos.TabsDemo, :minimal_example},
    tags_input: {E2eWeb.Demos.TagsInputDemo, :minimal_example},
    toast: {E2eWeb.Demos.ToastDemo, :minimal_example},
    toggle_group: {E2eWeb.Demos.ToggleGroupDemo, :minimal_example},
    tooltip: {E2eWeb.Demos.TooltipDemo, :minimal_example},
    tree_view: {E2eWeb.Demos.TreeViewDemo, :minimal_example}
  }

  def preview(component, assigns) do
    controls = Map.get(assigns, :controls, %{})
    assigns = Map.put(assigns, :controls, controls)

    case Map.get(@previews, component) do
      {module, fun} ->
        apply(module, fun, [assigns])

      nil ->
        apply(__MODULE__, String.to_atom("preview_#{component}"), [assigns])
    end
  end

  def preview_checkbox(assigns) do
    ~H"""
    <.checkbox
      id={SP.preview_id(:checkbox)}
      semantic={SP.attr(@controls, :checkbox, :semantic)}
      size={SP.attr(@controls, :checkbox, :size)}
      checked
    >
      <:label>Option</:label>
      <:indicator>
        <.heroicon name="hero-check" />
      </:indicator>
    </.checkbox>
    """
  end

  def preview_switch(assigns) do
    ~H"""
    <.switch
      id={SP.preview_id(:switch)}
      semantic={SP.attr(@controls, :switch, :semantic)}
      size={SP.attr(@controls, :switch, :size)}
      checked
    >
      <:label>Enable</:label>
    </.switch>
    """
  end

  def preview_toggle(assigns) do
    _ = assigns
    E2eWeb.Demos.ToggleDemo.minimal_example(%{})
  end

  def preview_select(assigns) do
    ~H"""
    <.select
      id={SP.preview_id(:select)}
      semantic={SP.attr(@controls, :select, :semantic)}
      variant={SP.attr(@controls, :select, :variant)}
      size={SP.attr(@controls, :select, :size)}
      text={SP.attr(@controls, :select, :text)}
      radius={SP.attr(@controls, :select, :radius)}
      max_width={SP.attr(@controls, :select, :max_width)}
      items={select_items()}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    </.select>
    """
  end

  def preview_timer(assigns) do
    ~H"""
    <.timer
      id={SP.preview_id(:timer)}
      semantic={SP.attr(@controls, :timer, :semantic)}
      size={SP.attr(@controls, :timer, :size)}
      text={SP.attr(@controls, :timer, :text)}
      radius={SP.attr(@controls, :timer, :radius)}
      start_ms={60_000}
    />
    """
  end

  def preview_avatar(assigns) do
    ~H"""
    <.avatar
      id={SP.preview_id(:avatar)}
      size={SP.attr(@controls, :avatar, :size)}
      radius={SP.attr(@controls, :avatar, :radius)}
      src=""
    >
      <:fallback>JD</:fallback>
    </.avatar>
    """
  end

  def preview_navigate(assigns) do
    ~H"""
    <.navigate
      id={SP.preview_id(:navigate)}
      semantic={SP.attr(@controls, :navigate, :semantic)}
      size={SP.attr(@controls, :navigate, :size)}
      to="#"
    >
      Link
    </.navigate>
    """
  end

  def preview_code(assigns) do
    ~H"""
    <.code
      id={SP.preview_id(:code)}
      code="lorem()"
      size={SP.attr(@controls, :code, :size)}
      max_width={SP.attr(@controls, :code, :max_width)}
    />
    """
  end

  def preview_clipboard(assigns) do
    ~H"""
    <.clipboard
      id={SP.preview_id(:clipboard)}
      size={SP.attr(@controls, :clipboard, :size)}
      value="Copy me"
    />
    """
  end

  def preview_layout_heading(assigns) do
    ~H"""
    <.layout_heading
      id={SP.preview_id(:layout_heading)}
      semantic={SP.attr(@controls, :layout_heading, :semantic)}
      max_width={SP.attr(@controls, :layout_heading, :max_width)}
      title="Heading"
    />
    """
  end

  def preview_marquee(assigns) do
    _ = assigns
    E2eWeb.Demos.MarqueeDemo.anatomy_minimal_example(%{})
  end

  defp select_items do
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])
  end
end
