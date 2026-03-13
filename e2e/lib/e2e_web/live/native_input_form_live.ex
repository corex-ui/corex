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
        message = "Submitted: #{NativeInputProfile.format_for_toast(data)}"

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
      <.layout_heading>
        <:title>NativeInput form</:title>
        <:subtitle>Live View Form</:subtitle>
      </.layout_heading>
      <p>Phoenix form with Ecto changeset and native inputs</p>

      <.form
        for={@form}
        phx-change="validate"
        phx-submit="save"
      >
        <.native_input
          field={@form[:name]}
          type="text"
          id="native-input-form-name"
          placeholder="Your name"
          class="native-input"
        >
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:email]}
          type="email"
          id="native-input-form-email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:bio]}
          type="textarea"
          id="native-input-form-bio"
          placeholder="Short bio"
          class="native-input"
        >
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:birth_date]}
          type="date"
          id="native-input-form-birth-date"
          placeholder="Choose date"
          class="native-input"
        >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:datetime]}
          type="datetime-local"
          id="native-input-form-datetime"
          class="native-input"
        >
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:reminder_time]}
          type="time"
          id="native-input-form-reminder-time"
          placeholder="Choose time"
          class="native-input"
        >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:month]}
          type="month"
          id="native-input-form-month"
          class="native-input"
        >
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:week]}
          type="week"
          id="native-input-form-week"
          class="native-input"
        >
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:website]}
          type="url"
          id="native-input-form-website"
          placeholder="https://example.com"
          class="native-input"
        >
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:phone]}
          type="tel"
          id="native-input-form-phone"
          placeholder="+1 234 567 8900"
          class="native-input"
        >
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:q]}
          type="search"
          id="native-input-form-q"
          placeholder="Search"
          class="native-input"
        >
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:color]}
          type="color"
          id="native-input-form-color"
          value="#3b82f6"
          class="native-input"
        >
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:count]}
          type="number"
          id="native-input-form-count"
          min={0}
          max={100}
          step={1}
          class="native-input"
        >
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:password]}
          type="password"
          id="native-input-form-password"
          class="native-input"
        >
          <:label>Password</:label>
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
        <.native_input
          field={@form[:size]}
          type="radio"
          id="native-input-form-size"
          value="m"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:agree]}
          type="checkbox"
          id="native-input-form-agree"
          class="native-input"
        >
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
