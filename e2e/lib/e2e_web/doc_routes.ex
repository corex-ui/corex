defmodule E2eWeb.DocRoutes do
  @moduledoc false

  defdelegate locale(), to: E2eWeb.DocA11yRoutes
  defdelegate all(), to: E2eWeb.DocA11yRoutes
  defdelegate for_slug(slug), to: E2eWeb.DocA11yRoutes
end
