defmodule E2eWeb.Demos.QrCodeDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.qr_code class="qr-code" value="https://github.com/corex-ui/corex">
      <:overlay>
        <img src="/images/tech/elixir.svg" alt="Corex" />
      </:overlay>
    </.qr_code>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.qr_code id="qr-code-anatomy-minimal" class="qr-code" value="https://github.com/corex-ui/corex">
      <:overlay>
        <img src="/images/tech/elixir.svg" alt="Corex" />
      </:overlay>
    </.qr_code>
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.qr_code class="qr-code" />
    <.qr_code class="qr-code ui-accent" />
    <.qr_code class="qr-code ui-brand" />
    <.qr_code class="qr-code ui-alert" />
    <.qr_code class="qr-code ui-success" />
    <.qr_code class="qr-code ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.qr_code id="qr-code-style-default" class="qr-code" />
      <.qr_code id="qr-code-style-accent" class="qr-code ui-accent" />
      <.qr_code id="qr-code-style-brand" class="qr-code ui-brand" />
      <.qr_code id="qr-code-style-alert" class="qr-code ui-alert" />
      <.qr_code id="qr-code-style-success" class="qr-code ui-success" />
      <.qr_code id="qr-code-style-info" class="qr-code ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.qr_code class="qr-code ui-size-sm" />
    <.qr_code class="qr-code ui-size-md" />
    <.qr_code class="qr-code ui-size-lg" />
    <.qr_code class="qr-code ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.qr_code id="qr-code-style-size-sm" class="qr-code ui-size-sm" />
      <.qr_code id="qr-code-style-size-md" class="qr-code ui-size-md" />
      <.qr_code id="qr-code-style-size-lg" class="qr-code ui-size-lg" />
      <.qr_code id="qr-code-style-size-xl" class="qr-code ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.qr_code class="qr-code ui-rounded-none" />
    <.qr_code class="qr-code ui-rounded-sm" />
    <.qr_code class="qr-code ui-rounded-md" />
    <.qr_code class="qr-code ui-rounded-lg" />
    <.qr_code class="qr-code ui-rounded-xl" />
    <.qr_code class="qr-code ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.qr_code id="qr-code-style-r-none" class="qr-code ui-rounded-none" />
      <.qr_code id="qr-code-style-r-sm" class="qr-code ui-rounded-sm" />
      <.qr_code id="qr-code-style-r-md" class="qr-code ui-rounded-md" />
      <.qr_code id="qr-code-style-r-lg" class="qr-code ui-rounded-lg" />
      <.qr_code id="qr-code-style-r-xl" class="qr-code ui-rounded-xl" />
      <.qr_code id="qr-code-style-r-full" class="qr-code ui-rounded-full" />
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("qr-code")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("qr-code", modifier)
      ~s(<.qr_code class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("qr-code"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.qr_code
        :for={step <- @width_variants}
        id={"qr-code-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("qr-code", step.modifier)}
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("qr-code")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("qr-code", modifier)
      ~s(<.qr_code class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("qr-code") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.qr_code
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("qr-code", step.modifier)}
      />
    </div>
    """
  end
end
