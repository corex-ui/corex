defmodule E2eWeb.Demos.AvatarDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales
  alias Phoenix.LiveView.JS

  def events_server_heex do
    ~S"""
    <form phx-change="avatar_events_changed">
      <.native_input type="url" name="avatar_src" value="https://corex-ui.com/images/avatar.png" class="native-input ui-size-sm w-full">
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
    <div class="flex flex-wrap items-center gap-space">
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
    <div class="flex flex-wrap items-center gap-space">
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
    <.avatar src="https://corex-ui.com/images/avatar.png" alt="" class="avatar">
      <:value :let={src}>
        {if src, do: "IMG", else: " - "}
      </:value>
    </.avatar>
    """
  end

  def anatomy_pending_code do
    ~S"""
    <.avatar pending class="avatar">
      <:loading><span class="text-sm">Loading</span></:loading>
    </.avatar>
    """
  end

  def anatomy_value_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-4">
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

  def anatomy_custom_slots_code do
    ~S"""
    <div class="flex flex-col gap-8 items-center w-full">
      <div class="flex flex-col gap-2 items-center w-full">
        <.avatar src="" class="avatar">
          <:fallback>
            <span class="font-semibold">AB</span>
          </:fallback>
        </.avatar>
      </div>
      <div class="flex flex-col gap-2 items-center w-full">
        <div class="flex flex-wrap items-center gap-space gap-4">
          <.avatar src="" class="avatar">
            <:value :let={src}>
              {if src, do: "IMG", else: " - "}
            </:value>
          </.avatar>
          <.avatar src="https://example.com/photo.jpg" class="avatar">
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

  def styling_color_code do
    ~S"""
    <.avatar class="avatar">
      <:fallback>DF</:fallback>
    </.avatar>
    <.avatar class="avatar ui-accent">
      <:fallback>AC</:fallback>
    </.avatar>
    <.avatar class="avatar ui-brand">
      <:fallback>BR</:fallback>
    </.avatar>
    <.avatar class="avatar ui-alert">
      <:fallback>AL</:fallback>
    </.avatar>
    <.avatar class="avatar ui-info">
      <:fallback>IN</:fallback>
    </.avatar>
    <.avatar class="avatar ui-success">
      <:fallback>SU</:fallback>
    </.avatar>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.avatar id="avatar-style-default" class="avatar">
        <:fallback>DF</:fallback>
      </.avatar>
      <.avatar id="avatar-style-accent" class="avatar ui-accent">
        <:fallback>AC</:fallback>
      </.avatar>
      <.avatar id="avatar-style-brand" class="avatar ui-brand">
        <:fallback>BR</:fallback>
      </.avatar>
      <.avatar id="avatar-style-alert" class="avatar ui-alert">
        <:fallback>AL</:fallback>
      </.avatar>
      <.avatar id="avatar-style-info" class="avatar ui-info">
        <:fallback>IN</:fallback>
      </.avatar>
      <.avatar id="avatar-style-success" class="avatar ui-success">
        <:fallback>SU</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-end gap-space">
      <.avatar id="avatar-style-sm" class="avatar ui-size-sm">
        <:fallback>Sm</:fallback>
      </.avatar>
      <.avatar id="avatar-style-md" class="avatar ui-size-md">
        <:fallback>Md</:fallback>
      </.avatar>
      <.avatar id="avatar-style-lg" class="avatar ui-size-lg">
        <:fallback>Lg</:fallback>
      </.avatar>
      <.avatar id="avatar-style-xl" class="avatar ui-size-xl">
        <:fallback>Xl</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.avatar class="avatar">
      <:fallback>Su</:fallback>
    </.avatar>
    <.avatar class="avatar ui-solid">
      <:fallback>So</:fallback>
    </.avatar>
    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.avatar id="avatar-style-variant-subtle" class="avatar">
        <:fallback>Su</:fallback>
      </.avatar>
      <.avatar id="avatar-style-variant-solid" class="avatar ui-solid">
        <:fallback>So</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("avatar"),
        variant <- styling_variant_axis_steps() do
      class = DemoScales.join_matrix_modifiers("avatar", semantic.modifier, variant.modifier)

      ~s(<.avatar class="#{class}">
        <:fallback>#{avatar_glyph(semantic.label)}</:fallback>
      </.avatar>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("avatar"))
      |> assign(:matrix_variants, styling_variant_axis_steps())

    ~H"""
    <div class="w-full grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-space items-end">
      <div :for={semantic <- @matrix_semantics} class="contents">
        <.avatar
          :for={variant <- @matrix_variants}
          class={DemoScales.join_matrix_modifiers("avatar", semantic.modifier, variant.modifier)}
        >
          <:fallback>{avatar_glyph(semantic.label)}</:fallback>
        </.avatar>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.avatar class="avatar ui-size-sm">
      <:fallback>Sm</:fallback>
    </.avatar>
    <.avatar class="avatar ui-size-md">
      <:fallback>Md</:fallback>
    </.avatar>
    <.avatar class="avatar ui-size-lg">
      <:fallback>Lg</:fallback>
    </.avatar>
    <.avatar class="avatar ui-size-xl">
      <:fallback>Xl</:fallback>
    </.avatar>
    """
  end

  def styling_rounded_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-end gap-space">
      <.avatar id="avatar-style-rounded-none" class="avatar ui-rounded-none">
        <:fallback>No</:fallback>
      </.avatar>
      <.avatar id="avatar-style-rounded-sm" class="avatar ui-rounded-sm">
        <:fallback>Sm</:fallback>
      </.avatar>
      <.avatar id="avatar-style-rounded-md" class="avatar ui-rounded-md">
        <:fallback>Md</:fallback>
      </.avatar>
      <.avatar id="avatar-style-rounded-lg" class="avatar ui-rounded-lg">
        <:fallback>Lg</:fallback>
      </.avatar>
      <.avatar id="avatar-style-rounded-xl" class="avatar ui-rounded-xl">
        <:fallback>Xl</:fallback>
      </.avatar>
      <.avatar id="avatar-style-rounded-full" class="avatar ui-rounded-full">
        <:fallback>Fl</:fallback>
      </.avatar>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.avatar class="avatar ui-rounded-none">
      <:fallback>No</:fallback>
    </.avatar>
    <.avatar class="avatar ui-rounded-sm">
      <:fallback>Sm</:fallback>
    </.avatar>
    <.avatar class="avatar ui-rounded-md">
      <:fallback>Md</:fallback>
    </.avatar>
    <.avatar class="avatar ui-rounded-lg">
      <:fallback>Lg</:fallback>
    </.avatar>
    <.avatar class="avatar ui-rounded-xl">
      <:fallback>Xl</:fallback>
    </.avatar>
    <.avatar class="avatar ui-rounded-full">
      <:fallback>Fl</:fallback>
    </.avatar>
    """
  end

  defp styling_variant_axis_steps do
    [
      %{label: "Subtle (default)", modifier: ""},
      %{label: "Solid", modifier: "ui-solid"}
    ]
  end

  defp avatar_glyph(label) when is_binary(label) do
    Map.get(
      %{
        "Default" => "DF",
        "Base" => "BS",
        "Accent" => "AC",
        "Brand" => "BR",
        "Alert" => "AL",
        "Info" => "IN",
        "Success" => "SU",
        "Subtle (default)" => "Su",
        "Solid" => "So",
        "Small" => "Sm",
        "Medium" => "Md",
        "Large" => "Lg",
        "XL" => "Xl",
        "None" => "No",
        "SM" => "Sm",
        "MD" => "Md",
        "LG" => "Lg",
        "Full" => "Fl"
      },
      label,
      String.slice(label, 0, 2)
    )
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
        class="button ui-size-sm"
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
        class="button ui-size-sm"
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
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/images/avatar.png" class="button ui-size-sm">
        Set primary
      </.action>
      <.action phx-click="api_set_src_server" phx-value-url="https://corex-ui.com/pwa-192x192.png" class="button ui-size-sm">
        Set alternate
      </.action>
    </div>
    <.avatar id="api-set-src-server" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="API demo">
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
      <.action phx-click={@event} phx-value-url={@src_primary} class="button ui-size-sm">
        Set primary
      </.action>
      <.action phx-click={@event} phx-value-url={@src_alt} class="button ui-size-sm">
        Set alternate
      </.action>
    </div>
    <.avatar id={@id} class="avatar" src={@src_primary} alt="API demo">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Avatar.loaded("api-loaded-bind", respond_to: :both)} class="button ui-size-sm">
      Status
    </.action>
    <.avatar id="api-loaded-bind" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <.action
      phx-click={Corex.Avatar.loaded("api-loaded-bind", respond_to: :both)}
      class="button ui-size-sm"
    >
      Status
    </.action>
    <.avatar
      id="api-loaded-bind"
      class="avatar"
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
      class="button ui-size-sm"
    >
      Status
    </.action>
    <.avatar id="api-loaded-js" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="">
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
      class="button ui-size-sm"
    >
      Status
    </.action>
    <.avatar id={@id} class="avatar" src="https://corex-ui.com/images/avatar.png" alt="">
      <:fallback>?</:fallback>
    </.avatar>
    """
  end

  def api_loaded_server_heex do
    ~S"""
    <.action phx-click="api_loaded_server" class="button ui-size-sm">Status</.action>
    <.avatar id="api-loaded-server" class="avatar" src="https://corex-ui.com/images/avatar.png" alt="">
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
    <.action phx-click={@event_loaded} class="button ui-size-sm">Status</.action>
    <.avatar id={@id} class="avatar" src={@loaded_demo_src} alt="">
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
