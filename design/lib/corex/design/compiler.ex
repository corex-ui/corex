defmodule Corex.Design.Compiler do
  @moduledoc false

  alias Corex.Assets.Write
  alias Corex.Design.Emit.Layers
  alias Corex.Design.Emit.Responsive
  alias Corex.Design.Emit.TailwindUtilities
  alias Corex.Design.Emit.Tokens
  alias Corex.Design.Emit.Typography
  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Tokens.Scales

  @header "/* Corex generated design - do not edit */"

  @doc """
  Compiles a single recipe to Tailwind component-layer CSS.
  """
  def compile_recipe(%Recipe{} = recipe) do
    """
    #{@header}

    #{Recipe.to_css(recipe)}
    """
  end

  @doc """
  Writes the Tailwind bundle as layered folders plus thin root shims.
  """
  def write_tailwind_modular!(output_dir) do
    alias Corex.Design.Emit.Theme

    layers_dir = Path.join(output_dir, "layers")
    recipes_dir = Path.join(output_dir, "recipes")
    aggregates_dir = Path.join(output_dir, "aggregates")

    File.mkdir_p!(layers_dir)
    File.mkdir_p!(recipes_dir)
    File.mkdir_p!(aggregates_dir)

    for path <- [
          Path.join(recipes_dir, "class"),
          Path.join(recipes_dir, "data"),
          Path.join(output_dir, "corex.tailwind.recipes.css"),
          Path.join(output_dir, "corex.tailwind.recipes.data.css"),
          Path.join(aggregates_dir, "recipes.data.css")
        ] do
      File.rm_rf(path)
    end

    Write.atomic!(Path.join(layers_dir, "theme.css"), Theme.bridge_css())
    Write.atomic!(Path.join(layers_dir, "base.css"), tailwind_base_css())
    Write.atomic!(Path.join(layers_dir, "tokens.css"), Tokens.css())
    Write.atomic!(Path.join(layers_dir, "utilities.css"), TailwindUtilities.css())

    recipes = Recipes.emitted()

    for recipe <- recipes do
      id = recipe_file_id(recipe)

      Write.atomic!(
        Path.join(recipes_dir, "#{id}.css"),
        compile_recipe(recipe)
      )
    end

    Write.atomic!(Path.join(aggregates_dir, "recipes.css"), recipes_aggregate(recipes))

    Write.atomic!(
      Path.join(output_dir, "corex.tailwind.theme.css"),
      ~s(@import "./layers/theme.css";\n)
    )

    Write.atomic!(
      Path.join(output_dir, "corex.tailwind.base.css"),
      ~s(@import "./layers/base.css";\n)
    )

    Write.atomic!(Path.join(output_dir, "corex.tokens.css"), ~s(@import "./layers/tokens.css";\n))

    Write.atomic!(
      Path.join(output_dir, "corex.tailwind.css"),
      """
      @import "./layers/theme.css";
      @import "./layers/base.css";
      @import "./layers/tokens.css";
      @import "./aggregates/recipes.css";
      """
    )

    output_dir
  end

  @doc false
  def tailwind_base_css do
    """
    @layer reset, base;

    @layer reset {
    #{indent(Layers.reset_css())}
    }

    @layer base {
    #{indent(Layers.base_css())}
    #{indent(Typography.css())}
    }

    #{Scales.keyframes()}

    #{Layers.unlayered_host_icon_css()}
    """
  end

  @doc false
  def tailwind_recipes_css do
    recipes_aggregate(Recipes.emitted())
  end

  defp recipes_aggregate(recipes) do
    imports =
      [
        ~s(@import "../layers/utilities.css";),
        recipe_imports(recipes)
      ]
      |> Enum.join("\n")

    """
    #{@header}
    #{imports}

    #{Responsive.css()}
    """
  end

  defp recipe_imports(recipes) do
    Enum.map_join(recipes, "\n", fn recipe ->
      ~s(@import "../recipes/#{recipe_file_id(recipe)}.css";)
    end)
  end

  defp recipe_file_id(%Recipe{id: id}) do
    id |> Atom.to_string() |> String.replace("_", "-")
  end

  defp indent(text) do
    text
    |> String.split("\n")
    |> Enum.map_join("\n", fn
      "" -> ""
      line -> "  " <> line
    end)
  end
end
