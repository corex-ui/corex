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
      base: "#E8F1F2",
      accent: "#1E293B",
      alert: "#A63A3A",
      brand: "#0D9488",
      info: "#0284C7",
      success: "#15803D"
    }
  end

  defp light_colors do
    %{
      surface:
        Shared.surface_light(99, 97, 94, %{muted: 97, default: 95, hover: 92, active: 90}),
      roles:
        Shared.light_roles(94, %{
          accent: 36,
          alert: 42,
          brand: 38,
          info: 40,
          success: 38
        }),
      on: %{
        page: %{palette: :accent, against: :page, ratio: 9},
        muted: %{palette: :accent, against: :page, ratio: 5.3},
        link: %{palette: :brand, against: :page, ratio: 6.2}
      },
      border: %{palette: :base, against: :control, ratio: 1.2},
      focus: %{palette: :brand, against: :control, ratio: 2.4},
      shadow: %{palette: :accent, against: :page, ratio: 1.06}
    }
  end

  defp dark_colors do
    %{
      surface:
        Shared.surface_dark(
          8,
          13,
          20,
          %{muted: 23, default: 21, hover: 17, active: 15},
          :accent
        ),
      roles:
        Shared.dark_roles(20, %{
          accent: 52,
          alert: 50,
          brand: 50,
          info: 50,
          success: 48
        }),
      on: %{
        page: %{palette: :base, against: :page, ratio: 12.5},
        muted: %{palette: :base, against: :page, ratio: 6.2},
        link: %{palette: :brand, against: :page, ratio: 7.8}
      },
      border: %{palette: :brand, against: :control, ratio: 1.28},
      focus: %{palette: :brand, against: :control, ratio: 2.5},
      shadow: %{palette: :accent, against: :page, ratio: 1.18}
    }
  end

  defp dimensions do
    %{
      space_scale: 0.78,
      size_scale: 0.84,
      text_scale: 0.92,
      radius_scale: 0.9,
      container_scale: 0.86,
      shadow_scale: 0.6,
      radius: %{
        xs: 0.1,
        sm: 0.18,
        md: 0.3,
        lg: 0.4,
        xl: 0.52,
        "2xl": 0.68,
        "3xl": 0.9,
        "4xl": 1.15,
        full: 9999
      },
      font: %{
        sans: ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Sora", "ui-sans-serif", "system-ui", "sans-serif"],
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
        font_weight: {:weight, :semibold},
        letter_spacing: {:tracking, :tight}
      },
      "h2" => %{
        font_family: {:font, :display},
        letter_spacing: {:tracking, :tight}
      },
      "h3" => %{font_family: {:font, :display}, font_weight: {:weight, :medium}},
      "p" => %{line_height: {:leading, :snug}},
      "kbd" => %{font_family: {:font, :mono}}
    })
  end
end
