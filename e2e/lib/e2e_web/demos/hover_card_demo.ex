defmodule E2eWeb.Demos.HoverCardDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.hover_card class="hover-card" show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card id="hover-card-anatomy-minimal" class="hover-card" show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_with_arrow_code do
    ~S"""
    <.hover_card class="hover-card">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_with_arrow_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card id="hover-card-anatomy-arrow" class="hover-card">
      <:trigger>Hover me</:trigger>
      <:content>Preview content</:content>
    </.hover_card>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <.hover_card class="hover-card" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Card below</:content>
    </.hover_card>
    """
  end

  def anatomy_placement_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card
      id="hover-card-anatomy-placement"
      class="hover-card"
      positioning={%Corex.Positioning{placement: "bottom"}}
    >
      <:trigger>Bottom</:trigger>
      <:content>Card below</:content>
    </.hover_card>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click={Corex.HoverCard.set_open("hover-card-api-cb", true)} class="button ui-size-sm">
        Open
      </.action>
      <.hover_card id="hover-card-api-cb" class="hover-card">
        <:trigger>Target</:trigger>
        <:content>Opened from binding</:content>
      </.hover_card>
    </div>
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space-sm">
      <.action phx-click="hover_card_api_open" class="button ui-size-sm">Open</.action>
      <.hover_card id="hover-card-api-srv" class="hover-card">
        <:trigger>Target</:trigger>
        <:content>Opened from server</:content>
      </.hover_card>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <.hover_card id="hover-card-style-accent" class="hover-card ui-accent">
      <:trigger>Accent</:trigger>
      <:content>Accent panel</:content>
    </.hover_card>
    """
  end
end
