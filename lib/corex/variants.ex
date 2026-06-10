defmodule Corex.Variants do
  @moduledoc false

  @breakpoints [nil, "sm", "md", "lg", "xl", "2xl"]

  defmacro __using__(opts) do
    case Keyword.get(opts, :kind, :component) do
      :component -> component_using(opts)
      :layout -> layout_using(opts)
      :recipe -> recipe_using(opts)
      :appearance -> recipe_using(opts)
    end
  end

  defp component_using(opts) do
    base = Keyword.fetch!(opts, :base)
    axes = Keyword.fetch!(opts, :axes)
    defaults = Keyword.get(opts, :defaults, [])
    declare_class? = Keyword.get(opts, :class_attr, true)

    axis_names = Keyword.keys(axes)
    defaults_map = Map.new(defaults, fn {k, v} -> {k, to_string(v)} end)

    axis_decls =
      for {axis, scale} <- axes, do: axis_attr(base, axis, [nil | axis_values(scale)], nil)

    class_decl = if declare_class?, do: class_attr()

    quote do
      @corex_base unquote(base)
      @corex_axis_names unquote(axis_names)
      @corex_defaults unquote(Macro.escape(defaults_map))

      @doc "Returns the BEM class string for this component's configured style axes."
      def corex_style_class(assigns) do
        Corex.Variants.component_style_class(
          @corex_base,
          @corex_axis_names,
          @corex_defaults,
          assigns
        )
      end

      @doc "Returns `{base, axis_names}` for style introspection and tooling."
      def __corex_style__, do: {@corex_base, @corex_axis_names}

      attr(:unstyled, :boolean, default: false, doc: "Skip design output, keep only `class`.")

      unquote(class_decl)

      unquote_splicing(axis_decls)
    end
  end

  defp class_attr do
    quote do
      attr(:class, :any, default: nil, doc: "Additional classes for the host element.")
    end
  end

  defp layout_using(opts) do
    base = Keyword.fetch!(opts, :base)
    axes = Keyword.fetch!(opts, :axes)
    defaults = Keyword.get(opts, :defaults, [])

    axis_names = Keyword.keys(axes)

    axis_decls =
      for {axis, scale} <- axes do
        values = axis_values(scale)

        case Keyword.fetch(defaults, axis) do
          {:ok, default} -> axis_attr(base, axis, values, to_string(default))
          :error -> axis_attr(base, axis, [nil | values], nil)
        end
      end

    quote do
      @corex_base unquote(base)
      @corex_axis_names unquote(axis_names)

      @doc "Returns layout design output (`%{class: ...}`) for this layout primitive."
      def corex_layout_design(assigns) do
        Corex.Variants.layout_design(@corex_base, @corex_axis_names, assigns)
      end

      attr(:class, :any, default: nil, doc: "Additional classes for the host element.")
      attr(:unstyled, :boolean, default: false, doc: "Skip design output, keep only `class`.")

      attr(:hide_from, :string,
        values: unquote(@breakpoints),
        default: nil,
        doc: "Hide this element from the given breakpoint up (`sm`..`2xl`)."
      )

      attr(:hide_below, :string,
        values: unquote(@breakpoints),
        default: nil,
        doc: "Hide this element below the given breakpoint (`sm`..`2xl`)."
      )

      attr(:rest, :global)

      unquote_splicing(axis_decls)
    end
  end

  defp recipe_using(opts) do
    recipes = Keyword.get(opts, :recipes) || Keyword.fetch!(opts, :appearances)
    default = Keyword.fetch!(opts, :default)
    declare_class? = Keyword.get(opts, :class_attr, true)
    defaults = Keyword.get(opts, :defaults, [])
    defaults_map = Map.new(defaults, fn {k, v} -> {k, to_string(v)} end)

    unless default in recipes do
      raise ArgumentError,
            "Corex.Variants recipe default #{inspect(default)} must be one of #{inspect(recipes)}"
    end

    looks = Map.new(recipes, fn name -> {to_string(name), Corex.Appearances.fetch!(name)} end)

    meta =
      Map.new(looks, fn {name, look} ->
        {name, %{base: look.base, axes: Keyword.keys(look.axes)}}
      end)

    axes_union =
      recipes
      |> Enum.flat_map(fn name -> Corex.Appearances.fetch!(name).axes end)
      |> Enum.uniq_by(fn {axis, _scale} -> axis end)

    names = Enum.map(recipes, &to_string/1)
    default_str = to_string(default)

    axis_decls =
      for {axis, scale} <- axes_union do
        recipe_axis_attr(axis, [nil | axis_values(scale)])
      end

    class_decl = if declare_class?, do: class_attr()

    quote do
      @corex_recipes unquote(Macro.escape(meta))
      @corex_default_recipe unquote(default_str)
      @corex_recipe_defaults unquote(Macro.escape(defaults_map))

      @doc "Returns the BEM class string for the active polymorphic recipe look."
      def corex_style_class(assigns) do
        Corex.Variants.recipe_class(
          @corex_recipes,
          @corex_default_recipe,
          assigns,
          @corex_recipe_defaults
        )
      end

      @doc "Returns recipe metadata for style introspection and tooling."
      def __corex_style__, do: {:recipes, @corex_default_recipe, @corex_recipes}

      attr(:as, :string,
        values: unquote([nil | names]),
        default: unquote(default_str),
        doc: "Recipe look to wear (one of #{unquote(Enum.join(names, ", "))})."
      )

      unquote(class_decl)

      unquote_splicing(axis_decls)
    end
  end

  defp recipe_axis_attr(axis, values) do
    doc =
      "Style axis `#{axis}` for the active polymorphic look. Allowed values are set at compile time from your app config. Override with `config :corex, scales`, `:semantics`, or `:recipe_looks`, then recompile. See the Unstyled guide."

    quote do
      attr(unquote(axis), :string,
        values: unquote(values),
        default: nil,
        doc: unquote(doc)
      )
    end
  end

  defp axis_attr(_base, axis, values, default) do
    default_part =
      case default do
        nil -> ""
        value -> " Default `#{value}`."
      end

    override_hint =
      if axis == :semantic do
        " Override with `config :corex, semantics`."
      else
        " Override with `config :corex, scales`."
      end

    doc =
      "Style axis `#{axis}`.#{default_part} Allowed values are set at compile time from your app config.#{override_hint} Recompile after config changes. See the Unstyled guide."

    quote do
      attr(unquote(axis), :string,
        values: unquote(values),
        default: unquote(default),
        doc: unquote(doc)
      )
    end
  end

  @doc "Resolves compile-time axis value lists from a scale atom or explicit list."
  def axis_values(scale) when is_atom(scale), do: Corex.Scales.strings(scale)
  def axis_values(values) when is_list(values), do: Enum.map(values, &to_string/1)

  @bem_skip_axes ~W(hide_from hide_below as modal unstyled)a

  @doc "Builds the host BEM class for a styled component, honoring `unstyled` and `class`."
  def component_style_class(base, axis_names, defaults, assigns) do
    if Map.get(assigns, :unstyled, false) do
      assigns
      |> Map.get(:class)
      |> List.wrap()
      |> Corex.Style.merge_class()
    else
      host_class(base, axis_names, defaults, assigns)
    end
  end

  @doc "Builds the merged host class from base, axis modifiers, and optional `class`."
  def host_class(base, axis_names, defaults, assigns) do
    base
    |> List.wrap()
    |> Kernel.++(bem_modifiers(base, axis_names, defaults, assigns))
    |> Kernel.++(List.wrap(Map.get(assigns, :class)))
    |> Corex.Style.merge_class()
  end

  @doc "Builds a host class from base and `class` only, without axis modifiers."
  def component_class(base, assigns), do: host_class(base, [], %{}, assigns)

  @doc "Builds the host BEM class for the selected polymorphic recipe look."
  def recipe_class(recipes, default, assigns, defaults \\ %{}) do
    name = recipe_name(assigns, default)
    %{base: base, axes: axes} = Map.fetch!(recipes, name)

    base
    |> List.wrap()
    |> Kernel.++(bem_modifiers(base, axes, defaults, assigns))
    |> Kernel.++(List.wrap(Map.get(assigns, :class)))
    |> Corex.Style.merge_class()
  end

  defp bem_modifiers(base, axis_names, defaults, assigns) do
    for axis <- axis_names,
        axis not in @bem_skip_axes,
        value = resolve(axis, defaults, assigns),
        not is_nil(value) do
      "#{base}--#{bem_step(axis, value)}"
    end
  end

  defp bem_step(axis, value), do: Corex.Bem.step(axis, value)

  defp recipe_name(assigns, default) do
    case Map.get(assigns, :as) do
      nil -> default
      name when is_atom(name) -> Atom.to_string(name)
      name when is_binary(name) -> name
    end
  end

  @doc "Builds layout design output (`%{class: ...}`) from layout axis assigns."
  def layout_design(base, axis_names, assigns) do
    class =
      if Map.get(assigns, :unstyled, false) do
        Map.get(assigns, :class)
      else
        layout_host_class(base, axis_names, assigns)
      end

    %{class: class}
  end

  defp layout_host_class(base, axis_names, assigns) do
    base
    |> List.wrap()
    |> Kernel.++(layout_bem_modifiers(base, axis_names, assigns))
    |> Kernel.++(List.wrap(Map.get(assigns, :class)))
    |> Corex.Style.merge_class()
  end

  defp layout_bem_modifiers(base, axis_names, assigns) do
    for axis <- axis_names,
        axis not in @bem_skip_axes,
        value = Map.get(assigns, axis),
        not is_nil(value) do
      "#{base}--#{layout_bem_step(axis, value)}"
    end
  end

  defp layout_bem_step(axis, value), do: Corex.Bem.step(axis, value)

  defp resolve(axis, defaults, assigns) do
    case Map.get(assigns, axis) do
      nil -> Map.get(defaults, axis)
      value -> value
    end
  end
end
