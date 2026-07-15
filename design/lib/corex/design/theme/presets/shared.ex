defmodule Corex.Design.Theme.Presets.Shared do
  @moduledoc false

  def typography(overrides) when is_map(overrides), do: overrides

  def role_fill(palette, lightness) do
    %{
      palette: palette,
      lightness: lightness,
      states: %{
        muted: lightness + 3,
        default: lightness,
        hover: lightness - 4,
        active: lightness - 7
      },
      component: true
    }
  end

  def base_role(lightness) do
    %{
      palette: :base,
      lightness: lightness,
      states: %{
        muted: lightness + 3,
        default: lightness,
        hover: lightness - 4,
        active: lightness - 7
      },
      component: true
    }
  end

  def light_roles(base_lightness, fills) when is_map(fills) do
    Map.merge(
      %{base: base_role(base_lightness)},
      Map.new(fills, fn {role, lightness} -> {role, role_fill(role, lightness)} end)
    )
  end

  def dark_roles(base_lightness, fills) when is_map(fills) do
    dark_fills =
      Map.new(fills, fn {role, lightness} ->
        {role, role_fill(role, lightness)}
      end)

    Map.put(dark_fills, :base, base_role(base_lightness))
  end

  def light_on do
    %{
      page: %{palette: :base, against: :page, ratio: 8},
      muted: %{palette: :base, against: :page, ratio: 5.15},
      link: %{palette: :info, against: :page, ratio: 6},
      control: %{palette: :base, against: :control, ratio: 8}
    }
  end

  def dark_on do
    %{
      page: %{palette: :base, against: :page, ratio: 12},
      muted: %{palette: :base, against: :page, ratio: 6},
      link: %{palette: :info, against: :page, ratio: 7.5},
      control: %{palette: :base, against: :control, ratio: 12}
    }
  end

  def light_tokens(border_ratio, focus_ratio, shadow_ratio) do
    %{
      border: %{palette: :base, against: :control, ratio: border_ratio},
      focus: %{palette: :base, against: :control, ratio: focus_ratio},
      shadow: %{palette: :base, against: :page, ratio: shadow_ratio}
    }
  end

  def dark_tokens(border_ratio, focus_ratio, shadow_ratio) do
    %{
      border: %{palette: :base, against: :control, ratio: border_ratio},
      focus: %{palette: :base, against: :control, ratio: focus_ratio},
      shadow: %{palette: :base, against: :page, ratio: shadow_ratio}
    }
  end

  def surface_light(page, raised, control_lightness, control_states) do
    %{
      page: %{palette: :base, lightness: page},
      raised: %{palette: :base, lightness: raised},
      control: %{
        palette: :base,
        lightness: control_lightness,
        states: control_states
      }
    }
  end

  def surface_dark(page, raised, control_lightness, control_states) do
    %{
      page: %{palette: :base, lightness: page},
      raised: %{palette: :base, lightness: raised},
      control: %{
        palette: :base,
        lightness: control_lightness,
        states: control_states
      }
    }
  end
end
