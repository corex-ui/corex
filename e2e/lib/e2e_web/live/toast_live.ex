defmodule E2eWeb.ToastLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    changeset =
      {%{}, %{title: :string, message: :string, type: :string, duration: :integer}}
      |> Ecto.Changeset.change(%{
        title: "Toast Title",
        message: "Toast Message",
        type: "info",
        duration: 5000
      })

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :toast))}
  end

  def handle_event("create_toast", %{"value" => value}, socket) do
    {:noreply,
     Corex.Toast.push_toast(
       socket,
       "This is an info toast",
       "This is an info toast description",
       String.to_atom(value)
     )}
  end

  def handle_event("create_flash", params, socket) do
    duration =
      if params["toast"]["duration"] == "0" do
        :infinity
      else
        String.to_integer(params["toast"]["duration"])
      end

    IO.inspect(duration, label: "label")

    changeset =
      {%{}, %{title: :string, message: :string, type: :string, duration: :integer}}
      |> Ecto.Changeset.change(%{
        title: params["toast"]["title"],
        message: params["toast"]["message"],
        type: params["toast"]["type"],
        duration: params["toast"]["duration"]
      })
      |> Ecto.Changeset.cast(params, [:title, :message, :type, :duration])
      |> Ecto.Changeset.validate_required([:title, :message, :type])

    {:noreply,
     socket
     |> Corex.Toast.push_toast(
       params["toast"]["title"],
       params["toast"]["message"],
       String.to_atom(params["toast"]["type"]),
       duration
     )
     |> assign(form: to_form(changeset, as: :toast))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode}>
      <div class="layout__row">
        <h1>Toast</h1>
        <h2>Live View</h2>
      </div>

      <h3>Create Toast</h3>
      <.form
        for={@form}
        as={:toast}
        phx-submit="create_flash"
        id={get_form_id(@form)}
        class="flex flex-col gap-ui max-w-md"
      >
        <.input
          field={@form[:title]}
          type="text"
          label="Title"
          placeholder="Enter flash title"
          required
        />
        <.input
          field={@form[:message]}
          type="text"
          label="Message"
          placeholder="Enter flash message"
          required
        />

        <.select
          class="select"
          field={@form[:type]}
          placeholder="Select flash type"
          collection={[
            %{label: "Info", id: "info"},
            %{label: "Error", id: "error"},
            %{label: "Success", id: "success"}
          ]}
        >
          <:label>Type</:label>
          <:trigger>
            <.icon name="hero-chevron-down" />
          </:trigger>
        </.select>

        <.input
          field={@form[:duration]}
          type="number"
          label="Duration"
          placeholder="Enter flash duration"
          required
          value={5000}
        />

        <footer class="flex w-full justify-end gap-ui-gap">
          <.button class="button button--accent">Create Flash Message</.button>
        </footer>
      </.form>

      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is an info toast",
              "This is an info toast description",
              :info
            )
          }
          class="button"
        >
          Create Info Toast
        </button>

        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a success toast",
              "This is a success toast description",
              :success
            )
          }
          class="button"
        >
          Succes Toast
        </button>
        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a error toast",
              "This is a error toast description",
              :error
            )
          }
          class="button"
        >
          Error Toast
        </button>

        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a loading toast",
              "This is a loading toast description",
              :loading,
              duration: :infinity
            )
          }
          class="button"
        >
          Create Loading
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="create_toast" value={:info} class="button button--sm">
          Create info
        </button>
        <button phx-click="create_toast" value={:success} class="button button--sm">
          Create success
        </button>
        <button phx-click="create_toast" value={:error} class="button button--sm">
          Create error
        </button>
        <button phx-click="create_toast" value={:loading} class="button button--sm">
          Create loading
        </button>
      </div>
    </Layouts.app>
    """
  end
end
