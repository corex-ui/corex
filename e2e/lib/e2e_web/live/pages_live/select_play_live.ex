defmodule E2eWeb.SelectPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @playground_countries [
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"},
    %{label: "Netherlands", value: "nld"},
    %{label: "Switzerland", value: "che"},
    %{label: "Austria", value: "aut"}
  ]

  @disabled_select_items Enum.map(@playground_countries, &%{label: &1.label, value: &1.value})

  defp playground_items(controls) do
    disabled = Map.get(controls, :disabled_item_ids, [])

    Corex.List.new(
      Enum.map(@playground_countries, fn c ->
        if c.value in disabled, do: Map.put(c, :disabled, true), else: c
      end)
    )
  end

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      disabled_item_ids: ["fra"]
    }

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:disabled_select_items, @disabled_select_items)
     |> assign(:items, playground_items(controls))
     |> assign(:value, [])}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_item_ids: value})
     |> sync_items()}
  end

  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply,
     socket
     |> update(:controls, &%{&1 | disabled_item_ids: []})
     |> sync_items()}
  end

  defp sync_items(socket) do
    assign(socket, :items, playground_items(socket.assigns.controls))
  end

  defp update_control(socket, "select-playground-disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "select-playground-disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, "select-playground-invalid", v),
    do: update(socket, :controls, &Map.put(&1, :invalid, v))

  defp update_control(socket, "select-playground-read-only", v),
    do: update(socket, :controls, &Map.put(&1, :read_only, v))

  defp update_control(socket, "select-playground-dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, _, _), do: socket

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground path={@path} title="Select · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="select-playground-dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
          <.select
            id="select-playground-disabled-items"
            size="sm"
            class="w-4xs"
            positioning={%Corex.Positioning{same_width: true}}
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_item_ids}
            items={@disabled_select_items}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Disabled items"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>
          <.switch
            size="sm"
            id="select-playground-disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            size="sm"
            id="select-playground-read-only"
            checked={@controls.read_only}
            on_checked_change="control_changed"
          >
            <:label>Read only</:label>
          </.switch>
          <.switch
            size="sm"
            id="select-playground-invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.select
            id="select-playground"
            size="md"
            positioning={%Corex.Positioning{same_width: true}}
            items={@items}
            dir={@controls.dir}
            value={@value}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:item_indicator><.heroicon name="hero-check" /></:item_indicator>
          </.select>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
