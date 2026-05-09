defmodule E2eWeb.Demos.LayoutHeadingDemo do
  use E2eWeb, :html

  def title_only_code do
    ~S"""
    <.layout_heading class="layout-heading">
      <:title>Page Title</:title>
    </.layout_heading>
    """
  end

  def title_only_example(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>Page Title</:title>
    </.layout_heading>
    """
  end

  def title_and_subtitle_code do
    ~S"""
    <.layout_heading class="layout-heading">
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
    </.layout_heading>
    """
  end

  def title_and_subtitle_example(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>Page Title</:title>
      <:subtitle>Controller View</:subtitle>
    </.layout_heading>
    """
  end

  def with_actions_code do
    ~S"""
    <.layout_heading class="layout-heading">
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
    <.layout_heading class="layout-heading">
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

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-size w-full">
      <.layout_heading class="layout-heading">
        <:title>Default</:title>
        <:subtitle>Neutral ink on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--accent">
        <:title>Accent</:title>
        <:subtitle>Semantic accent on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--brand">
        <:title>Brand</:title>
        <:subtitle>Semantic brand on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--alert">
        <:title>Alert</:title>
        <:subtitle>Semantic alert on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--success">
        <:title>Success</:title>
        <:subtitle>Semantic success on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--info">
        <:title>Info</:title>
        <:subtitle>Semantic info on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.layout_heading class="layout-heading">
      <:title>Default</:title>
      <:subtitle>Neutral ink on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--accent">
      <:title>Accent</:title>
      <:subtitle>Semantic accent on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--brand">
      <:title>Brand</:title>
      <:subtitle>Semantic brand on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--alert">
      <:title>Alert</:title>
      <:subtitle>Semantic alert on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--success">
      <:title>Success</:title>
      <:subtitle>Semantic success on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--info">
      <:title>Info</:title>
      <:subtitle>Semantic info on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    """
  end

  def styling_max_width_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-size w-full items-center">
      <.layout_heading class="layout-heading max-w-xs">
        <:title>Narrow</:title>
        <:subtitle>max-w-xs</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading max-w-md">
        <:title>Medium block</:title>
        <:subtitle>max-w-md</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading max-w-xl">
        <:title>Wide block</:title>
        <:subtitle>max-w-xl</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading max-w-2xl">
        <:title>Extra wide</:title>
        <:subtitle>max-w-2xl</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
    </div>
    """
  end

  def styling_max_width_code do
    ~S"""
    <.layout_heading class="layout-heading max-w-xs">
      <:title>Narrow</:title>
      <:subtitle>max-w-xs</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading max-w-md">
      <:title>Medium block</:title>
      <:subtitle>max-w-md</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading max-w-xl">
      <:title>Wide block</:title>
      <:subtitle>max-w-xl</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading max-w-2xl">
      <:title>Extra wide</:title>
      <:subtitle>max-w-2xl</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    """
  end
end
