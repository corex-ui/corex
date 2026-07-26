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

  def surface_light(page, raised, control_lightness, control_states) do
    surface(:base, page, raised, control_lightness, control_states)
  end

  def surface_dark(page, raised, control_lightness, control_states, palette \\ :base) do
    surface(palette, page, raised, control_lightness, control_states)
  end

  def surface(palette, page, raised, control_lightness, control_states)
      when palette in [:base, :accent] do
    %{
      page: %{palette: palette, lightness: page},
      raised: %{palette: palette, lightness: raised},
      control: %{
        palette: palette,
        lightness: control_lightness,
        states: control_states
      }
    }
  end
end
