defmodule E2eWeb.Demos.AvatarDemo do
  use E2eWeb, :html

  alias Phoenix.LiveView.JS

  def events_server_heex do
    ~S"""
    <form phx-change="avatar_events_changed">
      <.native_input type="url" name="avatar_src" value="https://corex-ui.com/images/avatar.png" class="native-input native-input--sm w-full">
        <:label>Image URL</:label>
      </.native_input>
    </form>

    <.avatar
      class="avatar"
      src={@avatar_src}
      alt="Avatar"
      on_status_change="avatar_status_changed"
      on_status_change_client="avatar-status-changed"
    >
      <:fallback>JD</:fallback>
    </.avatar>
    """
  end

  def minimal_code do
    ~S"""
    <div class="layout__row gap-2">
      <.avatar src="" class="avatar">
        <:fallback>JD</:fallback>
      </.avatar>
      <.avatar src="/images/avatar.png" alt="Avatar" class="avatar">
        <:fallback>?</:fallback>
      </.avatar>
      <.avatar src="/images/favicon.ico" alt="Favicon" class="avatar">
        <:fallback>FX</:fallback>
      </.avatar>
    </div>
    """
  end

  def minimal_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row gap-2">
      <.avatar id="avatar-fallback" src="" class="avatar">
        <:fallback>JD</:fallback>
      </.avatar>
      <.avatar id="avatar-cat" src="/images/avatar.png" alt="Avatar" class="avatar">
        <:fallback>?</:fallback>
      </.avatar>
      <.avatar id="avatar-favicon" src="/images/favicon.ico" alt="Favicon" class="avatar">
        <:fallback>FX</:fallback>
      </.avatar>
    </div>
    """
  end

  def anatomy_fallback_code do
    ~S"""
    <.avatar src="" class="avatar">
      <:fallback>
        <span class="font-semibold">AB</span>
      </:fallback>
    </.avatar>
    """
  end

  def anatomy_fallback_example(assigns) do
    _ = assigns

    ~H"""
    <.avatar id="avatar-anatomy-fallback" src="" class="avatar">
      <:fallback>
        <span class="font-semibold">AB</span>
      </:fallback>
    </.avatar>
    """
  end

  def anatomy_value_code do
    ~S"""
    <.avatar src="https://example.com/photo.jpg" class="avatar">
      <:value :let={src}>
        {if src, do: "IMG", else: " - "}
      </:value>
    </.avatar>
    """
  end

  def anatomy_value_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row gap-4 items-center">
      <.avatar id="avatar-anatomy-value-empty" src="" class="avatar">
        <:value :let={src}>
          {if src, do: "IMG", else: " - "}
        </:value>
      </.avatar>
      <.avatar
        id="avatar-anatomy-value-img"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
        class="avatar"
      >
        <:value :let={src}>
          {if src, do: "IMG", else: " - "}
        </:value>
      </.avatar>
    </div>
    """
  end

  def anatomy_custom_slots_code_tabs do
    [
      %{
        value: "fallback",
        label: "Fallback",
        language: :heex,
        code: anatomy_fallback_code()
      },
      %{
        value: "value",
        label: "Value",
        language: :heex,
        code: anatomy_value_code()
      }
    ]
  end

  def anatomy_custom_slots_preview(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-8 items-center w-full">
      <div class="flex flex-col gap-2 items-center w-full">
        {anatomy_fallback_example(assigns)}
      </div>
      <div class="flex flex-col gap-2 items-center w-full">
        {anatomy_value_example(assigns)}
      </div>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-end justify-center">
      <.avatar id="avatar-style-accent" src="" class="avatar avatar--accent">
        <:fallback>A</:fallback>
      </.avatar>
      <.avatar id="avatar-style-brand" src="" class="avatar avatar--brand">
        <:fallback>B</:fallback>
      </.avatar>
      <.avatar id="avatar-style-alert" src="" class="avatar avatar--alert">
        <:fallback>C</:fallback>
      </.avatar>
      <.avatar id="avatar-style-info" src="" class="avatar avatar--info">
        <:fallback>D</:fallback>
      </.avatar>
      <.avatar id="avatar-style-success" src="" class="avatar avatar--success">
        <:fallback>E</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.avatar src="" class="avatar avatar--accent">
      <:fallback>A</:fallback>
    </.avatar>
    <.avatar src="" class="avatar avatar--brand">
      <:fallback>B</:fallback>
    </.avatar>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-end justify-center">
      <.avatar
        id="avatar-style-sm"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
        class="avatar avatar--sm"
      >
        <:fallback>SM</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-md"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
        class="avatar avatar--md"
      >
        <:fallback>MD</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-lg"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
        class="avatar avatar--lg"
      >
        <:fallback>LG</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-xl"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
        class="avatar avatar--xl"
      >
        <:fallback>XL</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.avatar src="https://corex-ui.com/images/avatar.png" class="avatar avatar--sm">
      <:fallback>SM</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" class="avatar avatar--md">
      <:fallback>MD</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" class="avatar avatar--lg">
      <:fallback>LG</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" class="avatar avatar--xl">
      <:fallback>XL</:fallback>
    </.avatar>
    """
  end

  def api_set_src_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Avatar.set_src("api-set-src-client", "https://corex-ui.com/images/avatar.png")}>
      Set primary
    </.action>
    <.action phx-click={Corex.Avatar.set_src("api-set-src-client", "https://corex-ui.com/pwa-192x192.png")}>
      Set alternate
    </.action>
    <.avatar id="api-set-src-client" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="API demo">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_set_src_client_js_heex do
    ~S"""
    <.action
      phx-click={
        JS.dispatch("corex:avatar:set-src",
          to: "#api-set-src-client-js",
          detail: %{src: "https://corex-ui.com/images/avatar.png"},
          bubbles: false
        )
      }
    >
      Set primary
    </.action>
    <.action
      phx-click={
        JS.dispatch("corex:avatar:set-src",
          to: "#api-set-src-client-js",
          detail: %{src: "https://corex-ui.com/pwa-192x192.png"},
          bubbles: false
        )
      }
    >
      Set alternate
    </.action>
    <.avatar id="api-set-src-client-js" class="avatar" src="" alt="">
      <:fallback>JS</:fallback>
    </.avatar>
    """
  end

  def api_set_src_client_js_js do
    ~S"""
    const el = document.getElementById("api-set-src-client-js")
    el?.dispatchEvent(
      new CustomEvent("corex:avatar:set-src", {
        detail: { src: "https://corex-ui.com/images/avatar.png" },
        bubbles: false
      })
    )
    el?.dispatchEvent(
      new CustomEvent("corex:avatar:set-src", {
        detail: { src: "https://corex-ui.com/pwa-192x192.png" },
        bubbles: false
      })
    )
    """
  end

  def api_set_src_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("api-set-src-client-js")
    el?.dispatchEvent(
      new CustomEvent<{ src: string }>("corex:avatar:set-src", {
        detail: { src: "https://corex-ui.com/images/avatar.png" },
        bubbles: false
      })
    )
    el?.dispatchEvent(
      new CustomEvent<{ src: string }>("corex:avatar:set-src", {
        detail: { src: "https://corex-ui.com/pwa-192x192.png" },
        bubbles: false
      })
    )
    """
  end

  def api_set_src_client_js_example(assigns) do
    assigns =
      assigns
      |> Phoenix.Component.assign(:src_primary, "https://corex-ui.com/images/avatar.png")
      |> Phoenix.Component.assign(:src_alt, "https://corex-ui.com/pwa-192x192.png")

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:avatar:set-src",
            to: "##{@id}",
            detail: %{src: @src_primary},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set primary
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:avatar:set-src",
            to: "##{@id}",
            detail: %{src: @src_alt},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set alternate
      </.action>
    </div>
    <.avatar id={@id} class="avatar" src="" alt="">
      <:fallback>JS</:fallback>
    </.avatar>
    """
  end

  def api_set_src_server_heex do
    ~S"""
    <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/images/avatar.png" class="button button--sm">
      Set primary
    </.action>
    <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/pwa-192x192.png" class="button button--sm">
      Set alternate
    </.action>
    """
  end

  def api_set_src_server_elixir do
    ~S"""
    def handle_event("api_set_src_server", %{"url" => url}, socket) do
      {:noreply, Corex.Avatar.set_src(socket, "api-set-src-server", url)}
    end
    """
  end

  def api_set_src_server_example(assigns) do
    assigns =
      assigns
      |> Phoenix.Component.assign(:src_primary, "https://corex-ui.com/images/avatar.png")
      |> Phoenix.Component.assign(
        :src_alt,
        "https://corex-ui.com/pwa-192x192.png"
      )

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} phx-value-url={@src_primary} class="button button--sm">
        Set primary
      </.action>
      <.action phx-click={@event} phx-value-url={@src_alt} class="button button--sm">
        Set alternate
      </.action>
    </div>
    <.avatar id={@id} class="avatar" src={@src_primary} alt="API demo">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_server_heex do
    ~S"""
    <.action phx-click="api_loaded_server">Loaded</.action>
    <.action phx-click="api_loaded_server_client_only">Loaded (client only)</.action>
    <.avatar id="api-loaded-server" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_server_elixir do
    ~S"""
    def handle_event("api_loaded_server", _params, socket) do
      {:noreply, Corex.Avatar.loaded(socket, "api-loaded-server")}
    end

    def handle_event("api_loaded_server_client_only", _params, socket) do
      {:noreply, Corex.Avatar.loaded(socket, "api-loaded-server", respond_to: :client)}
    end

    def handle_event("avatar_loaded_response", %{"id" => id, "loaded" => loaded}, socket) do
      desc = "#{id}\n#{inspect(loaded)}"

      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "avatar_loaded_response", desc, :info, duration: 5000)}
    end

    def handle_event("avatar_loaded_dom", %{"id" => id, "loaded" => loaded}, socket) do
      desc = "avatar-loaded (client)\n#{id}\n#{inspect(loaded)}"

      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "avatar_loaded_dom", desc, :info, duration: 5000)}
    end
    """
  end

  def api_loaded_server_example(assigns) do
    assigns =
      Phoenix.Component.assign(
        assigns,
        :loaded_demo_src,
        "https://corex-ui.com/images/avatar.png"
      )

    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event_loaded} class="button button--sm">Loaded</.action>
      <.action phx-click={@event_loaded_client_only} class="button button--sm">
        Loaded (client only)
      </.action>
    </div>
    <.avatar id={@id} class="avatar" src={@loaded_demo_src} alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end
end
