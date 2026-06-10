defmodule Corex.Design.Recipes do
  @moduledoc false

  alias Corex.Design.Recipes.Layout
  alias Corex.Design.Recipes.Typo

  @component_recipe_modules [
    Corex.Design.Recipes.Accordion,
    Corex.Design.Recipes.AngleSlider,
    Corex.Design.Recipes.Avatar,
    Corex.Design.Recipes.Badge,
    Corex.Design.Recipes.Button,
    Corex.Design.Recipes.Carousel,
    Corex.Design.Recipes.Checkbox,
    Corex.Design.Recipes.Clipboard,
    Corex.Design.Recipes.Code,
    Corex.Design.Recipes.Collapsible,
    Corex.Design.Recipes.ColorPicker,
    Corex.Design.Recipes.Combobox,
    Corex.Design.Recipes.DataList,
    Corex.Design.Recipes.DataTable,
    Corex.Design.Recipes.DatePicker,
    Corex.Design.Recipes.DialogModal,
    Corex.Design.Recipes.DialogSide,
    Corex.Design.Recipes.Editable,
    Corex.Design.Recipes.FileUpload,
    Corex.Design.Recipes.FloatingPanel,
    Corex.Design.Recipes.LayoutHeading,
    Corex.Design.Recipes.Link,
    Corex.Design.Recipes.Listbox,
    Corex.Design.Recipes.Marquee,
    Corex.Design.Recipes.Menu,
    Corex.Design.Recipes.NativeInput,
    Corex.Design.Recipes.NumberInput,
    Corex.Design.Recipes.Pagination,
    Corex.Design.Recipes.PasswordInput,
    Corex.Design.Recipes.PinInput,
    Corex.Design.Recipes.RadioGroup,
    Corex.Design.Recipes.Select,
    Corex.Design.Recipes.SignaturePad,
    Corex.Design.Recipes.Switch,
    Corex.Design.Recipes.Tabs,
    Corex.Design.Recipes.TagsInput,
    Corex.Design.Recipes.Timer,
    Corex.Design.Recipes.Toast,
    Corex.Design.Recipes.Toggle,
    Corex.Design.Recipes.ToggleGroup,
    Corex.Design.Recipes.Tooltip,
    Corex.Design.Recipes.TreeNavigation,
    Corex.Design.Recipes.TreeView
  ]

  @doc "Semantic axis host markers that stamp BEM role modifiers on the host."
  def semantic_host_variants, do: Corex.Design.Palette.semantic_host_variants()

  @doc "Semantic axis host markers for part recipes (styles the host part)."
  def semantic_part_host_variants, do: Corex.Design.Palette.semantic_part_host_variants()

  def semantic_slot_host_variants, do: semantic_part_host_variants()

  @doc "All component recipes (anatomy, states, variants)."
  def components do
    Enum.map(@component_recipe_modules, & &1.recipe())
  end

  @doc "All layout recipes (box/stack/row/grid/container/spacer/divider/icon)."
  def layout, do: Layout.all()

  @doc "Typography element recipes (h1, p, form, list, …)."
  def typography, do: Typo.all()

  @doc """
  Every recipe the compiler renders into the recipe layer, with host overrides
  from `config :corex_design, recipes: [...]` merged by `:id` (a host recipe
  replaces a built-in with the same id in place; a new id is appended).
  """
  def all do
    builtins = components() ++ layout() ++ typography()
    overrides = host_recipes()
    by_id = Map.new(overrides, &{&1.id, &1})

    replaced =
      Enum.map(builtins, fn recipe -> Map.get(by_id, recipe.id, recipe) end)

    builtin_ids = MapSet.new(builtins, & &1.id)
    added = Enum.reject(overrides, &MapSet.member?(builtin_ids, &1.id))

    replaced ++ added
  end

  @doc """
  Recipes the compiler emits as CSS: `all/0` filtered by the optional allowlist
  `config :corex_design, include_recipes: [:button, :select, ...]` (recipe ids).
  When unset, every recipe is emitted. Filtering shrinks the Tailwind recipe
  exports for apps that use a known subset; the full vocabulary
  still flows to the component contract via `all/0`.
  """
  def emitted do
    case Application.get_env(:corex_design, :include_recipes) do
      nil ->
        all()

      ids when is_list(ids) ->
        allowed = MapSet.new(ids)
        Enum.filter(all(), &MapSet.member?(allowed, &1.id))
    end
  end

  @doc false
  def host_recipes do
    :corex_design
    |> Application.get_env(:recipes, [])
    |> List.wrap()
    |> Enum.flat_map(&source_recipes/1)
  end

  @doc false
  def component_recipe_modules, do: @component_recipe_modules

  defp source_recipes(module) when is_atom(module) do
    :code.ensure_loaded(module)

    unless function_exported?(module, :recipes, 0) do
      raise ArgumentError,
            "config :corex_design, recipes: expects modules implementing " <>
              "Corex.Design.RecipeSource (recipes/0); got #{inspect(module)}"
    end

    Enum.map(module.recipes(), &validate_recipe!(&1, module))
  end

  defp source_recipes(other) do
    raise ArgumentError,
          "config :corex_design, recipes: expects a list of modules, got #{inspect(other)}"
  end

  defp validate_recipe!(%Corex.Design.Recipe{} = recipe, _module), do: recipe

  defp validate_recipe!(other, module) do
    raise ArgumentError,
          "#{inspect(module)}.recipes/0 must return %Corex.Design.Recipe{} structs, " <>
            "got #{inspect(other)}"
  end

  defmodule FormHost do
    @moduledoc false

    alias Corex.Design.Rule
    alias Corex.Design.Selector

    def host_rules(id, scope, opts \\ []) do
      orientation_rules = Keyword.get(opts, :orientation_rules, true)
      host = Selector.host(id)

      rules =
        [
          Rule.new(host,
            decls: [
              display: "flex",
              flex_direction: "column",
              gap: "var(--space)"
            ]
          ),
          Rule.new("#{host}[data-loading] #{Selector.slot(scope, "root")}",
            decls: [include: :ui_loading]
          ),
          Rule.new(Selector.part(id, scope, "root"),
            decls: [include: :ui_root]
          ),
          Rule.new("#{Selector.part(id, scope, "root")}[data-readonly]",
            decls: [include: :ui_readonly]
          ),
          Rule.new(Selector.part(id, scope, "label"),
            decls: [include: :ui_label]
          ),
          Rule.new(Selector.part(id, scope, "error"),
            decls: [include: :ui_error]
          )
        ]

      if orientation_rules do
        rules ++
          [
            Rule.new(Selector.host_attr(id, "data-orientation", "horizontal"),
              decls: [max_width: "fit-content"]
            ),
            Rule.new(Selector.host_attr(id, "data-orientation", "vertical"),
              decls: [max_width: {:container, :"4xs"}]
            )
          ]
      else
        rules
      end
    end

    def control_focus_rules(id, scope, checked_selector) do
      control = Selector.part(id, scope, "control")

      [
        Rule.new(control,
          decls: [
            display: "flex",
            align_items: "center",
            justify_content: "center",
            cursor: "pointer",
            flex_shrink: "0",
            border: "1px solid var(--color-border)",
            background: "var(--color-ui)",
            color: "var(--color-ui-ink)"
          ],
          children: [
            Rule.new("&:hover", decls: [background_color: "var(--color-ui-hover)"]),
            Rule.new("&:active", decls: [background_color: "var(--color-ui-active)"]),
            Rule.new("&:focus-visible,\n  &[data-focus]",
              decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--color-ui-ink)"]
            ),
            Rule.new(checked_selector,
              decls: [
                background: "var(--color-accent-active)",
                color: "var(--color-accent-ink)"
              ],
              children: [
                Rule.new("&:hover", decls: [background_color: "var(--color-accent-hover)"]),
                Rule.new("&:active", decls: [background_color: "var(--color-accent)"]),
                Rule.new("&:focus-visible,\n  &[data-focus]",
                  decls: [box_shadow: "inset 0 0 0 2px var(--color-accent-ink)"]
                )
              ]
            ),
            Rule.new("&[data-state=\"unchecked\"]",
              decls: [background: "var(--color-ui)", color: "var(--color-ui-ink)"]
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
            Rule.new("&[data-invalid]:focus-visible,\n  &[data-invalid][data-focus]",
              decls: [box_shadow: "none"]
            )
          ]
        ),
        Rule.new(Selector.part(id, scope, "label"),
          decls: [cursor: "pointer"],
          children: [
            Rule.new("&[data-invalid]", decls: [color: "var(--color-ui-ink)"])
          ]
        ),
        Rule.new(
          "#{host(id)}[data-disabled] #{Selector.slot(scope, "label")},\n  #{host(id)}:has(#{Selector.slot(scope, "root")}[data-disabled]) #{Selector.slot(scope, "label")}",
          decls: [cursor: "not-allowed"]
        )
      ]
    end

    defp host(id), do: Selector.host(id)
  end

  defmodule SemanticStates do
    @moduledoc false

    alias Corex.Design.Palette
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    def open_closed_trigger_rules(id, part_selector, opts \\ []) do
      inherit = Keyword.get(opts, :inherit, [])

      for role <- Palette.color_atoms() do
        host = host_mod(id, role)
        muted = "var(#{Palette.muted_var(role)})"

        closed =
          Rule.new("#{host} #{slot_selector(id, part_selector)}[data-state=\"closed\"]",
            decls: [color: "var(#{Palette.fg_var(role)}, var(--color-ui-ink))"]
          )

        open_children =
          Palette.active_state_children(role, muted: muted) ++
            Enum.map(inherit, fn sel ->
              Rule.new("& #{sel}", decls: [color: "inherit"])
            end) ++
            [Rule.new("& [data-icon]", decls: [color: "currentcolor"])]

        open =
          Rule.new("#{host} #{slot_selector(id, part_selector)}[data-state=\"open\"]",
            decls: Palette.active_decls(role),
            children: open_children
          )

        [closed, open]
      end
      |> List.flatten()
    end

    def selected_trigger_rules(id, part_selector, attr \\ "[data-selected]") do
      for role <- Palette.color_atoms() do
        host = host_mod(id, role)
        muted = "var(#{Palette.muted_var(role)})"

        Rule.new("#{host} #{slot_selector(id, part_selector)}#{attr}",
          decls: Palette.active_decls(role),
          children: Palette.active_state_children(role, muted: muted)
        )
      end
    end

    def active_part_rules(id, part_selector, attrs, opts \\ []) do
      highlighted = Keyword.get(opts, :highlighted, false)

      for role <- Palette.color_atoms(), attr <- List.wrap(attrs) do
        host = host_mod(id, role)

        children =
          Palette.active_state_children(role) ++
            if(highlighted, do: highlighted_children(role), else: [])

        Rule.new("#{host} #{slot_selector(id, part_selector)}#{attr}",
          decls: Palette.active_decls(role),
          children: children
        )
      end
      |> List.flatten()
    end

    def active_selector_rules(id, selector, opts \\ []) do
      highlighted = Keyword.get(opts, :highlighted, false)

      for role <- Palette.color_atoms() do
        host = host_mod(id, role)

        children =
          Palette.active_state_children(role) ++
            if(highlighted, do: highlighted_children(role), else: [])

        Rule.new("#{host} #{slot_selector(id, selector)}",
          decls: Palette.active_decls(role),
          children: children
        )
      end
    end

    def solid_trigger_rules(id, part_selectors) when is_list(part_selectors) do
      part_selectors
      |> Enum.map(&slot_selector(id, &1))
      |> then(&solid_part_rules(id, &1))
    end

    def solid_part_rules(id, selectors) when is_list(selectors) do
      for role <- Palette.color_atoms() do
        host = host_mod(id, role)

        combined =
          selectors
          |> Enum.map_join(",\n  ", fn selector -> "#{host} #{selector}" end)

        Rule.new(combined,
          decls: Palette.active_decls(role),
          children: Palette.active_state_children(role)
        )
      end
    end

    def solid_part_rules(id, selector) when is_binary(selector) do
      solid_part_rules(id, [slot_selector(id, selector)])
    end

    def toggle_group_item_rules(id, part_selector) do
      active_sel = ~S(&[data-state="on"],\n  &[data-toggle-grouped],\n  &[data-state="checked"])

      inactive =
        "&:not([data-state=\"on\"]):not([data-toggle-grouped]):not([data-state=\"checked\"]):not([data-disabled]):not(:disabled):not([disabled])"

      for role <- Palette.color_atoms() do
        host = host_mod(id, role)
        focus_ring = "var(#{Palette.solid_var(role)})"
        ink_on_disabled = "var(#{Palette.on_solid_var(role)})"
        muted = "var(#{Palette.muted_var(role)})"

        Rule.new("#{host} #{slot_selector(id, part_selector)}",
          decls: [],
          children:
            [
              Rule.new(inactive,
                decls: [color: "var(#{Palette.fg_var(role)}, var(--color-ui-ink))"],
                children: [
                  Rule.new("&:focus-visible",
                    decls: [outline: "none", box_shadow: "inset 0 0 0 2px #{focus_ring}"]
                  )
                ]
              ),
              Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
                decls: [background_color: muted, color: ink_on_disabled, cursor: "not-allowed"]
              ),
              Rule.new(active_sel,
                decls: Palette.active_decls(role),
                children:
                  Palette.active_state_children(role,
                    muted: muted,
                    disabled_color: ink_on_disabled
                  )
              )
            ] ++ toggle_group_highlight_rules(active_sel, focus_ring, role)
        )
      end
    end

    def neutral_selected_trigger_rules(id, part_selector, attr \\ "[data-selected]") do
      host = ".#{Selector.class_name(id)}"
      role = :selected
      muted = "var(#{Palette.muted_var(role)})"

      [
        Rule.new("#{host} #{slot_selector(id, part_selector)}#{attr}",
          decls: Palette.active_decls(role),
          children: Palette.active_state_children(role, muted: muted)
        )
      ]
    end

    def neutral_toggle_group_item_rules(id, part_selector) do
      host = ".#{Selector.class_name(id)}"
      role = :selected
      active_sel = ~S(&[data-state="on"],\n  &[data-toggle-grouped],\n  &[data-state="checked"])

      inactive =
        "&:not([data-state=\"on\"]):not([data-toggle-grouped]):not([data-state=\"checked\"]):not([data-disabled]):not(:disabled):not([disabled])"

      focus_ring = "var(#{Palette.solid_var(role)})"
      ink_on_disabled = "var(#{Palette.on_solid_var(role)})"
      muted = "var(#{Palette.muted_var(role)})"

      [
        Rule.new("#{host} #{slot_selector(id, part_selector)}",
          decls: [],
          children:
            [
              Rule.new(inactive,
                decls: [color: "var(--color-ui-ink)"],
                children: [
                  Rule.new("&:focus-visible",
                    decls: [outline: "none", box_shadow: "inset 0 0 0 2px #{focus_ring}"]
                  )
                ]
              ),
              Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
                decls: [background_color: muted, color: ink_on_disabled, cursor: "not-allowed"]
              ),
              Rule.new(active_sel,
                decls: Palette.active_decls(role),
                children:
                  Palette.active_state_children(role,
                    muted: muted,
                    disabled_color: ink_on_disabled
                  )
              )
            ] ++ toggle_group_highlight_rules(active_sel, focus_ring, role)
        )
      ]
    end

    defp host_mod(id, role), do: Palette.host_mod(id, role)

    defp slot_selector(id, selector) do
      host = Selector.host(id)
      prefix = "#{host} "

      if String.starts_with?(selector, prefix) do
        String.replace_prefix(selector, prefix, "")
      else
        selector
      end
    end

    defp toggle_group_highlight_rules(active_sel, focus_ring, role) do
      inactive_highlight =
        "&[data-highlighted]:not([data-state=\"on\"]):not([data-toggle-grouped]):not([data-state=\"checked\"])"

      hover_children = [
        Rule.new("#{inactive_highlight}:not(:hover)",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px #{focus_ring}",
            background_color: "var(#{Palette.surface_var()})"
          ]
        ),
        Rule.new("#{inactive_highlight}:active", decls: [box_shadow: "none"]),
        Rule.new("#{active_sel}[data-highlighted]:not(:hover)",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(#{Palette.on_solid_var(role)})",
            background_color: "var(#{Palette.solid_hover_var(role)})",
            color: "var(#{Palette.on_solid_var(role)})"
          ]
        ),
        Rule.new("#{active_sel}[data-highlighted]:hover",
          decls: [
            outline: "none",
            box_shadow: "none",
            background_color: "var(#{Palette.solid_hover_var(role)})",
            color: "var(#{Palette.on_solid_var(role)})"
          ]
        ),
        Rule.new("#{active_sel}[data-highlighted]:active",
          decls: [
            outline: "none",
            box_shadow: "none",
            background_color: "var(#{Palette.solid_active_var(role)})",
            color: "var(#{Palette.on_solid_var(role)})"
          ]
        )
      ]

      touch_children = [
        Rule.new(inactive_highlight,
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px #{focus_ring}",
            background_color: "var(#{Palette.surface_var()})"
          ]
        ),
        Rule.new("#{active_sel}[data-highlighted]",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(#{Palette.on_solid_var(role)})",
            background_color: "var(#{Palette.solid_hover_var(role)})",
            color: "var(#{Palette.on_solid_var(role)})"
          ]
        )
      ]

      [
        Rule.new("@media (hover: hover)", children: hover_children),
        Rule.new("@media (hover: none)", children: touch_children)
      ]
    end

    defp highlighted_children(role) do
      [
        Rule.new("&[data-highlighted]",
          decls: [
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(#{Palette.on_solid_var(role)})",
            background_color: "var(#{Palette.solid_hover_var(role)})",
            color: "var(#{Palette.on_solid_var(role)})"
          ]
        )
      ]
    end
  end

  defmodule HostIcon do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @doc """
    Indicator part and `[data-icon]` sizing for a host recipe (`:button`, `:link`).
    """
    def indicator_rules(id) do
      host = Selector.host(id)
      indicator = ~s(#{host} [data-part="indicator"])
      icon = ~s(#{indicator} [data-icon])

      [
        Rule.new(indicator, decls: Map.to_list(RecipePresets.trigger_indicator_part())),
        Rule.new(icon,
          decls: [
            width: {:raw, "1em"},
            height: {:raw, "1em"},
            display: :inline_flex,
            flex_shrink: {:raw, "0"}
          ]
        )
      ]
    end

    def host_icon_rules(id) do
      host = Selector.host(id)

      [
        Rule.new(~s(#{host} [data-icon]), decls: [include: :ui_icon])
      ]
    end

    def sized_host_icon_rules(id, sizes \\ nil) do
      sizes = sizes || Axes.size_atoms()
      name = Selector.class_name(id)
      host = Selector.host(id)

      icon_decls = [
        display: :inline_flex,
        align_items: :center,
        justify_content: :center,
        flex_shrink: {:raw, "0"},
        padding: 0,
        width: {:raw, "1em !important"},
        height: {:raw, "1em !important"}
      ]

      base = Rule.new(~s(#{host} [data-icon]), decls: icon_decls)

      sized =
        for size <- sizes do
          Rule.new(~s(.#{name}.#{name}--size-#{size} [data-icon]), decls: icon_decls)
        end

      [base | sized]
    end

    @doc """
    Square host `[data-icon]` sizing (direct child or in indicator).
    """
    def square_icon_rules(id) do
      host = Selector.host(id)
      name = Selector.class_name(id)
      square = ~s(#{host}.#{name}--shape-square)

      [
        Rule.new(
          ~s(#{square} > [data-icon],\n  #{square} [data-part="indicator"] [data-icon]),
          decls: [
            width: {:raw, "1em"},
            height: {:raw, "1em"},
            flex_shrink: "0",
            display: :inline_flex
          ]
        )
      ]
    end

    def scoped_size_rules(id, scope, part \\ "root") do
      name = Selector.class_name(id)
      host = Selector.host(id)
      part_sel = ~s([data-scope="#{scope}"][data-part="#{part}"])

      for size <- Axes.size_atoms() do
        Rule.new(
          ~s(#{host}.#{name}--size-#{size} #{part_sel}),
          decls: Map.to_list(RecipePresets.size_block(size))
        )
      end
    end

    def scoped_shape_square_size_rules(id, scope, part \\ "root") do
      name = Selector.class_name(id)
      host = Selector.host(id)
      part_sel = ~s([data-scope="#{scope}"][data-part="#{part}"])

      for size <- Axes.size_atoms() do
        Rule.new(
          ~s(#{host}.#{name}--shape-square.#{name}--size-#{size} #{part_sel}),
          decls: [
            padding: 0,
            padding_inline: 0,
            padding_block: 0,
            width: {:size, size},
            min_height: {:size, size},
            aspect_ratio: {:raw, "1 / 1"},
            justify_content: :center
          ]
        )
      end
    end

    def shape_variants do
      [
        auto: %{},
        square: %{
          aspect_ratio: {:raw, "1 / 1"},
          padding: 0,
          justify_content: :center,
          width: :auto
        }
      ]
    end
  end

  defmodule Layout do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @gaps ~W(none sm md lg xl)a
    @aligns ~W(start center end stretch baseline)a
    @justifies ~W(start center end between around evenly)a

    def all do
      [box(), stack(), row(), grid(), container(), spacer(), divider(), icon()]
    end

    def get(id), do: Enum.find(all(), &(&1.id == id))

    defp box do
      Recipe.new(:box,
        base: [display: "block"],
        variants: [padding: gap_scale(:padding), radius: radius_scale()],
        default_variants: [padding: :none]
      )
    end

    defp stack do
      Recipe.new(:stack,
        base: [display: "flex", flex_flow: "column nowrap"],
        variants:
          flex_variants() ++
            direction_variants() ++
            [
              variant: [
                {:none, []},
                {:layer,
                 [
                   background_color: {:color, :layer},
                   border: {:raw, "1px solid var(--color-border)"},
                   box_shadow: {:raw, "var(--shadow-md)"}
                 ]}
              ],
              radius: radius_scale()
            ],
        default_variants: flex_defaults() ++ [direction: :column, variant: :none, radius: :none]
      )
    end

    defp row do
      row_defaults =
        spacing_defaults() ++
          [
            gap: :none,
            align: :center,
            justify: :start,
            width: :none,
            grow: :none,
            shrink: :none,
            wrap: :wrap
          ]

      Recipe.new(:row,
        base: [display: "flex", flex_flow: "row wrap", align_items: "center"],
        variants:
          flex_variants() ++
            [
              wrap: [
                {:wrap, [flex_flow: "row wrap"]},
                {:nowrap, [flex_flow: "row nowrap"]}
              ]
            ],
        default_variants: row_defaults
      )
    end

    defp flex_variants do
      spacing_variants() ++
        [
          gap: gap_scale(:gap),
          align: align_scale(),
          justify: justify_scale(),
          width: width_scale(),
          min_height: min_height_scale(),
          grow: grow_scale(),
          shrink: shrink_scale()
        ]
    end

    defp min_height_scale do
      [
        {:none, []},
        {:full, [min_height: "100%"]},
        {:screen, [min_height: "100vh"]},
        {:dvh, [min_height: "100dvh"]}
      ]
    end

    defp flex_defaults do
      spacing_defaults() ++
        [gap: :none, align: :stretch, justify: :start, width: :none, grow: :none, shrink: :none]
    end

    defp spacing_variants do
      [
        padding: space_scale(:padding),
        padding_inline: space_scale(:padding_inline),
        padding_block: space_scale(:padding_block)
      ]
    end

    defp spacing_defaults do
      [
        padding: :none,
        padding_inline: :none,
        padding_block: :none
      ]
    end

    defp space_scale(property), do: gap_scale(property)

    defp direction_variants do
      [
        direction: [
          {:row, [flex_flow: "row nowrap"]},
          {:column, [flex_flow: "column nowrap"]}
        ]
      ]
    end

    defp width_scale do
      [
        {:none, []},
        {:full, [width: "100%"]}
      ]
    end

    defp grow_scale do
      [
        {:none, []},
        {:fill, [flex: "1 1 auto", min_width: "0", min_height: "0"]}
      ]
    end

    defp shrink_scale do
      [
        {:none, []},
        {:"0", [flex_shrink: "0"]}
      ]
    end

    defp grid do
      Recipe.new(:grid,
        base: [display: "grid"],
        variants: [
          gap: gap_scale(:gap),
          columns:
            Enum.map(1..6, fn n ->
              {n, [grid_template_columns: {:raw, "repeat(#{n}, minmax(0, 1fr))"}]}
            end)
        ],
        default_variants: [gap: :none]
      )
    end

    defp container do
      sizes = ~W(7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl)a

      Recipe.new(:container,
        base: [width: "100%", margin_inline: "auto"],
        variants: [
          size: Enum.map(sizes, fn s -> {s, [max_width: {:container, s}]} end)
        ],
        default_variants: [size: :lg]
      )
    end

    defp spacer do
      Recipe.new(:spacer, base: [flex: "1 1 auto"])
    end

    defp divider do
      Recipe.new(:divider,
        base: [
          border: "0",
          border_top: {:raw, "1px solid var(--color-border)"},
          block_size: "0",
          inline_size: "100%"
        ],
        variants: [
          orientation: [
            {:horizontal,
             [border_top: {:raw, "1px solid var(--color-border)"}, inline_size: "100%"]},
            {:vertical,
             [
               border_top: "0",
               border_inline_start: {:raw, "1px solid var(--color-border)"},
               inline_size: "0",
               block_size: "100%"
             ]}
          ]
        ],
        default_variants: [orientation: :horizontal]
      )
    end

    defp icon do
      host = Selector.host(:icon)

      Recipe.new(:icon,
        base: [
          display: "inline-flex",
          align_items: "center",
          flex_shrink: "0",
          color: "currentcolor"
        ],
        variants: [
          text: Enum.map(Axes.text_atoms(), fn step -> {step, RecipePresets.text_block(step)} end)
        ],
        default_variants: [text: :sm],
        extra_rules: [
          Rule.new(~s(#{host} [data-icon],\n  #{host} svg,\n  #{host} img),
            decls: [include: :ui_icon]
          ),
          Rule.new("#{host} img", decls: [{:raw, "object-fit: contain"}])
        ]
      )
    end

    defp gap_scale(property) do
      Enum.map(@gaps, fn
        :none -> {:none, [{property, "0"}]}
        step -> {step, [{property, {:space, step}}]}
      end)
    end

    defp align_scale do
      Enum.map(@aligns, fn value -> {value, [align_items: css_align(value)]} end)
    end

    defp justify_scale do
      Enum.map(@justifies, fn value -> {value, [justify_content: css_justify(value)]} end)
    end

    defp radius_scale do
      Enum.map(~W(none sm md lg xl 2xl full)a, fn step ->
        {step, [border_radius: {:radius, step}]}
      end)
    end

    defp css_align(:start), do: "flex-start"
    defp css_align(:end), do: "flex-end"
    defp css_align(value), do: to_string(value)

    defp css_justify(:start), do: "flex-start"
    defp css_justify(:end), do: "flex-end"
    defp css_justify(:between), do: "space-between"
    defp css_justify(:around), do: "space-around"
    defp css_justify(:evenly), do: "space-evenly"
    defp css_justify(value), do: to_string(value)
  end

  defmodule Typo do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector
    alias Corex.Design.Typography

    @text_ids ~W(h1 h2 h3 h4 p lead small kbd blockquote)a

    def all do
      Enum.map(@text_ids, &recipe/1) ++ [recipe(:list), recipe(:form)]
    end

    def recipe(:list) do
      host = Selector.host(:list)
      defaults = Typography.default()

      Recipe.define(:list,
        base: Map.fetch!(defaults, ".list"),
        variants: [
          text: text_variants(),
          semantic: semantic_variants()
        ],
        extra_rules: [
          Rule.new("#{host} li", decls: Map.fetch!(defaults, ".list li")),
          Rule.new("#{host} li:last-child", decls: Map.fetch!(defaults, ".list li:last-child")),
          Rule.new("#{host} li:hover", decls: Map.fetch!(defaults, ".list li:hover"))
        ]
      )
    end

    def recipe(:form) do
      Recipe.define(:form,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: Typography.form_base(),
        variants: [
          semantic: semantic_variants(),
          gap: gap_variants()
        ]
      )
    end

    def recipe(id) when id in @text_ids do
      Recipe.define(id,
        base: Typography.element_base(id),
        variants: [
          text: text_variants(),
          semantic: semantic_variants(),
          weight: weight_variants()
        ]
      )
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, RecipePresets.text_block(step)}
    end

    defp semantic_variants do
      for role <- Palette.color_atoms(),
          do: {role, %{color: {:color, Palette.ink_color_atom(role)}}}
    end

    defp weight_variants do
      for weight <- Axes.weight_atoms(), do: {weight, %{font_weight: {:weight, weight}}}
    end

    defp gap_variants do
      none = %{gap: 0, padding: 0}

      spacing =
        for step <- ~W(sm md lg xl)a,
            do: {step, %{gap: {:space, step}, padding: {:space, step}}}

      [{:none, none} | spacing]
    end
  end

  defmodule Dialog do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "dialog"

    def recipe, do: modal_recipe()

    def modal_recipe do
      id = :dialog_modal

      Recipe.part_recipe(id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules(id) ++ semantic_dialog_rules(id) ++ text_content_p_rules(id)
      )
    end

    def side_recipe do
      id = :dialog_side

      Recipe.part_recipe(id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants(),
          side: side_variants()
        ],
        default_variants: [size: :md, side: :start],
        extra_rules:
          base_rules(id) ++
            semantic_dialog_rules(id) ++ side_layout_rules(id) ++ text_content_p_rules(id)
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp semantic_dialog_rules(id) do
      Palette.semantic_ink_part_rules(id, part(id, "close-trigger"))
    end

    defp side_variants do
      [
        start: [positioner: %{justify_content: "flex-start", align_items: "stretch"}],
        end: [positioner: %{justify_content: "flex-end", align_items: "stretch"}],
        top: [positioner: %{align_items: "flex-start", justify_content: "center"}],
        bottom: [positioner: %{align_items: "flex-end", justify_content: "center"}]
      ]
    end

    defp base_rules(id) do
      host = Selector.host(id)
      trigger = part(id, "trigger")
      close_trigger = part(id, "close-trigger")
      backdrop = part(id, "backdrop")
      positioner = part(id, "positioner")
      content = part(id, "content")
      header = part(id, "header")
      title = part(id, "title")
      description = part(id, "description")

      [
        Rule.new("#{host}[data-loading] > *", decls: [include: :ui_loading]),
        Rule.new(trigger, decls: [include: :ui_trigger]),
        Rule.new(close_trigger,
          decls: [
            include: :ui_trigger,
            flex_shrink: "0",
            height: "fit-content",
            margin_inline_start: "auto",
            min_height: {:size, :sm},
            aspect_ratio: "1 / 1",
            padding: "0"
          ]
        ),
        Rule.new(backdrop,
          decls: [
            position: "fixed",
            inset: "0",
            width: "100vw",
            height: "100vh",
            background: {:raw, "color-mix(in srgb, var(--color-ui) 95%, transparent)"},
            z_index: "10"
          ]
        ),
        Rule.new(positioner,
          decls: [
            position: "fixed",
            inset: "0",
            width: "100vw",
            height: "100vh",
            display: "flex",
            align_items: "center",
            justify_content: "center",
            z_index: "10"
          ]
        ),
        Rule.new(content,
          decls: [
            include: :ui_content,
            max_width: {:container, :md},
            padding: {:space, :md},
            text_align: "start"
          ]
        ),
        Rule.new(
          "#{slot("positioner")}:has(#{slot("content")}[data-state=\"closed\"])",
          decls: [pointer_events: "none"]
        ),
        Rule.new(
          ~s(#{host}[data-animation='js'] #{slot("backdrop")}[data-state='closed'],\n  #{host}[data-animation='custom'] #{slot("backdrop")}[data-state='closed'],\n  #{host}[data-animation='js'] #{slot("content")}[data-state='closed'],\n  #{host}[data-animation='custom'] #{slot("content")}[data-state='closed']),
          decls: [opacity: "0", pointer_events: "none"]
        ),
        Rule.new(header, decls: [display: "flex", align_items: "center"]),
        Rule.new("#{slot("header")} #{slot("title")}",
          decls: [flex: "1 1 0%", min_width: "0"]
        ),
        Rule.new(~s(#{host} [data-part="row"]),
          decls: [
            display: "inline-flex",
            flex_direction: "row",
            justify_content: "space-between"
          ]
        ),
        Rule.new(title, decls: [margin_block: "0", text_align: "start"]),
        Rule.new(description, decls: [margin_block: "0", text_align: "start"]),
        Rule.new("#{slot("content")}[data-has-nested]",
          decls: [
            transform: {:raw, "scale(calc(1 - var(--nested-layer-count) * 0.05))"},
            transition: "transform 0.2s ease-in-out"
          ]
        ),
        Rule.new("#{slot("content")}[data-nested]",
          decls: [border: {:raw, "2px solid var(--color-border-accent, var(--color-accent))"}]
        ),
        Rule.new("#{slot("backdrop")}[data-has-nested]",
          decls: [opacity: {:raw, "calc(0.4 + var(--nested-layer-count) * 0.1)"}]
        )
      ]
    end

    defp side_layout_rules(id) do
      host = Selector.host(id)
      content = part(id, "content")
      positioner = part(id, "positioner")

      [
        Rule.new("#{host} #{content}",
          decls: [
            height: "100%",
            overflow: "hidden",
            display: "flex",
            flex_direction: "column",
            width: "100%",
            max_width: {:container, :"3xs"},
            padding: "0 !important",
            border_radius: {:radius, :none},
            border: "0"
          ]
        ),
        Rule.new("#{host} #{positioner}",
          decls: [
            align_items: "stretch",
            justify_content: "flex-start",
            height: "100vh"
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        {size,
         [
           content: %{
             padding: {:space, size},
             max_width: {:container, size}
           },
           header: %{padding: {:space, size}, gap: {:space, size}},
           description: %{
             padding_inline: {:space, size},
             padding_bottom: {:space, size}
           }
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms(),
          do:
            {step,
             [
               title: RecipePresets.text_block(step),
               description: RecipePresets.text_block(step),
               trigger: RecipePresets.text_block(step)
             ]}
    end

    defp text_content_p_rules(id) do
      name = Selector.class_name(id)
      content_p = "#{slot("content")} p"

      for step <- Axes.text_atoms() do
        Rule.new(".#{name}.#{name}--text-#{step} #{content_p}",
          decls: Map.to_list(RecipePresets.text_block(step))
        )
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r,
             [
               content: RecipePresets.rounded_block(r),
               close_trigger: RecipePresets.rounded_block(r)
             ]}
    end

    defp part(id, name), do: Selector.part(id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule Accordion do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @id :accordion
    @scope "accordion"
    @anatomy [
      trigger: [include: :ui_trigger, width: "100%", margin_bottom: "var(--space)"],
      indicator: [
        flex_shrink: "0",
        transform: "rotate(0deg)",
        transition: "transform 0.2s ease",
        rotate_when: [state: :open, deg: 90]
      ],
      icons: :accordion_toggle
    ]

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md],
        base: [host: %{}],
        variants: [
          semantic: semantic_variants(),
          variant: variant_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants(),
          height: RecipePresets.slot_axis_variants(RecipePresets.height_blocks(), :item_content),
          max_height:
            RecipePresets.slot_axis_variants(RecipePresets.max_height_blocks(), :item_content)
        ],
        default_variants: [variant: :subtle, size: :md, height: :auto, max_height: :none],
        axis_overrides: [
          %{match: %{width: :fit}, style: [host: %{max_width: :none}]},
          %{match: %{width: :auto}, style: [host: %{max_width: :none}]}
        ],
        extra_rules:
          expand_anatomy(@anatomy) ++
            base_rules() ++
            Palette.modifier_paint_open_closed_trigger_rules(@id, slot("item-trigger"),
              inherit: [slot("item-text")]
            ) ++
            content_p_variant_rules() ++
            horizontal_size_column_rules() ++
            width_fit_rules() ++
            max_height_scroll_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      item = part("item")
      item_trigger = part("item-trigger")
      item_text = part("item-text")
      item_content = part("item-content")

      [
        Rule.new(~s(#{host}[data-loading] #{slot("root")}), decls: [include: :ui_loading]),
        Rule.new(root, decls: [include: :ui_root]),
        Rule.new(~s(#{root}[data-orientation="horizontal"]),
          decls: [
            display: "grid",
            grid_template_rows: "auto 1fr",
            grid_auto_flow: "column",
            align_items: "stretch",
            max_width: "100%",
            overflow_x: "auto"
          ],
          children: RecipePresets.scrollbar_sm_children()
        ),
        Rule.new(item,
          decls: [display: "flex", flex_direction: "column", width: "100%", gap: "0"]
        ),
        Rule.new(~s(#{item}[data-orientation="horizontal"]), decls: [display: "contents"]),
        Rule.new(~s(#{item}[data-orientation="horizontal"] > h3),
          decls: [
            grid_row: "1",
            display: "flex",
            flex_direction: "column",
            min_height: "0",
            align_self: "stretch"
          ]
        ),
        Rule.new(
          ~s(#{item}[data-orientation="horizontal"] > h3 > #{slot("item-trigger")}),
          decls: [flex: "1 1 auto"]
        ),
        Rule.new(~s(#{item} h3), decls: [margin: "0", padding: "0"]),
        Rule.new(~s(#{item_trigger}[data-orientation="horizontal"]),
          decls: [
            box_sizing: "border-box",
            height: "100%",
            width: "100%",
            margin_bottom: "0",
            align_items: "center",
            justify_content: "center",
            text_align: "center"
          ]
        ),
        Rule.new(item_text,
          decls: [
            width: "100%",
            display: "flex",
            align_items: "center",
            gap: "var(--space)"
          ]
        ),
        Rule.new(~s(#{item_trigger}[data-orientation="horizontal"] #{slot("item-text")}),
          decls: [
            flex: "1 1 auto",
            min_width: "0",
            align_items: "center",
            text_align: "center",
            white_space: "normal"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "overflow-wrap: anywhere"}])
          ]
        ),
        Rule.new(item_content, decls: [overflow: "hidden"]),
        Rule.new(
          ~s(#{host}[data-animation="js"] #{slot("item-content")}[data-state="closed"],\n  #{host}[data-animation="custom"] #{slot("item-content")}[data-state="closed"]),
          decls: [height: "0", opacity: "0", overflow: "hidden"]
        ),
        Rule.new(~s(#{item_content}[data-orientation="horizontal"]),
          decls: [
            grid_row: "2",
            display: "flex",
            min_height: "0",
            min_width: "0",
            width: "100%"
          ]
        ),
        Rule.new(~s(#{item_content}[data-orientation="horizontal"] > p),
          decls: [{:raw, "overflow-wrap: break-word"}]
        ),
        Rule.new(~s(#{item_content} > p),
          decls: [include: :ui_content, margin: "0", margin_bottom: "var(--space)"]
        ),
        Rule.new(
          ~s(#{root}[data-async] #{slot("item-text")} > *,\n  #{root}[data-async] #{slot("item-indicator")} > *),
          decls: [animation: "corex-skeleton 1.4s ease-in-out infinite"]
        ),
        Rule.new(
          ~s(#{root}[data-async] #{slot("item-text")}::before,\n  #{root}[data-async] #{slot("item-text")}::after),
          decls: [
            content: ~S(""),
            display: "block",
            height: "var(--space)",
            background_color: "var(--color-ui-active)",
            border_radius: "var(--radius-md)"
          ]
        ),
        Rule.new(~s(#{root}[data-async] #{slot("item-text")}::before),
          decls: [width: "var(--container-2xs)", margin_block: "var(--space)"]
        )
      ]
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp variant_variants do
      for visual <- Axes.visual_atoms(), do: {visual, [host: %{}]}
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        {size,
         [
           item_trigger:
             Map.merge(RecipePresets.size_block(size), %{margin_bottom: {:space, size}}),
           item_text: %{gap: {:space, size}}
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, [item_trigger: RecipePresets.text_block(step)]}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [item_trigger: RecipePresets.rounded_block(r)]}
    end

    defp content_p_variant_rules do
      content_p = ~s(#{slot("item-content")} > p)
      name = Selector.class_name(@id)

      size_rules =
        for size <- Axes.size_atoms() do
          text = size_text(size)

          Rule.new("#{Palette.host_size_mod(@id, size)} #{content_p}",
            decls: [
              font_size: {:text, text},
              line_height: {:leading, text},
              padding: {:space, size},
              margin_bottom: {:space, size}
            ]
          )
        end

      text_rules =
        for step <- Axes.text_atoms() do
          Rule.new(".#{name}.#{name}--text-#{step} #{content_p}",
            decls: Map.to_list(RecipePresets.text_block(step))
          )
        end

      rounded_rules =
        for r <- Axes.radius_atoms() do
          Rule.new(".#{name}.#{name}--rounded-#{r} #{content_p}",
            decls: Map.to_list(RecipePresets.rounded_block(r))
          )
        end

      size_rules ++ text_rules ++ rounded_rules
    end

    defp horizontal_size_column_rules do
      root = slot("root")

      for {size, col} <- horizontal_column_mins() do
        Rule.new(
          "#{Palette.host_size_mod(@id, size)} #{root}[data-orientation=\"horizontal\"]",
          decls: [{:raw, "grid-auto-columns: minmax(var(--container-#{col}), 1fr)"}]
        )
      end
    end

    defp horizontal_column_mins do
      [sm: "2xs", md: "3xs", lg: "xs", xl: "sm"]
    end

    defp width_fit_rules do
      name = Selector.class_name(@id)
      root = slot("root")
      item = slot("item")
      item_trigger = slot("item-trigger")
      item_text = slot("item-text")
      content_p = ~s(#{slot("item-content")} > p)

      for width <- [:fit] do
        mod = ".#{name}.#{name}--w-#{width}"

        [
          Rule.new("#{mod} #{root}", decls: [width: "auto", align_items: "flex-start"]),
          Rule.new("#{mod} #{item}", decls: [width: "auto", align_self: "flex-start"]),
          Rule.new("#{mod} #{item_trigger}", decls: [width: "auto"]),
          Rule.new("#{mod} #{item_trigger}[data-orientation=\"horizontal\"]",
            decls: [width: "auto"]
          ),
          Rule.new("#{mod} #{item_text}", decls: [width: "auto"]),
          Rule.new("#{mod} #{content_p}", decls: [width: "auto"])
        ]
      end
      |> List.flatten()
    end

    defp max_height_scroll_rules do
      item_content = slot("item-content")
      name = Selector.class_name(@id)

      for step <- max_height_scroll_steps() do
        mod = ".#{name}.#{name}--max-h-#{step}"
        open = "#{mod} #{item_content}[data-state=\"open\"]"

        [
          Rule.new(open,
            decls: [
              display: "flex",
              flex_direction: "column",
              min_height: "0",
              overflow: "hidden"
            ]
          ),
          Rule.new("#{open} > p",
            decls: [
              overflow_y: "auto",
              min_height: "0",
              flex: "1 1 auto",
              box_sizing: "border-box"
            ],
            children:
              content_scrollbar_children() ++
                [Rule.new("&", decls: [{:raw, "overflow-wrap: break-word"}])]
          )
        ]
      end
      |> List.flatten()
    end

    defp max_height_scroll_steps do
      [:full | Enum.map(RecipePresets.max_height_blocks(), fn {step, _} -> step end)]
      |> Enum.reject(&(&1 == :none))
      |> Enum.uniq()
    end

    defp content_scrollbar_children do
      [
        Rule.new("&::-webkit-scrollbar",
          decls: [
            {:raw, "width: calc(var(--space-sm) * 0.6); height: calc(var(--space-sm) * 0.6)"}
          ]
        ),
        Rule.new("&::-webkit-scrollbar-track",
          decls: [background: {:color, :root}]
        ),
        Rule.new("&::-webkit-scrollbar-thumb",
          decls: [background: {:color, :border}]
        ),
        Rule.new("&::-webkit-scrollbar-corner",
          decls: [background: {:color, :root}]
        )
      ]
    end

    defp part(name), do: Selector.part(@id, @scope, name)
    defp slot(name), do: Selector.slot(@scope, name)

    defp expand_anatomy(anatomy) when is_list(anatomy) do
      Enum.flat_map(anatomy, &expand_anatomy_part/1)
    end

    defp expand_anatomy_part({:trigger, decls}) do
      [Rule.new(part("item-trigger"), decls: decls)]
    end

    defp expand_anatomy_part({:indicator, decls}) do
      {rotate, base_decls} = Keyword.pop(decls, :rotate_when)
      indicator = part("item-indicator")

      rotate_rules =
        case rotate do
          nil ->
            []

          rotate ->
            deg = Keyword.fetch!(rotate, :deg)
            state = Keyword.get(rotate, :state, :open)

            [
              Rule.new(~s(#{indicator}[data-state="#{state}"]),
                decls: [transform: "rotate(#{deg}deg)"]
              ),
              Rule.new(~s(#{indicator}[dir="rtl"][data-state="#{state}"]),
                decls: [transform: "rotate(-#{deg}deg)"]
              )
            ]
        end

      [Rule.new(indicator, decls: base_decls) | rotate_rules]
    end

    defp expand_anatomy_part({:icons, :accordion_toggle}) do
      item = part("item")
      indicator = slot("item-indicator")

      [
        Rule.new(~s(#{indicator} [data-icon]), decls: [include: :ui_icon]),
        Rule.new(
          ~s(#{item}[data-state="closed"] #{indicator} [data-icon-state="open"],\n  #{item}[data-state="open"] #{indicator} [data-icon-state="closed"]),
          decls: [include: :ui_icon, display: "none"]
        ),
        Rule.new(
          ~s(#{item}[data-state="open"] #{indicator} [data-icon-state="open"],\n  #{item}[data-state="closed"] #{indicator} [data-icon-state="closed"]),
          decls: [include: :ui_icon, display: "inline-block"]
        )
      ]
    end

    defp expand_anatomy_part(_entry), do: []

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule AngleSlider do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "angle-slider"
    @id :angle_slider

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :none, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          thumb: %{},
          marker_group: %{},
          marker: %{},
          value_text: %{},
          hidden_input: %{},
          error: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: angle_slider_rules() ++ semantic_angle_rules()
      )
    end

    defp angle_slider_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      root = Selector.part(id, scope, "root")
      label = Selector.part(id, scope, "label")
      control = Selector.part(id, scope, "control")
      thumb = Selector.part(id, scope, "thumb")
      marker_group = Selector.part(id, scope, "marker-group")
      marker = Selector.part(id, scope, "marker")
      value_text = Selector.part(id, scope, "value-text")
      value_part = ~s(#{value_text} [data-part="value"])
      text_part = ~s(#{value_text} [data-part="text"])
      hidden = Selector.part(id, scope, "hidden-input")
      error = Selector.part(id, scope, "error")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host,
            decls: [
              width: "100%",
              display: "flex",
              flex_direction: "column",
              max_width: {:raw, "var(--container-6xs)"},
              gap: {:space, :md}
            ],
            children: [
              Rule.new("&[data-orientation=\"horizontal\"]",
                decls: [max_width: {:container, :"3xs"}]
              )
            ]
          ),
          Rule.new(root,
            decls: [
              width: "100%",
              gap: {:space, :md},
              position: "relative",
              padding: {:space, :md}
            ],
            children: [
              Rule.new("&[data-orientation=\"horizontal\"]",
                decls: [
                  flex_direction: "row",
                  flex_wrap: "nowrap",
                  align_items: "end",
                  justify_content: "end"
                ]
              ),
              Rule.new("&[data-disabled]",
                decls: [color: {:color, :ui_ink_muted}, cursor: "not-allowed"]
              ),
              Rule.new("&[data-invalid] #{control}", decls: [border_color: {:color, :alert}]),
              Rule.new("&[data-invalid] #{text_part},\n  &[data-invalid] #{value_part}",
                decls: [color: {:color, :alert}]
              ),
              Rule.new("&[data-invalid] #{thumb}::before",
                decls: [background_color: {:color, :alert}]
              ),
              Rule.new("&[data-invalid] #{marker}[data-state=\"under-value\"]",
                decls: [{:"--marker-color", "var(--color-alert)"}]
              ),
              Rule.new("&[data-loading]",
                decls: [pointer_events: "none", min_height: {:raw, "var(--container-6xs)"}]
              )
            ]
          ),
          Rule.new("#{root}[data-orientation=\"horizontal\"] #{label}",
            decls: [flex_shrink: "0"]
          ),
          Rule.new("#{root}[data-orientation=\"horizontal\"] #{value_text}",
            decls: [
              width: "auto",
              flex: "0 0 auto",
              flex_shrink: "0",
              min_width: "calc(var(--angle-slider-value-ch, 6) * 1ch)"
            ]
          ),
          Rule.new("#{root}[data-orientation=\"horizontal\"] #{control}",
            decls: [flex_shrink: "0", margin_inline: "0"]
          ),
          Rule.new(label,
            children: [
              Rule.new("#{root}[data-disabled] &", decls: [color: {:color, :ui_ink_muted}])
            ]
          ),
          Rule.new(control,
            decls: [
              "--size": {:size, :lg},
              "--thumb-size": {:raw, "calc(var(--size-lg) * 0.5)"},
              "--thumb-indicator-size": {:raw, "min(var(--thumb-size), calc(var(--size) / 2))"},
              width: "var(--size)",
              height: "var(--size)",
              border_radius: {:radius, :full},
              border: {:raw, "1px solid var(--color-border)"},
              background_color: {:color, :ui},
              margin_inline: "auto",
              display: "flex",
              align_items: "center",
              justify_content: "center",
              user_select: "none",
              position: "relative",
              overflow: "hidden"
            ]
          ),
          Rule.new(thumb,
            decls: [
              position: "absolute",
              top: "0",
              bottom: "0",
              left: "50%",
              pointer_events: "none",
              width: "0",
              color: {:color, :ui_ink}
            ],
            children: [
              Rule.new("&",
                decls: [{:raw, "transform: translate(-50%, 0); transform-origin: center"}]
              ),
              Rule.new("&:focus-visible", decls: [outline: "none"]),
              Rule.new("&::before",
                decls: [
                  content: "\"\"",
                  position: "absolute",
                  top: "0",
                  left: "50%",
                  transform: "translate(-50%, 0)",
                  height: "var(--thumb-indicator-size)",
                  width: "max(3px, calc(var(--thumb-size) * 0.12))",
                  background_color: {:color, :ui_ink},
                  border_radius: {:radius, :md}
                ],
                children: [
                  Rule.new("#{root}[data-disabled] &",
                    decls: [background_color: {:color, :ui_ink_muted}]
                  ),
                  Rule.new("&:focus-visible",
                    decls: [outline: "none", box_shadow: "0 0 0 1px var(--color-ui-ink)"]
                  )
                ]
              )
            ]
          ),
          Rule.new(marker_group,
            decls: [
              position: "absolute",
              inset: "1px",
              border_radius: {:radius, :full},
              pointer_events: "none"
            ]
          ),
          Rule.new(marker,
            decls: [
              position: "absolute",
              top: "0",
              bottom: "0",
              left: "50%",
              width: "0"
            ],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "--marker-color: var(--color-ui-ink-muted); transform: translate(-50%, 0); transform-origin: center"}
                ]
              ),
              Rule.new("&::before",
                decls: [
                  content: "\"\"",
                  position: "absolute",
                  top: "calc(var(--thumb-size) / 4)",
                  left: "50%",
                  width: "1px",
                  height: "calc(var(--thumb-size) / 2)",
                  transform: "translate(-50%, -50%)",
                  background_color: "var(--marker-color)",
                  border_radius: "1px"
                ]
              ),
              Rule.new("&[data-state=\"under-value\"]",
                decls: [{:"--marker-color", "var(--color-ui-ink)"}],
                children: [
                  Rule.new("&::before", decls: [width: "3px"])
                ]
              ),
              Rule.new("&[data-state=\"at-value\"]", decls: [display: "none"]),
              Rule.new("&[data-state=\"over-value\"]",
                decls: [{:"--marker-color", "var(--color-ui-ink-muted)"}]
              )
            ]
          ),
          Rule.new(value_text,
            decls: [
              display: "flex",
              flex_direction: "row",
              flex_wrap: "nowrap",
              align_items: "center",
              justify_content: "center",
              gap: {:space, :md},
              width: "100%",
              flex: "1",
              text_align: "center"
            ],
            children: [
              Rule.new("&", decls: [{:raw, "--angle-slider-value-ch: 6"}])
            ]
          ),
          Rule.new("#{text_part},\n  #{value_part}",
            decls: [
              font_size: {:text, :base},
              line_height: {:leading, :base},
              font_weight: {:weight, :normal},
              color: {:color, :ui_ink}
            ],
            children: [
              Rule.new("&", decls: [{:raw, "font-variant-numeric: tabular-nums"}])
            ]
          ),
          Rule.new(value_part,
            decls: [
              display: "inline-block",
              min_width: "calc(var(--angle-slider-value-ch, 6) * 1ch)",
              text_align: "center"
            ],
            children: [
              Rule.new("#{root}[data-disabled] &", decls: [color: {:color, :ui_ink_muted}])
            ]
          ),
          Rule.new(hidden, decls: [display: "none"]),
          Rule.new(error,
            decls: [
              width: "100%",
              max_width: "100%",
              min_width: "0",
              display: "flex",
              flex_wrap: "wrap",
              box_sizing: "border-box"
            ]
          )
        ]
    end

    defp semantic_angle_rules do
      thumb = Selector.slot(@scope, "thumb")
      marker = Selector.slot(@scope, "marker")

      for role <- Palette.semantic_atoms() do
        host = Palette.host_mod(@id, role)
        ink = Palette.fg_var(role)
        solid = Palette.solid_var(role)

        [
          Rule.new("#{host} #{thumb}::before",
            decls: [background_color: "var(#{solid})"],
            children: [
              Rule.new("&:focus-visible",
                decls: [outline: "none", box_shadow: "0 0 0 1px var(#{ink})"]
              )
            ]
          ),
          Rule.new("#{host} #{marker}[data-state=\"under-value\"]",
            decls: [{:"--marker-color", "var(#{solid})"}]
          )
        ]
      end
      |> List.flatten()
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}, padding: {:space, size}},
           label: RecipePresets.text_block(text),
           control: %{
             font_size: {:text, text},
             line_height: {:leading, text},
             background_color: {:color, :ui},
             color: {:color, :ui_ink},
             border_color: {:color, :border},
             "--size": {:size, size},
             "--thumb-size": {:raw, "calc(var(--size-#{size}) * 0.5)"}
           }
         ]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [control: RecipePresets.rounded_block(r)]}
    end
  end

  defmodule Avatar do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "avatar"
    @id :avatar

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.inline_host_sizing(),
        base: [],
        variants: [
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: avatar_rules()
      )
    end

    defp avatar_rules do
      host = Selector.host(@id)
      root = part("root")
      fallback = part("fallback")
      image = part("image")
      skeleton = part("skeleton")

      [
        Rule.new("@keyframes avatar-skeleton-loading",
          children: [
            Rule.new("0%", decls: [{:raw, "background-position: 200% 0"}]),
            Rule.new("100%", decls: [{:raw, "background-position: -200% 0"}])
          ]
        ),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new("#{host}[dir=\"rtl\"] #{fallback}", decls: [text_align: "end"]),
        Rule.new(root,
          decls: [
            include: :ui_root,
            position: "relative",
            display: "inline-grid",
            align_items: "center",
            justify_items: "center",
            width: {:size, :md},
            height: {:size, :md},
            max_width: "100%",
            border_radius: {:radius, :md},
            overflow: "hidden"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}])
          ]
        ),
        Rule.new(fallback,
          decls: [
            display: "inline-flex",
            align_items: "center",
            justify_content: "center",
            text_align: "start",
            width: "100%",
            height: "100%",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            font_weight: {:weight, :normal},
            border_radius: "inherit",
            border: {:raw, "1px solid var(--color-border)"},
            gap: {:space, :md},
            color: {:color, :ui_ink},
            background_color: {:color, :ui}
          ]
        ),
        Rule.new(image,
          decls: [
            display: "block",
            width: "100%",
            height: "100%",
            border_radius: "inherit",
            position: "relative",
            z_index: "1"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "object-fit: cover"}])
          ]
        ),
        Rule.new(skeleton,
          decls: [
            position: "absolute",
            top: "0",
            right: "0",
            bottom: "0",
            left: "0",
            z_index: "2",
            display: "block",
            width: "100%",
            height: "100%",
            box_sizing: "border-box",
            border_radius: {:radius, :md},
            background:
              {:raw,
               "linear-gradient(90deg, var(--color-ui-muted) 0%, var(--color-border) 50%, var(--color-ui-muted) 100%)"},
            animation: "avatar-skeleton-loading 1.2s ease-in-out infinite"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "background-size: 200% 100%"}]),
            Rule.new("&[data-state=\"hidden\"]", decls: [display: "none"])
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{
             max_width: {:container, size},
             width: {:size, size},
             height: {:size, size}
           },
           fallback: RecipePresets.text_block(text)
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r, [root: RecipePresets.rounded_block(r), skeleton: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule Badge do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.HostIcon
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @id :badge
    @name Selector.class_name(@id)

    def recipe do
      Recipe.define(@id,
        host_sizing: RecipePresets.inline_host_sizing(),
        base: %{},
        variants: [
          semantic: Corex.Design.Recipes.semantic_host_variants(),
          size: size_variants(),
          shape: shape_variants()
        ],
        default_variants: [size: :md],
        extra_rules: badge_rules()
      )
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, badge_size_block(size)}
    end

    defp badge_size_block(size) do
      text = if size == :md, do: :base, else: size

      %{
        font_size: {:raw, "calc(var(--text-#{text}) * 0.8)"},
        line_height: {:raw, "var(--text-#{text}--line-height)"},
        height: {:raw, "calc(var(--spacing-size) * 0.8)"},
        padding_inline: {:space, :sm},
        gap: {:space, :sm}
      }
    end

    defp shape_variants do
      [auto: %{}, square: %{}]
    end

    defp badge_rules do
      host = Selector.host(@id)

      [
        Rule.new(host,
          decls: [
            display: "inline-flex",
            align_items: "center",
            justify_content: "center",
            text_align: "center",
            cursor: "unset",
            width: "fit-content",
            max_width: "100%",
            font_size: {:raw, "calc(var(--text-base) * 0.8)"},
            line_height: {:leading, :base},
            font_weight: {:weight, :normal},
            border_radius: {:radius, :full},
            border: {:raw, "1px solid var(--color-border)"},
            padding: {:space, :sm},
            gap: {:space, :sm},
            height: {:raw, "calc(var(--spacing-size) * 0.8)"},
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "normal",
            color: {:color, :ui_ink},
            background_color: {:color, :ui}
          ],
          children: [
            Rule.new(
              ~S(&:disabled,\n  &[data-disabled],\n  &[disabled]),
              decls: [
                color: {:color, :ui_ink_muted},
                background_color: {:color, :ui_muted},
                cursor: "not-allowed"
              ]
            )
          ]
        ),
        Rule.new(".#{@name}.#{@name}--shape-square",
          decls: [
            display: "inline-flex",
            aspect_ratio: "1 / 1",
            justify_content: "center",
            align_items: "center",
            width: "auto",
            padding: 0
          ]
        )
      ] ++ HostIcon.sized_host_icon_rules(@id)
    end
  end

  defmodule Button do
    @moduledoc false
    @behaviour Corex.Design.RecipeBehaviour

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.HostIcon

    @impl Corex.Design.RecipeBehaviour
    def recipe do
      Recipe.define(:button,
        host_sizing: RecipePresets.inline_host_sizing(),
        base: RecipePresets.trigger_base(),
        variants: [
          semantic: semantic_variants(),
          variant: variant_variants(),
          size: size_variants(),
          text: text_variants(),
          shape: HostIcon.shape_variants(),
          radius: radius_variants()
        ],
        default_variants: [variant: :solid, size: :md],
        axis_overrides: [
          %{
            match: [variant: :ghost, size: :sm],
            style: %{padding: {:space, :sm}, gap: {:space, :sm}}
          }
        ],
        extra_rules:
          Palette.modifier_paint_rules(:button) ++
            HostIcon.indicator_rules(:button) ++
            HostIcon.host_icon_rules(:button) ++
            HostIcon.square_icon_rules(:button)
      )
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, %{position: :relative}}
    end

    defp variant_variants do
      [
        solid: RecipePresets.visual_solid(),
        ghost: RecipePresets.visual_ghost(),
        outline: RecipePresets.visual_outline(),
        subtle: RecipePresets.visual_subtle()
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, RecipePresets.size_block(size)}
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, RecipePresets.text_block(step)}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, RecipePresets.rounded_block(r)}
    end
  end

  defmodule Carousel do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "carousel"
    @id :carousel

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :md],
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_trigger_rules() ++ semantic_indicator_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      control = part("control")
      prev = part("prev-trigger")
      next = part("next-trigger")
      autoplay = part("autoplay-trigger")
      item_group = part("item-group")
      item = part("item")
      indicator_group = part("indicator-group")
      indicator = part("indicator")

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(host,
          decls: [width: "100%", max_width: {:container, :md}, max_height: {:container, :md}]
        ),
        Rule.new(root,
          decls: [
            include: :ui_root,
            width: "100%",
            aspect_ratio: "4/3",
            overflow: "hidden",
            min_height: "0",
            gap: {:space, :md},
            justify_content: "center",
            position: "relative",
            border_radius: {:radius, :md}
          ]
        ),
        Rule.new(control,
          decls: [
            display: "flex",
            position: "absolute",
            flex_direction: "column",
            width: "auto",
            padding: {:space, :md},
            overflow: "hidden",
            gap: {:space, :md},
            justify_content: "center",
            border_radius: {:radius, :md}
          ],
          children: [
            Rule.new("&[data-orientation=\"horizontal\"]",
              decls: [flex_direction: "row", bottom: {:space, :md}]
            ),
            Rule.new("&[data-orientation=\"vertical\"]",
              decls: [flex_flow: "column nowrap", right: {:space, :md}]
            )
          ]
        ),
        Rule.new(prev,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            min_height: {:raw, "calc(var(--size-md) * 0.8)"},
            min_width: {:raw, "calc(var(--size-md) * 0.8)"},
            padding: "0"
          ],
          children: disabled_hidden_rules()
        ),
        Rule.new(next,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            min_height: {:raw, "calc(var(--size-md) * 0.8)"},
            min_width: {:raw, "calc(var(--size-md) * 0.8)"},
            padding: "0"
          ],
          children: disabled_hidden_rules()
        ),
        Rule.new(autoplay,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            min_height: {:size, :md},
            min_width: {:size, :md},
            padding: "0"
          ],
          children:
            disabled_hidden_rules() ++
              [
                Rule.new("&[data-pressed] [data-play]", decls: [display: "none"]),
                Rule.new("&:not([data-pressed]) [data-pause]", decls: [display: "none"])
              ]
        ),
        Rule.new(item_group,
          decls: [
            overflow: "hidden",
            align_self: "stretch",
            min_width: "0",
            min_height: "0",
            border_radius: {:radius, :md}
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw,
                 "scrollbar-width: none; -webkit-scrollbar-width: none; -ms-overflow-style: none"}
              ]
            ),
            Rule.new("&::-webkit-scrollbar", decls: [display: "none"])
          ]
        ),
        Rule.new(item,
          decls: [
            display: "flex",
            justify_content: "center",
            align_items: "center",
            min_width: "0",
            min_height: "0",
            align_self: "stretch"
          ],
          children: [
            Rule.new("& img",
              decls: [
                margin: "0",
                border_radius: {:radius, :md},
                height: "100%",
                width: "100%"
              ],
              children: [
                Rule.new("&", decls: [{:raw, "object-fit: cover"}])
              ]
            )
          ]
        ),
        Rule.new(indicator_group,
          decls: [
            display: "flex",
            flex_wrap: "wrap",
            justify_content: "center",
            align_items: "center",
            gap: {:space, :md}
          ],
          children: [
            Rule.new("&[data-orientation=\"horizontal\"]",
              decls: [flex_direction: "row", height: "auto"]
            ),
            Rule.new("&[data-orientation=\"vertical\"]",
              decls: [flex_direction: "column", height: "auto"]
            )
          ]
        ),
        Rule.new(indicator,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            border_radius: {:raw, "var(--radius-full) !important"},
            min_height: {:space, :md},
            min_width: {:space, :md},
            padding: "0"
          ],
          children: [
            Rule.new("&[data-current]", decls: [background_color: {:color, :selected}])
          ]
        )
      ]
    end

    defp disabled_hidden_rules do
      [
        Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
          decls: [visibility: "hidden"]
        )
      ]
    end

    defp semantic_trigger_rules do
      SemanticStates.solid_trigger_rules(@id, [
        part("next-trigger"),
        part("prev-trigger"),
        part("autoplay-trigger")
      ])
    end

    defp semantic_indicator_rules do
      SemanticStates.solid_part_rules(@id, "#{part("indicator")}[data-current]")
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           control: %{
             max_width: {:container, size},
             padding: {:space, size},
             gap: {:space, size}
           },
           prev_trigger: trigger_size_block(size, text, 0.8),
           next_trigger: trigger_size_block(size, text, 0.8),
           autoplay_trigger: trigger_size_block(size, text, 0.8),
           indicator: %{
             min_height: {:raw, "calc(var(--size-#{size}) * 0.25)"},
             min_width: {:raw, "calc(var(--size-#{size}) * 0.25)"}
           }
         ]}
      end
    end

    defp trigger_size_block(size, text, scale) do
      %{
        font_size: {:raw, "calc(var(--text-#{text}) * #{scale})"},
        line_height: {:raw, "calc(var(--text-#{text}--line-height) * #{scale})"},
        min_height: {:raw, "calc(var(--size-#{size}) * #{scale})"},
        min_width: {:raw, "calc(var(--size-#{size}) * #{scale})"}
      }
    end

    defp radius_variants do
      rounded_parts =
        [
          "root",
          "item-group",
          "item",
          "control",
          "prev-trigger",
          "next-trigger",
          "autoplay-trigger",
          "indicator"
        ]

      for r <- Axes.radius_atoms() do
        block = RecipePresets.rounded_block(r)

        {r,
         Enum.map(rounded_parts, fn part_name ->
           {String.to_atom(part_name), block}
         end)}
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule Checkbox do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "checkbox"
    @id :checkbox

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"4xl", height: :auto, max_height: :none],
        base: [host: %{}, root: %{}, label: %{}, control: %{}, indicator: %{}, error: %{}],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: checkbox_rules() ++ semantic_control_rules()
      )
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, [host: Palette.selected_host_sx(color)]}
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        block = %{
          "--size": {:size, size},
          height: {:raw, "calc(var(--size-#{size}) * 0.6)"},
          width: {:raw, "calc(var(--size-#{size}) * 0.6)"},
          font_size: {:text, size_text(size)},
          line_height: {:leading, size_text(size)}
        }

        {size, [control: block, label: RecipePresets.text_block(size_text(size))]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [control: RecipePresets.rounded_block(r)]}
    end

    defp semantic_control_rules do
      id = @id
      control = Selector.slot(@scope, "control")

      for color <- Axes.semantic_atoms() do
        c = Atom.to_string(color)
        host_mod = Palette.host_mod(id, color)

        checked =
          "#{host_mod} #{control}[data-state='checked'], #{host_mod} #{control}[data-state='indeterminate']"

        Rule.new(checked,
          decls: [
            background_color: {:raw, "var(--color-#{c})"},
            color: {:raw, "var(--color-#{c}-ink)"},
            border_color: {:raw, "var(--color-#{c})"}
          ],
          children: [
            Rule.new("&:hover", decls: [background_color: {:raw, "var(--color-#{c}-hover)"}]),
            Rule.new("&:active", decls: [background_color: {:raw, "var(--color-#{c}-active)"}]),
            Rule.new("&:focus-visible, &[data-focus]",
              decls: [
                outline: "none",
                box_shadow: {:raw, "inset 0 0 0 2px var(--color-#{c}-ink)"}
              ]
            )
          ]
        )
      end
    end

    defp checkbox_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      control = Selector.part(id, scope, "control")
      control_slot = Selector.slot(scope, "control")
      indicator = Selector.part(id, scope, "indicator")
      indicator_slot = Selector.slot(scope, "indicator")
      indeterminate = Selector.part(id, scope, "indeterminate")
      indeterminate_slot = Selector.slot(scope, "indeterminate")

      FormHost.host_rules(id, scope) ++
        FormHost.control_focus_rules(
          id,
          scope,
          ~S(&[data-state="checked"],\n  &[data-state="indeterminate"])
        ) ++
        [
          Rule.new(control,
            decls: [
              height: "calc(var(--size-md) * 0.6)",
              width: "calc(var(--size-md) * 0.6)",
              border_radius: "var(--radius-md)",
              font_size: "var(--text-base)",
              line_height: "var(--leading-base)"
            ]
          ),
          Rule.new(
            "#{indicator},\n  #{indeterminate}",
            decls: [
              display: "none",
              align_items: "center",
              justify_content: "center",
              width: "100%",
              height: "100%"
            ],
            children: [
              Rule.new("& [data-icon],\n  & svg,\n  & img",
                decls: [include: :ui_icon]
              )
            ]
          ),
          Rule.new(
            ~s(#{host} #{control_slot}[data-state="checked"] #{indicator_slot}),
            decls: [display: "flex"]
          ),
          Rule.new(
            ~s(#{host} #{control_slot}[data-state="indeterminate"] #{indeterminate_slot}),
            decls: [display: "flex"]
          ),
          Rule.new(
            "#{Selector.part(id, scope, "root")}[data-orientation=\"vertical\"]",
            decls: [flex_direction: "column-reverse"]
          )
        ]
    end
  end

  defmodule Clipboard do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "clipboard"
    @id :clipboard

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          size: size_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ copy_part_size_rules() ++ width_full_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      control = part("control")
      input = part("input")
      trigger = part("trigger")
      copy = ~s(#{trigger} #{Selector.slot(@scope, "copy")})
      copied = ~s(#{trigger} #{Selector.slot(@scope, "copied")})

      [
        Rule.new(~s(#{host}[data-loading] #{Selector.slot(@scope, "root")}),
          decls: [include: :ui_loading]
        ),
        Rule.new(root, decls: [include: :ui_root, gap: "var(--space)"]),
        Rule.new(~s(#{root}[data-orientation="horizontal"]), decls: [align_items: "center"]),
        Rule.new(~s(#{root}[data-orientation="vertical"]), decls: [align_items: "start"]),
        Rule.new(label, decls: [include: :ui_label]),
        Rule.new(control,
          decls: [
            display: "flex",
            flex_flow: "row wrap",
            justify_content: "start",
            gap: "var(--space-sm)"
          ]
        ),
        Rule.new(~s(#{control}[data-orientation="horizontal"]),
          decls: [flex_flow: "row nowrap", align_items: "center"]
        ),
        Rule.new(input,
          decls: [
            include: :ui_input,
            width: :auto,
            flex: "0 1 auto",
            max_width: {:container, :md}
          ]
        ),
        Rule.new(~s(#{input}[data-copied]),
          decls: [
            background_color: "var(--color-success)",
            color: "var(--color-success-ink)"
          ]
        ),
        Rule.new(trigger, decls: [include: :ui_trigger]),
        Rule.new(copy,
          decls: [
            display: "inline-flex",
            align_items: "center",
            gap: "var(--space)",
            pointer_events: "none"
          ]
        ),
        Rule.new(copied,
          decls: [
            display: "none",
            align_items: "center",
            gap: "var(--space)",
            pointer_events: "none"
          ]
        ),
        Rule.new(~s(#{trigger}[data-copied]),
          decls: [
            background_color: "var(--color-success)",
            color: "var(--color-success-ink)",
            outline: "none",
            box_shadow: "inset 0 0 0 2px var(--color-success-ink)"
          ]
        ),
        Rule.new(~s(#{trigger}[data-copied] #{Selector.slot(@scope, "copy")}),
          decls: [display: "none"]
        ),
        Rule.new(~s(#{trigger}[data-copied] #{Selector.slot(@scope, "copied")}),
          decls: [display: "inline-flex"]
        ),
        Rule.new(
          ~s(#{copy} [data-icon],\n  #{copied} [data-icon]),
          decls: [
            display: :inline_flex,
            align_items: :center,
            justify_content: :center,
            flex_shrink: {:raw, "0"},
            width: {:raw, "0.875em !important"},
            height: {:raw, "0.875em !important"}
          ]
        )
      ]
    end

    defp width_full_rules do
      name = Selector.class_name(@id)

      [
        Rule.new(
          ~s(.#{name}.#{name}--w-full #{Selector.slot(@scope, "root")}),
          decls: [width: "100%"]
        ),
        Rule.new(
          ~s(.#{name}.#{name}--w-full #{Selector.slot(@scope, "control")}),
          decls: [width: "100%"]
        ),
        Rule.new(
          ~s(.#{name}.#{name}--w-full #{Selector.slot(@scope, "input")}),
          decls: [flex: "1 1 auto", min_width: "0", max_width: :none]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           control: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           trigger: RecipePresets.size_block(size),
           input: %{min_height: {:size, size}}
         ]}
      end
    end

    defp copy_part_size_rules do
      copy = ~s(#{Selector.slot(@scope, "trigger")} #{Selector.slot(@scope, "copy")})
      copied = ~s(#{Selector.slot(@scope, "trigger")} #{Selector.slot(@scope, "copied")})

      for size <- Axes.size_atoms() do
        host = Palette.host_size_mod(@id, size)

        Rule.new("#{host} #{copy},\n  #{host} #{copied}",
          decls: [gap: {:space, size}]
        )
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule Code do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @id :code

    def recipe do
      Recipe.define(@id,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: %{},
        variants: [
          size: size_variants(),
          text: text_variants(),
          max_width: max_width_variants()
        ],
        default_variants: [text: :sm],
        extra_rules: code_rules()
      )
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, RecipePresets.size_block(size)}
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, RecipePresets.text_block(step)}
    end

    defp max_width_variants, do: RecipePresets.max_width_blocks()

    defp code_rules do
      host = Selector.host(@id)

      text_inherit_rules() ++
        [
          Rule.new("pre#{host}",
            decls: [
              {:raw,
               "background-image: linear-gradient(var(--color-root) 50%, var(--color-layer) 50%);"},
              {:raw, "background-size: 100% 2lh;"},
              {:raw, "background-origin: content-box;"},
              {:raw, "background-attachment: local;"},
              {:raw, "background-position: 0 0;"},
              width: "100%",
              font_family: {:font, :mono},
              padding: {:space, :md},
              background_color: {:color, :ui},
              color: {:color, :ui_ink},
              border: {:raw, "1px solid var(--color-border)"},
              overflow: :auto,
              min_width: 0,
              box_sizing: :border_box,
              white_space: :pre
            ],
            children: [
              Rule.new("& code[data-part=\"content\"]",
                decls: [
                  display: :block,
                  padding_inline_end: {:space, :xl},
                  white_space: :pre
                ]
              )
            ]
          ),
          Rule.new("code#{host}",
            decls: [
              {:raw, "box-decoration-break: clone;"},
              {:raw, "-webkit-box-decoration-break: clone;"},
              display: :inline_block,
              max_width: "100%",
              overflow: :visible,
              vertical_align: :baseline,
              font_family: {:font, :mono},
              padding_inline: {:space, :sm},
              padding_block: {:raw, "0.12em"},
              border: {:raw, "1px solid var(--color-border)"},
              border_radius: {:radius, :md},
              background_color: {:color, :layer},
              color: {:color, :ui_ink},
              user_select: :all
            ],
            children: [
              Rule.new("& > span[data-part=\"content\"]",
                decls: [{:raw, "overflow-wrap: break-word;"}, white_space: :pre_wrap]
              )
            ]
          ),
          Rule.new("pre#{host}.unselectable,\n  code#{host}.unselectable",
            decls: [
              {:raw, "-webkit-touch-callout: none"},
              {:raw, "-webkit-user-select: none"},
              {:raw, "-khtml-user-select: none"},
              {:raw, "-moz-user-select: none"},
              {:raw, "-ms-user-select: none"},
              user_select: :none
            ]
          )
        ] ++ syntax_rules()
    end

    defp text_inherit_rules do
      host = Selector.host(@id)
      name = Selector.class_name(@id)

      variant_inherit =
        for step <- Axes.text_atoms() do
          sel = ".#{name}.#{name}--text-#{step}"

          [
            Rule.new("#{sel}:is(pre) > code[data-part=\"content\"]",
              decls: [font_size: :inherit, line_height: :inherit]
            ),
            Rule.new("#{sel}:is(code#{host}) > span[data-part=\"content\"]",
              decls: [font_size: :inherit, line_height: :inherit]
            )
          ]
        end
        |> List.flatten()

      highlight_inherit = [
        Rule.new("pre#{host} code[data-part=\"content\"] span",
          decls: [font_size: :inherit, line_height: :inherit, white_space: :pre]
        ),
        Rule.new("pre#{host} code[data-part=\"content\"] span.w",
          decls: [white_space: :pre]
        ),
        Rule.new("code#{host} > span[data-part=\"content\"] span",
          decls: [font_size: :inherit, line_height: :inherit]
        )
      ]

      variant_inherit ++ highlight_inherit
    end

    defp syntax_rules do
      for {mode, specs} <- [light: light_syntax_specs(), dark: dark_syntax_specs()] do
        Enum.map(specs, fn {classes, decls} ->
          selector =
            classes
            |> List.wrap()
            |> Enum.map_join(", ", fn class ->
              ~s([data-mode="#{mode}"] #{Selector.host(@id)} .#{class})
            end)

          Rule.new(selector, decls: decls)
        end)
      end
      |> List.flatten()
    end

    defp light_syntax_specs do
      [
        {["hll"], [background_color: "#fff9c4"]},
        {["bp"], [color: "#0070c1"]},
        {~W(c c1 ch cm cs), [color: "#008000", font_style: :italic]},
        {~W(cp cpf), [color: "#0000ff", font_style: :normal]},
        {["dl"], [color: "#a31515"]},
        {["err"], [border_color: "#cd3131", color: "#cd3131"]},
        {["fm"], [color: "#795e26"]},
        {["gd"], [color: "#a31515"]},
        {["ge"], [font_style: :italic]},
        {["gh"], [color: "#000080", font_weight: "bold"]},
        {["gi"], [color: "#098658"]},
        {["go"], [color: "#6e7681"]},
        {["gp"], [color: "#000080", font_weight: "bold"]},
        {["gr"], [color: "#cd3131"]},
        {["gs"], [font_weight: "bold"]},
        {["gt"], [color: "#0451a5"]},
        {["gu"], [color: "#800080", font_weight: "bold"]},
        {["il"], [color: "#098658"]},
        {~W(k kd kr kc kn kp), [color: "#0000ff", font_weight: "bold"]},
        {["kt"], [color: "#267f99"]},
        {~W(m mb mf mh mi mo), [color: "#098658"]},
        {["na"], [color: "#e50000"]},
        {["nb"], [color: "#267f99"]},
        {~W(nc nn), [color: "#267f99", font_weight: "bold"]},
        {["nd"], [color: "#af00db"]},
        {["ne"], [color: "#cd3131", font_weight: "bold"]},
        {["nf"], [color: "#795e26"]},
        {["ni"], [color: "#6e7681", font_weight: "bold"]},
        {["nl"], [color: "#000000"]},
        {["no"], [color: "#0070c1"]},
        {["nt"], [color: "#800000", font_weight: "bold"]},
        {~W(nv vc vg vi vm), [color: "#001080"]},
        {["o"], [color: "#000000"]},
        {["ow"], [color: "#0000ff", font_weight: "bold"]},
        {~W(s s1 s2 sa sb sc sh sx), [color: "#a31515"]},
        {["sd"], [color: "#a31515", font_style: :italic]},
        {["se"], [color: "#ee0000", font_weight: "bold"]},
        {["si"], [color: "#811f3f", font_weight: "bold"]},
        {["sr"], [color: "#811f3f"]},
        {["ss"], [color: "#001080"]}
      ]
    end

    defp dark_syntax_specs do
      [
        {["hll"], [background_color: "#264f78"]},
        {["bp"], [color: "#4ec9b0"]},
        {~W(c c1 ch cm cs), [color: "#6a9955", font_style: :italic]},
        {~W(cp cpf), [color: "#569cd6", font_style: :normal]},
        {["dl"], [color: "#ce9178"]},
        {["err"], [border_color: "#f44747", color: "#f44747"]},
        {["fm"], [color: "#dcdcaa"]},
        {["gd"], [color: "#ce9178"]},
        {["ge"], [font_style: :italic]},
        {["gh"], [color: "#569cd6", font_weight: "bold"]},
        {["gi"], [color: "#b5cea8"]},
        {["go"], [color: "#808080"]},
        {["gp"], [color: "#569cd6", font_weight: "bold"]},
        {["gr"], [color: "#f44747"]},
        {["gs"], [font_weight: "bold"]},
        {["gt"], [color: "#4ec9b0"]},
        {["gu"], [color: "#c586c0", font_weight: "bold"]},
        {["il"], [color: "#b5cea8"]},
        {~W(k kd kr kc kn kp), [color: "#569cd6", font_weight: "bold"]},
        {["kt"], [color: "#4ec9b0"]},
        {~W(m mb mf mh mi mo), [color: "#b5cea8"]},
        {["na"], [color: "#9cdcfe"]},
        {["nb"], [color: "#4ec9b0"]},
        {~W(nc nn), [color: "#4ec9b0", font_weight: "bold"]},
        {["nd"], [color: "#c586c0"]},
        {["ne"], [color: "#f44747", font_weight: "bold"]},
        {["nf"], [color: "#dcdcaa"]},
        {["ni"], [color: "#808080", font_weight: "bold"]},
        {["nl"], [color: "#c8c8c8"]},
        {["no"], [color: "#4fc1ff"]},
        {["nt"], [color: "#569cd6", font_weight: "bold"]},
        {~W(nv vc vg vi vm), [color: "#9cdcfe"]},
        {["o"], [color: "#d4d4d4"]},
        {["ow"], [color: "#569cd6", font_weight: "bold"]},
        {~W(s s1 s2 sa sb sc sh sx), [color: "#ce9178"]},
        {["sd"], [color: "#ce9178", font_style: :italic]},
        {["se"], [color: "#d7ba7d", font_weight: "bold"]},
        {["si"], [color: "#d7ba7d", font_weight: "bold"]},
        {["sr"], [color: "#d16969"]},
        {["ss"], [color: "#9cdcfe"]}
      ]
    end
  end

  defmodule Collapsible do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "collapsible"
    @id :collapsible

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [host: %{}],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_open_trigger_rules() ++ keyframe_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      trigger = part("trigger")
      content = part("content")
      closed = part("closed")
      opened = part("opened")

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(host, decls: [width: "100%", max_width: {:container, :md}]),
        Rule.new(root, decls: [include: :ui_root]),
        Rule.new("#{root}[data-orientation=\"vertical\"]",
          decls: [flex_direction: "column", align_items: "stretch"]
        ),
        Rule.new("#{root}[data-orientation=\"horizontal\"]",
          decls: [flex_flow: "row nowrap", align_items: "flex-start"]
        ),
        Rule.new(trigger,
          decls: [
            include: :ui_trigger,
            justify_content: "space-between",
            max_width: {:raw, "var(--container-5xs)"},
            align_self: "flex-start",
            width: "auto",
            box_shadow: {:raw, "var(--shadow-ui)"}
          ],
          children: [
            Rule.new("& svg", decls: [include: :ui_icon]),
            Rule.new("&[data-state=\"closed\"]:has(#{opened}) #{opened}",
              decls: [display: "none"]
            ),
            Rule.new("&[data-state=\"open\"]:has(#{opened}) #{closed}", decls: [display: "none"])
          ]
        ),
        Rule.new("#{root}[data-orientation=\"horizontal\"] #{trigger}",
          decls: [flex_shrink: "0", max_width: "none"]
        ),
        Rule.new(closed,
          decls: [
            display: "inline-flex",
            transition: "transform 0.2s ease"
          ]
        ),
        Rule.new(
          ~s|#{root}[data-orientation="vertical"] #{trigger}[data-state="open"]:not(:has(#{opened})) #{closed}|,
          decls: [transform: "rotate(90deg)"]
        ),
        Rule.new(
          ~s|#{root}[data-orientation="vertical"] #{trigger}[dir="rtl"][data-state="open"]:not(:has(#{opened})) #{closed}|,
          decls: [transform: "rotate(-90deg)"]
        ),
        Rule.new(
          ~s|#{root}[data-orientation="horizontal"] #{trigger}[data-state="open"]:not(:has(#{opened})) #{closed}|,
          decls: [transform: "rotate(90deg)"]
        ),
        Rule.new(
          ~s|#{root}[data-orientation="horizontal"] #{trigger}[dir="rtl"][data-state="open"]:not(:has(#{opened})) #{closed}|,
          decls: [transform: "rotate(-90deg)"]
        ),
        Rule.new(~s(#{content}[data-orientation="vertical"][data-state="open"]),
          decls: [animation: "collapsible-slide-down 200ms ease"]
        ),
        Rule.new(~s(#{content}[data-orientation="vertical"][data-state="closed"]),
          decls: [animation: "collapsible-slide-up 200ms ease"]
        ),
        Rule.new(~s(#{content}[data-orientation="horizontal"][data-state="open"]),
          decls: [animation: "collapsible-slide-right 200ms ease"]
        ),
        Rule.new(~s(#{content}[data-orientation="horizontal"][data-state="closed"]),
          decls: [animation: "collapsible-slide-left 200ms ease"]
        ),
        Rule.new(content, decls: [include: :ui_content]),
        Rule.new("#{root}[data-orientation=\"horizontal\"] #{content}",
          decls: [flex: "1 1 auto", min_width: "0", width: "auto"]
        ),
        Rule.new("#{root}[data-loading],\n  #{root}[data-loading]",
          decls: [
            include: :ui_loading,
            min_height: {:size, :md},
            min_width: {:raw, "var(--container-7xs)"}
          ]
        ),
        Rule.new(
          "#{root}[data-loading] #{trigger},\n  #{root}[data-loading] #{trigger}",
          decls: [
            border_color: {:color, :border},
            background_color: {:color, :ui_active},
            animation: "corex-skeleton 1.4s ease-in-out infinite",
            width: "100%"
          ]
        )
      ]
    end

    defp semantic_open_trigger_rules do
      trigger = part("trigger")
      closed = part("closed")
      opened = part("opened")
      content = part("content")
      content_p = "#{content} > p"

      base_ui =
        for size <- Axes.size_atoms() do
          text = size_text(size)
          host = Palette.host_size_mod(@id, size)

          [
            Rule.new("#{host} #{trigger}",
              decls: Map.to_list(RecipePresets.text_block(text))
            ),
            Rule.new("#{host} #{closed},\n  #{host} #{opened}",
              decls: Map.to_list(RecipePresets.text_block(text))
            ),
            Rule.new("#{host} #{content},\n  #{host} #{content_p}",
              decls: Map.to_list(RecipePresets.text_block(text))
            )
          ]
        end
        |> List.flatten()

      base_ui ++
        Palette.neutral_open_closed_trigger_rules(@id, trigger) ++
        SemanticStates.open_closed_trigger_rules(@id, trigger)
    end

    defp keyframe_rules do
      [
        Rule.new("@keyframes collapsible-slide-down",
          children: [
            Rule.new("from", decls: [opacity: "0.01", height: "0"]),
            Rule.new("to", decls: [opacity: "1", height: "var(--height)"])
          ]
        ),
        Rule.new("@keyframes collapsible-slide-up",
          children: [
            Rule.new("from", decls: [opacity: "1", height: "var(--height)"]),
            Rule.new("to", decls: [opacity: "0.01", height: "0"])
          ]
        ),
        Rule.new("@keyframes collapsible-slide-right",
          children: [
            Rule.new("from", decls: [opacity: "0.01", width: "0"]),
            Rule.new("to", decls: [opacity: "1", width: "var(--width)"])
          ]
        ),
        Rule.new("@keyframes collapsible-slide-left",
          children: [
            Rule.new("from", decls: [opacity: "1", width: "var(--width)"]),
            Rule.new("to", decls: [opacity: "0.01", width: "0"])
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms(),
          do: {size, [root: %{gap: {:space, size}, max_width: {:container, size}}]}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule ColorPicker do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "color-picker"
    @id :color_picker

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :fit, max_width: :none, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          trigger: %{},
          channel_input: %{},
          content: %{},
          area: %{},
          error: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: color_picker_rules() ++ semantic_color_picker_rules()
      )
    end

    defp color_picker_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      root = Selector.part(id, scope, "root")
      _label = Selector.part(id, scope, "label")
      control = Selector.part(id, scope, "control")
      trigger = Selector.part(id, scope, "trigger")
      swatch = Selector.slot(scope, "swatch")
      grid = Selector.slot(scope, "transparency-grid")
      channel_input = Selector.part(id, scope, "channel-input")
      positioner = ~s(#{host} [data-part="positioner"])
      content = Selector.part(id, scope, "content")
      area = Selector.part(id, scope, "area")
      area_bg = Selector.part(id, scope, "area-background")
      area_thumb = Selector.part(id, scope, "area-thumb")
      slider = Selector.part(id, scope, "channel-slider")
      slider_track = Selector.part(id, scope, "channel-slider-track")
      slider_thumb = Selector.part(id, scope, "channel-slider-thumb")
      eye_dropper = Selector.part(id, scope, "eye-dropper-trigger")
      swatch_trigger = Selector.part(id, scope, "swatch-trigger")
      error = Selector.part(id, scope, "error")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host, decls: [width: "fit-content", max_width: "fit-content"]),
          Rule.new(root,
            decls: [
              width: "fit-content",
              max_width: "fit-content",
              gap: {:space, :md},
              position: "relative",
              padding_inline_end: {:space, :md}
            ]
          ),
          Rule.new(control,
            decls: [
              display: "flex",
              flex_flow: "row wrap",
              align_items: "center",
              width: "fit-content",
              max_width: "fit-content",
              padding: {:space, :md},
              overflow: "hidden",
              gap: {:space, :md},
              justify_content: "flex-start",
              border_radius: {:radius, :md}
            ]
          ),
          Rule.new(trigger,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              min_width: {:size, :md},
              padding: "0",
              aspect_ratio: "1 / 1",
              width: "auto",
              position: "relative",
              overflow: "hidden",
              border_radius: {:radius, :md},
              background_color: "transparent"
            ],
            children: [
              Rule.new(" #{swatch}",
                decls: [width: "100%", height: "100%", display: "block", border_radius: "inherit"]
              ),
              Rule.new(" #{grid}",
                decls: [width: "100%", height: "100%", min_height: "0", border_radius: "inherit"]
              )
            ]
          ),
          Rule.new(channel_input,
            decls: [
              include: :ui_input,
              text_align: "center",
              justify_content: "center"
            ],
            children: [
              Rule.new("&::-webkit-outer-spin-button,\n  &::-webkit-inner-spin-button",
                decls: [{:raw, "-webkit-appearance: none; margin: 0"}]
              ),
              Rule.new("&[type=\"number\"]",
                decls: [{:raw, "-moz-appearance: textfield; appearance: textfield"}]
              )
            ]
          ),
          Rule.new("#{control} #{channel_input}[data-channel=\"hex\"]",
            decls: [width: {:raw, "calc(var(--size-md) * 2.5)"}, flex: "0 0 auto"]
          ),
          Rule.new("#{control} #{channel_input}[data-channel=\"alpha\"]",
            decls: [
              width: {:raw, "calc(var(--size-md) * 1.35)"},
              flex: "0 0 auto",
              padding: "0",
              padding_inline: {:raw, "calc(var(--space-md) * 0.5)"}
            ]
          ),
          Rule.new(positioner,
            decls: [display: "none", width: "max-content", max_width: "max-content"]
          ),
          Rule.new(~s|#{positioner}:has([data-part="content"][data-state="open"])|,
            decls: [display: "block"]
          ),
          Rule.new(content,
            decls: [
              include: :ui_content,
              flex_direction: "column",
              z_index: "30",
              padding: "0",
              width: "max-content",
              min_width: {:container, :"4xs"},
              max_width: {:container, :"4xs"},
              gap: {:raw, "calc(var(--space-sm) * 0.5)"},
              box_sizing: "border-box",
              overflow_x: "hidden",
              overflow_y: "auto"
            ]
          ),
          Rule.new(area,
            decls: [
              include: :ui_trigger,
              position: "relative",
              padding: "0",
              min_height: "0",
              width: "100%",
              max_width: "100%",
              aspect_ratio: "4 / 3",
              height: "auto",
              align_self: "center"
            ]
          ),
          Rule.new(area_bg,
            decls: [position: "absolute", inset: "0", width: "100%", height: "100%"]
          ),
          Rule.new(area_thumb,
            decls: [
              border: {:raw, "calc(var(--space-md) / 8) solid var(--color-ui-ink)"},
              border_radius: {:radius, :full},
              box_sizing: "border-box",
              transform: "translate(-50%, -50%)",
              outline: "none",
              box_shadow: {:raw, "inset 0 0 0 var(--space-md) var(--color-root)"},
              width: {:raw, "calc(var(--size-md) * 0.4)"},
              height: {:raw, "calc(var(--size-md) * 0.4)"}
            ]
          ),
          Rule.new(slider,
            decls: [
              height: {:raw, "calc(var(--size-md) * 0.375)"},
              width: "100%",
              min_width: "0",
              border_radius: {:radius, :md},
              box_sizing: "border-box"
            ]
          ),
          Rule.new(slider_track,
            decls: [height: "100%", width: "100%", border_radius: {:radius, :md}]
          ),
          Rule.new(slider_thumb,
            decls: [
              border: {:raw, "calc(var(--space-md) / 8) solid var(--color-ui-ink)"},
              border_radius: {:radius, :full},
              box_sizing: "border-box",
              transform: "translate(-50%, -50%)",
              outline: "none",
              box_shadow: {:raw, "inset 0 0 0 var(--space-md) var(--color-root)"},
              width: {:raw, "calc(var(--size-md) * 0.4)"},
              height: {:raw, "calc(var(--size-md) * 0.4)"}
            ]
          ),
          Rule.new(eye_dropper,
            decls: [include: :ui_trigger] ++ RecipePresets.trigger_part_square()
          ),
          Rule.new(swatch_trigger,
            decls: [
              include: :ui_trigger,
              min_height: {:raw, "calc(var(--size-md) * 0.4)"},
              padding: "0",
              aspect_ratio: "1 / 1",
              width: "auto",
              position: "relative",
              overflow: "hidden",
              border_radius: {:radius, :md},
              background_color: "transparent"
            ]
          ),
          Rule.new("#{error}.absolute", decls: [padding_block: "0", display: "block"])
        ]
    end

    defp semantic_color_picker_rules do
      Palette.semantic_focus_rules(@id, Selector.slot(@scope, "trigger")) ++
        SemanticStates.active_part_rules(
          @id,
          Selector.slot(@scope, "swatch-trigger"),
          "[data-selected]"
        )
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           control: %{
             padding: {:space, size},
             gap: {:space, size},
             width: "fit-content",
             max_width: "fit-content"
           },
           trigger: %{
             min_width: {:size, size},
             min_height: {:size, size},
             max_height: {:size, size},
             overflow: "hidden",
             border_radius: {:radius, :md}
           },
           channel_input: %{
             font_size: {:text, text},
             line_height: {:leading, text},
             min_height: {:size, size},
             max_height: {:size, size},
             color: {:color, :ui_ink},
             border_color: {:raw, "var(--color-border)"}
           },
           content: %{
             min_width:
               {:raw, "calc(var(--container-4xs) * var(--size-#{size}) / var(--size-md))"},
             max_width:
               {:raw, "calc(var(--container-4xs) * var(--size-#{size}) / var(--size-md))"},
             gap: {:space, size}
           },
           area_thumb: %{
             width: {:raw, "calc(var(--size-#{size}) * 0.4)"},
             height: {:raw, "calc(var(--size-#{size}) * 0.4)"},
             border: {:raw, "calc(var(--space-#{size}) / 8) solid var(--color-ui-ink)"},
             box_shadow: {:raw, "inset 0 0 0 var(--space-#{size}) var(--color-root)"}
           }
         ]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for radius <- Axes.radius_atoms(),
          do:
            {radius,
             [
               trigger: RecipePresets.rounded_block(radius),
               control: RecipePresets.rounded_block(radius)
             ]}
    end
  end

  defmodule Combobox do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "combobox"
    @id :combobox

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"3xs", height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_item_rules() ++ highlight_rules()
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp semantic_item_rules do
      SemanticStates.active_part_rules(
        @id,
        slot("item"),
        ["[data-selected]", "[data-state='checked']"],
        highlighted: true
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      empty = part("empty")
      control = part("control")
      input = part("input")
      trigger = part("trigger")
      clear_trigger = part("clear-trigger")
      positioner = part("positioner")
      content = part("content")
      item_group = part("item-group")
      list = part("list")
      item_group_label = part("item-group-label")
      item = part("item")
      error = part("error")

      [
        Rule.new(host,
          decls: [width: "100%", max_width: {:container, :"3xs"}],
          children: [
            Rule.new("&[data-orientation='horizontal']",
              decls: [max_width: {:container, :md}]
            )
          ]
        ),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(root,
          decls: [
            include: :ui_root,
            gap: {:space, :md},
            width: "100%",
            position: "relative",
            padding_inline_end: {:space, :md}
          ]
        ),
        Rule.new(label, decls: [include: :ui_label]),
        Rule.new(empty,
          decls: [
            include: :ui_label,
            list_style: "none",
            padding_inline: {:space, :md},
            padding_block: {:space, :md}
          ]
        ),
        Rule.new(control, decls: [display: "flex", position: "relative"]),
        Rule.new(input,
          decls: [
            include: :ui_input,
            flex: "1",
            padding_inline: {:space, :md}
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw,
                 "border-inline-end: none; border-end-end-radius: 0; border-start-end-radius: 0"}
              ]
            ),
            Rule.new("&::placeholder", decls: [color: {:color, :ui_ink}])
          ]
        ),
        Rule.new("#{input}[data-invalid]",
          children: [
            Rule.new("&", decls: [{:raw, "border-inline-end-color: var(--color-alert)"}])
          ]
        ),
        Rule.new(
          "#{input}[data-invalid] ~ #{clear_trigger},\n  #{input}[data-invalid] ~ #{trigger}",
          decls: [border_color: {:color, :alert}, box_shadow: "none"]
        ),
        Rule.new(trigger,
          decls: [
            include: :ui_trigger,
            flex_shrink: "0",
            padding: "0"
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw,
                 "border-inline-start: none; border-start-start-radius: 0; border-end-start-radius: 0; aspect-ratio: 1 / 1"}
              ]
            )
          ]
        ),
        Rule.new(clear_trigger,
          decls: [
            include: :ui_trigger,
            border_radius: "0",
            flex_shrink: "0",
            padding: "0"
          ],
          children: [
            Rule.new("&",
              decls: [{:raw, "border-inline: none; aspect-ratio: 1 / 1"}]
            )
          ]
        ),
        Rule.new(positioner, decls: [position: "relative", z_index: "50"]),
        Rule.new(content,
          decls: [
            include: :ui_content,
            z_index: "50",
            max_height: {:raw, "calc(var(--spacing) * 96)"},
            overflow: "auto",
            padding: "0",
            box_shadow: {:raw, "var(--shadow-ui)"}
          ],
          children: RecipePresets.scrollbar_sm_children()
        ),
        Rule.new(item_group,
          decls: [display: "flex", flex_direction: "column", min_height: "fit-content"]
        ),
        Rule.new(list,
          decls: [min_height: "fit-content", display: "flex", flex_direction: "column"]
        ),
        Rule.new(item_group_label,
          decls: [
            display: "flex",
            align_items: "center",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            text_align: "start",
            padding_inline: {:space, :md},
            min_height: {:size, :md},
            background_color: {:color, :root},
            color: {:color, :ui_ink},
            border_bottom: {:raw, "1px solid var(--color-border)"}
          ]
        ),
        Rule.new(item, decls: [include: :ui_item]),
        Rule.new("#{content} #{slot("item-text")}",
          decls: Map.to_list(RecipePresets.item_row_text())
        ),
        Rule.new("#{content} #{slot("item-indicator")}",
          decls: Map.to_list(RecipePresets.item_row_indicator()) ++ [include: :ui_icon]
        ),
        Rule.new("#{content} #{slot("item-indicator")}[hidden]",
          decls: Map.to_list(RecipePresets.item_row_indicator_hidden())
        ),
        Rule.new(error, decls: [include: :ui_error]),
        Rule.new("#{error}.absolute", decls: [padding_block: "0", display: "block"]),
        Rule.new("#{root}[data-readonly]", decls: [include: :ui_readonly])
      ]
    end

    defp highlight_rules do
      item = part("item")

      [
        Rule.new("#{item}[data-highlighted]:not(:hover)",
          decls: [
            outline: "none",
            box_shadow: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"},
            background_color: {:color, :ui_hover},
            color: {:color, :ui_ink}
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = if(size == :md, do: :base, else: size)
        block = RecipePresets.text_block(text)

        {size,
         [
           root: %{gap: {:space, size}},
           label: block,
           input:
             Map.merge(block, %{
               color: {:color, :ui_ink},
               border_color: {:color, :border}
             }),
           trigger:
             Map.merge(block, %{
               color: {:color, :ui_ink},
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           clear_trigger:
             Map.merge(block, %{
               color: {:color, :ui_ink},
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           item_group_label: %{min_height: {:size, size}, color: {:color, :ui_ink}},
           item: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r,
             [content: RecipePresets.rounded_block(r), trigger: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule DataList do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "data-list"
    @id :data_list

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          size: size_variants()
        ],
        default_variants: [size: :md],
        extra_rules: data_list_rules()
      )
    end

    defp data_list_rules do
      host = Selector.host(@id)
      root = part("root")
      item = part("item")
      label = part("label")
      content = part("content")
      empty = part("empty")

      [
        Rule.new(host,
          decls: [
            include: :ui_root,
            width: "100%",
            max_width: {:container, :md},
            overflow: "hidden",
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            background_color: {:color, :border},
            color: {:color, :ui_ink}
          ]
        ),
        Rule.new(root,
          decls: [
            display: "flex",
            flex_direction: "column",
            width: "100%",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            background_color: {:color, :border},
            color: {:color, :ui_ink},
            border_radius: {:radius, :md},
            overflow: "auto",
            gap: "1px"
          ],
          children: RecipePresets.scrollbar_sm_children()
        ),
        Rule.new("#{host}:has(#{root} #{item}) #{empty}", decls: [display: "none"]),
        Rule.new(empty,
          decls: [
            padding: {:space, :md},
            background_color: {:color, :layer},
            color: {:color, :ui_ink_muted}
          ]
        ),
        Rule.new(item,
          decls: [
            padding: {:space, :md},
            display: "flex",
            flex_direction: "column",
            align_items: "flex-start",
            justify_content: "flex-start",
            transition: "background-color 0.2s ease-in-out",
            gap: {:space, :md},
            background_color: {:color, :layer},
            color: {:color, :ui_ink}
          ]
        ),
        Rule.new("#{root}[data-orientation=\"horizontal\"] #{item}",
          decls: [
            flex_direction: "row",
            align_items: "baseline",
            gap: {:space, :lg}
          ]
        ),
        Rule.new(label,
          decls: [
            include: :ui_label,
            flex_shrink: "0",
            gap: {:space, :md},
            width: "100%"
          ],
          children: [
            Rule.new("& [data-icon]", decls: [include: :ui_icon])
          ]
        ),
        Rule.new("#{root}[data-orientation=\"horizontal\"] #{label}",
          decls: [
            width: "auto",
            min_width: {:container, :"3xs"},
            max_width: "40%"
          ]
        ),
        Rule.new(content,
          decls: [
            font_size: {:text, :base},
            line_height: {:leading, :base},
            margin: "0",
            min_width: "0",
            flex: "1 1 auto"
          ]
        ),
        Rule.new("#{root}[data-orientation=\"horizontal\"] #{content}",
          decls: [flex: "1 1 auto"]
        ),
        Rule.new("#{root}[dir=\"rtl\"] #{item}", decls: [align_items: "flex-start"]),
        Rule.new(~s(#{root}[dir="rtl"][data-orientation="horizontal"] #{item}),
          decls: [
            align_items: "baseline",
            justify_content: "flex-start",
            gap: {:space, :lg}
          ]
        ),
        Rule.new("#{root}[dir=\"rtl\"] #{label}",
          decls: [
            justify_content: "flex-start",
            text_align: "start",
            width: "100%"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "unicode-bidi: plaintext"}])
          ]
        ),
        Rule.new("#{root}[dir=\"rtl\"] #{content}",
          decls: [
            text_align: "end",
            width: "100%",
            align_self: "stretch"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "unicode-bidi: plaintext"}])
          ]
        ),
        Rule.new(~s(#{root}[dir="rtl"][data-orientation="horizontal"] #{label}),
          decls: [
            width: "auto",
            justify_content: "flex-start",
            text_align: "start"
          ]
        ),
        Rule.new(~s(#{root}[dir="rtl"][data-orientation="horizontal"] #{content}),
          decls: [
            width: "auto",
            text_align: "start",
            align_self: "auto"
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           item: %{padding: {:space, size}},
           label: Map.merge(RecipePresets.text_block(text), %{color: {:color, :ui_ink}}),
           content: RecipePresets.text_block(text)
         ]}
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule DataTable do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "data-table"
    @id :data_table

    def recipe do
      Recipe.define(@id,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :md],
        base: %{
          display: :block,
          position: :relative,
          min_width: 0,
          overflow_x: :auto,
          overflow_y: :auto,
          border_radius: {:radius, :md},
          border: {:raw, "1px solid var(--color-border)"}
        },
        variants: [
          size: for(size <- Axes.size_atoms(), do: {size, %{}}),
          semantic: for(color <- Axes.semantic_atoms(), do: {color, %{}}),
          radius: for(r <- Axes.radius_atoms(), do: {r, %{border_radius: {:radius, r}}})
        ],
        default_variants: [],
        extra_rules: data_table_rules()
      )
    end

    defp data_table_rules do
      host = Selector.host(@id)
      root = part("root")
      thead = part("thead")
      tbody = part("tbody")
      sort_trigger = part("sort-trigger")

      size_rules() ++
        semantic_rules() ++
        [
          Rule.new(root,
            decls: [
              {:raw, "table-layout: auto;"},
              {:raw, "border-collapse: separate;"},
              {:raw, "border-spacing: 0;"},
              display: :table,
              width: "100%"
            ]
          ),
          Rule.new(
            ~s(#{host} col[data-part="col-selection"],\n  #{host} col[data-part="col-action"]),
            decls: [width: 0]
          ),
          Rule.new("#{host} col[data-part=\"col-grow\"]", decls: [width: "100%"]),
          Rule.new(thead,
            decls: [position: :sticky, top: 0, z_index: 2]
          ),
          Rule.new(
            ~s(#{thead} th[data-part="cell"],\n  #{thead} th[data-part="grow-cell"]),
            decls: header_cell_base()
          ),
          Rule.new("#{thead} th[data-part=\"cell\"]",
            decls: [width: 0, min_width: {:raw, "max-content"}]
          ),
          Rule.new("#{thead} th[data-part=\"grow-cell\"]", decls: [width: "100%"]),
          Rule.new(part("selection-header"), decls: header_cell_base()),
          Rule.new("#{thead} th[data-part=\"action-header\"]", decls: action_header_decls()),
          Rule.new(
            ~s|#{host}:has(\n    [data-scope="dialog"][data-part="backdrop"][data-state="open"]\n  )|,
            children: [
              Rule.new(
                "#{thead},\n    #{thead} th[data-part=\"action-header\"],\n    #{part("action-cell")}",
                decls: [z_index: 0]
              ),
              Rule.new(
                ~s|#{part("action-cell")}:has(\n      [data-scope="dialog"][data-part="backdrop"][data-state="open"]\n    )|,
                decls: [z_index: 1]
              )
            ]
          ),
          Rule.new(
            "#{thead} th:not(:last-child),\n  #{tbody} tr[data-part=\"row\"] td:not(:last-child)",
            decls: [{:raw, "border-inline-end: 1px solid var(--color-border);"}]
          ),
          Rule.new(
            "#{part("selection-header")},\n  #{part("selection-cell")}",
            decls: [width: 0, min_width: {:raw, "max-content"}, white_space: :nowrap]
          ),
          Rule.new(part("action-cell"), decls: action_cell_decls()),
          Rule.new(part("sort-header"),
            decls: [
              display: :flex,
              align_items: :center,
              gap: {:space, :md},
              width: "100%"
            ]
          ),
          Rule.new(part("sort-icon-container"),
            decls: [
              display: :flex,
              align_items: :center,
              justify_content: :center,
              flex_shrink: 0
            ]
          ),
          Rule.new(sort_trigger,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              border_radius: {:raw, "var(--radius-full) !important"},
              min_height: {:size, :sm},
              font_size: {:text, :sm},
              line_height: {:leading, :sm},
              padding_inline: {:space, :sm}
            ]
          ),
          Rule.new(part("sort-text"), decls: [flex: 1, text_align: :start]),
          Rule.new("#{tbody} tr[data-part=\"empty-row\"]:not(:only-child)",
            decls: [display: :none]
          ),
          Rule.new(part("empty"), decls: [padding: {:space, :md}]),
          Rule.new("#{tbody} tr",
            decls: [{:raw, "border-bottom: 1px solid var(--color-border);"}]
          ),
          Rule.new("#{tbody} tr:last-child", decls: [{:raw, "border-bottom: none;"}]),
          Rule.new(
            "#{part("cell")},\n  #{part("grow-cell")},\n  #{part("action-cell")},\n  #{part("selection-cell")}",
            decls: body_cell_base()
          ),
          Rule.new(part("cell"), decls: [width: 0, min_width: {:raw, "max-content"}]),
          Rule.new(part("grow-cell"), decls: [width: "100%"]),
          Rule.new(
            "#{part("selection-cell")},\n  #{part("action-cell")}",
            decls: [text_align: :center]
          ),
          Rule.new(
            "#{part("selection-cell")} .checkbox,\n  #{part("selection-header")} .checkbox",
            decls: [margin_inline: :auto]
          ),
          Rule.new(
            ~s|#{tbody} tr[data-part="row"]:hover #{part("cell")},\n  #{tbody} tr[data-part="row"]:hover #{part("grow-cell")},\n  #{tbody} tr[data-part="row"]:hover #{part("selection-cell")}|,
            decls: [background_color: {:color, :ui_hover}]
          ),
          Rule.new(
            "#{tbody} tr[data-part=\"row\"]:hover #{part("action-cell")}",
            decls: [background_color: {:color, :layer}]
          ),
          Rule.new(part("actions"),
            decls: [
              display: :inline_flex,
              align_items: :center,
              justify_content: :center,
              width: {:raw, "max-content"},
              max_width: "100%",
              gap: {:space, :md},
              margin_inline: :auto
            ]
          )
        ] ++ rtl_rules(host)
    end

    defp part(name) do
      Selector.part(@id, @scope, name)
    end

    defp header_cell_base do
      [
        text_align: :start,
        padding_inline: {:space, :md},
        white_space: :nowrap,
        background_color: {:color, :layer},
        border_bottom: {:raw, "1px solid var(--color-border)"},
        font_weight: {:weight, :medium},
        font_size: {:text, :base},
        line_height: {:leading, :base}
      ]
    end

    defp action_header_decls do
      [
        position: :sticky,
        inset_inline_end: 0,
        top: 0,
        z_index: 3,
        text_align: :center,
        padding: {:space, :md},
        white_space: :nowrap,
        width: 0,
        min_width: {:raw, "max-content"},
        max_width: {:raw, "max-content"},
        background_color: {:color, :layer},
        border_bottom: {:raw, "1px solid var(--color-border)"},
        border_inline_start: {:raw, "1px solid var(--color-border)"},
        font_weight: {:weight, :medium},
        box_shadow: action_shadow(:ltr)
      ]
    end

    defp action_cell_decls do
      [
        position: :sticky,
        inset_inline_end: 0,
        z_index: 1,
        width: 0,
        min_width: {:raw, "max-content"},
        max_width: {:raw, "max-content"},
        padding: {:space, :md},
        white_space: :nowrap,
        border_inline_start: {:raw, "1px solid var(--color-border)"},
        box_shadow: action_shadow(:ltr)
      ]
    end

    defp body_cell_base do
      [
        padding: {:space, :md},
        vertical_align: :middle,
        white_space: :nowrap,
        background_color: {:color, :layer},
        transition: {:raw, "background-color 0.2s ease-in-out"},
        font_size: {:text, :base},
        line_height: {:leading, :base}
      ]
    end

    defp action_shadow(:ltr) do
      {:raw, "-4px 0 8px -6px color-mix(in srgb, var(--color-ui-ink) 12%, transparent)"}
    end

    defp action_shadow(:rtl) do
      {:raw, "4px 0 8px -6px color-mix(in srgb, var(--color-ui-ink) 12%, transparent)"}
    end

    defp size_rules do
      host = Selector.host(@id)
      thead_th = "#{part("thead")} th"

      cells =
        Enum.join(
          [part("cell"), part("grow-cell"), part("action-cell"), part("selection-cell")],
          ",\n  "
        )

      headers = Enum.join([part("selection-header"), part("action-header")], ",\n  ")

      for size <- Axes.size_atoms() do
        sel = "#{host}.#{Selector.class_name(@id)}--size-#{size}"
        block = RecipePresets.size_block(size)

        [
          Rule.new("#{sel} #{thead_th}",
            decls: [
              font_size: block.font_size,
              line_height: block.line_height
            ]
          ),
          Rule.new("#{sel} #{cells}",
            decls: [
              font_size: block.font_size,
              line_height: block.line_height,
              padding_inline: block.padding_inline
            ]
          ),
          Rule.new("#{sel} #{headers}", decls: [padding_inline: block.padding_inline])
        ]
      end
      |> List.flatten()
    end

    defp semantic_rules do
      host = Selector.host(@id)
      thead_th = "#{part("thead")} th"

      for color <- Axes.semantic_atoms() do
        ink = Palette.ink_color_atom(color)

        Rule.new("#{host}.#{Selector.class_name(@id)}--semantic-#{color} #{thead_th}",
          decls: [color: {:color, ink}]
        )
      end
    end

    defp rtl_rules(host) do
      [
        Rule.new(
          ~s|#{host}[dir="rtl"] #{part("thead")} th[data-part="cell"],\n  #{host}[dir="rtl"] #{part("thead")} th[data-part="grow-cell"],\n          #{host}[dir="rtl"] #{part("cell")},\n  #{host}[dir="rtl"] #{part("grow-cell")}|,
          decls: [{:raw, "unicode-bidi: plaintext;"}, text_align: :start]
        ),
        Rule.new(
          ~s|#{host}[dir="rtl"] #{part("selection-header")},\n  #{host}[dir="rtl"] #{part("action-header")},\n  #{host}[dir="rtl"] #{part("selection-cell")},\n  #{host}[dir="rtl"] #{part("action-cell")}|,
          decls: [{:raw, "unicode-bidi: plaintext;"}, text_align: :center]
        ),
        Rule.new(
          ~s|#{host}[dir="rtl"] #{part("action-header")},\n  #{host}[dir="rtl"] #{part("action-cell")}|,
          decls: [box_shadow: action_shadow(:rtl)]
        )
      ]
    end
  end

  defmodule DatePicker do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "date-picker"
    @id :date_picker

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :auto, max_width: :none, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules:
          base_rules() ++ semantic_cell_rules() ++ nav_trigger_rules() ++ range_control_rules()
      )
    end

    defp semantic_variants do
      Corex.Design.Recipes.semantic_part_host_variants()
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      control = part("control")
      trigger = part("trigger")
      input = part("input")
      positioner = part("positioner")
      content = part("content")
      table_cell_trigger = part("table-cell-trigger")
      prev_trigger = part("prev-trigger")
      next_trigger = part("next-trigger")
      view_trigger = part("view-trigger")
      view_control = part("view-control")
      table_header = part("table-header")
      day_table_header = part("day-table-header")
      error = part("error")

      [
        Rule.new(host, decls: [width: "fit-content"]),
        Rule.new("#{content}[hidden]", decls: [display: "none !important"]),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(root,
          decls: [
            include: :ui_root,
            width: "fit-content",
            gap: {:space, :md},
            position: "relative",
            padding_inline_end: {:space, :md}
          ]
        ),
        Rule.new("#{root}[data-readonly]", decls: [include: :ui_readonly]),
        Rule.new(label,
          decls: [include: :ui_label],
          children: [
            Rule.new("&[data-invalid]", decls: [color: {:color, :alert}])
          ]
        ),
        Rule.new(control,
          decls: [
            display: "flex",
            flex_flow: "row nowrap",
            padding: "0",
            width: "fit-content",
            overflow: "hidden",
            gap: {:space, :md},
            justify_content: "flex-start",
            border_radius: {:radius, :md}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "place-items: center"}])
          ]
        ),
        Rule.new(trigger,
          decls: [
            include: :ui_trigger,
            padding: "0",
            width: "auto",
            min_height: {:size, :md},
            max_height: {:size, :md},
            position: "relative"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}])
          ]
        ),
        Rule.new(input,
          decls: [
            include: :ui_input,
            width: {:raw, "calc(var(--size) * 3)"},
            max_width: {:raw, "calc(var(--size) * 3)"},
            min_width: "0",
            flex: "0 0 auto"
          ]
        ),
        Rule.new(positioner,
          decls: [
            position: "relative",
            z_index: "30",
            width: "max-content",
            max_width: "max-content"
          ]
        ),
        Rule.new(content,
          decls: [
            display: "flex",
            flex_direction: "column",
            width: "max-content",
            max_width: "max-content",
            min_width: "0",
            padding: "0",
            border_radius: {:radius, :md},
            border: {:raw, "1px solid var(--color-border)"},
            background_color: {:color, :root},
            color: {:color, :ui_ink},
            box_shadow: {:raw, "var(--shadow-ui)"},
            z_index: "30",
            box_sizing: "border-box",
            overflow: "hidden"
          ]
        ),
        Rule.new(
          "#{part("day-view")}, #{part("month-view")}, #{part("year-view")}",
          decls: [width: "max-content", max_width: "max-content", min_width: "0"]
        ),
        Rule.new(
          "#{part("table")}, #{part("day-table")}, #{part("month-table")}, #{part("year-table")}",
          decls: [
            width: "max-content",
            max_width: "max-content",
            padding: "0",
            margin: "0"
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw, "table-layout: fixed; border-collapse: collapse; border-spacing: 0"}
              ]
            )
          ]
        ),
        Rule.new(part("table-cell"),
          decls: [
            position: "relative",
            padding: "0",
            border: "0",
            text_align: "center",
            vertical_align: "middle"
          ]
        ),
        Rule.new("#{table_header}, #{day_table_header}", decls: [border: "0"]),
        Rule.new("#{table_header} th, #{day_table_header} th",
          decls: [
            border: "0",
            font_weight: {:raw, "var(--font-weight-normal)"},
            padding_block: {:raw, "calc(var(--space) * 0.35)"},
            padding_inline: "0",
            text_align: "center",
            font_size: {:text, :sm},
            line_height: {:leading, :sm},
            color: {:color, :ui_ink},
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "text-transform: uppercase"}])
          ]
        ),
        Rule.new(view_control,
          decls: [
            display: "flex",
            width: "auto",
            align_self: "stretch",
            min_width: "0",
            justify_content: "space-between",
            align_items: "center",
            gap: {:raw, "calc(var(--space) * 0.5)"},
            padding_inline: {:space, :md},
            padding_block: {:raw, "calc(var(--space) * 0.5)"}
          ]
        ),
        Rule.new(table_cell_trigger,
          decls: [
            include: :ui_item,
            display: "flex",
            align_items: "center",
            justify_content: "center",
            box_sizing: "border-box",
            width: {:raw, "calc(var(--size) * 0.95)"},
            min_width: {:raw, "calc(var(--size) * 0.95)"},
            max_width: {:raw, "calc(var(--size) * 0.95)"},
            height: {:raw, "calc(var(--size) * 0.95)"},
            min_height: {:raw, "calc(var(--size) * 0.95)"},
            max_height: {:raw, "calc(var(--size) * 0.95)"},
            margin: "0",
            padding: "0",
            gap: "0",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            border_radius: "0",
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap"
          ]
        ),
        Rule.new(
          "#{table_cell_trigger}[data-view='month'],\n  #{table_cell_trigger}[data-view='year']",
          decls: [
            width: {:raw, "calc(var(--size) * 1.15)"},
            min_width: {:raw, "calc(var(--size) * 1.15)"},
            max_width: {:raw, "calc(var(--size) * 1.15)"},
            min_height: {:raw, "calc(var(--size) * 1.15)"},
            height: "auto",
            max_height: "none",
            padding: {:raw, "calc(var(--space) * 0.35)"}
          ]
        ),
        Rule.new("#{table_cell_trigger}[data-today]:not([data-selected])",
          decls: [
            font_weight: {:raw, "var(--font-weight-semibold)"},
            text_decoration_line: "underline",
            text_underline_offset: {:raw, "calc(var(--space) * 0.85)"},
            position: "relative"
          ]
        ),
        Rule.new("#{table_cell_trigger}[data-outside-month]",
          decls: [color: {:color, :ui_ink_muted}, opacity: "0.5"]
        ),
        Rule.new("#{table_cell_trigger}[data-disabled]",
          decls: [color: {:color, :ui_ink_muted}, cursor: "not-allowed"]
        ),
        Rule.new("#{table_cell_trigger}[data-unavailable]",
          decls: [
            text_decoration_line: "line-through",
            cursor: "not-allowed",
            color: {:color, :ui_ink_muted}
          ]
        ),
        Rule.new(prev_trigger,
          decls: [
            include: :ui_trigger,
            width: {:raw, "calc(var(--size) * 0.8)"},
            min_width: {:raw, "calc(var(--size) * 0.8)"},
            max_width: {:raw, "calc(var(--size) * 0.8)"},
            min_height: {:raw, "calc(var(--size) * 0.8)"},
            max_height: {:raw, "calc(var(--size) * 0.8)"},
            padding: "0",
            font_size: {:text, :sm},
            line_height: {:leading, :sm}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}])
          ]
        ),
        Rule.new(next_trigger,
          decls: [
            include: :ui_trigger,
            width: {:raw, "calc(var(--size) * 0.8)"},
            min_width: {:raw, "calc(var(--size) * 0.8)"},
            max_width: {:raw, "calc(var(--size) * 0.8)"},
            min_height: {:raw, "calc(var(--size) * 0.8)"},
            max_height: {:raw, "calc(var(--size) * 0.8)"},
            padding: "0",
            font_size: {:text, :sm},
            line_height: {:leading, :sm}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}])
          ]
        ),
        Rule.new(view_trigger,
          decls: [
            include: :ui_trigger,
            min_height: {:size, :md},
            font_size: {:text, :sm},
            line_height: {:leading, :sm}
          ]
        ),
        Rule.new(error, decls: [include: :ui_error])
      ]
    end

    defp semantic_cell_rules do
      cell = part("table-cell-trigger")

      for color <- Axes.semantic_atoms() do
        c = Atom.to_string(color)
        host_mod = Palette.host_mod(@id, color)
        bg = "var(--color-#{c})"
        ink = "var(--color-#{c}-ink)"
        hover = "var(--color-#{c}-hover)"
        active = "var(--color-#{c}-active)"
        today = "var(--color-#{c})"

        [
          Rule.new(
            "#{host_mod} #{cell}[data-selected]:not(:disabled):not([data-disabled]):not([disabled])",
            decls: [
              background_color: {:raw, bg},
              color: {:raw, ink},
              border_color: {:raw, bg}
            ],
            children: [
              Rule.new("&:hover", decls: [background_color: {:raw, hover}]),
              Rule.new("&:active", decls: [background_color: {:raw, active}])
            ]
          ),
          Rule.new(
            "#{host_mod} #{cell}[data-today]:not([data-selected]):not(:disabled):not([data-disabled]):not([disabled])",
            decls: [color: {:raw, today}]
          ),
          Rule.new("#{host_mod} #{part("trigger")}",
            decls: [
              background_color: {:color, :ui},
              color: {:raw, bg},
              border_color: {:color, :border}
            ]
          )
        ]
      end
      |> List.flatten()
    end

    defp nav_trigger_rules do
      nav = "#{part("prev-trigger")}, #{part("next-trigger")}, #{part("view-trigger")}"

      for color <- Axes.semantic_atoms() do
        c = Atom.to_string(color)
        host_mod = Palette.host_mod(@id, color)

        Rule.new("#{host_mod} #{nav}",
          decls: [
            color: {:raw, "var(--color-#{c})"},
            background_color: "transparent",
            border_color: {:color, :border}
          ],
          children: [
            Rule.new("&:hover", decls: [background_color: {:color, :ui_hover}]),
            Rule.new("&:active", decls: [background_color: {:color, :ui_active}])
          ]
        )
      end
    end

    defp range_control_rules do
      host = Selector.host(@id)

      [
        Rule.new("#{host} .date-picker__control-inputs--range",
          decls: [
            display: "flex",
            flex: "1 1 0%",
            flex_flow: "row wrap",
            align_items: "center",
            gap: {:space, :md},
            min_width: "0"
          ]
        ),
        Rule.new("#{host} .date-picker__range-label",
          decls: [
            include: :ui_label,
            flex: "0 0 auto",
            font_size: {:text, :sm},
            line_height: {:leading, :sm},
            color: {:color, :ui_ink}
          ]
        ),
        Rule.new(
          "#{host} .date-picker__control-inputs--range #{slot("input")}",
          decls: [
            flex: "0 0 auto",
            width: {:raw, "calc(var(--size) * 3)"},
            max_width: {:raw, "calc(var(--size) * 3)"},
            min_width: "0"
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = if(size == :md, do: :base, else: size)
        block = RecipePresets.text_block(text)
        size_raw = "var(--size-#{size})"
        space_raw = "var(--space-#{size})"

        {size,
         [
           root: %{gap: {:space, size}},
           label: block,
           control: %{gap: {:space, size}},
           positioner: %{width: "max-content", max_width: "max-content"},
           content: %{width: "max-content", max_width: "max-content"},
           input: %{
             width: {:raw, "calc(#{size_raw} * 3)"},
             max_width: {:raw, "calc(#{size_raw} * 3)"},
             flex: "0 0 auto",
             font_size: {:text, text},
             line_height: {:leading, text},
             min_height: {:size, size},
             max_height: {:size, size},
             padding_inline: {:space, size},
             background_color: {:color, :ui},
             color: {:color, :ui_ink},
             border_color: {:color, :border}
           },
           trigger: %{
             font_size: {:text, text},
             line_height: {:leading, text},
             min_height: {:size, size},
             max_height: {:size, size},
             background_color: {:color, :ui},
             border_color: {:color, :border}
           },
           prev_trigger: nav_size_block(size, text),
           next_trigger: nav_size_block(size, text),
           view_trigger: %{
             min_height: {:size, size},
             font_size: {:text, text},
             line_height: {:leading, text}
           },
           view_control: %{
             gap: {:space, size},
             padding_inline: {:space, size},
             padding_block: {:raw, "calc(#{space_raw} * 0.5)"}
           },
           table_header: %{font_size: {:text, text}, line_height: {:leading, text}},
           day_table_header: %{font_size: {:text, text}, line_height: {:leading, text}},
           table_cell_trigger: cell_size_block(size, text)
         ]}
      end
    end

    defp nav_size_block(size, text) do
      size_raw = "var(--size-#{size})"

      %{
        width: {:raw, "calc(#{size_raw} * 0.8)"},
        min_width: {:raw, "calc(#{size_raw} * 0.8)"},
        max_width: {:raw, "calc(#{size_raw} * 0.8)"},
        min_height: {:raw, "calc(#{size_raw} * 0.8)"},
        max_height: {:raw, "calc(#{size_raw} * 0.8)"},
        font_size: {:text, text},
        line_height: {:leading, text}
      }
    end

    defp cell_size_block(size, text) do
      size_raw = "var(--size-#{size})"

      %{
        width: {:raw, "calc(#{size_raw} * 0.95)"},
        min_width: {:raw, "calc(#{size_raw} * 0.95)"},
        max_width: {:raw, "calc(#{size_raw} * 0.95)"},
        height: {:raw, "calc(#{size_raw} * 0.95)"},
        min_height: {:raw, "calc(#{size_raw} * 0.95)"},
        max_height: {:raw, "calc(#{size_raw} * 0.95)"},
        font_size: {:text, text},
        line_height: {:leading, text}
      }
    end

    defp radius_variants do
      for r <- Axes.radius_atoms() do
        block = RecipePresets.rounded_block(r)

        {r,
         [
           input: block,
           trigger: block,
           prev_trigger: block,
           next_trigger: block,
           view_trigger: block
         ]}
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule DialogModal do
    @moduledoc false

    def recipe, do: Corex.Design.Recipes.Dialog.modal_recipe()
  end

  defmodule DialogSide do
    @moduledoc false

    def recipe, do: Corex.Design.Recipes.Dialog.side_recipe()
  end

  defmodule Editable do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "editable"
    @id :editable

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :fit, max_width: :none, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules:
          base_rules() ++ semantic_edit_trigger_rules() ++ semantic_action_trigger_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      control = part("control")
      area = part("area")
      input = part("input")
      preview = part("preview")
      edit = part("edit-trigger")
      cancel = part("cancel-trigger")
      submit = part("submit-trigger")
      error = part("error")
      triggers = ~s(#{host} [data-part="triggers"])

      square_trigger =
        [include: :ui_trigger] ++
          RecipePresets.trigger_part_square() ++
          [
            flex: "0 0 auto",
            width: {:raw, "calc(var(--size-md) * 0.6)"},
            min_width: {:raw, "calc(var(--size-md) * 0.6)"},
            max_width: {:raw, "calc(var(--size-md) * 0.6)"},
            min_height: {:raw, "calc(var(--size-md) * 0.6)"},
            max_height: {:raw, "calc(var(--size-md) * 0.6)"}
          ]

      [
        Rule.new(host, decls: [width: "fit-content"]),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(root,
          decls: [
            include: :ui_root,
            width: "100%",
            position: "relative",
            padding_inline_end: {:space, :md}
          ],
          children: [
            Rule.new("&[data-readonly]", decls: [include: :ui_readonly])
          ]
        ),
        Rule.new(label, decls: [include: :ui_label]),
        Rule.new(control,
          decls: [
            display: "flex",
            flex_direction: "row",
            gap: {:space, :md},
            width: "100%",
            align_items: "center",
            justify_content: "start"
          ]
        ),
        Rule.new(area,
          decls: [
            display: "flex",
            flex: "1 1 auto",
            align_items: "center",
            justify_content: "start",
            gap: {:space, :md}
          ]
        ),
        Rule.new(input,
          decls: [
            include: :ui_input,
            flex: "0 0 auto",
            width: {:raw, "calc(var(--size-md) * 3)"},
            max_width: {:raw, "calc(var(--size-md) * 3)"},
            min_width: "0"
          ]
        ),
        Rule.new(preview,
          decls: [
            include: :ui_input,
            flex: "0 0 auto",
            width: {:raw, "calc(var(--size-md) * 3)"},
            max_width: {:raw, "calc(var(--size-md) * 3)"},
            min_width: "0",
            white_space: "nowrap"
          ]
        ),
        Rule.new(triggers,
          decls: [
            display: "inline-flex",
            align_items: "center",
            justify_content: "center",
            flex: "0 0 auto",
            gap: {:space, :sm}
          ]
        ),
        Rule.new(edit,
          decls: square_trigger,
          children: [
            Rule.new("&:not([hidden])", decls: [margin_inline: "auto"])
          ]
        ),
        Rule.new(cancel,
          decls:
            square_trigger ++
              [
                background_color: {:color, :alert},
                color: {:color, :alert_ink},
                border_color: {:color, :alert}
              ]
        ),
        Rule.new(submit,
          decls:
            square_trigger ++
              [
                background_color: {:color, :success},
                color: {:color, :success_ink},
                border_color: {:color, :success}
              ]
        ),
        Rule.new(error, decls: [include: :ui_error])
      ]
    end

    defp semantic_edit_trigger_rules do
      Palette.semantic_ink_part_rules(@id, Selector.slot(@scope, "edit-trigger"), hover: false)
    end

    defp semantic_action_trigger_rules do
      Palette.semantic_solid_part_rules(@id, Selector.slot(@scope, "submit-trigger")) ++
        Palette.semantic_ink_part_rules(@id, Selector.slot(@scope, "cancel-trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)
        dim = {:raw, "calc(var(--size-#{size}) * 0.6)"}
        field = {:raw, "calc(var(--size-#{size}) * 3)"}

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           edit_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               width: dim,
               min_width: dim,
               max_width: dim,
               min_height: dim,
               max_height: dim,
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           cancel_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               width: dim,
               min_width: dim,
               max_width: dim,
               min_height: dim,
               max_height: dim,
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           submit_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               width: dim,
               min_width: dim,
               max_width: dim,
               min_height: dim,
               max_height: dim,
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           preview:
             Map.merge(RecipePresets.text_block(text), %{
               width: field,
               max_width: field,
               min_height: {:size, size},
               color: {:color, :ui_ink},
               border_color: {:color, :border}
             }),
           input:
             Map.merge(RecipePresets.text_block(text), %{
               width: field,
               max_width: field,
               min_height: {:size, size},
               color: {:color, :ui_ink},
               border_color: {:color, :border}
             })
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms() do
        block = RecipePresets.rounded_block(r)

        {r,
         [
           input: block,
           preview: block,
           edit_trigger: block,
           cancel_trigger: block,
           submit_trigger: block
         ]}
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule FileUpload do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Emit.Tokens, as: Var
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "file-upload"
    @id :file_upload

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_trigger_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      region = part("region")
      dropzone = part("dropzone")
      trigger = part("trigger")
      item_group = part("item-group")
      item = part("item")
      item_lead = part("item-lead")
      item_preview = part("item-preview")
      item_preview_image = part("item-preview-image")
      item_name = part("item-name")
      item_size_text = part("item-size-text")
      item_delete = part("item-delete-trigger")
      hidden = part("hidden-input")
      hidden_sentinel = part("hidden-input-sentinel")
      error = part("error")

      hidden_decls = [
        opacity: "0",
        position: "absolute",
        width: "1px",
        height: "1px",
        margin: "-1px",
        overflow: "hidden"
      ]

      hidden_clip = [Rule.new("&", decls: [{:raw, "clip-path: inset(50%)"}])]

      [
        Rule.new(host,
          decls: [width: "100%", max_width: {:container, :md}, margin_inline: "auto"]
        ),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new("#{host}[data-loading] #{hidden},\n  #{host}[data-loading] #{hidden_sentinel}",
          decls: hidden_decls ++ [pointer_events: "none"]
        ),
        Rule.new(hidden, decls: hidden_decls, children: hidden_clip),
        Rule.new(hidden_sentinel, decls: hidden_decls, children: hidden_clip),
        Rule.new(root,
          decls: [
            include: :ui_root,
            display: "flex",
            flex_direction: "column",
            align_items: "center",
            gap: {:space, :md},
            width: "100%"
          ],
          children: [
            Rule.new("&[data-readonly]", decls: [include: :ui_readonly])
          ]
        ),
        Rule.new(label,
          decls: [include: :ui_label, align_self: "stretch", text_align: "center"]
        ),
        Rule.new(region,
          decls: [
            position: "relative",
            display: "flex",
            flex_direction: "column",
            align_items: "center",
            align_self: "stretch",
            gap: {:space, :md},
            border: {:raw, "1px dashed var(--color-border)"},
            border_radius: {:radius, :md},
            padding: {:space, :md},
            width: "100%",
            box_sizing: "border-box"
          ],
          children: [
            Rule.new(
              "&:has(#{dropzone}[data-dragging])",
              decls: [
                border_color: {:color, :brand},
                background: {:raw, "color-mix(in srgb, var(--color-brand) 8%, transparent)"}
              ]
            )
          ]
        ),
        Rule.new(dropzone,
          decls: [
            display: "flex",
            flex_direction: "column",
            align_items: "center",
            align_self: "stretch",
            flex: "1 1 auto",
            min_height: "0",
            cursor: "pointer",
            text_align: "center"
          ]
        ),
        Rule.new(trigger, decls: [include: :ui_trigger]),
        Rule.new(item_group,
          decls: [
            list_style: "none",
            align_self: "stretch",
            width: "100%",
            min_width: "0",
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            background_color: {:color, :ui},
            overflow: "hidden",
            display: "flex",
            flex_direction: "column",
            gap: {:space, :md},
            padding_block: {:space, :md}
          ],
          children: [
            Rule.new("&:not(:has(li))", decls: [display: "none"])
          ]
        ),
        Rule.new(item,
          decls: [
            display: "flex",
            flex_direction: "row",
            flex_wrap: "nowrap",
            align_items: "center",
            min_width: "0",
            gap: {:space, :md},
            padding: "0",
            margin: "0"
          ]
        ),
        Rule.new(item_lead,
          decls: [
            flex: "0 0 auto",
            display: "flex",
            align_items: "center",
            justify_content: "center"
          ],
          children: [
            Rule.new("&:empty", decls: [display: "none"])
          ]
        ),
        Rule.new(item_preview,
          decls: [
            width: {:size, :md},
            height: {:size, :md},
            flex_shrink: "0",
            overflow: "hidden",
            border_radius: {:radius, :md},
            display: "flex",
            align_items: "center",
            justify_content: "center",
            background_color: {:color, :border},
            margin_inline: {:space, :sm}
          ]
        ),
        Rule.new(item_preview_image,
          decls: [
            width: "100%",
            height: "100%",
            border_radius: {:radius, :md}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "object-fit: cover"}])
          ]
        ),
        Rule.new(item_name,
          decls: [
            include: :ui_label,
            flex: "1 1 0",
            min_width: "0",
            overflow: "hidden",
            text_overflow: "ellipsis"
          ]
        ),
        Rule.new(item_size_text,
          decls: [include: :ui_label, font_weight: {:weight, :medium}]
        ),
        Rule.new(item_delete,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            background_color: {:color, :alert},
            color: {:color, :alert_ink},
            border_color: {:color, :alert},
            min_height: {:size, :sm},
            font_size: {:text, :sm},
            line_height: {:leading, :sm}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "margin-inline-end: #{Var.ref([:space, :md])}"}])
          ]
        ),
        Rule.new(error, decls: [include: :ui_error])
      ]
    end

    defp semantic_trigger_rules do
      SemanticStates.solid_part_rules(@id, part("trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}, max_width: {:container, size}},
           label: RecipePresets.text_block(text),
           region: %{padding: {:space, size}, gap: {:space, size}},
           trigger:
             Map.merge(RecipePresets.size_block(size), %{
               background_color: {:color, :accent},
               color: {:color, :accent_ink}
             })
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r,
             [dropzone: RecipePresets.rounded_block(r), trigger: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule FloatingPanel do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "floating-panel"
    @id :floating_panel

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          radius: radius_variants()
        ],
        default_variants: [],
        extra_rules: base_rules() ++ semantic_trigger_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      trigger = part("trigger")
      title = ~s(#{host} [data-part="title"])
      positioner = part("positioner")
      content = part("content")
      header = part("header")
      body = part("body")
      drag = part("drag-trigger")
      control = part("control")
      stage = part("stage-trigger")
      close = part("close-trigger")
      resize = part("resize-trigger")

      [
        Rule.new("#{host}[data-loading] #{part("root")}", decls: [include: :ui_loading]),
        Rule.new(trigger,
          decls: [
            include: :ui_trigger,
            min_height: {:raw, "calc(var(--size-md) * 0.8)"}
          ],
          children: [
            Rule.new("&[data-state=\"open\"] [data-closed]", decls: [display: "none"]),
            Rule.new("&[data-state=\"closed\"] [data-open]", decls: [display: "none"])
          ]
        ),
        Rule.new(title, decls: [include: :ui_label]),
        Rule.new(positioner, decls: [z_index: "50"]),
        Rule.new("#{positioner}:has(#{content}[data-state=\"closed\"])",
          decls: [display: "none"]
        ),
        Rule.new("#{positioner}:has(#{content}[data-topmost])", decls: [z_index: "999999"]),
        Rule.new(content,
          decls: [
            display: "flex",
            flex_direction: "column",
            z_index: "var(--z-index)",
            position: "relative",
            box_shadow: {:shadow, :md}
          ],
          children: [
            Rule.new("&[data-topmost]", decls: [z_index: "999999"]),
            Rule.new("&[data-behind]", decls: [opacity: "0.8"]),
            Rule.new("&:focus-visible",
              decls: [
                outline: "none",
                box_shadow: "inset 0 0 0 2px var(--color-ui-ink)",
                border_radius: {:radius, :md}
              ]
            ),
            Rule.new("&[data-minimized]",
              decls: [height: "auto !important", overflow: "visible !important"]
            ),
            Rule.new("&[data-minimized] #{drag}", decls: [border_radius: {:radius, :md}])
          ]
        ),
        Rule.new(stage,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            width: {:raw, "calc(var(--size-sm) * 0.8)"},
            min_width: {:raw, "calc(var(--size-sm) * 0.8)"},
            max_width: {:raw, "calc(var(--size-sm) * 0.8)"},
            min_height: {:raw, "calc(var(--size-sm) * 0.8)"},
            max_height: {:raw, "calc(var(--size-sm) * 0.8)"},
            padding: "0",
            font_size: {:text, :xs},
            line_height: {:leading, :xs}
          ]
        ),
        Rule.new(close,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            width: {:raw, "calc(var(--size-sm) * 0.8)"},
            min_width: {:raw, "calc(var(--size-sm) * 0.8)"},
            max_width: {:raw, "calc(var(--size-sm) * 0.8)"},
            min_height: {:raw, "calc(var(--size-sm) * 0.8)"},
            max_height: {:raw, "calc(var(--size-sm) * 0.8)"},
            padding: "0",
            font_size: {:text, :xs},
            line_height: {:leading, :xs}
          ]
        ),
        Rule.new(body,
          decls: [
            position: "relative",
            overflow: "auto",
            flex: "1 1 auto",
            min_height: "fit-content",
            height: "var(--height)",
            padding: {:space, :md},
            background_color: {:color, :root},
            border_radius: {:raw, "0 0 var(--radius-md) var(--radius-md)"},
            border: {:raw, "1px solid var(--color-border)"}
          ],
          children:
            RecipePresets.scrollbar_sm_children() ++
              [
                Rule.new("&", decls: [{:raw, "border-block-start: 0"}]),
                Rule.new("& p", decls: [margin_block: "0"])
              ]
        ),
        Rule.new(header,
          decls: [
            display: "flex",
            justify_content: "space-between",
            align_items: "center",
            flex_wrap: "wrap",
            padding_block: {:space, :sm},
            padding_inline: {:space, :md},
            gap: {:space, :md}
          ]
        ),
        Rule.new(drag,
          decls: [
            background_color: {:color, :layer},
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:raw, "var(--radius-md) var(--radius-md) 0 0"}
          ],
          children: [
            Rule.new("&:focus-visible", decls: [outline: "none"])
          ]
        ),
        Rule.new(control,
          decls: [
            display: "flex",
            flex_flow: "row nowrap",
            align_items: "center",
            gap: {:space, :md}
          ]
        ),
        Rule.new(resize,
          children: [
            Rule.new(~S(&[data-axis="n"],\n  &[data-axis="s"]),
              decls: [height: "6px", max_width: "90%"]
            ),
            Rule.new(~S(&[data-axis="e"],\n  &[data-axis="w"]),
              decls: [width: "6px", max_height: "90%"]
            ),
            Rule.new(
              ~S(&[data-axis="ne"],\n  &[data-axis="nw"],\n  &[data-axis="se"],\n  &[data-axis="sw"]),
              decls: [width: "10px", height: "10px"]
            )
          ]
        ),
        Rule.new("#{host}:not([data-resizable]) #{resize},\n  #{resize}[data-disabled]",
          decls: [display: "none"]
        ),
        Rule.new("#{host}:not([data-draggable]) #{drag},\n  #{drag}[data-disabled]",
          decls: [
            cursor: "default !important",
            user_select: "auto !important"
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw, "-webkit-user-select: auto !important; touch-action: auto !important"}
              ]
            )
          ]
        )
      ]
    end

    defp semantic_trigger_rules do
      SemanticStates.solid_part_rules(@id, part("trigger"))
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r,
             [content: RecipePresets.rounded_block(r), trigger: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)
  end

  defmodule LayoutHeading do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "layout-heading"
    @id :layout_heading

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          gap: gap_variants()
        ],
        default_variants: [text: :"2xl", gap: :md],
        extra_rules: base_rules()
      )
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      content = part("content")
      title = part("title")
      subtitle = part("subtitle")
      actions = part("actions")

      [
        Rule.new(host, decls: [width: "100%"]),
        Rule.new(root,
          decls: [
            display: "flex",
            flex_wrap: "wrap",
            align_items: "flex-start",
            justify_content: "space-between",
            gap: {:space, :md},
            width: "100%",
            padding: {:space, :md}
          ]
        ),
        Rule.new(content,
          decls: [
            display: "flex",
            flex_direction: "column",
            gap: {:space, :md}
          ]
        ),
        Rule.new(
          ~s(#{host} h1,
  #{host} h2,
  #{host} h3,
  #{host} h4,
  #{host} h5,
  #{host} h6,
  #{subtitle}),
          decls: [margin: 0]
        ),
        Rule.new(title, decls: [color: {:color, :ui_ink}]),
        Rule.new(subtitle, decls: [color: {:color, :ui_ink_muted}]),
        Rule.new(actions,
          decls: [
            display: "flex",
            flex_wrap: "wrap",
            align_items: "flex-start",
            gap: {:space, :md},
            padding: 0
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, [root: RecipePresets.size_block(size)]}
    end

    defp semantic_variants do
      for role <- Palette.color_atoms(),
          do:
            {role,
             [
               title: %{color: {:color, Palette.ink_color_atom(role)}},
               subtitle: %{color: {:color, :ui_ink_muted}}
             ]}
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, [title: RecipePresets.text_block(step)]}
    end

    defp gap_variants do
      none = [root: %{gap: 0, padding: 0}]

      spacing =
        for step <- ~W(sm md lg xl)a,
            do: {step, [root: %{gap: {:space, step}, padding: {:space, step}}]}

      [{:none, none} | spacing]
    end
  end

  defmodule Link do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.HostIcon
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    def recipe do
      Recipe.define(:link,
        host_sizing: RecipePresets.inline_host_sizing(),
        base: RecipePresets.link_base(),
        variants: [
          semantic: semantic_variants(),
          variant: variant_variants(),
          size: size_variants(),
          text: text_variants(),
          shape: HostIcon.shape_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules:
          link_semantic_rules() ++
            HostIcon.indicator_rules(:link) ++
            HostIcon.host_icon_rules(:link) ++
            HostIcon.square_icon_rules(:link) ++ skip_link_rules()
      )
    end

    defp link_semantic_rules do
      for role <- Axes.semantic_atoms() do
        c = Atom.to_string(role)
        ink = Palette.ink_color_var(role)

        Rule.new(Palette.host_mod(:link, role),
          decls: [color: "var(#{ink})"],
          children: [
            Rule.new("&:hover", decls: [color: "var(--color-#{c}-hover)"])
          ]
        )
      end
    end

    defp skip_link_rules do
      host = Selector.host(:link)
      skip = ~s(#{host}.link--skip)

      [
        Rule.new(skip,
          decls: [
            position: :fixed,
            inset_inline_start: {:space, :lg},
            inset_block_start: {:raw, "-9999px"},
            z_index: 10_000,
            max_width: {:raw, "min(100vw - calc(var(--space) * 2), 20rem)"},
            padding_block: {:space, :md},
            padding_inline: {:space, :lg},
            margin: 0,
            overflow: :visible,
            background: {:color, :layer},
            color: {:color, :ui_ink},
            border: {:raw, "1px solid var(--color-border)"},
            box_shadow: {:raw, "0 4px 24px rgb(0 0 0 / 0.12)"},
            transition: {:raw, "inset-block-start 0.15s ease"}
          ],
          children: [
            Rule.new("&:focus,\n  &:focus-visible",
              decls: [inset_block_start: {:space, :lg}]
            ),
            Rule.new("@media (prefers-reduced-motion: reduce)",
              decls: [transition: :none]
            )
          ]
        )
      ]
    end

    defp variant_variants do
      for variant <- Axes.visual_atoms(), do: {variant, %{}}
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, %{position: :relative}}
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, RecipePresets.size_block(size)}
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, RecipePresets.text_block(step)}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, RecipePresets.rounded_block(r)}
    end
  end

  defmodule Listbox do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "listbox"
    @id :listbox

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"3xs", height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_item_rules()
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp semantic_item_rules do
      SemanticStates.active_part_rules(@id, part("item"), "[data-selected]")
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      content = part("content")
      item_group = part("item-group")
      item_group_label = part("item-group-label")
      item = part("item")
      item_text = "#{content} #{slot("item-text")}"
      item_indicator = "#{content} #{slot("item-indicator")}"

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(host,
          decls: [
            width: "100%",
            max_width: {:container, :"3xs"},
            min_width: "0",
            box_sizing: "border-box",
            margin_inline: "auto"
          ],
          children: [
            Rule.new("&[data-orientation='horizontal']",
              decls: [width: "100%", max_width: {:container, :md}]
            )
          ]
        ),
        Rule.new(root,
          decls: [
            include: :ui_root,
            flex_direction: "column",
            flex_wrap: "nowrap",
            align_items: "stretch",
            width: "100%",
            min_width: "0",
            max_width: "none",
            gap: {:space, :md}
          ]
        ),
        Rule.new("#{root} > #{content}", decls: [width: "100%", min_width: "0"]),
        Rule.new("#{root}[data-orientation='horizontal']",
          decls: [flex_direction: "column", flex_wrap: "nowrap"]
        ),
        Rule.new(label, decls: [include: :ui_label]),
        Rule.new("#{label}[data-disabled]", decls: [color: {:color, :ui_ink_muted}]),
        Rule.new(item_group_label,
          decls: [
            display: "flex",
            align_items: "center",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            text_align: "start",
            min_height: {:size, :md},
            padding_inline: {:space, :md},
            background_color: {:color, :root},
            color: {:color, :ui_ink},
            border_bottom: {:raw, "1px solid var(--color-border)"},
            width: "100%",
            box_sizing: "border-box"
          ]
        ),
        Rule.new("#{content}[data-layout='list'][data-orientation='vertical']",
          decls: [
            display: "flex",
            flex_direction: "column",
            align_items: "stretch",
            width: "100%",
            min_width: "0"
          ]
        ),
        Rule.new("#{content}[data-layout='list'][data-orientation='horizontal']",
          decls: [
            display: "flex",
            flex_direction: "row",
            flex_wrap: "nowrap",
            width: "100%",
            min_width: "0"
          ]
        ),
        Rule.new(
          "#{content}[data-layout='list'][data-orientation='horizontal']:not(:has(#{slot("item-group")}))",
          decls: [
            overflow_x: "auto",
            overflow_y: "hidden",
            background_color: {:color, :border},
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            gap: "1px"
          ],
          children: RecipePresets.scrollbar_sm_children()
        ),
        Rule.new(
          "#{content}[data-layout='grid']:not(:has(#{slot("item-group")}))",
          decls: [
            display: "grid",
            grid_template_columns: {:raw, "repeat(var(--column-count), 1fr)"}
          ]
        ),
        Rule.new("#{content}[data-layout='grid'] #{slot("item-group")}",
          decls: [
            display: "grid",
            grid_template_columns: {:raw, "repeat(var(--column-count), 1fr)"}
          ]
        ),
        Rule.new("#{content}:focus-visible", decls: [outline: "none"]),
        Rule.new(item_group,
          decls: [display: "flex", flex_direction: "column", margin_block: {:space, :md}]
        ),
        Rule.new(
          "#{content}:not(:has(#{slot("item-group")})):not([data-layout='list'][data-orientation='horizontal']),\n  #{item_group}",
          decls: [
            display: "flex",
            flex_direction: "column",
            align_items: "stretch",
            width: "100%",
            min_width: "0",
            background_color: {:color, :border},
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            overflow: "hidden",
            gap: "1px"
          ]
        ),
        Rule.new(item,
          decls: [
            include: :ui_item,
            display: "flex",
            width: "100%",
            align_self: "stretch",
            box_sizing: "border-box"
          ]
        ),
        Rule.new(
          "#{content}[data-layout='list'][data-orientation='horizontal']:not(:has(#{slot("item-group")})) > #{item}",
          decls: [flex: "0 0 auto", min_width: "max-content", width: "auto"]
        ),
        Rule.new(item_text,
          decls: [
            flex: "1 1 0%",
            min_width: "0",
            max_width: "100%",
            width: "auto",
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap",
            display: "flex",
            flex_direction: "row",
            align_items: "center",
            gap: {:space, :md},
            text_align: "start"
          ]
        ),
        Rule.new(
          "#{content}[data-layout='list'][data-orientation='horizontal']:not(:has(#{slot("item-group")})) > #{item} #{part("item-text")}",
          decls: [
            flex: "none",
            min_width: "auto",
            max_width: "none",
            overflow: "visible",
            text_overflow: "clip",
            white_space: "nowrap"
          ]
        ),
        Rule.new(item_indicator,
          decls: [
            display: "flex",
            align_items: "center",
            justify_content: "center",
            flex: "0 0 auto",
            flex_shrink: "0",
            min_width: "1em",
            min_height: "1em",
            margin_inline_start: "auto"
          ]
        ),
        Rule.new("#{item_indicator}[hidden]",
          decls: [display: "flex !important", visibility: "hidden"]
        ),
        Rule.new("#{item_indicator} [data-icon]",
          decls: [transition: "none !important"]
        ),
        Rule.new(
          "#{content}[dir='rtl'] #{item_indicator} [data-icon],\n  #{content} #{item}[dir='rtl'] > #{part("item-indicator")} [data-icon]",
          decls: [transform: "scaleX(-1) !important"]
        ),
        Rule.new("#{content}[dir='rtl'] #{item}", decls: [border_radius: "0"])
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = if(size == :md, do: :base, else: size)
        block = RecipePresets.text_block(text)

        {size,
         [
           host: %{width: "100%"},
           root: %{width: "100%", gap: {:space, size}},
           label: block,
           item:
             Map.merge(block, %{
               min_height: {:size, size},
               padding_inline: {:space, size},
               gap: {:space, size}
             }),
           item_group_label:
             Map.merge(block, %{min_height: {:size, size}, padding_inline: {:space, size}})
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule Marquee do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "marquee"
    @id :marquee

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [
          root: %{width: "100%"},
          content: %{},
          edge: %{:"--edge-background" => {:color, :root}},
          item: %{}
        ],
        variants: [
          semantic: semantic_variants(),
          size: size_variants()
        ],
        default_variants: [],
        extra_rules: marquee_rules()
      )
    end

    defp semantic_variants do
      for role <- Axes.semantic_atoms() do
        {role, [edge: %{:"--edge-background" => {:color, role}}]}
      end
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        block = RecipePresets.size_block(size)
        {size, [item: Map.take(block, [:font_size, :line_height, :gap])]}
      end
    end

    defp marquee_rules do
      host = Selector.host(@id)
      root = Selector.part(@id, @scope, "root")
      content = Selector.part(@id, @scope, "content")
      edge = Selector.part(@id, @scope, "edge")

      [
        Rule.new("@keyframes marqueeX",
          children: [
            Rule.new("0%", decls: [transform: {:raw, "translateX(0%)"}]),
            Rule.new("100%",
              decls: [transform: {:raw, "translateX(var(--marquee-translate))"}]
            )
          ]
        ),
        Rule.new("@keyframes marqueeY",
          children: [
            Rule.new("0%", decls: [transform: {:raw, "translateY(0%)"}]),
            Rule.new("100%",
              decls: [transform: {:raw, "translateY(var(--marquee-translate))"}]
            )
          ]
        ),
        Rule.new("#{host}:not([data-loading])",
          decls: [
            opacity: 1,
            transition: {:raw, "opacity 2s ease"}
          ]
        ),
        Rule.new("#{host}[data-loading]", decls: [opacity: 0]),
        Rule.new("#{host}[data-loading] #{Selector.slot(@scope, "root")}",
          decls: [include: :ui_loading]
        ),
        Rule.new(root,
          children: [
            Rule.new("&[data-orientation=\"vertical\"]",
              decls: [height: {:raw, "calc(var(--size) * 6)"}]
            ),
            Rule.new("&[data-orientation=\"horizontal\"]",
              decls: [width: "100%", height: {:raw, "fit-content"}]
            ),
            Rule.new("&[data-paused], &[data-paused] *",
              decls: [{:raw, "animation-play-state: paused !important"}]
            )
          ]
        ),
        Rule.new(content,
          decls: [
            {:raw, "animation-timing-function: linear;"},
            {:raw, "animation-duration: var(--marquee-duration);"},
            {:raw, "animation-delay: var(--marquee-delay);"},
            {:raw, "animation-iteration-count: var(--marquee-loop-count);"}
          ],
          children: [
            Rule.new("&[data-side=\"start\"], &[data-side=\"end\"]",
              decls: [{:raw, "animation-name: marqueeX;"}]
            ),
            Rule.new("&[data-side=\"top\"], &[data-side=\"bottom\"]",
              decls: [{:raw, "animation-name: marqueeY;"}]
            ),
            Rule.new("&[data-reverse]", decls: [{:raw, "animation-direction: reverse;"}]),
            Rule.new("@media (prefers-reduced-motion: reduce)",
              decls: [{:raw, "animation: none !important"}]
            )
          ]
        ),
        Rule.new(edge,
          decls: [z_index: 10],
          children: edge_side_rules()
        )
      ] ++ size_root_rules()
    end

    defp size_root_rules do
      root = Selector.slot(@scope, "root")

      for size <- Axes.size_atoms() do
        Rule.new("#{Palette.host_size_mod(@id, size)} #{root}[data-orientation=\"vertical\"]",
          decls: [height: {:raw, "calc(var(--size-#{size}) * 6)"}]
        )
      end
    end

    defp edge_side_rules do
      [
        Rule.new("&[data-side=\"start\"]",
          decls: [
            width: "20%",
            background: {:raw, "linear-gradient(to right, var(--edge-background), transparent)"}
          ],
          children: [
            Rule.new("&[dir=\"rtl\"]",
              decls: [
                background:
                  {:raw, "linear-gradient(to left, var(--edge-background), transparent)"}
              ]
            )
          ]
        ),
        Rule.new("&[data-side=\"end\"]",
          decls: [
            width: "20%",
            background: {:raw, "linear-gradient(to left, var(--edge-background), transparent)"}
          ],
          children: [
            Rule.new("&[dir=\"rtl\"]",
              decls: [
                background:
                  {:raw, "linear-gradient(to right, var(--edge-background), transparent)"}
              ]
            )
          ]
        ),
        Rule.new("&[data-side=\"top\"]",
          decls: [
            height: "20%",
            background: {:raw, "linear-gradient(to bottom, var(--edge-background), transparent)"}
          ]
        ),
        Rule.new("&[data-side=\"bottom\"]",
          decls: [
            height: "20%",
            background: {:raw, "linear-gradient(to top, var(--edge-background), transparent)"}
          ]
        )
      ]
    end
  end

  defmodule Menu do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Emit.Tokens, as: Var
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "menu"
    @id :menu

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_item_rules() ++ indicator_rules()
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp semantic_item_rules do
      item = slot("item")
      trigger_item = slot("trigger-item")
      item_text = slot("item-text")
      selected = ["[data-selected]", "[data-state='checked']"]

      item_rules =
        SemanticStates.active_part_rules(@id, item, selected, highlighted: true) ++
          SemanticStates.active_part_rules(@id, trigger_item, selected, highlighted: true)

      text_rules =
        for role <- Palette.color_atoms() do
          host = ".#{Selector.class_name(@id)}.#{Selector.class_name(@id)}--semantic-#{role}"

          [
            Rule.new("#{host} #{item}[data-state='checked'] #{item_text}",
              decls: [color: "inherit"]
            ),
            Rule.new("#{host} #{trigger_item}[data-state='checked'] #{item_text}",
              decls: [color: "inherit"]
            )
          ]
        end
        |> List.flatten()

      item_rules ++ text_rules
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      content = part("content")
      trigger = part("trigger")
      context_trigger = part("context-trigger")
      separator = part("separator")
      item_group = part("item-group")
      item_group_label = part("item-group-label")
      item = part("item")
      trigger_item = part("trigger-item")
      item_text = "#{content} #{slot("item-text")}"
      item_indicator = "#{content} #{slot("item-indicator")}"

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(content,
          decls: [
            include: :ui_content,
            border: {:raw, "1px solid var(--color-border)"},
            z_index: "50",
            padding: "0",
            border_radius: {:radius, :md},
            overflow: "hidden",
            box_shadow: {:raw, "var(--shadow-ui)"}
          ],
          children: [
            Rule.new("&:focus-visible", decls: [outline: "none"])
          ]
        ),
        Rule.new(trigger,
          decls: [
            include: :ui_trigger,
            justify_content: "space-between",
            width: "100%",
            border: "none",
            min_width: {:raw, "var(--container-7xs)"}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "margin-inline-end: #{Var.ref([:space, :md])}"}])
          ]
        ),
        Rule.new("#{trigger} > :not(#{slot("indicator")})",
          decls: [
            flex: "1 1 0%",
            min_width: "0",
            text_align: "start",
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap"
          ]
        ),
        Rule.new("#{trigger} > #{slot("indicator")}", decls: [flex_shrink: "0"]),
        Rule.new(context_trigger,
          decls: [
            include: :ui_trigger,
            border: {:raw, "1px dashed var(--color-border)"},
            cursor: "context-menu"
          ]
        ),
        Rule.new(separator,
          decls: [height: "1px", width: "100%", background: {:color, :border}]
        ),
        Rule.new(item_group,
          decls: [display: "flex", flex_direction: "column", background_color: "transparent"]
        ),
        Rule.new(item_group_label,
          decls: [
            display: "flex",
            align_items: "center",
            font_size: {:text, :base},
            line_height: {:leading, :base},
            text_align: "start",
            min_height: {:size, :md},
            padding_inline: {:space, :md},
            background_color: {:color, :root},
            color: {:color, :ui_ink},
            border_bottom: {:raw, "1px solid var(--color-border)"},
            cursor: "default",
            pointer_events: "none"
          ]
        ),
        Rule.new(
          "#{item_group}:not(:first-child) #{slot("item-group-label")}",
          decls: [
            border_top: {:raw, "1px solid var(--color-border)"},
            box_shadow: {:raw, "var(--shadow-ui)"}
          ]
        ),
        Rule.new(item, decls: [include: :ui_item, min_width: "0"]),
        Rule.new(trigger_item, decls: [include: :ui_item, min_width: "0"]),
        Rule.new(
          "#{item} > #{slot("item-indicator")}, #{trigger_item} > #{slot("item-indicator")}",
          decls:
            Map.to_list(RecipePresets.item_row_indicator()) ++ [transition: "none !important"]
        ),
        Rule.new(item_text, decls: Map.to_list(RecipePresets.item_row_text())),
        Rule.new("#{item_text} > [data-icon]",
          decls: [margin_inline_start: "auto", flex_shrink: "0"]
        ),
        Rule.new(item_indicator,
          decls: Map.to_list(RecipePresets.item_row_indicator()) ++ [include: :ui_icon]
        ),
        Rule.new("#{content} #{slot("trigger-item")}",
          decls: [justify_content: "flex-start", width: "100%", min_width: "0"]
        ),
        Rule.new(
          "#{content} #{item}:has(> div:has([data-nested='menu'])),\n  #{content} #{trigger_item}:has(> div:has([data-nested='menu']))",
          decls: [position: "relative"]
        ),
        Rule.new(
          "#{content}:not([dir='rtl']) #{item} > div:has([data-nested='menu']),\n  #{content}:not([dir='rtl']) #{trigger_item} > div:has([data-nested='menu'])",
          decls: [
            position: "absolute",
            inset_inline_end: "0",
            inset_inline_start: "auto",
            top: "0",
            bottom: "0",
            width: "0",
            min_width: "0",
            overflow: "visible",
            pointer_events: "none"
          ]
        ),
        Rule.new(
          "#{content}[dir='rtl'] #{item} > div:has([data-nested='menu']),\n  #{content}[dir='rtl'] #{trigger_item} > div:has([data-nested='menu'])",
          decls: [
            position: "absolute",
            inset_inline_start: "0",
            inset_inline_end: "auto",
            top: "0",
            bottom: "0",
            width: "0",
            min_width: "0",
            overflow: "visible",
            pointer_events: "none"
          ]
        ),
        Rule.new(
          "#{content} #{item} > div:has([data-nested='menu']) *,\n  #{content} #{trigger_item} > div:has([data-nested='menu']) *",
          decls: [pointer_events: "auto"]
        )
      ]
    end

    defp indicator_rules do
      content = part("content")
      indicator = part("indicator")
      item_indicator = slot("item-indicator")

      no_transform =
        "#{content} #{item_indicator},\n  #{content} #{item_indicator} [data-icon],\n  #{part("item")} > #{item_indicator},\n  #{part("trigger-item")} > #{item_indicator},\n  #{part("item")}[data-state='open'] > #{item_indicator},\n  #{indicator}[data-state='open'],\n  #{content} #{part("trigger-item")}[data-state='open'] > #{item_indicator}"

      [
        Rule.new("#{indicator} [data-icon], #{no_transform}",
          decls: [transition: "none !important", transform: "none !important"]
        ),
        Rule.new(
          "#{content}[dir='rtl'] #{item_indicator} [data-icon],\n  #{content} #{part("item")}[dir='rtl'] > #{item_indicator} [data-icon],\n  #{content} #{part("trigger-item")}[dir='rtl'] > #{item_indicator} [data-icon],\n  #{content} #{item_indicator}[dir='rtl'] [data-icon]",
          decls: [transform: "scaleX(-1) !important"]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = if(size == :md, do: :base, else: size)
        block = RecipePresets.text_block(text)

        {size,
         [
           content: %{border_color: {:color, :border}},
           trigger:
             Map.merge(block, %{
               padding_inline: {:space, size},
               gap: {:space, size},
               min_height: {:size, size}
             }),
           item: Map.merge(block, %{padding_inline: {:space, size}}),
           trigger_item: Map.merge(block, %{padding_inline: {:space, size}}),
           item_group_label: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule NativeInput do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "native-input"
    @id :native_input

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"4xl", height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          input: %{},
          icon: %{},
          error: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: native_input_rules() ++ semantic_input_rules()
      )
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}, max_width: {:container, size}},
           label: RecipePresets.text_block(text),
           input:
             Map.merge(RecipePresets.text_block(text), %{
               padding_inline: {:space, size},
               min_height: {:size, size},
               background_color: {:color, :ui},
               color: {:color, :ui_ink},
               border_color: {:color, :border}
             })
         ]}
      end
    end

    defp radius_variants do
      for radius <- Axes.radius_atoms(),
          do: {radius, [input: RecipePresets.rounded_block(radius)]}
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp native_input_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      control = Selector.part(id, scope, "control")
      input = Selector.part(id, scope, "input")
      icon = Selector.part(id, scope, "icon")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(control,
            decls: [
              display: "flex",
              flex_flow: "row nowrap",
              align_items: "stretch",
              position: "relative",
              width: "100%",
              min_width: "0"
            ]
          ),
          Rule.new(input, decls: [include: :ui_input, flex: "1 1 auto", min_width: "0"]),
          Rule.new(icon,
            decls: [
              position: "absolute",
              top: "0",
              bottom: "0",
              left: "0",
              width: "var(--size)",
              display: "flex",
              align_items: "center",
              justify_content: "center",
              padding_inline: "var(--space)",
              pointer_events: "none"
            ],
            children: [
              Rule.new(~S(& [data-icon],\n  & svg), decls: [include: :ui_icon])
            ]
          ),
          Rule.new("#{host}[data-no-icon] #{input}",
            decls: [padding_inline_start: "var(--space)"]
          ),
          Rule.new("#{host}:not([data-no-icon]) #{input}",
            decls: [padding_inline_start: "var(--size)"]
          )
        ]
    end

    defp semantic_input_rules do
      input = Selector.slot(@scope, "input")
      Palette.semantic_focus_rules(@id, input)
    end
  end

  defmodule NumberInput do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "number-input"
    @id :number_input

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :none, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          input: %{},
          increment_trigger: %{},
          decrement_trigger: %{},
          error: %{},
          trigger_group: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: number_input_rules() ++ semantic_input_rules()
      )
    end

    defp number_input_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      control = Selector.part(id, scope, "control")
      input = Selector.part(id, scope, "input")
      trigger_group = ~s(#{host} [data-part="trigger-group"])
      increment = Selector.part(id, scope, "increment-trigger")
      decrement = Selector.part(id, scope, "decrement-trigger")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host,
            decls: [
              width: "100%",
              max_width: {:raw, "var(--container-5xs)"},
              min_width: "0",
              box_sizing: "border-box"
            ]
          ),
          Rule.new(control,
            decls: [
              display: "flex",
              flex_flow: "row nowrap",
              align_items: "stretch",
              position: "relative",
              width: "100%"
            ]
          ),
          Rule.new(input,
            decls: [
              include: :ui_input,
              flex: "1",
              min_width: "0",
              min_height: {:size, :md},
              max_height: {:size, :md},
              box_sizing: "border-box"
            ],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "border-inline-end: 0; border-end-end-radius: 0; border-start-end-radius: 0"}
                ]
              )
            ]
          ),
          Rule.new(trigger_group,
            decls: [
              display: "flex",
              flex_direction: "column",
              flex_shrink: "0",
              gap: "0",
              width: {:size, :md},
              min_height: {:size, :md},
              height: {:size, :md},
              max_height: {:size, :md},
              box_sizing: "border-box"
            ]
          ),
          Rule.new(increment,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              flex: "1",
              min_height: "0",
              margin: "0",
              padding: "0",
              width: "fit-content",
              padding_inline: {:space, :md}
            ],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "border-start-start-radius: 0; border-end-start-radius: 0; border-end-end-radius: 0; border-block-end: 0"}
                ]
              )
            ]
          ),
          Rule.new(decrement,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              flex: "1",
              min_height: "0",
              margin: "0",
              padding: "0",
              width: "fit-content",
              padding_inline: {:space, :md}
            ],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "border-start-start-radius: 0; border-end-start-radius: 0; border-start-end-radius: 0; border-block-start: 0"}
                ]
              )
            ]
          )
        ]
    end

    defp semantic_input_rules do
      input = Selector.slot(@scope, "input")

      Palette.semantic_focus_rules(@id, input) ++
        Palette.semantic_ink_part_rules(@id, Selector.slot(@scope, "increment-trigger")) ++
        Palette.semantic_ink_part_rules(@id, Selector.slot(@scope, "decrement-trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           trigger_group: %{
             width: {:size, size},
             min_height: {:size, size},
             height: {:size, size},
             max_height: {:size, size}
           },
           input:
             Map.merge(RecipePresets.text_block(text), %{
               min_height: {:size, size},
               max_height: {:size, size},
               padding_inline: {:space, size},
               background_color: {:color, :ui},
               color: {:color, :ui_ink}
             }),
           increment_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               background_color: {:color, :ui},
               color: {:color, :ui_ink},
               min_height: {:raw, "calc(var(--size-#{size}) / 2)"}
             }),
           decrement_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               background_color: {:color, :ui},
               color: {:color, :ui_ink},
               min_height: {:raw, "calc(var(--size-#{size}) / 2)"}
             })
         ]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for radius <- Axes.radius_atoms(),
          do: {radius, [input: RecipePresets.rounded_block(radius)]}
    end
  end

  defmodule Pagination do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "pagination"
    @id :pagination

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :fit, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_item_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      prev = part("prev-trigger")
      next = part("next-trigger")
      item = part("item")
      ellipsis = part("ellipsis")
      list = ~s(#{root} ul)

      [
        Rule.new(host, decls: [width: "fit-content", max_width: {:container, :md}]),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(root,
          decls: [include: :ui_root, width: "fit-content", max_width: "100%"]
        ),
        Rule.new(list,
          decls: [
            display: "flex",
            flex_direction: "row",
            align_items: "center",
            gap: {:space, :md},
            list_style: "none",
            margin: "0",
            padding: "0",
            padding_inline: {:space, :md},
            overflow_x: "auto",
            width: "100%",
            max_width: "100%"
          ],
          children: RecipePresets.scrollbar_sm_children()
        ),
        Rule.new(prev,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            min_width: {:raw, "calc(var(--size-md) * 0.8)"},
            min_height: {:raw, "calc(var(--size-md) * 0.8)"},
            font_size: {:raw, "calc(var(--text-base) * 0.8)"},
            line_height: {:raw, "calc(var(--text-base--line-height) * 0.8)"},
            padding: "0"
          ]
        ),
        Rule.new(next,
          decls: [
            include: :ui_trigger,
            aspect_ratio: {:raw, "1 / 1"},
            padding: 0,
            justify_content: :center,
            width: :auto,
            min_width: {:raw, "calc(var(--size-md) * 0.8)"},
            min_height: {:raw, "calc(var(--size-md) * 0.8)"},
            font_size: {:raw, "calc(var(--text-base) * 0.8)"},
            line_height: {:raw, "calc(var(--text-base--line-height) * 0.8)"},
            padding: "0"
          ]
        ),
        Rule.new(item,
          decls: [
            include: :ui_item,
            width: "auto",
            max_width: "none",
            min_width: {:size, :md},
            min_height: {:size, :md},
            padding_inline: {:space, :sm},
            justify_content: "center",
            border_radius: {:radius, :md}
          ]
        ),
        Rule.new(ellipsis,
          decls: [
            display: "inline-flex",
            align_items: "center",
            justify_content: "center",
            min_width: {:size, :md},
            min_height: {:size, :md},
            color: {:color, :ui_ink_muted},
            pointer_events: "none",
            cursor: "default"
          ]
        ),
        Rule.new("#{prev}[data-disabled],\n  #{next}[data-disabled]",
          decls: [opacity: "0.5", cursor: "not-allowed", pointer_events: "none"]
        )
      ]
    end

    defp semantic_item_rules do
      item = part("item")
      selected = "#{item}[data-selected],\n  #{item}[aria-current=\"page\"]"

      SemanticStates.active_selector_rules(@id, selected)
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           item:
             Map.merge(RecipePresets.text_block(text), %{
               min_height: {:size, size},
               min_width: {:size, size},
               padding_inline: {:space, size}
             }),
           ellipsis:
             Map.merge(RecipePresets.text_block(text), %{
               min_height: {:size, size},
               min_width: {:size, size},
               color: {:color, :ui_ink}
             }),
           prev_trigger: nav_trigger_size(size, text),
           next_trigger: nav_trigger_size(size, text)
         ]}
      end
    end

    defp nav_trigger_size(size, text) do
      %{
        font_size: {:raw, "calc(var(--text-#{text}) * 0.8)"},
        line_height: {:raw, "calc(var(--text-#{text}--line-height) * 0.8)"},
        min_height: {:raw, "calc(var(--size-#{size}) * 0.8)"},
        min_width: {:raw, "calc(var(--size-#{size}) * 0.8)"}
      }
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r,
             [
               prev_trigger: RecipePresets.rounded_block(r),
               next_trigger: RecipePresets.rounded_block(r),
               item: RecipePresets.rounded_block(r)
             ]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule PasswordInput do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "password-input"
    @id :password_input

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :xs, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          input: %{},
          visibility_trigger: %{},
          indicator: %{},
          error: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: password_input_rules() ++ semantic_input_rules()
      )
    end

    defp password_input_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      control = Selector.part(id, scope, "control")
      input = Selector.part(id, scope, "input")
      visibility = Selector.part(id, scope, "visibility-trigger")
      indicator = Selector.part(id, scope, "indicator")
      error = Selector.part(id, scope, "error")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host, decls: [width: "100%", max_width: {:container, :xs}]),
          Rule.new(control,
            decls: [
              display: "flex",
              flex_flow: "row nowrap",
              align_items: "stretch",
              position: "relative"
            ]
          ),
          Rule.new(input,
            decls: [
              include: :ui_input,
              flex: "1"
            ],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "border-inline-end: 1px solid transparent; border-end-end-radius: 0; border-start-end-radius: 0"}
                ]
              ),
              Rule.new("&[data-invalid]",
                decls: [{:raw, "border-inline-end-color: var(--color-alert)"}]
              )
            ]
          ),
          Rule.new("#{input}[data-invalid] + #{visibility}",
            decls: [border_color: {:color, :alert}, box_shadow: "none"]
          ),
          Rule.new("#{host}[data-no-icon] #{input}",
            decls: [border: {:raw, "1px solid var(--color-border)"}],
            children: [
              Rule.new("&",
                decls: [
                  {:raw,
                   "border-end-end-radius: var(--radius-md); border-start-end-radius: var(--radius-md)"}
                ]
              )
            ]
          ),
          Rule.new("#{indicator}[data-state=\"visible\"] [data-hidden]",
            decls: [display: "none"]
          ),
          Rule.new("#{indicator}[data-state=\"hidden\"] [data-visible]",
            decls: [display: "none"]
          ),
          Rule.new(visibility,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              display: "flex",
              align_items: "center",
              justify_content: "center",
              min_width: {:size, :md}
            ],
            children: [
              Rule.new("&",
                decls: [{:raw, "border-start-start-radius: 0; border-end-start-radius: 0"}]
              ),
              Rule.new(" #{indicator}",
                decls: [
                  display: "flex",
                  align_items: "center",
                  justify_content: "center"
                ]
              )
            ]
          ),
          Rule.new("#{error}.absolute", decls: [padding_block: "0", display: "block"])
        ]
    end

    defp semantic_input_rules do
      input = Selector.slot(@scope, "input")
      Palette.semantic_focus_rules(@id, input)
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           control: %{max_width: {:container, size}},
           input:
             Map.merge(RecipePresets.text_block(text), %{
               min_height: {:size, size},
               max_height: {:size, size},
               padding_inline: {:space, size},
               background_color: {:color, :ui},
               color: {:color, :ui_ink}
             }),
           visibility_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               min_width: {:size, size},
               min_height: {:size, size},
               max_height: {:size, size},
               background_color: {:color, :ui},
               color: {:color, :ui_ink}
             })
         ]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for radius <- Axes.radius_atoms(),
          do: {radius, [input: RecipePresets.rounded_block(radius)]}
    end
  end

  defmodule PinInput do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "pin-input"
    @id :pin_input

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :auto, max_width: :md, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          input: %{},
          error: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: pin_input_rules() ++ semantic_input_rules()
      )
    end

    defp pin_input_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      root = Selector.part(id, scope, "root")
      label = Selector.part(id, scope, "label")
      control = Selector.part(id, scope, "control")
      input = Selector.part(id, scope, "input")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host, decls: [width: "auto", max_width: {:container, :md}]),
          Rule.new(root,
            decls: [gap: {:space, :md}, position: "relative", padding_inline_end: {:space, :md}],
            children: [
              Rule.new("&[data-disabled]", decls: [opacity: "0.6", pointer_events: "none"])
            ]
          ),
          Rule.new(label,
            children: [
              Rule.new("&[data-invalid]", decls: [color: {:color, :ui_ink_alert}]),
              Rule.new("&[data-disabled]", decls: [color: {:color, :ui_ink_muted}]),
              Rule.new("&[data-complete]", decls: [color: {:color, :ui_ink_success}]),
              Rule.new("&[data-readonly]", decls: [color: {:color, :ui_ink_muted}])
            ]
          ),
          Rule.new(control,
            decls: [
              display: "flex",
              flex_flow: "row nowrap",
              gap: {:space, :md},
              align_items: "center",
              justify_content: "flex-start"
            ]
          ),
          Rule.new(input,
            decls: [
              include: :ui_input,
              height: {:size, :md},
              width: {:size, :md},
              flex_shrink: "0",
              text_align: "center",
              padding_inline: "0"
            ],
            children: [
              Rule.new("&:focus",
                decls: [
                  background_color: {:color, :root},
                  outline: "none",
                  box_shadow: "inset 0 0 0 2px var(--color-ui-ink)"
                ]
              ),
              Rule.new("&[data-filled]:not([data-complete])",
                decls: [background_color: {:color, :ui_hover}]
              ),
              Rule.new("&[data-complete]",
                decls: [
                  color: {:color, :ui_ink},
                  background_color: {:color, :ui},
                  border_color: {:color, :success},
                  box_shadow: "none"
                ],
                children: [
                  Rule.new("&:focus",
                    decls: [box_shadow: "inset 0 0 0 2px var(--color-success)"]
                  )
                ]
              ),
              Rule.new("&[data-invalid]",
                decls: [
                  color: {:color, :ui_ink},
                  background_color: {:color, :ui},
                  border_color: {:color, :alert},
                  box_shadow: "none"
                ],
                children: [
                  Rule.new("&:focus",
                    decls: [box_shadow: "inset 0 0 0 2px var(--color-alert)", outline: "none"]
                  )
                ]
              ),
              Rule.new("&[data-disabled]",
                decls: [
                  color: {:color, :ui_ink_muted},
                  background_color: {:color, :ui_muted},
                  cursor: "not-allowed"
                ]
              )
            ]
          )
        ]
    end

    defp semantic_input_rules do
      input = Selector.slot(@scope, "input")
      Palette.semantic_focus_rules(@id, input, complete: true)
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           control: %{gap: {:space, size}},
           input:
             Map.merge(RecipePresets.text_block(text), %{
               height: {:size, size},
               width: {:size, size}
             })
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [input: RecipePresets.rounded_block(r)]}
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule RadioGroup do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "radio-group"
    @id :radio_group

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :fit, max_width: :md, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          item: %{},
          item_text: %{},
          item_control: %{},
          error: %{}
        ],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: radio_group_rules()
      )
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, [host: Palette.selected_host_sx(color)]}
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        block = %{
          height: {:raw, "calc(var(--size) * 0.6)"},
          width: {:raw, "calc(var(--size) * 0.6)"},
          padding: {:raw, "calc(var(--space) * 0.25)"},
          font_size: {:text, size_text(size)},
          line_height: {:leading, size_text(size)}
        }

        {size, [item_control: block, item_text: RecipePresets.text_block(size_text(size))]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [item_control: RecipePresets.rounded_block(r)]}
    end

    defp radio_group_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      item = Selector.part(id, scope, "item")
      item_text = Selector.part(id, scope, "item-text")
      item_control = Selector.part(id, scope, "item-control")
      item_control_slot = Selector.slot(scope, "item-control")

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(item,
            decls: [
              display: "flex",
              align_items: "center",
              position: "relative",
              width: "100%",
              gap: "var(--space)",
              cursor: "pointer"
            ],
            children: [
              Rule.new("&[data-disabled]", decls: [cursor: "not-allowed"])
            ]
          ),
          Rule.new(item_text,
            decls: [flex: "1 1 auto", min_width: "0", text_align: "start"]
          ),
          Rule.new(item_control,
            decls: [
              flex_shrink: "0",
              margin_inline_start: "auto",
              height: "calc(var(--size) * 0.6)",
              width: "calc(var(--size) * 0.6)",
              background: "var(--color-ui)",
              color: "var(--color-ui-ink)",
              font_weight: "var(--font-weight-normal)",
              border_radius: "var(--radius-full)",
              border: "1px solid var(--color-border)",
              display: "flex",
              align_items: "center",
              justify_content: "center",
              cursor: "pointer",
              padding: "calc(var(--space) * 0.25)"
            ],
            children: [
              Rule.new("&[data-state=\"checked\"]",
                decls: [
                  background: "var(--color-selected)",
                  color: "var(--color-selected-ink)",
                  border_color: "var(--color-selected)"
                ],
                children: [
                  Rule.new("&:hover", decls: [background_color: "var(--color-selected-hover)"]),
                  Rule.new("&:active", decls: [background_color: "var(--color-selected-active)"])
                ]
              ),
              Rule.new("&[data-state=\"unchecked\"]",
                decls: [
                  background: "var(--color-ui)",
                  color: "var(--color-ui-ink)",
                  border_color: "var(--color-border)"
                ],
                children: [
                  Rule.new("&:hover", decls: [background_color: "var(--color-ui-hover)"]),
                  Rule.new("&:active", decls: [background_color: "var(--color-ui-active)"])
                ]
              ),
              Rule.new("&:focus-visible,\n  &[data-focus]",
                decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--color-ui-ink)"]
              ),
              Rule.new(
                ~S(&[data-state="checked"]:focus-visible,\n  &[data-state="checked"][data-focus]),
                decls: [box_shadow: "inset 0 0 0 2px var(--color-selected-ink)"]
              ),
              Rule.new("&[data-invalid]", decls: [border_color: "var(--color-alert)"])
            ]
          ),
          Rule.new("#{item_control} .data-checked", decls: [display: "none"]),
          Rule.new(
            ~s(#{host} #{item_control_slot}[data-state="checked"] .data-checked),
            decls: [
              display: "block",
              color: "inherit",
              width: "60%",
              height: "60%"
            ]
          )
        ]
    end
  end

  defmodule Select do
    @moduledoc """
    Slot recipe for `data-select`. Variant axes target explicit parts only:

    * `color` — host (`--color-selected-*` tokens)
    * `visual` — trigger (`ghost`)
    * `size` — root, label, control, trigger, item, item_indicator, item_group_label
    * `text` — label, trigger, item, item_group_label
    * `rounded` — trigger only; content panel keeps base `md` radius
    """

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector
    alias Corex.Design.Style

    @scope "select"

    def recipe do
      Recipe.part_recipe(:select,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"4xs", height: :auto, max_height: :none],
        base: base_slots(),
        variants: [
          semantic: semantic_variants(),
          variant: [ghost: [trigger: ghost_trigger()]],
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: select_extra_rules()
      )
    end

    defp base_slots do
      [
        host: %{},
        root: %{
          display: :flex,
          flex_direction: :column,
          width: "100%",
          gap: {:space, :md},
          position: :relative,
          padding_inline_end: {:space, :md}
        },
        label: %{
          display: :flex,
          align_items: :center,
          justify_content: :start,
          text_align: :start,
          width: :auto,
          font_size: {:text, :base},
          line_height: {:leading, :base},
          font_weight: :medium,
          color: {:color, :ui_ink}
        },
        control: %{
          display: :flex,
          flex_direction: :row,
          align_items: :center,
          width: "100%",
          min_width: 0,
          position: :relative
        },
        indicator: RecipePresets.trigger_indicator_part(),
        trigger:
          Style.merge_many([
            RecipePresets.trigger_base(),
            %{
              flex: {:raw, "1 1 0%"},
              justify_content: :space_between,
              width: "100%",
              min_width: 0,
              max_width: "100%",
              border: {:raw, "1px solid var(--color-border)"},
              background_color: {:color, :ui},
              color: {:color, :ui_ink},
              border_radius: {:radius, :md},
              min_height: {:size, :md},
              padding_inline: {:space, :md},
              font_size: {:text, :base},
              line_height: {:leading, :base},
              hover: %{background_color: {:color, :ui_hover}},
              active: %{background_color: {:color, :ui_active}},
              focus_visible: %{
                outline: :none,
                box_shadow: RecipePresets.inset_ring(:focus_ring)
              },
              open: trigger_open_sx(),
              disabled:
                RecipePresets.lock_disabled_interaction(%{
                  color: {:color, :ui_ink_muted},
                  background_color: {:color, :ui_muted},
                  cursor: :not_allowed,
                  box_shadow: :none
                }),
              invalid: %{border_color: {:color, :alert}, box_shadow: :none}
            }
          ]),
        positioner: %{position: :relative},
        content: content_sx(),
        item_group: %{display: :flex, flex_direction: :column},
        item_group_label: %{
          display: :flex,
          align_items: :center,
          justify_content: :start,
          text_align: :start,
          width: :auto,
          font_size: {:text, :base},
          line_height: {:leading, :base},
          font_weight: :medium,
          color: {:color, :ui_ink},
          background_color: {:color, :root},
          border_bottom: {:raw, "1px solid var(--color-border)"},
          border_top: {:raw, "1px solid var(--color-border)"},
          box_shadow: {:shadow, :md},
          padding_inline_start: {:space, :md}
        },
        item: item_sx(),
        item_indicator: RecipePresets.trigger_indicator_part(),
        error: %{
          display: :inline_flex,
          align_items: :center,
          justify_content: :start,
          text_align: :start,
          width: :auto,
          font_size: {:text, :sm},
          line_height: {:leading, :sm},
          font_weight: :normal,
          gap: {:raw, "0.25rem"},
          color: {:color, :ui_ink_alert},
          padding_block: {:space, :md}
        }
      ]
    end

    defp item_sx do
      %{
        width: "100%",
        display: :inline_flex,
        align_items: :center,
        text_align: :start,
        cursor: :pointer,
        font_size: {:text, :base},
        line_height: {:leading, :base},
        font_weight: :normal,
        min_height: {:size, :md},
        padding_inline: {:space, :md},
        gap: {:space, :md},
        background_color: {:color, :ui},
        color: {:color, :ui_ink},
        border_radius: {:radius, :none},
        outline: :none,
        transition:
          {:raw, "background-color 120ms ease, color 120ms ease, box-shadow 120ms ease"},
        hover: %{background_color: {:color, :ui_hover}},
        active: %{background_color: {:color, :ui_active}, box_shadow: :none},
        focus_visible: %{
          outline: :none,
          box_shadow: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"},
          background_color: {:color, :ui_hover}
        },
        selected: %{
          background_color: {:color, :selected},
          color: {:color, :selected_ink},
          hover: %{
            background_color: {:color, :selected_hover},
            color: {:color, :selected_ink}
          },
          active: %{
            background_color: {:color, :selected_active},
            color: {:color, :selected_ink},
            box_shadow: :none
          },
          focus_visible: %{
            background_color: {:color, :selected_hover},
            color: {:color, :selected_ink},
            box_shadow: {:raw, "inset 0 0 0 2px var(--color-selected-ink)"},
            outline: :none
          },
          highlighted: %{
            background_color: {:color, :selected_hover},
            color: {:color, :selected_ink}
          }
        },
        disabled:
          RecipePresets.lock_disabled_interaction(%{
            color: {:color, :ui_ink_muted},
            background_color: {:color, :ui_muted},
            cursor: :not_allowed,
            box_shadow: :none
          })
      }
    end

    defp content_sx do
      %{
        display: :flex,
        flex_direction: :column,
        width: "100%",
        padding: 0,
        list_style: :none,
        border_radius: {:radius, :md},
        border: {:raw, "1px solid var(--color-border)"},
        background_color: {:color, :root},
        color: {:color, :ui_ink},
        box_shadow: {:shadow, :md},
        z_index: 50,
        overflow: :hidden,
        isolation: :isolate,
        focus_visible: %{outline: :none}
      }
    end

    defp ghost_trigger do
      %{
        background_color: :transparent,
        border_color: :transparent,
        hover: %{background_color: {:color, :ui_hover}},
        open: trigger_open_sx(),
        focus_visible: %{
          outline: :none,
          box_shadow: RecipePresets.inset_ring(:focus_ring)
        }
      }
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, [host: Palette.selected_host_sx(color)]}
    end

    defp select_extra_rules do
      host = Selector.host(:select)
      root = Selector.part(:select, @scope, "root")
      control = Selector.part(:select, @scope, "control")
      content = Selector.part(:select, @scope, "content")
      error = Selector.part(:select, @scope, "error")
      trigger = ~S(.select [data-scope="select"][data-part="trigger"])
      item_text = RecipePresets.item_text()

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new("#{root}[data-readonly]", decls: [include: :ui_readonly]),
        Rule.new(
          control,
          children: [
            Rule.new("&[data-focus]:focus-visible",
              decls: [outline: :none, box_shadow: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"}]
            ),
            Rule.new("&[data-invalid][data-focus],\n  &[data-invalid][data-focus]:focus-visible",
              decls: [box_shadow: :none]
            )
          ]
        ),
        Rule.new(
          ~s(#{content} [data-part="item"]),
          decls: [{:raw, "border-radius: var(--radius-none) !important"}]
        ),
        Rule.new(
          ~s(#{content} > [data-part="item"]:first-child),
          decls: [
            {:raw, "border-top-left-radius: var(--radius-md) !important"},
            {:raw, "border-top-right-radius: var(--radius-md) !important"},
            {:raw, "border-bottom-left-radius: var(--radius-none) !important"},
            {:raw, "border-bottom-right-radius: var(--radius-none) !important"}
          ]
        ),
        Rule.new(
          ~s(#{content} > [data-part="item"]:last-child),
          decls: [
            {:raw, "border-bottom-left-radius: var(--radius-md) !important"},
            {:raw, "border-bottom-right-radius: var(--radius-md) !important"},
            {:raw, "border-top-left-radius: var(--radius-none) !important"},
            {:raw, "border-top-right-radius: var(--radius-none) !important"}
          ]
        ),
        Rule.new(
          ~s(#{content} > [data-part="item-group"]:last-child [data-part="item"]:last-child),
          decls: [
            {:raw, "border-bottom-left-radius: var(--radius-md) !important"},
            {:raw, "border-bottom-right-radius: var(--radius-md) !important"}
          ]
        ),
        Rule.new(
          ~s(#{error}.absolute),
          decls: [padding_block: 0, display: :block]
        ),
        Rule.new(
          ~s(#{trigger} > [data-part="item-text"]),
          decls: Map.to_list(item_text)
        ),
        Rule.new(
          ~s(#{trigger} > [data-scope="select"][data-part="indicator"]),
          decls: Map.to_list(RecipePresets.trigger_indicator_part())
        ),
        Rule.new(
          ~s(#{trigger} > [data-icon]),
          decls: [include: :ui_icon]
        ),
        Rule.new(
          ~s(#{trigger} svg),
          decls: [{:raw, "fill: currentColor"}]
        ),
        Rule.new(
          ~s(#{trigger} > [data-part="indicator"] [data-icon]),
          decls: [include: :ui_icon]
        ),
        Rule.new(
          ~S(.select [data-scope="select"][data-part="item"] [data-part="item-text"]),
          decls: Map.to_list(item_text)
        ),
        Rule.new(
          ~S(.select [data-scope="select"][data-part="item"] [data-part="item-indicator"]),
          decls: [
            flex_shrink: {:raw, "0"},
            margin_inline_start: :auto,
            padding_inline_end: {:space, :md}
          ]
        ),
        Rule.new(
          ~S(.select [data-scope="select"][data-part="indicator"] [data-icon]),
          decls: [include: :ui_icon]
        ),
        Rule.new(
          ~S(.select [data-scope="select"][data-part="item-indicator"] [data-icon]),
          decls: [include: :ui_icon]
        )
      ] ++ item_highlight_rules()
    end

    defp item_highlight_rules do
      item = ~S(.select [data-scope="select"][data-part="item"])
      selected = &selected_item_selector/1

      [
        Rule.new("@media (hover: hover)",
          children: [
            Rule.new("#{item}[data-highlighted]:not(:hover)",
              decls: [
                outline: :none,
                box_shadow: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"},
                background_color: {:color, :ui_hover}
              ]
            ),
            Rule.new("#{item}[data-highlighted]:active",
              decls: [background_color: {:color, :ui_active}, box_shadow: :none]
            ),
            Rule.new(selected.("[data-highlighted]:not(:hover)"),
              decls: [
                background_color: {:color, :selected_hover},
                color: {:color, :selected_ink},
                box_shadow: {:raw, "inset 0 0 0 2px var(--color-selected-ink)"},
                outline: :none
              ]
            ),
            Rule.new(selected.("[data-highlighted]:hover"),
              decls: [
                background_color: {:color, :selected_hover},
                color: {:color, :selected_ink},
                box_shadow: :none,
                outline: :none
              ]
            ),
            Rule.new(selected.("[data-highlighted]:active"),
              decls: [
                background_color: {:color, :selected_active},
                color: {:color, :selected_ink},
                box_shadow: :none
              ]
            )
          ]
        ),
        Rule.new("@media (hover: none)",
          children: [
            Rule.new("#{item}[data-highlighted]",
              decls: [
                outline: :none,
                box_shadow: {:raw, "inset 0 0 0 2px var(--color-ui-ink)"},
                background_color: {:color, :ui_hover}
              ]
            ),
            Rule.new(selected.("[data-highlighted]"),
              decls: [
                background_color: {:color, :selected_hover},
                color: {:color, :selected_ink},
                box_shadow: {:raw, "inset 0 0 0 2px var(--color-selected-ink)"},
                outline: :none
              ]
            )
          ]
        )
      ]
    end

    defp selected_item_selector(suffix) do
      base = ~S(.select [data-scope="select"][data-part="item"])

      Enum.map_join(
        [
          "[data-selected]",
          ~S([data-state="checked"]),
          ~S([data-state="on"]),
          "[data-checked]",
          ~S([data-indeterminate])
        ],
        ",\n  ",
        &"#{base}#{&1}#{suffix}"
      )
    end

    defp trigger_open_sx do
      %{
        background_color: {:color, :selected},
        color: {:color, :selected_ink},
        hover: %{background_color: {:color, :selected_hover}},
        active: %{background_color: {:color, :selected_active}},
        focus_visible: %{
          outline: :none,
          box_shadow: {:raw, "inset 0 0 0 2px var(--color-selected-ink)"}
        }
      }
    end

    defp size_variants do
      for s <- Axes.size_atoms() do
        text = size_text(s)

        {s,
         [
           root: %{gap: {:space, s}},
           label: RecipePresets.text_block(text),
           control: %{max_width: {:container, s}, gap: {:space, s}},
           trigger: RecipePresets.size_block(s),
           item: Map.merge(RecipePresets.size_block(s), %{min_height: {:size, s}}),
           item_indicator: %{padding_inline_end: {:space, s}},
           item_group_label: RecipePresets.text_block(text)
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms() do
        block = RecipePresets.text_block(step)

        {step,
         [
           label: block,
           trigger: block,
           item: block,
           item_group_label: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [trigger: RecipePresets.rounded_block(r)]}
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule SignaturePad do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "signature-pad"
    @id :signature_pad

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :xs, height: :auto, max_height: :none],
        base: [
          host: %{},
          root: %{},
          label: %{},
          control: %{},
          guide: %{},
          segment: %{},
          clear_trigger: %{},
          hidden_input: %{},
          error: %{},
          preview: %{}
        ],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: signature_pad_rules() ++ semantic_clear_rules()
      )
    end

    defp signature_pad_rules do
      id = @id
      scope = @scope
      host = Selector.host(id)
      _root = Selector.part(id, scope, "root")
      control = Selector.part(id, scope, "control")
      guide = Selector.part(id, scope, "guide")
      segment = Selector.part(id, scope, "segment")
      clear = Selector.part(id, scope, "clear-trigger")
      preview = ~s(#{host} [data-part="preview"])

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        [
          Rule.new(host,
            decls: [
              width: "100%",
              max_width: {:container, :xs},
              gap: {:space, :md},
              display: "flex",
              flex_direction: "column"
            ]
          ),
          Rule.new(control,
            decls: [
              position: "relative",
              width: "100%",
              height: {:raw, "calc(var(--container-4xs) * 0.7)"},
              background_color: {:color, :ui},
              border_radius: {:radius, :md},
              border: {:raw, "1px solid var(--color-border)"}
            ]
          ),
          Rule.new(guide,
            decls: [
              position: "absolute",
              bottom: {:space, :md},
              inset_inline_start: {:space, :md},
              inset_inline_end: {:space, :md},
              border_bottom: {:raw, "2px dashed var(--color-border)"}
            ]
          ),
          Rule.new(segment,
            decls: [
              position: "absolute",
              top: "0",
              inset_inline_start: "0",
              width: "100%",
              height: "100%",
              pointer_events: "none",
              background_color: {:color, :ui_muted},
              border_radius: {:radius, :md}
            ]
          ),
          Rule.new(clear,
            decls: [
              include: :ui_trigger,
              aspect_ratio: {:raw, "1 / 1"},
              padding: 0,
              justify_content: :center,
              width: :auto,
              position: "absolute",
              z_index: "1",
              top: {:space, :sm},
              inset_inline_end: {:space, :sm},
              min_height: {:raw, "calc(var(--size-md) * 0.6)"},
              min_width: {:raw, "calc(var(--size-md) * 0.6)"}
            ]
          ),
          Rule.new(preview,
            decls: [
              display: "flex",
              flex_direction: "column",
              align_items: "center",
              width: {:container, :"4xs"},
              padding: {:space, :md},
              gap: {:space, :md},
              background_color: {:color, :layer}
            ],
            children: [
              Rule.new("& img",
                decls: [
                  width: "100%",
                  height: {:raw, "var(--container-6xs)"},
                  display: "flex",
                  justify_content: "center",
                  align_items: "center",
                  overflow: "hidden",
                  padding: {:space, :md},
                  border: {:raw, "1px solid var(--color-border)"},
                  border_radius: {:radius, :md},
                  background_color: {:color, :root}
                ]
              )
            ]
          )
        ]
    end

    defp semantic_clear_rules do
      Palette.semantic_solid_part_rules(@id, Selector.slot(@scope, "clear-trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = size_text(size)

        {size,
         [
           root: %{gap: {:space, size}},
           label: RecipePresets.text_block(text),
           control: %{height: {:raw, "calc(var(--size-#{size}) * 4)"}},
           clear_trigger:
             Map.merge(RecipePresets.text_block(text), %{
               min_height: {:size, size},
               min_width: {:size, size},
               background_color: {:color, :accent},
               color: {:color, :accent_ink}
             })
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms() do
        block = RecipePresets.rounded_block(r)

        {r, [control: block, segment: block, clear_trigger: block]}
      end
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step
  end

  defmodule Switch do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.FormHost
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "switch"
    @id :switch

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"4xl", height: :auto, max_height: :none],
        base: [host: %{}, root: %{}, label: %{}, control: %{}, thumb: %{}, error: %{}],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: switch_rules()
      )
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, [host: Palette.selected_host_sx(color)]}
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        {size,
         [
           root:
             Map.merge(
               %{gap: {:space, size}, padding_inline_end: {:space, size}},
               track_var_block(size)
             ),
           control: %{padding: {:raw, "calc(var(--space-#{size}) * 0.3)"}},
           label: RecipePresets.text_block(size_text(size))
         ]}
      end
    end

    defp track_var_block(size) do
      %{
        "--switch-track-width": {:raw, "calc(var(--size-#{size}) * 0.8)"},
        "--switch-track-height": {:raw, "calc(var(--size-#{size}) * 0.5 * 0.8)"},
        "--switch-track-diff":
          {:raw, "calc(var(--switch-track-width) - var(--switch-track-height))"},
        "--switch-thumb-x": {:raw, "var(--switch-track-diff)"}
      }
    end

    defp size_text(:md), do: :base
    defp size_text(step), do: step

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do:
            {r, [control: RecipePresets.rounded_block(r), thumb: RecipePresets.rounded_block(r)]}
    end

    defp switch_rules do
      id = @id
      scope = @scope
      root = Selector.part(id, scope, "root")
      control = Selector.part(id, scope, "control")
      thumb = Selector.part(id, scope, "thumb")
      thumb_child = "& #{Selector.slot(scope, "thumb")}"

      FormHost.host_rules(id, scope, orientation_rules: false) ++
        semantic_thumb_rules() ++
        [
          Rule.new(root,
            decls:
              [
                display: "flex",
                align_items: "center",
                position: "relative",
                width: "fit-content",
                gap: "var(--space-md)",
                padding_inline_end: "var(--space-md)"
              ] ++ track_var_decls(:md)
          ),
          Rule.new(control,
            decls: [
              display: "inline-flex",
              flex_shrink: "0",
              align_items: "center",
              cursor: "pointer",
              justify_content: "flex-start",
              box_sizing: "content-box",
              overflow: "hidden",
              border_radius: "var(--radius-4xl)",
              border: "1px solid var(--color-border)",
              padding: "calc(var(--space-md) * 0.3)",
              width: "var(--switch-track-width)",
              height: "var(--switch-track-height)",
              background: "var(--color-ui)",
              transition:
                "background 150ms ease, border-color 150ms ease, color 150ms ease, transform 150ms ease"
            ],
            children: [
              Rule.new("&[data-state=\"checked\"]",
                decls: [background_color: "var(--color-selected)"],
                children: [
                  Rule.new(thumb_child, decls: [background_color: "var(--color-selected-ink)"])
                ]
              ),
              Rule.new("&[data-disabled]",
                decls: [
                  color: "var(--color-ui-ink-muted)",
                  background: "var(--color-ui-muted)",
                  cursor: "not-allowed",
                  box_shadow: "none"
                ]
              ),
              Rule.new("&[data-invalid]", decls: [border_color: "var(--color-alert)"]),
              Rule.new("&:focus-visible",
                decls: [outline: "none", box_shadow: "inset 0 0 0 2px var(--color-ui-ink)"]
              ),
              Rule.new("&[data-focus]:not(:focus-visible)", decls: [box_shadow: "none"])
            ]
          ),
          Rule.new(thumb,
            decls: [
              background: "var(--color-ui-ink)",
              transition: "transform 200ms ease, background-color 200ms ease",
              border_radius: "inherit",
              width: "var(--switch-track-height)",
              height: "var(--switch-track-height)",
              flex_shrink: "0",
              position: "relative"
            ],
            children: [
              Rule.new("&[data-state=\"checked\"]",
                decls: [
                  transform: "translateX(var(--switch-thumb-x))",
                  background_color: "var(--color-selected-ink)"
                ]
              ),
              Rule.new("&[data-invalid]", decls: [background: "var(--color-alert)"])
            ]
          ),
          Rule.new(
            ~s(#{root}[dir="rtl"] #{Selector.slot(scope, "thumb")}[data-state="checked"]),
            decls: [transform: "translateX(calc(var(--switch-thumb-x) * -1))"]
          )
        ]
    end

    defp semantic_thumb_rules do
      thumb = Selector.slot(@scope, "thumb")

      for color <- Axes.semantic_atoms() do
        Rule.new(
          "#{Palette.host_mod(@id, color)} #{thumb}:not([data-state=\"checked\"])",
          decls: [background_color: "var(--color-#{color})"]
        )
      end
    end

    defp track_var_decls(size) do
      size = Atom.to_string(size)

      [
        "--switch-track-width": "calc(var(--size-#{size}) * 0.8)",
        "--switch-track-height": "calc(var(--size-#{size}) * 0.5 * 0.8)",
        "--switch-track-diff": "calc(var(--switch-track-width) - var(--switch-track-height))",
        "--switch-thumb-x": "var(--switch-track-diff)"
      ]
    end
  end

  defmodule Tabs do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "tabs"
    @id :tabs

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [host: %{}],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ neutral_trigger_rules() ++ semantic_trigger_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      list = part("list")
      trigger = part("trigger")
      content = part("content")
      item_indicator = part("item-indicator")

      [
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(host, decls: [width: "100%", max_width: {:container, :md}]),
        Rule.new(root, decls: [include: :ui_root, gap: {:space, :md}]),
        Rule.new("#{root}[data-orientation='vertical']",
          decls: [
            flex_direction: "row",
            align_items: "flex-start",
            width: "100%"
          ]
        ),
        Rule.new("#{root}[data-orientation='horizontal']",
          decls: [flex_direction: "column"]
        ),
        Rule.new(list,
          decls: [
            position: "relative",
            display: "flex",
            flex_wrap: "wrap",
            justify_content: "center",
            background_color: {:color, :border},
            gap: "1px",
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            overflow: "auto",
            width: "fit-content"
          ]
        ),
        Rule.new("#{list}[data-orientation='vertical']",
          decls: [
            flex_direction: "column",
            height: "fit-content",
            flex_shrink: "0",
            min_width: "max-content",
            align_self: "flex-start",
            align_items: "stretch",
            justify_content: "flex-start",
            width: "max-content"
          ]
        ),
        Rule.new("#{list}[data-orientation='horizontal']",
          decls: [flex_direction: "row"]
        ),
        Rule.new(content, decls: [include: :ui_content, width: "100%"]),
        Rule.new("#{content}[data-orientation='vertical']",
          decls: [flex: "1 1 0%", min_width: "0", width: "auto"]
        ),
        Rule.new(trigger,
          decls: [include: :ui_item, width: "fit-content", max_width: "none"]
        ),
        Rule.new("#{trigger}[data-focus]:not(:focus-visible)",
          decls: [box_shadow: "none"]
        ),
        Rule.new("#{trigger}[data-orientation='vertical']",
          decls: [
            box_sizing: "border-box",
            width: "100%",
            max_width: "none",
            justify_content: "flex-start"
          ]
        ),
        Rule.new(item_indicator,
          decls: [
            display: "none",
            "--transition-duration": "0.2s",
            "--transition-timing-function": "ease-in-out",
            background_color: {:color, :ui_ink},
            z_index: "10"
          ],
          children: [
            Rule.new("&[data-orientation='horizontal']",
              decls: [
                height: "4px",
                width: "var(--width)",
                bottom: "0",
                top: "auto !important"
              ]
            ),
            Rule.new("&[data-orientation='vertical']",
              decls: [width: "4px", height: "var(--height)", top: "var(--top)"]
            )
          ]
        )
      ]
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp neutral_trigger_rules do
      SemanticStates.neutral_selected_trigger_rules(@id, part("trigger"))
    end

    defp semantic_trigger_rules do
      SemanticStates.selected_trigger_rules(@id, part("trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        {size,
         [
           root: %{gap: {:space, size}},
           trigger: RecipePresets.size_block(size)
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms(),
          do:
            {step,
             [trigger: RecipePresets.text_block(step), content: RecipePresets.text_block(step)]}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do: {r, [list: RecipePresets.rounded_block(r), content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)
  end

  defmodule TagsInput do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "tags-input"
    @id :tags_input

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ trigger_semantic_rules()
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      label = part("label")
      control = part("control")
      input = part("input")
      item = part("item")
      item_preview = part("item-preview")
      item_text = part("item-text")
      item_delete_trigger = part("item-delete-trigger")
      item_input = part("item-input")
      error = part("error")

      [
        Rule.new(host,
          decls: [
            include: :ui_root,
            width: "100%",
            max_width: {:container, :md}
          ]
        ),
        Rule.new("#{host}[data-loading] #{root}", decls: [include: :ui_loading]),
        Rule.new(root, decls: [include: :ui_root, position: "relative"]),
        Rule.new("#{root}[data-focus]", decls: [outline: "none"]),
        Rule.new("#{root}[data-invalid]",
          decls: [color: {:raw, "var(--color-alert, var(--color-ui-ink))"}]
        ),
        Rule.new("#{root}[data-readonly]", decls: [include: :ui_readonly]),
        Rule.new(label, decls: [include: :ui_label]),
        Rule.new(control,
          decls: [
            display: "flex",
            flex_wrap: "wrap",
            align_items: "center",
            gap: {:space, :md},
            min_height: {:size, :md},
            padding: {:space, :md},
            border: {:raw, "1px solid var(--color-border)"},
            border_radius: {:radius, :md},
            background: {:color, :layer}
          ]
        ),
        Rule.new("#{control}[data-invalid]",
          decls: [border_color: {:color, :alert}, box_shadow: "none"]
        ),
        Rule.new("#{control}[data-invalid][data-focus]",
          decls: [outline_color: {:color, :alert}]
        ),
        Rule.new(
          "#{control}[data-invalid] > #{slot("input")},\n  #{control}[data-invalid] #{slot("item-preview")},\n  #{control}[data-invalid] #{slot("item-input")}",
          decls: [border_color: {:color, :border}, box_shadow: "none"]
        ),
        Rule.new("#{control}[data-focus]",
          decls: [
            outline: {:raw, "2px solid var(--color-accent)"},
            outline_offset: "2px"
          ]
        ),
        Rule.new(input,
          decls: [
            include: :ui_input,
            flex: "1 1 8rem",
            min_width: "6rem",
            max_width: {:raw, "var(--container-7xs)"}
          ]
        ),
        Rule.new("#{input}[data-empty]", decls: [min_width: "4rem"]),
        Rule.new(item,
          decls: [
            display: "inline-flex",
            flex_wrap: "wrap",
            align_items: "center",
            gap: {:space, :md},
            max_width: "100%"
          ]
        ),
        Rule.new("#{item_preview}[hidden]", decls: [display: "none !important"]),
        Rule.new(item_preview, decls: [include: :ui_trigger]),
        Rule.new(item_text,
          decls: [
            min_width: "0",
            overflow: "hidden",
            text_overflow: "ellipsis",
            white_space: "nowrap",
            max_width: "12rem"
          ]
        ),
        Rule.new(item_delete_trigger,
          decls: [
            include: :ui_trigger,
            min_height: {:raw, "calc(var(--size) * 0.6)"},
            min_width: {:raw, "calc(var(--size) * 0.6)"},
            aspect_ratio: "1 / 1",
            padding: "0"
          ]
        ),
        Rule.new("#{item_input}[hidden]", decls: [display: "none !important"]),
        Rule.new(item_input,
          decls: [include: :ui_input, max_width: {:raw, "var(--container-7xs)"}]
        ),
        Rule.new(error, decls: [include: :ui_error]),
        Rule.new("#{error}.absolute", decls: [padding_block: "0", display: "block"])
      ]
    end

    defp trigger_semantic_rules do
      Palette.semantic_solid_part_rules(@id, Selector.slot(@scope, "item-delete-trigger"))
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        size_raw = "var(--size-#{size})"

        {size,
         [
           root: %{gap: {:space, size}},
           control: %{
             gap: {:space, size},
             padding: {:space, size},
             min_height: {:size, size}
           },
           item_preview: %{
             gap: {:space, size},
             padding_inline: {:space, size},
             min_height: {:size, size}
           },
           item_delete_trigger: %{
             min_height: {:raw, "calc(#{size_raw} * 0.6)"},
             min_width: {:raw, "calc(#{size_raw} * 0.6)"}
           },
           item_input: %{padding: {:space, size}},
           input: %{
             font_size: {:text, if(size == :md, do: :base, else: size)},
             line_height: {:leading, if(size == :md, do: :base, else: size)},
             min_height: {:size, size}
           },
           item_text: %{color: {:color, :ui_ink}}
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms() do
        block = RecipePresets.text_block(step)

        {step,
         [
           label: block,
           item_text: block,
           input: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms() do
        block = RecipePresets.rounded_block(r)

        {r,
         [
           control: block,
           input: block,
           item_preview: block,
           item_input: block,
           item_delete_trigger: block
         ]}
      end
    end

    defp part(name), do: Selector.part(@id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end

  defmodule Timer do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "timer"
    @id :timer

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :none, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: Corex.Design.Recipes.semantic_part_host_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ semantic_action_rules() ++ timer_size_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = part("root")
      area = part("area")
      item = part("item")
      item_label = part("item-label")
      separator = part("separator")
      control = part("control")
      action = part("action-trigger")
      segment = ~s(#{host} [data-timer-segment])

      [
        Rule.new(host, decls: [width: "100%", max_width: "fit-content"]),
        Rule.new(root, decls: [include: :ui_root]),
        Rule.new(area,
          decls: [
            display: "flex",
            width: "100%",
            justify_content: "center",
            align_items: "flex-start",
            flex_wrap: "wrap"
          ]
        ),
        Rule.new("#{area}:not(:has(#{separator}))", decls: [gap: {:space, :md}]),
        Rule.new(segment,
          decls: [
            display: "flex",
            flex_direction: "column",
            align_items: "center",
            justify_content: "flex-start",
            min_width: "0",
            gap: {:space, :sm}
          ]
        ),
        Rule.new(item,
          decls: [
            include: :ui_label,
            justify_content: "center",
            font_size: {:text, :"4xl"},
            line_height: {:leading, :"4xl"},
            font_weight: {:weight, :semibold},
            text_align: "center",
            color: {:color, :ui_ink},
            min_width: "2ch",
            height: "2em",
            overflow: "hidden",
            position: "relative"
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw, "font-variant-numeric: tabular-nums; font-variation-settings: \"tnum\""}
              ]
            ),
            Rule.new("&::before",
              decls: timer_digits_before()
            ),
            Rule.new("&[data-type=\"days\"]",
              decls: [min_width: "max(2ch, 3.5ch)", width: "auto"]
            )
          ]
        ),
        Rule.new(item_label,
          decls: [
            include: :ui_label,
            justify_content: "center",
            font_size: {:text, :xs},
            line_height: {:leading, :xs},
            font_weight: {:weight, :medium},
            letter_spacing: "0.08em",
            color: {:color, :ui_ink_muted},
            text_align: "center",
            white_space: "nowrap",
            max_width: "100%"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "text-transform: uppercase"}])
          ]
        ),
        Rule.new(separator,
          decls: [
            include: :ui_label,
            justify_content: "center",
            align_self: "flex-start",
            font_size: {:text, :"4xl"},
            line_height: {:leading, :"4xl"},
            font_weight: {:weight, :semibold},
            color: {:color, :ui_ink},
            padding_inline: {:space, :sm},
            height: "2em",
            flex_shrink: "0"
          ]
        ),
        Rule.new(control,
          decls: [
            display: "inline-flex",
            width: "100%",
            justify_content: "center",
            gap: {:space, :sm},
            margin_top: {:space, :sm}
          ]
        ),
        Rule.new(action,
          decls: [
            include: :ui_trigger,
            font_size: {:text, :base},
            line_height: {:leading, :base},
            padding: "0 !important",
            min_height: "calc(2em * 0.8) !important",
            height: "calc(2em * 0.8)",
            justify_content: "center",
            width: "auto"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}]),
            Rule.new(" [data-icon]",
              decls: [font_size: "1em"]
            )
          ]
        )
      ]
    end

    defp timer_digits_before do
      [
        position: "absolute",
        left: "0",
        right: "0",
        content:
          {:raw,
           ~S("00\\a 01\\a 02\\a 03\\a 04\\a 05\\a 06\\a 07\\a 08\\a 09\\a 10\\a 11\\a 12\\a 13\\a 14\\a 15\\a 16\\a 17\\a 18\\a 19\\a 20\\a 21\\a 22\\a 23\\a 24\\a 25\\a 26\\a 27\\a 28\\a 29\\a 30\\a 31\\a 32\\a 33\\a 34\\a 35\\a 36\\a 37\\a 38\\a 39\\a 40\\a 41\\a 42\\a 43\\a 44\\a 45\\a 46\\a 47\\a 48\\a 49\\a 50\\a 51\\a 52\\a 53\\a 54\\a 55\\a 56\\a 57\\a 58\\a 59\\a 60\\a 61\\a 62\\a 63\\a 64\\a 65\\a 66\\a 67\\a 68\\a 69\\a 70\\a 71\\a 72\\a 73\\a 74\\a 75\\a 76\\a 77\\a 78\\a 79\\a 80\\a 81\\a 82\\a 83\\a 84\\a 85\\a 86\\a 87\\a 88\\a 89\\a 90\\a 91\\a 92\\a 93\\a 94\\a 95\\a 96\\a 97\\a 98\\a 99\\a")},
        white_space: "pre",
        top: "calc(var(--value) * -2em)",
        font_size: "inherit",
        line_height: "2",
        text_align: "center",
        transition: "top 1s cubic-bezier(1, 0, 0, 1)",
        pointer_events: "none",
        z_index: "1"
      ]
    end

    defp semantic_action_rules do
      Palette.semantic_solid_part_rules(@id, Selector.slot(@scope, "action-trigger"))
    end

    defp timer_size_rules do
      name = Selector.class_name(@id)
      item = part("item")
      separator = part("separator")
      action = part("action-trigger")

      sm = [
        Rule.new(".#{name}.#{name}--size-sm #{item},\n  .#{name}.#{name}--size-sm #{separator}",
          decls: [font_size: {:text, :"2xl"}, line_height: {:leading, :"2xl"}]
        ),
        Rule.new(".#{name}.#{name}--size-sm #{action}",
          decls: [
            font_size: {:text, :sm},
            line_height: {:leading, :sm},
            min_height: "calc(2em * 0.8) !important",
            height: "calc(2em * 0.8)"
          ]
        )
      ]

      md = [
        Rule.new(".#{name}.#{name}--size-md #{item},\n  .#{name}.#{name}--size-md #{separator}",
          decls: [font_size: {:text, :"4xl"}, line_height: {:leading, :"4xl"}]
        ),
        Rule.new(".#{name}.#{name}--size-md #{action}",
          decls: [
            font_size: {:text, :base},
            line_height: {:leading, :base},
            min_height: "calc(2em * 0.8) !important",
            height: "calc(2em * 0.8)"
          ]
        )
      ]

      lg = [
        Rule.new(".#{name}.#{name}--size-lg #{item},\n  .#{name}.#{name}--size-lg #{separator}",
          children: [
            Rule.new("&",
              decls: [
                {:raw, "font-size: var(--text-5xl); line-height: var(--text-5xl--line-height)"}
              ]
            )
          ]
        ),
        Rule.new(".#{name}.#{name}--size-lg #{action}",
          decls: [
            font_size: {:text, :lg},
            line_height: {:leading, :lg},
            min_height: "calc(2em * 0.8) !important",
            height: "calc(2em * 0.8)"
          ]
        )
      ]

      xl = [
        Rule.new(".#{name}.#{name}--size-xl #{item},\n  .#{name}.#{name}--size-xl #{separator}",
          children: [
            Rule.new("&",
              decls: [
                {:raw, "font-size: var(--text-6xl); line-height: var(--text-6xl--line-height)"}
              ]
            )
          ]
        ),
        Rule.new(".#{name}.#{name}--size-xl #{action}",
          decls: [
            font_size: {:text, :xl},
            line_height: {:leading, :xl},
            min_height: "calc(2em * 0.8) !important",
            height: "calc(2em * 0.8)"
          ]
        )
      ]

      sm ++ md ++ lg ++ xl
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, []}
    end

    defp text_variants do
      for step <- Axes.text_atoms() do
        block = RecipePresets.text_block(step)

        {step,
         [
           item: block,
           item_label: block,
           separator: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [action_trigger: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)
  end

  defmodule Toast do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Emit.Tokens, as: Var
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "toast"
    @id :toast

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules() ++ keyframe_rules() ++ semantic_toast_rules()
      )
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp semantic_toast_rules do
      Palette.semantic_solid_part_rules(@id, part("action-trigger")) ++
        Palette.semantic_ink_part_rules(@id, part("close-trigger"))
    end

    defp base_rules do
      group = part("group")
      root = part("root")
      content = part("content")
      header = part("header")
      title = part("title")
      description = part("description")
      actions = part("actions")
      action_trigger = part("action-trigger")
      close_trigger = part("close-trigger")
      progressbar = part("progressbar")
      loading_spinner = part("loading-spinner")

      [
        Rule.new(group,
          decls: [
            position: "fixed",
            inset_inline_start: "var(--viewport-offset-left)",
            inset_inline_end: "var(--viewport-offset-right)",
            bottom:
              {:raw, "max(env(safe-area-inset-bottom, 0px), var(--viewport-offset-bottom))"},
            top: "auto",
            display: "flex",
            flex_direction: "column",
            align_items: "stretch",
            max_width: "100%"
          ]
        ),
        Rule.new(root,
          decls: [
            include: :ui_root,
            max_width: {:container, :xs},
            z_index: "var(--z-index)",
            height: "var(--height)",
            opacity: "var(--opacity)",
            transition:
              {:raw,
               "translate 400ms cubic-bezier(0.21, 1.02, 0.73, 1), scale 400ms cubic-bezier(0.21, 1.02, 0.73, 1), opacity 400ms cubic-bezier(0.21, 1.02, 0.73, 1), height 400ms cubic-bezier(0.21, 1.02, 0.73, 1), box-shadow 200ms"}
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw,
                 "translate: var(--x) var(--y); scale: var(--scale); will-change: translate, opacity, scale"}
              ]
            ),
            Rule.new("&[data-state='closed']",
              decls: [
                transition:
                  {:raw,
                   "translate 400ms cubic-bezier(0.06, 0.71, 0.55, 1), scale 400ms cubic-bezier(0.06, 0.71, 0.55, 1), opacity 200ms cubic-bezier(0.06, 0.71, 0.55, 1)"}
              ]
            )
          ]
        ),
        Rule.new(content,
          decls: [
            include: :ui_content,
            display: "flex",
            flex_direction: "column",
            padding: "0",
            overflow: "hidden"
          ]
        ),
        Rule.new(header,
          decls: [
            display: "flex",
            align_items: "center",
            gap: {:space, :md},
            padding_inline: {:space, :md},
            padding_block: {:raw, "calc(var(--space) * 0.5)"}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "border-block-end: 1px solid var(--color-border)"}])
          ]
        ),
        Rule.new(title,
          decls: [
            include: :ui_label,
            flex: "1",
            min_width: "0",
            font_weight: {:raw, "var(--font-weight-medium)"}
          ]
        ),
        Rule.new(description,
          decls: [
            font_size: {:text, :base},
            line_height: {:leading, :base},
            font_weight: {:raw, "var(--font-weight-medium)"},
            padding: {:space, :lg},
            min_height: {:size, :lg},
            white_space: "pre-line"
          ]
        ),
        Rule.new(actions,
          decls: [
            display: "flex",
            flex_direction: "row",
            justify_content: "flex-end",
            align_items: "center",
            gap: {:space, :md},
            padding_inline: {:space, :lg}
          ],
          children: [
            Rule.new("&", decls: [{:raw, "padding-block-end: #{Var.ref([:space, :md])}"}])
          ]
        ),
        Rule.new(action_trigger, decls: [include: :ui_trigger, min_height: {:size, :sm}]),
        Rule.new("#{action_trigger}[hidden]", decls: [display: "none"]),
        Rule.new(close_trigger,
          decls: [
            include: :ui_trigger,
            flex_shrink: "0",
            min_height: {:size, :sm},
            padding: "0",
            background_color: "transparent",
            border_color: "transparent"
          ],
          children: [
            Rule.new("&", decls: [{:raw, "aspect-ratio: 1 / 1"}])
          ]
        ),
        Rule.new("#{root}[data-type='error'] #{title}", decls: [color: {:color, :ui_ink_alert}]),
        Rule.new("#{root}[data-type='error'] #{progressbar}",
          decls: [
            background:
              {:raw, "linear-gradient(to left, var(--color-alert-hover), var(--color-alert))"}
          ]
        ),
        Rule.new("#{root}[data-type='info'] #{title}", decls: [color: {:color, :ui_ink_info}]),
        Rule.new("#{root}[data-type='info'] #{progressbar}",
          decls: [
            background:
              {:raw, "linear-gradient(to left, var(--color-info-hover), var(--color-info))"}
          ]
        ),
        Rule.new("#{root}[data-type='success'] #{title}",
          decls: [color: {:color, :ui_ink_success}]
        ),
        Rule.new("#{root}[data-type='success'] #{progressbar}",
          decls: [
            background:
              {:raw, "linear-gradient(to left, var(--color-success-hover), var(--color-success))"}
          ]
        ),
        Rule.new(progressbar,
          decls: [
            height: {:raw, "calc(var(--space) * 0.5)"},
            background:
              {:raw, "linear-gradient(to left, var(--color-ui-ink-muted), var(--color-ui-ink))"},
            width: "100%",
            position: "absolute",
            bottom: "0",
            inset_inline: "0"
          ],
          children: [
            Rule.new("&",
              decls: [
                {:raw,
                 "transform-origin: left; animation-name: shrink; animation-duration: var(--duration); animation-fill-mode: forwards; animation-play-state: running"}
              ]
            ),
            Rule.new("[data-paused] &", decls: [{:raw, "animation-play-state: paused"}]),
            Rule.new("[dir='rtl'] &", decls: [{:raw, "transform-origin: right"}])
          ]
        ),
        Rule.new(loading_spinner,
          decls: [
            include: :ui_icon,
            display: "none",
            min_height: {:size, :sm},
            animation: "spin 1s linear infinite"
          ]
        ),
        Rule.new("#{root}[data-duration-infinity='true'] #{loading_spinner}",
          decls: [display: "inline-flex"]
        ),
        Rule.new("#{root}[data-duration-infinity='true'] #{progressbar}",
          decls: [display: "none"]
        )
      ]
    end

    defp keyframe_rules do
      [
        Rule.new("@keyframes spin",
          children: [
            Rule.new("from", decls: [transform: "rotate(0deg)"]),
            Rule.new("to", decls: [transform: "rotate(360deg)"])
          ]
        ),
        Rule.new("@keyframes shrink",
          children: [
            Rule.new("from", decls: [transform: "scaleX(1)"]),
            Rule.new("to", decls: [transform: "scaleX(0)"])
          ]
        )
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        text = if(size == :md, do: :base, else: size)
        block = RecipePresets.text_block(text)

        {size,
         [
           group: %{gap: {:space, size}},
           description: %{
             padding: {:space, size},
             min_height: {:raw, "calc(var(--space-#{size}) * 14)"}
           },
           header: %{
             gap: {:space, size},
             padding_inline: {:space, size},
             padding_block: {:raw, "calc(var(--space-#{size}) * 0.5)"}
           },
           title: block
         ]}
      end
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do: {r, [root: RecipePresets.rounded_block(r), content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)
  end

  defmodule Toggle do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.HostIcon
    alias Corex.Design.Rule
    alias Corex.Design.Selector
    alias Corex.Design.Style

    @scope "toggle"
    @id :toggle

    def recipe do
      Recipe.part_recipe(:toggle,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [
          host: %{},
          root: root_base(),
          indicator: %{display: :inline_flex, align_items: :center, justify_content: :center}
        ],
        variants: [
          semantic: semantic_variants(),
          variant: variant_variants(),
          size: on_root(size_variants()),
          text: on_root(text_variants()),
          radius: on_root(radius_variants()),
          shape: on_root(HostIcon.shape_variants())
        ],
        default_variants: [variant: :solid, size: :md],
        extra_rules:
          Palette.modifier_paint_on_rules(@id, @scope, "root") ++
            HostIcon.indicator_rules(@id) ++
            HostIcon.host_icon_rules(@id) ++
            HostIcon.square_icon_rules(@id) ++
            HostIcon.scoped_size_rules(@id, @scope) ++
            HostIcon.scoped_shape_square_size_rules(@id, @scope) ++
            host_extra_rules()
      )
    end

    defp root_base do
      Style.merge(
        RecipePresets.trigger_base(),
        %{
          width: {:raw, "fit-content"},
          on: RecipePresets.visual_solid(),
          not_on: RecipePresets.visual_trigger()
        }
      )
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms(), do: {color, [host: %{position: :relative}]}
    end

    defp variant_variants do
      [
        solid: [root: %{not_on: RecipePresets.visual_trigger()}],
        ghost: [root: %{not_on: RecipePresets.visual_ghost()}],
        outline: [root: %{not_on: RecipePresets.visual_outline()}],
        subtle: [root: %{not_on: RecipePresets.visual_subtle()}]
      ]
    end

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, RecipePresets.size_block(size)}
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, RecipePresets.text_block(step)}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, RecipePresets.rounded_block(r)}
    end

    defp on_root(variants), do: for({value, block} <- variants, do: {value, [root: block]})

    defp host_extra_rules do
      host = Selector.host(@id)

      [
        Rule.new(~s(#{host}[data-loading] [data-scope="toggle"][data-part="root"]),
          decls: [include: :ui_loading]
        ),
        Rule.new(
          ~s(#{host}[data-toggle-dual-label] [data-scope="toggle"][data-part="root"][data-state="off"] > span[data-pressed]),
          decls: [display: :none]
        ),
        Rule.new(
          host <>
            "[data-toggle-dual-label] [data-scope=\"toggle\"][data-part=\"root\"][data-state=\"on\"] > span:not([data-scope]):not([data-pressed])",
          decls: [display: :none]
        )
      ]
    end
  end

  defmodule ToggleGroup do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Recipes.SemanticStates
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "toggle-group"
    @id :toggle_group

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :"4xs", height: :auto, max_height: :none],
        base: [host: %{}],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules:
          base_rules() ++
            neutral_item_rules() ++
            semantic_item_rules() ++
            icon_rules() ++
            item_icon_size_rules()
      )
    end

    defp base_rules do
      host = Selector.host(@id)
      root = Selector.part(@id, @scope, "root")
      item = Selector.part(@id, @scope, "item")

      [
        Rule.new(~s(#{host}[data-loading] #{root}), decls: [include: :ui_loading]),
        Rule.new(root,
          decls: [
            include: :ui_root,
            justify_content: "center",
            flex_direction: "row",
            width: "fit-content",
            gap: "1px",
            background_color: "var(--color-border)",
            border: "1px solid var(--color-border)",
            border_radius: "var(--radius-md)",
            overflow: "hidden"
          ]
        ),
        Rule.new(item,
          decls: [
            include: :ui_item,
            flex: "1 1 0",
            min_width: "0",
            justify_content: "center",
            padding_inline: "var(--space-md)",
            gap: "var(--space-sm)"
          ],
          children: [
            Rule.new("&[data-focus]:not(:focus-visible)", decls: [box_shadow: "none"])
          ]
        )
      ]
    end

    defp semantic_variants, do: Corex.Design.Recipes.semantic_part_host_variants()

    defp size_variants do
      for size <- Axes.size_atoms(), do: {size, [item: toggle_group_item_size_block(size)]}
    end

    defp toggle_group_item_size_block(size) do
      RecipePresets.size_block(size)
      |> Map.put(:padding_inline, {:space, toggle_group_item_padding(size)})
    end

    defp toggle_group_item_padding(:sm), do: :md
    defp toggle_group_item_padding(size), do: size

    defp radius_variants do
      for r <- Axes.radius_atoms(),
          do: {r, [root: RecipePresets.rounded_block(r), item: %{border_radius: 0}]}
    end

    defp neutral_item_rules do
      SemanticStates.neutral_toggle_group_item_rules(@id, Selector.part(@id, @scope, "item"))
    end

    defp semantic_item_rules do
      SemanticStates.toggle_group_item_rules(@id, Selector.part(@id, @scope, "item"))
    end

    defp icon_rules do
      item = Selector.part(@id, @scope, "item")

      [
        Rule.new(~s(#{item}[data-state="on"] .icon.state-on),
          decls: [display: "block !important"]
        ),
        Rule.new(~s(#{item}[data-state="off"] .icon.state-on),
          decls: [display: "none !important"]
        ),
        Rule.new(~s(#{item}[data-state="on"] .icon.state-off),
          decls: [display: "none !important"]
        ),
        Rule.new(~s(#{item}[data-state="off"] .icon.state-off),
          decls: [display: "block !important"]
        )
      ]
    end

    defp item_icon_size_rules do
      item = Selector.slot(@scope, "item")

      for size <- Axes.size_atoms() do
        Rule.new(
          "#{Palette.host_size_mod(@id, size)} #{item} [data-icon]",
          decls: [
            display: :inline_flex,
            align_items: :center,
            justify_content: :center,
            flex_shrink: {:raw, "0"},
            width: {:raw, "1em !important"},
            height: {:raw, "1em !important"}
          ]
        )
      end
    end
  end

  defmodule Tooltip do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "tooltip"
    @id :tooltip

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: RecipePresets.default_host_sizing(),
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: tooltip_rules()
      )
    end

    defp tooltip_rules do
      host = Selector.host(@id)
      positioner = part("positioner")
      content = part("content")
      content_open = ~s(#{content}[data-state="open"])
      arrow = part("arrow")
      arrow_tip = part("arrow-tip")

      [
        Rule.new(host, decls: [position: "relative", z_index: "20"]),
        Rule.new("#{host}:has(#{content_open})", decls: [z_index: "50"]),
        Rule.new("#{host}[data-loading] > *", decls: [include: :ui_loading]),
        Rule.new(positioner,
          decls: [
            z_index: "50",
            position: "absolute",
            left: "0",
            top: "0",
            visibility: "hidden",
            pointer_events: "none"
          ]
        ),
        Rule.new("#{positioner}:has(#{content_open})",
          decls: [visibility: "visible", pointer_events: "auto"]
        ),
        Rule.new(content,
          decls: [
            include: :ui_content,
            padding: {:space, :md},
            max_width: {:raw, "var(--container-5xs)"},
            position: "relative",
            z_index: "1",
            background_color: {:color, :ui},
            border: {:raw, "1px solid var(--color-border)"},
            box_shadow: {:raw, "var(--shadow-ui)"}
          ]
        ),
        Rule.new("#{content}[data-state='closed']",
          decls: [
            visibility: "hidden",
            opacity: "0",
            transition: "visibility 0.15s, opacity 0.15s"
          ]
        ),
        Rule.new("#{content}[data-state='open']",
          decls: [
            visibility: "visible",
            opacity: "1",
            transition: "visibility 0.15s, opacity 0.15s"
          ]
        ),
        Rule.new(arrow,
          decls: [
            "--arrow-size": {:space, :md},
            "--arrow-background": {:raw, "var(--color-ui)"},
            z_index: "0"
          ]
        ),
        Rule.new(arrow_tip,
          decls: [
            background: {:raw, "var(--arrow-background)"},
            border: {:raw, "1px solid var(--color-border)"}
          ]
        )
      ]
    end

    defp semantic_variants do
      for color <- Axes.semantic_atoms() do
        c = Atom.to_string(color)

        {color,
         [
           content: %{
             background_color: {:color, color},
             color: {:color, String.to_atom("#{c}_ink")},
             border_color: {:raw, "var(--color-border-#{c}, var(--color-border))"}
           },
           arrow: %{"--arrow-background": {:raw, "var(--color-#{c})"}},
           arrow_tip: %{
             border_color: {:raw, "var(--color-border-#{c}, var(--color-border))"}
           }
         ]}
      end
    end

    defp size_variants do
      for size <- Axes.size_atoms() do
        {size,
         [
           content: %{
             max_width: {:container, size},
             padding: {:space, size}
           },
           arrow: %{"--arrow-size": {:raw, "calc(var(--space-#{size}) * 0.25)"}}
         ]}
      end
    end

    defp text_variants do
      for step <- Axes.text_atoms(), do: {step, [content: RecipePresets.text_block(step)]}
    end

    defp radius_variants do
      for r <- Axes.radius_atoms(), do: {r, [content: RecipePresets.rounded_block(r)]}
    end

    defp part(name), do: Selector.part(@id, @scope, name)
  end

  defmodule TreeNavigation do
    @moduledoc false

    def recipe, do: Corex.Design.Recipes.TreeView.navigation_recipe()
  end

  defmodule TreeView do
    @moduledoc false

    alias Corex.Design.Axes
    alias Corex.Design.Emit.Tokens, as: Var
    alias Corex.Design.Palette
    alias Corex.Design.Recipe
    alias Corex.Design.RecipePresets
    alias Corex.Design.Rule
    alias Corex.Design.Selector

    @scope "tree-view"
    @id :tree_view

    def recipe do
      Recipe.part_recipe(@id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules: base_rules(@id) ++ semantic_selection_rules(@id)
      )
    end

    def navigation_recipe do
      id = :tree_navigation

      Recipe.part_recipe(id,
        scope: @scope,
        host_sizing: [width: :full, max_width: :md, height: :auto, max_height: :none],
        base: [],
        variants: [
          semantic: semantic_variants(),
          size: size_variants(),
          text: text_variants(),
          radius: radius_variants()
        ],
        default_variants: [size: :md],
        extra_rules:
          base_rules(id) ++
            semantic_selection_rules(id) ++
            navigation_appearance_rules(id) ++
            navigation_transparent_overrides(id)
      )
    end

    defp base_rules(id) do
      host = Selector.host(id)
      root = part(id, "root")
      tree = part(id, "tree")
      label = part(id, "label")
      branch = part(id, "branch")
      branch_control = part(id, "branch-control")
      branch_text = part(id, "branch-text")
      branch_indicator = part(id, "branch-indicator")
      branch_content = part(id, "branch-content")
      item = part(id, "item")

      [
        Rule.new(~s(#{host} #{slot("root")}[data-loading]), decls: [include: :ui_loading]),
        Rule.new(host,
          decls: [width: "100%", max_width: {:container, :md}, min_width: "0"]
        ),
        Rule.new(root, decls: [include: :ui_root]),
        Rule.new(tree,
          decls: [display: "flex", flex_direction: "column", width: "100%"]
        ),
        Rule.new(label,
          decls: [include: :ui_label, padding_inline_start: {:space, :md}]
        ),
        Rule.new(branch,
          decls: [display: "flex", flex_direction: "column", width: "100%"]
        ),
        Rule.new(item, decls: [include: :ui_item]),
        Rule.new(branch_control,
          decls: [include: :ui_item, flex_wrap: "nowrap", min_width: "0"]
        ),
        Rule.new(branch_text,
          decls: [flex: "1 1 0%", min_width: "0", width: "auto", max_width: "100%"]
        ),
        Rule.new(branch_indicator,
          decls: [flex: "0 0 auto", margin_inline_start: "auto"]
        ),
        Rule.new("#{branch_control} [data-icon]",
          decls: [include: :ui_icon]
        ),
        Rule.new(
          "#{branch_control}[data-state='open']:not([data-selected]):not([data-checked]):not([data-indeterminate]):not([data-loading])",
          decls: [background_color: {:color, :ui_active}]
        ),
        Rule.new(
          "#{branch_indicator}[dir='rtl'][data-state='open'],\n  #{host} #{slot("item-indicator")}[dir='rtl'][data-state='open']",
          decls: [transform: "rotate(-90deg) !important"]
        ),
        Rule.new(branch_content,
          decls: [
            margin_inline_start: {:space, :md},
            min_width: "0",
            align_self: "stretch",
            position: "relative",
            isolation: "isolate"
          ]
        ),
        Rule.new(
          ~s(#{host} #{slot("branch-content")} > #{slot("item")},\n  #{host} #{slot("branch-content")} > #{slot("branch")}),
          decls: [
            flex: "0 0 auto",
            align_self: "stretch",
            width: "100%",
            max_width: "100%"
          ]
        ),
        Rule.new(~s(#{host} #{slot("branch-content")}[data-state='open']),
          decls: [visibility: "visible", display: "flex", flex_direction: "column"]
        ),
        Rule.new(
          ~s(#{host}[data-animation='js'] #{slot("branch-content")}[data-state='closed'],\n  #{host}[data-animation='custom'] #{slot("branch-content")}[data-state='closed']),
          decls: [
            display: "flex",
            flex_direction: "column",
            height: "0",
            opacity: "0",
            overflow: "hidden"
          ]
        ),
        Rule.new(part(id, "branch-label"), decls: [include: :ui_label]),
        Rule.new(
          ~s(#{host} #{slot("branch-content")} #{slot("branch-indent-guide")}),
          decls: [
            border_inline_start: {:raw, "1px solid var(--color-ui-ink-muted)"},
            top: "0",
            bottom: "0",
            right: "0",
            pointer_events: "none",
            opacity: "0.65"
          ]
        ),
        Rule.new(~s(#{host} #{slot("root")}[data-loading] #{slot("branch-text")}),
          decls: loading_skeleton_decls()
        ),
        Rule.new(~s(#{host} #{slot("root")}[data-loading] #{slot("branch-indicator")}),
          decls: loading_skeleton_decls()
        ),
        Rule.new(~s(#{host} #{slot("root")}[data-loading] #{slot("item-text")}),
          decls: loading_skeleton_decls()
        )
      ]
    end

    defp semantic_variants do
      Corex.Design.Recipes.semantic_part_host_variants()
    end

    defp semantic_selection_rules(id) do
      item = slot("item")
      branch_control = slot("branch-control")
      branch_content = slot("branch-content")
      branch_text = slot("branch-text")
      item_text = slot("item-text")
      label_part = slot("label")

      selected_attrs = [
        "[data-selected]",
        ~S([data-state='checked']),
        ~S([data-state='on']),
        "[data-in-range]",
        "[data-checked]",
        "[data-indeterminate]"
      ]

      for color <- Axes.semantic_atoms() do
        c = Atom.to_string(color)
        host_mod = Palette.host_mod(id, color)
        bg = "var(--color-#{c})"
        ink = "var(--color-#{c}-ink)"
        hover = "var(--color-#{c}-hover)"
        active = "var(--color-#{c}-active)"
        muted = "var(--color-#{c}-muted)"

        item_rules =
          for attr <- selected_attrs do
            Rule.new("#{host_mod} #{item}#{attr}",
              decls: [background_color: {:raw, bg}, color: {:raw, ink}],
              children: semantic_state_children(hover, active, ink, muted)
            )
          end

        branch_rules =
          for attr <- selected_attrs do
            Rule.new("#{host_mod} #{branch_control}#{attr}",
              decls: [background_color: {:raw, bg}, color: {:raw, ink}],
              children: semantic_state_children(hover, active, ink, muted, loading: true)
            )
          end

        spacing_rules = [
          Rule.new("#{host_mod} #{label_part}",
            decls: [padding_inline_start: {:space, :md}]
          ),
          Rule.new("#{host_mod} #{item}",
            decls: [padding_inline: {:space, :md}, gap: {:space, :md}]
          ),
          Rule.new("#{host_mod} #{branch_control}",
            decls: [padding_inline: {:space, :md}, gap: {:space, :md}]
          ),
          Rule.new("#{host_mod} #{item_text}, #{host_mod} #{branch_text}",
            decls: [gap: {:space, :md}]
          ),
          Rule.new(
            "#{host_mod} #{branch_content} #{slot("branch-indent-guide")}",
            decls: [border_inline_start: {:raw, "1px solid #{ink}"}]
          )
        ]

        item_rules ++ branch_rules ++ spacing_rules
      end
      |> List.flatten()
    end

    defp loading_skeleton_decls do
      [
        display: "inline-block",
        min_height: {:raw, Var.ref([:size])},
        background_color: {:color, :ui_active},
        border_radius: {:radius, :md},
        animation: "corex-skeleton 1.4s ease-in-out infinite"
      ]
    end

    defp semantic_state_children(hover, active, ink, muted, opts \\ []) do
      loading =
        if Keyword.get(opts, :loading, false) do
          [
            Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled],\n  &[data-loading]",
              decls: [background_color: {:raw, muted}, cursor: "not-allowed"]
            )
          ]
        else
          [
            Rule.new("&:disabled,\n  &[data-disabled],\n  &[disabled]",
              decls: [background_color: {:raw, muted}, cursor: "not-allowed"]
            )
          ]
        end

      [
        Rule.new("&:hover", decls: [background_color: {:raw, hover}]),
        Rule.new("&:active", decls: [background_color: {:raw, active}]),
        Rule.new("&:focus-visible",
          decls: [box_shadow: {:raw, "inset 0 0 0 2px #{ink}"}, outline: "none"]
        )
        | loading
      ]
    end

    defp navigation_appearance_rules(id) do
      root = nav_part(id, "root")
      tree = nav_part(id, "tree")
      label = nav_part(id, "label")
      branch = nav_part(id, "branch")
      item = nav_part(id, "item")
      branch_control = nav_part(id, "branch-control")
      branch_indicator = nav_part(id, "branch-indicator")
      branch_content = nav_part(id, "branch-content")
      branch_text = slot("branch-text")
      item_text = slot("item-text")

      [
        Rule.new(root,
          decls: [
            gap: {:space, :lg},
            padding_inline: {:space, :md},
            padding_block: {:space, :sm},
            align_self: "stretch",
            width: "100%"
          ]
        ),
        Rule.new(tree,
          decls: [gap: {:space, :sm}],
          children: [
            Rule.new("&:focus-visible",
              decls: [outline: "none", pointer_events: "none"]
            )
          ]
        ),
        Rule.new(label,
          decls: [
            {:raw, "text-transform: uppercase;"},
            padding_inline: "0",
            padding_block: {:raw, "var(--space) var(--space-sm)"},
            font_size: {:text, :xs},
            line_height: {:leading, :xs},
            font_weight: {:weight, :semibold},
            letter_spacing: {:raw, "0.05em"},
            color: {:color, :ui_ink_muted},
            background: "transparent"
          ]
        ),
        Rule.new(branch, decls: [gap: "0"]),
        Rule.new("#{item}, #{branch_control}",
          decls: [
            border: "0",
            border_radius: "0",
            min_height: {:size, :sm},
            padding_inline: {:space, :sm},
            gap: {:space, :sm},
            background_color: "transparent",
            box_shadow: "none",
            transition: "color 0.2s ease, border-color 0.2s ease"
          ]
        ),
        Rule.new(branch_control,
          decls: [flex_wrap: "nowrap", min_width: "0", overflow: "hidden"]
        ),
        Rule.new(branch_indicator,
          decls: [flex: "0 0 auto", margin_inline_start: "auto"]
        ),
        Rule.new("#{nav_host(id)}.layout__aside-tree",
          decls: [width: "100%", max_width: {:container, :xs}]
        ),
        Rule.new("#{branch_control}[data-disabled]",
          decls: [color: {:color, :ui_ink_muted}, background_color: "transparent"]
        ),
        Rule.new(item,
          decls: [border_inline_start: {:raw, "3px solid var(--color-border)"}]
        ),
        Rule.new(
          "#{item}:hover,\n  #{branch_control}:hover,\n  #{item}:active,\n  #{branch_control}:active",
          decls: [
            {:raw, "border-inline-start-color: var(--color-link);"},
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :ui_ink}
          ]
        ),
        Rule.new(
          "#{item}[data-focus],\n  #{branch_control}[data-focus],\n  #{item}[data-highlighted],\n  #{branch_control}[data-highlighted]",
          decls: [
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :link},
            font_weight: {:weight, :medium},
            outline: "none"
          ]
        ),
        Rule.new(
          "#{item}[data-focus],\n  #{item}[data-highlighted]",
          decls: [{:raw, "border-inline-start-color: var(--color-link);"}]
        ),
        Rule.new(
          "#{branch_control}[data-focus] #{branch_text},\n  #{branch_control}[data-highlighted] #{branch_text},\n  #{branch_text}[data-focus],\n  #{branch_text}[data-highlighted],\n  #{item_text}[data-focus],\n  #{item_text}[data-highlighted]",
          decls: [color: {:color, :link}, font_weight: {:weight, :medium}]
        ),
        Rule.new(
          "#{branch_control}[data-focus] #{branch_indicator},\n  #{branch_control}[data-highlighted] #{branch_indicator}",
          decls: [color: {:color, :link}]
        ),
        Rule.new(
          "#{item}[data-selected],\n  #{branch_control}[data-selected]",
          decls: [
            {:raw, "border-inline-start-color: var(--color-link);"},
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :link},
            font_weight: {:weight, :medium}
          ]
        ),
        Rule.new(
          "#{item}[data-selected]:hover,\n  #{branch_control}[data-selected]:hover,\n  #{item}[data-selected]:active,\n  #{branch_control}[data-selected]:active",
          decls: [
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :link}
          ]
        ),
        Rule.new(
          "#{branch_control}[data-state='open']:not([data-selected]):not([data-checked]):not([data-indeterminate]):not([data-loading]):not([data-focus]):not([data-highlighted])",
          decls: [
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :ui_ink},
            font_weight: {:weight, :medium}
          ]
        ),
        Rule.new(
          "#{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted]):hover,\n  #{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted]):active",
          decls: [
            background_color: "transparent",
            box_shadow: "none",
            color: {:color, :ui_ink},
            font_weight: {:weight, :medium}
          ]
        ),
        Rule.new(
          "#{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted]) #{branch_text}",
          decls: [color: {:color, :ui_ink}]
        ),
        Rule.new(
          "#{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted]) #{branch_indicator}",
          decls: [color: {:color, :link}]
        ),
        Rule.new(
          "#{branch}:has(#{item}[data-selected]) > #{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted])",
          decls: [color: {:color, :link}]
        ),
        Rule.new(
          "#{branch}:has(#{item}[data-selected]) > #{branch_control}[data-state='open']:not([data-focus]):not([data-highlighted]) #{branch_text}",
          decls: [color: {:color, :link}]
        ),
        Rule.new(branch_content,
          decls: [
            margin_inline_start: {:space, :sm},
            padding_block: "0",
            padding_inline: "0",
            gap: "0",
            overflow: "hidden"
          ]
        ),
        Rule.new(
          "#{nav_host(id)}.layout__aside-tree #{slot("branch-text")},\n  #{nav_host(id)}.layout__aside-tree #{slot("item-text")},\n  #{nav_part(id, "branch-text")},\n  #{nav_part(id, "item-text")}",
          decls: [flex: "1 1 0%", min_width: "0", width: "auto"]
        ),
        Rule.new(
          "#{branch_control}[data-focus] > #{branch_text},\n  #{branch_control}[data-highlighted] > #{branch_text},\n  #{branch_control}[data-focus] > #{branch_text} :is(span, a),\n  #{branch_control}[data-highlighted] > #{branch_text} :is(span, a)",
          decls: [color: {:color, :link}, font_weight: {:weight, :medium}]
        ),
        Rule.new(branch_control,
          decls: [
            display: "inline-flex",
            flex_flow: "row nowrap",
            align_items: "center"
          ]
        ),
        Rule.new(nav_part(id, "branch-text"),
          decls: [
            flex: "1 1 0%",
            min_width: "0",
            width: "auto",
            max_width: "100%"
          ]
        ),
        Rule.new(branch_indicator,
          decls: [
            flex: "0 0 auto",
            display: "inline-flex",
            align_items: "center",
            justify_content: "center"
          ]
        )
      ]
    end

    defp navigation_transparent_overrides(id) do
      item = nav_part(id, "item")
      branch_control = nav_part(id, "branch-control")

      selector =
        """
        #{item},
          #{branch_control},
          #{item}:is(:hover, :active, :focus, :focus-visible),
          #{branch_control}:is(:hover, :active, :focus, :focus-visible),
          #{item}[data-focus],
          #{branch_control}[data-focus],
          #{item}[data-highlighted],
          #{branch_control}[data-highlighted],
          #{item}[data-selected],
          #{branch_control}[data-selected],
          #{item}[data-checked],
          #{branch_control}[data-checked],
          #{item}[data-indeterminate],
          #{branch_control}[data-indeterminate],
          #{branch_control}[data-state="open"],
          #{branch_control}[data-state="open"]:is(:hover, :active, :focus, :focus-visible)
        """
        |> String.trim()

      [
        Rule.new(
          selector,
          decls: [
            background: "transparent !important",
            background_color: "transparent !important",
            box_shadow: "none !important"
          ]
        )
      ]
    end

    defp size_variants do
      block = fn size ->
        [
          label: %{padding_inline_start: {:space, size}},
          item: Map.merge(RecipePresets.size_block(size), %{padding_inline: {:space, size}}),
          branch_control: RecipePresets.size_block(size),
          item_text: %{gap: {:space, size}},
          branch_text: %{gap: {:space, size}}
        ]
      end

      for size <- Axes.size_atoms(), do: {size, block.(size)}
    end

    defp text_variants do
      block = fn step ->
        [
          item: RecipePresets.text_block(step),
          branch_control: RecipePresets.text_block(step),
          item_text: RecipePresets.text_block(step),
          branch_text: RecipePresets.text_block(step)
        ]
      end

      for step <- Axes.text_atoms(), do: {step, block.(step)}
    end

    defp radius_variants do
      block = fn r ->
        [
          item: RecipePresets.rounded_block(r),
          branch_control: RecipePresets.rounded_block(r)
        ]
      end

      for r <- Axes.radius_atoms(), do: {r, block.(r)}
    end

    defp nav_host(id), do: Selector.host(id)

    defp nav_part(id, name), do: "#{nav_host(id)} #{slot(name)}"

    defp part(id, name), do: Selector.part(id, @scope, name)

    defp slot(name), do: Selector.slot(@scope, name)
  end
end
