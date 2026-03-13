defmodule E2eWeb.DataListLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
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
        <:title>Data List</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>

      <h3>Basic Example</h3>
      <.data_list class="data-list">
        <:item title="Name">Bob</:item>
        <:item title="Role">User</:item>
        <:item title="Email">bob@example.com</:item>
        <:item title="Status">Inactive</:item>
      </.data_list>

      <h3>System Details</h3>
      <.data_list class="data-list mt-4">
        <:item title="OS">Linux</:item>
        <:item title="Version">20.04 LTS</:item>
        <:item title="Uptime">14 days</:item>
        <:item title="Memory Usage">4.2 GB / 16 GB</:item>
      </.data_list>
    </Layouts.app>
    """
  end
end
