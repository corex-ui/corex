defmodule E2eWeb.Demos.DialogDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
    <.dialog id="dialog-anatomy-actions" class="dialog">
      <:trigger>Open Dialog</:trigger>
      <:title>Confirm</:title>
      <:description>Choose an action to continue.</:description>
      <:content>
        <p>Are you sure you want to continue?</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button ui-size-sm">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)} class="button ui-size-sm">
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
            class="button ui-size-sm"
          >
            Cancel
          </.action>
          <.action
            phx-click={Corex.Dialog.set_open("dialog-anatomy-actions", false)}
            class="button ui-size-sm"
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} class="button ui-size-sm">
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
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Dialog.set_open("dialog-api", true)} class="button ui-size-sm">
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
          <.action phx-click={Corex.Dialog.set_open("dialog-api", false)} class="button ui-size-sm">
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
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
            to: "#dialog-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
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
            class="button ui-size-sm"
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
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:dialog:set-open",
            to: "#dialog-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
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
            class="button ui-size-sm"
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="dialog_api_open" class="button ui-size-sm">Open</.action>
    </div>

    <.dialog id="dialog-api-server" class="dialog">
      <:trigger>Open</:trigger>
      <:title>Lorem ipsum dolor sit amet</:title>
      <:description>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</:description>
      <:content>
        <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
        <div class="flex flex-wrap justify-end gap-2 mt-4">
          <.action phx-click="dialog_api_close" class="button ui-size-sm">Close</.action>
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
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="dialog_api_open" class="button ui-size-sm">Open</.action>
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
          <.action phx-click="dialog_api_close" class="button ui-size-sm">Close</.action>
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

  def styling_color_code do
    """
    <.dialog class="dialog" modal>
      <:trigger>Open default</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-accent" modal>
      <:trigger>Open accent</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-brand" modal>
      <:trigger>Open brand</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-alert" modal>
      <:trigger>Open alert</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-info" modal>
      <:trigger>Open info</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-success" modal>
      <:trigger>Open success</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-color-default" class="dialog" modal>
        <:trigger>Open default</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-color-accent" class="dialog ui-accent" modal>
        <:trigger>Open accent</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-color-brand" class="dialog ui-brand" modal>
        <:trigger>Open brand</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-color-alert" class="dialog ui-alert" modal>
        <:trigger>Open alert</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-color-info" class="dialog ui-info" modal>
        <:trigger>Open info</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-color-success" class="dialog ui-success" modal>
        <:trigger>Open success</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_variant_code do
    """
    <.dialog class="dialog" modal>
      <:trigger>Subtle (default)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-solid" modal>
      <:trigger>Solid</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>

    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-variant-subtle" class="dialog" modal>
        <:trigger>Subtle (default)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-variant-solid" class="dialog ui-solid" modal>
        <:trigger>Solid</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("dialog"),
        variant <- DemoScales.styling_variant_axis_steps("dialog") do
      class = DemoScales.join_matrix_modifiers("dialog", semantic.modifier, variant.modifier)

      """
      <.dialog class="#{class}" modal>
        <:trigger>#{semantic.label}</:trigger>
        <:title>#{style_dialog_title()}</:title>
        <:description>#{style_dialog_description()}</:description>
        <:content><p>#{style_dialog_body()}</p></:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("dialog"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("dialog"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.dialog
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("dialog", semantic.modifier, variant.modifier)}
            modal
          >
            <:trigger>{semantic.label}</:trigger>
            <:title>{style_dialog_title()}</:title>
            <:description>{style_dialog_description()}</:description>
            <:content>
              <p>{style_dialog_body()}</p>
            </:content>
            <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
          </.dialog>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    """
    <.dialog class="dialog ui-size-sm" modal>
      <:trigger>Open (sm)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-size-md" modal>
      <:trigger>Open (md)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-size-lg" modal>
      <:trigger>Open (lg)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-size-xl" modal>
      <:trigger>Open (xl)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-sm" class="dialog ui-size-sm" modal>
        <:trigger>Open (sm)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-md" class="dialog ui-size-md" modal>
        <:trigger>Open (md)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-lg" class="dialog ui-size-lg" modal>
        <:trigger>Open (lg)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-xl" class="dialog ui-size-xl" modal>
        <:trigger>Open (xl)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_radius_code do
    """
    <.dialog class="dialog ui-rounded-none" modal>
      <:trigger>Open (rounded-none)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-rounded-sm" modal>
      <:trigger>Open (rounded-sm)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-rounded-md" modal>
      <:trigger>Open (rounded-md)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-rounded-lg" modal>
      <:trigger>Open (rounded-lg)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-rounded-xl" modal>
      <:trigger>Open (rounded-xl)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    <.dialog class="dialog ui-rounded-full" modal>
      <:trigger>Open (rounded-full)</:trigger>
      <:title>#{style_dialog_title()}</:title>
      <:description>#{style_dialog_description()}</:description>
      <:content><p>#{style_dialog_body()}</p></:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-2xl">
      <.dialog id="dialog-style-rounded-none" class="dialog ui-rounded-none" modal>
        <:trigger>Open (rounded-none)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-sm" class="dialog ui-rounded-sm" modal>
        <:trigger>Open (rounded-sm)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-md" class="dialog ui-rounded-md" modal>
        <:trigger>Open (rounded-md)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-lg" class="dialog ui-rounded-lg" modal>
        <:trigger>Open (rounded-lg)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-xl" class="dialog ui-rounded-xl" modal>
        <:trigger>Open (rounded-xl)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
      <.dialog id="dialog-style-rounded-full" class="dialog ui-rounded-full" modal>
        <:trigger>Open (rounded-full)</:trigger>
        <:title>{style_dialog_title()}</:title>
        <:description>{style_dialog_description()}</:description>
        <:content>
          <p>{style_dialog_body()}</p>
        </:content>
        <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
      </.dialog>
    </div>
    """
  end

  def styling_sidebar_code do
    """
    <.dialog class="dialog dialog--side" modal>
      <:trigger>Open</:trigger>
      <:title>#{style_dialog_sidebar_title()}</:title>
      <:description>#{style_dialog_sidebar_description()}</:description>
      <:content>
        <p>#{style_dialog_sidebar_body()}</p>
      </:content>
      <:close_trigger><.heroicon name="hero-x-mark" class="icon" /></:close_trigger>
    </.dialog>
    """
  end

  def styling_sidebar_example(assigns) do
    ~H"""
    <.dialog id="dialog-style-sidebar" class="dialog dialog--side" modal>
      <:trigger>Open</:trigger>
      <:title>{style_dialog_sidebar_title()}</:title>
      <:description>{style_dialog_sidebar_description()}</:description>
      <:content>
        <p>{style_dialog_sidebar_body()}</p>
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

  def patterns_controlled_heex do
    ~S"""
    <.dialog
      id="patterns-dialog-controlled"
      class="dialog"
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
          class="dialog"
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
      class="dialog"
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
          <.action id="patterns-dialog-alert-cancel" phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} class="button ui-size-sm">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} class="button ui-size-sm ui-alert">
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
      class="dialog"
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
          <.action id="patterns-dialog-alert-cancel" phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} class="button ui-size-sm">
            Cancel
          </.action>
          <.action phx-click={Corex.Dialog.set_open("patterns-dialog-alert", false)} class="button ui-size-sm ui-alert">
            Delete
          </.action>
        </div>
      </:content>
    </.dialog>
    '''
  end

  defp style_dialog_title, do: "Update profile"

  defp style_dialog_description, do: "Change how your name appears across the app."

  defp style_dialog_body,
    do: "Your display name is shown on comments, mentions, and shared documents."

  defp style_dialog_sidebar_title, do: "Filters"

  defp style_dialog_sidebar_description, do: "Narrow results by category, date, or status."

  defp style_dialog_sidebar_body,
    do: "Applied filters update the list immediately. Clear all to reset."
end
