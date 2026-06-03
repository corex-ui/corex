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
  Compiles the full Tailwind-free `design.css`: cascade-layer declaration, the
  reset + base layers, the token layer (`:root` + theme/mode scopes), and the
  recipe layer (component + layout recipes as plain CSS).
  """
  def compile do
    """
    #{@header}
    @layer reset, base, tokens;

    @layer reset {
    #{indent(Layers.reset_css())}
    }

    @layer base {
    #{indent(Layers.base_css())}
    #{indent(Typography.css())}
    }

    @layer tokens {
    #{indent(Tokens.css())}
    }

    #{Scales.keyframes()}
    #{recipes_css()}

    #{Responsive.css()}
    """
  end

  @doc """
  Compiles reset, base, and token layers for modular CSS export.
  """
  def compile_base do
    """
    #{@header}
    @layer reset, base, tokens;

    @layer reset {
    #{indent(Layers.reset_css())}
    }

    @layer base {
    #{indent(Layers.base_css())}
    #{indent(Typography.css())}
    }

    @layer tokens {
    #{indent(Tokens.css())}
    }

    #{Scales.keyframes()}

    #{Responsive.css()}
    """
  end

  @doc """
  Compiles a single recipe to plain CSS for modular CSS export.
  """
  def compile_recipe(%Recipe{} = recipe, opts \\ []) do
    target = Keyword.get(opts, :target, :css)

    """
    #{@header}

    #{Recipe.to_css(recipe, target: target)}
    """
  end

  @doc """
  Writes modular plain CSS export: `layers/base.css` and `components/{id}.css`.
  """
  def write_modular!(output_dir) do
    layers_dir = Path.join(output_dir, "layers")
    components_dir = Path.join(output_dir, "components")

    File.mkdir_p!(layers_dir)
    File.mkdir_p!(components_dir)
    Write.atomic!(Path.join(layers_dir, "base.css"), compile_base())

    for recipe <- Recipes.emitted() do
      Write.atomic!(
        Path.join(components_dir, "#{recipe_file_id(recipe)}.css"),
        compile_recipe(recipe)
      )
    end

    output_dir
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
        compile_recipe(recipe, target: :tailwind)
      )
    end

    Write.atomic!(Path.join(aggregates_dir, "recipes.css"), recipes_aggregate(recipes))

    Write.atomic!(Path.join(output_dir, "corex.tailwind.theme.css"), ~s(@import "./layers/theme.css";\n))
    Write.atomic!(Path.join(output_dir, "corex.tailwind.base.css"), ~s(@import "./layers/base.css";\n))
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

  @doc """
  Writes the compiled `design.css` to the given path (defaults to
  `priv/static/corex/design.css`).
  """
  def write!(path \\ default_output()) do
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, compile())
    write_modular!(Path.dirname(path))
    path
  end

  def default_output do
    Path.join([File.cwd!(), "priv", "static", "corex", "design.css"])
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
  def recipes_css(_opts \\ []) do
    Recipes.emitted()
    |> Enum.map_join("\n\n", &Recipe.to_css(&1, target: :css))
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
    recipes
    |> Enum.map(fn recipe ->
      ~s(@import "../recipes/#{recipe_file_id(recipe)}.css";)
    end)
    |> Enum.join("\n")
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
