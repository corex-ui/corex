defmodule Corex.Design.Theme.Presets.Duo do
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
      typography: typography()
    }
  end

  defp seeds do
    %{
      neutral: "#E9E7E4",
      accent: "#2C2925",
      brand: "#1D4E89",
      alert: "#9B3A3A",
      info: "#3D5278",
      success: "#3F6B4E"
    }
  end

  defp light_colors do
    Shared.mode(%{
      root: Shared.l(0.99),
      surface: Shared.l(0.97),
      ui: Shared.fill(0.94),
      accent: Shared.fill(0.34, seed: :accent),
      brand: Shared.fill(0.40, seed: :brand),
      alert: Shared.fill(0.44, seed: :alert),
      info: Shared.fill(0.40, seed: :info),
      success: Shared.fill(0.38, seed: :success),
      ink: Shared.contrast(seed: :accent, against: :root, target: 9),
      "ink-muted": Shared.contrast(seed: :accent, against: :root, target: 5.0),
      link: Shared.contrast(seed: :brand, against: :root, target: 5.6),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.1),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.1),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.25)
    })
  end

  defp dark_colors do
    Shared.mode(%{
      root: Shared.l(0.08, seed: :accent),
      surface: Shared.l(0.13, seed: :accent),
      ui: Shared.fill(0.20, seed: :accent, delta: 0.04),
      accent: Shared.fill(0.50, seed: :accent),
      brand: Shared.fill(0.54, seed: :brand),
      alert: Shared.fill(0.48, seed: :alert),
      info: Shared.fill(0.50, seed: :info),
      success: Shared.fill(0.48, seed: :success),
      ink: Shared.contrast(seed: :neutral, against: :root, target: 12),
      "ink-muted": Shared.contrast(seed: :neutral, against: :root, target: 6),
      link: Shared.contrast(seed: :brand, against: :root, target: 7.0),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.16),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.25),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.3)
    })
  end

  defp dimensions do
    Shared.dimensions(
      %{
        space_scale: 1.35,
        size_scale: 1.2,
        text_scale: 1.18,
        radius_scale: 1.9,
        container_scale: 1.22,
        shadow_scale: 2.2,
        blur_scale: 1.85,
        ring_width: 2.5,
        ring_offset: 1,
        border_width: 1.5,
        duration_fast: 110,
        duration_normal: 180,
        duration_slow: 280,
        opacity_disabled: 0.72,
        opacity_backdrop: 0.48
      },
      %{
        xs: 0.28,
        sm: 0.48,
        md: 0.72,
        lg: 1.0,
        xl: 1.35,
        "2xl": 1.85,
        "3xl": 2.5,
        "4xl": 3.3,
        full: 9999
      },
      Shared.font_stack(%{
        sans: ["Work Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Playfair Display", "Georgia", "serif"],
        mono: ["ui-monospace", "SFMono-Regular", "Menlo", "monospace"],
        code: ["ui-monospace", "SFMono-Regular", "Menlo", "monospace"],
        serif: ["Playfair Display", "Georgia", "serif"]
      })
    )
  end

  defp typography do
    %{
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
    }
  end
end
