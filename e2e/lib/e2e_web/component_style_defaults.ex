defmodule E2eWeb.ComponentStyleDefaults do
  @moduledoc false

  @action_controls %{
    as: "button",
    semantic: nil,
    variant: "solid",
    size: "md",
    radius: nil,
    shape: nil,
    disabled: false
  }

  @accordion_controls %{
    semantic: nil,
    variant: "subtle",
    size: "md",
    text: nil,
    radius: nil,
    width: "full",
    max_width: "md",
    height: "auto",
    max_height: "none"
  }

  @snippet_defaults %{
    action: %{as: "button", variant: "solid", size: "md"},
    accordion: %{
      variant: "subtle",
      size: "md",
      width: "full",
      max_width: "md",
      height: "auto",
      max_height: "none"
    }
  }

  def control_defaults(:action), do: @action_controls
  def control_defaults(:accordion), do: @accordion_controls

  def snippet_defaults(component), do: Map.get(@snippet_defaults, component, %{})

  def axis_default(component, axis) do
    component
    |> control_defaults()
    |> Map.get(axis)
  end
end
