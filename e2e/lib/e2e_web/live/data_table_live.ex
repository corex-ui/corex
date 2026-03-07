defmodule E2eWeb.DataTableLive do
  use E2eWeb, :live_view

  @list_rows [
    %{id: 1, name: "Alice", role: "Admin"},
    %{id: 2, name: "Bob", role: "User"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:list_rows, @list_rows)
     |> stream(:stream_rows, [
       %{id: 10, name: "Stream A", role: "Admin"},
       %{id: 11, name: "Stream B", role: "User"}
     ])}
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
      <h1>DataTable</h1>
      <h2>List</h2>
      <.data_table id="list-table" rows={@list_rows}>
        <:col :let={row} label="ID">{row.id}</:col>
        <:col :let={row} label="Name">{row.name}</:col>
        <:col :let={row} label="Role">{row.role}</:col>
        <:action :let={row}>
          <span data-action={"list-#{row.id}"}>Action</span>
        </:action>
      </.data_table>
      <h2>Stream</h2>
      <.data_table id="stream-table" rows={@streams.stream_rows}>
        <:col :let={{_id, row}} label="ID">{row.id}</:col>
        <:col :let={{_id, row}} label="Name">{row.name}</:col>
        <:col :let={{_id, row}} label="Role">{row.role}</:col>
        <:action :let={{_id, row}}>
          <span data-action={"stream-#{row.id}"}>Action</span>
        </:action>
      </.data_table>
    </Layouts.app>
    """
  end
end
