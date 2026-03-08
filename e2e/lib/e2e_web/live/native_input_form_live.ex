defmodule E2eWeb.NativeInputFormLive do
  use E2eWeb, :live_view

  alias E2e.Form.NativeInputProfile
  alias Corex.Toast

  @tag_options [
    "Elixir": "elixir",
    Phoenix: "phoenix",
    LiveView: "liveview",
    Ecto: "ecto",
    OTP: "otp"
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "NativeInput form")
     |> assign(:tag_options, @tag_options)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form =
      %NativeInputProfile{}
      |> NativeInputProfile.changeset(%{})
      |> Phoenix.Component.to_form(as: :profile, id: "profile")

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
        message = "Submitted: name=#{data.name}, agree=#{data.agree}, tags=#{inspect(data.tags)}"

        {:noreply,
         socket
         |> Toast.push_toast("layout-toast", "Submitted", message, :info, 5000)
         |> assign(
           :form,
           Phoenix.Component.to_form(NativeInputProfile.changeset(%NativeInputProfile{}, params),
             as: :profile
           )
         )}

      %Ecto.Changeset{} = changeset ->
        {:noreply,
         socket
         |> assign(
           :form,
           Phoenix.Component.to_form(changeset, action: :insert, as: :profile, id: "profile")
         )}
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
        <.native_input
          field={@form[:tags]}
          type="select"
          multiple
          id="native-input-form-tags"
          options={@tag_options}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
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
    </Layouts.app>
    """
  end
end
