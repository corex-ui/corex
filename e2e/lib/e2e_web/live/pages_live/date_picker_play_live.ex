defmodule E2eWeb.DatePickerPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @locales [
    %{value: "en-US", label: "English (US)"},
    %{value: "ar", label: "Arabic"},
    %{value: "ja-JP", label: "Japanese"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      disabled: false,
      invalid: false,
      read_only: false,
      dir: "ltr",
      locale: "en-US",
      selection_mode: "single",
      max_selected_dates: nil
    }

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:value, nil)
     |> assign(:locale_options, @locales)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  def handle_event("play_value", %{"id" => _, "value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  defp update_control(socket, "disabled", true),
    do: update(socket, :controls, &%{&1 | disabled: true})

  defp update_control(socket, "disabled", false),
    do: update(socket, :controls, &Map.put(&1, :disabled, false))

  defp update_control(socket, "invalid", v),
    do: update(socket, :controls, &Map.put(&1, :invalid, v))

  defp update_control(socket, "read_only", v),
    do: update(socket, :controls, &Map.put(&1, :read_only, v))

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "locale", value) when is_binary(value),
    do: update(socket, :controls, &Map.put(&1, :locale, value))

  defp update_control(socket, "selection_mode", value) when is_binary(value),
    do: update(socket, :controls, &Map.put(&1, :selection_mode, value))

  defp update_control(socket, "max_selected_dates", "unlimited"),
    do: update(socket, :controls, &Map.put(&1, :max_selected_dates, nil))

  defp update_control(socket, "max_selected_dates", value) when is_binary(value) do
    case Integer.parse(value) do
      {n, ""} when n > 0 -> update(socket, :controls, &Map.put(&1, :max_selected_dates, n))
      _ -> socket
    end
  end

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
      <.demo_playground path={@path} title="Date Picker · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.switch
            class="switch switch--sm"
            id="disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
          <.switch
            class="switch switch--sm"
            id="read_only"
            checked={@controls.read_only}
            on_checked_change="control_changed"
          >
            <:label>Read only</:label>
          </.switch>
          <.switch
            class="switch switch--sm"
            id="invalid"
            checked={@controls.invalid}
            on_checked_change="control_changed"
          >
            <:label>Invalid</:label>
          </.switch>

          <.select
            class="select select--sm w-4xs"
            id="locale"
            value={[@controls.locale]}
            deselectable={false}
            items={@locale_options}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Locale"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            <:label>Locale</:label>
          </.select>

          <.select
            class="select select--sm w-4xs"
            id="selection_mode"
            value={[@controls.selection_mode]}
            deselectable={false}
            items={[
              %{value: "single", label: "Single"},
              %{value: "multiple", label: "Multiple"},
              %{value: "range", label: "Range"}
            ]}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Selection"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            <:label>Selection mode</:label>
          </.select>

          <.select
            :if={@controls.selection_mode == "multiple"}
            class="select select--sm w-4xs"
            id="max_selected_dates"
            value={[
              if @controls.max_selected_dates == nil do
                "unlimited"
              else
                to_string(@controls.max_selected_dates)
              end
            ]}
            deselectable={false}
            items={[
              %{value: "unlimited", label: ~t"Unlimited days"},
              %{value: "1", label: ~t"Max 1 day"},
              %{value: "2", label: ~t"Max 2 days"},
              %{value: "3", label: ~t"Max 3 days"},
              %{value: "5", label: ~t"Max 5 days"}
            ]}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Max selected"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
            <:label>Multiple cap</:label>
          </.select>
        </:controls>
        <:canvas>
          <.date_picker
            id="date-picker-playground"
            translation={
              %Corex.DatePicker.Translation{
                open_calendar: "Select date",
                close_calendar: "Select date",
                input: "Select date"
              }
            }
            class="date-picker"
            dir={@controls.dir}
            locale={@controls.locale}
            selection_mode={@controls.selection_mode}
            max_selected_dates={@controls.max_selected_dates}
            value={@value && [@value]}
            disabled={@controls.disabled}
            read_only={@controls.read_only}
            invalid={@controls.invalid}
            on_value_change="play_value"
          >
            <:label>Select a date</:label>
            <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
            <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
            <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
          </.date_picker>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
