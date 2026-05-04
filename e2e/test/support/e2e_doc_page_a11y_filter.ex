defmodule E2eWeb.A11yDocPageFilter do
  @moduledoc false
  @behaviour A11yAudit.ViolationFilter

  @impl true
  def exclude_violation?(%A11yAudit.Results.Violation{id: "heading-order"}), do: true
  def exclude_violation?(_), do: false
end
