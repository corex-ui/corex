defmodule E2eWeb.LiveCapture do
  use LiveCapture.Component

  breakpoints s: "320px", m: "480px", l: "768px", xl: "1024px"

  root_layout {E2eWeb.Layouts, :captures}
end
