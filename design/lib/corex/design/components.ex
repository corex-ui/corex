defmodule Corex.Design.Components do
  @moduledoc false

  @type host_width :: :fill | :fit | :auto
  @type default_max :: :none | :fit_content | {:container, String.t()}
  @type family :: :action | :selection | :field | :static

  @type role ::
          :root
          | :trigger
          | :item
          | :control
          | :input
          | :label
          | :content
          | :link
          | :error
          | :icon
          | :host_trigger
          | :host_link
          | :host_badge

  @components %{
    "accordion" => %{family: :action},
    "angle-slider" => %{family: :selection},
    "avatar" => %{family: :action},
    "badge" => %{family: :action},
    "button" => %{family: :action},
    "button-group" => %{family: :static},
    "carousel" => %{family: :action},
    "checkbox" => %{family: :selection},
    "clipboard" => %{family: :action},
    "code" => %{family: :static},
    "collapsible" => %{family: :action},
    "color-picker" => %{family: :action},
    "combobox" => %{family: :action},
    "data-list" => %{family: :static},
    "data-table" => %{family: :static},
    "date-picker" => %{family: :action},
    "dialog" => %{family: :action},
    "editable" => %{family: :action},
    "file-upload" => %{family: :action},
    "floating-panel" => %{family: :action},
    "icon" => %{family: :static},
    "layout-heading" => %{family: :static},
    "link" => %{family: :action},
    "listbox" => %{family: :action},
    "marquee" => %{family: :static},
    "menu" => %{family: :action},
    "native-input" => %{family: :field},
    "number-input" => %{family: :field},
    "pagination" => %{family: :selection},
    "password-input" => %{family: :field},
    "pin-input" => %{family: :field},
    "radio-group" => %{family: :selection},
    "scrollbar" => %{family: :static},
    "select" => %{family: :action},
    "signature-pad" => %{family: :action},
    "switch" => %{family: :selection},
    "tabs" => %{family: :selection},
    "tags-input" => %{family: :field},
    "timer" => %{family: :static},
    "toast" => %{family: :static},
    "toggle" => %{family: :selection},
    "toggle-group" => %{family: :selection},
    "tooltip" => %{family: :action},
    "tree-view" => %{family: :selection},
    "typo" => %{family: :static}
  }

  @parts [
    {"accordion", "root", :root},
    {"accordion", "item-trigger", :trigger},
    {"angle-slider", "root", :root},
    {"angle-slider", "label", :label},
    {"angle-slider", "error-text", :error},
    {"badge", :host, :host_badge},
    {"button", :host, :host_trigger},
    {"carousel", "root", :root},
    {"carousel", "prev-trigger", :trigger},
    {"carousel", "next-trigger", :trigger},
    {"carousel", "autoplay-trigger", :trigger},
    {"carousel", "indicator", :trigger},
    {"checkbox", "root", :root},
    {"checkbox", "label", :label},
    {"checkbox", "control", :control},
    {"checkbox", "error-text", :error},
    {"clipboard", "root", :root},
    {"clipboard", "label", :label},
    {"clipboard", "input", :input},
    {"clipboard", "trigger", :trigger},
    {"collapsible", "root", :root},
    {"collapsible", "trigger", :trigger},
    {"color-picker", "root", :root},
    {"color-picker", "label", :label},
    {"color-picker", "trigger", :trigger},
    {"color-picker", "channel-input", :input},
    {"color-picker", "content", :content},
    {"color-picker", "transparency-grid", :trigger},
    {"color-picker", "eye-dropper-trigger", :trigger},
    {"color-picker", "swatch-trigger", :trigger},
    {"color-picker", "error-text", :error},
    {"combobox", "root", :root},
    {"combobox", "label", :label},
    {"combobox", "input", :input},
    {"combobox", "trigger", :trigger},
    {"combobox", "clear-trigger", :trigger},
    {"combobox", "content", :content},
    {"combobox", "item", :item},
    {"combobox", "error-text", :error},
    {"data-list", "root", :root},
    {"data-list", "item-label", :label},
    {"data-table", "actions", :trigger},
    {"date-picker", "root", :root},
    {"date-picker", "label", :label},
    {"date-picker", "trigger", :trigger},
    {"date-picker", "input", :input},
    {"date-picker", "control", :label},
    {"date-picker", "table-cell-trigger", :item},
    {"date-picker", "prev-trigger", :trigger},
    {"date-picker", "next-trigger", :trigger},
    {"date-picker", "view-trigger", :trigger},
    {"date-picker", "error-text", :error},
    {"dialog", "trigger", :trigger},
    {"dialog", "close-trigger", :trigger},
    {"dialog", "content", :content},
    {"editable", "root", :root},
    {"editable", "label", :label},
    {"editable", "area", :input},
    {"editable", "input", :input},
    {"editable", "edit-trigger", :trigger},
    {"editable", "submit-trigger", :trigger},
    {"editable", "cancel-trigger", :trigger},
    {"editable", "error-text", :error},
    {"file-upload", "root", :root},
    {"file-upload", "label", :label},
    {"file-upload", "trigger", :trigger},
    {"file-upload", "item-name", :label},
    {"file-upload", "item-size-text", :label},
    {"file-upload", "item-delete-trigger", :trigger},
    {"file-upload", "error-text", :error},
    {"floating-panel", "trigger", :trigger},
    {"floating-panel", "title", :label},
    {"floating-panel", "minimize-trigger", :trigger},
    {"floating-panel", "maximize-trigger", :trigger},
    {"link", :host, :host_link},
    {"listbox", "root", :root},
    {"listbox", "label", :label},
    {"listbox", "item", :item},
    {"menu", "content", :content},
    {"menu", "trigger", :trigger},
    {"menu", "item-trigger", :trigger},
    {"menu", "item", :item},
    {"native-input", "root", :root},
    {"native-input", "label", :label},
    {"native-input", "input", :input},
    {"native-input", "error-text", :error},
    {"number-input", "root", :root},
    {"number-input", "label", :label},
    {"number-input", "input", :input},
    {"number-input", "increment-trigger", :trigger},
    {"number-input", "decrement-trigger", :trigger},
    {"number-input", "error-text", :error},
    {"pagination", "root", :root},
    {"pagination", "prev-trigger", :trigger},
    {"pagination", "next-trigger", :trigger},
    {"pagination", "item", :item},
    {"password-input", "root", :root},
    {"password-input", "label", :label},
    {"password-input", "input", :input},
    {"password-input", "visibility-trigger", :trigger},
    {"password-input", "error-text", :error},
    {"pin-input", "root", :root},
    {"pin-input", "label", :label},
    {"pin-input", "input", :input},
    {"pin-input", "error-text", :error},
    {"radio-group", "root", :root},
    {"radio-group", "label", :label},
    {"radio-group", "item-control", :control},
    {"radio-group", "error-text", :error},
    {"select", "root", :root},
    {"select", "label", :label},
    {"select", "trigger", :trigger},
    {"select", "content", :content},
    {"select", "item-group-label", :label},
    {"select", "item", :item},
    {"select", "error-text", :error},
    {"signature-pad", "root", :root},
    {"signature-pad", "label", :label},
    {"signature-pad", "clear-trigger", :trigger},
    {"signature-pad", "error-text", :error},
    {"switch", "label", :label},
    {"switch", "error-text", :error},
    {"tabs", "root", :root},
    {"tabs", "content", :content},
    {"tabs", "trigger", :item},
    {"tags-input", "root", :root},
    {"tags-input", "control", :root},
    {"tags-input", "label", :label},
    {"tags-input", "item-preview", :input},
    {"tags-input", "item-delete-trigger", :trigger},
    {"tags-input", "input", :input},
    {"tags-input", "clear-trigger", :trigger},
    {"tags-input", "error-text", :error},
    {"timer", "root", :root},
    {"timer", "item", :label},
    {"timer", "separator", :label},
    {"timer", "action-trigger", :trigger},
    {"toast", "group", :root},
    {"toast", "root", :content},
    {"toast", "title", :label},
    {"toast", "action-trigger", :trigger},
    {"toast", "close-trigger", :trigger},
    {"toggle", "root", :control},
    {"toggle-group", "root", :root},
    {"toggle-group", "item", :item},
    {"tooltip", "content", :content},
    {"tree-view", "root", :root},
    {"tree-view", "label", :label},
    {"tree-view", "item", :item},
    {"tree-view", "branch-control", :item},
    {"tree-view", "branch-text", :label}
  ]

  @elixir_id_aliases %{
    "action" => "button",
    "file_upload_live" => "file-upload",
    "heroicon" => "icon",
    "navigate" => "link"
  }

  @css_id_aliases %{
    "button" => "action",
    "icon" => "heroicon",
    "link" => "navigate"
  }

  @css_only_ids ~w(badge scrollbar typo)

  @unknown_part_hosts for {host, _part, _role} <- @parts,
                          not Map.has_key?(@components, host),
                          uniq: true,
                          do: host

  if @unknown_part_hosts != [] do
    raise CompileError,
      description:
        "Corex.Design.Components @parts references hosts missing from @components: " <>
          inspect(@unknown_part_hosts)
  end

  @max_height_hosts ~w(
    accordion collapsible color-picker combobox date-picker dialog
    floating-panel listbox menu select
  )

  @shape_hosts ~w(badge button)

  @no_variant_families MapSet.new([:selection, :field, :static])

  def ids, do: @components |> Map.keys() |> Enum.sort()

  @doc """
  CSS host ids with no HEEx component (`badge`, `scrollbar`, `typo`).

  Aliased hosts (`button` to `action`, `icon` to `heroicon`, `link` to `navigate`) are
  not included; they resolve through `fetch_elixir_id/1` via `@css_id_aliases`.
  """
  @spec css_only_ids() :: [String.t()]
  def css_only_ids, do: @css_only_ids

  @doc """
  Looks up a component's layout metadata.

  Returns `{:ok, meta} | :error`, the same shape as `fetch_css_id/1` and
  `fetch_elixir_id/1`, so every miss in this registry reads alike.
  """
  @spec fetch(String.t()) :: {:ok, map()} | :error
  def fetch(id) when is_binary(id), do: Map.fetch(@components, id)

  @doc """
  Looks up a component's layout metadata, raising when the id is unknown.

  `Map.fetch!/2` would raise a `KeyError` naming the whole registry map, which
  says nothing about which ids are valid.
  """
  @spec get!(String.t()) :: map()
  def get!(id) when is_binary(id) do
    case fetch(id) do
      {:ok, meta} ->
        meta

      :error ->
        raise ArgumentError, "unknown component id #{inspect(id)}; allowed: #{inspect(ids())}"
    end
  end

  def host_width(id) do
    css = File.read!(css_path(id))
    parse_host_width(css, host_selector(id))
  end

  def default_max(id) do
    css = File.read!(css_path(id))
    parse_host_max(css, host_selector(id))
  end

  def default_max_label(id) do
    case default_max(id) do
      :none -> "none"
      :fit_content -> "fit-content"
      {:container, step} -> step
    end
  end

  def host_width_label(id) do
    case host_width(id) do
      :fill -> "100%"
      :fit -> "fit-content"
      :auto -> "auto"
    end
  end

  def family(host) when is_binary(host), do: get!(host).family

  def family?(host) when is_binary(host), do: Map.has_key?(@components, host)

  def host_families do
    Map.new(@components, fn {id, meta} -> {id, meta.family} end)
  end

  def has_variant_axis?(host) when is_binary(host), do: family(host) == :action

  def no_variant_hosts do
    @components
    |> Enum.filter(fn {_id, meta} -> MapSet.member?(@no_variant_families, meta.family) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
  end

  def parts, do: @parts

  def parts_for(host) when is_binary(host) do
    for {^host, part, role} <- @parts, do: {part, role}
  end

  def entries_for(component_ids) when is_list(component_ids) do
    allowed = MapSet.new(component_ids, &to_string/1)

    Enum.filter(@parts, fn {host, _part, _role} -> MapSet.member?(allowed, host) end)
  end

  def grouped_selectors(component_ids) do
    component_ids
    |> entries_for()
    |> Enum.group_by(fn {_host, _part, role} -> role end, fn {host, part, _role} ->
      selector(host, part)
    end)
  end

  def selector(host, :host), do: host_selector(host)

  def selector(host, part) when is_binary(part) do
    ~s|#{host_selector(host)} :where([data-scope="#{scope(host)}"][data-part="#{part}"])|
  end

  def host_selector("code"), do: "pre.code"
  def host_selector(id) when is_binary(id), do: ".#{id}"

  def scope(host) when is_binary(host), do: host

  def axes_for(host) when is_binary(host) do
    variant_axis(host) ++
      [:semantic, :size, :radius] ++
      shape_axis(host) ++
      max_height_axis(host) ++ [:width]
  end

  defp variant_axis(host) do
    if has_variant_axis?(host), do: [:variant], else: []
  end

  defp shape_axis(host) when host in @shape_hosts, do: [:shape]
  defp shape_axis(_host), do: []

  defp max_height_axis(host) when host in @max_height_hosts, do: [:max_height]
  defp max_height_axis(_host), do: []

  def variant_steps do
    [
      %{label: "Subtle (default)", modifier: ""},
      %{label: "Solid", modifier: "ui-solid"},
      %{label: "Ghost", modifier: "ui-ghost"}
    ]
  end

  @doc """
  Resolves a Corex component id (`date_picker`, `action`) to its CSS host id.

  Returns `:error` for components with no styled host, such as `hidden_input`.
  """
  def fetch_css_id(elixir_id) when is_binary(elixir_id) do
    css_id =
      Map.get_lazy(@elixir_id_aliases, elixir_id, fn ->
        String.replace(elixir_id, "_", "-")
      end)

    if family?(css_id), do: {:ok, css_id}, else: :error
  end

  def fetch_css_id(elixir_id) when is_atom(elixir_id) do
    fetch_css_id(Atom.to_string(elixir_id))
  end

  @doc """
  Resolves a CSS host id to the Corex component id that renders it.

  Returns `:error` for the CSS-only hosts (#{Enum.join(@css_only_ids, ", ")}), which
  have no component behind them.
  """
  def fetch_elixir_id(css_id) when is_binary(css_id) do
    cond do
      css_id in @css_only_ids -> :error
      alias_id = Map.get(@css_id_aliases, css_id) -> {:ok, alias_id}
      family?(css_id) -> {:ok, String.replace(css_id, "-", "_")}
      true -> :error
    end
  end

  def css_path(id) do
    :corex_design
    |> :code.priv_dir()
    |> List.to_string()
    |> Path.join("css/components/#{id}.css")
  end

  def parse_host_width(css, selector) do
    block = host_block(css, selector)

    cond do
      block =~ ~r/width:\s*fit-content/ -> :fit
      block =~ ~r/width:\s*100%/ -> :fill
      true -> :auto
    end
  end

  def parse_host_max(css, selector) do
    block = host_block(css, selector)

    cond do
      block =~ ~r/max-width:\s*fit-content/ ->
        :fit_content

      match = Regex.run(~r/max-width:\s*var\(--container-([a-z0-9]+)\)/, block) ->
        {:container, Enum.at(match, 1)}

      true ->
        :none
    end
  end

  defp host_block(css, selector) do
    escaped = Regex.escape(selector)

    case Regex.run(~r/#{escaped}\s*\{([^}]*)\}/s, css) do
      [_, body] -> body
      _ -> ""
    end
  end
end
