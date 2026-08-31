defmodule E2eWeb.Demos.CascadeSelectDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.cascade_select class="cascade-select" show_indicator={false} />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select
      id="cascade-select-anatomy-minimal"
      class="cascade-select"
      show_indicator={false}
    />
    """
  end

  def anatomy_indicator_code do
    ~S"""
    <.cascade_select class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def anatomy_indicator_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select id="cascade-select-anatomy-indicator" class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def anatomy_label_code do
    ~S"""
    <.cascade_select class="cascade-select">
      <:label>Category</:label>
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def anatomy_label_example(assigns) do
    _ = assigns

    ~H"""
    <.cascade_select id="cascade-select-anatomy-label" class="cascade-select">
      <:label>Category</:label>
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def api_set_open_client_binding_heex do
    ~S"""
    <.action phx-click={Corex.CascadeSelect.set_open("cascade-select-api-cb", true)} class="button ui-size-sm">Open</.action>
    <.cascade_select id="cascade-select-api-cb" class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-space items-center">
      <.action
        phx-click={Corex.CascadeSelect.set_open("cascade-select-api-cb", true)}
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.cascade_select id="cascade-select-api-cb" class="cascade-select">
        <:indicator>▾</:indicator>
      </.cascade_select>
    </div>
    """
  end

  def api_set_open_client_js_heex do
    ~S"""
    <button type="button" class="button ui-size-sm" onclick="document.getElementById('cascade-select-api-cjs')?.dispatchEvent(new CustomEvent('corex:cascade-select:set-open', {bubbles: false, detail: { open: true } }))">Open</button>
    <.cascade_select id="cascade-select-api-cjs" class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def api_set_open_client_js_js do
    ~S"""
    document.getElementById("cascade-select-api-cjs")?.dispatchEvent(
      new CustomEvent("corex:cascade-select:set-open", { bubbles: false, detail: { open: true } })
    );
    """
  end

  def api_set_open_client_js_ts do
    api_set_open_client_js_js()
  end

  def api_set_open_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-space items-center">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('cascade-select-api-cjs')?.dispatchEvent(new CustomEvent('corex:cascade-select:set-open', {bubbles: false, detail: { open: true } }))"
      >
        Open
      </button>
      <.cascade_select id="cascade-select-api-cjs" class="cascade-select">
        <:indicator>▾</:indicator>
      </.cascade_select>
    </div>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <.action phx-click="cascade_select_api_open" class="button ui-size-sm">Open</.action>
    <.cascade_select id="cascade-select-api-srv" class="cascade-select">
      <:indicator>▾</:indicator>
    </.cascade_select>
    """
  end

  def api_set_open_server_elixir do
    ~S"""
    def handle_event("cascade_select_api_open", _params, socket) do
      {:noreply, Corex.CascadeSelect.set_open(socket, "cascade-select-api-srv", true)}
    end
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-space items-center">
      <.action phx-click="cascade_select_api_open" class="button ui-size-sm">Open</.action>
      <.cascade_select id="cascade-select-api-srv" class="cascade-select">
        <:indicator>▾</:indicator>
      </.cascade_select>
    </div>
    """
  end

  def api_codes do
    %{
      set_open_client_binding: api_set_open_client_binding_heex(),
      set_open_client_js_heex: api_set_open_client_js_heex(),
      set_open_client_js: api_set_open_client_js_js(),
      set_open_client_ts: api_set_open_client_js_ts(),
      set_open_server_heex: api_set_open_server_heex(),
      set_open_server_elixir: api_set_open_server_elixir()
    }
  end

  def form_preview_phoenix(assigns) do
    ~H"""
    <form id="cascade-select-form-phoenix" method="post" action="#" class="flex flex-col gap-space">
      <.cascade_select class="cascade-select" name="category">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-size-sm">Submit</.action>
    </form>
    """
  end

  alias E2eWeb.DemoScales

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select" />
    <.cascade_select class="cascade-select ui-accent" />
    <.cascade_select class="cascade-select ui-brand" />
    <.cascade_select class="cascade-select ui-alert" />
    <.cascade_select class="cascade-select ui-success" />
    <.cascade_select class="cascade-select ui-info" />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-default" class="cascade-select" />
      <.cascade_select id="cascade-select-style-accent" class="cascade-select ui-accent" />
      <.cascade_select id="cascade-select-style-brand" class="cascade-select ui-brand" />
      <.cascade_select id="cascade-select-style-alert" class="cascade-select ui-alert" />
      <.cascade_select id="cascade-select-style-success" class="cascade-select ui-success" />
      <.cascade_select id="cascade-select-style-info" class="cascade-select ui-info" />
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select" />
    <.cascade_select class="cascade-select ui-solid" />
    </div>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-subtle" class="cascade-select" />
      <.cascade_select id="cascade-select-style-solid" class="cascade-select ui-solid" />
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("cascade-select"),
        variant <- DemoScales.styling_variant_axis_steps("cascade-select") do
      class =
        DemoScales.join_matrix_modifiers("cascade-select", semantic.modifier, variant.modifier)

      ~s(<.cascade_select class="#{class}">)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("cascade-select"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("cascade-select"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm" tabindex="0">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.cascade_select
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"cascade-select-matrix-#{semantic_index}-#{variant_index}"}
            class={
              DemoScales.join_matrix_modifiers("cascade-select", semantic.modifier, variant.modifier)
            }
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select ui-size-sm" />
    <.cascade_select class="cascade-select ui-size-md" />
    <.cascade_select class="cascade-select ui-size-lg" />
    <.cascade_select class="cascade-select ui-size-xl" />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-size-sm" class="cascade-select ui-size-sm" />
      <.cascade_select id="cascade-select-style-size-md" class="cascade-select ui-size-md" />
      <.cascade_select id="cascade-select-style-size-lg" class="cascade-select ui-size-lg" />
      <.cascade_select id="cascade-select-style-size-xl" class="cascade-select ui-size-xl" />
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.cascade_select class="cascade-select ui-rounded-none" />
    <.cascade_select class="cascade-select ui-rounded-sm" />
    <.cascade_select class="cascade-select ui-rounded-md" />
    <.cascade_select class="cascade-select ui-rounded-lg" />
    <.cascade_select class="cascade-select ui-rounded-xl" />
    <.cascade_select class="cascade-select ui-rounded-full" />
    </div>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.cascade_select id="cascade-select-style-r-none" class="cascade-select ui-rounded-none" />
      <.cascade_select id="cascade-select-style-r-sm" class="cascade-select ui-rounded-sm" />
      <.cascade_select id="cascade-select-style-r-md" class="cascade-select ui-rounded-md" />
      <.cascade_select id="cascade-select-style-r-lg" class="cascade-select ui-rounded-lg" />
      <.cascade_select id="cascade-select-style-r-xl" class="cascade-select ui-rounded-xl" />
      <.cascade_select id="cascade-select-style-r-full" class="cascade-select ui-rounded-full" />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("cascade-select")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("cascade-select", modifier)
      ~s(<.cascade_select class="#{class}" />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("cascade-select") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.cascade_select
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("cascade-select", step.modifier)}
      />
    </div>
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.CascadeSelectForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :category, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:category])
        |> validate_required([:category], message: "can't be blank")
      end
    end
    """
  end

  def form_phoenix_heex do
    ~S"""
    <.form for={@form} action={~p"/cascade-select/form"} method="post" class="flex flex-col gap-space">
      <.cascade_select class="cascade-select" name="cascade_phoenix[category]">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_phoenix_elixir do
    ~S"""
    def cascade_select_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"category" => ""}, as: :cascade_phoenix, id: "cascade-select-form-phoenix")

      render(conn, :cascade_select_form_page, phoenix_form: phoenix_form)
    end
    """
  end

  def form_ecto_heex, do: form_phoenix_heex()

  def form_ecto_elixir do
    ~S"""
    def cascade_select_form_page(conn, _params) do
      ecto_form =
        %MyApp.Forms.CascadeSelectForm{}
        |> MyApp.Forms.CascadeSelectForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :cascade_ecto, id: "cascade-select-form-ecto")

      render(conn, :cascade_select_form_page, ecto_form: ecto_form)
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/cascade-select/form"} method="post" class="flex flex-col gap-space">
      <.cascade_select class="cascade-select" name="user[category]">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def form_native_elixir do
    ~S"""
    def cascade_select_form_submit(conn, %{"user" => %{"category" => category}}) do
      conn
      |> put_flash(:info, "Submitted: category=#{inspect(category)}")
      |> redirect(to: ~p"/cascade-select/form")
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/cascade-select/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.cascade_select class="cascade-select" name="cascade_phoenix[category]">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/cascade-select/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.cascade_select class="cascade-select" name="cascade_ecto[category]">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/cascade-select/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.cascade_select class="cascade-select" name="user[category]">
        <:label>Category</:label>
        <:indicator>▾</:indicator>
      </.cascade_select>
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end
end
