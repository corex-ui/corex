defmodule Corex.Api.RespondTo do
  @moduledoc false

  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @respond_to_targets ~W(both server client)a

  @spec respond_to_fields(keyword()) :: %{respond_to: String.t()}
  def respond_to_fields(opts) when is_list(opts) do
    opts
    |> Keyword.get(:respond_to, :server)
    |> respond_to_field()
  end

  defp respond_to_field(target) when target in @respond_to_targets do
    %{respond_to: Atom.to_string(target)}
  end

  defp respond_to_field(other) do
    raise ArgumentError,
          "invalid :respond_to, expected :both, :server, or :client, got: #{inspect(other)}"
  end

  @spec push_event(Phoenix.LiveView.Socket.t(), String.t(), map()) :: Phoenix.LiveView.Socket.t()
  def push_event(socket, event, payload)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_map(payload) do
    LiveView.push_event(socket, event, payload)
  end

  @spec push_set_value(Phoenix.LiveView.Socket.t(), String.t(), String.t(), term()) ::
          Phoenix.LiveView.Socket.t()
  def push_set_value(socket, event, id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_binary(id) do
    push_event(socket, event, %{id: id, value: value})
  end

  @spec push_set_open(Phoenix.LiveView.Socket.t(), String.t(), String.t(), boolean()) ::
          Phoenix.LiveView.Socket.t()
  def push_set_open(socket, event, id, open)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_binary(id) and
             is_boolean(open) do
    push_event(socket, event, %{id: id, open: open})
  end

  @spec dispatch_set_value(String.t(), term(), String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  def dispatch_set_value(component_id, value, hook_event, opts \\ []) do
    bubbles = Keyword.get(opts, :bubbles, false)

    JS.dispatch(hook_event,
      to: Corex.Selectors.css_id(component_id),
      detail: %{id: component_id, value: value},
      bubbles: bubbles
    )
  end

  @spec dispatch_set_open(String.t(), boolean(), String.t(), keyword()) :: Phoenix.LiveView.JS.t()
  def dispatch_set_open(component_id, open, hook_event, opts \\ []) when is_boolean(open) do
    bubbles = Keyword.get(opts, :bubbles, false)

    JS.dispatch(hook_event,
      to: Corex.Selectors.css_id(component_id),
      detail: %{id: component_id, open: open},
      bubbles: bubbles
    )
  end
end
