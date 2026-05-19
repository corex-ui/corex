defmodule E2eWeb.Demos.DialogDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.dialog class="dialog">
      <:trigger>Open</:trigger>
      <:content>
        <p>Minimal content.</p>
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
        <p>Minimal content.</p>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>
        Short description of what this dialog is for.
      </:description>
      <:content>
        <p>Body content.</p>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>
        Short description of what this dialog is for.
      </:description>
      <:content>
        <p>Body content.</p>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Confirm</:title>
      <:description>Choose an action to continue.</:description>
      <:content>
        <p>Are you sure you want to continue?</p>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Confirm</:title>
      <:description>Choose an action to continue.</:description>
      <:content>
        <p>Are you sure you want to continue?</p>
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
        Open Dialog
      </.action>
    </div>

    <.dialog id="dialog-api" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
        <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button button--sm">
          Close
        </.action>
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
        Open Dialog
      </.action>
    </div>

    <.dialog id="dialog-api" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
        <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button button--sm">
          Close
        </.action>
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
        Open Dialog
      </.action>
    </div>

    <.dialog id="dialog-api-js" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
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
        Open Dialog
      </.action>
    </div>

    <.dialog id="dialog-api-js" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
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
      <.action phx-click="dialog_api_open" class="button button--sm">Open Dialog</.action>
    </div>

    <.dialog id="dialog-api-server" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
        <.action phx-click="dialog_api_close" class="button button--sm">Close</.action>
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
      <.action phx-click="dialog_api_open" class="button button--sm">Open Dialog</.action>
    </div>

    <.dialog id="dialog-api-server" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>Dialog description.</:description>
      <:content>
        <p>Dialog content</p>
        <.action phx-click="dialog_api_close" class="button button--sm">Close</.action>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:content>
        <p>Dialog content</p>
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
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:content>
        <p>Dialog content</p>
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

  def patterns_controlled_heex do
    ~S"""
    <.dialog
      class="dialog"
      controlled
      open={@dialog_open}
      on_open_change="patterns_dialog_open_changed"
    >
      <:trigger>Open dialog</:trigger>
      <:title>Controlled</:title>
      <:description>State lives on the LiveView.</:description>
      <:content>
        <p>Content</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" class="icon" />
      </:close_trigger>
    </.dialog>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def handle_event("patterns_dialog_open_changed", %{"open" => open}, socket) do
      {:noreply, assign(socket, :dialog_open, open)}
    end
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
      <:title>Instant</:title>
      <:content>
        <p>Native show and hide without JS transitions.</p>
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
      <:title>Custom</:title>
      <:content>
        <p>Motion animates open and close.</p>
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
      <:title>Small</:title>
      <:content><p>Content</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--md" modal>
      <:trigger>Open (md)</:trigger>
      <:title>Medium</:title>
      <:content><p>Content</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--lg" modal>
      <:trigger>Open (lg)</:trigger>
      <:title>Large</:title>
      <:content><p>Content</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog dialog--xl" modal>
      <:trigger>Open (xl)</:trigger>
      <:title>Extra large</:title>
      <:content><p>Content</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-sm" class="dialog dialog--sm" modal>
        <:trigger>Open (sm)</:trigger>
        <:title>Small</:title>
        <:content>
          <p>Content</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-md" class="dialog dialog--md" modal>
        <:trigger>Open (md)</:trigger>
        <:title>Medium</:title>
        <:content>
          <p>Content</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-lg" class="dialog dialog--lg" modal>
        <:trigger>Open (lg)</:trigger>
        <:title>Large</:title>
        <:content>
          <p>Content</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-xl" class="dialog dialog--xl" modal>
        <:trigger>Open (xl)</:trigger>
        <:title>Extra large</:title>
        <:content>
          <p>Content</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_sidebar_code do
    ~S"""
    <.dialog class="dialog dialog--sidebar" modal>
      <:trigger>Open sidebar</:trigger>
      <:title>Sidebar</:title>
      <:content><p>Edge-aligned panel.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_sidebar_example(assigns) do
    ~H"""
    <.dialog id="dialog-style-sidebar" class="dialog dialog--sidebar" modal>
      <:trigger>Open sidebar</:trigger>
      <:title>Sidebar</:title>
      <:content>
        <p>Edge-aligned panel.</p>
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
