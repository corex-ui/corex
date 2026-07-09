defmodule Corex.Design.Theme.Presets.Neo do
  @moduledoc false

  def spec do
    %{
      palette: palette(),
      colors: %{
        light: light_colors(),
        dark: dark_colors()
      },
      dimensions: dimensions()
    }
  end

  defp palette do
    %{
      base: "#F0F0F0",
      accent: "#4B4B4B",
      alert: "#A43C3C",
      brand: "#32479C",
      info: "#1F77D4",
      success: "#059669"
    }
  end

  defp light_colors do
    %{
      surface: %{
        page: %{palette: :base, lightness: 98},
        raised: %{palette: :base, lightness: 97},
        control: %{
          palette: :base,
          lightness: 94,
          states: %{muted: 97, default: 95, hover: 95, active: 93}
        }
      },
      roles: light_roles(),
      on: %{
        page: %{palette: :base, against: :page, ratio: 8},
        muted: %{palette: :base, against: :page, ratio: 5.15},
        link: %{palette: :info, against: :page, ratio: 6},
        control: %{palette: :base, against: :control, ratio: 8}
      },
      border: %{palette: :base, against: :control, ratio: 1.16},
      focus: %{palette: :base, against: :control, ratio: 2.2},
      shadow: %{palette: :base, against: :page, ratio: 1.05}
    }
  end

  defp dark_colors do
    %{
      surface: %{
        page: %{palette: :base, lightness: 8},
        raised: %{palette: :base, lightness: 15},
        control: %{
          palette: :base,
          lightness: 24,
          states: %{muted: 27, default: 25, hover: 20, active: 18}
        }
      },
      roles: dark_roles(),
      on: %{
        page: %{palette: :base, against: :page, ratio: 12},
        muted: %{palette: :base, against: :page, ratio: 6},
        link: %{palette: :info, against: :page, ratio: 7.5},
        control: %{palette: :base, against: :control, ratio: 12}
      },
      border: %{palette: :base, against: :control, ratio: 1.22},
      focus: %{palette: :base, against: :control, ratio: 2.4},
      shadow: %{palette: :base, against: :page, ratio: 1.2}
    }
  end

  defp light_roles do
    fill = %{
      lightness: 40,
      states: %{muted: 43, default: 40, hover: 36, active: 33},
      component: true
    }

    %{
      base: %{
        palette: :base,
        lightness: 94,
        states: %{muted: 97, default: 94, hover: 90, active: 87},
        component: true
      },
      accent: Map.merge(fill, %{palette: :accent}),
      alert: Map.merge(fill, %{palette: :alert}),
      brand: Map.merge(fill, %{palette: :brand}),
      info: Map.merge(fill, %{palette: :info}),
      success: Map.merge(fill, %{palette: :success})
    }
  end

  defp dark_roles do
    fill = %{
      lightness: 48,
      states: %{muted: 51, default: 48, hover: 44, active: 41},
      component: true
    }

    %{
      base: %{
        palette: :base,
        lightness: 24,
        states: %{muted: 27, default: 25, hover: 20, active: 18},
        component: true
      },
      accent: Map.merge(fill, %{palette: :accent}),
      alert: Map.merge(fill, %{palette: :alert}),
      brand: Map.merge(fill, %{palette: :brand}),
      info: Map.merge(fill, %{palette: :info}),
      success: Map.merge(fill, %{palette: :success})
    }
  end

  defp dimensions do
    %{
      space_scale: 1.0,
      size_scale: 1.0,
      text_scale: 1.0,
      radius_scale: 1.0,
      container_scale: 1.0,
      shadow_scale: 1.0,
      radius: %{
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
    }
  end
end
