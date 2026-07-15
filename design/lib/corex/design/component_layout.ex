defmodule Corex.Design.ComponentLayout do
  @moduledoc false

  @type host_width :: :fill | :fit | :auto
  @type default_max :: :none | :fit_content | {:container, String.t()}

  @layouts %{
    "accordion" => %{host_width: :fill, default_max: {:container, "md"}},
    "angle-slider" => %{
      host_width: :fit,
      default_max: {:container, "6xs"},
      orientation: %{horizontal: {:container, "3xs"}}
    },
    "avatar" => %{host_width: :auto, default_max: :none},
    "badge" => %{host_width: :fit, default_max: :fit_content},
    "button" => %{host_width: :fit, default_max: :none},
    "carousel" => %{host_width: :fill, default_max: {:container, "md"}},
    "checkbox" => %{host_width: :fill, default_max: {:container, "5xs"}},
    "clipboard" => %{host_width: :fit, default_max: :none},
    "code" => %{host_width: :fill, default_max: {:container, "md"}},
    "collapsible" => %{host_width: :fill, default_max: {:container, "md"}},
    "color-picker" => %{host_width: :fit, default_max: :fit_content},
    "combobox" => %{
      host_width: :fill,
      default_max: {:container, "3xs"},
      orientation: %{horizontal: {:container, "md"}}
    },
    "data-list" => %{host_width: :fill, default_max: {:container, "md"}},
    "data-table" => %{host_width: :fill, default_max: {:container, "md"}},
    "date-picker" => %{host_width: :fit, default_max: :none},
    "dialog" => %{host_width: :auto, default_max: :none},
    "editable" => %{host_width: :fit, default_max: :none},
    "file-upload" => %{host_width: :fill, default_max: {:container, "md"}},
    "floating-panel" => %{host_width: :auto, default_max: :none},
    "icon" => %{host_width: :auto, default_max: :none},
    "layout-heading" => %{host_width: :fill, default_max: :none},
    "link" => %{host_width: :auto, default_max: :none},
    "listbox" => %{
      host_width: :fill,
      default_max: {:container, "3xs"},
      orientation: %{horizontal: {:container, "md"}}
    },
    "marquee" => %{host_width: :fill, default_max: {:container, "md"}},
    "menu" => %{host_width: :auto, default_max: :none},
    "native-input" => %{host_width: :fill, default_max: {:container, "xs"}},
    "number-input" => %{host_width: :fill, default_max: {:container, "5xs"}},
    "pagination" => %{host_width: :fit, default_max: {:container, "md"}},
    "password-input" => %{host_width: :fill, default_max: {:container, "xs"}},
    "pin-input" => %{host_width: :fit, default_max: {:container, "md"}},
    "radio-group" => %{host_width: :fit, default_max: {:container, "md"}},
    "scrollbar" => %{host_width: :auto, default_max: :none},
    "select" => %{host_width: :fill, default_max: {:container, "3xs"}},
    "signature-pad" => %{host_width: :fill, default_max: {:container, "xs"}},
    "switch" => %{host_width: :fit, default_max: :none},
    "tabs" => %{host_width: :fill, default_max: {:container, "md"}},
    "tags-input" => %{host_width: :fill, default_max: {:container, "md"}},
    "timer" => %{host_width: :fit, default_max: :none},
    "toast" => %{host_width: :auto, default_max: {:container, "xs"}},
    "toggle" => %{host_width: :fit, default_max: :none},
    "toggle-group" => %{host_width: :fit, default_max: {:container, "5xs"}},
    "tooltip" => %{host_width: :auto, default_max: :none},
    "tree-view" => %{host_width: :fill, default_max: {:container, "md"}},
    "typo" => %{host_width: :auto, default_max: :none}
  }

  def ids, do: Map.keys(@layouts) |> Enum.sort()

  def get(id) when is_binary(id) do
    Map.fetch!(@layouts, id)
  end

  def get!(id), do: get(id)

  def host_width(id), do: get(id).host_width

  def default_max(id), do: get(id).default_max

  def orientation_defaults(id) do
    Map.get(get(id), :orientation, %{})
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

  def css_path(id) do
    root =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    Path.join(root, "#{id}.css")
  end

  def host_selector(id) do
    case id do
      "code" -> "pre.code"
      _ -> ".#{id}"
    end
  end

  def parse_host_width(css, selector) do
    block = host_block(css, selector)

    cond do
      block =~ ~r/width:\s*fit-content/ -> :fit
      block =~ ~r/width:\s*100%/ -> :fill
      block =~ ~r/width:\s*auto/ -> :auto
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
