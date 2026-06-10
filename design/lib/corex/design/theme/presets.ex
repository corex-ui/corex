defmodule Corex.Design.Theme.Presets do
  @moduledoc """
  Built-in theme presets (neo, uno, duo, leo). Copy into host config or reference
  directly:

      config :corex_design,
        themes: Corex.Design.Theme.Presets.all()
  """

  alias Corex.Design.Theme

  def all do
    %{neo: neo(), uno: uno(), duo: duo(), leo: leo()}
  end

  def neo, do: Theme.normalize_input_spec(neo_raw())

  def uno, do: Theme.merge_specs(neo(), uno_overrides())

  def duo, do: Theme.merge_specs(neo(), duo_overrides())

  def leo, do: Theme.merge_specs(neo(), leo_overrides())

  defp neo_raw do
    %{
      seeds: neo_seeds(),
      colors: %{light: neo_light_colors(), dark: neo_dark_colors()},
      dimensions: neo_dimensions()
    }
  end

  defp uno_overrides do
    %{
      seeds: uno_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{stop: 50},
            root: %{stop: 50},
            ui: %{stop: 50, states: %{muted: 50, default: 50, hover: 100, active: 100}}
          },
          utility: %{
            border: %{ratio: 1.32},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.1}
          },
          ink: %{default: %{ratio: 8.5}}
        },
        dark: %{
          surface: %{
            layer: %{stop: 950},
            root: %{stop: 950},
            ui: %{stop: 900, states: %{muted: 900, default: 900, hover: 950, active: 950}}
          },
          utility: %{
            border: %{ratio: 1.42},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.22}
          },
          ink: %{default: %{ratio: 12.25}}
        }
      },
      dimensions: %{
        space_scale: 0.92,
        size_scale: 0.92,
        text_scale: 0.92,
        radius_scale: 0.88,
        container_scale: 0.92,
        radius: uno_radius_curve(),
        font: uno_font_stacks()
      }
    }
  end

  defp duo_overrides do
    %{
      seeds: duo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{stop: 50},
            root: %{stop: 50},
            ui: %{stop: 100, states: %{muted: 50, default: 100, hover: 100, active: 200}}
          },
          utility: %{
            border: %{ratio: 1.34},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{stop: 600, states: %{muted: 500, default: 600, hover: 600, active: 700}},
            brand: %{stop: 800, states: %{muted: 700, default: 800, hover: 800, active: 900}},
            selected: %{ink: %{color: "brand", ratio: 7}}
          }
        },
        dark: %{
          surface: %{
            layer: %{stop: 950},
            root: %{stop: 950},
            ui: %{stop: 900, states: %{muted: 900, default: 900, hover: 950, active: 950}}
          },
          utility: %{
            border: %{ratio: 1.43},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.23}
          },
          ink: %{default: %{ratio: 12.1}}
        }
      },
      dimensions: %{
        space_scale: 1.0,
        size_scale: 1.0,
        text_scale: 1.02,
        radius_scale: 1.15,
        container_scale: 1.0,
        radius: duo_radius_curve(),
        font: duo_font_stacks()
      }
    }
  end

  defp leo_overrides do
    %{
      seeds: leo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{stop: 50},
            root: %{stop: 50},
            ui: %{stop: 100, states: %{muted: 50, default: 100, hover: 100, active: 200}}
          },
          utility: %{
            border: %{ratio: 1.34},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{stop: 700, states: %{muted: 600, default: 700, hover: 700, active: 800}},
            brand: %{stop: 700, states: %{muted: 600, default: 700, hover: 700, active: 800}},
            success: %{stop: 700, states: %{muted: 600, default: 700, hover: 700, active: 800}}
          }
        },
        dark: %{
          surface: %{
            layer: %{stop: 950},
            root: %{stop: 950},
            ui: %{stop: 900, states: %{muted: 900, default: 900, hover: 950, active: 950}}
          },
          utility: %{
            border: %{ratio: 1.43},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.23}
          },
          ink: %{default: %{ratio: 12.1}}
        }
      },
      dimensions: %{
        space_scale: 0.96,
        size_scale: 0.96,
        text_scale: 0.96,
        radius_scale: 0.82,
        container_scale: 0.96,
        radius: leo_radius_curve(),
        font: leo_font_stacks()
      }
    }
  end

  defp neo_dimensions do
    %{
      space_scale: 1.0,
      size_scale: 1.0,
      text_scale: 1.0,
      radius_scale: 1.0,
      container_scale: 1.0,
      radius: neo_radius_curve(),
      font: neo_font_stacks()
    }
  end

  defp neo_font_stacks do
    figtree = [
      "Figtree",
      "ui-sans-serif",
      "system-ui",
      "sans-serif",
      "Apple Color Emoji",
      "Segoe UI Emoji",
      "Segoe UI Symbol",
      "Noto Color Emoji"
    ]

    %{sans: figtree, display: figtree}
  end

  defp uno_font_stacks do
    %{
      sans: [
        "Inter",
        "ui-sans-serif",
        "system-ui",
        "sans-serif",
        "Apple Color Emoji",
        "Segoe UI Emoji"
      ]
    }
  end

  defp duo_font_stacks do
    %{
      sans: [
        "Source Sans 3",
        "Segoe UI",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ]
    }
  end

  defp leo_font_stacks do
    %{
      sans: [
        "IBM Plex Sans",
        "Segoe UI",
        "Roboto",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ]
    }
  end

  defp neo_radius_curve do
    %{
      xs: 0.125,
      sm: 0.25,
      md: 0.375,
      lg: 0.5,
      xl: 0.75,
      "2xl": 1.0,
      "3xl": 1.5,
      "4xl": 2.0,
      full: 9999
    }
  end

  defp uno_radius_curve do
    %{
      xs: 0.1,
      sm: 0.2,
      md: 0.3,
      lg: 0.4,
      xl: 0.55,
      "2xl": 0.7,
      "3xl": 1.0,
      "4xl": 1.25,
      full: 9999
    }
  end

  defp duo_radius_curve do
    %{
      xs: 0.15,
      sm: 0.3,
      md: 0.45,
      lg: 0.7,
      xl: 1.0,
      "2xl": 1.35,
      "3xl": 2.0,
      "4xl": 2.75,
      full: 9999
    }
  end

  defp leo_radius_curve do
    %{
      xs: 0.08,
      sm: 0.15,
      md: 0.25,
      lg: 0.35,
      xl: 0.5,
      "2xl": 0.65,
      "3xl": 0.85,
      "4xl": 1.1,
      full: 9999
    }
  end

  defp neo_seeds do
    %{
      "accent" => "#4B4B4B",
      "alert" => "#A43C3C",
      "base" => "#F0F0F0",
      "brand" => "#32479C",
      "info" => "#1F77D4",
      "success" => "#059669"
    }
  end

  defp uno_seeds do
    %{
      "accent" => "#475569",
      "alert" => "#B91C1C",
      "base" => "#EEF2F7",
      "brand" => "#0E7490",
      "info" => "#0369A1",
      "success" => "#047857"
    }
  end

  defp duo_seeds do
    %{
      "accent" => "#57534E",
      "alert" => "#9F1239",
      "base" => "#FAF7F2",
      "brand" => "#5B21B6",
      "info" => "#1D4ED8",
      "success" => "#15803D"
    }
  end

  defp leo_seeds do
    %{
      "accent" => "#3F3F46",
      "alert" => "#991B1B",
      "base" => "#F4F4F5",
      "brand" => "#B45309",
      "info" => "#1E40AF",
      "success" => "#166534"
    }
  end

  defp neo_light_colors do
    %{
      ink: %{
        accent: %{color: "accent", ratio: 6},
        alert: %{color: "alert", ratio: 6},
        brand: %{color: "brand", ratio: 6},
        default: %{color: "base", ratio: 8},
        info: %{color: "info", ratio: 6},
        link: %{color: "info", ratio: 6},
        muted: %{color: "base", ratio: 5.15},
        success: %{color: "success", ratio: 6}
      },
      semantic: neo_light_semantic(),
      surface: neo_light_surface(),
      utility: %{
        border: %{color: "base", ratio: 1.3},
        outline: %{color: "base", ratio: 2.2},
        shadow: %{color: "base", ratio: 1.05}
      }
    }
  end

  defp neo_dark_colors do
    %{
      ink: %{
        accent: %{color: "accent", ratio: 7.5},
        alert: %{color: "alert", ratio: 7.5},
        brand: %{color: "brand", ratio: 7.5},
        default: %{color: "base", ratio: 12},
        info: %{color: "info", ratio: 7.5},
        link: %{color: "info", ratio: 7.5},
        muted: %{color: "base", ratio: 6},
        success: %{color: "success", ratio: 7.5}
      },
      semantic: neo_dark_semantic(),
      surface: neo_dark_surface(),
      utility: %{
        border: %{color: "base", ratio: 1.4},
        outline: %{color: "base", ratio: 2.4},
        shadow: %{color: "base", ratio: 1.2}
      }
    }
  end

  defp neo_light_surface do
    %{
      layer: %{color: "base", stop: 50},
      root: %{color: "base", stop: 50},
      ui: %{
        color: "base",
        stop: 100,
        states: %{muted: 50, default: 100, hover: 100, active: 200}
      }
    }
  end

  defp neo_dark_surface do
    %{
      layer: %{color: "base", stop: 950},
      root: %{color: "base", stop: 950},
      ui: %{
        color: "base",
        stop: 900,
        states: %{muted: 900, default: 900, hover: 950, active: 950}
      }
    }
  end

  defp neo_light_semantic do
    fill = %{stop: 700, states: %{muted: 600, default: 700, hover: 700, active: 800}}
    ink = %{color: "base", ratio: 7}

    %{
      accent: Map.merge(fill, %{bg: "accent", ink: ink}),
      alert: Map.merge(fill, %{bg: "alert", ink: ink}),
      brand: Map.merge(fill, %{bg: "brand", ink: ink}),
      info: Map.merge(fill, %{bg: "info", ink: ink}),
      selected: %{
        bg: "base",
        stop: 100,
        states: %{muted: 100, default: 100, hover: 200, active: 200},
        ink: ink
      },
      success: Map.merge(fill, %{bg: "success", ink: ink})
    }
  end

  defp neo_dark_semantic do
    fill = %{stop: 600, states: %{muted: 500, default: 600, hover: 600, active: 700}}
    ink = %{color: "base", ratio: 7}

    %{
      accent: Map.merge(fill, %{bg: "accent", ink: ink}),
      alert: Map.merge(fill, %{bg: "alert", ink: ink}),
      brand: Map.merge(fill, %{bg: "brand", ink: ink}),
      info: Map.merge(fill, %{bg: "info", ink: ink}),
      selected: %{
        bg: "base",
        stop: 800,
        states: %{muted: 800, default: 800, hover: 900, active: 900},
        ink: ink
      },
      success: Map.merge(fill, %{bg: "success", ink: ink})
    }
  end
end
