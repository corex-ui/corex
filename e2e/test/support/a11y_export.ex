defmodule E2eWeb.A11yExport do
  @moduledoc false

  import Wallaby.Browser

  @exports ~w(tailwind)

  def exports, do: @exports

  def visit_with_export(session, path, _export) do
    session
    |> visit(path)
  end
end
