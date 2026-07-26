defmodule Corex.Design.Theme.Presets.Duo do
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
      base: "#F2EFE8",
      accent: "#3F3A32",
      alert: "#9B3A3A",
      brand: "#1D4E89",
      info: "#3D5278",
      success: "#3F6B4E"
    }
  end

  defp light_colors do
    %{
      surface:
        Shared.surface_light(99, 97, 94, %{
          muted: 97,
          default: 95,
          hover: 92,
          active: 90
        }),
      roles:
        Shared.light_roles(94, %{
          accent: 38,
          alert: 42,
          brand: 42,
          info: 40,
          success: 40
        }),
      on: %{
        page: %{palette: :accent, against: :page, ratio: 8.5},
        muted: %{palette: :accent, against: :page, ratio: 5.0},
        link: %{palette: :brand, against: :page, ratio: 5.8}
      },
      border: %{palette: :base, against: :control, ratio: 1.06},
      focus: %{palette: :brand, against: :control, ratio: 2.3},
      shadow: %{palette: :accent, against: :page, ratio: 1.2}
    }
  end

  defp dark_colors do
    %{
      surface:
        Shared.surface_dark(9, 14, 22, %{
          muted: 25,
          default: 23,
          hover: 18,
          active: 16
        }),
      roles:
        Shared.dark_roles(22, %{
          accent: 50,
          alert: 48,
          brand: 52,
          info: 50,
          success: 48
        }),
      on: %{
        page: %{palette: :base, against: :page, ratio: 12},
        muted: %{palette: :base, against: :page, ratio: 6},
        link: %{palette: :brand, against: :page, ratio: 7.2}
      },
      border: %{palette: :base, against: :control, ratio: 1.14},
      focus: %{palette: :brand, against: :control, ratio: 2.5},
      shadow: %{palette: :accent, against: :page, ratio: 1.25}
    }
  end

  defp dimensions do
    %{
      space_scale: 1.16,
      size_scale: 1.16,
      text_scale: 1.1,
      radius_scale: 1.28,
      container_scale: 1.12,
      shadow_scale: 1.4,
      radius: %{
        xs: 0.22,
        sm: 0.4,
        md: 0.62,
        lg: 0.86,
        xl: 1.15,
        "2xl": 1.55,
        "3xl": 2.2,
        "4xl": 2.9,
        full: 9999
      },
      font: %{
        sans: ["Work Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Playfair Display", "Georgia", "serif"],
        mono: ["ui-monospace", "SFMono-Regular", "Menlo", "monospace"],
        code: ["ui-monospace", "SFMono-Regular", "Menlo", "monospace"],
        serif: ["Playfair Display", "Georgia", "serif"]
      }
    }
  end

  defp typography do
    Shared.typography(%{
      "h1" => %{
        font_family: {:font, :display},
        font_weight: {:weight, :bold},
        letter_spacing: {:tracking, :tight}
      },
      "h2" => %{
        font_family: {:font, :display},
        font_weight: {:weight, :semibold}
      },
      "h3" => %{font_family: {:font, :display}},
      "p" => %{line_height: {:leading, :relaxed}},
      "p.display" => %{
        line_height: {:leading, :relaxed},
        md: %{line_height: {:leading, :relaxed}},
        lg: %{line_height: {:leading, :relaxed}}
      },
      "blockquote" => %{
        font_family: {:font, :display},
        font_style: :italic
      }
    })
  end
end
