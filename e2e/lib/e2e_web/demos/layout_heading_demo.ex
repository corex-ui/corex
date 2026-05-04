defmodule E2eWeb.Demos.LayoutHeadingDemo do
  use E2eWeb, :html

  def title_only_code do
    ~S"""
    <.layout_heading>
      <:title>Page Title</:title>
    </.layout_heading>
    """
  end

  def title_only_example(assigns) do
    ~H"""
    <.layout_heading>
      <:title>Page Title</:title>
    </.layout_heading>
    """
  end

  def title_and_subtitle_code do
    ~S"""
    <.layout_heading>
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
    </.layout_heading>
    """
  end

  def title_and_subtitle_example(assigns) do
    ~H"""
    <.layout_heading>
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
    </.layout_heading>
    """
  end

  def with_actions_code do
    ~S"""
    <.layout_heading>
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
      <:actions>
        <.navigate to={~p"/"} type="href" class="button">
          <.heroicon name="hero-arrow-left" class="icon" /> Back
        </.navigate>
      </:actions>
    </.layout_heading>
    """
  end

  def with_actions_example(assigns) do
    ~H"""
    <.layout_heading>
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
      <:actions>
        <.navigate to={~p"/"} type="href" class="button">
          <.heroicon name="hero-arrow-left" class="icon" /> Back
        </.navigate>
      </:actions>
    </.layout_heading>
    """
  end

  def styling_wrapper_code do
    ~S"""
    <.layout_heading class="layout-heading">
      <:title>Full width</:title>
      <:subtitle>Default spacing from the layout-heading stylesheet.</:subtitle>
    </.layout_heading>
    """
  end

  def styling_wrapper_example(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>Full width</:title>
      <:subtitle>Default spacing from the layout-heading stylesheet.</:subtitle>
    </.layout_heading>
    """
  end

  def styling_constrained_code do
    ~S"""
    <.layout_heading class="layout-heading max-w-3xl mx-auto">
      <:title>Constrained width</:title>
      <:subtitle>Combine utility classes on the same element as the component root.</:subtitle>
    </.layout_heading>
    """
  end

  def styling_constrained_example(assigns) do
    ~H"""
    <.layout_heading class="layout-heading max-w-3xl mx-auto">
      <:title>Constrained width</:title>
      <:subtitle>Combine utility classes on the same element as the component root.</:subtitle>
    </.layout_heading>
    """
  end
end
