defmodule Corex.MCP.Tools.Design do
  @moduledoc false

  alias Corex.MCP.DesignAvailable
  alias Corex.MCP.Json

  @max_id_length 64
  @valid_guide_topics ~W(setup modifiers theming dark_mode all)
  @valid_axes ~W(semantic variant size radius max_height shape)

  @fallback_semantics ~w(base accent brand alert info success)
  @fallback_sizes ~w(xs sm md lg xl)
  @fallback_radii ~w(none xs sm md lg xl 2xl 3xl 4xl full)
  @fallback_max_heights ~w(xs sm md lg xl 2xl 3xl 4xl 5xl 6xl)

  @elixir_to_css %{
    "angle_slider" => "angle-slider",
    "color_picker" => "color-picker",
    "data_list" => "data-list",
    "data_table" => "data-table",
    "date_picker" => "date-picker",
    "file_upload" => "file-upload",
    "floating_panel" => "floating-panel",
    "native_input" => "native-input",
    "number_input" => "number-input",
    "password_input" => "password-input",
    "pin_input" => "pin-input",
    "radio_group" => "radio-group",
    "signature_pad" => "signature-pad",
    "tags_input" => "tags-input",
    "toggle_group" => "toggle-group",
    "tree_view" => "tree-view",
    "action" => "button"
  }

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
              description: "setup, modifiers, theming, dark_mode, or all (default)."
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

  def list_modifiers(_), do: {:error, :invalid_arguments}

  def get_component_style(%{"id" => id} = args)
      when is_binary(id) and byte_size(id) <= @max_id_length and map_size(args) == 1 do
    with :ok <- DesignAvailable.ensure_design(),
         {:ok, css_id} <- resolve_css_id(id) do
      encode(component_style(css_id, id))
    end
  end

  def get_component_style(_), do: {:error, :invalid_arguments}

  def list_themes(%{} = args) when map_size(args) == 0 do
    case DesignAvailable.ensure_design() do
      :ok -> encode(themes_payload())
      error -> error
    end
  end

  def list_themes(_), do: {:error, :invalid_arguments}

  def design_guide(args) when args in [nil, %{}] do
    encode(guide_payload("all"))
  end

  def design_guide(%{"topic" => topic} = args)
      when topic in @valid_guide_topics and map_size(args) == 1 do
    encode(guide_payload(topic))
  end

  def design_guide(_), do: {:error, :invalid_arguments}

  def css_id_for_elixir(id) when is_binary(id) do
    Map.get(@elixir_to_css, id, String.replace(id, "_", "-"))
  end

  def design_enrichment(elixir_id) when is_binary(elixir_id) do
    if DesignAvailable.design_available?() do
      css_id = css_id_for_elixir(elixir_id)

      if css_id in DesignAvailable.layout_ids() do
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
        %{design_available: true, css_id: css_id, note: "No ComponentLayout entry for this id."}
      end
    else
      %{
        design_available: false,
        css_id: css_id_for_elixir(elixir_id),
        root_class: css_id_for_elixir(elixir_id)
      }
    end
  end

  defp encode(payload), do: {:ok, Json.encode!(payload)}

  defp modifier_vocabulary(nil) do
    base = full_modifier_vocabulary()
    Map.put(base, :axis, nil)
  end

  defp modifier_vocabulary(axis) do
    full = full_modifier_vocabulary()

    slice =
      case axis do
        "semantic" -> %{semantic: full.semantic}
        "variant" -> %{variant: full.variant}
        "size" -> %{size: full.size}
        "radius" -> %{radius: full.radius}
        "max_height" -> %{max_height: full.max_height}
        "shape" -> %{shape: full.shape}
      end

    Map.merge(slice, %{
      axis: axis,
      pattern: full.pattern,
      anti_patterns: full.anti_patterns,
      design_available: full.design_available
    })
  end

  defp full_modifier_vocabulary do
    design? = DesignAvailable.design_available?()

    semantics =
      if design? do
        DesignAvailable.default_semantics() |> Enum.map(&to_string/1)
      else
        @fallback_semantics
      end

    sizes =
      if design? do
        DesignAvailable.sizes()
      else
        @fallback_sizes
      end

    radii =
      if design? do
        DesignAvailable.radii()
      else
        @fallback_radii
      end

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
        note: "Do not invent ghost or outline variants."
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
        steps: @fallback_max_heights,
        classes: Enum.map(@fallback_max_heights, &"ui-max-h-#{&1}")
      },
      shape: %{
        note: "Button/action hosts only.",
        classes: ["ui-square", "ui-circle"]
      },
      anti_patterns: [
        "Do not invent new class names or BEM modifiers in templates.",
        "Do not add custom CSS or @apply for Corex hosts.",
        "Prefer typography components or .typo over ad-hoc text utilities."
      ]
    }
  end

  defp resolve_css_id(id) do
    css_id =
      if String.contains?(id, "_") do
        css_id_for_elixir(id)
      else
        id
      end

    if css_id in DesignAvailable.layout_ids() do
      {:ok, css_id}
    else
      {:error,
       "Unknown design component id. Use list_components or a CSS id from ComponentLayout."}
    end
  end

  defp component_style(css_id, original_id) do
    layout = DesignAvailable.layout_get(css_id)
    axes = default_axes_for(css_id)
    root = String.trim_leading(DesignAvailable.layout_host_selector(css_id), ".")

    examples =
      [
        "#{root} ui-accent ui-size-lg",
        "#{root} ui-accent ui-solid ui-size-md",
        "#{root} ui-brand ui-size-lg ui-rounded-xl"
      ]

    %{
      id: original_id,
      css_id: css_id,
      root_class: root,
      axes: axes,
      examples: examples,
      layout: %{
        host_width: DesignAvailable.layout_host_width_label(css_id),
        default_max: DesignAvailable.layout_default_max_label(css_id),
        host_width_atom: layout.host_width,
        default_max_raw: encode_default_max(layout.default_max)
      },
      design_css_path: relative_design_css_path(css_id),
      design_available: true
    }
  end

  defp encode_default_max(:none), do: "none"
  defp encode_default_max(:fit_content), do: "fit-content"
  defp encode_default_max({:container, step}), do: "container:#{step}"

  defp relative_design_css_path(css_id) do
    abs = DesignAvailable.layout_css_path(css_id)
    root = Path.expand(Corex.MCP.root())

    cond do
      String.starts_with?(abs, root <> "/") -> Path.relative_to(abs, root)
      true -> "priv/css/components/#{css_id}.css"
    end
  end

  defp default_axes_for("button"), do: ["semantic", "variant", "size", "radius", "shape"]
  defp default_axes_for("badge"), do: ["semantic", "variant", "size", "radius"]
  defp default_axes_for("typo"), do: ["semantic", "size"]
  defp default_axes_for("icon"), do: ["semantic", "size"]
  defp default_axes_for("link"), do: ["semantic"]
  defp default_axes_for("scrollbar"), do: ["size"]

  defp default_axes_for(_),
    do: ["semantic", "variant", "size", "radius", "max_height"]

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
      end

    Map.merge(%{topic: topic, reference_urls: reference_urls()}, section)
  end

  defp setup_section do
    %{
      intent: "Wire Corex Design CSS into a Phoenix or Tableau app.",
      steps: [
        "Add {:corex_design, \"~> 0.2\", runtime: false, only: :dev} to mix.exs",
        "Configure config :corex_design (output, default_theme, default_mode, components)",
        "Add corex.design.build to assets.build / assets.deploy",
        "Import in assets/css/app.css: @import \"../corex/corex.css\"; and @source \"../corex\";",
        "Run mix corex.design.build"
      ],
      app_css: """
      @import \"../corex/corex.css\";
      @source \"../corex\";
      """
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

  defp reference_urls do
    %{
      hexdocs_design: "https://hexdocs.pm/corex/design.html",
      modifiers: "https://hexdocs.pm/corex_design/modifiers.html",
      theming: "https://hexdocs.pm/corex/theming.html",
      dark_mode: "https://hexdocs.pm/corex/dark_mode.html"
    }
  end
end
