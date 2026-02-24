defmodule E2eWeb.MarqueeLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:marquee_paused, nil)

    {:ok, socket}
  end

  def handle_event("pause", _params, socket) do
    {:noreply, Corex.Marquee.pause(socket, "my-marquee")}
  end

  def handle_event("resume", _params, socket) do
    {:noreply, Corex.Marquee.resume(socket, "my-marquee")}
  end

  def handle_event("toggle_pause", _params, socket) do
    {:noreply, Corex.Marquee.toggle_pause(socket, "my-marquee")}
  end

  def handle_event("on_pause_change", %{"paused" => paused}, socket) do
    {:noreply, assign(socket, :marquee_paused, paused)}
  end

  def handle_event("on_loop_complete", _params, socket) do
    {:noreply, put_flash(socket, :info, "Marquee loop complete")}
  end

  def handle_event("on_complete", _params, socket) do
    {:noreply, put_flash(socket, :info, "Marquee complete")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <div class="layout__row">
        <h1>Marquee</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client API</h3>
      <div class="layout__row">
        <.action phx-click={Corex.Marquee.pause("my-marquee")} class="button button--sm">
          Pause
        </.action>
        <.action phx-click={Corex.Marquee.resume("my-marquee")} class="button button--sm">
          Resume
        </.action>
        <.action phx-click={Corex.Marquee.toggle_pause("my-marquee")} class="button button--sm">
          Toggle pause
        </.action>
      </div>
      <h3>Server API</h3>
      <div class="layout__row">
        <.action phx-click="pause" class="button button--sm">Pause</.action>
        <.action phx-click="resume" class="button button--sm">Resume</.action>
        <.action phx-click="toggle_pause" class="button button--sm">Toggle pause</.action>
      </div>
      <div :if={@marquee_paused != nil} class="layout__row">
        <p>Paused: <code>{inspect(@marquee_paused)}</code></p>
      </div>
      <.marquee
        id="my-marquee"
        class="marquee"
        on_pause_change="on_pause_change"
        on_loop_complete="on_loop_complete"
        on_complete="on_complete"
        loop_count={3}
        items={[
          %{name: "Apple", logo: "🍎"},
          %{name: "Banana", logo: "🍌"},
          %{name: "Cherry", logo: "🍒"},
          %{name: "Grape", logo: "🍇"},
          %{name: "Lemon", logo: "🍋"}
        ]}
        duration={20}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={%{item: item}}>
          <span>{item.logo}</span>
          <span>{item.name}</span>
        </:item>
      </.marquee>

      <h3>With components</h3>
      <.marquee
        id="marquee-icons"
        class="marquee"
        items={[
          %{name: "Home", icon: "hero-home"},
          %{name: "User", icon: "hero-user"},
          %{name: "Cog", icon: "hero-cog-6-tooth"},
          %{name: "Heart", icon: "hero-heart"},
          %{name: "Star", icon: "hero-star"}
        ]}
        duration={25}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={%{item: item}}>
          <.icon name={item.icon} />
          <span>{item.name}</span>
        </:item>
      </.marquee>

      <h3>With files</h3>
      <.marquee
        id="marquee-tech"
        class="marquee"
        items={[
          %{name: "Phoenix", src: ~p"/images/tech/phoenix.svg"},
          %{name: "Elixir", src: ~p"/images/tech/elixir.svg"},
          %{name: "HTML5", src: ~p"/images/tech/html5.svg"},
          %{name: "CSS", src: ~p"/images/tech/css.svg"},
          %{name: "JavaScript", src: ~p"/images/tech/javascript.svg"},
          %{name: "TypeScript", src: ~p"/images/tech/typescript.svg"},
          %{name: "Tailwind", src: ~p"/images/tech/tailwind.svg"},
          %{name: "Figma", src: ~p"/images/tech/figma.svg"}
        ]}
        duration={30}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={%{item: item}}>
          <img src={item.src} alt={item.name} class="w-10 mx-auto" />
          <p>{item.name}</p>
        </:item>
      </.marquee>
    </Layouts.app>
    """
  end
end
