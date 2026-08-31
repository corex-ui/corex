defmodule E2eWeb.Demos.PresenceDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", true)} class="button ui-size-sm">Show</.action>
    <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", false)} class="button ui-size-sm">Hide</.action>
    <.presence id="presence-anatomy-minimal" class="presence">
      Panel that animates in and out
    </.presence>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-space items-center">
      <div class="flex gap-space-sm">
        <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", true)} class="button ui-size-sm">
          Show
        </.action>
        <.action phx-click={Corex.Presence.set_present("presence-anatomy-minimal", false)} class="button ui-size-sm">
          Hide
        </.action>
      </div>
      <.presence id="presence-anatomy-minimal" class="presence">
        Panel that animates in and out
      </.presence>
    </div>
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.presence class="presence">
      Present
    </.presence>
    <.presence class="presence ui-accent">
      Present
    </.presence>
    <.presence class="presence ui-brand">
      Present
    </.presence>
    <.presence class="presence ui-alert">
      Present
    </.presence>
    <.presence class="presence ui-success">
      Present
    </.presence>
    <.presence class="presence ui-info">
      Present
    </.presence>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.presence id="presence-style-default" class="presence">
        Present
      </.presence>
      <.presence id="presence-style-accent" class="presence ui-accent">
        Present
      </.presence>
      <.presence id="presence-style-brand" class="presence ui-brand">
        Present
      </.presence>
      <.presence id="presence-style-alert" class="presence ui-alert">
        Present
      </.presence>
      <.presence id="presence-style-success" class="presence ui-success">
        Present
      </.presence>
      <.presence id="presence-style-info" class="presence ui-info">
        Present
      </.presence>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.presence class="presence ui-size-sm">
      Present
    </.presence>
    <.presence class="presence ui-size-md">
      Present
    </.presence>
    <.presence class="presence ui-size-lg">
      Present
    </.presence>
    <.presence class="presence ui-size-xl">
      Present
    </.presence>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.presence id="presence-style-size-sm" class="presence ui-size-sm">
        Present
      </.presence>
      <.presence id="presence-style-size-md" class="presence ui-size-md">
        Present
      </.presence>
      <.presence id="presence-style-size-lg" class="presence ui-size-lg">
        Present
      </.presence>
      <.presence id="presence-style-size-xl" class="presence ui-size-xl">
        Present
      </.presence>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.presence class="presence ui-rounded-none">
      Present
    </.presence>
    <.presence class="presence ui-rounded-sm">
      Present
    </.presence>
    <.presence class="presence ui-rounded-md">
      Present
    </.presence>
    <.presence class="presence ui-rounded-lg">
      Present
    </.presence>
    <.presence class="presence ui-rounded-xl">
      Present
    </.presence>
    <.presence class="presence ui-rounded-full">
      Present
    </.presence>
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.presence id="presence-style-r-none" class="presence ui-rounded-none">
        Present
      </.presence>
      <.presence id="presence-style-r-sm" class="presence ui-rounded-sm">
        Present
      </.presence>
      <.presence id="presence-style-r-md" class="presence ui-rounded-md">
        Present
      </.presence>
      <.presence id="presence-style-r-lg" class="presence ui-rounded-lg">
        Present
      </.presence>
      <.presence id="presence-style-r-xl" class="presence ui-rounded-xl">
        Present
      </.presence>
      <.presence id="presence-style-r-full" class="presence ui-rounded-full">
        Present
      </.presence>
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("presence")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("presence", modifier)
      ~s(<.presence class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("presence"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.presence
        :for={step <- @width_variants}
        id={"presence-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("presence", step.modifier)}
      >
        Present
      </.presence>
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("presence")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("presence", modifier)
      ~s(<.presence class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("presence") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.presence
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("presence", step.modifier)}
      >
        Present
      </.presence>
    </div>
    """
  end
end
