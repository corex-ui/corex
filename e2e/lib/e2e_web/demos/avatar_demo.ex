defmodule E2eWeb.Demos.AvatarDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  alias Phoenix.LiveView.JS

  def events_server_heex do
    ~S"""
    <form phx-change="avatar_events_changed">
      <.native_input type="url" name="avatar_src" value="https://corex-ui.com/images/avatar.png" class="native-input native-input--sm w-full">
        <:label>Image URL</:label>
      </.native_input>
    </form>

    <.avatar
      
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
      <.avatar src="" >
        <:fallback>JD</:fallback>
      </.avatar>
      <.avatar src="/images/avatar.png" alt="Avatar" >
        <:fallback>?</:fallback>
      </.avatar>
      <.avatar src="/images/favicon.ico" alt="Favicon" >
        <:fallback>FX</:fallback>
      </.avatar>
    </div>
    """
  end

  def minimal_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row gap-2">
      <.avatar id="avatar-fallback" src="">
        <:fallback>JD</:fallback>
      </.avatar>
      <.avatar id="avatar-cat" src="/images/avatar.png" alt="Avatar">
        <:fallback>?</:fallback>
      </.avatar>
      <.avatar id="avatar-favicon" src="/images/favicon.ico" alt="Favicon">
        <:fallback>FX</:fallback>
      </.avatar>
    </div>
    """
  end

  def anatomy_fallback_code do
    ~S"""
    <.avatar src="" >
      <:fallback>
        <span class="font-semibold">AB</span>
      </:fallback>
    </.avatar>
    """
  end

  def anatomy_fallback_example(assigns) do
    _ = assigns

    ~H"""
    <.avatar id="avatar-anatomy-fallback" src="">
      <:fallback>
        <span class="font-semibold">AB</span>
      </:fallback>
    </.avatar>
    """
  end

  def anatomy_value_code do
    ~S"""
    <.avatar src="https://corex-ui.com/images/avatar.png" alt="" >
      <:value :let={src}>
        {if src, do: "IMG", else: " - "}
      </:value>
    </.avatar>
    """
  end

  def anatomy_pending_code do
    ~S"""
    <.avatar pending >
      <:loading><span class="text-sm">Loading</span></:loading>
    </.avatar>
    """
  end

  def anatomy_value_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row gap-4 items-center">
      <.avatar id="avatar-anatomy-value-empty" src="">
        <:value :let={src}>
          {if src, do: "IMG", else: " - "}
        </:value>
      </.avatar>
      <.avatar
        id="avatar-anatomy-value-img"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
      >
        <:value :let={src}>
          {if src, do: "IMG", else: " - "}
        </:value>
      </.avatar>
    </div>
    """
  end

  def anatomy_custom_slots_code do
    ~S"""
    <div class="flex flex-col gap-8 items-center w-full">
      <div class="flex flex-col gap-2 items-center w-full">
        <.avatar src="" >
          <:fallback>
            <span class="font-semibold">AB</span>
          </:fallback>
        </.avatar>
      </div>
      <div class="flex flex-col gap-2 items-center w-full">
        <div class="layout__row gap-4 items-center">
          <.avatar src="" >
            <:value :let={src}>
              {if src, do: "IMG", else: " - "}
            </:value>
          </.avatar>
          <.avatar src="https://example.com/photo.jpg" >
            <:value :let={src}>
              {if src, do: "IMG", else: " - "}
            </:value>
          </.avatar>
        </div>
      </div>
    </div>
    """
  end

  def anatomy_custom_slots_example(assigns) do
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

  def styling_semantic_example(assigns) do
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

  def styling_semantic_code do
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
        size="sm"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
      >
        <:fallback>SM</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-md"
        size="md"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
      >
        <:fallback>MD</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-lg"
        size="lg"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
      >
        <:fallback>LG</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-xl"
        size="xl"
        src="https://corex-ui.com/images/avatar.png"
        alt=""
      >
        <:fallback>XL</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.avatar src="https://corex-ui.com/images/avatar.png" size="sm">
      <:fallback>SM</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" size="md">
      <:fallback>MD</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" size="lg">
      <:fallback>LG</:fallback>
    </.avatar>
    <.avatar src="https://corex-ui.com/images/avatar.png" size="xl">
      <:fallback>XL</:fallback>
    </.avatar>
    """
  end

  @styling_radius_src "https://corex-ui.com/images/avatar.png"

  def styling_radius_example(assigns) do
    assigns = assign(assigns, :rounded_src, @styling_radius_src)

    ~H"""
    <div class="flex flex-wrap gap-4 items-end justify-center">
      <.avatar id="avatar-style-rounded-default" src={@rounded_src} alt="">
        <:fallback>MD</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-none"
        radius="none"
        src={@rounded_src}
        alt=""
      >
        <:fallback>0</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-sm"
        radius="sm"
        src={@rounded_src}
        alt=""
      >
        <:fallback>SM</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-md"
        radius="md"
        src={@rounded_src}
        alt=""
      >
        <:fallback>MD</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-lg"
        radius="lg"
        src={@rounded_src}
        alt=""
      >
        <:fallback>LG</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-xl"
        radius="xl"
        src={@rounded_src}
        alt=""
      >
        <:fallback>XL</:fallback>
      </.avatar>
      <.avatar
        id="avatar-style-rounded-full"
        radius="full"
        src={@rounded_src}
        alt=""
      >
        <:fallback>●</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_radius_code do
    """
    <.avatar src="#{@styling_radius_src}" alt="" >
      <:fallback>MD</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="none">
      <:fallback>0</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="sm">
      <:fallback>SM</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="md">
      <:fallback>MD</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="lg">
      <:fallback>LG</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="xl">
      <:fallback>XL</:fallback>
    </.avatar>
    <.avatar src="#{@styling_radius_src}" alt="" radius="full">
      <:fallback>●</:fallback>
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
    <.avatar id="api-set-src-client"  src="https://corex-ui.com/images/avatar.png" alt="API demo">
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
    <.avatar id="api-set-src-client-js"  src="" alt="">
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
        size="sm"
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
        size="sm"
      >
        Set alternate
      </.action>
    </div>
    <.avatar id={@id} src="" alt="">
      <:fallback>JS</:fallback>
    </.avatar>
    """
  end

  def api_set_src_server_heex do
    ~S"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/images/avatar.png" size="sm">
        Set primary
      </.action>
      <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/pwa-192x192.png" size="sm">
        Set alternate
      </.action>
    </div>
    <.avatar id="api-set-src-server"  src="https://corex-ui.com/images/avatar.png" alt="API demo">
      <:fallback>?</:fallback>
    </.avatar>
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
      <.action phx-click={@event} phx-value-url={@src_primary} size="sm">
        Set primary
      </.action>
      <.action phx-click={@event} phx-value-url={@src_alt} size="sm">
        Set alternate
      </.action>
    </div>
    <.avatar id={@id} src={@src_primary} alt="API demo">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Avatar.loaded("api-loaded-bind", respond_to: :both)} size="sm">
      Status
    </.action>
    <.avatar id="api-loaded-bind"  src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <.action
      phx-click={Corex.Avatar.loaded("api-loaded-bind", respond_to: :both)}
      size="sm"
    >
      Status
    </.action>
    <.avatar
      id="api-loaded-bind"
      src="https://corex-ui.com/images/avatar.png"
      alt=""
    >
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_js_heex do
    ~S"""
    <.action
      phx-click={
        JS.dispatch("corex:avatar:loaded",
          to: "#api-loaded-js",
          detail: %{respond_to: "both"},
          bubbles: false
        )
      }
      size="sm"
    >
      Status
    </.action>
    <.avatar id="api-loaded-js"  src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_js_js do
    ~S"""
    const el = document.getElementById("api-loaded-js")
    el?.dispatchEvent(
      new CustomEvent("corex:avatar:loaded", {
        detail: { respond_to: "both" },
        bubbles: false
      })
    )
    """
  end

  def api_loaded_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("api-loaded-js")
    el?.dispatchEvent(
      new CustomEvent<{ respond_to: string }>("corex:avatar:loaded", {
        detail: { respond_to: "both" },
        bubbles: false
      })
    )
    """
  end

  def api_loaded_client_js_example(assigns) do
    ~H"""
    <.action
      phx-click={
        JS.dispatch("corex:avatar:loaded",
          to: "##{@id}",
          detail: %{respond_to: "both"},
          bubbles: false
        )
      }
      size="sm"
    >
      Status
    </.action>
    <.avatar id={@id} src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_server_heex do
    ~S"""
    <.action phx-click="api_loaded_server" size="sm">Status</.action>
    <.avatar id="api-loaded-server"  src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_server_elixir do
    ~S"""
    def handle_event("api_loaded_server", _params, socket) do
      {:noreply, Corex.Avatar.loaded(socket, "api-loaded-server", respond_to: :server)}
    end

    def handle_event("avatar_loaded_response", %{"id" => id, "loaded" => loaded}, socket) do
      desc = "#{id}\n#{inspect(loaded)}"

      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "avatar_loaded_response", desc, :info, duration: 5000)}
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
    <.action phx-click={@event_loaded} size="sm">Status</.action>
    <.avatar id={@id} src={@loaded_demo_src} alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_codes do
    %{
      set_src_binding: api_set_src_client_binding_code(),
      set_src_js_heex: api_set_src_client_js_heex(),
      set_src_js: api_set_src_client_js_js(),
      set_src_js_ts: api_set_src_client_js_ts(),
      set_src_server_heex: api_set_src_server_heex(),
      set_src_server_elixir: api_set_src_server_elixir(),
      loaded_binding: api_loaded_client_binding_code(),
      loaded_js_heex: api_loaded_client_js_heex(),
      loaded_js: api_loaded_client_js_js(),
      loaded_js_ts: api_loaded_client_js_ts(),
      loaded_server_heex: api_loaded_server_heex(),
      loaded_server_elixir: api_loaded_server_elixir()
    }
  end
end
