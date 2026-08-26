defmodule Corex.MCP.Tools.Design do
  @moduledoc false

  alias Corex.MCP.DesignAvailable
  alias Corex.MCP.Json
  alias Corex.MCP.ToolError

  @max_id_length 64
  @valid_guide_topics ~W(setup modifiers theming dark_mode accessibility all)
  @axis_keys %{
    "semantic" => :semantic,
    "variant" => :variant,
    "size" => :size,
    "radius" => :radius,
    "max_height" => :max_height,
    "width" => :width,
    "shape" => :shape
  }
  @valid_axes Map.keys(@axis_keys) |> Enum.sort()

  def tools do
    [
      %{
        name: "list_modifiers",
        description: """
        Return the shared Corex Design ui-* modifier vocabulary (semantic roles, variant, size, radius, max-height, button shape) and anti-patterns. Optional axis filter.
        """,
        inputSchema: %{
          type: "object",
          properties: %{
            axis: %{
              type: "string",
              enum: @valid_axes,
              description: "Optional axis to return only that slice of the vocabulary."
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &list_modifiers/1
      },
      %{
        name: "get_component_style",
        description: """
        Return design metadata for one component: css_id, root_class, modifier axes, class examples, layout, and recipe path when corex_design is loaded.
        Pass Elixir id (date_picker) or CSS id (date-picker).
        """,
        inputSchema: %{
          type: "object",
          required: ["id"],
          properties: %{
            id: %{
              type: "string",
              description: "Component id, e.g. accordion, date_picker, or date-picker"
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &get_component_style/1
      },
      %{
        name: "list_themes",
        description: """
        List built-in Corex Design theme preset ids, modes, and defaults when corex_design is loaded.
        """,
        inputSchema: %{
          type: "object",
          properties: %{}
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &list_themes/1
      },
      %{
        name: "design_guide",
        description: """
        Return copy-paste design setup: CSS import, modifiers, theming, or dark mode. Read-only; does not run commands.
        """,
        inputSchema: %{
          type: "object",
          properties: %{
            topic: %{
              type: "string",
              enum: @valid_guide_topics,
              description:
                "setup, modifiers, theming, dark_mode, accessibility, or all (default)."
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &design_guide/1
      }
    ]
  end

  def list_modifiers(args) when args in [nil, %{}] do
    encode(modifier_vocabulary(nil))
  end

  def list_modifiers(%{"axis" => axis} = args)
      when axis in @valid_axes and map_size(args) == 1 do
    encode(modifier_vocabulary(axis))
  end

  def list_modifiers(%{"axis" => axis} = args) when is_binary(axis) and map_size(args) == 1 do
    ToolError.unknown_value("list_modifiers", "axis", @valid_axes)
  end

  def list_modifiers(_) do
    ToolError.invalid_arguments("list_modifiers", "optional axis: one of #{axis_list()}")
  end

  def get_component_style(%{"id" => id} = args)
      when is_binary(id) and byte_size(id) <= @max_id_length and map_size(args) == 1 do
    with :ok <- DesignAvailable.ensure_design(),
         {:ok, css_id} <- resolve_css_id(id) do
      encode(component_style(css_id, id))
    end
  end

  def get_component_style(_) do
    ToolError.invalid_arguments(
      "get_component_style",
      "required id: string of at most #{@max_id_length} bytes, e.g. accordion, date_picker, or date-picker"
    )
  end

  def list_themes(%{} = args) when map_size(args) == 0 do
    case DesignAvailable.ensure_design() do
      :ok -> encode(themes_payload())
      error -> error
    end
  end

  def list_themes(_), do: ToolError.invalid_arguments("list_themes", "no arguments")

  def design_guide(args) when args in [nil, %{}] do
    encode(guide_payload("all"))
  end

  def design_guide(%{"topic" => topic} = args)
      when topic in @valid_guide_topics and map_size(args) == 1 do
    encode(guide_payload(topic))
  end

  def design_guide(%{"topic" => topic} = args) when is_binary(topic) and map_size(args) == 1 do
    ToolError.unknown_value("design_guide", "topic", @valid_guide_topics)
  end

  def design_guide(_) do
    ToolError.invalid_arguments(
      "design_guide",
      "optional topic: one of #{Enum.join(@valid_guide_topics, ", ")}"
    )
  end

  defp axis_list, do: Enum.join(@valid_axes, ", ")

  @doc """
  Adds the design slice to a `get_component` payload.

  Three outcomes, each self-describing: design loaded and the component has a
  styled host, design loaded but the component has none (`hidden_input`), or
  design not loaded at all. Only the first can name a root class, because the
  class only exists once corex_design has emitted its CSS.
  """
  def design_enrichment(elixir_id) when is_binary(elixir_id) do
    with :ok <- DesignAvailable.ensure_design(),
         {:ok, css_id} <- DesignAvailable.fetch_css_id(elixir_id) do
      style = component_style(css_id, elixir_id)

      %{
        design_available: true,
        css_id: style.css_id,
        root_class: style.root_class,
        modifiers: %{
          axes: style.axes,
          examples: style.examples
        },
        layout: style.layout,
        design_css_path: style.design_css_path
      }
    else
      :error ->
        %{
          design_available: true,
          css_id: nil,
          note: "#{elixir_id} renders no styled host, so it has no design modifiers."
        }

      {:error, reason} ->
        %{design_available: false, note: reason}
    end
  end

  defp encode(payload), do: {:ok, Json.encode!(payload)}

  defp modifier_vocabulary(nil) do
    base = full_modifier_vocabulary()
    Map.put(base, :axis, nil)
  end

  defp modifier_vocabulary(axis) do
    full = full_modifier_vocabulary()

    slice = Map.take(full, [Map.fetch!(@axis_keys, axis)])

    Map.merge(slice, %{
      axis: axis,
      pattern: full.pattern,
      anti_patterns: full.anti_patterns,
      design_available: full.design_available
    })
  end

  defp full_modifier_vocabulary do
    if DesignAvailable.design_available?() do
      modifier_vocabulary_from_design()
    else
      modifier_vocabulary_unavailable()
    end
  end

  defp modifier_vocabulary_from_design do
    build_modifier_vocabulary(
      true,
      Enum.map(DesignAvailable.default_semantics(), &to_string/1),
      DesignAvailable.sizes(),
      DesignAvailable.radii(),
      DesignAvailable.max_heights(),
      DesignAvailable.widths()
    )
  end

  defp modifier_vocabulary_unavailable do
    false
    |> build_modifier_vocabulary([], [], [], [], [])
    |> Map.put(
      :note,
      "Step ladders come from corex_design. Add {:corex_design, \"~> 0.2\", runtime: false} to mix.exs to get the real vocabulary."
    )
  end

  defp build_modifier_vocabulary(design?, semantics, sizes, radii, max_heights, widths) do
    %{
      design_available: design?,
      pattern: "<root> ui-<role> ui-solid ui-size-<step> ui-rounded-<step>",
      semantic: %{
        roles: semantics,
        classes: Enum.map(semantics, &"ui-#{&1}")
      },
      variant: %{
        default: "subtle (no class)",
        solid: "ui-solid",
        ghost: "ui-ghost",
        note:
          "Action hosts only. Selection, field and static hosts have no variant axis; call get_component_style to see a host's axes."
      },
      size: %{
        steps: sizes,
        classes: Enum.map(sizes, &"ui-size-#{&1}")
      },
      radius: %{
        steps: radii,
        classes: Enum.map(radii, &"ui-rounded-#{&1}")
      },
      max_height: %{
        steps: max_heights,
        classes: Enum.map(max_heights, &"ui-max-height-#{&1}")
      },
      width: %{
        steps: widths,
        classes: Enum.map(widths, &"ui-width-#{&1}")
      },
      shape: %{
        note: "Button and badge hosts.",
        classes: ["ui-trigger--square", "ui-trigger--circle"]
      },
      anti_patterns: [
        "Do not invent new class names or BEM modifiers in templates.",
        "Do not add custom CSS or @apply for Corex hosts.",
        "Prefer typography components or .typo over ad-hoc text utilities."
      ]
    }
  end

  defp resolve_css_id(id) do
    if id in DesignAvailable.component_ids() do
      {:ok, id}
    else
      resolve_elixir_id(id)
    end
  end

  defp resolve_elixir_id(id) do
    case DesignAvailable.fetch_css_id(id) do
      {:ok, css_id} -> {:ok, css_id}
      :error -> ToolError.unknown_id("get_component_style", id, "list_components")
    end
  end

  defp component_style(css_id, original_id) do
    axes = DesignAvailable.axes_for(css_id) |> Enum.map(&Atom.to_string/1)
    root = String.trim_leading(DesignAvailable.host_selector(css_id), ".")
    examples = style_examples(root, axes)
    host_width = DesignAvailable.host_width(css_id)
    default_max = DesignAvailable.default_max(css_id)

    %{
      id: original_id,
      css_id: css_id,
      root_class: root,
      axes: axes,
      examples: examples,
      layout: %{
        host_width: DesignAvailable.host_width_label(css_id),
        default_max: DesignAvailable.default_max_label(css_id),
        host_width_atom: host_width,
        default_max_raw: encode_default_max(default_max)
      },
      design_css_path: relative_design_css_path(css_id),
      design_available: true
    }
  end

  defp style_examples(root, axes) do
    if "variant" in axes do
      [
        "#{root} ui-accent ui-size-lg",
        "#{root} ui-accent ui-solid ui-size-md",
        "#{root} ui-brand ui-size-lg ui-rounded-xl"
      ]
    else
      [
        "#{root} ui-accent ui-size-lg",
        "#{root} ui-brand ui-size-md",
        "#{root} ui-info ui-size-lg ui-rounded-xl"
      ]
    end
  end

  defp encode_default_max(:none), do: "none"
  defp encode_default_max(:fit_content), do: "fit-content"
  defp encode_default_max({:container, step}), do: "container:#{step}"

  defp relative_design_css_path(css_id) do
    abs = DesignAvailable.css_path(css_id)
    root = Path.expand(Corex.MCP.root())

    if String.starts_with?(abs, root <> "/") do
      Path.relative_to(abs, root)
    else
      "priv/css/components/#{css_id}.css"
    end
  end

  defp themes_payload do
    %{
      design_available: true,
      presets: DesignAvailable.preset_ids() |> Enum.map(&to_string/1),
      modes: DesignAvailable.theme_modes() |> Enum.map(&to_string/1),
      default_theme: to_string(DesignAvailable.default_theme()),
      default_mode: to_string(DesignAvailable.default_mode()),
      html_attrs: %{
        theme: "data-theme=\"neo\"",
        mode: "data-mode=\"light\"|\"dark\""
      },
      notes: [
        "neo uses system fonts; uno/duo/leo may load web fonts.",
        "Switch theme/mode via html attributes; do not override token CSS variables in templates."
      ]
    }
  end

  defp guide_payload("all") do
    %{
      topic: "all",
      setup: setup_section(),
      modifiers: modifiers_section(),
      theming: theming_section(),
      dark_mode: dark_mode_section(),
      accessibility: accessibility_section(),
      reference_urls: reference_urls()
    }
  end

  defp guide_payload(topic) do
    section =
      case topic do
        "setup" -> setup_section()
        "modifiers" -> modifiers_section()
        "theming" -> theming_section()
        "dark_mode" -> dark_mode_section()
        "accessibility" -> accessibility_section()
      end

    Map.merge(%{topic: topic, reference_urls: reference_urls()}, section)
  end

  defp setup_section do
    %{
      intent: "Wire Corex Design CSS into a Phoenix or Tableau app.",
      steps: [
        "Add {:corex_design, \"~> 0.2\", runtime: false} to mix.exs",
        "Configure config :corex_design (output, default_theme, default_mode, components, optional accessibility)",
        "Add corex.design.build to assets.build / assets.deploy",
        "Import in assets/css/app.css (Phoenix) or assets/css/site.css (Tableau): @import \"../corex/corex.css\"; and @source \"../corex\";",
        "Run mix corex.design.build"
      ],
      app_css: """
      @import \"../corex/corex.css\";
      @source \"../corex\";
      """,
      note:
        "With accessibility preference CSS (--a11y), plugs/hooks call Corex.Design.Accessibility; keep corex_design without only: :dev so those modules load in every Mix env."
    }
  end

  defp modifiers_section do
    %{
      intent: "Style Corex hosts with shared ui-* modifiers only.",
      pattern: "<root> ui-<role> ui-solid ui-size-<step> ui-rounded-<step>",
      example: "class=\"timer ui-accent ui-size-lg ui-rounded-xl\"",
      tip: "Call list_modifiers or get_component_style before inventing classes."
    }
  end

  defp theming_section do
    %{
      intent: "Select a built-in or custom theme.",
      html: "<html data-theme=\"neo\" data-mode=\"light\">",
      tip: "Call list_themes for preset ids. Prefer theme/mode swap over token overrides."
    }
  end

  defp dark_mode_section do
    %{
      intent: "Toggle light/dark without restyling components.",
      html: "<html data-theme=\"neo\" data-mode=\"dark\">",
      tip:
        "Use Corex mode helpers when generated with --mode; never hard-code dark palette utilities."
    }
  end

  defp accessibility_section do
    %{
      intent:
        "Emit preference CSS and wire user axes (text, contrast, motion, cursor, focus, links).",
      config: "config :corex_design, accessibility: true",
      flags: "--a11y on mix corex.new / mix corex.tableau.new",
      tip:
        "accessibility: true enables all six axes; pass an axis list to emit a subset. Keep corex_design without only: :dev so plugs/hooks can call Corex.Design.Accessibility.",
      guide: "https://hexdocs.pm/corex/accessibility.html"
    }
  end

  defp reference_urls do
    %{
      hexdocs_design: "https://hexdocs.pm/corex/design.html",
      modifiers: "https://hexdocs.pm/corex_design/modifiers.html",
      theming: "https://hexdocs.pm/corex/theming.html",
      dark_mode: "https://hexdocs.pm/corex/dark_mode.html",
      accessibility: "https://hexdocs.pm/corex/accessibility.html"
    }
  end
end
