defmodule Corex.Design.Typography do
  @moduledoc false

  alias Corex.Design.Style

  @elements ~W(
    h1 h2 h3 h4 p p.display small mark abbr sup sub kbd del ins b strong i em
    blockquote hr dt figcaption .list
  )

  @component_ids ~W(h1 h2 h3 h4 p lead small kbd blockquote list form)a

  def elements, do: @elements
  def component_ids, do: @component_ids

  @element_keys %{
    h1: "h1",
    h2: "h2",
    h3: "h3",
    h4: "h4",
    p: "p",
    lead: "p.display",
    small: "small",
    kbd: "kbd",
    blockquote: "blockquote",
    list: ".list"
  }

  def element_base(id) when is_atom(id) do
    default()
    |> Map.fetch!(Map.fetch!(@element_keys, id))
  end

  def form_base do
    form_box()
    |> Map.drop([:width, :max_width])
  end

  def default do
    %{
      "h1" => heading(:"3xl", :"4xl", :bold),
      "h2" => heading(:"2xl", :"3xl", :bold),
      "h3" => heading(:lg, :xl, :semibold),
      "h4" => heading(:base, :lg, :normal),
      "p" => body_text(),
      "p.display" => display_lead(),
      "small" => small_text(),
      "mark" => %{
        background_color: {:color, :success},
        color: {:color, :on_success},
        padding: {:raw, "0.1em 0.25em"},
        border_radius: {:radius, :sm}
      },
      "abbr[title]" => %{
        border_bottom: {:raw, "1px dotted var(--color-border)"},
        cursor: :pointer,
        text_decoration_line: :none
      },
      "sup" => %{
        font_size: {:raw, "0.75em"},
        line_height: {:raw, "1"},
        position: :relative,
        vertical_align: :baseline,
        top: {:raw, "-0.5em"}
      },
      "sub" => %{
        font_size: {:raw, "0.75em"},
        line_height: {:raw, "1"},
        position: :relative,
        vertical_align: :baseline,
        bottom: {:raw, "-0.25em"}
      },
      "kbd" => %{
        font_family: {:font, :mono},
        background_color: {:color, :surface_raised},
        color: {:color, :on_page},
        border_radius: {:radius, :md},
        border: {:raw, "1px solid var(--color-border)"},
        padding: {:space, :sm},
        margin_inline: {:space, :sm}
      },
      "del" => %{text_decoration_line: :line_through, color: {:color, :alert}},
      "ins" => %{text_decoration_line: :underline, color: {:color, :success}},
      "b" => %{font_weight: {:weight, :semibold}},
      "strong" => %{font_weight: {:weight, :semibold}},
      "i" => %{font_style: :italic},
      "em" => %{font_style: :italic},
      "blockquote" => blockquote(),
      "blockquote p" => %{margin_block: {:raw, "0"}},
      "hr" => %{
        border_top: {:raw, "1px solid var(--color-border)"},
        margin_block: {:raw, "5em"},
        margin_inline: :auto,
        width: {:raw, "80%"}
      },
      "dt" => %{font_weight: {:weight, :semibold}, font_style: :italic},
      "figcaption" => figcaption(),
      ".list" => list_table(),
      ".list li" => list_item(),
      ".list li:last-child" => %{border_bottom: {:raw, "none"}},
      ".list li:hover" => %{background_color: {:color, :surface_raised}}
    }
  end

  def merge(base, override) when is_map(base) and is_map(override) do
    Map.merge(base, override, fn _key, left, right ->
      if is_map(left) and is_map(right), do: Style.merge(left, right), else: right
    end)
  end

  def merge(base, nil), do: base
  def merge(base, %{}), do: base

  defp heading(base_step, md_step, weight) do
    %{
      font_family: {:font, :sans},
      font_size: {:text, base_step},
      line_height: {:leading, base_step},
      font_weight: {:weight, weight},
      color: {:color, :on_page},
      md: %{
        font_size: {:text, md_step},
        line_height: {:leading, md_step}
      }
    }
  end

  defp body_text do
    %{
      font_size: {:text, :base},
      line_height: {:leading, :base},
      font_weight: {:weight, :normal},
      color: {:color, :on_page},
      margin_block: {:space, :md}
    }
  end

  defp display_lead do
    %{
      font_family: {:font, :sans},
      font_size: {:text, :lg},
      line_height: {:leading, :lg},
      font_weight: {:weight, :normal},
      md: %{
        font_size: {:text, :xl},
        line_height: {:leading, :xl}
      },
      lg: %{
        font_size: {:text, :"2xl"},
        line_height: {:leading, :"2xl"}
      }
    }
  end

  defp small_text do
    %{
      font_size: {:text, :xs},
      line_height: {:leading, :xs},
      font_weight: {:weight, :normal},
      margin_block: {:space, :md},
      md: %{
        font_size: {:text, :sm},
        line_height: {:leading, :sm}
      }
    }
  end

  defp blockquote do
    %{
      background_color: {:color, :surface_raised},
      color: {:color, :on_page},
      box_shadow: {:shadow, :md},
      font_style: :italic,
      border: {:raw, "1px solid var(--color-border)"},
      border_inline_start: {:raw, "4px solid var(--color-info)"},
      border_radius: {:radius, :md},
      padding_block: {:size, :md},
      padding: {:space, :md},
      gap: {:space, :md},
      width: {:raw, "fit-content"}
    }
  end

  defp list_item do
    %{
      text_align: :start,
      padding: {:space, :md},
      border_bottom: {:raw, "1px solid var(--color-border)"},
      white_space: :normal,
      color: {:color, :on_page}
    }
  end

  defp figcaption do
    %{
      font_size: {:text, :xs},
      line_height: {:leading, :xs},
      color: {:color, :on_muted},
      margin_top: {:raw, "1em"},
      md: %{
        font_size: {:text, :sm},
        line_height: {:leading, :sm}
      }
    }
  end

  defp list_table do
    %{
      width: {:raw, "100%"},
      font_size: {:text, :base},
      line_height: {:leading, :base},
      margin_block: {:raw, "2em"},
      border: {:raw, "1px solid var(--color-border)"},
      border_radius: {:radius, :md},
      overflow: :hidden,
      list_style: :none,
      padding: 0
    }
  end

  defp form_box do
    %{
      width: {:raw, "100%"},
      max_width: {:container, :md},
      display: :flex,
      flex_direction: :column,
      gap: {:space, :md},
      padding: {:space, :lg},
      background_color: {:color, :surface_raised},
      border: {:raw, "1px solid var(--color-border)"},
      color: {:color, :on_page},
      border_radius: {:radius, :md}
    }
  end
end
