defmodule CorexAdmin.Live.Home.Controller do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]

  alias CorexAdmin.Live.Helpers

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, Helpers.hub_title(socket))}
  end
end
