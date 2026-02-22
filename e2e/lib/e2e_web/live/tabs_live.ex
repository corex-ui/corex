defmodule E2eWeb.TabsLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Tabs.set_value(socket, "my-tabs", value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <div class="layout__row">
        <h1>Tabs</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Tabs.set_value("my-tabs", "lorem")}
          class="button button--sm"
        >
          Open Item 1
        </button>
        <button
          phx-click={Corex.Tabs.set_value("my-tabs", "duis")}
          class="button button--sm"
        >
          Open Item 1 and 2
        </button>
        <button phx-click={Corex.Tabs.set_value("my-tabs", nil)} class="button button--sm">
          Close all Items
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="lorem" class="button button--sm">
          Open Item 1
        </button>
        <button
          phx-click="set_value"
          value="duis"
          class="button button--sm"
        >
          Open Item 1 and 2
        </button>
        <button phx-click="set_value" value={nil} class="button button--sm">
          Close all Items
        </button>
      </div>
      <.tabs
        id="my-tabs"
        class="tabs"
        value="lorem"
        items={
          Corex.Content.new([
            [
              id: "lorem",
              trigger: "Lorem",
              content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
            ],
            [
              id: "duis",
              trigger: "Duis",
              content: "Nullam eget vestibulum ligula, at interdum tellus."
            ],
            [
              id: "donec",
              trigger: "Donec",
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
            ]
          ])
        }
      />
    </Layouts.app>
    """
  end
end
