defmodule <%= @web_namespace %>.ExampleLive do
  use <%= @web_namespace %>, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      <%= if @mode do %>mode={@mode}<% end %>
      <%= if @theme do %>theme={@theme}<% end %>
      <%= if @theme_switcher do %>themes={@themes}<% end %>
      <%= if @language_switcher do %>locale={@locale}
      current_path={@current_path}<% end %>
    >
      <section>
        <h1>Live View</h1>
      </section>
    </Layouts.app>
    """
  end
end
