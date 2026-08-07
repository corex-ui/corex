defmodule Corex.Select.Api do
  @moduledoc false
  use Corex.Component, :api

  alias Corex.Api.RespondTo
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  def set_value(select_id, value) when is_binary(select_id) do
    JS.dispatch("corex:select:set-value",
      to: Selectors.css_id(select_id),
      detail: %{value: coerce_string_list(List.wrap(value), "Corex.Select.set_value/2")},
      bubbles: false
    )
  end

  def set_value(socket, select_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) do
    RespondTo.push_set_value(
      socket,
      "select_set_value",
      select_id,
      coerce_string_list(List.wrap(value), "Corex.Select.set_value/2")
    )
  end

  def set_open(select_id, open) when is_binary(select_id) and is_boolean(open) do
    JS.dispatch("corex:select:set-open",
      to: Selectors.css_id(select_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  def set_open(socket, select_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(select_id) and
             is_boolean(open) do
    RespondTo.push_set_open(socket, "select_set_open", select_id, open)
  end
end
