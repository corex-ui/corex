defmodule E2eWeb.Demos.ScrollAreaDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.scroll_area class="scroll-area" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.scroll_area id="scroll-area-anatomy-minimal" class="scroll-area" />
    """
  end

  alias E2eWeb.DemoScales
  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area class="scroll-area">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-accent">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-brand">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-alert">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-success">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-info">
      <p>Long content</p>
    </.scroll_area>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area id="scroll-area-style-default" class="scroll-area">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-accent" class="scroll-area ui-accent">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-brand" class="scroll-area ui-brand">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-alert" class="scroll-area ui-alert">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-success" class="scroll-area ui-success">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-info" class="scroll-area ui-info">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    </div>
    """
  end
  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area class="scroll-area ui-size-sm">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-size-md">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-size-lg">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-size-xl">
      <p>Long content</p>
    </.scroll_area>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area id="scroll-area-style-size-sm" class="scroll-area ui-size-sm">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-size-md" class="scroll-area ui-size-md">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-size-lg" class="scroll-area ui-size-lg">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-size-xl" class="scroll-area ui-size-xl">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    </div>
    """
  end
  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area class="scroll-area ui-rounded-none">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-rounded-sm">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-rounded-md">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-rounded-lg">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-rounded-xl">
      <p>Long content</p>
    </.scroll_area>
    <.scroll_area class="scroll-area ui-rounded-full">
      <p>Long content</p>
    </.scroll_area>
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.scroll_area id="scroll-area-style-r-none" class="scroll-area ui-rounded-none">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-r-sm" class="scroll-area ui-rounded-sm">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-r-md" class="scroll-area ui-rounded-md">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-r-lg" class="scroll-area ui-rounded-lg">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-r-xl" class="scroll-area ui-rounded-xl">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    <.scroll_area id="scroll-area-style-r-full" class="scroll-area ui-rounded-full">
      <p :for={n <- 1..12}>Line {n} — scroll content for the overlay thumb.</p>
    </.scroll_area>
    </div>
    """
  end
  def styling_max_width_code do
    DemoScales.max_width_variants("scroll-area")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("scroll-area", modifier)
      ~s(<.scroll_area class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("scroll-area") |> Enum.take(4))

    ~H"""
    <div class="flex flex-col gap-space">
      <.scroll_area
        :for={step <- @max_width_variants}
        
        class={DemoScales.join_modifiers("scroll-area", step.modifier)}
        
      >
<p :for={n <- 1..8}>Line {n}</p>
      </.scroll_area>
    </div>
    """
  end

end
