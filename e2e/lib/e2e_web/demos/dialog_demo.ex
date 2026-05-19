defmodule E2eWeb.Demos.DialogDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.dialog class="dialog">
      <:trigger>Open</:trigger>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-minimal" class="dialog">
      <:trigger>Open</:trigger>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def with_title_description_code do
    ~S"""
    <.dialog class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>
        Consectetur adipiscing elit. Sed sodales ullamcorper tristique.
      </:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def with_title_description_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-titled" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>
        Consectetur adipiscing elit. Sed sodales ullamcorper tristique.
      </:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def actions_code do
    ~S"""
    <.dialog class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button button--sm button--ghost">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button button--sm">
            Continue
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def actions_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-actions" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action
            phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}
            class="button button--sm button--ghost"
          >
            Cancel
          </.action>
          <.action
            phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}
            class="button button--sm"
          >
            Continue
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} class="button button--sm">
        Open
      </.action>
    </div>

    <.dialog id="dialog-api" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button button--sm">
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} class="button button--sm">
        Open
      </.action>
    </div>

    <.dialog id="dialog-api" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button button--sm">
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_js_heex do
    ~S"""
    <div class="layout__row">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
            to: "#dialog-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Open
      </.action>
    </div>

    <.dialog id="dialog-api-js" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action
            phx-click={
              Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
                to: "#dialog-api-js",
                detail: %{open: false},
                bubbles: false
              )
            }
            class="button button--sm"
          >
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_js_js do
    ~S"""
    const el = document.getElementById("dialog-api-js");
    el?.dispatchEvent(
      new CustomEvent("corex:dialog:set-open", { bubbles: false, detail: { open: true } })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:dialog:set-open", { bubbles: false, detail: { open: false } })
    );
    """
  end

  def api_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("dialog-api-js");
    el?.dispatchEvent(
      new CustomEvent("corex:dialog:set-open", { bubbles: false, detail: { open: true } })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:dialog:set-open", { bubbles: false, detail: { open: false } })
    );
    """
  end

  def api_client_js_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
            to: "#dialog-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Open
      </.action>
    </div>

    <.dialog id="dialog-api-js" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action
            phx-click={
              Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
                to: "#dialog-api-js",
                detail: %{open: false},
                bubbles: false
              )
            }
            class="button button--sm"
          >
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="dialog_api_open" class="button button--sm">Open</.action>
    </div>

    <.dialog id="dialog-api-server" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click="dialog_api_close" class="button button--sm">Close</.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("dialog_api_open", _, socket) do
      {:noreply, Corex.Dialog.set_open(socket, "dialog-api-server", true)}
    end

    def handle_event("dialog_api_close", _, socket) do
      {:noreply, Corex.Dialog.set_open(socket, "dialog-api-server", false)}
    end
    """
  end

  def api_server_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action phx-click="dialog_api_open" class="button button--sm">Open</.action>
    </div>

    <.dialog id="dialog-api-server" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click="dialog_api_close" class="button button--sm">Close</.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def events_server_heex do
    ~S"""
    <.dialog class="dialog" on_open_change="dialog_open_changed">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "dialog_open_changed",
      ~S|%{"open" => open, "id" => id} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.dialog id="dialog-events-client" class="dialog" on_open_change_client="dialog-open-changed">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("dialog-events-client");
    el?.addEventListener("dialog-open-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("dialog-events-client");
    el?.addEventListener("dialog-open-changed", (event: Event) => {
      console.log((event as CustomEvent<{ id: string; open: boolean }>).detail);
    });
    """
  end

  def animation_instant_heex do
    ~S"""
    <.dialog
      class="dialog"
      modal
      animation="instant"
    >
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def animation_custom_heex do
    ~S"""
    <.dialog
      class="dialog"
      animation="custom"
      on_open_change_client="my-dialog-open-changed"
    >
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def styling_size_code do
    ~S"""
    <.dialog class="dialog dialog--sm" modal>
      <:trigger>Open (sm)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--md" modal>
      <:trigger>Open (md)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--lg" modal>
      <:trigger>Open (lg)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--xl" modal>
      <:trigger>Open (xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-sm" class="dialog dialog--sm" modal>
        <:trigger>Open (sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-md" class="dialog dialog--md" modal>
        <:trigger>Open (md)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-lg" class="dialog dialog--lg" modal>
        <:trigger>Open (lg)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-xl" class="dialog dialog--xl" modal>
        <:trigger>Open (xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_text_code do
    ~S"""
    <.dialog class="dialog dialog--text-sm" modal>
      <:trigger>Open (text-sm)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--text-xl" modal>
      <:trigger>Open (text-xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--text-2xl" modal>
      <:trigger>Open (text-2xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--text-4xl" modal>
      <:trigger>Open (text-4xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_text_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-text-sm" class="dialog dialog--text-sm" modal>
        <:trigger>Open (text-sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-xl" class="dialog dialog--text-xl" modal>
        <:trigger>Open (text-xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-2xl" class="dialog dialog--text-2xl" modal>
        <:trigger>Open (text-2xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-4xl" class="dialog dialog--text-4xl" modal>
        <:trigger>Open (text-4xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.dialog class="dialog dialog--rounded-none" modal>
      <:trigger>Open (rounded-none)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--rounded-sm" modal>
      <:trigger>Open (rounded-sm)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--rounded-md" modal>
      <:trigger>Open (rounded-md)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--rounded-lg" modal>
      <:trigger>Open (rounded-lg)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--rounded-xl" modal>
      <:trigger>Open (rounded-xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--rounded-full" modal>
      <:trigger>Open (rounded-full)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-rounded-none" class="dialog dialog--rounded-none" modal>
        <:trigger>Open (rounded-none)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-sm" class="dialog dialog--rounded-sm" modal>
        <:trigger>Open (rounded-sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-md" class="dialog dialog--rounded-md" modal>
        <:trigger>Open (rounded-md)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-lg" class="dialog dialog--rounded-lg" modal>
        <:trigger>Open (rounded-lg)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-xl" class="dialog dialog--rounded-xl" modal>
        <:trigger>Open (rounded-xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-full" class="dialog dialog--rounded-full" modal>
        <:trigger>Open (rounded-full)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_sidebar_code do
    ~S"""
    <.dialog class="dialog dialog--side" modal>
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_sidebar_example(assigns) do
    ~H"""
    <.dialog id="dialog-style-sidebar" class="dialog dialog--side" modal>
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
      </:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def animation_custom_js do
    ~S"""
    import { animate } from "motion"
    import {
      findDialogBackdrop,
      findDialogContent,
      animateScaleOpen,
      animateScaleClose,
    } from "corex"

    const reducedMotion = () =>
      window.matchMedia("(prefers-reduced-motion: reduce)").matches

    document.addEventListener("my-dialog-open-changed", (e) => {
      const { id, open } = e.detail
      const root = document.getElementById(id)
      if (!root) return
      const backdrop = findDialogBackdrop(root)
      const content = findDialogContent(root)
      if (open) {
        if (backdrop)
          animateScaleOpen(backdrop, { animator: animate, duration: 0.5, easing: "ease-out" })
        if (content) {
          animateScaleOpen(content, {
            animator: animate,
            duration: 0.7,
            easing: [0.16, 1, 0.3, 1],
            scaleStart: 0.7,
            scaleEnd: 1,
          })
          if (!reducedMotion())
            animate(
              content,
              { y: [60, 0], filter: ["blur(12px)", "blur(0px)"] },
              { duration: 0.7, easing: [0.16, 1, 0.3, 1] },
            )
        }
      } else {
        if (backdrop)
          animateScaleClose(backdrop, { animator: animate, duration: 0.4, easing: "ease-in" })
        if (content) {
          animateScaleClose(content, {
            animator: animate,
            duration: 0.35,
            easing: "ease-in",
            scaleStart: 0.8,
            scaleEnd: 1,
          })
          if (!reducedMotion())
            animate(
              content,
              { y: [0, 40], filter: ["blur(0px)", "blur(12px)"] },
              { duration: 0.35, easing: "ease-in" },
            )
        }
      }
    })
    """
  end
end
