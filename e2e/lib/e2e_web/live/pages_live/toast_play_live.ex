defmodule E2eWeb.ToastPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @toast_form_id "toast-playground-form"

  @type_items [
    %{label: "Info", value: "info"},
    %{label: "Success", value: "success"},
    %{label: "Error", value: "error"}
  ]

  @toast_types ~w(info success error)

  @toast_field_types %{
    title: :string,
    message: :string,
    type: :string,
    duration: :string,
    loading: :boolean
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
        duration: "5000",
        loading: false
      })

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :toast, id: @toast_form_id))
     |> assign(:type_items, @type_items)}
  end

  @impl true
  def handle_event("validate_toast", %{"toast" => params}, socket) do
    params = normalize_toast_params(params)

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.cast(params, @toast_fields)

    {:noreply,
     assign(socket, :form, to_form(changeset, as: :toast, action: :validate, id: @toast_form_id))}
  end

  @impl true
  def handle_event("create_toast", %{"toast" => params}, socket) do
    params = normalize_toast_params(params)

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.cast(params, @toast_fields)
      |> Ecto.Changeset.validate_required(@toast_fields)
      |> Ecto.Changeset.validate_inclusion(:type, @toast_types)
      |> validate_toast_duration()

    if changeset.valid? do
      socket = push_layout_toast(socket, changeset)
      next_changeset = toast_form_changeset_after_success(changeset)

      {:noreply,
       socket
       |> put_flash(:info, "Toast pushed to the shell group.")
       |> assign(:form, to_form(next_changeset, as: :toast, id: @toast_form_id))}
    else
      {:noreply,
       assign(socket, :form, to_form(changeset, as: :toast, action: :insert, id: @toast_form_id))}
    end
  end

  @impl true
  def handle_event("create_toast", _, socket) do
    {:noreply, put_flash(socket, :error, "Missing toast params.")}
  end

  defp normalize_toast_params(params) do
    normalize_field_param(params, "duration")
  end

  defp normalize_field_param(params, key) do
    case Map.get(params, key) do
      nil ->
        params

      v ->
        s = v |> to_string() |> String.trim()

        if s == "",
          do: Map.delete(params, key),
          else: Map.put(params, key, s)
    end
  end

  defp toast_form_changeset_after_success(cs) do
    applied = Ecto.Changeset.apply_changes(cs)

    {%{}, @toast_field_types}
    |> Ecto.Changeset.change(%{
      title: Map.fetch!(applied, :title),
      message: Map.fetch!(applied, :message),
      type: Map.fetch!(applied, :type),
      duration: applied |> Map.fetch!(:duration) |> to_string(),
      loading: Map.fetch!(applied, :loading)
    })
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
    loading? = Ecto.Changeset.get_field(changeset, :loading)
    {dur_int, _} = Integer.parse(to_string(Ecto.Changeset.get_field(changeset, :duration)))
    duration = if dur_int == 0, do: :infinity, else: dur_int

    type_atom = toast_type_atom(ty)
    opts = if loading?, do: [loading: true], else: []

    Corex.Toast.create(
      socket,
      "layout-toast",
      title,
      message,
      type_atom,
      Keyword.merge([duration: duration], opts)
    )
  end

  defp toast_type_atom("success"), do: :success
  defp toast_type_atom("error"), do: :error
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
              id={@form.id}
              phx-change="validate_toast"
              phx-submit="create_toast"
              class="flex flex-col gap-space"
            >
              <.native_input field={@form[:title]} type="text" class="native-input w-full" required>
                <:label>Title</:label>
              </.native_input>
              <.native_input field={@form[:message]} type="text" class="native-input w-full" required>
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
                id="toast-playground-duration"
                field={@form[:duration]}
                class="number-input w-full"
                min={0.0}
                step={1.0}
                required
              >
                <:label>Duration</:label>
                <:decrement_trigger>
                  <.heroicon name="hero-chevron-down" class="icon" />
                </:decrement_trigger>
                <:increment_trigger>
                  <.heroicon name="hero-chevron-up" class="icon" />
                </:increment_trigger>
              </.number_input>
              <.switch field={@form[:loading]} class="switch">
                <:label>Loading</:label>
              </.switch>
              <footer class="flex w-full justify-end">
                <.action type="submit" class="button button--accent">Create toast</.action>
              </footer>
            </.form>
          </div>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
