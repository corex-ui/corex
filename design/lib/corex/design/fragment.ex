defmodule Corex.Design.Fragment do
  @moduledoc false

  alias Corex.Design.Rule

  @doc """
  Returns the declarations and nested rules for a shared style fragment (the
  Tailwind-free replacement for the old `@utility ui-*` mixins). The emitter
  splices these inline wherever a rule declares `decls: [include: <id>]`.
  """
  @utility_ids ~w(ui_root ui_trigger ui_icon ui_content ui_label ui_input ui_item ui_link ui_error ui_readonly ui_loading)a

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

  defp fetch(:ui_root) do
    frag(
      [
        display: "flex",
        flex_direction: "column",
        width: "100%",
        gap: "var(--space)"
      ],
      [
        Rule.new(~s(&[data-orientation="vertical"]), decls: [flex_direction: "column"]),
        Rule.new(~s(&[data-orientation="horizontal"]), decls: [flex_flow: "row wrap"])
      ]
    )
  end

  defp fetch(:ui_trigger) do
    frag(
      [
        display: "inline-flex",
        align_items: "center",
        justify_content: "center",
        text_align: "center",
        cursor: "pointer",
        width: "auto",
        min_height: "var(--size)",
        font_size: "var(--text-base)",
        line_height: "var(--leading-base)",
        font_weight: "var(--font-weight-normal)",
        border_radius: "var(--radius-md)",
        border: "1px solid var(--color-border)",
        padding_inline: "var(--space)",
        gap: "var(--space)",
        color: "var(--color-ui-ink)",
        background_color: "var(--color-ui)",
        appearance: "none",
        transition: "background-color 120ms ease, color 120ms ease"
      ],
      [
        Rule.new("&:hover", decls: [background_color: "var(--color-ui-hover)"]),
        Rule.new("&:active", decls: [background_color: "var(--color-ui-active)"]),
        Rule.new("&:focus-visible",
          decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--color-ui-ink)"]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-ui-ink-muted)",
            background_color: "var(--color-ui-muted)",
            cursor: "not-allowed"
          ]
        ),
        Rule.new("&[data-invalid]",
          decls: [border_color: "var(--color-alert)", box_shadow: "none"]
        ),
        Rule.new("&[data-invalid]:focus-visible", decls: [box_shadow: "none"]),
        Rule.new(~s(& [data-icon]), decls: [include: :ui_icon]),
        Rule.new(~s(& [data-part="item-text"]),
          decls: [
            display: "flex",
            gap: "var(--space)",
            width: "100%",
            text_align: "start",
            align_items: "center"
          ]
        )
      ]
    )
  end

  defp fetch(:ui_icon) do
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
        Rule.new(~s([dir="rtl"] &), decls: [transform: "scaleX(-1)"])
      ]
    )
  end

  defp fetch(:ui_content) do
    frag(
      display: "flex",
      flex_direction: "column",
      width: "100%",
      padding: "var(--space)",
      border_radius: "var(--radius-md)",
      border: "1px solid var(--color-border)",
      background_color: "var(--color-root)",
      color: "var(--color-ui-ink)",
      box_shadow: "var(--shadow-md)"
    )
  end

  defp fetch(:ui_label) do
    frag(
      display: "flex",
      align_items: "center",
      justify_content: "start",
      text_align: "start",
      width: "auto",
      font_size: "var(--text-base)",
      line_height: "var(--leading-base)",
      font_weight: "var(--font-weight-medium)",
      color: "var(--color-ui-ink)"
    )
  end

  defp fetch(:ui_input) do
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
        padding_inline: "var(--space)",
        gap: "var(--space)",
        min_height: "var(--size)",
        overflow: "hidden",
        text_overflow: "ellipsis",
        white_space: "nowrap",
        color: "var(--color-ui-ink)",
        background_color: "var(--color-ui)",
        transition: "background-color 120ms ease, box-shadow 120ms ease"
      ],
      [
        Rule.new("&::placeholder", decls: [color: "var(--color-ui-ink-muted)"]),
        Rule.new("&:hover", decls: [background_color: "var(--color-ui-hover)"]),
        Rule.new("&:focus,\n  &:focus-within",
          decls: [background_color: "var(--color-root)", outline: "none"]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-ui-ink-muted)",
            background_color: "var(--color-ui-muted)",
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
        Rule.new(~s(& [data-icon],\n  & svg,\n  & img), decls: [include: :ui_icon])
      ]
    )
  end

  defp fetch(:ui_item) do
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
        min_height: "var(--size)",
        padding_inline: "var(--space)",
        gap: "var(--space)",
        background_color: "var(--color-ui)",
        color: "var(--color-ui-ink)",
        border_radius: "var(--radius-none)",
        outline: "none",
        transition: "background-color 120ms ease, color 120ms ease, box-shadow 120ms ease"
      ],
      [
        Rule.new("&:hover", decls: [background_color: "var(--color-ui-hover)"]),
        Rule.new("&:active",
          decls: [background_color: "var(--color-ui-active)", box_shadow: "none"]
        ),
        Rule.new("&:focus-visible",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(--color-ui-ink)",
            background_color: "var(--color-ui-hover)"
          ]
        ),
        Rule.new("@media (hover: hover)",
          children: [
            Rule.new("&[data-highlighted]:not(:hover)",
              decls: [
                outline: "none",
                box_shadow: "inset 0 0 0 2px var(--color-ui-ink)",
                background_color: "var(--color-ui-hover)"
              ]
            ),
            Rule.new("&[data-highlighted]:active",
              decls: [background_color: "var(--color-ui-active)", box_shadow: "none"]
            )
          ]
        ),
        Rule.new("@media (hover: none)",
          children: [
            Rule.new("&[data-highlighted]",
              decls: [
                outline: "none",
                box_shadow: "inset 0 0 0 2px var(--color-ui-ink)",
                background_color: "var(--color-ui-hover)"
              ]
            )
          ]
        ),
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [
            color: "var(--color-ui-ink-muted)",
            background_color: "var(--color-ui-muted)",
            cursor: "not-allowed",
            box_shadow: "none"
          ]
        ),
        Rule.new(
          ~s(& [data-part="branch-indicator"],\n  & [data-part="item-indicator"]),
          decls: [transition: "transform 0.2s ease"]
        ),
        Rule.new(
          ~s(& [data-part="branch-indicator"][data-state="open"],\n  & [data-part="item-indicator"][data-state="open"]),
          decls: [transform: "rotate(90deg) !important"]
        ),
        Rule.new(
          ~s(& [data-icon],\n  & svg,\n  & img,\n  & [data-part="item-indicator"] svg,\n  & [data-part="branch-indicator"] svg),
          decls: [include: :ui_icon]
        ),
        Rule.new(
          ~s(& [data-part="item-text"],\n  & [data-part="branch-text"]),
          decls: [
            display: "flex",
            gap: "var(--space)",
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
          ~s(& [data-part="branch-indicator"],\n  & [data-part="item-indicator"]),
          decls: [margin_inline_start: "auto", flex_shrink: "0", min_width: "1em"]
        )
      ]
    )
  end

  defp fetch(:ui_link) do
    frag(
      [
        display: "inline-flex",
        justify_content: "start",
        align_items: "center",
        cursor: "pointer",
        position: "relative",
        color: "var(--color-link)",
        height: "auto",
        font_size: "inherit",
        line_height: "inherit",
        gap: "var(--space)",
        padding_inline: "var(--space)",
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
            color: "var(--color-ui-ink-muted)",
            opacity: "0.7",
            cursor: "not-allowed",
            pointer_events: "none"
          ]
        ),
        Rule.new(~s(&[aria-current="page"],\n  &[aria-current="location"]),
          decls: [font_weight: "var(--font-weight-semibold)", pointer_events: "none"]
        ),
        Rule.new(~s(& [data-icon]), decls: [include: :ui_icon])
      ]
    )
  end

  defp fetch(:ui_error) do
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
      color: "var(--color-ui-ink-alert)",
      padding_block: "var(--space)"
    )
  end

  defp fetch(:ui_readonly) do
    frag([], [
      Rule.new("&::after",
        decls: [
          content: ~s(""),
          position: "absolute",
          inset_block_end: "0.25rem",
          inset_inline_end: "0.25rem",
          width: "1em",
          height: "1em",
          background_color: "var(--color-ui-ink-muted)",
          mask_image:
            ~S|url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'%3E%3Cpath fill-rule='evenodd' d='M10 1a4.5 4.5 0 0 0-4.5 4.5V9H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1ZM8.5 5.5V9H14V5.5a3.5 3.5 0 1 0-7 0Z' clip-rule='evenodd'/%3E%3C/svg%3E")|,
          mask_size: "contain",
          mask_repeat: "no-repeat",
          mask_position: "center"
        ]
      )
    ])
  end

  defp fetch(:ui_loading) do
    frag(
      pointer_events: "none !important",
      cursor: "wait",
      user_select: "none"
    )
  end

  defp fetch(_), do: nil
end
