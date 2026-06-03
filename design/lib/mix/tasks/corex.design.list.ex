defmodule Mix.Tasks.Corex.Design.List do
  use Mix.Task

  @shortdoc "Lists Corex design recipe ids for include_recipes"

  @moduledoc """
  Prints every recipe id the design compiler knows about, grouped by kind.

  Use these atoms in `config :corex_design, include_recipes: [...]`.

  ## Examples

      mix corex.design.list
      mix corex.design.list --emitted
  """

  @impl true
  def run(argv) do
    Mix.Task.run("app.config")

    {opts, _} = OptionParser.parse!(argv, strict: [emitted: :boolean])

    recipes =
      if Keyword.get(opts, :emitted, false) do
        Corex.Design.Recipes.emitted()
      else
        Corex.Design.Recipes.all()
      end

    component_ids =
      recipes
      |> Enum.filter(&(&1.kind in [:style_recipe, :style_slot_recipe, :style_part_recipe]))
      |> Enum.map(& &1.id)
      |> Enum.sort()

    layout_ids =
      recipes
      |> Enum.filter(&(&1.kind == :layout))
      |> Enum.map(& &1.id)
      |> Enum.sort()

    typo_ids =
      recipes
      |> Enum.reject(&(&1.kind in [:style_recipe, :style_slot_recipe, :style_part_recipe, :layout]))
      |> Enum.map(& &1.id)
      |> Enum.sort()

    Mix.shell().info("Component recipes (#{length(component_ids)}):")
    Enum.each(component_ids, &Mix.shell().info("  #{&1}"))

    Mix.shell().info("\nLayout recipes (#{length(layout_ids)}):")
    Enum.each(layout_ids, &Mix.shell().info("  #{&1}"))

    Mix.shell().info("\nTypography recipes (#{length(typo_ids)}):")
    Enum.each(typo_ids, &Mix.shell().info("  #{&1}"))

    Mix.shell().info("\nExample allowlist:")

    Mix.shell().info(
      "  config :corex_design, include_recipes: #{inspect(Enum.take(component_ids ++ layout_ids, 5))}"
    )
  end
end
