defmodule E2eWeb.Demos.DataListDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.data_list class="data-list">
      <:item title="Full name">Alice</:item>
      <:item title="Nationality">Polish–French</:item>
      <:item title="Field">Physics & Chemistry</:item>
      <:item title="Nobel Prizes">2</:item>
    </.data_list>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.data_list class="data-list">
      <:item title="Full name">Alice</:item>
      <:item title="Nationality">Polish–French</:item>
      <:item title="Field">Physics & Chemistry</:item>
      <:item title="Nobel Prizes">2</:item>
    </.data_list>
    """
  end

  def anatomy_rich_values_code do
    ~S"""
    <.data_list class="data-list">
      <:item title="Account">
        <span class="flex items-center gap-2">
          <.heroicon name="hero-user-circle" class="icon" /> alice@example.com
        </span>
      </:item>
      <:item title="Plan"><span class="tag tag--blue">Pro</span></:item>
      <:item title="Status"><span class="tag tag--green">Active</span></:item>
      <:item title="Actions">
        <span class="flex gap-2">
          <.action class="button button--sm">Edit</.action>
          <.action class="button button--sm button--red">Suspend</.action>
        </span>
      </:item>
    </.data_list>
    """
  end

  def anatomy_rich_values_example(assigns) do
    ~H"""
    <.data_list class="data-list">
      <:item title="Account">
        <span class="flex items-center gap-2">
          <.heroicon name="hero-user-circle" class="icon" /> alice@example.com
        </span>
      </:item>
      <:item title="Plan"><span class="tag tag--blue">Pro</span></:item>
      <:item title="Status"><span class="tag tag--green">Active</span></:item>
      <:item title="Actions">
        <span class="flex gap-2">
          <.action class="button button--sm">Edit</.action>
          <.action class="button button--sm button--red">Suspend</.action>
        </span>
      </:item>
    </.data_list>
    """
  end

  def api_items_code do
    ~S"""
    <.data_list
      class="data-list"
      items={
        Corex.DataList.Item.new([
          %{title: "Repository", value: "corex-ui/corex"},
          %{title: "Visibility", value: "Public"},
          %{title: "Default branch", value: "main"},
          %{title: "Last commit", value: "3 minutes ago"}
        ])
      }
    />
    """
  end

  def api_items_example(assigns) do
    ~H"""
    <.data_list
      class="data-list"
      items={
        Corex.DataList.Item.new([
          %{title: "Repository", value: "corex-ui/corex"},
          %{title: "Visibility", value: "Public"},
          %{title: "Default branch", value: "main"},
          %{title: "Last commit", value: "3 minutes ago"}
        ])
      }
    />
    """
  end
end
