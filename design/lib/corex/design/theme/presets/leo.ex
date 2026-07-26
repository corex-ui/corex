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
      base: "#F3F3F0",
      accent: "#0C0A09",
      alert: "#C41E1E",
      brand: "#059669",
      info: "#0369A1",
      success: "#166534"
    }
  end

  defp light_colors do
    %{
      surface:
        Shared.surface_light(97, 95, 91, %{muted: 94, default: 92, hover: 88, active: 85}),
      roles:
        Shared.light_roles(90, %{
          accent: 24,
          alert: 40,
          brand: 34,
          info: 36,
          success: 34
        }),
      on: %{
        page: %{palette: :accent, against: :page, ratio: 10},
        muted: %{palette: :accent, against: :page, ratio: 5.8},
        link: %{palette: :brand, against: :page, ratio: 6.8}
      },
      border: %{palette: :accent, against: :control, ratio: 1.35},
      focus: %{palette: :brand, against: :control, ratio: 2.5},
      shadow: %{palette: :accent, against: :page, ratio: 1.03}
    }
  end

  defp dark_colors do
    %{
      surface:
        Shared.surface_dark(
          6,
          11,
          18,
          %{muted: 21, default: 19, hover: 15, active: 13},
          :accent
        ),
      roles:
        Shared.dark_roles(18, %{
          accent: 54,
          alert: 50,
          brand: 50,
          info: 50,
          success: 48
        }),
      on: %{
        page: %{palette: :base, against: :page, ratio: 13},
        muted: %{palette: :base, against: :page, ratio: 6.8},
        link: %{palette: :brand, against: :page, ratio: 8.2}
      },
      border: %{palette: :brand, against: :control, ratio: 1.4},
      focus: %{palette: :brand, against: :control, ratio: 2.7},
      shadow: %{palette: :accent, against: :page, ratio: 1.06}
    }
  end

  defp dimensions do
    %{
      space_scale: 0.84,
      size_scale: 0.8,
      text_scale: 0.9,
      radius_scale: 0.62,
      container_scale: 0.88,
      shadow_scale: 0.42,
      radius: %{
        xs: 0.04,
        sm: 0.08,
        md: 0.14,
        lg: 0.2,
        xl: 0.28,
        "2xl": 0.38,
        "3xl": 0.5,
        "4xl": 0.65,
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
      "kbd" => %{font_family: {:font, :mono}},
      "code" => %{font_family: {:font, :mono}}
    })
  end
end
