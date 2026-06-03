defmodule E2eWeb.Demos.DialogDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def minimal_code do
    ~S"""
    <.dialog>
      <:trigger>Open</:trigger>
      <:content>
        <p>Minimal content.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-minimal">
      <:trigger>Open</:trigger>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def with_title_description_code do
    ~S"""
    <.dialog>
      <:trigger>Open Dialog</:trigger>
      <:title>Dialog Title</:title>
      <:description>
        Short description of what this dialog is for.
      </:description>
      <:content>
        <p>Body content.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def with_title_description_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-titled">
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
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def actions_code do
    ~S"""
    <.dialog id="dialog-anatomy-actions">
      <:trigger>Open Dialog</:trigger>
      <:title>Confirm</:title>
      <:description>Choose an action to continue.</:description>
      <:content>
        <p>Are you sure you want to continue?</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}>
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}>
            Continue
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def actions_example(assigns) do
    ~H"""
    <.dialog id="dialog-anatomy-actions">
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
            size="sm"
            variant="ghost"
          >
            Cancel
          </.action>
          <.action
            phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}
            size="sm"
          >
            Continue
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} size="sm">
        Open
      </.action>
    </div>

    <.dialog id="dialog-api"  >
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} size="sm">
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} size="sm">
        Open
      </.action>
    </div>

    <.dialog id="dialog-api">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} size="sm">
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
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
        size="sm"
      >
        Open
      </.action>
    </div>

    <.dialog id="dialog-api-js"  >
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
            size="sm"
          >
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
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
        size="sm"
      >
        Open
      </.action>
    </div>

    <.dialog id="dialog-api-js">
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
            size="sm"
          >
            Close
          </.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def api_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="dialog_api_open" size="sm">Open</.action>
    </div>

    <.dialog id="dialog-api-server"  >
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click="dialog_api_close" size="sm">Close</.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
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
      <.action phx-click="dialog_api_open" size="sm">Open</.action>
    </div>

    <.dialog id="dialog-api-server">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click="dialog_api_close" size="sm">Close</.action>
        </div>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def events_server_heex do
    ~S"""
    <.dialog   on_open_change="dialog_open_changed">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
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
    <.dialog id="dialog-events-client"   on_open_change_client="dialog-open-changed">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
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
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def animation_custom_heex do
    ~S"""
    <.dialog
       
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
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def styling_semantic_code do
    join_snippets([
      E2eWeb.AuthoringSnippet.dialog_modal_snippets([]),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(semantic: "accent"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(semantic: "brand"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(semantic: "alert"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(semantic: "info"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(semantic: "success")
    ])
  end

  def styling_semantic_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4 items-start w-full max-w-4xl">
      <.dialog id="dialog-style-semantic-default" modal>
        <:trigger>Open (default)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-semantic-accent" semantic="accent" modal>
        <:trigger>Open (accent)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-semantic-brand" semantic="brand" modal>
        <:trigger>Open (brand)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-semantic-alert" semantic="alert" modal>
        <:trigger>Open (alert)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-semantic-info" semantic="info" modal>
        <:trigger>Open (info)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-semantic-success" semantic="success" modal>
        <:trigger>Open (success)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_size_code do
    join_snippets([
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(size: "sm"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(size: "md"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(size: "lg"),
      E2eWeb.AuthoringSnippet.dialog_modal_snippets(size: "xl")
    ])
  end

  defp join_snippets(snippets) when is_list(snippets) do
    Enum.reduce(snippets, %{attr: "", class: ""}, fn %{attr: attr, class: class}, acc ->
      %{
        attr: String.trim(acc.attr <> "\n" <> attr),
        class: String.trim(acc.class <> "\n" <> class)
      }
    end)
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-sm" size="sm" modal>
        <:trigger>Open (sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-md" size="md" modal>
        <:trigger>Open (md)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-lg" size="lg" modal>
        <:trigger>Open (lg)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-xl" size="xl" modal>
        <:trigger>Open (xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_text_code do
    ~S"""
    <.dialog text="sm" modal>
      <:trigger>Open (text-sm)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog text="xl" modal>
      <:trigger>Open (text-xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog text="2xl" modal>
      <:trigger>Open (text-2xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog text="4xl" modal>
      <:trigger>Open (text-4xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_text_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-text-sm" text="sm" modal>
        <:trigger>Open (text-sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-xl" text="xl" modal>
        <:trigger>Open (text-xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-2xl" text="2xl" modal>
        <:trigger>Open (text-2xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-text-4xl" text="4xl" modal>
        <:trigger>Open (text-4xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.dialog  radius="none" modal>
      <:trigger>Open (rounded-none)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog  radius="sm" modal>
      <:trigger>Open (rounded-sm)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog  radius="md" modal>
      <:trigger>Open (rounded-md)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog  radius="lg" modal>
      <:trigger>Open (rounded-lg)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog  radius="xl" modal>
      <:trigger>Open (rounded-xl)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    <.dialog  radius="full" modal>
      <:trigger>Open (rounded-full)</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-rounded-none" radius="none" modal>
        <:trigger>Open (rounded-none)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-sm" radius="sm" modal>
        <:trigger>Open (rounded-sm)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-md" radius="md" modal>
        <:trigger>Open (rounded-md)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-lg" radius="lg" modal>
        <:trigger>Open (rounded-lg)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-xl" radius="xl" modal>
        <:trigger>Open (rounded-xl)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-full" radius="full" modal>
        <:trigger>Open (rounded-full)</:trigger>
        <:title>Lorem ipsum dolor sit amet</:title>
        <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
        <:content>
          <p>
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
          </p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_sidebar_code do
    ~S"""
    <.dialog as="side" side="start" modal>
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content class="p-4"><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_sidebar_example(assigns) do
    ~H"""
    <.dialog id="dialog-style-sidebar" as="side" side="start" modal>
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content class="p-4">
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        </p>
      </:content>
      <:close_trigger><.heroicon name="hero-x-mark" /></:close_trigger>
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

  def patterns_controlled_heex do
    ~S"""
    <.dialog
      id="patterns-dialog-controlled"
       
      controlled
      open={@open}
      on_open_change="patterns_dialog_open_changed"
    >
      <:trigger>Open</:trigger>
      <:content>
        <p>LiveView owns open state.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def patterns_controlled_elixir do
    ~S'''
    defmodule MyAppWeb.DialogPatternsLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        {:ok, assign(socket, :open, false)}
      end

      def handle_event("patterns_dialog_open_changed", %{"open" => open}, socket) do
        {:noreply, assign(socket, :open, open)}
      end

      def render(assigns) do
        ~H"""
        <.dialog
          id="patterns-dialog-controlled"
           
          controlled
          open={@open}
          on_open_change="patterns_dialog_open_changed"
        >
          <:trigger>Open</:trigger>
          <:content>
            <p>LiveView owns open state.</p>
          </:content>
          <:close_trigger>
            <.heroicon name="hero-x-mark" />
          </:close_trigger>
        </.dialog>
        """
      end
    end
    '''
  end

  def patterns_alert_heex do
    ~S"""
    <.dialog
      id="patterns-dialog-alert"
       
      role="alertdialog"
     modal
      close_on_interact_outside={false}
      initial_focus="patterns-dialog-alert-cancel"
      final_focus="dialog:patterns-dialog-alert:trigger"
    >
      <:trigger>Delete item</:trigger>
      <:title>Delete this item?</:title>
      <:description>This action cannot be undone.</:description>
      <:content>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action id="patterns-dialog-alert-cancel" phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} size="sm" variant="ghost">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} size="sm" semantic="alert">
            Delete
          </.action>
        </div>
      </:content>
    </.dialog>
    """
  end

  def patterns_alert_elixir do
    ~S'''
    <.dialog
      id="patterns-dialog-alert"
       
      role="alertdialog"
     modal
      close_on_interact_outside={false}
      initial_focus="patterns-dialog-alert-cancel"
      final_focus="dialog:patterns-dialog-alert:trigger"
    >
      <:trigger>Delete item</:trigger>
      <:title>Delete this item?</:title>
      <:description>This action cannot be undone.</:description>
      <:content>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action id="patterns-dialog-alert-cancel" phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} size="sm" variant="ghost">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} size="sm" semantic="alert">
            Delete
          </.action>
        </div>
      </:content>
    </.dialog>
    '''
  end
end
