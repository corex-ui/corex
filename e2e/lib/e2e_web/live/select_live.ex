defmodule E2eWeb.SelectLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Select</h1>
        <h2>Live View</h2>
      </div>
      <.select
        id="my-select"
        class="select"
        placeholder_text="Select a country"
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
      </.select>

      <h3>Grouped</h3>
      <.select
        class="select"
        placeholder_text="Select a country"
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
      </.select>

      <h3>Extended</h3>
      <.select
        class="select"
        placeholder_text="Select a country"
        collection={[
          %{label: "France", id: "fra"},
          %{label: "Belgium", id: "bel"},
          %{label: "Germany", id: "deu"},
          %{label: "Netherlands", id: "nld"},
          %{label: "Switzerland", id: "che"},
          %{label: "Austria", id: "aut"}
        ]}
      >
        <:label>
          Country of residence
        </:label>
        <:item :let={item}>
          <Flagpack.flag name={String.to_atom(item.id)} />
          {item.label}
        </:item>
        <:trigger>
          <.icon name="hero-chevron-down" />
        </:trigger>
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.select>

      <h3>Extended Grouped</h3>
      <.select
        class="select"
        placeholder_text="Select a country"
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
        <:item_indicator>
          <.icon name="hero-check" />
        </:item_indicator>
      </.select>
    </Layouts.app>
    """
  end
end
