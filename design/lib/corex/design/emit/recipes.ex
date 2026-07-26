defmodule Corex.Design.Emit.Recipes do
  @moduledoc false

  alias Corex.Design.Components
  alias Corex.Design.Write

  @header "/* Corex generated recipes - do not edit */\n"

  def write!(output_dir, component_ids) do
    Write.atomic!(Path.join(output_dir, "recipes.css"), [@header, generate(component_ids)])
  end

  def generate(component_ids) do
    grouped = Components.grouped_selectors(component_ids)
    hosts = component_ids |> Enum.map(&to_string/1) |> Enum.sort()
    action_hosts = Enum.filter(hosts, &Components.has_variant_axis?/1)

    [
      "@layer components {\n",
      base_palette(hosts),
      soft_idle(action_hosts),
      role_block(grouped, :root, root_chrome()),
      role_block(grouped, :host_trigger, trigger_chrome()),
      role_block(grouped, :trigger, trigger_chrome()),
      role_block(grouped, :control, control_chrome()),
      role_block(grouped, :item, item_chrome()),
      role_block(grouped, :input, input_chrome()),
      role_block(grouped, :label, label_chrome()),
      role_block(grouped, :content, content_chrome()),
      role_block(grouped, :host_link, link_chrome()),
      role_block(grouped, :host_badge, badge_chrome()),
      role_block(grouped, :error, error_chrome()),
      disclosure_block(grouped),
      selection_block(grouped),
      "}\n"
    ]
    |> Enum.join()
  end

  defp base_palette([]), do: ""

  defp base_palette(hosts) do
    selectors = Enum.map_join(hosts, ",\n", &Components.host_selector/1)

    """
    #{selectors} {
      --ctl-fill: var(--color-ink);
      --ctl-fill-hover: color-mix(in oklab, var(--color-ink) 88%, black);
      --ctl-fill-active: color-mix(in oklab, var(--color-ink) 76%, black);
      --ctl-fill-ink: var(--color-root);
      --ctl-ink-text: var(--color-ink);
      --ctl-muted: var(--color-ui-muted);
    }

    """
  end

  defp soft_idle([]), do: ""

  defp soft_idle(action_hosts) do
    selectors =
      Enum.map_join(action_hosts, ",\n", fn host ->
        "#{Components.host_selector(host)}:not(.ui-solid):not(.ui-ghost)"
      end)

    """
    #{selectors} {
      --ctl-bg: var(--color-ui);
      --ctl-ink: var(--ctl-ink-text, var(--color-ink));
      --ctl-bd: var(--color-border);
      --ctl-bg-hover: var(--color-ui-hover);
      --ctl-bg-active: var(--color-ui-active);
      --ctl-ring: var(--ctl-ink-text, var(--color-ink));
      --ctl-bg-muted: var(--color-ui-muted);
      --ctl-ink-muted: var(--color-ink-muted);
    }

    """
  end

  defp role_block(grouped, role, chrome) do
    case Map.get(grouped, role, []) do
      [] ->
        ""

      selectors ->
        joined = Enum.join(selectors, ",\n")
        "#{joined} {\n#{chrome}}\n\n"
    end
  end

  defp disclosure_block(grouped) do
    selectors =
      for role <- [:trigger, :host_trigger],
          sel <- Map.get(grouped, role, []) do
        sel
      end

    case selectors do
      [] ->
        ""

      list ->
        group = ":is(#{Enum.join(list, ", ")})"

        """
        #{group}:is([data-state="open"]) {
          background-color: var(--ctl-bg-active, var(--color-ui-active));
          color: var(--ctl-ink, var(--ctl-ink-text, var(--color-ink)));
          border-color: var(--ctl-bd, var(--color-border));
        }

        #{group}:is([data-state="open"]):hover,
        #{group}:is([data-state="open"]):active {
          background-color: var(--ctl-bg-active, var(--color-ui-active));
        }

        """
    end
  end

  defp selection_block(grouped) do
    selectors =
      for role <- [:trigger, :host_trigger, :control, :item],
          sel <- Map.get(grouped, role, []) do
        sel
      end

    case selectors do
      [] ->
        ""

      list ->
        group = ":is(#{Enum.join(list, ", ")})"
        states = Enum.join(selection_states(), ", ")
        selected = "#{group}:is(#{states})"

        """
        #{selected} {
          background-color: var(--ctl-fill);
          color: var(--ctl-fill-ink);
          border-color: transparent;
        }

        #{selected}:hover,
        #{selected}[data-highlighted] {
          background-color: var(--ctl-fill-hover);
        }

        #{selected}:active,
        #{selected}[data-highlighted]:active {
          background-color: var(--ctl-fill-active);
        }

        #{selected}:focus-visible,
        #{selected}[data-highlighted]:not(:hover) {
          outline: none;
          box-shadow: inset 0 0 0 2px var(--ctl-fill-ink);
          background-color: var(--ctl-fill-hover);
        }

        """
    end
  end

  defp selection_states do
    [
      "[data-state=\"on\"]",
      "[data-state=\"checked\"]",
      "[data-selected]",
      "[data-in-range]",
      "[data-checked]",
      "[data-indeterminate]"
    ]
  end

  defp root_chrome do
    """
      display: flex;
      flex-direction: column;
      width: 100%;
      gap: var(--ctl-space, var(--spacing-space));

      &[data-orientation="vertical"] {
        flex-direction: column;
      }

      &[data-orientation="horizontal"] {
        flex-flow: row wrap;
      }
    """
  end

  defp trigger_chrome do
    """
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      cursor: pointer;
      width: auto;
      min-height: var(--ctl-size, var(--spacing-size));
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-normal);
      border-radius: var(--ctl-radius, var(--radius-md));
      padding-inline: calc(var(--ctl-space, var(--spacing-space)) * 1.25);
      gap: var(--ctl-space, var(--spacing-space));
      color: var(--ctl-ink, var(--ctl-ink-text, var(--color-ink)));
      background-color: var(--ctl-bg, var(--color-ui));
      border: 1px solid var(--ctl-bd, var(--color-border));
      appearance: none;
      transition: background-color 120ms ease, color 120ms ease, border-color 120ms ease;
    """ <> interactive_idle() <> icon_child()
  end

  defp control_chrome do
    """
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      cursor: pointer;
      width: auto;
      min-height: var(--ctl-size, var(--spacing-size));
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-normal);
      border-radius: var(--ctl-radius, var(--radius-md));
      padding-inline: calc(var(--ctl-space, var(--spacing-space)) * 1.25);
      gap: var(--ctl-space, var(--spacing-space));
      color: var(--color-ink);
      background-color: var(--color-ui);
      border: 1px solid var(--color-border);
      appearance: none;
      transition: background-color 120ms ease, color 120ms ease, border-color 120ms ease;
    """ <> neutral_idle() <> icon_child()
  end

  defp item_chrome do
    """
      width: 100%;
      display: inline-flex;
      align-items: center;
      text-align: start;
      cursor: pointer;
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-normal);
      min-height: var(--ctl-size, var(--spacing-size));
      padding-inline: var(--ctl-space, var(--spacing-space));
      gap: var(--ctl-space, var(--spacing-space));
      color: var(--color-ink);
      background-color: var(--color-ui);
      border: 1px solid transparent;
      border-radius: var(--radius-none);
      outline: none;
      transition: background-color 120ms ease, color 120ms ease, box-shadow 120ms ease, border-color 120ms ease;
    """ <> neutral_idle() <> item_extras() <> icon_child()
  end

  defp input_chrome do
    """
      display: flex;
      align-items: center;
      justify-content: start;
      text-align: start;
      width: 100%;
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-normal);
      border-radius: var(--ctl-radius, var(--radius-md));
      border: 1px solid var(--color-border);
      padding-inline: var(--ctl-space, var(--spacing-space));
      gap: var(--ctl-space, var(--spacing-space));
      min-height: var(--ctl-size, var(--spacing-size));
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: var(--color-ink);
      background-color: var(--color-ui);
      transition: background-color 120ms ease, box-shadow 120ms ease;
    """ <> input_states() <> icon_child()
  end

  defp label_chrome do
    """
      display: flex;
      align-items: center;
      justify-content: start;
      text-align: start;
      width: auto;
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-medium);
      color: var(--color-ink);
    """
  end

  defp content_chrome do
    """
      display: flex;
      flex-direction: column;
      width: 100%;
      padding: var(--ctl-space, var(--spacing-space));
      border-radius: var(--ctl-radius, var(--radius-md));
      border: 1px solid var(--color-border);
      background-color: var(--color-root);
      color: var(--color-ink);
      box-shadow: var(--shadow-md);
    """
  end

  defp link_chrome do
    """
      display: inline-flex;
      justify-content: start;
      align-items: center;
      cursor: pointer;
      position: relative;
      color: var(--ctl-ink-text, var(--color-link));
      height: auto;
      font-size: inherit;
      line-height: inherit;
      gap: var(--ctl-space, var(--spacing-space));
      padding-inline: var(--ctl-space, var(--spacing-space));
      border-radius: var(--ctl-radius, var(--radius-md));
      text-decoration-line: underline;
      text-underline-offset: 0.15em;
      text-decoration-thickness: from-font;
      max-width: fit-content;
      min-width: 0;
    """ <> icon_child()
  end

  defp badge_chrome do
    """
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: fit-content;
      max-width: fit-content;
      min-height: var(--ctl-size, var(--spacing-size));
      font-size: var(--ctl-text, var(--text-base));
      line-height: var(--ctl-leading, var(--text-base--line-height));
      font-weight: var(--font-weight-medium);
      border-radius: var(--ctl-radius, var(--radius-md));
      padding-inline: calc(var(--ctl-space, var(--spacing-space)) * 1.25);
      gap: var(--ctl-space, var(--spacing-space));
      color: var(--ctl-ink, var(--ctl-ink-text, var(--color-ink)));
      background-color: var(--ctl-bg, var(--color-ui));
      border: 1px solid var(--ctl-bd, var(--color-border));
      transition: background-color 120ms ease, color 120ms ease, border-color 120ms ease;
    """ <> interactive_idle() <> icon_child()
  end

  defp error_chrome do
    """
      display: inline-flex;
      align-items: center;
      justify-content: start;
      text-align: start;
      width: auto;
      font-size: var(--text-sm);
      line-height: var(--text-sm--line-height);
      font-weight: var(--font-weight-normal);
      gap: var(--spacing-space-sm);
      color: var(--color-alert-text);
      padding-block: var(--spacing-space);
    """
  end

  defp interactive_idle do
    """
      &:hover {
        background-color: var(--ctl-bg-hover, var(--color-ui-hover));
      }

      &:active {
        background-color: var(--ctl-bg-active, var(--color-ui-active));
      }

      &:focus-visible {
        outline: none;
        box-shadow: inset 0 0 0 2px var(--ctl-ring, var(--color-ink));
      }

      &:disabled,
      &[data-disabled],
      &[disabled] {
        color: var(--ctl-ink-muted, var(--color-ink-muted));
        background-color: var(--ctl-bg-muted, var(--color-ui-muted));
        cursor: not-allowed;
      }

      &[data-invalid] {
        border-color: var(--color-alert);
        box-shadow: none;
      }

      &[data-invalid]:focus-visible {
        box-shadow: none;
      }
    """
  end

  defp neutral_idle do
    """
      &:hover {
        background-color: var(--color-ui-hover);
      }

      &:active {
        background-color: var(--color-ui-active);
      }

      &:focus-visible {
        outline: none;
        box-shadow: inset 0 0 0 2px var(--color-ink);
        background-color: var(--color-ui-hover);
      }

      &:disabled,
      &[data-disabled],
      &[disabled] {
        color: var(--color-ink-muted);
        background-color: var(--color-ui-muted);
        cursor: not-allowed;
      }
    """
  end

  defp input_states do
    """
      &::placeholder {
        color: var(--color-ink-muted);
      }

      &:hover {
        background-color: var(--color-ui-hover);
      }

      &:focus,
      &:focus-within {
        background-color: var(--color-root);
        outline: none;
      }

      &:disabled,
      &[data-disabled],
      &[disabled] {
        color: var(--color-ink-muted);
        background-color: var(--color-ui-muted);
        opacity: 0.7;
        cursor: not-allowed;
      }

      &[data-invalid] {
        border-color: var(--color-alert);
        box-shadow: none;
      }

      &[data-invalid]:focus,
      &[data-invalid]:focus-within,
      &[data-invalid]:focus-visible {
        box-shadow: none;
        outline: none;
      }
    """
  end

  defp item_extras do
    """
      @media (hover: hover) {
        &[data-highlighted]:not(:hover) {
          outline: none;
          box-shadow: inset 0 0 0 2px var(--color-ink);
          background-color: var(--color-ui-hover);
        }

        &[data-highlighted]:active {
          background-color: var(--color-ui-active);
          box-shadow: none;
        }
      }

      @media (hover: none) {
        &[data-highlighted] {
          outline: none;
          box-shadow: inset 0 0 0 2px var(--color-ink);
          background-color: var(--color-ui-hover);
        }
      }

      & [data-part="branch-indicator"],
      & [data-part="item-indicator"] {
        transition: transform 0.2s ease;
      }

      & [data-part="branch-indicator"][data-state="open"],
      & [data-part="item-indicator"][data-state="open"] {
        transform: rotate(90deg) !important;
      }

      [dir="rtl"] & [data-part="branch-indicator"][data-state="open"],
      [dir="rtl"] & [data-part="item-indicator"][data-state="open"] {
        transform: rotate(-90deg) !important;
      }

      & [data-part="item-text"],
      & [data-part="branch-text"] {
        display: flex;
        gap: var(--ctl-space, var(--spacing-space));
        width: 100%;
        text-align: start;
        align-items: center;
        flex: 1;
      }

      & [data-part="item-text"] > *,
      & [data-part="branch-text"] > *,
      & [data-part="item-indicator"] > *,
      & [data-part="branch-indicator"] > * {
        color: inherit;
      }
    """
  end

  defp icon_child do
    """
      & .icon,
      & [class^="hero-"],
      & svg,
      & img {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 1em !important;
        width: 1em !important;
        color: currentcolor;
        flex-shrink: 0;
      }

      [dir="rtl"] & .icon,
      [dir="rtl"] & [class^="hero-"] {
        transform: scaleX(-1);
      }
    """
  end
end
