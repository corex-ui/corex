defmodule E2eWeb.ComponentStylePage do
  @moduledoc false

  defmacro __using__(opts) do
    component = Keyword.fetch!(opts, :component)

    quote do
      use E2eWeb, :live_view

      alias E2eWeb.ComponentStyleConfig
      alias E2eWeb.ComponentStylePageView

      @component unquote(component)

      @impl true
      def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
        checked = raw == true or raw == "true"
        send_playground_update(id, checked, socket)
      end

      def handle_event("control_changed", %{"value" => value, "id" => id}, socket)
          when is_list(value) do
        normalized =
          case value do
            [v] -> v
            [] -> nil
          end

        send_playground_update(id, normalized, socket)
      end

      @impl true
      def render(assigns) do
        assigns =
          Map.merge(assigns, %{
            component: @component,
            config: ComponentStyleConfig.get(@component)
          })

        ComponentStylePageView.page(assigns)
      end

      defp send_playground_update(id, value, socket) do
        config = ComponentStyleConfig.get(@component)

        send_update(config.playground_module,
          id: "#{config.slug}-style-playground",
          component: @component,
          control_changed: %{id: id, value: value}
        )

        {:noreply, socket}
      end
    end
  end
end
