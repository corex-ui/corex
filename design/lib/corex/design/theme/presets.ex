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
            layer: %{lightness: 97},
            root: %{lightness: 100},
            ui: %{
              lightness: 94,
              states: %{muted: 97, default: 94, hover: 90, active: 87}
            }
          },
          utility: %{
            border: %{ratio: 1.12},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.1}
          },
          ink: %{default: %{ratio: 8.5}}
        },
        dark: %{
          surface: %{
            layer: %{lightness: 14},
            root: %{lightness: 7},
            ui: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          utility: %{
            border: %{ratio: 1.18},
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
        radius: uno_radius_curve()
      }
    }
  end

  defp duo_overrides do
    %{
      seeds: duo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{lightness: 97},
            root: %{lightness: 99},
            ui: %{
              lightness: 92,
              states: %{muted: 95, default: 92, hover: 88, active: 85}
            }
          },
          utility: %{
            border: %{ratio: 1.14},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{
              lightness: 42,
              states: %{muted: 45, default: 42, hover: 38, active: 35}
            },
            brand: %{
              lightness: 38,
              states: %{muted: 41, default: 38, hover: 34, active: 31}
            },
            selected: %{ink: %{color: "brand", ratio: 7}}
          }
        },
        dark: %{
          surface: %{
            layer: %{lightness: 16},
            root: %{lightness: 10},
            ui: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          utility: %{
            border: %{ratio: 1.2},
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
        radius: duo_radius_curve()
      }
    }
  end

  defp leo_overrides do
    %{
      seeds: leo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{lightness: 96},
            root: %{lightness: 98},
            ui: %{
              lightness: 92,
              states: %{muted: 95, default: 92, hover: 88, active: 85}
            }
          },
          utility: %{
            border: %{ratio: 1.14},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{
              lightness: 36,
              states: %{muted: 39, default: 36, hover: 32, active: 29}
            },
            brand: %{
              lightness: 42,
              states: %{muted: 45, default: 42, hover: 38, active: 35}
            },
            success: %{
              lightness: 38,
              states: %{muted: 41, default: 38, hover: 34, active: 31}
            }
          }
        },
        dark: %{
          surface: %{
            layer: %{lightness: 16},
            root: %{lightness: 9},
            ui: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          utility: %{
            border: %{ratio: 1.2},
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
        radius: leo_radius_curve()
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
      radius: neo_radius_curve()
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
        border: %{color: "base", ratio: 1.12},
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
        border: %{color: "base", ratio: 1.18},
        outline: %{color: "base", ratio: 2.4},
        shadow: %{color: "base", ratio: 1.2}
      }
    }
  end

  defp neo_light_surface do
    %{
      layer: %{color: "base", lightness: 97},
      root: %{color: "base", lightness: 98},
      ui: %{
        color: "base",
        lightness: 94,
        states: %{muted: 97, default: 94, hover: 90, active: 87}
      }
    }
  end

  defp neo_dark_surface do
    %{
      layer: %{color: "base", lightness: 15},
      root: %{color: "base", lightness: 8},
      ui: %{
        color: "base",
        lightness: 24,
        states: %{muted: 27, default: 24, hover: 20, active: 17}
      }
    }
  end

  defp neo_light_semantic do
    fill = %{
      lightness: 40,
      states: %{muted: 43, default: 40, hover: 36, active: 33}
    }

    ink = %{color: "base", ratio: 7}

    %{
      accent: Map.merge(fill, %{bg: "accent", ink: ink}),
      alert: Map.merge(fill, %{bg: "alert", ink: ink}),
      brand: Map.merge(fill, %{bg: "brand", ink: ink}),
      info: Map.merge(fill, %{bg: "info", ink: ink}),
      selected: %{
        bg: "base",
        lightness: 85,
        states: %{muted: 88, default: 85, hover: 81, active: 78},
        ink: ink
      },
      success: Map.merge(fill, %{bg: "success", ink: ink})
    }
  end

  defp neo_dark_semantic do
    ink = %{color: "base", ratio: 7}

    %{
      accent: %{
        bg: "accent",
        lightness: 52,
        states: %{muted: 55, default: 52, hover: 48, active: 45},
        ink: ink
      },
      alert: %{
        bg: "alert",
        lightness: 48,
        states: %{muted: 51, default: 48, hover: 44, active: 41},
        ink: ink
      },
      brand: %{
        bg: "brand",
        lightness: 48,
        states: %{muted: 51, default: 48, hover: 44, active: 41},
        ink: ink
      },
      info: %{
        bg: "info",
        lightness: 48,
        states: %{muted: 51, default: 48, hover: 44, active: 41},
        ink: ink
      },
      selected: %{
        bg: "base",
        lightness: 34,
        states: %{muted: 37, default: 34, hover: 30, active: 27},
        ink: ink
      },
      success: %{
        bg: "success",
        lightness: 48,
        states: %{muted: 51, default: 48, hover: 44, active: 41},
        ink: ink
      }
    }
  end
end
