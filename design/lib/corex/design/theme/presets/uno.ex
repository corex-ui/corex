defmodule Corex.Design.Theme.Presets.Uno do
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
      neutral: "#E6E8EB",
      accent: "#1A1F26",
      brand: "#0D9488",
      alert: "#A63A3A",
      info: "#0284C7",
      success: "#15803D"
    }
  end

  defp light_colors do
    Shared.mode(%{
      root: Shared.l(0.99),
      surface: Shared.l(0.97),
      ui: Shared.fill(0.94),
      accent: Shared.fill(0.32, seed: :accent),
      brand: Shared.fill(0.38, seed: :brand),
      alert: Shared.fill(0.44, seed: :alert),
      info: Shared.fill(0.40, seed: :info),
      success: Shared.fill(0.38, seed: :success),
      ink: Shared.contrast(seed: :accent, against: :root, target: 10),
      "ink-muted": Shared.contrast(seed: :accent, against: :root, target: 5.4),
      link: Shared.contrast(seed: :brand, against: :root, target: 5.8),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.2),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.15),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.04)
    })
  end

  defp dark_colors do
    Shared.mode(%{
      root: Shared.l(0.07, seed: :accent),
      surface: Shared.l(0.12, seed: :accent),
      ui: Shared.fill(0.18, seed: :accent, delta: 0.04),
      accent: Shared.fill(0.52, seed: :accent),
      brand: Shared.fill(0.52, seed: :brand),
      alert: Shared.fill(0.50, seed: :alert),
      info: Shared.fill(0.50, seed: :info),
      success: Shared.fill(0.48, seed: :success),
      ink: Shared.contrast(seed: :neutral, against: :root, target: 12.5),
      "ink-muted": Shared.contrast(seed: :neutral, against: :root, target: 6.2),
      link: Shared.contrast(seed: :brand, against: :root, target: 7.0),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.26),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.25),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.14)
    })
  end

  defp dimensions do
    Shared.dimensions(
      %{
        space_scale: 0.92,
        size_scale: 0.96,
        text_scale: 1.0,
        radius_scale: 0.55,
        container_scale: 0.8,
        shadow_scale: 0.28,
        blur_scale: 0.5,
        ring_width: 1.5,
        ring_offset: 0,
        border_width: 1,
        duration_fast: 55,
        duration_normal: 85,
        duration_slow: 140,
        opacity_disabled: 0.62,
        opacity_backdrop: 0.35,
      },
      %{
        xs: 0.08,
        sm: 0.14,
        md: 0.22,
        lg: 0.32,
        xl: 0.42,
        "2xl": 0.55,
        "3xl": 0.72,
        "4xl": 0.9,
        full: 9999
      },
      Shared.font_stack(%{
        sans: ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Sora", "ui-sans-serif", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "ui-monospace", "monospace"],
        code: ["JetBrains Mono", "ui-monospace", "monospace"],
        serif: ["ui-serif", "Georgia", "serif"]
      })
    )
  end

  defp typography do
    %{
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
    }
  end
end
