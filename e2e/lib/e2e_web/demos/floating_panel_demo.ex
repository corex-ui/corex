defmodule E2eWeb.Demos.FloatingPanelDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.floating_panel id="floating-panel-anatomy" class="floating-panel">
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>
          Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis
          non, pellentesque elit. Pellentesque sagittis fermentum.
        </p>
      </:content>
    </.floating_panel>
    """
  end

  def api_client_binding_code do
    """
    <div class="layout__row">
      <.action phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", true)} class="button button--sm">
        Open
      </.action>
      <.action phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", false)} class="button button--sm">
        Close
      </.action>
    </div>

    #{fp_api_panel_snippet("floating-panel-api-bind", "Open and close via phx-click and Corex.FloatingPanel.set_open/2.")}
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", true)}
        class="button button--sm"
      >
        Open
      </.action>
      <.action
        phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", false)}
        class="button button--sm"
      >
        Close
      </.action>
    </div>

    <.floating_panel_api_fixture
      id="floating-panel-api-bind"
      inner_text="Open and close via phx-click and Corex.FloatingPanel.set_open/2."
    />
    """
  end

  def api_client_js_code do
    ~S"""
    <div class="layout__row">
      <button type="button" id="floating-panel-api-js-open" class="button button--sm">
        Open
      </button>
      <button type="button" id="floating-panel-api-js-close" class="button button--sm">
        Close
      </button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".FloatingPanelApiClientJs">
      export default {
        mounted() {
          const panel = document.getElementById("floating-panel-api-js")
          document.getElementById("floating-panel-api-js-open")?.addEventListener("click", () => {
            panel?.dispatchEvent(
              new CustomEvent("corex:floating-panel:set-open", {
                detail: { open: true },
                bubbles: false,
              })
            )
          })
          document.getElementById("floating-panel-api-js-close")?.addEventListener("click", () => {
            panel?.dispatchEvent(
              new CustomEvent("corex:floating-panel:set-open", {
                detail: { open: false },
                bubbles: false,
              })
            )
          })
        },
      }
    </script>

    <.floating_panel id="floating-panel-api-js" class="floating-panel">
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>Open and close by dispatching corex:floating-panel:set-open on the panel root.</p>
      </:content>
    </.floating_panel>
    """
  end

  def api_client_js_example(assigns) do
    ~H"""
    <div class="layout__row">
      <button type="button" id="floating-panel-api-js-open" class="button button--sm">
        Open
      </button>
      <button type="button" id="floating-panel-api-js-close" class="button button--sm">
        Close
      </button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".FloatingPanelApiClientJs">
      export default {
        mounted() {
          const panel = document.getElementById("floating-panel-api-js")
          document.getElementById("floating-panel-api-js-open")?.addEventListener("click", () => {
            panel?.dispatchEvent(
              new CustomEvent("corex:floating-panel:set-open", {
                detail: { open: true },
                bubbles: false,
              })
            )
          })
          document.getElementById("floating-panel-api-js-close")?.addEventListener("click", () => {
            panel?.dispatchEvent(
              new CustomEvent("corex:floating-panel:set-open", {
                detail: { open: false },
                bubbles: false,
              })
            )
          })
        },
      }
    </script>

    <.floating_panel_api_fixture
      id="floating-panel-api-js"
      inner_text="Open and close by dispatching corex:floating-panel:set-open on the panel root."
    />
    """
  end

  def api_server_heex_code do
    """
    <div class="layout__row">
      <.action phx-click="floating_panel_api_server_open" class="button button--sm">
        Open
      </.action>
      <.action phx-click="floating_panel_api_server_close" class="button button--sm">
        Close
      </.action>
    </div>

    #{fp_api_panel_snippet("floating-panel-api-server", "Open and close via LiveView push_event and Corex.FloatingPanel.set_open/3.")}
    """
  end

  def api_server_handler_code do
    ~S"""
    def handle_event("floating_panel_api_server_open", _, socket) do
      {:noreply, Corex.FloatingPanel.set_open(socket, "floating-panel-api-server", true)}
    end

    def handle_event("floating_panel_api_server_close", _, socket) do
      {:noreply, Corex.FloatingPanel.set_open(socket, "floating-panel-api-server", false)}
    end
    """
  end

  def api_server_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action phx-click="floating_panel_api_server_open" class="button button--sm">
        Open
      </.action>
      <.action phx-click="floating_panel_api_server_close" class="button button--sm">
        Close
      </.action>
    </div>

    <.floating_panel_api_fixture
      id="floating-panel-api-server"
      inner_text="Open and close via LiveView push_event and Corex.FloatingPanel.set_open/3."
    />
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.floating_panel id="floating-panel-anatomy" class="floating-panel">
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>
          Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis
          non, pellentesque elit. Pellentesque sagittis fermentum.
        </p>
      </:content>
    </.floating_panel>
    """
  end

  def events_server_heex do
    ~S"""
    <.floating_panel
      id="fp-events-live"
      class="floating-panel"
      on_open_change="floating_panel_open_changed"
      on_open_change_client="floating-panel-open-changed"
    >
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>Lorem ipsum dolor sit amet.</p>
      </:content>
    </.floating_panel>
    """
  end

  attr :id, :string, required: true
  attr :inner_text, :string, required: true

  def floating_panel_api_fixture(assigns) do
    ~H"""
    <.floating_panel id={@id} class="floating-panel">
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>{@inner_text}</p>
      </:content>
    </.floating_panel>
    """
  end

  defp fp_api_panel_snippet(id, inner_text) do
    """
    <.floating_panel id="#{id}" class="floating-panel">
      <:trigger>
        <span data-closed>Open panel</span>
        <span data-open>Close panel</span>
      </:trigger>
      <:title>Panel</:title>
      <:minimize_trigger>
        <.heroicon name="hero-arrow-down-left" class="icon" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.heroicon name="hero-arrows-pointing-out" class="icon" />
      </:maximize_trigger>
      <:default_trigger>
        <.heroicon name="hero-rectangle-stack" class="icon" />
      </:default_trigger>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>#{inner_text}</p>
      </:content>
    </.floating_panel>
    """
  end
end
