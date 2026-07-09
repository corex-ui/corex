defmodule Corex.Design.Theme.Presets.Leo do
  @moduledoc false

  alias Corex.Design.Theme.Presets.Shared

  def spec do
    %{
      palette: palette(),
      colors: %{
        light: light_colors(),
        dark: dark_colors()
      },
      dimensions: dimensions(),
      typography: typography()
    }
  end

  defp palette do
    %{
      base: "#F5F5F4",
      accent: "#1C1917",
      alert: "#B91C1C",
      brand: "#047857",
      info: "#0369A1",
      success: "#15803D"
    }
  end

  defp light_colors do
    %{
      surface: %{
        page: %{palette: :base, lightness: 97},
        raised: %{palette: :base, lightness: 96},
        control: %{
          palette: :base,
          lightness: 92,
          states: %{muted: 95, default: 93, hover: 90, active: 88}
        }
      },
      roles:
        Shared.light_roles(90, %{
          accent: 28,
          alert: 40,
          brand: 36,
          info: 38,
          success: 36
        }),
      on: %{
        page: %{palette: :accent, against: :page, ratio: 9.5},
        muted: %{palette: :accent, against: :page, ratio: 5.5},
        link: %{palette: :brand, against: :page, ratio: 6.5},
        control: %{palette: :accent, against: :control, ratio: 9.5}
      },
      border: %{palette: :accent, against: :control, ratio: 1.20},
      focus: %{palette: :brand, against: :control, ratio: 2.4},
      shadow: %{palette: :accent, against: :page, ratio: 1.04}
    }
  end

  defp dark_colors do
    %{
      surface: %{
        page: %{palette: :accent, lightness: 7},
        raised: %{palette: :accent, lightness: 13},
        control: %{
          palette: :accent,
          lightness: 20,
          states: %{muted: 23, default: 21, hover: 17, active: 15}
        }
      },
      roles:
        Shared.dark_roles(20, %{
          accent: 56,
          alert: 48,
          brand: 48,
          info: 48,
          success: 46
        }),
      on: %{
        page: %{palette: :base, against: :page, ratio: 12.5},
        muted: %{palette: :base, against: :page, ratio: 6.5},
        link: %{palette: :brand, against: :page, ratio: 8},
        control: %{palette: :base, against: :control, ratio: 12.5}
      },
      border: %{palette: :brand, against: :control, ratio: 1.24},
      focus: %{palette: :brand, against: :control, ratio: 2.6},
      shadow: %{palette: :accent, against: :page, ratio: 1.08}
    }
  end

  defp dimensions do
    %{
      space_scale: 0.86,
      size_scale: 0.82,
      text_scale: 0.92,
      radius_scale: 0.72,
      container_scale: 0.90,
      shadow_scale: 0.50,
      radius: %{
        xs: 0.05,
        sm: 0.10,
        md: 0.22,
        lg: 0.28,
        xl: 0.38,
        "2xl": 0.50,
        "3xl": 0.65,
        "4xl": 0.82,
        full: 9999
      },
      font: %{
        sans: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["IBM Plex Mono", "ui-monospace", "monospace"],
        code: ["IBM Plex Mono", "ui-monospace", "monospace"],
        serif: ["ui-serif", "Georgia", "serif"]
      }
    }
  end

  defp typography do
    Shared.typography(%{
      "h1" => %{
        font_weight: {:weight, :semibold},
        letter_spacing: {:tracking, :tight}
      },
      "h2" => %{font_weight: {:weight, :semibold}},
      "h4" => %{
        font_weight: {:weight, :medium},
        letter_spacing: {:tracking, :widest},
        font_size: {:text, :sm},
        md: %{
          font_size: {:text, :md},
          line_height: {:leading, :md}
        }
      },
      "kbd" => %{font_family: {:font, :mono}}
    })
  end
end
