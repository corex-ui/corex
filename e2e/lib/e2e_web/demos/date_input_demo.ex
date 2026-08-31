defmodule E2eWeb.Demos.DateInputDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.date_input class="date-input" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.date_input id="date-input-anatomy-minimal" class="date-input" />
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input" />
    <.date_input class="date-input ui-accent" />
    <.date_input class="date-input ui-brand" />
    <.date_input class="date-input ui-alert" />
    <.date_input class="date-input ui-success" />
    <.date_input class="date-input ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.date_input id="date-input-style-default" class="date-input" />
      <.date_input id="date-input-style-accent" class="date-input ui-accent" />
      <.date_input id="date-input-style-brand" class="date-input ui-brand" />
      <.date_input id="date-input-style-alert" class="date-input ui-alert" />
      <.date_input id="date-input-style-success" class="date-input ui-success" />
      <.date_input id="date-input-style-info" class="date-input ui-info" />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input ui-size-sm" />
    <.date_input class="date-input ui-size-md" />
    <.date_input class="date-input ui-size-lg" />
    <.date_input class="date-input ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.date_input id="date-input-style-size-sm" class="date-input ui-size-sm" />
      <.date_input id="date-input-style-size-md" class="date-input ui-size-md" />
      <.date_input id="date-input-style-size-lg" class="date-input ui-size-lg" />
      <.date_input id="date-input-style-size-xl" class="date-input ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.date_input class="date-input ui-rounded-none" />
    <.date_input class="date-input ui-rounded-sm" />
    <.date_input class="date-input ui-rounded-md" />
    <.date_input class="date-input ui-rounded-lg" />
    <.date_input class="date-input ui-rounded-xl" />
    <.date_input class="date-input ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.date_input id="date-input-style-r-none" class="date-input ui-rounded-none" />
      <.date_input id="date-input-style-r-sm" class="date-input ui-rounded-sm" />
      <.date_input id="date-input-style-r-md" class="date-input ui-rounded-md" />
      <.date_input id="date-input-style-r-lg" class="date-input ui-rounded-lg" />
      <.date_input id="date-input-style-r-xl" class="date-input ui-rounded-xl" />
      <.date_input id="date-input-style-r-full" class="date-input ui-rounded-full" />
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("date-input")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("date-input", modifier)
      ~s(<.date_input class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("date-input"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.date_input
        :for={step <- @width_variants}
        id={"date-input-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("date-input", step.modifier)}
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("date-input")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("date-input", modifier)
      ~s(<.date_input class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("date-input") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.date_input
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("date-input", step.modifier)}
      />
    </div>
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.DateInputForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :born_on, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:born_on])
        |> validate_required([:born_on], message: "can't be blank")
      end
    end
    """
  end

  def form_phoenix_heex do
    ~S"""
    <.form for={@form} action={~p"/date-input/form"} method="post" class="flex flex-col gap-space">
      <.date_input class="date-input" name="date_phoenix[born_on]" />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_phoenix_elixir do
    ~S"""
    def date_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"born_on" => ""}, as: :date_phoenix, id: "date-input-form-phoenix")

      render(conn, :date_input_form_page, phoenix_form: phoenix_form)
    end
    """
  end

  def form_ecto_heex, do: form_phoenix_heex()

  def form_ecto_elixir do
    ~S"""
    def date_input_form_page(conn, _params) do
      ecto_form =
        %MyApp.Forms.DateInputForm{}
        |> MyApp.Forms.DateInputForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :date_ecto, id: "date-input-form-ecto")

      render(conn, :date_input_form_page, ecto_form: ecto_form)
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/date-input/form"} method="post" class="flex flex-col gap-space">
      <.date_input class="date-input" name="user[born_on]" />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def form_native_elixir do
    ~S"""
    def date_input_form_submit(conn, %{"user" => %{"born_on" => born_on}}) do
      conn
      |> put_flash(:info, "Submitted: born_on=#{inspect(born_on)}")
      |> redirect(to: ~p"/date-input/form")
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/date-input/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.date_input class="date-input" name="date_phoenix[born_on]" />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/date-input/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.date_input class="date-input" name="date_ecto[born_on]" />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form action={~p"/date-input/form"} method="post" class="flex flex-col gap-space w-full max-w-xl">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.date_input class="date-input" name="user[born_on]" />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def api_codes do
    %{
      set_value_client_binding: ~S"""
      <.action phx-click={Corex.DateInput.set_value("date-input-api-cb", "2026-08-31")} class="button ui-size-sm">Set date</.action>
      <.date_input id="date-input-api-cb" class="date-input" />
      """,
      set_value_client_js_heex: ~S"""
      <button type="button" class="button ui-size-sm" onclick="document.getElementById('date-input-api-cjs')?.dispatchEvent(new CustomEvent('corex:date-input:set-value', {bubbles: false, detail: { value: '2026-01-15' }}))">Set date</button>
      <.date_input id="date-input-api-cjs" class="date-input" />
      """,
      set_value_client_js: ~S"""
      document.getElementById("date-input-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:date-input:set-value", { bubbles: false, detail: { value: "2026-01-15" } })
      );
      """,
      set_value_client_ts: ~S"""
      document.getElementById("date-input-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:date-input:set-value", { bubbles: false, detail: { value: "2026-01-15" } })
      );
      """,
      set_value_server_heex: ~S"""
      <.action phx-click="date_input_api_set" class="button ui-size-sm">Set date</.action>
      <.date_input id="date-input-api-srv" class="date-input" />
      """,
      set_value_server_elixir: ~S"""
      def handle_event("date_input_api_set", _params, socket) do
        {:noreply, Corex.DateInput.set_value(socket, "date-input-api-srv", "2026-12-25")}
      end
      """
    }
  end
end
