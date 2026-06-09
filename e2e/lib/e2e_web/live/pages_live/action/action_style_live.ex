defmodule E2eWeb.ActionStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage,
    only: [demo_page: 1, demo_section: 1, demo_style_matrix: 1]

  alias E2eWeb.Demos.ActionDemo

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = raw == true or raw == "true"

    send_update(E2eWeb.ActionStylePlayground,
      id: "action-style-playground",
      control_changed: %{id: id, value: checked}
    )

    {:noreply, socket}
  end

  def handle_event("control_changed", %{"value" => value, "id" => id}, socket)
      when is_list(value) do
    normalized =
      case value do
        [v] -> v
        [] -> nil
      end

    send_update(E2eWeb.ActionStylePlayground,
      id: "action-style-playground",
      control_changed: %{id: id, value: normalized}
    )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      path={@path}
      mode={@mode}
      theme={@theme}
    >
      <.demo_page
        path={@path}
        id="action-style-page"
        title="Action · Style"
      >
        <.live_component module={E2eWeb.ActionStylePlayground} id="action-style-playground" />

        <.demo_style_matrix id="action-style-matrix">
          <.demo_section
            id="action-style-variant-semantic"
            title="Variant × semantic"
            values={ActionDemo.styling_variant_semantic_values()}
            code={ActionDemo.styling_variant_semantic_code()}
          >
            <:preview>
              <ActionDemo.styling_variant_semantic_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="action-style-size"
            title="Size"
            values={ActionDemo.styling_axis_values(:size)}
            code={ActionDemo.styling_size_code()}
          >
            <:preview>
              <ActionDemo.styling_size_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="action-style-rounded"
            title="Rounded"
            values={ActionDemo.styling_axis_values(:radius)}
            code={ActionDemo.styling_radius_code()}
          >
            <:preview>
              <ActionDemo.styling_radius_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="action-style-shape"
            title="Shape"
            values={ActionDemo.styling_axis_values(:shape)}
            code={ActionDemo.styling_shape_code()}
          >
            <:preview>
              <ActionDemo.styling_shape_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="action-style-disabled"
            title="Disabled"
            code={ActionDemo.styling_disabled_code()}
          >
            <:preview>
              <ActionDemo.styling_disabled_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="action-style-link"
            title="Link look"
            values={ActionDemo.styling_link_values()}
            code={ActionDemo.styling_link_code()}
          >
            <:preview>
              <ActionDemo.styling_link_example />
            </:preview>
          </.demo_section>
        </.demo_style_matrix>
      </.demo_page>
    </Layouts.app>
    """
  end
end
