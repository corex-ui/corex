defmodule E2eWeb.ZagScope do
  @moduledoc false

  def for_component(component) when is_atom(component) do
    component |> Atom.to_string() |> String.replace("_", "-")
  end
end
