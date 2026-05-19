defmodule E2eWeb.AccordionAnimationLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_playground: 1, demo_section: 1]

  @easing_items [
    %{label: "ease", value: "ease"},
    %{label: "ease-in", value: "ease-in"},
    %{label: "ease-out", value: "ease-out"},
    %{label: "ease-in-out", value: "ease-in-out"},
    %{label: "linear", value: "linear"}
  ]

  def mount(_params, _session, socket) do
    animation_options = %Corex.Animation.Height{}

    socket =
      socket
      |> assign(:items, demo_items())
      |> assign(:value, [])
      |> assign(:animation_options, animation_options)
      |> assign(:duration, to_string(animation_options.duration))
      |> assign(:opacity_start, to_string(animation_options.opacity_start))
      |> assign(:opacity_end, to_string(animation_options.opacity_end))
      |> assign(:easing_items, @easing_items)
      |> assign(:easing, [animation_options.easing])
      |> assign(:instant_heex, E2eWeb.Demos.AccordionDemo.animation_instant_heex())
      |> assign(:custom_heex, E2eWeb.Demos.AccordionDemo.animation_custom_heex())
      |> assign(:custom_js, E2eWeb.Demos.AccordionDemo.animation_custom_js())

    {:ok, socket}
  end

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

  def handle_event("block_interaction_changed", %{"checked" => checked, "id" => _}, socket) do
    b = checked == true or checked == "true"

    {:noreply, update(socket, :animation_options, fn o -> Map.put(o, :block_interaction, b) end)}
  end

  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="accordion-animation-page"
        title="Accordion · Animation"
        subtitle="Built-in JS animation, instant mode, and custom Motion-driven transitions."
      >
        <.demo_playground
          id="accordion-animation-playground"
          title="Playground"
          heading_class="layout-heading"
          title_tag="h2"
        >
          <:controls>
            <.select
              id="accordion-animation-easing"
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
              id="accordion-animation-duration"
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
              id="accordion-animation-opacity-start"
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
              id="accordion-animation-opacity-end"
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

            <.switch
              id="accordion-animation-block-interaction"
              class="switch switch--sm w-full"
              checked={@animation_options.block_interaction}
              on_checked_change="block_interaction_changed"
            >
              <:label>Block Interaction</:label>
            </.switch>
          </:controls>
          <:canvas>
            <.accordion
              id="accordion-animation-playground-accordion"
              class="accordion w-full h-full overflow-hidden"
              animation="js"
              animation_options={@animation_options}
              items={@items}
              value={@value}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:canvas>
        </.demo_playground>

        <.demo_section
          id="accordion-animation-instant"
          title="Instant"
          trigger_class="button--sm"
          code={@instant_heex}
        >
          <:preview>
            <.accordion id="accordion-animate" class="accordion" animation="instant" items={@items}>
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-animation-custom"
          title="Custom (Motion)"
          trigger_class="button--sm"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @custom_heex},
            %{value: "js", label: "Javascript", language: :js, code: @custom_js}
          ]}
        >
          <:preview>
            <.accordion
              id="accordion-custom-animate"
              class="accordion"
              animation="custom"
              value={["lorem"]}
              on_value_change_client="my-accordion-changed"
              items={@items}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp update_animation(socket, key, value, raw_value)
       when key in [:duration, :opacity_start, :opacity_end] do
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

  defp demo_items do
    E2eWeb.Demos.AccordionDemo.animation_items()
  end
end
