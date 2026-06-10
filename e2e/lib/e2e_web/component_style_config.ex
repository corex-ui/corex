defmodule E2eWeb.ComponentStyleConfig do
  @moduledoc false

  alias E2eWeb.DocPageMatrix

  @demo_modules %{
    accordion: E2eWeb.Demos.AccordionDemo,
    action: E2eWeb.Demos.ActionDemo,
    angle_slider: E2eWeb.Demos.AngleSliderDemo,
    avatar: E2eWeb.Demos.AvatarDemo,
    carousel: E2eWeb.Demos.CarouselDemo,
    checkbox: E2eWeb.Demos.CheckboxDemo,
    clipboard: E2eWeb.Demos.ClipboardDemo,
    code: E2eWeb.Demos.CodeDemo,
    collapsible: E2eWeb.Demos.CollapsibleDemo,
    color_picker: E2eWeb.Demos.ColorPickerDemo,
    combobox: E2eWeb.Demos.ComboboxDemo,
    data_list: E2eWeb.Demos.DataListDemo,
    data_table: E2eWeb.Demos.DataTableDemo,
    date_picker: E2eWeb.Demos.DatePickerDemo,
    dialog: E2eWeb.Demos.DialogDemo,
    editable: E2eWeb.Demos.EditableDemo,
    file_upload: E2eWeb.Demos.FileUploadDemo,
    floating_panel: E2eWeb.Demos.FloatingPanelDemo,
    layout_heading: E2eWeb.Demos.LayoutHeadingDemo,
    listbox: E2eWeb.Demos.ListboxDemo,
    marquee: E2eWeb.Demos.MarqueeDemo,
    menu: E2eWeb.Demos.MenuDemo,
    native_input: E2eWeb.Demos.NativeInputDemo,
    navigate: E2eWeb.Demos.NavigateDemo,
    number_input: E2eWeb.Demos.NumberInputDemo,
    pagination: E2eWeb.Demos.PaginationDemo,
    password_input: E2eWeb.Demos.PasswordInputDemo,
    pin_input: E2eWeb.Demos.PinInputDemo,
    radio_group: E2eWeb.Demos.RadioGroupDemo,
    select: E2eWeb.Demos.SelectDemo,
    signature_pad: E2eWeb.Demos.SignatureDemo,
    switch: E2eWeb.Demos.SwitchDemo,
    tabs: E2eWeb.Demos.TabsDemo,
    tags_input: E2eWeb.Demos.TagsInputDemo,
    timer: E2eWeb.Demos.TimerDemo,
    toast: E2eWeb.Demos.ToastDemo,
    toggle: E2eWeb.Demos.ToggleDemo,
    toggle_group: E2eWeb.Demos.ToggleGroupDemo,
    tooltip: E2eWeb.Demos.TooltipDemo,
    tree_view: E2eWeb.Demos.TreeViewDemo
  }

  @playground_axes %{
    accordion: [:semantic, :variant, :size, :text, :radius, :width, :max_width, :height, :max_height],
    action: [:as, :semantic, :variant, :size, :radius, :shape, :disabled],
    angle_slider: [:semantic, :size],
    avatar: [:semantic, :size, :radius],
    carousel: [:semantic, :size, :radius],
    checkbox: [:semantic, :size],
    clipboard: [:size],
    code: [:size, :max_width],
    collapsible: [:semantic, :size],
    color_picker: [:semantic, :size],
    combobox: [:semantic, :size, :max_width],
    data_list: [:semantic, :text, :max_width],
    data_table: [],
    date_picker: [:semantic, :size, :radius],
    dialog: [:semantic, :size, :text, :radius],
    editable: [:semantic, :size, :radius, :max_width],
    file_upload: [:semantic, :size, :radius],
    floating_panel: [:semantic, :radius],
    layout_heading: [:semantic, :max_width],
    listbox: [:semantic, :size, :max_width],
    marquee: [:size, :max_width],
    menu: [:semantic, :size],
    native_input: [:semantic, :size, :radius, :max_width],
    navigate: [:semantic, :size],
    number_input: [:semantic, :size, :max_width],
    pagination: [:semantic, :size, :text, :radius, :max_width],
    password_input: [:semantic, :size, :radius],
    pin_input: [:semantic, :size, :radius],
    radio_group: [:semantic, :size, :max_width],
    select: [:semantic, :variant, :size, :text, :radius, :max_width],
    signature_pad: [:size, :radius, :max_width],
    switch: [:semantic, :size],
    tabs: [:semantic, :size, :text, :radius, :max_width],
    tags_input: [:semantic, :size, :text, :radius, :max_width],
    timer: [:semantic, :size, :text, :radius],
    toast: [:semantic, :size, :radius],
    toggle: [:semantic, :size, :radius, :disabled],
    toggle_group: [:semantic, :size, :radius, :disabled],
    tooltip: [:semantic, :size, :text],
    tree_view: [:semantic, :size, :text, :radius, :max_width]
  }

  @custom_playgrounds %{
    accordion: E2eWeb.AccordionStylePlayground,
    action: E2eWeb.ActionStylePlayground
  }

  @custom_lives %{
    accordion: E2eWeb.AccordionStyleLive,
    action: E2eWeb.ActionStyleLive,
    data_table: E2eWeb.DataTableStyleLive
  }

  @section_titles %{
    all_types: "All types",
    button_cta: "Button CTA",
    drawing_color: "Drawing color",
    link: "Link look",
    markers: "Markers",
    modifiers: "Modifiers",
    sidebar: "Sidebar",
    states: "States",
    trigger: "Trigger",
    trigger_color: "Trigger color",
    variant_semantic: "Variant × semantic"
  }

  @axis_sections ~w(semantic size text radius width max_width height max_height)a

  def components_with_style do
    DocPageMatrix.all_components()
    |> Enum.filter(&(:style in DocPageMatrix.wallaby_pages(&1)))
  end

  def macro_components do
    components_with_style()
    |> Enum.reject(&Map.has_key?(@custom_lives, &1))
  end

  def all, do: Enum.map(components_with_style(), &build_entry/1)

  def get(component) when is_atom(component) do
    build_entry(component)
  end

  def demo_module(component), do: Map.fetch!(@demo_modules, component)

  def playground_axes(component), do: Map.get(@playground_axes, component, [:semantic, :size])

  def playground_module(component) do
    Map.get(@custom_playgrounds, component, E2eWeb.ComponentStylePlayground)
  end

  def live_module(component) do
    Map.get(@custom_lives, component, generated_live_module(component))
  end

  def generated_live_module(component) do
    Module.concat([E2eWeb, "#{component |> Atom.to_string() |> Macro.camelize()}StyleLive"])
  end

  def slug(component) do
    component |> Atom.to_string() |> String.replace("_", "-")
  end

  def page_id(component), do: "#{slug(component)}-style-page"

  def title(component) do
    name =
      component
      |> Atom.to_string()
      |> String.replace("_", " ")
      |> Phoenix.Naming.humanize()

    "#{name} · Style"
  end

  def matrix_sections(component) do
    component
    |> demo_module()
    |> detect_sections()
  end

  defp build_entry(component) do
    %{
      component: component,
      title: title(component),
      demo_module: demo_module(component),
      playground_axes: playground_axes(component),
      playground_module: playground_module(component),
      live_module: live_module(component),
      matrix_sections: matrix_sections(component),
      page_id: page_id(component),
      slug: slug(component)
    }
  end

  defp detect_sections(demo_module) do
    demo_module.__info__(:functions)
    |> Enum.flat_map(fn
      {name, 1} ->
        case Atom.to_string(name) do
          "styling_" <> rest ->
            case String.split(rest, "_example", parts: 2) do
              [section, ""] -> [{section, name}]
              _ -> []
            end

          _ ->
            []
        end

      _ ->
        []
    end)
    |> Enum.sort_by(fn {section, _} -> section end)
    |> Enum.map(fn {section, example_fun} ->
      section_atom = String.to_atom(section)

      %{
        key: section_atom,
        title: section_title(section_atom),
        values: section_values(demo_module, section_atom),
        code: section_code(demo_module, section_atom),
        code_tabs: section_code_tabs(demo_module, section_atom),
        example_fun: example_fun,
        demo_module: demo_module
      }
    end)
  end

  defp section_title(section) do
    Map.get(@section_titles, section, humanize_section(section))
  end

  defp humanize_section(section) do
    section
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> Phoenix.Naming.humanize()
  end

  defp section_values(demo_module, section) do
    values_fun = String.to_atom("styling_#{section}_values")

    cond do
      function_exported?(demo_module, values_fun, 0) ->
        apply(demo_module, values_fun, [])

      section in @axis_sections and function_exported?(demo_module, :styling_axis_values, 1) ->
        apply(demo_module, :styling_axis_values, [section])

      true ->
        nil
    end
  end

  defp section_code(demo_module, section) do
    code_fun = String.to_atom("styling_#{section}_code")

    if function_exported?(demo_module, code_fun, 0) do
      apply(demo_module, code_fun, [])
    else
      heex_fun = String.to_atom("styling_#{section}_heex")

      if function_exported?(demo_module, heex_fun, 0) do
        apply(demo_module, heex_fun, [])
      else
        nil
      end
    end
  end

  defp section_code_tabs(demo_module, section) do
    tabs_fun = String.to_atom("styling_#{section}_code_tabs")

    if function_exported?(demo_module, tabs_fun, 0) do
      apply(demo_module, tabs_fun, [])
    else
      []
    end
  end
end
