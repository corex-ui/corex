defmodule Corex.Design.Theme.Presets.Leo do
  @moduledoc false

  alias Corex.Design.Theme.Presets.Shared

  def spec do
    %{
      seeds: seeds(),
      colors: %{
        light: light_colors(),
        dark: dark_colors()
      },
      dimensions: dimensions(),
      typography: typography(),
    }
  end

  defp seeds do
    %{
      neutral: "#E8E8E6",
      accent: "#0A0A0A",
      brand: "#059669",
      alert: "#C41E1E",
      info: "#0369A1",
      success: "#166534"
    }
  end

  defp light_colors do
    Shared.mode(%{
      root: Shared.l(0.98),
      surface: Shared.l(0.96),
      ui: Shared.fill(0.92),
      accent: Shared.fill(0.18, seed: :accent),
      brand: Shared.fill(0.24, seed: :brand),
      alert: Shared.fill(0.44, seed: :alert),
      info: Shared.fill(0.40, seed: :info),
      success: Shared.fill(0.38, seed: :success),
      ink: Shared.contrast(seed: :accent, against: :root, target: 12),
      "ink-muted": Shared.contrast(seed: :accent, against: :root, target: 5.8),
      link: Shared.contrast(seed: :accent, against: :root, target: 8.0),
      border: Shared.contrast(seed: :accent, against: :ui, target: 1.55),
      focus: Shared.contrast(seed: :accent, against: :ui, target: 2.5),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.02)
    })
  end

  defp dark_colors do
    Shared.mode(%{
      root: Shared.l(0.04, seed: :accent),
      surface: Shared.l(0.09, seed: :accent),
      ui: Shared.fill(0.15, seed: :accent, delta: 0.04),
      accent: Shared.fill(0.48, seed: :accent),
      brand: Shared.fill(0.48, seed: :brand),
      alert: Shared.fill(0.50, seed: :alert),
      info: Shared.fill(0.50, seed: :info),
      success: Shared.fill(0.48, seed: :success),
      ink: Shared.contrast(seed: :neutral, against: :root, target: 14),
      "ink-muted": Shared.contrast(seed: :neutral, against: :root, target: 6.8),
      link: Shared.contrast(seed: :neutral, against: :root, target: 9.0),
      "accent-contrast": Shared.contrast(seed: :neutral, against: :accent, target: 9.5),
      "brand-contrast": Shared.contrast(seed: :neutral, against: :brand, target: 9.5),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.4),
      focus: Shared.contrast(seed: :neutral, against: :ui, target: 2.6),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.04)
    })
  end

  defp dimensions do
    Shared.dimensions(
      %{
        space_scale: 0.95,
        size_scale: 0.96,
        text_scale: 1.0,
        radius_scale: 0.1,
        container_scale: 0.82,
        shadow_scale: 0.1,
        blur_scale: 0.8,
        ring_width: 1,
        ring_offset: 0,
        border_width: 1,
        duration_fast: 45,
        duration_normal: 70,
        duration_slow: 120,
        opacity_disabled: 0.55,
        opacity_backdrop: 0.55,
      },
      %{
        xs: 0,
        sm: 0.02,
        md: 0.04,
        lg: 0.06,
        xl: 0.08,
        "2xl": 0.1,
        "3xl": 0.12,
        "4xl": 0.16,
        full: 9999
      },
      Shared.font_stack(%{
        sans: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["IBM Plex Mono", "ui-monospace", "monospace"],
        code: ["IBM Plex Mono", "ui-monospace", "monospace"],
        serif: ["ui-serif", "Georgia", "serif"]
      })
    )
  end

  defp typography do
    %{
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
    }
  end
end
