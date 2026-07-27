defmodule Corex.Combobox.Api do
  @moduledoc false

  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  def set_value(combobox_id, value) when is_binary(combobox_id) do
    JS.dispatch("corex:combobox:set-value",
      to: Selectors.css_id(combobox_id),
      detail: %{value: Corex.Value.parse_string_list(value, "Corex.Combobox.set_value/2")},
      bubbles: false
    )
  end

  def set_value(socket, combobox_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(combobox_id) do
    LiveView.push_event(socket, "combobox_set_value", %{
      id: combobox_id,
      value: Corex.Value.parse_string_list(value, "Corex.Combobox.set_value/2")
    })
  end

  def set_open(combobox_id, open) when is_binary(combobox_id) and is_boolean(open) do
    JS.dispatch("corex:combobox:set-open",
      to: Selectors.css_id(combobox_id),
      detail: %{open: open},
      bubbles: false
    )
  end

  def set_open(socket, combobox_id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(combobox_id) and
             is_boolean(open) do
    LiveView.push_event(socket, "combobox_set_open", %{id: combobox_id, open: open})
  end
end
