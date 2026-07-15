defmodule E2eWeb.Helpers do
  use E2eWeb, :html

  defp menu_item(label, id, to, opts \\ []) do
    base = %{label: label, value: id, to: to}

    base =
      case Keyword.get(opts, :meta) do
        meta when is_map(meta) -> Map.put(base, :meta, meta)
        _ -> base
      end

    base =
      if Keyword.get(opts, :redirect) do
        Map.put(base, :redirect, Keyword.get(opts, :redirect))
      else
        base
      end

    if Keyword.get(opts, :new_tab) do
      Map.put(base, :new_tab, true)
    else
      base
    end
  end

  defp doc_form_menu_item(label, to) do
    menu_item(label, to, to)
  end

  defp maybe_add(list, true, fun), do: list ++ [fun.()]
  defp maybe_add(list, false, _fun), do: list

  @aside_no_zag ~W(action navigate data-list data-table layout-heading code native-input file-upload-live)

  defp components_docs_node(%{label: label, id: id} = cfg) do
    badges =
      []
      |> then(fn b ->
        if match?([_ | _], Map.get(cfg, :forms, [])), do: b ++ [:form], else: b
      end)
      |> then(fn b ->
        if id in ["select", "tree-view", "menu", "navigate"], do: b ++ [:navigation], else: b
      end)
      |> then(fn b ->
        if id in @aside_no_zag, do: b, else: b ++ [:zagjs]
      end)

    %{
      label: label,
      value: id,
      children: component_docs_children(cfg),
      meta: %{aside_badges: badges}
    }
  end

  defp component_docs_children(%{id: id} = cfg) do
    slug = Map.get(cfg, :slug, id)
    anatomy_to = Map.get(cfg, :anatomy_to, "/" <> slug <> "/anatomy")
    show_animation? = Map.get(cfg, :animation, false)
    api_to = Map.get(cfg, :api_to)
    events_to = Map.get(cfg, :events_to)
    patterns_to = Map.get(cfg, :patterns_to)
    animation_to = Map.get(cfg, :animation_to)
    style_to = Map.get(cfg, :style_to)
    playground_to = Map.get(cfg, :playground_to, anatomy_to)

    []
    |> maybe_add(Map.get(cfg, :playground, true) && playground_to != nil, fn ->
      menu_item(~t"Playground", playground_to, playground_to)
    end)
    |> maybe_add(Map.get(cfg, :anatomy, true), fn ->
      menu_item(~t"Anatomy", anatomy_to, anatomy_to)
    end)
    |> maybe_add(Map.get(cfg, :api, true) && api_to != nil, fn ->
      menu_item(~t"API", api_to, api_to)
    end)
    |> maybe_add(Map.get(cfg, :event, true) && events_to != nil, fn ->
      menu_item(~t"Event", events_to, events_to)
    end)
    |> maybe_add(Map.get(cfg, :pattern, true) && patterns_to != nil, fn ->
      menu_item(~t"Pattern", patterns_to, patterns_to)
    end)
    |> maybe_add(show_animation? && animation_to != nil, fn ->
      menu_item(~t"Animation", animation_to, animation_to)
    end)
    |> maybe_add(style_to != nil, fn ->
      menu_item(~t"Style", style_to, style_to)
    end)
    |> Kernel.++(Map.get(cfg, :deep_routes, []))
    |> Kernel.++(Map.get(cfg, :forms, []))
  end

  def flat_navigation_items(items) when is_list(items) do
    Enum.flat_map(items, fn
      %{value: id, to: to, children: c} = item
      when is_binary(id) and is_binary(to) and c in [[], nil] ->
        label = Map.get(item, :label) || id
        [%{value: id, to: to, label: label}]

      %{children: children} when is_list(children) and children != [] ->
        flat_navigation_items(children)

      _ ->
        []
    end)
  end

  def ancestor_ids_for_path(items, full_path) when is_list(items) do
    Enum.flat_map(items, fn
      %{value: id, children: children} when is_list(children) and children != [] ->
        leaf_ids = Enum.map(flat_navigation_items(children), & &1.value)

        if full_path in leaf_ids do
          [id | ancestor_ids_for_path(children, full_path)]
        else
          ancestor_ids_for_path(children, full_path)
        end

      _ ->
        []
    end)
  end

  def flat_navigation_list do
    form = form_menu_items() |> flat_navigation_items()
    components = components_menu_items() |> flat_navigation_items()

    form ++ components
  end

  def prev_next_page(path, direction) do
    list = flat_navigation_list()
    index = nav_index(list, path)
    nav_neighbor(list, index, direction)
  end

  defp nav_index(list, path) do
    here = if is_binary(path), do: String.trim(path), else: ""

    Enum.find_index(list, fn item ->
      item_path =
        case item.value do
          id when is_binary(id) -> E2eWeb.Path.strip_after_locale(id)
          _ -> ""
        end

      String.trim(item_path) == here
    end)
  end

  defp nav_neighbor(_list, _index, direction) when direction not in [:prev, :next], do: nil
  defp nav_neighbor(_list, nil, _direction), do: nil
  defp nav_neighbor(_list, 0, :prev), do: nil

  defp nav_neighbor(list, index, :prev) when index > 0 do
    entry = Enum.at(list, index - 1)
    %{to: entry.to, label: entry.label}
  end

  defp nav_neighbor(list, index, :next) when index >= 0 do
    case Enum.at(list, index + 1) do
      nil -> nil
      entry -> %{to: entry.to, label: entry.label}
    end
  end

  def components_menu_items do
    components =
      [
        %{
          label: ~t"Accordion",
          id: "accordion",
          anatomy_to: ~p"/accordion/anatomy",
          api: true,
          event: true,
          pattern: true,
          animation: true,
          style: true,
          playground_to: ~p"/accordion/playground",
          api_to: ~p"/accordion/api",
          events_to: ~p"/accordion/events",
          patterns_to: ~p"/accordion/patterns",
          animation_to: ~p"/accordion/animation",
          style_to: ~p"/accordion/style"
        },
        %{
          label: ~t"Action",
          id: "action",
          anatomy_to: ~p"/action/anatomy",
          style: true,
          playground: false,
          pattern: true,
          patterns_to: ~p"/action/patterns",
          style_to: ~p"/action/style"
        },
        %{
          label: ~t"Angle slider",
          id: "angle-slider",
          anatomy_to: ~p"/angle-slider/anatomy",
          style: true,
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/angle-slider/form"),
            doc_form_menu_item(~t"Live Form", ~p"/angle-slider/live-form")
          ],
          playground_to: ~p"/angle-slider/playground",
          api_to: ~p"/angle-slider/api",
          events_to: ~p"/angle-slider/events",
          patterns_to: ~p"/angle-slider/patterns",
          style_to: ~p"/angle-slider/style"
        },
        %{
          label: ~t"Avatar",
          id: "avatar",
          anatomy_to: ~p"/avatar/anatomy",
          style: true,
          api: true,
          playground_to: ~p"/avatar/playground",
          api_to: ~p"/avatar/api",
          events_to: ~p"/avatar/events",
          style_to: ~p"/avatar/style"
        },
        %{
          label: ~t"Carousel",
          id: "carousel",
          anatomy_to: ~p"/carousel/anatomy",
          api: true,
          playground_to: ~p"/carousel/playground",
          api_to: ~p"/carousel/api",
          events_to: ~p"/carousel/events",
          style: true,
          style_to: ~p"/carousel/style"
        },
        %{
          label: ~t"Checkbox",
          id: "checkbox",
          anatomy_to: ~p"/checkbox/anatomy",
          style: true,
          playground_to: ~p"/checkbox/playground",
          api_to: ~p"/checkbox/api",
          events_to: ~p"/checkbox/events",
          patterns_to: ~p"/checkbox/patterns",
          style_to: ~p"/checkbox/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/checkbox/form"),
            doc_form_menu_item(~t"Live Form", ~p"/checkbox/live-form")
          ]
        },
        %{
          label: ~t"Clipboard",
          id: "clipboard",
          anatomy_to: ~p"/clipboard/anatomy",
          style: true,
          api: true,
          event: true,
          playground_to: ~p"/clipboard/playground",
          api_to: ~p"/clipboard/api",
          events_to: ~p"/clipboard/events",
          style_to: ~p"/clipboard/style"
        },
        %{
          label: ~t"Collapsible",
          id: "collapsible",
          anatomy_to: ~p"/collapsible/anatomy",
          style: true,
          playground_to: ~p"/collapsible/playground",
          api_to: ~p"/collapsible/api",
          events_to: ~p"/collapsible/events",
          patterns_to: ~p"/collapsible/patterns",
          style_to: ~p"/collapsible/style"
        },
        %{
          label: ~t"Code",
          id: "code",
          anatomy_to: ~p"/code/anatomy",
          api: false,
          event: false,
          playground: false,
          pattern: false,
          style: true,
          style_to: ~p"/code/style"
        },
        %{
          label: ~t"Color picker",
          id: "color-picker",
          anatomy_to: ~p"/color-picker/anatomy",
          playground_to: ~p"/color-picker/playground",
          api_to: ~p"/color-picker/api",
          events_to: ~p"/color-picker/events",
          pattern: false,
          style: true,
          style_to: ~p"/color-picker/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/color-picker/form"),
            doc_form_menu_item(~t"Live Form", ~p"/color-picker/live-form")
          ]
        },
        %{
          label: ~t"Combobox",
          id: "combobox",
          anatomy_to: ~p"/combobox/anatomy",
          style: true,
          playground_to: ~p"/combobox/playground",
          api_to: ~p"/combobox/api",
          events_to: ~p"/combobox/events",
          patterns_to: ~p"/combobox/patterns",
          style_to: ~p"/combobox/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/combobox/form"),
            doc_form_menu_item(~t"Live Form", ~p"/combobox/live-form")
          ]
        },
        %{
          label: ~t"Data list",
          id: "data-list",
          anatomy_to: ~p"/data-list/anatomy",
          playground_to: ~p"/data-list/playground",
          style_to: ~p"/data-list/style",
          api: false,
          event: false,
          pattern: true,
          patterns_to: ~p"/data-list/patterns"
        },
        %{
          label: ~t"Data table",
          id: "data-table",
          anatomy_to: ~p"/data-table/anatomy",
          playground_to: ~p"/data-table/playground",
          style_to: ~p"/data-table/style",
          api: false,
          event: false,
          pattern: true,
          patterns_to: ~p"/data-table/patterns"
        },
        %{
          label: ~t"Date picker",
          id: "date-picker",
          anatomy_to: ~p"/date-picker/anatomy",
          style: true,
          playground_to: ~p"/date-picker/playground",
          api_to: ~p"/date-picker/api",
          events_to: ~p"/date-picker/events",
          pattern: false,
          style_to: ~p"/date-picker/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/date-picker/form"),
            doc_form_menu_item(~t"Live Form", ~p"/date-picker/live-form")
          ]
        },
        %{
          label: ~t"Dialog",
          id: "dialog",
          anatomy_to: ~p"/dialog/anatomy",
          playground_to: ~p"/dialog/playground",
          api_to: ~p"/dialog/api",
          events_to: ~p"/dialog/events",
          patterns_to: ~p"/dialog/patterns",
          animation: true,
          animation_to: ~p"/dialog/animation",
          style: true,
          style_to: ~p"/dialog/style"
        },
        %{
          label: ~t"Editable",
          id: "editable",
          anatomy_to: ~p"/editable/anatomy",
          style: true,
          playground_to: ~p"/editable/playground",
          api_to: ~p"/editable/api",
          events_to: ~p"/editable/events",
          pattern: false,
          style_to: ~p"/editable/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/editable/form"),
            doc_form_menu_item(~t"Live Form", ~p"/editable/live-form")
          ]
        },
        %{
          label: ~t"File upload",
          id: "file-upload",
          anatomy_to: ~p"/file-upload/anatomy",
          playground_to: ~p"/file-upload/playground",
          api_to: ~p"/file-upload/api",
          events_to: ~p"/file-upload/events",
          pattern: false,
          style: true,
          style_to: ~p"/file-upload/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/file-upload/form")
          ]
        },
        %{
          label: ~t"File upload live",
          id: "file-upload-live",
          anatomy_to: ~p"/file-upload-live/anatomy",
          playground_to: ~p"/file-upload-live/playground",
          api: false,
          event: false,
          pattern: false,
          style: true,
          style_to: ~p"/file-upload-live/style",
          forms: [
            doc_form_menu_item(~t"Live Form", ~p"/file-upload-live/form")
          ]
        },
        %{
          label: ~t"Floating panel",
          id: "floating-panel",
          anatomy_to: ~p"/floating-panel/anatomy",
          playground_to: ~p"/floating-panel/playground",
          api_to: ~p"/floating-panel/api",
          events_to: ~p"/floating-panel/events",
          pattern: false,
          style: true,
          style_to: ~p"/floating-panel/style"
        },
        %{
          label: ~t"Layout heading",
          id: "layout-heading",
          anatomy_to: ~p"/layout-heading/anatomy",
          playground: false,
          api: false,
          event: false,
          pattern: false,
          style: true,
          style_to: ~p"/layout-heading/style"
        },
        %{
          label: ~t"Listbox",
          id: "listbox",
          anatomy_to: ~p"/listbox/anatomy",
          playground_to: ~p"/listbox/playground",
          api_to: ~p"/listbox/api",
          events_to: ~p"/listbox/events",
          patterns_to: ~p"/listbox/patterns",
          style: true,
          style_to: ~p"/listbox/style"
        },
        %{
          label: ~t"Marquee",
          id: "marquee",
          anatomy_to: ~p"/marquee/anatomy",
          playground: false,
          pattern: false,
          api_to: ~p"/marquee/api",
          events_to: ~p"/marquee/events",
          style: true,
          style_to: ~p"/marquee/style"
        },
        %{
          label: ~t"Menu",
          id: "menu",
          anatomy_to: ~p"/menu/anatomy",
          playground_to: ~p"/menu/playground",
          api_to: ~p"/menu/api",
          events_to: ~p"/menu/events",
          patterns_to: ~p"/menu/patterns",
          style: true,
          style_to: ~p"/menu/style"
        },
        %{
          label: ~t"Native input",
          id: "native-input",
          anatomy_to: ~p"/native-input/anatomy",
          playground_to: ~p"/native-input/playground",
          api: false,
          event: false,
          pattern: false,
          style: true,
          style_to: ~p"/native-input/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/native-input/form"),
            doc_form_menu_item(~t"Live Form", ~p"/native-input/live-form")
          ]
        },
        %{
          label: ~t"Navigate",
          id: "navigate",
          anatomy_to: ~p"/navigate/anatomy",
          style: true,
          playground: false,
          pattern: true,
          patterns_to: ~p"/navigate/patterns",
          style_to: ~p"/navigate/style"
        },
        %{
          label: ~t"Number input",
          id: "number-input",
          anatomy_to: ~p"/number-input/anatomy",
          style: true,
          playground_to: ~p"/number-input/playground",
          api_to: ~p"/number-input/api",
          events_to: ~p"/number-input/events",
          pattern: false,
          style_to: ~p"/number-input/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/number-input/form"),
            doc_form_menu_item(~t"Live Form", ~p"/number-input/live-form")
          ]
        },
        %{
          label: ~t"Password input",
          id: "password-input",
          anatomy_to: ~p"/password-input/anatomy",
          playground_to: ~p"/password-input/playground",
          api_to: ~p"/password-input/api",
          events_to: ~p"/password-input/events",
          pattern: false,
          style: true,
          style_to: ~p"/password-input/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/password-input/form"),
            doc_form_menu_item(~t"Live Form", ~p"/password-input/live-form")
          ]
        },
        %{
          label: ~t"Pin input",
          id: "pin-input",
          anatomy_to: ~p"/pin-input/anatomy",
          style_to: ~p"/pin-input/style",
          playground_to: ~p"/pin-input/playground",
          api_to: ~p"/pin-input/api",
          events_to: ~p"/pin-input/events",
          pattern: false,
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/pin-input/form"),
            doc_form_menu_item(~t"Live Form", ~p"/pin-input/live-form")
          ]
        },
        %{
          label: ~t"Radio group",
          id: "radio-group",
          anatomy_to: ~p"/radio-group/anatomy",
          style_to: ~p"/radio-group/style",
          playground_to: ~p"/radio-group/playground",
          api_to: ~p"/radio-group/api",
          events_to: ~p"/radio-group/events",
          patterns_to: ~p"/radio-group/patterns",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/radio-group/form"),
            doc_form_menu_item(~t"Live Form", ~p"/radio-group/live-form")
          ]
        },
        %{
          label: ~t"Select",
          id: "select",
          anatomy_to: ~p"/select/anatomy",
          style: true,
          playground_to: ~p"/select/playground",
          api_to: ~p"/select/api",
          events_to: ~p"/select/events",
          patterns_to: ~p"/select/patterns",
          style_to: ~p"/select/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/select/form"),
            doc_form_menu_item(~t"Live Form", ~p"/select/live-form")
          ]
        },
        %{
          label: ~t"Signature pad",
          id: "signature-pad",
          pattern: false,
          style: true,
          anatomy_to: ~p"/signature-pad/anatomy",
          playground_to: ~p"/signature-pad/playground",
          api_to: ~p"/signature-pad/api",
          events_to: ~p"/signature-pad/events",
          style_to: ~p"/signature-pad/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/signature-pad/form"),
            doc_form_menu_item(~t"Live Form", ~p"/signature-pad/live-form")
          ]
        },
        %{
          label: ~t"Switch",
          id: "switch",
          anatomy_to: ~p"/switch/anatomy",
          style: true,
          playground_to: ~p"/switch/playground",
          api_to: ~p"/switch/api",
          events_to: ~p"/switch/events",
          patterns_to: ~p"/switch/patterns",
          style_to: ~p"/switch/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/switch/form"),
            doc_form_menu_item(~t"Live Form", ~p"/switch/live-form")
          ]
        },
        %{
          label: ~t"Tabs",
          id: "tabs",
          style: true,
          anatomy_to: ~p"/tabs/anatomy",
          playground_to: ~p"/tabs/playground",
          api_to: ~p"/tabs/api",
          events_to: ~p"/tabs/events",
          patterns_to: ~p"/tabs/patterns",
          style_to: ~p"/tabs/style"
        },
        %{
          label: ~t"Tags input",
          id: "tags-input",
          anatomy_to: ~p"/tags-input/anatomy",
          playground_to: ~p"/tags-input/playground",
          api_to: ~p"/tags-input/api",
          events_to: ~p"/tags-input/events",
          patterns_to: ~p"/tags-input/patterns",
          style: true,
          style_to: ~p"/tags-input/style",
          forms: [
            doc_form_menu_item(~t"Controller Form", ~p"/tags-input/form"),
            doc_form_menu_item(~t"Live Form", ~p"/tags-input/live-form")
          ]
        },
        %{
          label: ~t"Timer",
          id: "timer",
          style: true,
          anatomy_to: ~p"/timer/anatomy",
          pattern: false,
          playground_to: ~p"/timer/playground",
          api_to: ~p"/timer/api",
          events_to: ~p"/timer/events",
          style_to: ~p"/timer/style"
        },
        %{
          label: ~t"Toast",
          id: "toast",
          pattern: false,
          event: false,
          anatomy_to: ~p"/toast/anatomy",
          playground_to: ~p"/toast/playground",
          api_to: ~p"/toast/api"
        },
        %{
          label: ~t"Pagination",
          id: "pagination",
          style: true,
          anatomy_to: ~p"/pagination/anatomy",
          playground_to: ~p"/pagination/playground",
          api_to: ~p"/pagination/api",
          events_to: ~p"/pagination/events",
          patterns_to: ~p"/pagination/patterns",
          style_to: ~p"/pagination/style"
        },
        %{
          label: ~t"Toggle",
          id: "toggle",
          anatomy_to: ~p"/toggle/anatomy",
          playground_to: ~p"/toggle/playground",
          api_to: ~p"/toggle/api",
          events_to: ~p"/toggle/events",
          patterns_to: ~p"/toggle/patterns",
          style: true,
          style_to: ~p"/toggle/style"
        },
        %{
          label: ~t"Toggle group",
          id: "toggle-group",
          style: true,
          anatomy_to: ~p"/toggle-group/anatomy",
          playground_to: ~p"/toggle-group/playground",
          api_to: ~p"/toggle-group/api",
          events_to: ~p"/toggle-group/events",
          patterns_to: ~p"/toggle-group/patterns",
          style_to: ~p"/toggle-group/style"
        },
        %{
          label: ~t"Tooltip",
          id: "tooltip",
          style: true,
          playground: false,
          pattern: true,
          anatomy_to: ~p"/tooltip/anatomy",
          api_to: ~p"/tooltip/api",
          events_to: ~p"/tooltip/events",
          patterns_to: ~p"/tooltip/patterns",
          style_to: ~p"/tooltip/style"
        },
        %{
          label: ~t"Tree view",
          id: "tree-view",
          anatomy_to: ~p"/tree-view/anatomy",
          api: true,
          event: true,
          pattern: true,
          animation: true,
          style: true,
          playground_to: ~p"/tree-view/playground",
          api_to: ~p"/tree-view/api",
          events_to: ~p"/tree-view/events",
          patterns_to: ~p"/tree-view/patterns",
          animation_to: ~p"/tree-view/animation",
          style_to: ~p"/tree-view/style"
        }
      ]
      |> Enum.sort_by(& &1.label)

    Corex.Tree.new(Enum.map(components, &components_docs_node/1))
  end

  def form_menu_items do
    Corex.Tree.new([
      menu_item(~t"Controller View", ~p"/users", ~p"/users"),
      menu_item(~t"Live View", ~p"/admins", ~p"/admins"),
      menu_item(~t"Pattern", ~p"/forms/patterns", ~p"/forms/patterns")
    ])
  end

  @hexdocs_url "https://hexdocs.pm/corex"

  def hexdocs_url, do: @hexdocs_url

  def site_nav_menu_items do
    Corex.Tree.new([
      menu_item(~t"Showcase", ~p"/showcases", ~p"/showcases"),
      menu_item(~t"Blog", ~p"/blog", ~p"/blog"),
      menu_item(~t"Hex Doc", @hexdocs_url, @hexdocs_url, new_tab: true, redirect: :href)
    ])
  end
end
