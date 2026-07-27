defmodule Corex.Accordion.Api do
  @moduledoc false
  use Corex.Component, :api

  alias Corex.Api.RespondTo
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  def set_value(accordion_id, value) when is_binary(accordion_id) do
    JS.dispatch("corex:accordion:set-value",
      to: Selectors.css_id(accordion_id),
      detail: %{value: parse_string_list(value, "Corex.Accordion.set_value/2")},
      bubbles: false
    )
  end

  def set_value(socket, accordion_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) do
    RespondTo.push_set_value(
      socket,
      "accordion_set_value",
      accordion_id,
      parse_string_list(value, "Corex.Accordion.set_value/2")
    )
  end

  def value(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:value",
      to: Selectors.css_id(accordion_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def value(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: value(socket, accordion_id, [])

  def value(accordion_id) when is_binary(accordion_id), do: value(accordion_id, [])

  def value(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_value",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  def focused(accordion_id, opts) when is_binary(accordion_id) and is_list(opts) do
    JS.dispatch("corex:accordion:focused",
      to: Selectors.css_id(accordion_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def focused(socket, accordion_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id),
      do: focused(socket, accordion_id, [])

  def focused(accordion_id) when is_binary(accordion_id), do: focused(accordion_id, [])

  def focused(socket, accordion_id, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "accordion_focused",
      Map.merge(%{id: accordion_id}, respond_to_fields(opts))
    )
  end

  def item_state(accordion_id, item_value, opts)
      when is_binary(accordion_id) and is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    JS.dispatch("corex:accordion:item-state",
      to: Selectors.css_id(accordion_id),
      detail:
        Map.merge(
          %{value: validate_item_value!(item_value), disabled: disabled},
          respond_to_fields(opts)
        ),
      bubbles: false
    )
  end

  def item_state(socket, accordion_id, item_value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) do
    item_state(socket, accordion_id, item_value, [])
  end

  def item_state(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    item_state(accordion_id, item_value, [])
  end

  def item_state(socket, accordion_id, item_value, opts)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(accordion_id) and
             is_binary(item_value) and is_list(opts) do
    disabled = Keyword.get(opts, :disabled, false)

    LiveView.push_event(
      socket,
      "accordion_item_state",
      Map.merge(
        %{
          id: accordion_id,
          value: validate_item_value!(item_value),
          disabled: disabled
        },
        respond_to_fields(opts)
      )
    )
  end

  defp validate_item_value!(v) when is_binary(v) and byte_size(v) > 0, do: v

  defp validate_item_value!(_),
    do: raise(ArgumentError, "accordion item value must be a non-empty string")
end
