defmodule E2eWeb.Demos.RatingGroupDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.rating_group class="rating-group" value={3.0} />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-anatomy-minimal" class="rating-group" value={3.0} />
    """
  end

  def anatomy_half_code do
    ~S"""
    <.rating_group class="rating-group" allow_half value={3.5} />
    """
  end

  def anatomy_half_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-anatomy-half" class="rating-group" allow_half value={3.5} />
    """
  end

  def anatomy_smileys_code do
    ~S"""
    <.rating_group class="rating-group" value={4.0}>
      <:item :let={item}>
        <span aria-hidden="true">{["😞", "🙁", "😐", "🙂", "😀"] |> Enum.at(item.index - 1)}</span>
      </:item>
    </.rating_group>
    """
  end

  def anatomy_smileys_example(assigns) do
    _ = assigns

    ~H"""
    <.rating_group id="rating-group-anatomy-smileys" class="rating-group" value={4.0}>
      <:item :let={item}>
        <span aria-hidden="true">{["😞", "🙁", "😐", "🙂", "😀"] |> Enum.at(item.index - 1)}</span>
      </:item>
    </.rating_group>
    """
  end

  def styling_color_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group class="rating-group" value={3.0} />
    <.rating_group class="rating-group ui-accent" value={3.0} />
    <.rating_group class="rating-group ui-brand" value={3.0} />
    <.rating_group class="rating-group ui-alert" value={3.0} />
    <.rating_group class="rating-group ui-success" value={3.0} />
    <.rating_group class="rating-group ui-info" value={3.0} />
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.rating_group id="rating-group-style-default" class="rating-group" value={3.0} />
      <.rating_group id="rating-group-style-accent" class="rating-group ui-accent" value={3.0} />
      <.rating_group id="rating-group-style-brand" class="rating-group ui-brand" value={3.0} />
      <.rating_group id="rating-group-style-alert" class="rating-group ui-alert" value={3.0} />
      <.rating_group id="rating-group-style-success" class="rating-group ui-success" value={3.0} />
      <.rating_group id="rating-group-style-info" class="rating-group ui-info" value={3.0} />
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex flex-wrap gap-space-sm items-start">
    <.rating_group class="rating-group ui-size-sm" value={3.0} />
    <.rating_group class="rating-group ui-size-md" value={3.0} />
    <.rating_group class="rating-group ui-size-lg" value={3.0} />
    <.rating_group class="rating-group ui-size-xl" value={3.0} />
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-space-sm items-start">
      <.rating_group id="rating-group-style-size-sm" class="rating-group ui-size-sm" value={3.0} />
      <.rating_group id="rating-group-style-size-md" class="rating-group ui-size-md" value={3.0} />
      <.rating_group id="rating-group-style-size-lg" class="rating-group ui-size-lg" value={3.0} />
      <.rating_group id="rating-group-style-size-xl" class="rating-group ui-size-xl" value={3.0} />
    </div>
    """
  end

  def styling_width_code do
    DemoScales.width_layout_variants("rating-group")
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("rating-group", modifier)
      ~s(<.rating_group class="#{class}" value={3.0} />)
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("rating-group"))

    ~H"""
    <div class="flex flex-col gap-space">
      <.rating_group
        :for={step <- @width_variants}
        id={"rating-group-style-w-#{step.id}"}
        class={DemoScales.join_modifiers("rating-group", step.modifier)}
        value={3.0}
      />
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("rating-group")
    |> Enum.take(4)
    |> Enum.map(fn %{id: _id, modifier: modifier} ->
      class = DemoScales.join_modifiers("rating-group", modifier)
      ~s(<.rating_group class="#{class}" value={3.0} />)
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assign(
        assigns,
        :max_width_variants,
        DemoScales.max_width_variants("rating-group") |> Enum.take(4)
      )

    ~H"""
    <div class="flex flex-col gap-space">
      <.rating_group
        :for={step <- @max_width_variants}
        class={DemoScales.join_modifiers("rating-group", step.modifier)}
        value={3.0}
      />
    </div>
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.RatingGroupForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :score, :string
      end

      def changeset(form, attrs \\ %{}) do
        form
        |> cast(attrs, [:score])
        |> validate_required([:score], message: "can't be blank")
      end
    end
    """
  end

  def form_phoenix_heex do
    ~S"""
    <.form for={@form} action={~p"/rating-group/form"} method="post" class="flex flex-col gap-space">
      <.rating_group class="rating-group" name="rating_phoenix[score]" allow_half />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_phoenix_elixir do
    ~S"""
    def rating_group_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"score" => ""}, as: :rating_phoenix, id: "rating-group-form-phoenix")

      render(conn, :rating_group_form_page, phoenix_form: phoenix_form)
    end
    """
  end

  def form_ecto_heex, do: form_phoenix_heex()

  def form_ecto_elixir do
    ~S"""
    def rating_group_form_page(conn, _params) do
      ecto_form =
        %MyApp.Forms.RatingGroupForm{}
        |> MyApp.Forms.RatingGroupForm.changeset(%{})
        |> Phoenix.Component.to_form(as: :rating_ecto, id: "rating-group-form-ecto")

      render(conn, :rating_group_form_page, ecto_form: ecto_form)
    end
    """
  end

  def form_native_heex do
    ~S"""
    <form action={~p"/rating-group/form"} method="post" class="flex flex-col gap-space">
      <.rating_group class="rating-group" name="user[score]" allow_half />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def form_native_elixir do
    ~S"""
    def rating_group_form_submit(conn, %{"user" => %{"score" => score}}) do
      conn
      |> put_flash(:info, "Submitted: score=#{inspect(score)}")
      |> redirect(to: ~p"/rating-group/form")
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/rating-group/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.rating_group class="rating-group" name="rating_phoenix[score]" allow_half />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      for={@form}
      action={~p"/rating-group/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <.rating_group class="rating-group" name="rating_ecto[score]" allow_half />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/rating-group/form"}
      method="post"
      class="flex flex-col gap-space w-full max-w-xl"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.rating_group class="rating-group" name="user[score]" allow_half />
      <.action type="submit" class="button ui-accent">Submit</.action>
    </form>
    """
  end

  def api_codes do
    %{
      set_value_client_binding: ~S"""
      <.action phx-click={Corex.RatingGroup.set_value("rating-group-api-cb", 4)} class="button ui-size-sm">Set 4</.action>
      <.rating_group id="rating-group-api-cb" class="rating-group" />
      """,
      set_value_client_js_heex: ~S"""
      <button type="button" class="button ui-size-sm" onclick="document.getElementById('rating-group-api-cjs')?.dispatchEvent(new CustomEvent('corex:rating-group:set-value', {bubbles: false, detail: { value: 3 }}))">Set 3</button>
      <.rating_group id="rating-group-api-cjs" class="rating-group" />
      """,
      set_value_client_js: ~S"""
      document.getElementById("rating-group-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:rating-group:set-value", { bubbles: false, detail: { value: 3 } })
      );
      """,
      set_value_client_ts: ~S"""
      document.getElementById("rating-group-api-cjs")?.dispatchEvent(
        new CustomEvent("corex:rating-group:set-value", { bubbles: false, detail: { value: 3 } })
      );
      """,
      set_value_server_heex: ~S"""
      <.action phx-click="rating_group_api_set" class="button ui-size-sm">Set 5</.action>
      <.rating_group id="rating-group-api-srv" class="rating-group" />
      """,
      set_value_server_elixir: ~S"""
      def handle_event("rating_group_api_set", _params, socket) do
        {:noreply, Corex.RatingGroup.set_value(socket, "rating-group-api-srv", 5)}
      end
      """
    }
  end
end
