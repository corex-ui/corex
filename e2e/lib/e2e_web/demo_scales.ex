defmodule E2eWeb.DemoScales do
  @moduledoc false

  alias Corex.Design.ComponentLayout
  alias Corex.Design.Scales
  alias E2eWeb.TailwindSizingLiterals

  def container_steps, do: Scales.master_ladder_strings()
  def max_width_steps, do: Scales.steps(:max_width)
  def min_width_steps, do: Scales.steps(:min_width)
  def width_steps, do: Scales.steps(:width)
  def max_height_steps, do: Scales.steps(:max_height)
  def min_height_steps, do: Scales.steps(:min_height)
  def radius_steps, do: Scales.steps(:radius)
  def size_steps, do: Scales.steps(:size)
  def text_steps, do: Scales.steps(:text)
  def semantic_steps, do: Scales.semantic_steps()

  def tailwind_max_width(step), do: TailwindSizingLiterals.max_width(step)
  def tailwind_min_width(step), do: TailwindSizingLiterals.min_width(step)
  def tailwind_width(step), do: TailwindSizingLiterals.width(step)
  def tailwind_max_height(step), do: TailwindSizingLiterals.max_height(step)
  def tailwind_min_height(step), do: TailwindSizingLiterals.min_height(step)
  def bem_max_width(component, step), do: "#{component}--max-w-#{step}"

  def preview_scroll_class do
    "w-full max-h-[70vh] overflow-y-auto scrollbar scrollbar--sm flex flex-col gap-space-lg"
  end

  def preview_scroll_attrs do
    [class: preview_scroll_class(), tabindex: "0"]
  end

  def join_code(blocks), do: Enum.join(blocks, "\n")

  def default_max_width_label(component_id) do
    ComponentLayout.default_max_label(component_id)
  end

  def default_width_label(component_id) do
    ComponentLayout.host_width_label(component_id)
  end

  def max_width_options_for(component_id) do
    default = default_max_width_label(component_id)

    Enum.map(max_width_steps(), fn
      ^default -> "#{default} (default)"
      step -> step
    end)
  end

  def width_options_for(_component_id) do
    width_steps()
  end

  def max_width_variants(component_id \\ nil) do
    default_label =
      if component_id do
        "default (#{default_max_width_label(component_id)})"
      else
        "default"
      end

    [
      %{id: "default", label: default_label, modifier: ""}
      | Enum.map(max_width_steps(), fn step ->
          %{id: step, label: step, modifier: tailwind_max_width(step)}
        end)
    ]
  end

  def max_width_variants_from(component_id, min_step) when is_binary(min_step) do
    component_id
    |> max_width_variants()
    |> Enum.reject(fn
      %{id: "default"} -> false
      %{id: id} -> container_step_index(id) < container_step_index(min_step)
    end)
  end

  defp container_step_index("none"), do: -2
  defp container_step_index("full"), do: -1
  defp container_step_index(step), do: Enum.find_index(max_width_steps(), &(&1 == step)) || 0

  def width_variants(_component_id \\ nil) do
    [
      %{id: "default", label: "default", modifier: ""}
      | Enum.map(width_steps(), fn step ->
          %{id: step, label: step, modifier: tailwind_width(step)}
        end)
    ]
  end

  def width_layout_variants(component_id) do
    [
      %{
        id: "default",
        label: "default (#{default_width_label(component_id)})",
        modifier: ""
      },
      %{id: "full", label: "full", modifier: "w-full"},
      %{id: "fit", label: "fit", modifier: "w-fit"}
    ]
  end

  def width_layout_options_for(component_id) do
    component_id
    |> width_layout_variants()
    |> Enum.map(& &1.label)
  end

  def width_variant_pairs(prefix) do
    Enum.map(max_width_steps(), fn step ->
      {tailwind_max_width(step), "#{prefix}-#{step}"}
    end)
  end

  def join_modifiers(base, ""), do: base
  def join_modifiers(base, modifier), do: "#{base} #{modifier}"

  def join_matrix_modifiers(host, semantic_modifier, variant_modifier) do
    [semantic_modifier, variant_modifier]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(" ")
    |> then(&join_modifiers(host, &1))
  end

  def styling_variant_axis_steps(host) do
    [
      %{label: "Subtle (default)", modifier: ""},
      %{label: "Solid", modifier: "#{host}--variant-solid"},
      %{label: "Ghost", modifier: "#{host}--variant-ghost"},
      %{label: "Outline", modifier: "#{host}--variant-outline"}
    ]
  end

  def styling_semantic_axis_steps(host) do
    [
      %{label: "Base", modifier: ""}
      | semantic_steps()
        |> Enum.reject(&(&1 == "base"))
        |> Enum.map(&%{label: String.capitalize(&1), modifier: "#{host}--#{&1}"})
    ]
  end

  def join_block_modifiers(base, ""), do: join_modifiers(base, "w-full")
  def join_block_modifiers(base, modifier), do: join_modifiers(base, "w-full " <> modifier)

  def block_demo_label, do: "Save changes to your account settings"

  def block_demo_value, do: "hello@example.com.with.a.very.long.domain.example"
end
