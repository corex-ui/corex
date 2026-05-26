defmodule E2eWeb.AvatarPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @default_avatar_src "https://corex-ui.com/images/avatar.png"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:avatar_src, @default_avatar_src)
      |> assign(:avatar_alt, "Avatar")
      |> assign(:avatar_fallback, "JD")

    {:ok, socket}
  end

  @impl true
  def handle_event("avatar_play_changed", params, socket) do
    src = string_param(params, "avatar_src", socket.assigns.avatar_src)
    alt = string_param(params, "avatar_alt", socket.assigns.avatar_alt)
    fallback = string_param(params, "avatar_fallback", socket.assigns.avatar_fallback)

    {:noreply,
     socket
     |> assign(:avatar_src, src)
     |> assign(:avatar_alt, alt)
     |> assign(:avatar_fallback, fallback)}
  end

  defp string_param(params, key, default) do
    case Map.get(params, key) do
      v when is_binary(v) -> v
      _ -> default
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground path={@path} title="Avatar · Playground" heading_class="layout-heading">
        <:controls>
          <form
            phx-change="avatar_play_changed"
            id="avatar-play-form"
            class="flex flex-col gap-4 w-full max-w-md"
          >
            <.native_input
              type="url"
              id="avatar-play-src"
              name="avatar_src"
              value={@avatar_src}
              class="native-input native-input--sm w-full"
            >
              <:label>Image URL</:label>
            </.native_input>

            <.native_input
              type="text"
              id="avatar-play-alt"
              name="avatar_alt"
              value={@avatar_alt}
              class="native-input native-input--sm w-full"
            >
              <:label>Alt text</:label>
            </.native_input>

            <.native_input
              type="text"
              id="avatar-play-fallback"
              name="avatar_fallback"
              value={@avatar_fallback}
              class="native-input native-input--sm w-full"
            >
              <:label>Fallback text</:label>
            </.native_input>
          </form>
        </:controls>
        <:canvas>
          <.avatar
            id="avatar-playground"
            class="avatar"
            src={@avatar_src}
            alt={@avatar_alt}
          >
            <:fallback>{@avatar_fallback}</:fallback>
          </.avatar>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
