defmodule E2eWeb.DataListModel do
  use E2eWeb.Model, component: "data-list"

  def see_content(session, content_text) do
    see(session, content_text)
  end
end
