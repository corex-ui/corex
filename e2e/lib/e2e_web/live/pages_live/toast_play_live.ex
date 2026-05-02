defmodule E2eWeb.ToastPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @type_items [
    %{label: "Info", id: "info"},
    %{label: "Success", id: "success"},
    %{label: "Error", id: "error"},
    %{label: "Loading", id: "loading"}
  ]

  @toast_types ~w(info success error loading)

  @toast_field_types %{
    title: :string,
    message: :string,
    type: :string,
    duration: :string
  }

  @toast_fields Map.keys(@toast_field_types)

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      {%{}, @toast_field_types}
      |> Ecto.Changeset.change(%{
        title: "Saved",
        message: "From the playground form.",
        type: "info",
        duration: "5000"
      })

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :toast))
     |> assign(:type_items, @type_items)}
  end

  @impl true
  def handle_event("validate_toast", %{"toast" => params}, socket) do
    changeset =
      {%{}, @toast_field_types}
      |> Ecto.Changeset.cast(params, @toast_fields)

    {:noreply, assign(socket, :form, to_form(changeset, as: :toast, action: :validate))}
  end

  @impl true
  def handle_event("create_toast", %{"toast" => params}, socket) do
    changeset =
      {%{}, @toast_field_types}
      |> Ecto.Changeset.cast(params, @toast_fields)
      |> Ecto.Changeset.validate_required(@toast_fields)
      |> Ecto.Changeset.validate_inclusion(:type, @toast_types)
      |> validate_toast_duration()

    if changeset.valid? do
      socket = push_layout_toast(socket, changeset)

      {:noreply,
       socket
       |> put_flash(:info, "Toast pushed to the shell group.")
       |> assign(:form, to_form(changeset, as: :toast))}
    else
      {:noreply, assign(socket, :form, to_form(changeset, as: :toast, action: :insert))}
    end
  end

  @impl true
  def handle_event("create_toast", _, socket) do
    {:noreply, put_flash(socket, :error, "Missing toast params.")}
  end

  defp validate_toast_duration(changeset) do
    Ecto.Changeset.validate_change(changeset, :duration, fn :duration, raw ->
      case Integer.parse(to_string(raw)) do
        {n, _} when n >= 0 -> []
        _ -> [duration: "use a non-negative integer, or 0 for infinite"]
      end
    end)
  end

  defp push_layout_toast(socket, changeset) do
    title = Ecto.Changeset.get_field(changeset, :title)
    message = Ecto.Changeset.get_field(changeset, :message)
    ty = Ecto.Changeset.get_field(changeset, :type)
    {dur_int, _} = Integer.parse(to_string(Ecto.Changeset.get_field(changeset, :duration)))
    duration = if dur_int == 0, do: :infinity, else: dur_int

    case ty do
      "loading" ->
        Corex.Toast.push_toast(
          socket,
          "layout-toast",
          title,
          message,
          :loading,
          duration,
          loading: true
        )

      other ->
        type_atom = toast_type_atom(other)
        Corex.Toast.push_toast(socket, "layout-toast", title, message, type_atom, duration)
    end
  end

  defp toast_type_atom("success"), do: :success
  defp toast_type_atom("error"), do: :error
  defp toast_type_atom("loading"), do: :loading
  defp toast_type_atom(_), do: :info

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        id="toast-playground"
        title="Toast · Playground"
        heading_class="layout-heading"
        controls_strip={false}
      >
        <:canvas>
          <div class="flex w-full max-w-lg flex-col gap-size">
            <.form
              for={@form}
              id="toast-playground-form"
              phx-change="validate_toast"
              phx-submit="create_toast"
              class="flex flex-col gap-space"
            >
              <.native_input field={@form[:title]} type="text" required>
                <:label>Title</:label>
              </.native_input>
              <.native_input field={@form[:message]} type="text" required>
                <:label>Message</:label>
              </.native_input>
              <.select
                class="select select--accent w-full"
                field={@form[:type]}
                items={@type_items}
              >
                <:label>Type</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
              </.select>
              <.number_input
                field={@form[:duration]}
                class="number-input"
                min={0.0}
                step={1.0}
                required
              >
                <:label>Duration (ms, 0 = infinite)</:label>
                <:decrement_trigger>
                  <.heroicon name="hero-chevron-down" class="icon" />
                </:decrement_trigger>
                <:increment_trigger>
                  <.heroicon name="hero-chevron-up" class="icon" />
                </:increment_trigger>
              </.number_input>
              <footer class="flex w-full justify-end">
                <.action type="submit" class="button button--accent">Create toast</.action>
              </footer>
            </.form>
            <.toast_group id="toast-play-preview" class="toast" placement="bottom-end" flash={%{}}>
              <:loading>
                <.heroicon name="hero-arrow-path" class="icon" />
              </:loading>
            </.toast_group>
          </div>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
