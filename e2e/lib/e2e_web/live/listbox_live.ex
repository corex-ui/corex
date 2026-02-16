defmodule E2eWeb.ListboxLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Listbox</h1>
        <h2>Live View</h2>
      </div>
      <.listbox
        id="my-listbox"
        collection={
          Corex.List.new([[label: "A", id: "a"], [label: "B", id: "b"], [label: "C", id: "c"]])
        }
        class="listbox"
      >
        <:label>Choose</:label>
      </.listbox>
    </Layouts.app>
    """
  end
end
