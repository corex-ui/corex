defmodule E2eWeb.SignaturePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @size_theme_items [
    %{label: "Default", id: "default"},
    %{label: "UI width", id: "ui"},
    %{label: "Mini", id: "mini"},
    %{label: "Micro", id: "micro"},
    %{label: "Accent color", id: "accent"},
    %{label: "Large label", id: "lg_label"}
  ]

  defp pad_classes(%{size_theme: "default"}), do: "signature-pad"
  defp pad_classes(%{size_theme: "ui"}), do: "signature-pad signature-pad--ui"
  defp pad_classes(%{size_theme: "mini"}), do: "signature-pad signature-pad--mini"
  defp pad_classes(%{size_theme: "micro"}), do: "signature-pad signature-pad--micro"

  defp pad_classes(%{size_theme: "accent"}),
    do: "signature-pad signature-pad--accent"

  defp pad_classes(%{size_theme: "lg_label"}),
    do: "signature-pad signature-pad--lg"

  defp pad_classes(_), do: "signature-pad"

  @impl true
  def mount(_params, _session, socket) do
    controls = %{dir: "ltr", size_theme: "default"}

    {:ok, socket |> assign(:controls, controls) |> assign(:size_theme_items, @size_theme_items)}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => "signature-playground-dir"},
        socket
      ) do
    {:noreply, update(socket, :controls, &%{&1 | dir: value})}
  end

  @impl true
  def handle_event(
        "control_changed",
        %{"value" => [value], "id" => "signature-playground-theme"},
        socket
      ) do
    {:noreply, update(socket, :controls, &%{&1 | size_theme: value})}
  end

  @impl true
  def handle_event("draw_end", _payload, socket) do
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
      <.demo_playground title="Signature Pad · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="signature-playground-dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
          <.select
            id="signature-playground-theme"
            class="select select--accent w-4xs"
            value={[@controls.size_theme]}
            deselectable={false}
            items={@size_theme_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Style"}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Style</:label>
          </.select>
        </:controls>
        <:canvas>
          <.signature_pad
            id="signature-playground"
            class={pad_classes(@controls)}
            on_draw_end="draw_end"
            dir={@controls.dir}
          >
            <:label>Sign here</:label>
            <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
          </.signature_pad>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
