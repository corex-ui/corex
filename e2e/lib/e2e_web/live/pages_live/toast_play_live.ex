defmodule E2eWeb.ToastPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @placement_items [
    %{label: "Top start", id: "top-start"},
    %{label: "Top", id: "top"},
    %{label: "Top end", id: "top-end"},
    %{label: "Bottom start", id: "bottom-start"},
    %{label: "Bottom", id: "bottom"},
    %{label: "Bottom end", id: "bottom-end"}
  ]

  @type_items [
    %{label: "Info", id: "info"},
    %{label: "Success", id: "success"},
    %{label: "Error", id: "error"},
    %{label: "Loading", id: "loading"}
  ]

  @toast_types ~w(info success error loading)
  @toast_placements ~w(top-start top top-end bottom-start bottom bottom-end)

  @toast_field_types %{
    title: :string,
    message: :string,
    type: :string,
    duration: :string,
    placement: :string
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
        placement: "bottom-end"
      })

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :toast))
     |> assign(:controls, %{placement: "bottom-end"})
     |> assign(:placement_items, @placement_items)
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
      |> Ecto.Changeset.validate_inclusion(:placement, @toast_placements)
      |> validate_toast_duration()

    if changeset.valid? do
      placement = Ecto.Changeset.get_field(changeset, :placement)

      socket =
        socket
        |> update(:controls, &%{&1 | placement: placement})
        |> push_layout_toast(changeset)

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

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "placement"}, socket) do
    {:noreply, update(socket, :controls, &%{&1 | placement: value})}
  end

  def handle_event("control_changed", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("toast_play_preview", _, socket) do
    {:noreply,
     Corex.Toast.push_toast(
       socket,
       "toast-play-preview",
       "Preview",
       "Placement #{socket.assigns.controls.placement}.",
       :info,
       4000
     )}
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
      >
        <:controls>
          <.select
            id="placement"
            class="select select--accent w-4xs"
            value={[@controls.placement]}
            deselectable={false}
            items={@placement_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Preview placement"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Preview placement</:label>
          </.select>
          <.action phx-click="toast_play_preview" class="button button--sm">
            Preview in slot
          </.action>
        </:controls>
        <:canvas>
          <div class="flex w-full max-w-lg flex-col gap-size">
            <p class="typo-sm text-ink-muted">
              LiveView <span class="font-mono">phx-change</span>
              and <span class="font-mono">phx-submit</span>;
              valid submits call <span class="font-mono">Corex.Toast.push_toast/6</span>
              on the shell group.
              Preview placement applies only to the slot below.
            </p>
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
              <.native_input field={@form[:duration]} type="number" required min={0} step={1}>
                <:label>Duration (ms, 0 = infinite)</:label>
              </.native_input>
              <.select
                class="select select--accent w-full"
                field={@form[:placement]}
                items={@placement_items}
              >
                <:label>Placement (sidebar syncs after submit)</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
              </.select>
              <footer class="flex w-full justify-end">
                <.action type="submit" class="button button--accent">Create toast</.action>
              </footer>
            </.form>
            <.toast_group
              id="toast-play-preview"
              class="toast"
              placement={@controls.placement}
              flash={%{}}
            >
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
