defmodule E2eWeb.ComboboxLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    form = to_form(%{})
    {:ok, assign(socket, form: form)}
  end

  def handle_event("handle_open_change", _params, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Combobox</h1>
        <h2>Live View</h2>
      </div>
      <h3>Minimal</h3>
      <.combobox
        id="my-combobox"
        class="combobox"
        placeholder="Select a country"
        on_open_change_client="handle_open_change"
        bubble
        on_open_change="handle_open_change"
        collection={[
          %{label: "France", id: "fra", disabled: true},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
      </.combobox>

      <h3>Grouped</h3>
      <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Netherlands", id: "nld", group: "Europe"},
          %{label: "Switzerland", id: "che", group: "Europe"},
          %{label: "Austria", id: "aut", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"},
          %{label: "Thailand", id: "tha", group: "Asia"},
          %{label: "USA", id: "usa", group: "North America"},
          %{label: "Canada", id: "can", group: "North America"},
          %{label: "Mexico", id: "mex", group: "North America"}
        ]}
      >
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
      </.combobox>

      <h3>Extended</h3>
      <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
          {item.label}
        </:item>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.icon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.combobox>

      <h3>Extended Grouped</h3>
      <.combobox
        class="combobox"
        placeholder="Select a country"
        collection={[
          %{label: "France", id: "fra", group: "Europe"},
          %{label: "Belgium", id: "bel", group: "Europe"},
          %{label: "Germany", id: "deu", group: "Europe"},
          %{label: "Japan", id: "jpn", group: "Asia"},
          %{label: "China", id: "chn", group: "Asia"},
          %{label: "South Korea", id: "kor", group: "Asia"}
        ]}
      >
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
          {item.label}
        </:item>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:clear_trigger>
          <.icon name="hero-backspace" />
        </:clear_trigger>
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.combobox>
    </Layouts.app>
    """
  end
end
