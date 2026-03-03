defmodule <%= @web_namespace %>.ExampleLive do
  use <%= @web_namespace %>, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Live View</h1>
    """
  end
end
