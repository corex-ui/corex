defmodule E2eWeb.Demos.FloatingPanelDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.floating_panel class="floating-panel">
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

  def api_client_js_heex do
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

  def api_client_js_js do
    ~S"""
    const panel = document.getElementById("floating-panel-api-js");
    panel?.dispatchEvent(
      new CustomEvent("corex:floating-panel:set-open", { detail: { open: true }, bubbles: false })
    );
    panel?.dispatchEvent(
      new CustomEvent("corex:floating-panel:set-open", { detail: { open: false }, bubbles: false })
    );
    """
  end

  def api_client_js_ts do
    ~S"""
    const panel: HTMLElement | null = document.getElementById("floating-panel-api-js");
    panel?.dispatchEvent(
      new CustomEvent("corex:floating-panel:set-open", { detail: { open: true }, bubbles: false })
    );
    panel?.dispatchEvent(
      new CustomEvent("corex:floating-panel:set-open", { detail: { open: false }, bubbles: false })
    );
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

  def api_server_heex do
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

  def api_server_elixir do
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

  defp anatomy_no_trigger_external_controls_script do
    ~S"""
    <script>
      (function () {
        const openBtn = document.getElementById("floating-panel-anatomy-no-trigger-open");
        const closeBtn = document.getElementById("floating-panel-anatomy-no-trigger-close");
        const dispatch = (open) => {
          document.getElementById("floating-panel-anatomy-no-trigger")?.dispatchEvent(
            new CustomEvent("corex:floating-panel:set-open", {
              detail: { open },
              bubbles: false,
            })
          );
        };
        openBtn?.addEventListener("click", () => dispatch(true));
        closeBtn?.addEventListener("click", () => dispatch(false));
      })();
    </script>
    """
  end

  def anatomy_no_trigger_code do
    """
    <div class="flex flex-col gap-space">
      <div class="flex flex-wrap gap-2">
        <button type="button" class="button button--sm">
          Open
        </button>
        <button type="button" class="button button--sm">
          Close
        </button>
      </div>
      #{anatomy_no_trigger_external_controls_script()}
      <.floating_panel class="floating-panel">
        <:trigger class="sr-only">
          <span data-closed>Open auxiliary panel</span>
          <span data-open>Close auxiliary panel</span>
        </:trigger>
        <:title>Auxiliary panel</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:close_trigger>
        <:content>
          <p>Opened from external buttons; the Zag trigger stays in the tab order but is visually hidden.</p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def anatomy_no_trigger_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-space">
      <div class="flex flex-wrap gap-2">
        <button type="button" id="floating-panel-anatomy-no-trigger-open" class="button button--sm">
          Open
        </button>
        <button type="button" id="floating-panel-anatomy-no-trigger-close" class="button button--sm">
          Close
        </button>
      </div>
      {Phoenix.HTML.raw(anatomy_no_trigger_external_controls_script())}
      <.floating_panel id="floating-panel-anatomy-no-trigger" class="floating-panel">
        <:trigger class="sr-only">
          <span data-closed>Open auxiliary panel</span>
          <span data-open>Close auxiliary panel</span>
        </:trigger>
        <:title>Auxiliary panel</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:close_trigger>
        <:content>
          <p>
            Opened from external buttons; the Zag trigger stays in the tab order but is visually hidden.
          </p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def anatomy_positioning_code do
    ~S"""
    <div class="inline-block rounded-md border border-border p-space">
      <.floating_panel
        class="floating-panel"
        positioning={%Corex.Positioning{placement: "top-start", gutter: 20, flip: true}}
      >
        <:trigger class="button button--ghost button--sm">
          <span data-closed>Open anchored panel</span>
          <span data-open>Close anchored panel</span>
        </:trigger>
        <:title>Placement</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:close_trigger>
        <:content>
          <p>
            Uses <code class="text-sm">positioning={%Corex.Positioning{}}</code> so the hook passes
            <code class="text-sm">getAnchorPosition</code> with placement and gutter (flip keeps it in view).
          </p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def anatomy_positioning_example(assigns) do
    ~H"""
    <div class="inline-block rounded-md border border-border p-space">
      <.floating_panel
        id="floating-panel-anatomy-positioning"
        class="floating-panel"
        positioning={%Corex.Positioning{placement: "top-start", gutter: 20, flip: true}}
      >
        <:trigger class="button button--ghost button--sm">
          <span data-closed>Open anchored panel</span>
          <span data-open>Close anchored panel</span>
        </:trigger>
        <:title>Placement</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:close_trigger>
        <:content>
          <p>
            Uses <code class="text-sm">{"positioning={%Corex.Positioning{}}"}</code>
            so the hook passes <code class="text-sm">getAnchorPosition</code>
            with placement and gutter (flip keeps it in view).
          </p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def anatomy_size_code do
    ~S"""
    <.floating_panel
      class="floating-panel"
      size={%{width: 380, height: 220}}
      min_size={%{width: 280, height: 160}}
    >
      <:trigger class="button button--ghost button--sm">
        <span data-closed>Open sized panel</span>
        <span data-open>Close sized panel</span>
      </:trigger>
      <:title>Default size</:title>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>
          <code class="text-sm">size={%{width: 380, height: 220}}</code> maps to Zag
          <code class="text-sm">defaultSize</code>; optional <code class="text-sm">min_size</code> constrains resize.
        </p>
      </:content>
    </.floating_panel>
    """
  end

  def anatomy_size_example(assigns) do
    ~H"""
    <.floating_panel
      id="floating-panel-anatomy-size"
      class="floating-panel"
      size={%{width: 380, height: 220}}
      min_size={%{width: 280, height: 160}}
    >
      <:trigger class="button button--ghost button--sm">
        <span data-closed>Open sized panel</span>
        <span data-open>Close sized panel</span>
      </:trigger>
      <:title>Default size</:title>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
      <:content>
        <p>
          <code class="text-sm">{"size={%{width: 380, height: 220}}"}</code>
          maps to Zag <code class="text-sm">defaultSize</code>; optional
          <code class="text-sm">min_size</code>
          constrains resize.
        </p>
      </:content>
    </.floating_panel>
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
      class="floating-panel"
      on_open_change="floating_panel_open_changed"
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

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "floating_panel_open_changed",
      ~S|%{"open" => open, "id" => id} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.floating_panel
      id="fp-events-client"
      class="floating-panel"
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

  def events_client_js do
    ~S"""
    const el = document.getElementById("fp-events-client");
    el?.addEventListener("floating-panel-open-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("fp-events-client");
    el?.addEventListener("floating-panel-open-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id: string; open: boolean }>).detail);
    });
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
