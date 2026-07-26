defmodule Corex.Design.Theme.Presets.Neo do
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
      base: "#E8E0D6",
      accent: "#1C1917",
      alert: "#B42318",
      brand: "#32479C",
      info: "#0F766E",
      success: "#166534"
    }
  end

  defp light_colors do
    %{
      surface:
        Shared.surface_light(98, 95, 92, %{muted: 95, default: 93, hover: 90, active: 87}),
      roles:
        Shared.light_roles(92, %{
          accent: 28,
          alert: 42,
          brand: 42,
          info: 38,
          success: 36
        }),
      on: %{
        page: %{palette: :accent, against: :page, ratio: 11},
        muted: %{palette: :accent, against: :page, ratio: 5.8},
        link: %{palette: :brand, against: :page, ratio: 5.5},
        accent: %{palette: :base, against: :accent, ratio: 9.5},
        brand: %{palette: :base, against: :brand, ratio: 9.5},
        alert: %{palette: :base, against: :alert, ratio: 9.5},
        info: %{palette: :base, against: :info, ratio: 9.5},
        success: %{palette: :base, against: :success, ratio: 9.5}
      },
      border: %{palette: :base, against: :control, ratio: 1.3},
      focus: %{palette: :brand, against: :control, ratio: 2.4},
      shadow: %{palette: :accent, against: :page, ratio: 1.15}
    }
  end

  defp dark_colors do
    %{
      surface:
        Shared.surface_dark(
          7,
          12,
          18,
          %{muted: 22, default: 20, hover: 16, active: 14},
          :accent
        ),
      roles:
        Shared.dark_roles(18, %{
          accent: 54,
          alert: 52,
          brand: 48,
          info: 52,
          success: 48
        }),
      on: %{
        page: %{palette: :base, against: :page, ratio: 13},
        muted: %{palette: :base, against: :page, ratio: 6.5},
        link: %{palette: :brand, against: :page, ratio: 6},
        accent: %{palette: :base, against: :accent, ratio: 9.5},
        brand: %{palette: :base, against: :brand, ratio: 9.5},
        alert: %{palette: :base, against: :alert, ratio: 9.5},
        info: %{palette: :base, against: :info, ratio: 9.5},
        success: %{palette: :base, against: :success, ratio: 9.5}
      },
      border: %{palette: :base, against: :control, ratio: 1.35},
      focus: %{palette: :brand, against: :control, ratio: 2.5},
      shadow: %{palette: :accent, against: :page, ratio: 1.3}
    }
  end

  defp dimensions do
    %{
      space_scale: 1.0,
      size_scale: 1.0,
      text_scale: 1.05,
      radius_scale: 0.9,
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
      },
      font: %{
        sans: ["Manrope", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Outfit", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "ui-monospace", "monospace"],
        code: ["JetBrains Mono", "ui-monospace", "monospace"],
        serif: ["ui-serif", "Georgia", "serif"]
      }
    }
  end

  defp typography do
    Shared.typography(%{
      "h1" => %{
        font_family: {:font, :display},
        font_weight: {:weight, :bold},
        letter_spacing: {:tracking, :tighter}
      },
      "h2" => %{
        font_family: {:font, :display},
        font_weight: {:weight, :bold},
        letter_spacing: {:tracking, :tight}
      },
      "h3" => %{font_family: {:font, :display}, font_weight: {:weight, :semibold}},
      "p.display" => %{
        font_family: {:font, :display},
        font_weight: {:weight, :bold},
        letter_spacing: {:tracking, :tighter}
      },
      "kbd" => %{font_family: {:font, :mono}}
    })
  end
end
