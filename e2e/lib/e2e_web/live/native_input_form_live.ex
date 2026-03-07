defmodule E2eWeb.NativeInputFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.NativeInputProfile
  alias Corex.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "NativeInput form")
     |> assign(:submitted, nil)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(%{})
      |> Phoenix.Component.to_form(as: :profile)

    assign(socket, :form, form)
  end

  @impl true
  def handle_event("validate", %{"profile" => params}, socket) do
    changeset =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, Phoenix.Component.to_form(changeset, action: :validate, as: :profile))}
  end

  @impl true
  def handle_event("save", %{"profile" => params}, socket) do
    case NativeInputProfile.changeset(%NativeInputProfile{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        {:noreply,
         socket
         |> assign(:submitted, %{
           name: data.name,
           email: data.email,
           birth_date: data.birth_date,
           reminder_time: data.reminder_time,
           role: data.role,
           agree: data.agree
         })
         |> assign(
           :form,
           Phoenix.Component.to_form(NativeInputProfile.changeset(%NativeInputProfile{}, params),
             as: :profile
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(:form, Phoenix.Component.to_form(changeset, action: :insert, as: :profile))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <h1>NativeInput form (LiveView)</h1>
      <p>Phoenix form with Ecto changeset and native inputs</p>

      <.form
        for={@form}
        id={Form.get_form_id(@form)}
        phx-change="validate"
        phx-submit="save"
      >
        <.native_input field={@form[:name]} type="text" placeholder="Your name" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:email]}
          type="email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:birth_date]}
          type="date"
          placeholder="Choose date"
          class="native-input"
        >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:reminder_time]}
          type="time"
          placeholder="Choose time"
          class="native-input"
        >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:role]}
          type="select"
          id="native-input-form-role"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:agree]} type="checkbox" class="native-input">
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.action type="submit" id="native-input-form-live-submit" class="button button--accent">
          Submit
        </.action>
      </.form>

      <div :if={@submitted} id="native-input-form-result">
        <p>
          Submitted: name={@submitted.name}, email={@submitted.email}, role={@submitted.role}, agree={@submitted.agree}
        </p>
      </div>
    </Layouts.app>
    """
  end
end
