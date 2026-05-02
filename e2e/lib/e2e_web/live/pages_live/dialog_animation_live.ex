defmodule E2eWeb.DialogAnimationLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_playground: 1, demo_section: 1]

  @easing_items [
    %{label: "ease", id: "ease"},
    %{label: "ease-in", id: "ease-in"},
    %{label: "ease-out", id: "ease-out"},
    %{label: "ease-in-out", id: "ease-in-out"},
    %{label: "linear", id: "linear"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    animation_options = %Corex.Animation.Scale{scale_start: 0.96, scale_end: 1.0}

    socket =
      socket
      |> assign(:animation_options, animation_options)
      |> assign(:duration, to_string(animation_options.duration))
      |> assign(:opacity_start, to_string(animation_options.opacity_start))
      |> assign(:opacity_end, to_string(animation_options.opacity_end))
      |> assign(:scale_start, to_string(animation_options.scale_start))
      |> assign(:scale_end, to_string(animation_options.scale_end))
      |> assign(:easing_items, @easing_items)
      |> assign(:easing, [animation_options.easing])
      |> assign(:instant_heex, E2eWeb.Demos.DialogDemo.animation_instant_heex())
      |> assign(:custom_heex, E2eWeb.Demos.DialogDemo.animation_custom_heex())
      |> assign(:custom_js, E2eWeb.Demos.DialogDemo.animation_custom_js())

    {:ok, socket}
  end

  @impl true
  def handle_event("duration_changed", %{"value" => value}, socket) do
    duration = parse_float(value, socket.assigns.animation_options.duration)
    {:noreply, update_animation(socket, :duration, duration, value)}
  end

  def handle_event("opacity_start_changed", %{"value" => value}, socket) do
    opacity_start = parse_float(value, socket.assigns.animation_options.opacity_start)
    {:noreply, update_animation(socket, :opacity_start, opacity_start, value)}
  end

  def handle_event("opacity_end_changed", %{"value" => value}, socket) do
    opacity_end = parse_float(value, socket.assigns.animation_options.opacity_end)
    {:noreply, update_animation(socket, :opacity_end, opacity_end, value)}
  end

  def handle_event("easing_changed", %{"value" => [value]}, socket) do
    {:noreply, update_animation(socket, :easing, value, [value])}
  end

  def handle_event("scale_start_changed", %{"value" => value}, socket) do
    v = parse_float(value, socket.assigns.animation_options.scale_start)
    {:noreply, update_animation(socket, :scale_start, v, value)}
  end

  def handle_event("scale_end_changed", %{"value" => value}, socket) do
    v = parse_float(value, socket.assigns.animation_options.scale_end)
    {:noreply, update_animation(socket, :scale_end, v, value)}
  end

  def handle_event("block_interaction_changed", %{"checked" => checked, "id" => _}, socket) do
    b = checked == true or checked == "true"

    {:noreply, update(socket, :animation_options, fn o -> Map.put(o, :block_interaction, b) end)}
  end

  def handle_event(_event, _params, socket) do
    {:noreply, socket}
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
      <.demo_page
        id="dialog-animation-page"
        title="Dialog · Animation"
        subtitle="Built-in JS animation, instant mode, and custom Motion-driven transitions."
      >
        <.demo_playground
          id="dialog-animation-playground-section"
          title="Playground"
          heading_class="layout-heading"
        >
          <:controls>
            <.select
              id="dialog-animation-easing"
              class="select select--sm select--mini-sm lg:w-full"
              value={@easing}
              items={@easing_items}
              on_value_change="easing_changed"
              translation={%Corex.Select.Translation{placeholder: "Easing"}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Easing</:label>
            </.select>

            <.number_input
              id="dialog-animation-duration"
              class="number-input number-input--sm lg:w-full"
              value={@duration}
              step={0.1}
              min={0.0}
              on_value_change="duration_changed"
            >
              <:label>Duration</:label>
              <:decrement_trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:decrement_trigger>
              <:increment_trigger>
                <.heroicon name="hero-chevron-up" class="icon" />
              </:increment_trigger>
            </.number_input>

            <.number_input
              id="dialog-animation-opacity-start"
              class="number-input number-input--sm lg:w-full"
              step={0.1}
              min={0.0}
              max={1.0}
              value={@opacity_start}
              on_value_change="opacity_start_changed"
            >
              <:label>Opacity start</:label>
              <:decrement_trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:decrement_trigger>
              <:increment_trigger>
                <.heroicon name="hero-chevron-up" class="icon" />
              </:increment_trigger>
            </.number_input>

            <.number_input
              id="dialog-animation-opacity-end"
              class="number-input number-input--sm lg:w-full"
              step={0.1}
              min={0.0}
              max={1.0}
              value={@opacity_end}
              on_value_change="opacity_end_changed"
            >
              <:label>Opacity end</:label>
              <:decrement_trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:decrement_trigger>
              <:increment_trigger>
                <.heroicon name="hero-chevron-up" class="icon" />
              </:increment_trigger>
            </.number_input>

            <.number_input
              id="dialog-animation-scale-start"
              class="number-input number-input--sm lg:w-full"
              step={0.01}
              min={0.0}
              max={1.5}
              value={@scale_start}
              on_value_change="scale_start_changed"
            >
              <:label>Scale (closed)</:label>
              <:decrement_trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:decrement_trigger>
              <:increment_trigger>
                <.heroicon name="hero-chevron-up" class="icon" />
              </:increment_trigger>
            </.number_input>

            <.number_input
              id="dialog-animation-scale-end"
              class="number-input number-input--sm lg:w-full"
              step={0.01}
              min={0.0}
              max={1.5}
              value={@scale_end}
              on_value_change="scale_end_changed"
            >
              <:label>Scale (open)</:label>
              <:decrement_trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:decrement_trigger>
              <:increment_trigger>
                <.heroicon name="hero-chevron-up" class="icon" />
              </:increment_trigger>
            </.number_input>

            <.switch
              id="dialog-animation-block-interaction"
              class="switch switch--sm w-full"
              checked={@animation_options.block_interaction}
              on_checked_change="block_interaction_changed"
            >
              <:label>Block Interaction</:label>
            </.switch>
          </:controls>
          <:canvas>
            <.dialog
              id="dialog-animation-playground"
              class="dialog"
              modal
              animation="js"
              animation_options={@animation_options}
            >
              <:trigger>Open</:trigger>
              <:title>Playground</:title>
              <:content>
                <p>Dialog JS animation uses only opacity and scale on the content.</p>
              </:content>
              <:close_trigger>
                <.heroicon name="hero-x-mark" class="icon" />
              </:close_trigger>
            </.dialog>
          </:canvas>
        </.demo_playground>

        <.demo_section
          id="dialog-animation-instant"
          title="Instant"
          trigger_class="button--sm"
          code={@instant_heex}
        >
          <:preview>
            <.dialog
              id="dialog-animate-instant"
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
          </:preview>
        </.demo_section>

        <.demo_section
          id="dialog-animation-custom"
          title="Custom (Motion)"
          trigger_class="button--sm"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @custom_heex},
            %{value: "js", label: "Javascript", language: :js, code: @custom_js}
          ]}
        >
          <:preview>
            <.dialog
              id="dialog-custom-animate"
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
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp update_animation(socket, key, value, raw_value)
       when key in [
              :duration,
              :opacity_start,
              :opacity_end,
              :scale_start,
              :scale_end
            ] do
    socket
    |> update(:animation_options, fn opts -> Map.put(opts, key, value) end)
    |> assign(key, raw_value)
  end

  defp update_animation(socket, key, value, raw_value) when key in [:easing] do
    socket
    |> update(:animation_options, fn opts -> Map.put(opts, key, value) end)
    |> assign(key, raw_value)
  end

  defp parse_float(nil, fallback), do: fallback

  defp parse_float(raw, fallback) when is_binary(raw) do
    case Float.parse(raw) do
      {v, _} -> v
      :error -> fallback
    end
  end
end
