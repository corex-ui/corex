defmodule E2eWeb.Demos.ActionDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def anatomy_minimal_snippets do
    E2eWeb.AuthoringSnippet.snippets(:action, [], inner: "Text")
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.action>Text</.action>
    """
  end

  def anatomy_minimal_markup_example(assigns) do
    ~H"""
    <.action>Text</.action>
    """
  end

  def anatomy_with_icon_snippets do
    E2eWeb.AuthoringSnippet.snippets(:action, [],
      inner: "Text and icon <.heroicon name=\"hero-arrow-right\" />"
    )
  end

  def anatomy_with_icon_example(assigns) do
    ~H"""
    <.action>
      Text and icon <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_with_icon_markup_example(assigns) do
    ~H"""
    <.action>
      Text and icon <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def anatomy_icon_only_snippets do
    E2eWeb.AuthoringSnippet.snippets(:action,
      [shape: "square", aria_label: "Square icon button"],
      inner: ~s(<.heroicon name="hero-arrow-right" />)
    )
  end

  def anatomy_icon_only_example(assigns) do
    ~H"""
    <.row gap="sm">
      <.action shape="square" aria_label="Square icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action shape="square" radius="full" aria_label="Circle icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </.row>
    """
  end

  def anatomy_icon_only_markup_example(assigns) do
    ~H"""
    <.row gap="sm">
      <.action aria_label="Square icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action aria_label="Circle icon button">
        <.heroicon name="hero-arrow-right" />
      </.action>
    </.row>
    """
  end

  def patterns_type_code do
    ~S"""
    <.form for={%{}} as={:demo} phx-submit="noop">
      <.action  type="button">Button</.action>
      <.action semantic="accent" type="submit">Submit</.action>
      <.action variant="ghost" type="reset">Reset</.action>
    </.form>
    """
  end

  def patterns_type_example(assigns) do
    ~H"""
    <.form for={%{}} as={:action_type_demo} phx-submit="noop">
      <.row gap="sm">
        <.action type="button">Button</.action>
        <.action semantic="accent" type="submit">Submit</.action>
        <.action variant="ghost" type="reset">Reset</.action>
      </.row>
    </.form>
    """
  end

  def patterns_phx_click_code do
    ~S"""
    <.action
      phx-click={
        Corex.Toast.create("layout-toast", "Clicked", "phx-click with Corex.Toast.create/5", :info,
          duration: 5000
        )
      }
      size="sm"
    >
      Show toast
    </.action>
    """
  end

  def patterns_phx_click_example(assigns) do
    ~H"""
    <.action
      phx-click={
        Corex.Toast.create(
          "layout-toast",
          "Clicked",
          "phx-click with Corex.Toast.create/5",
          :info,
          duration: 5000
        )
      }
      size="sm"
    >
      Show toast
    </.action>
    """
  end

  def patterns_phx_click_js_code do
    ~S"""
    <.action
      phx-click={Corex.Dialog.set_open("action-patterns-dialog", true)}
      size="sm"
    >
      Open dialog
    </.action>

    <.dialog id="action-patterns-dialog"  >
      <:trigger class="hidden">Open</:trigger>
      <:title>Dialog</:title>
      <:content>
        <p>Opened from an action with phx-click and a Corex JS command.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  def patterns_phx_click_js_example(assigns) do
    ~H"""
    <.action
      phx-click={Corex.Dialog.set_open("action-patterns-dialog", true)}
      size="sm"
    >
      Open dialog
    </.action>

    <.dialog id="action-patterns-dialog">
      <:trigger class="hidden">Open</:trigger>
      <:title>Dialog</:title>
      <:content>
        <p>Opened from an action with phx-click and a Corex JS command.</p>
      </:content>
      <:close_trigger>
        <.heroicon name="hero-x-mark" />
      </:close_trigger>
    </.dialog>
    """
  end

  @styling_matrix_variants ~w(solid ghost outline subtle)

  @styling_matrix_semantics [
    {"Default", nil},
    {"Accent", "accent"},
    {"Brand", "brand"},
    {"Alert", "alert"},
    {"Info", "info"},
    {"Success", "success"}
  ]

  def styling_variant_semantic_code do
    ~S"""
    <.action variant="solid">Default</.action>
    <.action variant="solid" semantic="accent">Accent</.action>
    <.action variant="solid" semantic="brand">Brand</.action>
    <.action variant="solid" semantic="alert">Alert</.action>
    <.action variant="solid" semantic="info">Info</.action>
    <.action variant="solid" semantic="success">Success</.action>

    <.action variant="ghost">Default</.action>
    <.action variant="ghost" semantic="accent">Accent</.action>
    <.action variant="ghost" semantic="brand">Brand</.action>
    <.action variant="ghost" semantic="alert">Alert</.action>
    <.action variant="ghost" semantic="info">Info</.action>
    <.action variant="ghost" semantic="success">Success</.action>

    <.action variant="outline">Default</.action>
    <.action variant="outline" semantic="accent">Accent</.action>
    <.action variant="outline" semantic="brand">Brand</.action>
    <.action variant="outline" semantic="alert">Alert</.action>
    <.action variant="outline" semantic="info">Info</.action>
    <.action variant="outline" semantic="success">Success</.action>

    <.action variant="subtle">Default</.action>
    <.action variant="subtle" semantic="accent">Accent</.action>
    <.action variant="subtle" semantic="brand">Brand</.action>
    <.action variant="subtle" semantic="alert">Alert</.action>
    <.action variant="subtle" semantic="info">Info</.action>
    <.action variant="subtle" semantic="success">Success</.action>
    """
  end

  def styling_variant_semantic_example(assigns) do
    assigns =
      assign(assigns,
        variants: @styling_matrix_variants,
        semantics: @styling_matrix_semantics
      )

    ~H"""
    <.stack gap="lg">
      <.stack :for={variant <- @variants} gap="sm">
        <.small>{variant}</.small>
        <.row gap="sm" wrap="wrap">
          <.action :for={{label, semantic} <- @semantics} variant={variant} semantic={semantic}>
            {label}
          </.action>
        </.row>
      </.stack>
    </.stack>
    """
  end

  def styling_variant_semantic_values do
    "Variants: #{styling_axis_values(:variant)} · Semantics: default, #{styling_axis_values(:semantic)}"
  end

  def styling_size_code do
    ~S"""
    <.action size="sm">Small</.action>
    <.action >Medium</.action>
    <.action size="lg">Large</.action>
    <.action size="xl">XL</.action>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <.row gap="sm" align="center">
      <.action size="sm">Small</.action>
      <.action>Medium</.action>
      <.action size="lg">Large</.action>
      <.action size="xl">XLarge</.action>
    </.row>
    """
  end

  def styling_radius_code do
    ~S"""
    <.action radius="none">None</.action>
    <.action radius="sm">SM</.action>
    <.action radius="md">MD</.action>
    <.action radius="lg">LG</.action>
    <.action radius="xl">XL</.action>
    <.action radius="full">Full</.action>
    """
  end

  def styling_radius_example(assigns) do
    ~H"""
    <.row gap="sm" align="center" wrap="wrap">
      <.action radius="none">None</.action>
      <.action radius="sm">SM</.action>
      <.action radius="md">MD</.action>
      <.action radius="lg">LG</.action>
      <.action radius="xl">XL</.action>
      <.action radius="full">Full</.action>
    </.row>
    """
  end

  def styling_shape_code do
    ~S"""
    <.action shape="square" aria_label="Square button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    <.action shape="square" radius="full" aria_label="Circle button">
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_shape_example(assigns) do
    ~H"""
    <.row gap="sm" align="center">
      <.action shape="square" aria_label="Square button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action shape="square" radius="full" aria_label="Circle button">
        <.heroicon name="hero-arrow-right" />
      </.action>
      <.action shape="square" aria_label="Square letter">B</.action>
      <.action shape="square" radius="full" aria_label="Circle letter">B</.action>
    </.row>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.action  disabled>Disabled</.action>
    <.action semantic="accent" disabled>Disabled</.action>
    <.action shape="square" aria_label="Disabled" disabled>
      <.heroicon name="hero-arrow-right" />
    </.action>
    """
  end

  def styling_disabled_example(assigns) do
    ~H"""
    <.row gap="sm" align="center">
      <.action disabled>Disabled</.action>
      <.action semantic="accent" disabled>Disabled</.action>
      <.action shape="square" aria_label="Disabled" disabled>
        <.heroicon name="hero-arrow-right" />
      </.action>
    </.row>
    """
  end

  @link_styling_variants ~w(solid ghost subtle)

  def styling_link_code do
    ~S"""
    <.action as="link" variant="solid">Default</.action>
    <.action as="link" variant="solid" semantic="accent">Accent</.action>
    <.action as="link" variant="solid" semantic="brand">Brand</.action>
    <.action as="link" variant="solid" semantic="alert">Alert</.action>

    <.action as="link" variant="ghost">Default</.action>
    <.action as="link" variant="ghost" semantic="accent">Accent</.action>
    <.action as="link" variant="ghost" semantic="brand">Brand</.action>
    <.action as="link" variant="ghost" semantic="alert">Alert</.action>

    <.action as="link" variant="subtle">Default</.action>
    <.action as="link" variant="subtle" semantic="accent">Accent</.action>
    <.action as="link" variant="subtle" semantic="brand">Brand</.action>
    <.action as="link" variant="subtle" semantic="alert">Alert</.action>

    <.action as="link" size="sm">Small</.action>
    <.action as="link">Medium</.action>
    <.action as="link" size="lg">Large</.action>
    """
  end

  def styling_link_example(assigns) do
    assigns =
      assign(assigns,
        variants: @link_styling_variants,
        semantics: Enum.take(@styling_matrix_semantics, 5)
      )

    ~H"""
    <.stack gap="lg">
      <.stack :for={variant <- @variants} gap="sm">
        <.small>{variant}</.small>
        <.row gap="sm" wrap="wrap">
          <.action
            :for={{label, semantic} <- @semantics}
            as="link"
            variant={variant}
            semantic={semantic}
          >
            {label}
          </.action>
        </.row>
      </.stack>
      <.stack gap="sm">
        <.small>Size</.small>
        <.row gap="sm" align="center">
          <.action as="link" size="sm">Small</.action>
          <.action as="link">Medium</.action>
          <.action as="link" size="lg">Large</.action>
        </.row>
      </.stack>
    </.stack>
    """
  end

  def styling_link_values do
    "as=\"link\" · Variants: #{Enum.join(@link_styling_variants, ", ")} · Semantics: default, accent, brand, alert · Sizes: sm, md, lg"
  end
end
