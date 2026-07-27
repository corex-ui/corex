defmodule Corex.Menu.Api do
  @moduledoc false

  alias Corex.Api.RespondTo
  alias Phoenix.LiveView.JS

  def set_open(menu_id, open) when is_binary(menu_id) do
    JS.dispatch("corex:menu:set-open",
      to: "[id=\"menu:#{menu_id}\"]",
      detail: %{open: open},
      bubbles: false
    )
  end

  def set_open(socket, menu_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(menu_id) do
    RespondTo.push_set_open(socket, "menu_set_open", menu_id, open)
  end
end
