defmodule E2eWeb.Demos.LayoutHeadingDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--accent">
        <:title>Accent</:title>
        <:subtitle>Semantic accent on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--brand">
        <:title>Brand</:title>
        <:subtitle>Semantic brand on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--alert">
        <:title>Alert</:title>
        <:subtitle>Semantic alert on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--success">
        <:title>Success</:title>
        <:subtitle>Semantic success on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      <.layout_heading class="layout-heading layout-heading--info">
        <:title>Info</:title>
        <:subtitle>Semantic info on title and subtitle.</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
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
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--accent">
      <:title>Accent</:title>
      <:subtitle>Semantic accent on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--brand">
      <:title>Brand</:title>
      <:subtitle>Semantic brand on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--alert">
      <:title>Alert</:title>
      <:subtitle>Semantic alert on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--success">
      <:title>Success</:title>
      <:subtitle>Semantic success on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    <.layout_heading class="layout-heading layout-heading--info">
      <:title>Info</:title>
      <:subtitle>Semantic info on title and subtitle.</:subtitle>
      <:actions>
        <.action type="button" class="button button--sm">Save</.action>
        <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
      </:actions>
    </.layout_heading>
    """
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(assigns, :max_width_variants, DemoScales.max_width_variants("layout-heading"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo typo--sm font-medium">{variant.label}</p>
        <.layout_heading class={DemoScales.join_modifiers("layout-heading", variant.modifier)}>
          <:title>Layout heading</:title>
          <:subtitle>{variant.label}</:subtitle>
          <:actions>
            <.action type="button" class="button button--sm">Save</.action>
            <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
          </:actions>
        </.layout_heading>
      </div>
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("layout-heading")
    |> Enum.map(fn %{label: label, modifier: modifier} ->
      class = DemoScales.join_modifiers("layout-heading", modifier)

      """
      <.layout_heading class="#{class}">
        <:title>Layout heading</:title>
        <:subtitle>#{label}</:subtitle>
        <:actions>
          <.action type="button" class="button button--sm">Save</.action>
          <.action type="button" class="button button--sm button--variant-ghost">Cancel</.action>
        </:actions>
      </.layout_heading>
      """
    end)
    |> DemoScales.join_code()
  end
end
