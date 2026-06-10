defmodule E2eWeb.StyleLives do
  @moduledoc false

  @components E2eWeb.ComponentStyleConfig.macro_components()

  for component <- @components do
    module = Module.concat([E2eWeb, "#{Macro.camelize(Atom.to_string(component))}StyleLive"])

    defmodule module do
      use E2eWeb.ComponentStylePage, component: component
    end
  end
end
