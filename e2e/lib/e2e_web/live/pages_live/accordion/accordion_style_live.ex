defmodule E2eWeb.AccordionStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1]

  alias E2eWeb.ComponentStyleConfig
  alias E2eWeb.ComponentStyleMatrix

  @component :accordion

  @impl true
  def handle_event("control_changed", %{"value" => value, "id" => id}, socket)
      when is_list(value) do
    normalized =
      case value do
        [v] -> v
        [] -> nil
      end

    config = ComponentStyleConfig.get(@component)

    send_update(config.playground_module,
      id: "#{config.slug}-style-playground",
      component: @component,
      control_changed: %{id: id, value: normalized}
    )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    config = ComponentStyleConfig.get(@component)
    assigns = assign(assigns, :config, config)

    ~H"""
    <Layouts.app flash={@flash} path={@path} mode={@mode} theme={@theme}>
      <.demo_page path={@path} id={@config.page_id} title={@config.title}>
        <.live_component
          module={@config.playground_module}
          id={"#{@config.slug}-style-playground"}
          component={@config.component}
        />
        <ComponentStyleMatrix.style_matrix component={@config.component} />
      </.demo_page>
    </Layouts.app>
    """
  end
end
