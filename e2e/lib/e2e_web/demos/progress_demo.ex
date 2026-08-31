defmodule E2eWeb.Demos.ProgressDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.progress class="progress" value={40} />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.progress id="progress-anatomy-linear" class="progress" value={40} />
    """
  end

  def anatomy_circular_code do
    ~S"""
    <.progress class="progress" variant="circular" value={65} />
    """
  end

  def anatomy_circular_example(assigns) do
    _ = assigns

    ~H"""
    <.progress id="progress-anatomy-circular" class="progress" variant="circular" value={65} />
    """
  end

  def anatomy_loading_code do
    ~S"""
    <.progress class="progress" value={nil} />
    """
  end

  def anatomy_loading_example(assigns) do
    _ = assigns

    ~H"""
    <.progress id="progress-anatomy-loading" class="progress" value={nil} />
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.progress class="progress" />
    <.progress class="progress ui-accent" />
    <.progress class="progress ui-brand" />
    <.progress class="progress ui-alert" />
    <.progress class="progress ui-success" />
    <.progress class="progress ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.progress id="progress-style-default" class="progress" />
      <.progress id="progress-style-accent" class="progress ui-accent" />
      <.progress id="progress-style-brand" class="progress ui-brand" />
      <.progress id="progress-style-alert" class="progress ui-alert" />
      <.progress id="progress-style-success" class="progress ui-success" />
      <.progress id="progress-style-info" class="progress ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.progress class="progress ui-size-sm" />
    <.progress class="progress ui-size-md" />
    <.progress class="progress ui-size-lg" />
    <.progress class="progress ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.progress id="progress-style-size-sm" class="progress ui-size-sm" />
      <.progress id="progress-style-size-md" class="progress ui-size-md" />
      <.progress id="progress-style-size-lg" class="progress ui-size-lg" />
      <.progress id="progress-style-size-xl" class="progress ui-size-xl" />
      <.progress id="progress-style-size-circular" class="progress ui-size-lg" variant="circular" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.progress class="progress ui-rounded-none" />
    <.progress class="progress ui-rounded-sm" />
    <.progress class="progress ui-rounded-md" />
    <.progress class="progress ui-rounded-lg" />
    <.progress class="progress ui-rounded-xl" />
    <.progress class="progress ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.progress id="progress-style-r-none" class="progress ui-rounded-none" />
      <.progress id="progress-style-r-sm" class="progress ui-rounded-sm" />
      <.progress id="progress-style-r-md" class="progress ui-rounded-md" />
      <.progress id="progress-style-r-lg" class="progress ui-rounded-lg" />
      <.progress id="progress-style-r-xl" class="progress ui-rounded-xl" />
      <.progress id="progress-style-r-full" class="progress ui-rounded-full" />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("progress")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("progress", modifier)
      ~s(<.progress class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("progress") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.progress
        :for={step <- @max_width_variants}
        id={"progress-style-mw-#{step.id}"}
        class={DemoScales.join_modifiers("progress", step.modifier)}
      />
    </div>
    """
  end

  def patterns_server_heex do
    ~S"""
    <.action phx-click="progress_advance" class="button ui-size-sm">Advance</.action>
    <.action phx-click="progress_reset" class="button ui-size-sm">Reset</.action>
    <.progress id="patterns-progress" class="progress" value={@value} />
    """
  end

  def patterns_server_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :value, 20)}
    end

    def handle_event("progress_advance", _params, socket) do
      value = min(socket.assigns.value + 20, 100)

      {:noreply,
       socket
       |> assign(:value, value)
       |> Corex.Progress.set_value("patterns-progress", value)}
    end

    def handle_event("progress_reset", _params, socket) do
      {:noreply,
       socket
       |> assign(:value, 0)
       |> Corex.Progress.set_value("patterns-progress", 0)}
    end
    """
  end
end
