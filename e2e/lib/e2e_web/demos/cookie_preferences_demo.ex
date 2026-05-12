defmodule E2eWeb.Demos.CookiePreferencesDemo do
  def template_code do
    ~S"""
    <.form
      for={@cookie_form}
      id={@cookie_form.id}
      phx-change="validate"
      phx-submit="save_cookies"
      class="home__showcase__form"
    >
      <.switch field={@cookie_form[:analytics]} class="switch">
        <:label>Analytics cookies</:label>
      </.switch>

      <.checkbox field={@cookie_form[:marketing]} class="checkbox">
        <:label>Marketing emails</:label>
      </.checkbox>

      <.select
        field={@cookie_form[:frequency]}
        class="select"
        items={[
          %{label: "Daily",   value: "daily"},
          %{label: "Weekly",  value: "weekly"},
          %{label: "Monthly", value: "monthly"},
          %{label: "Never",   value: "never"}
        ]}
      >
        <:label>Update frequency</:label>
        <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>

      <button type="submit" class="button button--brand">
        Save preferences
        <.heroicon name="hero-sparkles" class="icon" />
      </button>
    </.form>
    """
  end

  def schema_code do
    ~S"""
    defmodule E2e.Form.CookiePreferences do
      use Ecto.Schema
      import Ecto.Changeset

      @frequencies ~w(daily weekly monthly never)

      embedded_schema do
        field :analytics, :boolean, default: false
        field :marketing, :boolean, default: false
        field :frequency, :string,  default: "weekly"
      end

      def changeset(schema, attrs \\ %{}) do
        schema
        |> cast(attrs, [:analytics, :marketing, :frequency])
        |> validate_required([:frequency])
        |> validate_inclusion(:frequency, @frequencies)
      end
    end
    """
  end

  def handler_code do
    ~S"""
    def mount(_params, _session, socket) do
      form =
        %E2e.Form.CookiePreferences{}
        |> E2e.Form.CookiePreferences.changeset(%{})
        |> to_form(as: :cookie_preferences, id: "cookie-preferences-form")

      {:ok, assign(socket, :cookie_form, form)}
    end

    def handle_event("save_cookies", %{"cookie_preferences" => params}, socket) do
      case E2e.Form.CookiePreferences.changeset(%E2e.Form.CookiePreferences{}, params) do
        %Ecto.Changeset{valid?: true} = cs ->
          data = Ecto.Changeset.apply_changes(cs)
          msg  = "analytics=#{data.analytics}, marketing=#{data.marketing}, frequency=#{data.frequency}"

          {:noreply,
           socket
           |> Corex.Toast.push_toast("layout-toast", "Preferences saved", msg, :success, 5000)
           |> assign(:cookie_form, fresh_form())}

        %Ecto.Changeset{} = cs ->
          {:noreply, assign(socket, :cookie_form, to_form(cs, action: :insert, as: :cookie_preferences))}
      end
    end
    """
  end
end
