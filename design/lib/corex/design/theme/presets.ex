defmodule Corex.Design.Theme.Presets do
  @moduledoc """
  Built-in theme presets (neo, uno, duo, leo). Copy into host config or reference
  directly:

      config :corex_design,
        output: "assets/css/corex.tailwind.css"
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
      palette: neo_palette(),
      colors: %{light: neo_light_colors(), dark: neo_dark_colors()},
      dimensions: neo_dimensions()
    }
  end

  defp uno_overrides do
    %{
      palette: uno_palette(),
      colors: %{
        light: %{
          surface: %{
            raised: %{lightness: 97},
            page: %{lightness: 100},
            control: %{
              lightness: 94,
              states: %{muted: 97, default: 94, hover: 90, active: 87}
            }
          },
          border: %{ratio: 1.12},
          focus: %{ratio: 2.2},
          shadow: %{ratio: 1.1},
          on: %{page: %{ratio: 8.5}}
        },
        dark: %{
          surface: %{
            raised: %{lightness: 14},
            page: %{lightness: 7},
            control: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          border: %{ratio: 1.18},
          focus: %{ratio: 2.4},
          shadow: %{ratio: 1.22},
          on: %{page: %{ratio: 12.25}}
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
      palette: duo_palette(),
      colors: %{
        light: %{
          surface: %{
            raised: %{lightness: 97},
            page: %{lightness: 99},
            control: %{
              lightness: 92,
              states: %{muted: 95, default: 92, hover: 88, active: 85}
            }
          },
          border: %{ratio: 1.14},
          focus: %{ratio: 2.2},
          shadow: %{ratio: 1.07},
          on: %{page: %{ratio: 8.25}},
          roles: %{
            accent: %{
              lightness: 42,
              states: %{muted: 45, default: 42, hover: 38, active: 35}
            },
            brand: %{
              lightness: 38,
              states: %{muted: 41, default: 38, hover: 34, active: 31}
            }
          }
        },
        dark: %{
          surface: %{
            raised: %{lightness: 16},
            page: %{lightness: 10},
            control: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          border: %{ratio: 1.2},
          focus: %{ratio: 2.4},
          shadow: %{ratio: 1.23},
          on: %{page: %{ratio: 12.1}}
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
      palette: leo_palette(),
      colors: %{
        light: %{
          surface: %{
            raised: %{lightness: 96},
            page: %{lightness: 98},
            control: %{
              lightness: 92,
              states: %{muted: 95, default: 92, hover: 88, active: 85}
            }
          },
          border: %{ratio: 1.14},
          focus: %{ratio: 2.2},
          shadow: %{ratio: 1.07},
          on: %{page: %{ratio: 8.25}},
          roles: %{
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
            raised: %{lightness: 16},
            page: %{lightness: 9},
            control: %{
              lightness: 24,
              states: %{muted: 27, default: 24, hover: 20, active: 17}
            }
          },
          border: %{ratio: 1.2},
          focus: %{ratio: 2.4},
          shadow: %{ratio: 1.23},
          on: %{page: %{ratio: 12.1}}
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

  defp neo_palette do
    %{
      neutral: "#F0F0F0",
      accent: "#4B4B4B",
      alert: "#A43C3C",
      brand: "#32479C",
      info: "#1F77D4",
      success: "#059669"
    }
  end

  defp uno_palette do
    %{
      neutral: "#EEF2F7",
      accent: "#475569",
      alert: "#B91C1C",
      brand: "#0E7490",
      info: "#0369A1",
      success: "#047857"
    }
  end

  defp duo_palette do
    %{
      neutral: "#FAF7F2",
      accent: "#57534E",
      alert: "#9F1239",
      brand: "#5B21B6",
      info: "#1D4ED8",
      success: "#15803D"
    }
  end

  defp leo_palette do
    %{
      neutral: "#F4F4F5",
      accent: "#3F3F46",
      alert: "#991B1B",
      brand: "#B45309",
      info: "#1E40AF",
      success: "#166534"
    }
  end

  defp neo_light_colors do
    %{
      surface: neo_light_surface(),
      roles: neo_light_roles(),
      on: neo_light_on(),
      border: %{palette: :neutral, against: :control, ratio: 1.12},
      focus: %{palette: :neutral, against: :control, ratio: 2.2},
      shadow: %{palette: :neutral, against: :page, ratio: 1.05}
    }
  end

  defp neo_dark_colors do
    %{
      surface: neo_dark_surface(),
      roles: neo_dark_roles(),
      on: neo_dark_on(),
      border: %{palette: :neutral, against: :control, ratio: 1.18},
      focus: %{palette: :neutral, against: :control, ratio: 2.4},
      shadow: %{palette: :neutral, against: :page, ratio: 1.2}
    }
  end

  defp neo_light_surface do
    %{
      page: %{palette: :neutral, lightness: 98},
      raised: %{palette: :neutral, lightness: 97},
      control: %{
        palette: :neutral,
        lightness: 94,
        states: %{muted: 97, default: 94, hover: 90, active: 87}
      }
    }
  end

  defp neo_dark_surface do
    %{
      page: %{palette: :neutral, lightness: 8},
      raised: %{palette: :neutral, lightness: 15},
      control: %{
        palette: :neutral,
        lightness: 24,
        states: %{muted: 27, default: 24, hover: 20, active: 17}
      }
    }
  end

  defp neo_light_on do
    %{
      page: %{palette: :neutral, against: :page, ratio: 8},
      muted: %{palette: :neutral, against: :page, ratio: 5.15},
      link: %{palette: :info, against: :page, ratio: 6},
      control: %{palette: :neutral, against: :control, ratio: 8}
    }
  end

  defp neo_dark_on do
    %{
      page: %{palette: :neutral, against: :page, ratio: 12},
      muted: %{palette: :neutral, against: :page, ratio: 6},
      link: %{palette: :info, against: :page, ratio: 7.5},
      control: %{palette: :neutral, against: :control, ratio: 12}
    }
  end

  defp neo_light_roles do
    fill = %{
      lightness: 40,
      states: %{muted: 43, default: 40, hover: 36, active: 33},
      component: true
    }

    %{
      accent: Map.merge(fill, %{palette: :accent}),
      alert: Map.merge(fill, %{palette: :alert}),
      brand: Map.merge(fill, %{palette: :brand}),
      info: Map.merge(fill, %{palette: :info}),
      success: Map.merge(fill, %{palette: :success}),
      neutral: %{
        palette: :neutral,
        lightness: 94,
        states: %{muted: 97, default: 94, hover: 90, active: 87},
        component: true
      },
      selected: %{
        palette: :neutral,
        lightness: 85,
        states: %{muted: 88, default: 85, hover: 81, active: 78},
        component: true
      }
    }
  end

  defp neo_dark_roles do
    fill = %{
      lightness: 48,
      states: %{muted: 51, default: 48, hover: 44, active: 41},
      component: true
    }

    %{
      accent: Map.merge(fill, %{palette: :accent}),
      alert: Map.merge(fill, %{palette: :alert}),
      brand: Map.merge(fill, %{palette: :brand}),
      info: Map.merge(fill, %{palette: :info}),
      success: Map.merge(fill, %{palette: :success}),
      neutral: %{
        palette: :neutral,
        lightness: 24,
        states: %{muted: 27, default: 24, hover: 20, active: 17},
        component: true
      },
      selected: %{
        palette: :neutral,
        lightness: 34,
        states: %{muted: 37, default: 34, hover: 30, active: 27},
        component: true
      }
    }
  end
end
