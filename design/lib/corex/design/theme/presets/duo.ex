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
      base: "#F2F1EF",
      accent: "#57534E",
      alert: "#8F4040",
      brand: "#524D6E",
      info: "#3E5080",
      success: "#3D6B52"
    }
  end

  defp light_colors do
    %{
      surface:
        Shared.surface_light(99, 96, 93, %{
          muted: 96,
          default: 94,
          hover: 91,
          active: 89
        }),
      roles:
        Shared.light_roles(94, %{
          accent: 40,
          alert: 40,
          brand: 40,
          info: 40,
          success: 40
        }),
      on: Shared.light_on(),
      border: %{palette: :base, against: :control, ratio: 1.08},
      focus: %{palette: :base, against: :control, ratio: 2.5},
      shadow: %{palette: :base, against: :page, ratio: 1.16}
    }
  end

  defp dark_colors do
    %{
      surface:
        Shared.surface_dark(8, 15, 24, %{
          muted: 27,
          default: 25,
          hover: 20,
          active: 18
        }),
      roles:
        Shared.dark_roles(24, %{
          accent: 48,
          alert: 48,
          brand: 48,
          info: 48,
          success: 48
        }),
      on: Shared.dark_on(),
      border: %{palette: :base, against: :control, ratio: 1.20},
      focus: %{palette: :base, against: :control, ratio: 2.6},
      shadow: %{palette: :base, against: :page, ratio: 1.22}
    }
  end

  defp dimensions do
    %{
      space_scale: 1.12,
      size_scale: 1.14,
      text_scale: 1.08,
      radius_scale: 1.24,
      container_scale: 1.10,
      shadow_scale: 1.35,
      radius: %{
        xs: 0.20,
        sm: 0.36,
        md: 0.50,
        lg: 0.76,
        xl: 1.05,
        "2xl": 1.45,
        "3xl": 2.05,
        "4xl": 2.70,
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
