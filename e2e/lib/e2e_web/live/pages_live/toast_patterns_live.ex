defmodule E2eWeb.ToastPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToastDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      {%{}, %{title: :string, message: :string, type: :string, duration: :integer}}
      |> Ecto.Changeset.change(%{
        title: "Toast Title",
        message: "Toast Message",
        type: "info",
        duration: 5000
      })

    {:ok, assign(socket, :form, to_form(changeset, as: :toast))}
  end

  @impl true
  def handle_event("create_toast", %{"value" => value}, socket) do
    {:noreply,
     Corex.Toast.push_toast(
       socket,
       "layout-toast",
       "This is an info toast",
       "This is an info toast description",
       String.to_atom(value),
       5000
     )}
  end

  @impl true
  def handle_event("create_flash", params, socket) do
    duration =
      if params["toast"]["duration"] == "0" do
        :infinity
      else
        String.to_integer(params["toast"]["duration"])
      end

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
       "layout-toast",
       params["toast"]["title"],
       params["toast"]["message"],
       String.to_atom(params["toast"]["type"]),
       duration
     )
     |> assign(:form, to_form(changeset, as: :toast))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="toast-patterns-page"
        title="Toast · Pattern"
        subtitle="Form submit, client bindings, and server push on one page."
      >
        <.demo_section
          id="toast-patterns-form"
          title="Phoenix form"
          code={Demo.patterns_form_code()}
        >
          <:preview>
            <.form
              for={@form}
              as={:toast}
              phx-submit="create_flash"
              class="w-full max-w-md flex flex-col gap-space"
              id={Corex.Form.get_form_id(@form)}
            >
              <.native_input
                field={@form[:title]}
                type="text"
                placeholder="Enter flash title"
                required
              >
                <:label>Title</:label>
              </.native_input>
              <.native_input
                field={@form[:message]}
                type="text"
                placeholder="Enter flash message"
                required
              >
                <:label>Message</:label>
              </.native_input>
              <.select
                class="select"
                field={@form[:type]}
                placeholder="Select flash type"
                items={[
                  %{label: "Info", id: "info"},
                  %{label: "Error", id: "error"},
                  %{label: "Success", id: "success"}
                ]}
              >
                <:label>Type</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
              </.select>
              <.native_input
                field={@form[:duration]}
                type="number"
                placeholder="Enter flash duration"
                required
                value={5000}
              >
                <:label>Duration</:label>
              </.native_input>
              <footer class="flex w-full justify-end gap-2">
                <.action type="submit" class="button button--accent">Create Flash Message</.action>
              </footer>
            </.form>
          </:preview>
        </.demo_section>

        <.demo_section
          id="toast-patterns-client"
          title="Client bindings"
          code={Demo.patterns_client_actions_code()}
        >
          <:preview>
            <div class="layout__row flex-wrap">
              <.action
                phx-click={
                  Corex.Toast.create_toast(
                    "layout-toast",
                    "This is an info toast",
                    "This is an info toast description",
                    :info,
                    []
                  )
                }
                class="button"
              >
                Create Info Toast
              </.action>
              <.action
                phx-click={
                  Corex.Toast.create_toast(
                    "layout-toast",
                    "This is a success toast",
                    "This is a success toast description",
                    :success,
                    []
                  )
                }
                class="button"
              >
                Success Toast
              </.action>
              <.action
                phx-click={
                  Corex.Toast.create_toast(
                    "layout-toast",
                    "This is a error toast",
                    "This is a error toast description",
                    :error,
                    []
                  )
                }
                class="button"
              >
                Error Toast
              </.action>
              <.action
                phx-click={
                  Corex.Toast.create_toast(
                    "layout-toast",
                    "This is a loading toast",
                    "This is a loading toast description",
                    :loading,
                    duration: :infinity
                  )
                }
                class="button"
              >
                Create Loading
              </.action>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="toast-patterns-server"
          title="Server event"
          code={Demo.api_push_toast_server_elixir()}
        >
          <:preview>
            <div class="layout__row">
              <.action phx-click="create_toast" value="info" class="button button--sm">
                Create info
              </.action>
              <.action phx-click="create_toast" value="success" class="button button--sm">
                Create success
              </.action>
              <.action phx-click="create_toast" value="error" class="button button--sm">
                Create error
              </.action>
              <.action phx-click="create_toast" value="loading" class="button button--sm">
                Create loading
              </.action>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
