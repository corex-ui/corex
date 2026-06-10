defmodule Corex.Design.Fragment do
  @moduledoc false

  alias Corex.Design.Rule

  @doc """
  Returns the declarations and nested rules for a shared style fragment (the
  Tailwind-free replacement for the old `@utility ui-*` mixins). The emitter
  splices these inline wherever a rule declares `decls: [include: <id>]`.
  """
  @utility_ids ~W(part_root part_trigger part_icon part_content part_label part_input part_item part_link part_error part_readonly part_loading)a

  def utility_ids, do: @utility_ids

  def get!(id) do
    case fetch(id) do
      nil -> raise ArgumentError, "unknown design fragment #{inspect(id)}"
      fragment -> fragment
    end
  end

  def utility_name(id) when id in @utility_ids do
    id |> Atom.to_string() |> String.replace("_", "-")
  end

  defp frag(decls, children \\ []), do: %{decls: decls, children: children}

  defp part_readonly_lock_mask do
    xmlns = Enum.join(["http", "://", "www.", "w3.org", "/2000", "/svg"])

    svg =
      "<svg xmlns='#{xmlns}' viewBox='0 0 20 20' fill='currentColor'>" <>
        "<path fill-rule='evenodd' d='M10 1a4.5 4.5 0 0 0-4.5 4.5V9H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1ZM8.5 5.5V9H14V5.5a3.5 3.5 0 1 0-7 0Z' clip-rule='evenodd'/>" <>
        "</svg>"

    "url(\"data:image/svg+xml," <> URI.encode(svg) <> "\")"
  end

  defp fetch(:part_root) do
    frag(
      [
        display: "flex",
        flex_direction: "column",
        width: "100%",
        gap: "var(--spacing-md)"
      ],
      [
        Rule.new(~S(&[data-orientation="vertical"]), decls: [flex_direction: "column"]),
        Rule.new(~S(&[data-orientation="horizontal"]), decls: [flex_flow: "row wrap"])
      ]
    )
  end

  defp fetch(:part_trigger) do
    frag(
      [
        display: "inline-flex",
        align_items: "center",
        justify_content: "center",
        text_align: "center",
        cursor: "pointer",
        width: "auto",
        min_height: "var(--spacing-control-md)",
        font_size: "var(--text-base)",
        line_height: "var(--leading-base)",
        font_weight: "var(--font-weight-normal)",
        border_radius: "var(--radius-md)",
        border: "1px solid var(--color-border)",
        padding_inline: "var(--spacing-md)",
        gap: "var(--spacing-md)",
        color: "var(--color-on-page)",
        background_color: "var(--color-surface-control)",
        appearance: "none",
        transition: "background-color 120ms ease, color 120ms ease"
      ],
      [
        Rule.new("&:hover", decls: [background_color: "var(--color-surface-control-hover)"]),
        Rule.new("&:active", decls: [background_color: "var(--color-surface-control-active)"]),
        Rule.new("&:focus-visible",
          decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--color-on-page)"]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-on-muted)",
            background_color: "var(--color-surface-control-muted)",
            cursor: "not-allowed"
          ]
        ),
        Rule.new("&[data-invalid]",
          decls: [border_color: "var(--color-alert)", box_shadow: "none"]
        ),
        Rule.new("&[data-invalid]:focus-visible", decls: [box_shadow: "none"]),
        Rule.new(~S(& [data-icon]), decls: [include: :part_icon]),
        Rule.new(~S(& [data-part="item-text"]),
          decls: [
            display: "flex",
            gap: "var(--spacing-md)",
            width: "100%",
            text_align: "start",
            align_items: "center"
          ]
        )
      ]
    )
  end

  defp fetch(:part_icon) do
    frag(
      [
        display: "flex",
        align_items: "center",
        justify_content: "center",
        height: "1em !important",
        width: "1em !important",
        color: "currentcolor",
        flex_shrink: "0"
      ],
      [
        Rule.new(~S([dir="rtl"] &), decls: [transform: "scaleX(-1)"])
      ]
    )
  end

  defp fetch(:part_content) do
    frag(
      display: "flex",
      flex_direction: "column",
      width: "100%",
      padding: "var(--spacing-md)",
      border_radius: "var(--radius-md)",
      border: "1px solid var(--color-border)",
      background_color: "var(--color-surface-page)",
      color: "var(--color-on-page)",
      box_shadow: "var(--shadow-md)"
    )
  end

  defp fetch(:part_label) do
    frag(
      display: "flex",
      align_items: "center",
      justify_content: "start",
      text_align: "start",
      width: "auto",
      font_size: "var(--text-base)",
      line_height: "var(--leading-base)",
      font_weight: "var(--font-weight-medium)",
      color: "var(--color-on-page)"
    )
  end

  defp fetch(:part_input) do
    frag(
      [
        display: "flex",
        align_items: "center",
        justify_content: "start",
        text_align: "start",
        width: "100%",
        font_size: "var(--text-base)",
        line_height: "var(--leading-base)",
        font_weight: "var(--font-weight-normal)",
        border_radius: "var(--radius-md)",
        border: "1px solid var(--color-border)",
        padding_inline: "var(--spacing-md)",
        gap: "var(--spacing-md)",
        min_height: "var(--spacing-control-md)",
        overflow: "hidden",
        text_overflow: "ellipsis",
        white_space: "nowrap",
        color: "var(--color-on-page)",
        background_color: "var(--color-surface-control)",
        transition: "background-color 120ms ease, box-shadow 120ms ease"
      ],
      [
        Rule.new("&::placeholder", decls: [color: "var(--color-on-muted)"]),
        Rule.new("&:hover", decls: [background_color: "var(--color-surface-control-hover)"]),
        Rule.new("&:focus,\n  &:focus-within",
          decls: [background_color: "var(--color-surface-page)", outline: "none"]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-on-muted)",
            background_color: "var(--color-surface-control-muted)",
            opacity: "0.7",
            cursor: "not-allowed"
          ]
        ),
        Rule.new("&[data-invalid]",
          decls: [border_color: "var(--color-alert)", box_shadow: "none"]
        ),
        Rule.new(
          "&[data-invalid]:focus,\n  &[data-invalid]:focus-within,\n  &[data-invalid]:focus-visible",
          decls: [box_shadow: "none", outline: "none"]
        ),
        Rule.new(~S(& [data-icon],\n  & svg,\n  & img), decls: [include: :part_icon])
      ]
    )
  end

  defp fetch(:part_item) do
    frag(
      [
        width: "100%",
        display: "inline-flex",
        align_items: "center",
        text_align: "start",
        cursor: "pointer",
        font_size: "var(--text-base)",
        line_height: "var(--leading-base)",
        font_weight: "var(--font-weight-normal)",
        min_height: "var(--spacing-control-md)",
        padding_inline: "var(--spacing-md)",
        gap: "var(--spacing-md)",
        background_color: "var(--color-surface-control)",
        color: "var(--color-on-page)",
        border_radius: "var(--radius-none)",
        outline: "none",
        transition: "background-color 120ms ease, color 120ms ease, box-shadow 120ms ease"
      ],
      [
        Rule.new("&:hover", decls: [background_color: "var(--color-surface-control-hover)"]),
        Rule.new("&:active",
          decls: [background_color: "var(--color-surface-control-active)", box_shadow: "none"]
        ),
        Rule.new("&:focus-visible",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(--color-on-page)",
            background_color: "var(--color-surface-control-hover)"
          ]
        ),
        Rule.new("@media (hover: hover)",
          children: [
            Rule.new("&[data-highlighted]:not(:hover)",
              decls: [
                outline: "none",
                box_shadow: "inset 0 0 0 2px var(--color-on-page)",
                background_color: "var(--color-surface-control-hover)"
              ]
            ),
            Rule.new("&[data-highlighted]:active",
              decls: [background_color: "var(--color-surface-control-active)", box_shadow: "none"]
            )
          ]
        ),
        Rule.new("@media (hover: none)",
          children: [
            Rule.new("&[data-highlighted]",
              decls: [
                outline: "none",
                box_shadow: "inset 0 0 0 2px var(--color-on-page)",
                background_color: "var(--color-surface-control-hover)"
              ]
            )
          ]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-on-muted)",
            background_color: "var(--color-surface-control-muted)",
            cursor: "not-allowed",
            box_shadow: "none"
          ]
        ),
        Rule.new(
          ~S(& [data-part="branch-indicator"],\n  & [data-part="item-indicator"]),
          decls: [transition: "transform 0.2s ease"]
        ),
        Rule.new(
          ~S(& [data-part="branch-indicator"][data-state="open"],\n  & [data-part="item-indicator"][data-state="open"]),
          decls: [transform: "rotate(90deg) !important"]
        ),
        Rule.new(
          ~S(& [data-icon],\n  & svg,\n  & img,\n  & [data-part="item-indicator"] svg,\n  & [data-part="branch-indicator"] svg),
          decls: [include: :part_icon]
        ),
        Rule.new(
          ~S(& [data-part="item-text"],\n  & [data-part="branch-text"]),
          decls: [
            display: "flex",
            gap: "var(--spacing-md)",
            flex: "1 1 0%",
            min_width: "0",
            max_width: "100%",
            width: "auto",
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap",
            text_align: "start",
            align_items: "center"
          ]
        ),
        Rule.new(
          ~S(& [data-part="branch-indicator"],\n  & [data-part="item-indicator"]),
          decls: [margin_inline_start: "auto", flex_shrink: "0", min_width: "1em"]
        )
      ]
    )
  end

  defp fetch(:part_link) do
    frag(
      [
        display: "inline-flex",
        justify_content: "start",
        align_items: "center",
        cursor: "pointer",
        position: "relative",
        color: "var(--color-on-link)",
        height: "auto",
        font_size: "inherit",
        line_height: "inherit",
        gap: "var(--spacing-md)",
        padding_inline: "var(--spacing-md)",
        border_radius: "var(--radius-md)",
        text_decoration_line: "underline",
        text_underline_offset: "0.15em",
        text_decoration_thickness: "from-font",
        max_width: "fit-content",
        min_width: "0"
      ],
      [
        Rule.new("&:hover", decls: [text_decoration_thickness: "2px"]),
        Rule.new("&:focus-visible",
          decls: [outline: "2px solid var(--color-focus)", outline_offset: "2px"]
        ),
        Rule.new("&:disabled,\n  &[data-disabled]",
          decls: [
            color: "var(--color-on-muted)",
            opacity: "0.7",
            cursor: "not-allowed",
            pointer_events: "none"
          ]
        ),
        Rule.new(~S(&[aria-current="page"],\n  &[aria-current="location"]),
          decls: [font_weight: "var(--font-weight-semibold)", pointer_events: "none"]
        ),
        Rule.new(~S(& [data-icon]), decls: [include: :part_icon])
      ]
    )
  end

  defp fetch(:part_error) do
    frag(
      display: "inline-flex",
      align_items: "center",
      justify_content: "start",
      text_align: "start",
      width: "auto",
      font_size: "var(--text-sm)",
      line_height: "var(--leading-sm)",
      font_weight: "var(--font-weight-normal)",
      gap: "0.25rem",
      color: "var(--color-on-page-alert)",
      padding_block: "var(--spacing-md)"
    )
  end

  defp fetch(:part_readonly) do
    frag([], [
      Rule.new("&::after",
        decls: [
          content: ~S(""),
          position: "absolute",
          inset_block_end: "0.25rem",
          inset_inline_end: "0.25rem",
          width: "1em",
          height: "1em",
          background_color: "var(--color-on-muted)",
          mask_image: part_readonly_lock_mask(),
          mask_size: "contain",
          mask_repeat: "no-repeat",
          mask_position: "center"
        ]
      )
    ])
  end

  defp fetch(:part_loading) do
    frag(
      pointer_events: "none !important",
      cursor: "wait",
      user_select: "none"
    )
  end

  defp fetch(_), do: nil
end
