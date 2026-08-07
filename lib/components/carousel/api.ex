defmodule Corex.Carousel.Api do
  @moduledoc false

  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  def play(carousel_id) when is_binary(carousel_id) do
    JS.dispatch("corex:carousel:play",
      to: Selectors.css_id(carousel_id),
      detail: %{},
      bubbles: false
    )
  end

  def pause(carousel_id) when is_binary(carousel_id) do
    JS.dispatch("corex:carousel:pause",
      to: Selectors.css_id(carousel_id),
      detail: %{},
      bubbles: false
    )
  end

  def play(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    LiveView.push_event(socket, "carousel_play", %{"id" => carousel_id})
  end

  def pause(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    LiveView.push_event(socket, "carousel_pause", %{"id" => carousel_id})
  end

  def scroll_next(carousel_id) when is_binary(carousel_id), do: scroll_next(carousel_id, false)

  def scroll_next(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant) do
    JS.dispatch("corex:carousel:scroll-next",
      to: Selectors.css_id(carousel_id),
      detail: scroll_detail(instant),
      bubbles: false
    )
  end

  def scroll_next(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    scroll_next(socket, carousel_id, false)
  end

  def scroll_next(socket, carousel_id, instant)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) and
             is_boolean(instant) do
    LiveView.push_event(socket, "carousel_scroll_next", scroll_payload(carousel_id, instant))
  end

  def scroll_prev(carousel_id) when is_binary(carousel_id), do: scroll_prev(carousel_id, false)

  def scroll_prev(carousel_id, instant) when is_binary(carousel_id) and is_boolean(instant) do
    JS.dispatch("corex:carousel:scroll-prev",
      to: Selectors.css_id(carousel_id),
      detail: scroll_detail(instant),
      bubbles: false
    )
  end

  def scroll_prev(socket, carousel_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) do
    scroll_prev(socket, carousel_id, false)
  end

  def scroll_prev(socket, carousel_id, instant)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(carousel_id) and
             is_boolean(instant) do
    LiveView.push_event(socket, "carousel_scroll_prev", scroll_payload(carousel_id, instant))
  end

  defp scroll_detail(false), do: %{}
  defp scroll_detail(true), do: %{instant: true}

  defp scroll_payload(carousel_id, instant) do
    base = %{"id" => carousel_id}
    if instant, do: Map.put(base, "instant", true), else: base
  end
end
