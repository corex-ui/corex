defmodule Corex.Design.Theme.Presets.Neo do
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
      neutral: "#E5E5E5",
      accent: "#171717",
      brand: "#32479C",
      alert: "#B42318",
      info: "#0F766E",
      success: "#166534"
    }
  end

  defp light_colors do
    Shared.mode(%{
      root: Shared.l(0.99),
      surface: Shared.l(0.97),
      ui: Shared.fill(0.94),
      accent: Shared.fill(0.26, seed: :accent),
      brand: Shared.fill(0.42, seed: :brand),
      alert: Shared.fill(0.44, seed: :alert),
      info: Shared.fill(0.40, seed: :info),
      success: Shared.fill(0.38, seed: :success),
      ink: Shared.contrast(seed: :accent, against: :root, target: 12),
      "ink-muted": Shared.contrast(seed: :accent, against: :root, target: 5.8),
      link: Shared.contrast(seed: :brand, against: :root, target: 5.5),
      "accent-contrast": Shared.contrast(seed: :neutral, against: :accent, target: 9.5),
      "brand-contrast": Shared.contrast(seed: :neutral, against: :brand, target: 9.5),
      "alert-contrast": Shared.contrast(seed: :neutral, against: :alert, target: 9.5),
      "info-contrast": Shared.contrast(seed: :neutral, against: :info, target: 9.5),
      "success-contrast": Shared.contrast(seed: :neutral, against: :success, target: 9.5),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.22),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.2),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.08)
    })
  end

  defp dark_colors do
    Shared.mode(%{
      root: Shared.l(0.06, seed: :accent),
      surface: Shared.l(0.10, seed: :accent),
      ui: Shared.fill(0.16, seed: :accent, delta: 0.04),
      accent: Shared.fill(0.48, seed: :accent),
      brand: Shared.fill(0.52, seed: :brand),
      alert: Shared.fill(0.50, seed: :alert),
      info: Shared.fill(0.50, seed: :info),
      success: Shared.fill(0.48, seed: :success),
      ink: Shared.contrast(seed: :neutral, against: :root, target: 13),
      "ink-muted": Shared.contrast(seed: :neutral, against: :root, target: 6.5),
      link: Shared.contrast(seed: :brand, against: :root, target: 6.2),
      "accent-contrast": Shared.contrast(seed: :neutral, against: :accent, target: 9.5),
      "brand-contrast": Shared.contrast(seed: :neutral, against: :brand, target: 9.5),
      "alert-contrast": Shared.contrast(seed: :neutral, against: :alert, target: 9.5),
      "info-contrast": Shared.contrast(seed: :neutral, against: :info, target: 9.5),
      "success-contrast": Shared.contrast(seed: :neutral, against: :success, target: 9.5),
      border: Shared.contrast(seed: :neutral, against: :ui, target: 1.3),
      focus: Shared.contrast(seed: :brand, against: :ui, target: 2.35),
      shadow: Shared.contrast(seed: :accent, against: :root, target: 1.2)
    })
  end

  defp dimensions do
    Shared.dimensions(
      %{
        space_scale: 1.0,
        size_scale: 1.0,
        text_scale: 1.02,
        radius_scale: 1.2,
        container_scale: 1.0,
        shadow_scale: 0.85,
        blur_scale: 1.1,
        ring_width: 2,
        ring_offset: 0,
        border_width: 1,
        duration_fast: 80,
        duration_normal: 120,
        duration_slow: 200,
        opacity_disabled: 0.7,
        opacity_backdrop: 0.4
      },
      %{
        xs: 0.3,
        sm: 0.45,
        md: 0.7,
        lg: 0.95,
        xl: 1.2,
        "2xl": 1.55,
        "3xl": 2.0,
        "4xl": 2.6,
        full: 9999
      },
      Shared.font_stack(%{
        sans: ["Manrope", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Outfit", "ui-sans-serif", "system-ui", "sans-serif"],
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
    }
  end
end
