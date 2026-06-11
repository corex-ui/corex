defmodule Corex.Bem do
  @moduledoc false

  def step(:max_width, value), do: "max-w-#{value}"
  def step(:max_height, value), do: "max-h-#{value}"
  def step(:width, value), do: "w-#{value}"
  def step(:height, value), do: "h-#{value}"
  def step(:surface, value), do: "on-#{value}"
  def step(:radius, value), do: "rounded-#{value}"
  def step(axis, value), do: "#{axis_name(axis)}-#{value}"

  def axis_name(axis) when is_atom(axis) do
    axis
    |> Atom.to_string()
    |> String.replace("_", "-")
  end

  def modifier_class(base, axis, value) do
    "#{base}--#{step(axis, value)}"
  end

  def merge_class(classes) do
    classes
    |> List.wrap()
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join(" ")
  end

  defmodule Variants do
    @moduledoc false

    @bem_skip_axes ~W(as modal unstyled)a

    defmacro __using__(opts) do
      env = __CALLER__

      case Keyword.get(opts, :kind, :component) do
        :component -> component_using(opts, env)
        :layout -> layout_using(opts, env)
        :polymorphic -> polymorphic_using(opts, env)
      end
    end

    defp component_using(opts, _env) do
      base = Keyword.fetch!(opts, :base)
      axes = normalize_axes!(opts, :component)
      declare_class? = Keyword.get(opts, :class_attr, true)

      axis_decls = for axis <- axes, do: axis_attr(axis)

      class_decl = if declare_class?, do: class_attr()

      quote do
        @corex_base unquote(base)
        @corex_axis_names unquote(axes)

        @doc "Returns the BEM class string for this component's configured style axes."
        def corex_style_class(assigns) do
          Corex.Bem.Variants.component_style_class(@corex_base, @corex_axis_names, assigns)
        end

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

    @layout_hide_axes ~W(hide_from hide_below)a

    defp layout_using(opts, _env) do
      base = Keyword.fetch!(opts, :base)
      axes = normalize_axes!(opts, :layout)
      axis_names = axes ++ @layout_hide_axes

      axis_decls = for axis <- axis_names, do: axis_attr(axis)

      quote do
        @corex_base unquote(base)
        @corex_axis_names unquote(axis_names)

        @doc "Returns layout design output (`%{class: ...}`) for this layout primitive."
        def corex_layout_design(assigns) do
          Corex.Bem.Variants.layout_design(@corex_base, @corex_axis_names, assigns)
        end

        attr(:class, :any, default: nil, doc: "Additional classes for the host element.")
        attr(:unstyled, :boolean, default: false, doc: "Skip design output, keep only `class`.")

        attr(:rest, :global)

        unquote_splicing(axis_decls)
      end
    end

    defp polymorphic_using(opts, _env) do
      looks = Keyword.fetch!(opts, :looks)
      default_as = Keyword.fetch!(opts, :default_as)
      axes = normalize_axes!(opts, :polymorphic)
      declare_class? = Keyword.get(opts, :class_attr, true)

      looks_map =
        looks
        |> Map.new(fn {name, base} -> {to_string(name), base} end)

      default_str = to_string(default_as)

      axis_decls = for axis <- axes, do: axis_attr(axis)

      class_decl = if declare_class?, do: class_attr()

      quote do
        @corex_looks unquote(Macro.escape(looks_map))
        @corex_default_as unquote(default_str)
        @corex_axis_names unquote(axes)

        @doc "Returns the BEM class string for the active polymorphic look."
        def corex_style_class(assigns) do
          Corex.Bem.Variants.polymorphic_class(
            @corex_looks,
            @corex_default_as,
            @corex_axis_names,
            assigns
          )
        end

        attr(:as, :string,
          default: unquote(default_str),
          doc: "Look name for BEM base resolution."
        )

        unquote(class_decl)

        unquote_splicing(axis_decls)
      end
    end

    defp normalize_axes!(opts, kind) do
      case Keyword.fetch!(opts, :axes) do
        axes when is_list(axes) ->
          if axes != [] and Keyword.keyword?(axes) do
            raise ArgumentError,
                  "Corex.Bem.Variants #{kind} axes: must be a list of atoms, not keyword pairs"
          end

          Enum.map(axes, fn
            axis when is_atom(axis) -> axis
            other -> raise ArgumentError, "Corex.Bem.Variants axes: expected atoms, got #{inspect(other)}"
          end)

        _ ->
          raise ArgumentError, "Corex.Bem.Variants #{kind} axes: must be a list of atoms"
      end
    end

    defp axis_attr(axis) do
      doc = "Style axis `#{axis}`."

      quote do
        attr(unquote(axis), :string, default: nil, doc: unquote(doc))
      end
    end

    @doc "Builds the host BEM class for a styled component, honoring `unstyled` and `class`."
    def component_style_class(base, axis_names, assigns) do
      cond do
        Map.get(assigns, :unstyled, false) ->
          class_only(assigns)

        emit_style_classes?() ->
          host_class(base, axis_names, assigns)

        true ->
          class_only(assigns)
      end
    end

    @doc "Builds the merged host class from base, axis modifiers, and optional `class`."
    def host_class(base, axis_names, assigns) do
      base
      |> List.wrap()
      |> Kernel.++(bem_modifiers(base, axis_names, assigns))
      |> Kernel.++(List.wrap(Map.get(assigns, :class)))
      |> Corex.Bem.merge_class()
    end

    @doc "Builds a host class from base and `class` only, without axis modifiers."
    def component_class(base, assigns), do: host_class(base, [], assigns)

    @doc "Builds the host BEM class for the selected polymorphic look."
    def polymorphic_class(looks, default_as, axis_names, assigns) do
      name = look_name(assigns, default_as)
      base = Map.get(looks, name, name)

      cond do
        emit_style_classes?() ->
          base
          |> List.wrap()
          |> Kernel.++(bem_modifiers(base, axis_names, assigns))
          |> Kernel.++(List.wrap(Map.get(assigns, :class)))
          |> Corex.Bem.merge_class()

        true ->
          class_only(assigns)
      end
    end

    @doc "Builds layout design output (`%{class: ...}`) from layout axis assigns."
    def layout_design(base, axis_names, assigns) do
      class =
        cond do
          Map.get(assigns, :unstyled, false) ->
            Map.get(assigns, :class)

          emit_style_classes?() ->
            layout_host_class(base, axis_names, assigns)

          true ->
            Map.get(assigns, :class)
        end

      %{class: class}
    end

    defp class_only(assigns) do
      assigns
      |> Map.get(:class)
      |> List.wrap()
      |> Corex.Bem.merge_class()
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

    defp layout_host_class(base, axis_names, assigns) do
      host_class(base, axis_names, assigns)
    end

    defp look_name(assigns, default) do
      case Map.get(assigns, :as) do
        nil -> default
        name when is_atom(name) -> Atom.to_string(name)
        name when is_binary(name) -> name
      end
    end

    defp emit_style_classes? do
      Application.get_env(:corex, :emit_style_classes, false)
    end
  end
end
