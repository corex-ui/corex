defmodule E2eWeb.Demos.SliderDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  import Corex.Slider,
    only: [
      slider: 1,
      slider_control: 1,
      slider_hidden_input: 1,
      slider_label: 1,
      slider_marker: 1,
      slider_marker_group: 1,
      slider_range: 1,
      slider_root: 1,
      slider_thumb: 1,
      slider_track: 1,
      slider_value_text: 1
    ]

  def marker_values do
    [0.0, 25.0, 50.0, 75.0, 100.0]
  end

  def minimal_example(assigns) do
    ~H"""
    <.slider id="slider-minimal" class="slider" value={50.0} markers marker_values={marker_values()} />
    """
  end

  def with_label_example(assigns) do
    ~H"""
    <.slider
      id="slider-with-label"
      class="slider"
      value={50.0}
      markers
      marker_values={marker_values()}
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.slider
      id="slider-custom-slots"
      class="slider"
      value={50.0}
      markers
      marker_values={marker_values()}
    >
      <:label>Volume</:label>
      <:value_text class="font-bold">
        Value:
      </:value_text>
    </.slider>
    """
  end

  def range_example(assigns) do
    ~H"""
    <.slider
      id="slider-range"
      class="slider"
      value={[20, 80]}
      min_steps_between_thumbs={1}
    >
      <:label>Price</:label>
    </.slider>
    """
  end

  def with_marks_example(assigns) do
    ~H"""
    <.slider
      id="slider-with-marks"
      class="slider"
      value={50.0}
      markers
      marker_values={marker_values()}
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def compound_example(assigns) do
    ~H"""
    <.slider
      :let={ctx}
      id="slider-compound"
      class="slider"
      value={50.0}
      markers
      marker_values={marker_values()}
      name="volume"
      compound
    >
      <.slider_root ctx={ctx}>
        <.slider_label ctx={ctx}>Volume</.slider_label>
        <.slider_control ctx={ctx}>
          <.slider_track ctx={ctx}>
            <.slider_range ctx={ctx} />
          </.slider_track>
          <.slider_thumb ctx={ctx} index={0}>
            <.slider_hidden_input ctx={ctx} index={0} />
          </.slider_thumb>
        </.slider_control>
        <.slider_marker_group ctx={ctx}>
          <.slider_marker :for={v <- ctx.marker_values} ctx={ctx} value={v} />
        </.slider_marker_group>
        <.slider_value_text ctx={ctx} />
      </.slider_root>
    </.slider>
    """
  end

  def minimal_code do
    ~S"""
    <.slider class="slider">
      <:label>Volume</:label>
    </.slider>
    """
  end

  def with_label_code do
    ~S"""
    <.slider class="slider" markers marker_values={[0, 25, 50, 75, 100]}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def range_code do
    ~S"""
    <.slider class="slider" value={[20, 80]}>
      <:label>Price</:label>
    </.slider>
    """
  end

  def with_marks_code do
    ~S"""
    <.slider class="slider" markers marker_values={[0, 25, 50, 75, 100]}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def custom_slots_code do
    ~S"""
    <.slider class="slider" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Volume</:label>
      <:value_text>
        Value:
      </:value_text>
    </.slider>
    """
  end

  def compound_code do
    ~S"""
    <.slider class="slider" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]} compound :let={ctx}>
      <.slider_root ctx={ctx}>
        <.slider_label ctx={ctx}>Volume</.slider_label>
        <.slider_control ctx={ctx}>
          <.slider_track ctx={ctx}>
            <.slider_range ctx={ctx} />
          </.slider_track>
          <.slider_thumb ctx={ctx} index={0}>
            <.slider_hidden_input ctx={ctx} index={0} />
          </.slider_thumb>
        </.slider_control>
        <.slider_marker_group ctx={ctx}>
          <.slider_marker :for={v <- ctx.marker_values} ctx={ctx} value={v} />
        </.slider_marker_group>
        <.slider_value_text ctx={ctx} />
      </.slider_root>
    </.slider>
    """
  end

  def styling_modifiers_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-lg">
      <.slider
        id="slider-style-color-default"
        class="slider"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Default</:label>
      </.slider>
      <.slider
        id="slider-style-color-accent"
        class="slider ui-accent"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Accent</:label>
      </.slider>
      <.slider
        id="slider-style-color-brand"
        class="slider ui-brand"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Brand</:label>
      </.slider>
      <.slider
        id="slider-style-color-alert"
        class="slider ui-alert"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Alert</:label>
      </.slider>
      <.slider
        id="slider-style-color-info"
        class="slider ui-info"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Info</:label>
      </.slider>
      <.slider
        id="slider-style-color-success"
        class="slider ui-success"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Success</:label>
      </.slider>
    </div>
    """
  end

  def styling_color_example(assigns), do: styling_modifiers_example(assigns)

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-end gap-space-lg">
      <.slider
        id="slider-style-sm"
        class="slider ui-size-sm"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>SM</:label>
      </.slider>
      <.slider
        id="slider-style-md"
        class="slider ui-size-md"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>MD</:label>
      </.slider>
      <.slider
        id="slider-style-lg"
        class="slider ui-size-lg"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>LG</:label>
      </.slider>
      <.slider
        id="slider-style-xl"
        class="slider ui-size-xl"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>XL</:label>
      </.slider>
    </div>
    """
  end

  def styling_states_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-lg">
      <.slider
        id="slider-style-disabled"
        class="slider"
        value={50.0}
        disabled
        markers
        marker_values={marker_values()}
      >
        <:label>Disabled</:label>
      </.slider>
      <.slider
        id="slider-style-read-only"
        class="slider"
        value={50.0}
        read_only
        markers
        marker_values={marker_values()}
      >
        <:label>Read only</:label>
      </.slider>
      <.slider
        id="slider-style-invalid"
        class="slider"
        value={50.0}
        invalid
        markers
        marker_values={marker_values()}
      >
        <:label>Invalid</:label>
      </.slider>
    </div>
    """
  end

  def styling_markers_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-lg">
      <.slider
        id="slider-style-markers"
        class="slider"
        value={50.0}
        markers
        marker_values={marker_values()}
      >
        <:label>Markers</:label>
      </.slider>
      <.slider
        id="slider-style-no-markers"
        class="slider"
        value={50.0}
      >
        <:label>No markers</:label>
      </.slider>
    </div>
    """
  end

  def styling_modifiers_code do
    ~S"""
    <.slider class="slider" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Default</:label>
    </.slider>
    <.slider class="slider ui-accent" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Accent</:label>
    </.slider>
    <.slider class="slider ui-brand" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Brand</:label>
    </.slider>
    <.slider class="slider ui-alert" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Alert</:label>
    </.slider>
    <.slider class="slider ui-info" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Info</:label>
    </.slider>
    <.slider class="slider ui-success" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Success</:label>
    </.slider>
    """
  end

  def styling_color_code, do: styling_modifiers_code()

  def styling_variant_code do
    ~S"""
    <.slider class="slider" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Subtle (default)</:label>
    </.slider>
    <.slider class="slider ui-solid" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Solid</:label>
    </.slider>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-lg">
      <.slider
        id="slider-style-variant-subtle"
        class="slider"
        value={50.0}
        markers
        marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      >
        <:label>Subtle (default)</:label>
      </.slider>
      <.slider
        id="slider-style-variant-solid"
        class="slider ui-solid"
        value={50.0}
        markers
        marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      >
        <:label>Solid</:label>
      </.slider>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("slider"),
        variant <- DemoScales.styling_variant_axis_steps("slider") do
      class =
        DemoScales.join_matrix_modifiers("slider", semantic.modifier, variant.modifier)

      ~s(<.slider class="#{class}" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
        <:label>#{semantic.label}</:label>
      </.slider>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("slider"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("slider"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.slider
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"slider-matrix-#{semantic_index}-#{variant_index}"}
            class={DemoScales.join_matrix_modifiers("slider", semantic.modifier, variant.modifier)}
            value={50.0}
            markers
            marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
          >
            <:label>{semantic.label}</:label>
          </.slider>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.slider class="slider ui-size-sm" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>SM</:label>
    </.slider>
    <.slider class="slider ui-size-md" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>MD</:label>
    </.slider>
    <.slider class="slider ui-size-lg" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>LG</:label>
    </.slider>
    <.slider class="slider ui-size-xl" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>XL</:label>
    </.slider>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("slider")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("slider", modifier)

      """
      <.slider class="#{class}" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]} />
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("slider")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("slider", modifier)

      """
      <.slider class="#{class}" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]} />
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("slider"))

    ~H"""
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-space-sm">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.slider
          id={"slider-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("slider", variant.modifier)}
          value={50.0}
          markers
          marker_values={marker_values()}
        />
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("slider"))

    ~H"""
    <div {DemoScales.preview_scroll_attrs()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-space-sm">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.slider
          id={"slider-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("slider", variant.modifier)}
          value={50.0}
          markers
          marker_values={marker_values()}
        />
      </div>
    </div>
    """
  end

  def styling_states_code do
    ~S"""
    <.slider class="slider" value={50.0} disabled markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Disabled</:label>
    </.slider>
    <.slider class="slider" value={50.0} read_only markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Read only</:label>
    </.slider>
    <.slider class="slider" value={50.0} invalid markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Invalid</:label>
    </.slider>
    """
  end

  def styling_markers_code do
    ~S"""
    <.slider class="slider" value={50.0} markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Markers</:label>
    </.slider>
    <.slider class="slider" value={50.0}>
      <:label>No markers</:label>
    </.slider>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Slider.set_value("api-slider", 0)}>Set to 0</.action>
    <.action phx-click={Corex.Slider.set_value("api-slider", 25)}>Set to 25</.action>
    <.action phx-click={Corex.Slider.set_value("api-slider", 50)}>Set to 50</.action>
    <.action phx-click={Corex.Slider.set_value("api-slider", 75)}>Set to 75</.action>
    <.slider class="slider" markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-sm mb-space-lg">
      <.action phx-click={Corex.Slider.set_value(@id, 0)} class="button ui-size-sm">
        Set to 0
      </.action>
      <.action phx-click={Corex.Slider.set_value(@id, 25)} class="button ui-size-sm">
        Set to 25
      </.action>
      <.action phx-click={Corex.Slider.set_value(@id, 50)} class="button ui-size-sm">
        Set to 50
      </.action>
      <.action phx-click={Corex.Slider.set_value(@id, 75)} class="button ui-size-sm">
        Set to 75
      </.action>
    </div>
    <.slider id={@id} class="slider" value={50.0} markers marker_values={marker_values()}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <.action
      phx-click={
        JS.dispatch("corex:slider:set-value",
          to: "#api-slider-client-js",
          detail: %{value: [25]},
          bubbles: false
        )
      }
    >
      Set to 25
    </.action>
    <.slider class="slider" markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("api-slider-client-js")
    el?.dispatchEvent(new CustomEvent("corex:slider:set-value", {
      detail: { value: [25] },
      bubbles: false
    }))
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("api-slider-client-js")
    el?.dispatchEvent(
      new CustomEvent<{ value: number[] }>("corex:slider:set-value", {
        detail: { value: [25] },
        bubbles: false
      })
    )
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-sm mb-space-lg">
      <.action
        phx-click={
          JS.dispatch("corex:slider:set-value",
            to: "##{@id}",
            detail: %{value: [0]},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Set to 0
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:slider:set-value",
            to: "##{@id}",
            detail: %{value: [25]},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Set to 25
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:slider:set-value",
            to: "##{@id}",
            detail: %{value: [50]},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Set to 50
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:slider:set-value",
            to: "##{@id}",
            detail: %{value: [75]},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Set to 75
      </.action>
    </div>
    <.slider id={@id} class="slider" value={50.0} markers marker_values={marker_values()}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_set_value" value="0" class="button ui-size-sm">Server: 0</.action>
    <.action phx-click="api_set_value" value="25" class="button ui-size-sm">Server: 25</.action>
    <.action phx-click="api_set_value" value="50" class="button ui-size-sm">Server: 50</.action>
    <.action phx-click="api_set_value" value="75" class="button ui-size-sm">Server: 75</.action>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_set_value", %{"value" => value}, socket) do
      {:noreply, Corex.Slider.set_value(socket, "api-slider", value)}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-space-sm mb-space-lg">
      <.action phx-click={@event} value="0" class="button ui-size-sm">Server: 0</.action>
      <.action phx-click={@event} value="25" class="button ui-size-sm">Server: 25</.action>
      <.action phx-click={@event} value="50" class="button ui-size-sm">Server: 50</.action>
      <.action phx-click={@event} value="75" class="button ui-size-sm">Server: 75</.action>
    </div>
    <.slider id={@id} class="slider" value={50.0} markers marker_values={marker_values()}>
      <:label>Volume</:label>
    </.slider>
    """
  end

  def events_on_value_change_server_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      on_value_change="slider_changed"
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def events_on_value_change_end_server_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      value={50.0}
      on_value_change_end="slider_change_ended"
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def events_on_value_change_client_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      on_value_change_client="slider-changed"
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def events_on_value_change_end_client_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      value={50.0}
      on_value_change_end_client="slider-change-ended"
    >
      <:label>Volume</:label>
    </.slider>
    """
  end

  def events_server_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      on_value_change="slider_changed"
    >
      <:label>On Change</:label>
    </.slider>

    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      value={50.0}
      on_value_change_end="slider_change_ended"
    >
      <:label>On End</:label>
    </.slider>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"slider_changed", ~S|%{"id" => id, "value" => value} = params|},
      {"slider_change_ended", ~S|%{"id" => id, "value" => value} = params|}
    ])
  end

  def events_client_heex do
    ~S"""
    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      on_value_change_client="slider-changed"
    >
      <:label>On Change</:label>
    </.slider>

    <.slider
      class="slider"
      markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      value={50.0}
      on_value_change_end_client="slider-change-ended"
    >
      <:label>On End</:label>
    </.slider>
    """
  end

  def events_client_js do
    ~S"""
    const a = document.getElementById("events-slider-on-value-change-client");
    const b = document.getElementById("events-slider-on-value-change-end-client");
    a?.addEventListener("slider-changed", (event) => console.log(event.detail));
    b?.addEventListener("slider-change-ended", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    type Detail = { id: string; value: number[]; dragging?: boolean };
    const a = document.getElementById("events-slider-on-value-change-client");
    const b = document.getElementById("events-slider-on-value-change-end-client");
    a?.addEventListener("slider-changed", (event: Event) => console.log((event as CustomEvent<Detail>).detail));
    b?.addEventListener("slider-change-ended", (event: Event) => console.log((event as CustomEvent<Detail>).detail));
    """
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={slider} assign={@slider}>
      <:loading>
        <.slider_skeleton class="slider" />
      </:loading>

      <.slider
        id={@id_async}
        class="slider"
        value={slider.value}
        markers marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
      >
        <:label>Volume</:label>
      </.slider>
    </.async_result>
    """
  end

  def patterns_async_heex_panel do
    ~S"""
    <.async_result :let={slider} assign={@slider}>
      <:loading>
        <.slider_skeleton class="slider" />
      </:loading>

      <.slider value={slider.value} />
    </.async_result>
    """
  end

  def patterns_async_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign(:id_async, "patterns-slider-async")
       |> assign_async(:slider, fn ->
         Process.sleep(1000)
         {:ok, %{slider: %{value: [25]}}}
       end)}
    end
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.Slider do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :volume, :float, default: 0.0
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:volume])
        |> validate_required([:volume])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:volume])
        |> validate_required([:volume])
        |> validate_number(:volume,
          greater_than_or_equal_to: 0.0,
          less_than_or_equal_to: 90.0,
          message: "must be between 0 and 90"
        )
      end
    end
    """
  end

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def slider_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"volume" => "0"}, as: :slider_phoenix, id: "slider-form-phoenix")

      render(conn, :slider_form_page, phoenix_form: phoenix_form)
    end

    def slider_form_submit(conn, params) do
      if is_map(params["slider_phoenix"]) do
        volume = params["slider_phoenix"]["volume"] || ""

        conn
        |> put_flash(:info, "Submitted: volume=#{inspect(volume)}")
        |> redirect(to: ~p"/slider/form#slider-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@form} phx-submit="save_phoenix"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action type="submit" class="button ui-accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def product_form_page(conn, _params) do
      changeset = MyApp.Forms.Slider.changeset(%MyApp.Forms.Slider{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :slider,
          id: "product-volume-form"
        )

      render(conn, :product_form, form: form)
    end

    def product_form_create(conn, %{"slider" => params}) do
      case MyApp.Forms.Slider.changeset(%MyApp.Forms.Slider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved volume=#{data.volume}")
          |> redirect(to: ~p"/products")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :slider,
              id: "product-volume-form"
            )

          render(conn, :product_form, form: form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action type="submit" class="button ui-accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def product_form_validated_page(conn, _params) do
      changeset =
        MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :slider_validated,
          id: "product-volume-validated-form"
        )

      render(conn, :product_form_validated, form: form)
    end

    def product_form_validated_create(conn, %{"slider_validated" => params}) do
      case MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved volume=#{data.volume}")
          |> redirect(to: ~p"/products")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :slider_validated,
              id: "product-volume-validated-form"
            )

          render(conn, :product_form_validated, form: form)
      end
    end
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_volume"
      phx-submit="save_volume"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        on_value_change="volume_changed"
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action type="submit" class="button ui-accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      changeset = MyApp.Forms.Slider.changeset(%MyApp.Forms.Slider{}, %{})

      {:ok,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset, as: :slider, id: "live-product-volume-form")
       )}
    end

    def handle_event("validate_volume", %{"slider" => params}, socket) do
      changeset =
        %MyApp.Forms.Slider{}
        |> MyApp.Forms.Slider.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :slider,
           id: "live-product-volume-form"
         )
       )}
    end

    def handle_event("volume_changed", %{"value" => value}, socket) do
      params = %{"volume" => to_string(value)}

      changeset =
        %MyApp.Forms.Slider{}
        |> MyApp.Forms.Slider.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :slider,
           id: "live-product-volume-form"
         )
       )}
    end

    def handle_event("save_volume", %{"slider" => params}, socket) do
      case MyApp.Forms.Slider.changeset(%MyApp.Forms.Slider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset, as: :slider, id: "live-product-volume-form")
           )}

        changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :slider,
               id: "live-product-volume-form"
             )
           )}
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
     
      phx-change="validate_volume_range"
      phx-submit="save_volume_range"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={@form[:volume]}
        markers marker_values={[0, 25, 50, 75, 100]}
        on_value_change="volume_range_changed"
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action type="submit" class="button ui-accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      changeset =
        MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, %{})

      {:ok,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           as: :slider_validated,
           id: "live-product-volume-validated-form"
         )
       )}
    end

    def handle_event("validate_volume_range", %{"slider_validated" => params}, socket) do
      changeset =
        %MyApp.Forms.Slider{}
        |> MyApp.Forms.Slider.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :slider_validated,
           id: "live-product-volume-validated-form"
         )
       )}
    end

    def handle_event("volume_range_changed", %{"value" => value}, socket) do
      params = %{"volume" => to_string(value)}

      changeset =
        %MyApp.Forms.Slider{}
        |> MyApp.Forms.Slider.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :slider_validated,
           id: "live-product-volume-validated-form"
         )
       )}
    end

    def handle_event("save_volume_range", %{"slider_validated" => params}, socket) do
      case MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               as: :slider_validated,
               id: "live-product-volume-validated-form"
             )
           )}

        changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :slider_validated,
               id: "live-product-volume-validated-form"
             )
           )}
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.slider
        name="slider_form[volume]"
        value={0.0}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
      </.slider>
      <.action type="submit" class="button ui-accent">Submit</:action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def slider_form_submit(conn, %{"slider_form" => %{"volume" => volume}}) do
      conn
      |> put_flash(:info, "Submitted: volume=#{volume}")
      |> redirect(to: ~p"/slider/form#slider-form-native")
    end
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={f[:volume]}
        id="slider-form-changeset-volume"
        markers
        marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action
        type="submit"
        id="slider-form-changeset-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        field={f[:volume]}
        id="slider-form-validate-volume"
        markers
        marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action
        type="submit"
        id="slider-form-validate-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/slider/form"}
      method="post"
      id="slider-plain-form"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.slider
        name="slider_form[volume]"
        id="slider-form-volume"
        value={0.0}
        markers
        marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume</:label>
      </.slider>
      <.action type="submit" id="slider-form-submit" class="button ui-accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:volume_value, :float, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_basic"
      phx-submit="save_basic"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-changeset-volume"
        field={@form[:volume]}
        value={@volume_value}
        markers
        marker_values={[0, 25, 50, 75, 100]}
        on_value_change="volume_changed_basic"
        class="slider"
      >
        <:label>Volume</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action
        type="submit"
        id="slider-live-form-changeset-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:volume_value, :float, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_validate"
      phx-submit="save_validate"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-validate-volume"
        field={@form[:volume]}
        value={@volume_value}
        markers
        marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>

      <.action
        type="submit"
        id="slider-live-form-validate-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()
  def form_native_elixir, do: form_doc_controller_native_elixir()

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/slider/form"}
      method="post"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider field={f[:volume]} markers marker_values={[0, 25, 50, 75, 100]} class="slider">
        <:label>Volume</:label>
      </.slider>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_phoenix" class="flex flex-col gap-space-lg w-full max-w-xl">
      <.slider field={@form[:volume]} markers marker_values={[0, 25, 50, 75, 100]} class="slider">
        <:label>Volume</:label>
      </.slider>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.SliderFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"volume" => "0"}, as: :slider_phoenix, id: "slider-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"slider_phoenix" => params}, socket) do
        volume = params["volume"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"volume" => volume}, as: :slider_phoenix, id: "slider-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.SliderFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.Slider{}
          |> MyApp.Forms.Slider.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :slider_ecto, id: "slider-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"slider_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.Slider{}
          |> MyApp.Forms.Slider.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :slider_ecto,
             id: "slider-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"slider_ecto" => params}, socket) do
        case MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.Slider.changeset_validate(%MyApp.Forms.Slider{}, params),
                 as: :slider_ecto,
                 id: "slider-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :slider_ecto,
                 id: "slider-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end

  def form_doc_live_ecto_controlled_heex do
    ~S"""
    <.form for={@validate_controlled_form} phx-change="validate_controlled" phx-submit="save_controlled"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-validate-controlled-volume"
        field={@validate_controlled_form[:volume]}
        value={@validate_controlled_volume_value}
        markers marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action type="submit" id="slider-live-form-validate-controlled-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_invalid_heex do
    ~S"""
    <.form for={@validate_invalid_form} phx-change="validate_invalid" phx-submit="save_invalid"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-validate-invalid-volume"
        field={@validate_invalid_form[:volume]}
        value={@validate_invalid_volume_value}
        markers marker_values={[0, 25, 50, 75, 100]}
        invalid={Corex.FormField.invalid?(@validate_invalid_form[:volume])}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action type="submit" id="slider-live-form-validate-invalid-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)
  attr(:volume_value, :float, required: true)

  def form_preview_live_validate_controlled(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_controlled"
      phx-submit="save_controlled"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-validate-controlled-volume"
        field={@form[:volume]}
        value={@volume_value}
        markers
        marker_values={[0, 25, 50, 75, 100]}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action
        type="submit"
        id="slider-live-form-validate-controlled-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)
  attr(:volume_value, :float, required: true)

  def form_preview_live_validate_invalid(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-change="validate_invalid"
      phx-submit="save_invalid"
      class="flex flex-col gap-space-lg w-full max-w-xl"
    >
      <.slider
        id="slider-live-form-validate-invalid-volume"
        field={@form[:volume]}
        value={@volume_value}
        markers
        marker_values={[0, 25, 50, 75, 100]}
        invalid={Corex.FormField.invalid?(@form[:volume])}
        class="slider"
      >
        <:label>Volume (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.slider>
      <.action
        type="submit"
        id="slider-live-form-validate-invalid-submit"
        class="button ui-accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_ecto_controlled_elixir do
    ~S"""
    defmodule MyAppWeb.SliderFormLive do
      use MyAppWeb, :live_view

      def handle_event("validate_controlled", params, socket) do
        validate_ecto_controlled(socket, Map.get(params, "slider_validate_controlled", %{}))
      end

      def handle_event("save_controlled", params, socket) do
        save_ecto_controlled(socket, Map.get(params, "slider_validate_controlled", %{}))
      end
    end
    """
  end

  def form_doc_live_ecto_invalid_elixir do
    ~S"""
    defmodule MyAppWeb.SliderFormLive do
      use MyAppWeb, :live_view

      def handle_event("validate_invalid", params, socket) do
        validate_ecto_invalid(socket, Map.get(params, "slider_validate_invalid", %{}))
      end

      def handle_event("save_invalid", params, socket) do
        save_ecto_invalid(socket, Map.get(params, "slider_validate_invalid", %{}))
      end
    end
    """
  end
end
