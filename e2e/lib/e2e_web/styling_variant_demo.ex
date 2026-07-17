defmodule E2eWeb.StylingVariantDemo do
  @moduledoc false

  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def variant_steps(host), do: DemoScales.styling_variant_axis_steps(host)

  def semantic_steps(host), do: DemoScales.styling_semantic_axis_steps(host)

  def join_class(host, semantic_modifier, variant_modifier) do
    DemoScales.join_matrix_modifiers(host, semantic_modifier, variant_modifier)
  end

  def join_class(host, variant_modifier) when is_binary(variant_modifier) do
    join_class(host, "", variant_modifier)
  end

  def matrix_assigns(host, assigns) do
    assign(assigns, :matrix_semantics, semantic_steps(host))
    |> assign(:matrix_variants, variant_steps(host))
    |> assign(:matrix_host, host)
  end

  def variant_code_from_lines(lines) when is_list(lines), do: DemoScales.join_code(lines)

  def variant_description(host) do
    assigns = %{host: host}

    ~H"""
    <div class="typo text-ink-muted flex flex-col gap-space-xs max-w-none">
      <p>
        Variant modifiers control {@host} surface treatment. Default is subtle; add
        <code class="text-sm">ui-solid</code>
        for a filled surface.
      </p>
    </div>
    """
  end

  def variant_matrix_description(host) do
    assigns = %{host: host}

    ~H"""
    <div class="typo text-ink-muted flex flex-col gap-space-xs max-w-none">
      <p>
        Combine semantic palette and variant treatment on the same host, for example <code class="text-sm">{@host} ui-accent ui-solid</code>.
      </p>
    </div>
    """
  end
end
