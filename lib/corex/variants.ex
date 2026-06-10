defmodule Corex.Variants do
  @moduledoc false

  @breakpoints [nil, "sm", "md", "lg", "xl", "2xl"]

  defmacro __using__(opts) do
    env = __CALLER__

    case Keyword.get(opts, :kind, :component) do
      :component -> component_using(opts, env)
      :layout -> layout_using(opts, env)
      :polymorphic -> polymorphic_using(opts, env)
    end
  end

  defp component_using(opts, env) do
    base = Keyword.fetch!(opts, :base)
    axes = Keyword.fetch!(opts, :axes)
    declare_class? = Keyword.get(opts, :class_attr, true)

    axis_names = Keyword.keys(axes)

    axis_decls =
      for {axis, scale} <- axes, do: axis_attr(axis, axis_attr_values(scale, env))

    class_decl = if declare_class?, do: class_attr()

    quote do
      @corex_base unquote(base)
      @corex_axis_names unquote(axis_names)

      @doc "Returns the BEM class string for this component's configured style axes."
      def corex_style_class(assigns) do
        Corex.Variants.component_style_class(@corex_base, @corex_axis_names, assigns)
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

  defp layout_using(opts, env) do
    base = Keyword.fetch!(opts, :base)
    axes = Keyword.fetch!(opts, :axes)
    axis_names = Keyword.keys(axes)

    axis_decls =
      for {axis, scale} <- axes do
        axis_attr(axis, axis_attr_values(scale, env))
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

  defp polymorphic_using(opts, env) do
    looks = Keyword.fetch!(opts, :looks)
    default_as = Keyword.fetch!(opts, :default_as)
    axes = Keyword.fetch!(opts, :axes)
    declare_class? = Keyword.get(opts, :class_attr, true)

    unless default_as in Keyword.keys(looks) do
      raise ArgumentError,
            "Corex.Variants default_as #{inspect(default_as)} must be one of #{inspect(Keyword.keys(looks))}"
    end

    looks_map =
      looks
      |> Map.new(fn {name, base} -> {to_string(name), base} end)

    meta =
      Map.new(looks_map, fn {name, base} -> {name, %{base: base, axes: Keyword.keys(axes)}} end)

    names = Map.keys(looks_map)
    default_str = to_string(default_as)
    axis_names = Keyword.keys(axes)

    axis_decls =
      for {axis, scale} <- axes do
        axis_attr(axis, axis_attr_values(scale, env))
      end

    class_decl = if declare_class?, do: class_attr()

    quote do
      @corex_looks unquote(Macro.escape(looks_map))
      @corex_default_as unquote(default_str)
      @corex_axis_names unquote(axis_names)
      @corex_recipes unquote(Macro.escape(meta))

      @doc "Returns the BEM class string for the active polymorphic look."
      def corex_style_class(assigns) do
        Corex.Variants.polymorphic_class(
          @corex_looks,
          @corex_default_as,
          @corex_axis_names,
          assigns
        )
      end

      @doc "Returns recipe metadata for style introspection and tooling."
      def __corex_style__, do: {:recipes, @corex_default_as, @corex_recipes}

      attr(:as, :string,
        values: unquote([nil | names]),
        default: unquote(default_str),
        doc: "Look to wear (one of #{unquote(Enum.join(names, ", "))})."
      )

      unquote(class_decl)

      unquote_splicing(axis_decls)
    end
  end

  defp axis_attr(axis, values) do
    doc = "Style axis `#{axis}`."

    quote do
      attr(unquote(axis), :string, values: unquote(values), default: nil, doc: unquote(doc))
    end
  end

  defp axis_attr_values(scale, env) do
    scale = Macro.expand(scale, env)
    [nil | axis_values(scale)]
  end

  @doc "Resolves compile-time axis value lists from a scale atom or explicit list."
  def axis_values(scale) when is_atom(scale), do: Corex.Scales.strings(scale)
  def axis_values(values) when is_list(values), do: Enum.map(values, &to_string/1)

  @bem_skip_axes ~W(hide_from hide_below as modal unstyled)a

  @doc "Builds the host BEM class for a styled component, honoring `unstyled` and `class`."
  def component_style_class(base, axis_names, assigns) do
    if Map.get(assigns, :unstyled, false) do
      assigns
      |> Map.get(:class)
      |> List.wrap()
      |> Corex.Style.merge_class()
    else
      host_class(base, axis_names, assigns)
    end
  end

  @doc "Builds the merged host class from base, axis modifiers, and optional `class`."
  def host_class(base, axis_names, assigns) do
    base
    |> List.wrap()
    |> Kernel.++(bem_modifiers(base, axis_names, assigns))
    |> Kernel.++(List.wrap(Map.get(assigns, :class)))
    |> Corex.Style.merge_class()
  end

  @doc "Builds a host class from base and `class` only, without axis modifiers."
  def component_class(base, assigns), do: host_class(base, [], assigns)

  @doc "Builds the host BEM class for the selected polymorphic look."
  def polymorphic_class(looks, default_as, axis_names, assigns) do
    name = look_name(assigns, default_as)

    base =
      case Map.fetch(looks, name) do
        {:ok, block} ->
          block

        :error ->
          raise ArgumentError,
                "invalid look #{inspect(name)}; expected one of #{inspect(Map.keys(looks))}"
      end

    base
    |> List.wrap()
    |> Kernel.++(bem_modifiers(base, axis_names, assigns))
    |> Kernel.++(List.wrap(Map.get(assigns, :class)))
    |> Corex.Style.merge_class()
  end

  defp bem_modifiers(base, axis_names, assigns) do
    for axis <- axis_names,
        axis not in @bem_skip_axes,
        value = Map.get(assigns, axis),
        not is_nil(value) do
      "#{base}--#{bem_step(axis, value)}"
    end
  end

  defp bem_step(axis, value), do: Corex.Bem.step(axis, value)

  defp look_name(assigns, default) do
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
end
