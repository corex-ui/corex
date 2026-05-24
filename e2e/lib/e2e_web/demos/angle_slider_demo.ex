defmodule E2eWeb.Demos.AngleSliderDemo do
  use E2eWeb, :html

  import Corex.AngleSlider,
    only: [
      angle_slider: 1,
      angle_slider_control: 1,
      angle_slider_hidden_input: 1,
      angle_slider_label: 1,
      angle_slider_marker: 1,
      angle_slider_marker_group: 1,
      angle_slider_root: 1,
      angle_slider_thumb: 1,
      angle_slider_value_text: 1
    ]

  def marker_values do
    [0.0, 90.0, 180.0, 270.0]
  end

  def minimal_example(assigns) do
    ~H"""
    <.angle_slider
      id="angle-slider-minimal"
      class="angle-slider"
      value={90.0}
      marker_values={marker_values()}
    />
    """
  end

  def with_label_example(assigns) do
    ~H"""
    <.angle_slider
      id="angle-slider-with-label"
      class="angle-slider"
      value={90.0}
      marker_values={marker_values()}
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.angle_slider
      id="angle-slider-custom-slots"
      class="angle-slider"
      value={90.0}
      marker_values={marker_values()}
    >
      <:label>Angle</:label>
      <:value_text class="font-bold">
        Rotation:
      </:value_text>
    </.angle_slider>
    """
  end

  def compound_example(assigns) do
    ~H"""
    <.angle_slider
      :let={ctx}
      id="angle-slider-compound"
      class="angle-slider"
      value={90.0}
      marker_values={marker_values()}
      name="angle"
      compound
    >
      <.angle_slider_root ctx={ctx}>
        <.angle_slider_label ctx={ctx}>Angle</.angle_slider_label>
        <.angle_slider_control ctx={ctx}>
          <.angle_slider_thumb ctx={ctx} />
          <.angle_slider_marker_group ctx={ctx}>
            <.angle_slider_marker :for={v <- ctx.marker_values} ctx={ctx} value={v} />
          </.angle_slider_marker_group>
        </.angle_slider_control>
        <.angle_slider_value_text ctx={ctx} />
        <.angle_slider_hidden_input ctx={ctx} />
      </.angle_slider_root>
    </.angle_slider>
    """
  end

  def minimal_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]} />
    """
  end

  def with_label_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def custom_slots_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Angle</:label>
      <:value_text :let={vt}>
        Rotation: <span class="font-bold" {vt.value_attrs} />
        <span {vt.text_attrs}>°</span>
      </:value_text>
    </.angle_slider>
    """
  end

  def compound_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]} compound :let={ctx}>
      <.angle_slider_root ctx={ctx}>
        <.angle_slider_label ctx={ctx}>Angle</.angle_slider_label>
        <.angle_slider_control ctx={ctx}>
          <.angle_slider_thumb ctx={ctx} />
          <.angle_slider_marker_group ctx={ctx}>
            <.angle_slider_marker :for={v <- ctx.marker_values} ctx={ctx} value={v} />
          </.angle_slider_marker_group>
        </.angle_slider_control>
        <.angle_slider_value_text ctx={ctx} />
        <.angle_slider_hidden_input ctx={ctx} name="angle" />
      </.angle_slider_root>
    </.angle_slider>
    """
  end

  def styling_modifiers_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4">
      <.angle_slider class="angle-slider" value={90.0} marker_values={marker_values()}>
        <:label>Default</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--accent"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>Accent</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--brand"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>Brand</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--alert"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>Alert</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--info"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>Info</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--success"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>Success</:label>
      </.angle_slider>
    </div>
    """
  end

  def styling_color_example(assigns), do: styling_modifiers_example(assigns)

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4">
      <.angle_slider
        class="angle-slider angle-slider--sm"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>SM</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--md"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>MD</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--lg"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>LG</:label>
      </.angle_slider>
      <.angle_slider
        class="angle-slider angle-slider--xl"
        value={90.0}
        marker_values={marker_values()}
      >
        <:label>XL</:label>
      </.angle_slider>
    </div>
    """
  end

  def styling_states_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4">
      <.angle_slider class="angle-slider" value={90.0} disabled marker_values={marker_values()}>
        <:label>Disabled</:label>
      </.angle_slider>
      <.angle_slider class="angle-slider" value={90.0} read_only marker_values={marker_values()}>
        <:label>Read only</:label>
      </.angle_slider>
      <.angle_slider class="angle-slider" value={90.0} invalid marker_values={marker_values()}>
        <:label>Invalid</:label>
      </.angle_slider>
    </div>
    """
  end

  def styling_markers_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4">
      <.angle_slider class="angle-slider" value={90.0} marker_values={marker_values()}>
        <:label>Markers</:label>
      </.angle_slider>
      <.angle_slider class="angle-slider" value={90.0} marker_values={[]}>
        <:label>No markers</:label>
      </.angle_slider>
    </div>
    """
  end

  def styling_modifiers_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Default</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--accent" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Accent</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--brand" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Brand</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--alert" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Alert</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--info" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Info</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--success" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Success</:label>
    </.angle_slider>
    """
  end

  def styling_color_code, do: styling_modifiers_code()

  def styling_size_code do
    ~S"""
    <.angle_slider class="angle-slider angle-slider--sm" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>SM</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--md" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>MD</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--lg" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>LG</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider angle-slider--xl" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>XL</:label>
    </.angle_slider>
    """
  end

  def styling_states_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} disabled marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Disabled</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider" value={90.0} read_only marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Read only</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider" value={90.0} invalid marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Invalid</:label>
    </.angle_slider>
    """
  end

  def styling_markers_code do
    ~S"""
    <.angle_slider class="angle-slider" value={90.0} marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Markers</:label>
    </.angle_slider>
    <.angle_slider class="angle-slider" value={90.0} marker_values={[]}>
      <:label>No markers</:label>
    </.angle_slider>
    """
  end

  def api_set_value_client_binding_code do
    ~S"""
    <.action phx-click={Corex.AngleSlider.set_value("api-angle-slider", 0.0)}>Set to 0°</.action>
    <.action phx-click={Corex.AngleSlider.set_value("api-angle-slider", 90.0)}>Set to 90°</.action>
    <.action phx-click={Corex.AngleSlider.set_value("api-angle-slider", 180.0)}>Set to 180°</.action>
    <.action phx-click={Corex.AngleSlider.set_value("api-angle-slider", 270.0)}>Set to 270°</.action>
    <.angle_slider id="api-angle-slider" class="angle-slider" marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def api_set_value_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.AngleSlider.set_value(@id, 0.0)} class="button button--sm">
        Set to 0°
      </.action>
      <.action phx-click={Corex.AngleSlider.set_value(@id, 90.0)} class="button button--sm">
        Set to 90°
      </.action>
      <.action phx-click={Corex.AngleSlider.set_value(@id, 180.0)} class="button button--sm">
        Set to 180°
      </.action>
      <.action phx-click={Corex.AngleSlider.set_value(@id, 270.0)} class="button button--sm">
        Set to 270°
      </.action>
    </div>
    <.angle_slider id={@id} class="angle-slider" value={90.0} marker_values={marker_values()}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def api_set_value_client_js_heex do
    ~S"""
    <.action
      phx-click={
        JS.dispatch("corex:angle-slider:set-value",
          to: "#api-angle-slider-client-js",
          detail: %{value: 90.0},
          bubbles: false
        )
      }
    >
      Set to 90°
    </.action>
    <.angle_slider id="api-angle-slider-client-js" class="angle-slider" marker_values={[0.0, 90.0, 180.0, 270.0]}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def api_set_value_client_js_js do
    ~S"""
    const el = document.getElementById("api-angle-slider-client-js")
    el?.dispatchEvent(new CustomEvent("corex:angle-slider:set-value", {
      detail: { value: 90.0 },
      bubbles: false
    }))
    """
  end

  def api_set_value_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("api-angle-slider-client-js")
    el?.dispatchEvent(
      new CustomEvent<{ value: number }>("corex:angle-slider:set-value", {
        detail: { value: 90.0 },
        bubbles: false
      })
    )
    """
  end

  def api_set_value_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={
          JS.dispatch("corex:angle-slider:set-value",
            to: "##{@id}",
            detail: %{value: 0.0},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set to 0°
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:angle-slider:set-value",
            to: "##{@id}",
            detail: %{value: 90.0},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set to 90°
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:angle-slider:set-value",
            to: "##{@id}",
            detail: %{value: 180.0},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set to 180°
      </.action>
      <.action
        phx-click={
          JS.dispatch("corex:angle-slider:set-value",
            to: "##{@id}",
            detail: %{value: 270.0},
            bubbles: false
          )
        }
        class="button button--sm"
      >
        Set to 270°
      </.action>
    </div>
    <.angle_slider id={@id} class="angle-slider" value={90.0} marker_values={marker_values()}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def api_set_value_server_heex do
    ~S"""
    <.action phx-click="api_set_value" value="0" class="button button--sm">Server: 0°</.action>
    <.action phx-click="api_set_value" value="90" class="button button--sm">Server: 90°</.action>
    <.action phx-click="api_set_value" value="180" class="button button--sm">Server: 180°</.action>
    <.action phx-click="api_set_value" value="270" class="button button--sm">Server: 270°</.action>
    """
  end

  def api_set_value_server_elixir do
    ~S"""
    def handle_event("api_set_value", %{"value" => value}, socket) do
      angle =
        case Float.parse(to_string(value)) do
          {num, _} -> num
          :error -> 0.0
        end

      {:noreply, Corex.AngleSlider.set_value(socket, "api-angle-slider", angle)}
    end
    """
  end

  def api_set_value_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={@event} value="0" class="button button--sm">Server: 0°</.action>
      <.action phx-click={@event} value="90" class="button button--sm">Server: 90°</.action>
      <.action phx-click={@event} value="180" class="button button--sm">Server: 180°</.action>
      <.action phx-click={@event} value="270" class="button button--sm">Server: 270°</.action>
    </div>
    <.angle_slider id={@id} class="angle-slider" value={90.0} marker_values={marker_values()}>
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def events_on_value_change_server_heex do
    ~S"""
    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      on_value_change="angle_slider_changed"
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def events_on_value_change_end_server_heex do
    ~S"""
    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      value={90.0}
      on_value_change_end="angle_slider_change_ended"
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def events_on_value_change_client_heex do
    ~S"""
    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      on_value_change_client="angle-slider-changed"
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def events_on_value_change_end_client_heex do
    ~S"""
    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      value={90.0}
      on_value_change_end_client="angle-slider-change-ended"
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def events_server_heex do
    ~S"""
    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      on_value_change="angle_slider_changed"
    >
      <:label>on change</:label>
    </.angle_slider>

    <.angle_slider
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      value={90.0}
      on_value_change_end="angle_slider_change_ended"
    >
      <:label>on end</:label>
    </.angle_slider>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"angle_slider_changed", ~S|%{"id" => id, "value" => value} = params|},
      {"angle_slider_change_ended", ~S|%{"id" => id, "value" => value} = params|}
    ])
  end

  def events_client_heex do
    ~S"""
    <.angle_slider
      id="events-angle-slider-on-value-change-client"
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      on_value_change_client="angle-slider-changed"
    >
      <:label>on_value_change_client</:label>
    </.angle_slider>

    <.angle_slider
      id="events-angle-slider-on-value-change-end-client"
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      value={90.0}
      on_value_change_end_client="angle-slider-change-ended"
    >
      <:label>on_value_change_end_client</:label>
    </.angle_slider>
    """
  end

  def events_client_js do
    ~S"""
    const a = document.getElementById("events-angle-slider-on-value-change-client");
    const b = document.getElementById("events-angle-slider-on-value-change-end-client");
    a?.addEventListener("angle-slider-changed", (event) => console.log(event.detail));
    b?.addEventListener("angle-slider-change-ended", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    type Detail = { id: string; value: number; valueAsDegree?: number; dragging?: boolean };
    const a = document.getElementById("events-angle-slider-on-value-change-client");
    const b = document.getElementById("events-angle-slider-on-value-change-end-client");
    a?.addEventListener("angle-slider-changed", (event: Event) => console.log((event as CustomEvent<Detail>).detail));
    b?.addEventListener("angle-slider-change-ended", (event: Event) => console.log((event as CustomEvent<Detail>).detail));
    """
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={angle_slider} assign={@angle_slider}>
      <:loading>
        <.angle_slider_skeleton class="angle-slider" />
      </:loading>

      <.angle_slider
        id={@id_async}
        class="angle-slider"
        value={angle_slider.value}
        marker_values={[0.0, 90.0, 180.0, 270.0]}
      >
        <:label>Angle</:label>
      </.angle_slider>
    </.async_result>
    """
  end

  def patterns_async_heex_panel do
    ~S"""
    <.async_result :let={angle_slider} assign={@angle_slider}>
      <:loading>
        <.angle_slider_skeleton class="angle-slider" />
      </:loading>

      <.angle_slider value={angle_slider.value} />
    </.async_result>
    """
  end

  def patterns_async_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign(:id_async, "patterns-angle-slider-async")
       |> assign_async(:angle_slider, fn ->
         Process.sleep(1000)
         {:ok, %{angle_slider: %{value: 90.0}}}
       end)}
    end
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.angle_slider
      id={@id_controlled}
      class="angle-slider"
      marker_values={[0.0, 90.0, 180.0, 270.0]}
      controlled
      value={@value}
      on_value_change="patterns_controlled_changed"
    >
      <:label>Angle</:label>
    </.angle_slider>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign(:id_controlled, "patterns-angle-slider-controlled")
       |> assign(:value, 90.0)}
    end

    def handle_event("patterns_controlled_changed", %{"value" => value}, socket) do
      {:noreply, assign(socket, :value, value)}
    end
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.AngleSlider do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :angle, :float, default: 0.0
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:angle])
        |> validate_required([:angle])
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:angle])
        |> validate_required([:angle])
        |> validate_number(:angle,
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
      :let={f}
      for={@phoenix_form}
      action={~p"/angle-slider/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.angle_slider
        field={f[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def angle_slider_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"angle" => "0"}, as: :angle_slider_phoenix, id: "angle-slider-form-phoenix")

      render(conn, :angle_slider_form_page, phoenix_form: phoenix_form)
    end

    def angle_slider_form_submit(conn, params) do
      if is_map(params["angle_slider_phoenix"]) do
        angle = params["angle_slider_phoenix"]["angle"] || ""

        conn
        |> put_flash(:info, "Submitted: angle=#{inspect(angle)}")
        |> redirect(to: ~p"/angle-slider/form#angle-slider-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.angle_slider
        field={@phoenix_form[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/angle-slider/form"}
      method="post"
      id={@form.id}
          >
      <.angle_slider
        field={f[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action type="submit" class="button button--accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def product_form_page(conn, _params) do
      changeset = MyApp.Forms.AngleSlider.changeset(%MyApp.Forms.AngleSlider{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :angle_slider,
          id: "product-angle-form"
        )

      render(conn, :product_form, form: form)
    end

    def product_form_create(conn, %{"angle_slider" => params}) do
      case MyApp.Forms.AngleSlider.changeset(%MyApp.Forms.AngleSlider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved angle=#{data.angle}")
          |> redirect(to: ~p"/products")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :angle_slider,
              id: "product-angle-form"
            )

          render(conn, :product_form, form: form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/angle-slider/form"}
      method="post"
      id={@form.id}
          >
      <.angle_slider
        field={f[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action type="submit" class="button button--accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def product_form_validated_page(conn, _params) do
      changeset =
        MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :angle_slider_validated,
          id: "product-angle-validated-form"
        )

      render(conn, :product_form_validated, form: form)
    end

    def product_form_validated_create(conn, %{"angle_slider_validated" => params}) do
      case MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved angle=#{data.angle}")
          |> redirect(to: ~p"/products")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :angle_slider_validated,
              id: "product-angle-validated-form"
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
      id={@form.id}
      phx-change="validate_angle"
      phx-submit="save_angle"
          >
      <.angle_slider
        field={@form[:angle]}
        marker_values={[0, 90, 180, 270]}
        on_value_change="angle_changed"
        class="angle-slider"
      >
        <:label>Angle</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action type="submit" class="button button--accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      changeset = MyApp.Forms.AngleSlider.changeset(%MyApp.Forms.AngleSlider{}, %{})

      {:ok,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset, as: :angle_slider, id: "live-product-angle-form")
       )}
    end

    def handle_event("validate_angle", %{"angle_slider" => params}, socket) do
      changeset =
        %MyApp.Forms.AngleSlider{}
        |> MyApp.Forms.AngleSlider.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :angle_slider,
           id: "live-product-angle-form"
         )
       )}
    end

    def handle_event("angle_changed", %{"value" => value}, socket) do
      params = %{"angle" => to_string(value)}

      changeset =
        %MyApp.Forms.AngleSlider{}
        |> MyApp.Forms.AngleSlider.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :angle_slider,
           id: "live-product-angle-form"
         )
       )}
    end

    def handle_event("save_angle", %{"angle_slider" => params}, socket) do
      case MyApp.Forms.AngleSlider.changeset(%MyApp.Forms.AngleSlider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset, as: :angle_slider, id: "live-product-angle-form")
           )}

        changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :angle_slider,
               id: "live-product-angle-form"
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
      id={@form.id}
      phx-change="validate_angle_range"
      phx-submit="save_angle_range"
          >
      <.angle_slider
        field={@form[:angle]}
        marker_values={[0, 90, 180, 270]}
        on_value_change="angle_range_changed"
        class="angle-slider"
      >
        <:label>Angle (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action type="submit" class="button button--accent">Submit</:action>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      changeset =
        MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, %{})

      {:ok,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           as: :angle_slider_validated,
           id: "live-product-angle-validated-form"
         )
       )}
    end

    def handle_event("validate_angle_range", %{"angle_slider_validated" => params}, socket) do
      changeset =
        %MyApp.Forms.AngleSlider{}
        |> MyApp.Forms.AngleSlider.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :angle_slider_validated,
           id: "live-product-angle-validated-form"
         )
       )}
    end

    def handle_event("angle_range_changed", %{"value" => value}, socket) do
      params = %{"angle" => to_string(value)}

      changeset =
        %MyApp.Forms.AngleSlider{}
        |> MyApp.Forms.AngleSlider.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(socket, :form,
         Phoenix.Component.to_form(changeset,
           action: :validate,
           as: :angle_slider_validated,
           id: "live-product-angle-validated-form"
         )
       )}
    end

    def handle_event("save_angle_range", %{"angle_slider_validated" => params}, socket) do
      case MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               as: :angle_slider_validated,
               id: "live-product-angle-validated-form"
             )
           )}

        changeset ->
          {:noreply,
           assign(socket, :form,
             Phoenix.Component.to_form(changeset,
               action: :insert,
               as: :angle_slider_validated,
               id: "live-product-angle-validated-form"
             )
           )}
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form
      action={~p"/angle-slider/form"}
      method="post"
          >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.angle_slider
        name="product[angle]"
        value={0.0}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" class="button button--accent">Submit</:action>
    </form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/angle-slider/form"}
      method="post"
      id={@form.id}
    >
      <.angle_slider
        field={f[:angle]}
        id="angle-slider-form-changeset-angle"
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action
        type="submit"
        id="angle-slider-form-changeset-submit"
        class="button button--accent"
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
      action={~p"/angle-slider/form"}
      method="post"
      id={@form.id}
    >
      <.angle_slider
        field={f[:angle]}
        id="angle-slider-form-validate-angle"
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action
        type="submit"
        id="angle-slider-form-validate-submit"
        class="button button--accent"
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
      action={~p"/angle-slider/form"}
      method="post"
      id="angle-slider-plain-form"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.angle_slider
        name="angle_slider_form[angle]"
        id="angle-slider-form-angle"
        value={0.0}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" id="angle-slider-form-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:angle_value, :float, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_basic"
      phx-submit="save_basic"
    >
      <.angle_slider
        id="angle-slider-live-form-changeset-angle"
        field={@form[:angle]}
        value={@angle_value}
        marker_values={[0, 90, 180, 270]}
        on_value_change="angle_changed_basic"
        class="angle-slider"
      >
        <:label>Angle</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action
        type="submit"
        id="angle-slider-live-form-changeset-submit"
        class="button button--accent"
      >
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)
  attr(:angle_value, :float, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_validate"
      phx-submit="save_validate"
    >
      <.angle_slider
        id="angle-slider-live-form-validate-angle"
        field={@form[:angle]}
        value={@angle_value}
        marker_values={[0, 90, 180, 270]}
        on_value_change="angle_changed_validate"
        class="angle-slider"
      >
        <:label>Angle (0–90)</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.action
        type="submit"
        id="angle-slider-live-form-validate-submit"
        class="button button--accent"
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

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/angle-slider/form"}
      method="post"
      id={@form.id}
    >
      <.angle_slider
        field={f[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" class="button button--accent">Submit</.action>
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
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.angle_slider
        field={@form[:angle]}
        marker_values={[0, 90, 180, 270]}
        class="angle-slider"
      >
        <:label>Angle</:label>
      </.angle_slider>
      <.action type="submit" class="button button--accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.AngleSliderFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"angle" => "0"}, as: :angle_slider_phoenix, id: "angle-slider-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"angle_slider_phoenix" => params}, socket) do
        angle = params["angle"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"angle" => angle}, as: :angle_slider_phoenix, id: "angle-slider-live-form-phoenix")
         )}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.AngleSliderFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.AngleSlider{}
          |> MyApp.Forms.AngleSlider.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :angle_slider_ecto, id: "angle-slider-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"angle_slider_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.AngleSlider{}
          |> MyApp.Forms.AngleSlider.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :angle_slider_ecto,
             id: "angle-slider-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"angle_slider_ecto" => params}, socket) do
        case MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.AngleSlider.changeset_validate(%MyApp.Forms.AngleSlider{}, params),
                 as: :angle_slider_ecto,
                 id: "angle-slider-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :angle_slider_ecto,
                 id: "angle-slider-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end


end
