defmodule E2eWeb.Demos.FloatingPanelDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_basic_code do
    ~S"""
    <.floating_panel class="floating-panel">
      <:trigger class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", true)} class="button ui-size-sm">
        Open
      </.action>
      <.action phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", false)} class="button ui-size-sm">
        Close
      </.action>
    </div>

    #{fp_api_panel_snippet("floating-panel-api-bind", "Open and close via phx-click and Corex.FloatingPanel.set_open/2.")}
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", true)}
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.action
        phx-click={Corex.FloatingPanel.set_open("floating-panel-api-bind", false)}
        class="button ui-size-sm"
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
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="floating-panel-api-js-open" class="button ui-size-sm">
        Open
      </button>
      <button type="button" id="floating-panel-api-js-close" class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="floating-panel-api-js-open" class="button ui-size-sm">
        Open
      </button>
      <button type="button" id="floating-panel-api-js-close" class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="floating_panel_api_server_open" class="button ui-size-sm">
        Open
      </.action>
      <.action phx-click="floating_panel_api_server_close" class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="floating_panel_api_server_open" class="button ui-size-sm">
        Open
      </.action>
      <.action phx-click="floating_panel_api_server_close" class="button ui-size-sm">
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
        <button type="button" class="button ui-size-sm">
          Open
        </button>
        <button type="button" class="button ui-size-sm">
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
        <button type="button" id="floating-panel-anatomy-no-trigger-open" class="button ui-size-sm">
          Open
        </button>
        <button type="button" id="floating-panel-anatomy-no-trigger-close" class="button ui-size-sm">
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
        <:trigger class="button ui-size-sm">
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
        <:trigger class="button ui-size-sm">
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
      <:trigger class="button ui-size-sm">
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
      <:trigger class="button ui-size-sm">
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

  def styling_color_code do
    """
    <.floating_panel class="floating-panel">
      <:trigger class="button ui-size-sm">Default</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-accent">
      <:trigger class="button ui-size-sm">Accent</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-brand">
      <:trigger class="button ui-size-sm">Brand</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-alert">
      <:trigger class="button ui-size-sm">Alert</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-info">
      <:trigger class="button ui-size-sm">Info</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-success">
      <:trigger class="button ui-size-sm">Success</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-md">
      <.floating_panel id="floating-panel-style-color-default" class="floating-panel">
        <:trigger class="button ui-size-sm">Default</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-color-accent"
        class="floating-panel ui-accent"
      >
        <:trigger class="button ui-size-sm">Accent</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-color-brand"
        class="floating-panel ui-brand"
      >
        <:trigger class="button ui-size-sm">Brand</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-color-alert"
        class="floating-panel ui-alert"
      >
        <:trigger class="button ui-size-sm">Alert</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-color-info"
        class="floating-panel ui-info"
      >
        <:trigger class="button ui-size-sm">Info</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-color-success"
        class="floating-panel ui-success"
      >
        <:trigger class="button ui-size-sm">Success</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def styling_variant_code do
    """
    <.floating_panel class="floating-panel">
      <:trigger class="button ui-size-sm">Subtle (default)</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>
    <.floating_panel class="floating-panel ui-solid">
      <:trigger class="button ui-size-sm">Solid</:trigger>
      <:title>Notes</:title>
      #{styling_panel_controls_code()}
      <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
    </.floating_panel>

    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.floating_panel id="floating-panel-style-variant-subtle" class="floating-panel">
        <:trigger class="button ui-size-sm">Subtle (default)</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-minus" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-variant-solid"
        class="floating-panel ui-solid"
      >
        <:trigger class="button ui-size-sm">Solid</:trigger>
        <:title>Notes</:title>
        <:minimize_trigger><.heroicon name="hero-minus" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Drag, resize, and minimize this panel while you work.</p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("floating-panel"),
        variant <- DemoScales.styling_variant_axis_steps("floating-panel") do
      class =
        DemoScales.join_matrix_modifiers("floating-panel", semantic.modifier, variant.modifier)

      """
      <.floating_panel class="#{class}">
        <:trigger class="button ui-size-sm">#{semantic.label}</:trigger>
        <:title>Notes</:title>
        #{styling_panel_controls_code()}
        <:content><p>Drag, resize, and minimize this panel while you work.</p></:content>
      </.floating_panel>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("floating-panel"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("floating-panel"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.floating_panel
            :for={variant <- @matrix_variants}
            class={
              DemoScales.join_matrix_modifiers("floating-panel", semantic.modifier, variant.modifier)
            }
          >
            <:trigger class="button ui-size-sm">{semantic.label}</:trigger>
            <:title>Notes</:title>
            <:minimize_trigger><.heroicon name="hero-minus" class="icon" /></:minimize_trigger>
            <:maximize_trigger>
              <.heroicon name="hero-arrows-pointing-out" class="icon" />
            </:maximize_trigger>
            <:default_trigger>
              <.heroicon name="hero-rectangle-stack" class="icon" />
            </:default_trigger>
            <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
            <:content>
              <p>Drag, resize, and minimize this panel while you work.</p>
            </:content>
          </.floating_panel>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    Enum.map(["sm", "md", "lg", "xl"], fn size ->
      label = String.upcase(size)

      """
      <.floating_panel class="floating-panel ui-size-#{size}">
        <:trigger class="button ui-size-sm">#{label}</:trigger>
        <:title>#{label}</:title>
        #{styling_panel_controls_code()}
        <:content><p>Panel density scales with ui-size-#{size}.</p></:content>
      </.floating_panel>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-md">
      <.floating_panel id="floating-panel-style-sm" class="floating-panel ui-size-sm">
        <:trigger class="button ui-size-sm">SM</:trigger>
        <:title>SM</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Panel density scales with ui-size-sm.</p>
        </:content>
      </.floating_panel>
      <.floating_panel id="floating-panel-style-md" class="floating-panel ui-size-md">
        <:trigger class="button ui-size-sm">MD</:trigger>
        <:title>MD</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Panel density scales with ui-size-md.</p>
        </:content>
      </.floating_panel>
      <.floating_panel id="floating-panel-style-lg" class="floating-panel ui-size-lg">
        <:trigger class="button ui-size-sm">LG</:trigger>
        <:title>LG</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Panel density scales with ui-size-lg.</p>
        </:content>
      </.floating_panel>
      <.floating_panel id="floating-panel-style-xl" class="floating-panel ui-size-xl">
        <:trigger class="button ui-size-sm">XL</:trigger>
        <:title>XL</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Panel density scales with ui-size-xl.</p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  def styling_rounded_code do
    for {suffix, label} <- [
          {"none", "None"},
          {"sm", "SM"},
          {"md", "MD"},
          {"lg", "LG"},
          {"xl", "XL"},
          {"full", "Full"}
        ] do
      """
      <.floating_panel class="floating-panel ui-rounded-#{suffix}">
        <:trigger class="button ui-size-sm">#{label}</:trigger>
        <:title>#{label}</:title>
        #{styling_panel_controls_code()}
        <:content><p>Corner radius via ui-rounded-#{suffix}.</p></:content>
      </.floating_panel>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-md">
      <.floating_panel
        id="floating-panel-style-rounded-none"
        class="floating-panel ui-rounded-none"
      >
        <:trigger class="button ui-size-sm">None</:trigger>
        <:title>None</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-none.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-rounded-sm"
        class="floating-panel ui-rounded-sm"
      >
        <:trigger class="button ui-size-sm">SM</:trigger>
        <:title>SM</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-sm.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-rounded-md"
        class="floating-panel ui-rounded-md"
      >
        <:trigger class="button ui-size-sm">MD</:trigger>
        <:title>MD</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-md.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-rounded-lg"
        class="floating-panel ui-rounded-lg"
      >
        <:trigger class="button ui-size-sm">LG</:trigger>
        <:title>LG</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-lg.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-rounded-xl"
        class="floating-panel ui-rounded-xl"
      >
        <:trigger class="button ui-size-sm">XL</:trigger>
        <:title>XL</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-xl.</p>
        </:content>
      </.floating_panel>
      <.floating_panel
        id="floating-panel-style-rounded-full"
        class="floating-panel ui-rounded-full"
      >
        <:trigger class="button ui-size-sm">Full</:trigger>
        <:title>Full</:title>
        <:minimize_trigger><.heroicon name="hero-arrow-down-left" class="icon" /></:minimize_trigger>
        <:maximize_trigger>
          <.heroicon name="hero-arrows-pointing-out" class="icon" />
        </:maximize_trigger>
        <:default_trigger><.heroicon name="hero-rectangle-stack" class="icon" /></:default_trigger>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
        <:content>
          <p>Corner radius via ui-rounded-full.</p>
        </:content>
      </.floating_panel>
    </div>
    """
  end

  defp styling_panel_controls_code do
    """
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
    """
  end
end
