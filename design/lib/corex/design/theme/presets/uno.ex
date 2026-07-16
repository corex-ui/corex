defmodule Corex.Design.Theme.Presets.Uno do
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
      base: "#F0F2F4",
      accent: "#4B5563",
      alert: "#9A4040",
      brand: "#3A5F6F",
      info: "#3A6580",
      success: "#3A6656"
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
      roles:
        Shared.light_roles(94, %{
          accent: 40,
          alert: 40,
          brand: 36,
          info: 40,
          success: 40
        }),
      on: Shared.light_on(),
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
      roles:
        Shared.dark_roles(24, %{
          accent: 48,
          alert: 48,
          brand: 48,
          info: 48,
          success: 48
        }),
      on: Shared.dark_on(),
      border: %{palette: :base, against: :control, ratio: 1.22},
      focus: %{palette: :base, against: :control, ratio: 2.4},
      shadow: %{palette: :base, against: :page, ratio: 1.2}
    }
  end

  defp dimensions do
    %{
      space_scale: 0.82,
      size_scale: 0.88,
      text_scale: 0.94,
      radius_scale: 0.86,
      container_scale: 0.88,
      shadow_scale: 0.65,
      radius: %{
        xs: 0.10,
        sm: 0.18,
        md: 0.32,
        lg: 0.42,
        xl: 0.55,
        "2xl": 0.72,
        "3xl": 0.95,
        "4xl": 1.2,
        full: 9999
      },
      font: %{
        sans: ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "ui-monospace", "monospace"],
        code: ["JetBrains Mono", "ui-monospace", "monospace"],
        serif: ["ui-serif", "Georgia", "serif"]
      }
    }
  end

  defp typography do
    Shared.typography(%{
      "h1" => %{font_weight: {:weight, :semibold}},
      "h2" => %{letter_spacing: {:tracking, :tight}},
      "h3" => %{font_weight: {:weight, :medium}},
      "p" => %{line_height: {:leading, :snug}}
    })
  end
end
