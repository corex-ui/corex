defmodule E2eWeb.CarouselPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  defp playground_items do
    E2eWeb.Demos.CarouselDemo.gallery_images()
  end

  defp playground_slide_count, do: length(playground_items())

  defp max_slides_per_page(slide_count) when is_integer(slide_count) and slide_count >= 1 do
    max(1, slide_count - 1)
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{orientation: "horizontal", dir: "ltr"}

    socket =
      socket
      |> assign(:loop, false)
      |> assign(:autoplay, false)
      |> assign(:controls, controls)
      |> assign(:spacing_px, 0)
      |> assign(:padding_px, nil)
      |> assign(:slides_per_page, 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("loop_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :loop, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("autoplay_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :autoplay, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  @impl true
  def handle_event("spacing_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :spacing_px, parse_spacing_px(value, socket.assigns.spacing_px))}
  end

  @impl true
  def handle_event("padding_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :padding_px, parse_padding_px(value))}
  end

  @impl true
  def handle_event("slides_per_page_changed", %{"value" => value}, socket) do
    max_n = max_slides_per_page(playground_slide_count())

    n =
      case Integer.parse(to_string(value || "")) do
        {i, _} -> min(max(i, 1), max_n)
        _ -> min(max(socket.assigns.slides_per_page, 1), max_n)
      end

    {:noreply, assign(socket, :slides_per_page, n)}
  end

  defp update_control(socket, "dir", value) when value in ["ltr", "rtl"] do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, "orientation", value) when value in ["horizontal", "vertical"] do
    update(socket, :controls, &%{&1 | orientation: value})
  end

  defp update_control(socket, _id, _value), do: socket

  defp parse_spacing_px(raw, fallback) do
    case Integer.parse(to_string(raw || "")) do
      {n, _} when n >= 0 and n <= 200 -> n
      _ -> fallback
    end
  end

  defp parse_padding_px(raw) do
    s = to_string(raw || "") |> String.trim()

    if s == "" do
      nil
    else
      case Integer.parse(s) do
        {n, _} when n >= 0 and n <= 200 -> n
        _ -> nil
      end
    end
  end

  defp vertical?(%{orientation: "vertical"}), do: true
  defp vertical?(_), do: false

  @impl true
  def render(assigns) do
    slide_count = playground_slide_count()
    max_sp = max_slides_per_page(slide_count)
    slides = min(assigns.slides_per_page, max_sp)

    assigns =
      assigns
      |> assign(:vertical?, vertical?(assigns.controls))
      |> assign(:slides_per_page_max, max_sp)
      |> assign(:slides_per_page, slides)

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground path={@path} title={~t"Carousel · Playground"} heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm toggle--max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label={~t"Vertical orientation"}>
              <.heroicon name="hero-arrows-up-down" />
            </:item>
            <:item value="horizontal" aria_label={~t"Horizontal orientation"}>
              <.heroicon name="hero-arrows-right-left" />
            </:item>
          </.toggle_group>

          <.switch
            size="sm"
            id="loop"
            checked={@loop}
            on_checked_change="loop_changed"
          >
            <:label>Loop</:label>
          </.switch>
          <.switch
            size="sm"
            id="autoplay"
            checked={@autoplay}
            on_checked_change="autoplay_changed"
          >
            <:label>Autoplay</:label>
          </.switch>

          <.number_input
            id="carousel-playground-slides-per-page"
            class="number-input number-input--sm w-4xs"
            value={to_string(@slides_per_page)}
            step={1.0}
            min={1.0}
            max={@slides_per_page_max * 1.0}
            on_value_change="slides_per_page_changed"
          >
            <:label>Slides per page (1–{@slides_per_page_max})</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="carousel-playground-spacing"
            class="number-input number-input--sm w-4xs"
            value={to_string(@spacing_px)}
            step={1.0}
            min={0.0}
            max={200.0}
            on_value_change="spacing_changed"
          >
            <:label>Spacing (px)</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="carousel-playground-padding"
            class="number-input number-input--sm w-4xs"
            value={if(@padding_px, do: to_string(@padding_px), else: "")}
            step={1.0}
            min={0.0}
            max={200.0}
            on_value_change="padding_changed"
          >
            <:label>Padding (px, optional)</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" />
            </:increment_trigger>
          </.number_input>
        </:controls>
        <:canvas>
          <.carousel
            id="carousel-playground"
            items={playground_items()}
            slides_per_page={@slides_per_page}
            loop={@loop}
            autoplay={@autoplay}
            dir={@controls.dir}
            orientation={@controls.orientation}
            spacing={"#{@spacing_px}px"}
            padding={if(@padding_px, do: "#{@padding_px}px", else: nil)}
            class="carousel w-full"
          >
            <:prev_trigger>
              <.heroicon name={if(@vertical?, do: "hero-arrow-up", else: "hero-arrow-left")} />
            </:prev_trigger>
            <:next_trigger>
              <.heroicon name={if(@vertical?, do: "hero-arrow-down", else: "hero-arrow-right")} />
            </:next_trigger>
          </.carousel>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
