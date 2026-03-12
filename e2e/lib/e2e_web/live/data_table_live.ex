defmodule E2eWeb.DataTableLive do
  use E2eWeb, :live_view

  @list_rows [
    %{id: 1, name: "Alice", role: "Admin", email: "alice@example.com"},
    %{id: 2, name: "Bob", role: "User", email: "bob@example.com"},
    %{id: 3, name: "Charlie", role: "Editor", email: "charlie@example.com"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :list_rows, @list_rows)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Data Table</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Basic Example</h3>
      <.data_table id="basic-table" class="data-table" rows={@list_rows}>
        <:col :let={row} label="ID">{row.id}</:col>
        <:col :let={row} label="Name">{row.name}</:col>
        <:col :let={row} label="Role">{row.role}</:col>
        <:col :let={row} label="Email">{row.email}</:col>
        <:action :let={row}>
          <.action class="button button--sm" aria-label={"Edit #{row.name}"}>
            <.heroicon name="hero-pencil-square" />
          </.action>
        </:action>
      </.data_table>
    </Layouts.app>
    """
  end
end
