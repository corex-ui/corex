defmodule E2eWeb.Demos.NativeInputDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  import E2eWeb.Demos.NativeInputFormFields

  def tag_options do
    [
      "Elixir": "elixir",
      Phoenix: "phoenix",
      LiveView: "liveview",
      Ecto: "ecto",
      OTP: "otp"
    ]
  end

  def phoenix_form_defaults do
    %{
      "name" => "",
      "email" => "",
      "bio" => "",
      "birth_date" => "",
      "datetime" => "",
      "reminder_time" => "",
      "month" => "",
      "week" => "",
      "website" => "",
      "phone" => "",
      "q" => "",
      "color" => "",
      "count" => "",
      "password" => "",
      "role" => "",
      "tags" => "",
      "size" => "",
      "agree" => false
    }
  end

  def anatomy_all_code do
    ~S"""
    <.anatomy_all_fields id_prefix="native-input-all" input_class="native-input" />
    """
  end

  def anatomy_all_example(assigns) do
    ~H"""
    <.anatomy_all_fields id_prefix="native-input-all" input_class="native-input max-w-md w-full" />
    """
  end

  def styling_all_types_code, do: anatomy_all_code()

  def styling_all_types_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-h-[70vh] overflow-y-auto scrollbar scrollbar--sm">
      <.anatomy_all_fields
        id_prefix="native-input-style-all"
        name_prefix="native-input-style-all"
        input_class="native-input max-w-md w-full"
      />
    </div>
    """
  end

  @styling_color_variants [
    %{id: "default", label: "Default", modifier: ""},
    %{id: "accent", label: "Accent", modifier: "ui-accent"},
    %{id: "brand", label: "Brand", modifier: "ui-brand"},
    %{id: "alert", label: "Alert", modifier: "ui-alert"},
    %{id: "info", label: "Info", modifier: "ui-info"},
    %{id: "success", label: "Success", modifier: "ui-success"}
  ]

  @styling_size_variants [
    %{id: "sm", label: "SM", modifier: "ui-size-sm"},
    %{id: "md", label: "MD", modifier: "ui-size-md"},
    %{id: "lg", label: "LG", modifier: "ui-size-lg"},
    %{id: "xl", label: "XL", modifier: "ui-size-xl"}
  ]

  @styling_rounded_variants [
    %{id: "none", label: "None", modifier: "ui-rounded-none"},
    %{id: "sm", label: "SM", modifier: "ui-rounded-sm"},
    %{id: "md", label: "MD", modifier: "ui-rounded-md"},
    %{id: "lg", label: "LG", modifier: "ui-rounded-lg"},
    %{id: "xl", label: "XL", modifier: "ui-rounded-xl"},
    %{id: "full", label: "Full", modifier: "ui-rounded-full"}
  ]

  def styling_max_width_code do
    DemoScales.max_width_variants("native-input")
    |> Enum.map(fn %{id: id, label: label, modifier: modifier} ->
      input_class = styling_width_input_class(modifier)

      """
      <div class="flex flex-col gap-3 pb-8 last:pb-0">
        <p class="typo ui-size-sm font-medium">#{label}</p>
        <.anatomy_all_fields
          id_prefix="native-input-style-max-width-#{id}"
          input_class="#{input_class}"
        />
      </div>
      """
    end)
    |> then(fn blocks ->
      """
      <div class="w-full max-h-[70vh] overflow-y-auto scrollbar scrollbar--sm">
      #{Enum.join(blocks, "\n")}
      </div>
      """
    end)
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :variants, DemoScales.max_width_variants("native-input"))

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-max-width"
      variants={@variants}
      width_modifiers
    />
    """
  end

  attr(:id_prefix, :string, required: true)
  attr(:variants, :list, required: true)
  attr(:width_modifiers, :boolean, default: false)

  defp styling_modifier_preview(assigns) do
    variants =
      Enum.map(assigns.variants, fn variant ->
        input_class =
          if assigns.width_modifiers do
            styling_width_input_class(variant.modifier)
          else
            styling_input_class(variant.modifier)
          end

        Map.put(variant, :input_class, input_class)
      end)

    assigns = assign(assigns, :variants, variants)

    ~H"""
    <div class="w-full max-h-[70vh] overflow-y-auto scrollbar scrollbar--sm">
      <div :for={variant <- @variants} class="flex flex-col gap-3 pb-8 last:pb-0">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.anatomy_all_fields
          id_prefix={"#{@id_prefix}-#{variant.id}"}
          name_prefix={"#{@id_prefix}-#{variant.id}"}
          input_class={variant.input_class}
        />
      </div>
    </div>
    """
  end

  defp styling_input_class(modifier) do
    ["native-input", modifier, "max-w-md", "w-full"]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(" ")
  end

  defp styling_width_input_class(width_modifier) do
    ["native-input", width_modifier, "w-full"]
    |> Enum.join(" ")
  end

  defp styling_modifier_code(id_prefix, modifier, width_modifiers \\ false) do
    input_class =
      if width_modifiers,
        do: styling_width_input_class(modifier),
        else: styling_input_class(modifier)

    ~s"""
    <div class="max-h-[70vh] overflow-y-auto scrollbar scrollbar--sm">
      <.anatomy_all_fields
        id_prefix="#{id_prefix}-example"
        input_class="#{input_class}"
      />
    </div>
    """
  end

  def playground_code do
    ~S"""
    <.native_input type="text" name="demo[name]" class="native-input" disabled={false}>
      <:label>Text</:label>
    </.native_input>
    """
  end

  def playground_example(assigns) do
    assigns = assign_new(assigns, :disabled, fn -> false end)

    ~H"""
    <.native_input
      type="text"
      id="native-input-play"
      name="demo[name]"
      class="native-input"
      disabled={@disabled}
    >
      <:label>Text</:label>
    </.native_input>
    """
  end

  def anatomy_textarea_code do
    ~S"""
    <.native_input type="textarea" name="user[bio]" class="native-input">
      <:label>Bio</:label>
    </.native_input>
    """
  end

  def form_field_code do
    ~S"""
    <.form for={@form}>
      <.native_input type="email" field={@form[:email]} class="native-input">
        <:label>Email</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
    </.form>
    """
  end

  def anatomy_basic_code do
    ~S"""
    <.native_input type="text" name="user[name]" class="native-input">
      <:label>Name</:label>
    </.native_input>
    """
  end

  def anatomy_with_icon_code do
    ~S"""
    <.native_input type="email" name="user[email]" class="native-input">
      <:label>Email</:label>
      <:icon><.heroicon name="hero-envelope" class="icon" /></:icon>
    </.native_input>
    """
  end

  def anatomy_text_code do
    ~S"""
    <div class="flex flex-col gap-4">
      <.native_input type="text" name="user[name]" class="native-input">
        <:label>Text</:label>
        <:icon><.heroicon name="hero-pencil-square" class="icon" /></:icon>
      </.native_input>
      <.native_input type="text" name="user[name]" class="native-input">
        <:label>Text</:label>
      </.native_input>
      <.native_input type="textarea" name="user[bio]" class="native-input">
        <:label>Bio</:label>
      </.native_input>
      <.native_input type="email" name="user[email]" class="native-input">
        <:label>Email</:label>
        <:icon><.heroicon name="hero-envelope" class="icon" /></:icon>
      </.native_input>
      <.native_input type="email" name="user[email]" class="native-input">
        <:label>Email</:label>
      </.native_input>
      <.native_input type="url" name="user[website]" class="native-input">
        <:label>Website</:label>
        <:icon><.heroicon name="hero-link" class="icon" /></:icon>
      </.native_input>
      <.native_input type="url" name="user[website]" class="native-input">
        <:label>Website</:label>
      </.native_input>
      <.native_input type="tel" name="user[phone]" class="native-input">
        <:label>Phone</:label>
        <:icon><.heroicon name="hero-phone" class="icon" /></:icon>
      </.native_input>
      <.native_input type="tel" name="user[phone]" class="native-input">
        <:label>Phone</:label>
      </.native_input>
      <.native_input type="search" name="q" class="native-input" placeholder="Search">
        <:label>Search</:label>
        <:icon><.heroicon name="hero-magnifying-glass" class="icon" /></:icon>
      </.native_input>
      <.native_input type="search" name="q" class="native-input" placeholder="Search">
        <:label>Search</:label>
      </.native_input>
      <.native_input type="password" name="user[password]" class="native-input">
        <:label>Password</:label>
        <:icon><.heroicon name="hero-lock-closed" class="icon" /></:icon>
      </.native_input>
      <.native_input type="password" name="user[password]" class="native-input">
        <:label>Password</:label>
      </.native_input>
      <.native_input
        type="number"
        name="user[count]"
        value="42"
        min="0"
        max="100"
        step="1"
        class="native-input"
      >
        <:label>Number</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_text_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.native_input type="text" id="text-with-icon" name="user[name]" class="native-input">
        <:label>Text</:label>
        <:icon><.heroicon name="hero-pencil-square" class="icon" /></:icon>
      </.native_input>
      <.native_input type="text" id="text-basic" name="user[name]" class="native-input">
        <:label>Text</:label>
      </.native_input>
      <.native_input type="textarea" id="textarea" name="user[bio]" class="native-input">
        <:label>Bio</:label>
      </.native_input>
      <.native_input type="email" id="email-with-icon" name="user[email]" class="native-input">
        <:label>Email</:label>
        <:icon><.heroicon name="hero-envelope" class="icon" /></:icon>
      </.native_input>
      <.native_input type="email" id="email-basic" name="user[email]" class="native-input">
        <:label>Email</:label>
      </.native_input>
      <.native_input type="url" id="url-with-icon" name="user[website]" class="native-input">
        <:label>Website</:label>
        <:icon><.heroicon name="hero-link" class="icon" /></:icon>
      </.native_input>
      <.native_input type="url" id="url-basic" name="user[website]" class="native-input">
        <:label>Website</:label>
      </.native_input>
      <.native_input type="tel" id="tel-with-icon" name="user[phone]" class="native-input">
        <:label>Phone</:label>
        <:icon><.heroicon name="hero-phone" class="icon" /></:icon>
      </.native_input>
      <.native_input type="tel" id="tel-basic" name="user[phone]" class="native-input">
        <:label>Phone</:label>
      </.native_input>
      <.native_input
        type="search"
        id="search-with-icon"
        name="q"
        class="native-input"
        placeholder="Search"
      >
        <:label>Search</:label>
        <:icon><.heroicon name="hero-magnifying-glass" class="icon" /></:icon>
      </.native_input>
      <.native_input
        type="search"
        id="search-basic"
        name="q"
        class="native-input"
        placeholder="Search"
      >
        <:label>Search</:label>
      </.native_input>
      <.native_input
        type="password"
        id="password-with-icon"
        name="user[password]"
        class="native-input"
      >
        <:label>Password</:label>
        <:icon><.heroicon name="hero-lock-closed" class="icon" /></:icon>
      </.native_input>
      <.native_input type="password" id="password-basic" name="user[password]" class="native-input">
        <:label>Password</:label>
      </.native_input>
      <.native_input
        type="number"
        id="number"
        name="user[count]"
        value="42"
        min="0"
        max="100"
        step="1"
        class="native-input"
      >
        <:label>Number</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_date_time_code do
    ~S"""
    <div class="flex flex-col gap-4">
      <.native_input type="date" name="user[date]" class="native-input">
        <:label>Date</:label>
      </.native_input>
      <.native_input type="datetime-local" name="user[datetime]" class="native-input">
        <:label>Date and time</:label>
      </.native_input>
      <.native_input type="time" name="user[time]" class="native-input">
        <:label>Time</:label>
      </.native_input>
      <.native_input type="month" name="user[month]" class="native-input">
        <:label>Month</:label>
      </.native_input>
      <.native_input type="week" name="user[week]" class="native-input">
        <:label>Week</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_date_time_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.native_input type="date" id="date" name="user[date]" class="native-input">
        <:label>Date</:label>
      </.native_input>
      <.native_input type="datetime-local" id="datetime" name="user[datetime]" class="native-input">
        <:label>Date and time</:label>
      </.native_input>
      <.native_input type="time" id="time" name="user[time]" class="native-input">
        <:label>Time</:label>
      </.native_input>
      <.native_input type="month" id="month" name="user[month]" class="native-input">
        <:label>Month</:label>
      </.native_input>
      <.native_input type="week" id="week" name="user[week]" class="native-input">
        <:label>Week</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_multiple_code do
    ~S"""
    <div class="flex flex-col gap-4">
      <.native_input
        type="select"
        multiple
        name="user[tags][]"
        options={[
          {"Elixir", "elixir"},
          {"Phoenix", "phoenix"},
          {"LiveView", "liveview"},
          {"Ecto", "ecto"},
          {"OTP", "otp"}
        ]}
        prompt="Choose tags..."
        class="native-input"
      >
        <:label>Tags</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_multiple_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.native_input
        type="select"
        multiple
        id="select-multiple"
        name="user[tags][]"
        options={[
          {"Elixir", "elixir"},
          {"Phoenix", "phoenix"},
          {"LiveView", "liveview"},
          {"Ecto", "ecto"},
          {"OTP", "otp"}
        ]}
        prompt="Choose tags..."
        class="native-input"
      >
        <:label>Tags</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_other_code do
    ~S"""
    <.native_input type="checkbox" name="user[agree]" class="native-input">
      <:label>I agree</:label>
    </.native_input>
    <.native_input type="select" name="user[role]" options={["Admin": "admin", "User": "user"]} prompt="Choose role" class="native-input">
      <:label>Role</:label>
    </.native_input>
    <.native_input type="radio" name="user[size]" options={["Small": "s", "Medium": "m", "Large": "l"]} value="m" class="native-input">
      <:label>Size</:label>
    </.native_input>
    """
  end

  def anatomy_other_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4">
      <.native_input type="checkbox" id="checkbox" name="user[agree]" class="native-input">
        <:label>I agree</:label>
      </.native_input>
      <.native_input type="color" id="color" name="user[color]" value="#3b82f6" class="native-input">
        <:label>Color</:label>
      </.native_input>
      <.native_input
        type="radio"
        id="radio"
        name="user[size]"
        options={[{"Small", "s"}, {"Medium", "m"}, {"Large", "l"}]}
        value="m"
        class="native-input"
      >
        <:label>Size</:label>
      </.native_input>
      <.native_input
        type="select"
        id="select"
        name="user[role]"
        options={[{"Admin", "admin"}, {"User", "user"}]}
        prompt="Choose a role..."
        class="native-input"
      >
        <:label>Role</:label>
      </.native_input>
    </div>
    """
  end

  def showcase_code, do: anatomy_all_code()

  def showcase_example(assigns) do
    _ = assigns
    anatomy_all_example(assigns)
  end

  def styling_color_code do
    styling_modifier_code("native-input-style-color", "ui-accent")
  end

  def styling_color_example(assigns) do
    assigns = assign(assigns, :variants, @styling_color_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-color"
      variants={@variants}
    />
    """
  end

  def styling_variant_code do
    ~S"""
    <.native_input type="text" name="user[name]" class="native-input">
      <:label>Subtle (default)</:label>
    </.native_input>
    <.native_input type="text" name="user[name]" class="native-input ui-solid">
      <:label>Solid</:label>
    </.native_input>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.native_input
        id="native-input-style-variant-subtle"
        type="text"
        name="user[name]"
        class="native-input"
      >
        <:label>Subtle (default)</:label>
      </.native_input>
      <.native_input
        id="native-input-style-variant-solid"
        type="text"
        name="user[name]"
        class="native-input ui-solid"
      >
        <:label>Solid</:label>
      </.native_input>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("native-input"),
        variant <- DemoScales.styling_variant_axis_steps("native-input") do
      class =
        DemoScales.join_matrix_modifiers("native-input", semantic.modifier, variant.modifier)

      ~s(<.native_input type="text" name="user[name]" class="#{class}">
        <:label>#{semantic.label}</:label>
      </.native_input>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("native-input"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("native-input"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={{semantic, semantic_index} <- Enum.with_index(@matrix_semantics)} class="contents">
          <.native_input
            :for={{variant, variant_index} <- Enum.with_index(@matrix_variants)}
            id={"native-input-matrix-#{semantic_index}-#{variant_index}"}
            type="text"
            name="user[name]"
            class={
              DemoScales.join_matrix_modifiers("native-input", semantic.modifier, variant.modifier)
            }
          >
            <:label>{semantic.label}</:label>
          </.native_input>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    styling_modifier_code("native-input-style-size", "ui-size-lg")
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :variants, @styling_size_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-size"
      variants={@variants}
    />
    """
  end

  def styling_rounded_code do
    styling_modifier_code("native-input-style-rounded", "ui-rounded-lg")
  end

  def styling_rounded_example(assigns) do
    assigns = assign(assigns, :variants, @styling_rounded_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-rounded"
      variants={@variants}
    />
    """
  end

  def form_ecto do
    ~S"""
    defmodule MyApp.Forms.NativeInputProfile do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :name, :string
        field :email, :string
        field :bio, :string
        field :birth_date, :string
        field :datetime, :string
        field :reminder_time, :string
        field :month, :string
        field :week, :string
        field :website, :string
        field :phone, :string
        field :q, :string
        field :color, :string
        field :count, :integer
        field :password, :string
        field :role, :string
        field :tags, {:array, :string}, default: []
        field :size, :string
        field :agree, :boolean, default: false
      end

      def changeset(profile, attrs \\ %{}) do
        profile
        |> cast(attrs, [:name, :email, :bio, :birth_date, :datetime, :reminder_time, :month, :week, :website, :phone, :q, :color, :count, :password, :role, :tags, :size, :agree])
        |> validate_required([:name, :email, :agree])
        |> validate_acceptance(:agree)
      end

      def changeset_validate(profile, attrs \\ %{}) do
        profile
        |> cast(attrs, [:name, :email, :bio, :birth_date, :datetime, :reminder_time, :month, :week, :website, :phone, :q, :color, :count, :password, :role, :tags, :size, :agree])
        |> validate_required([:name, :email, :bio, :birth_date, :datetime, :reminder_time, :month, :week, :website, :phone, :q, :color, :count, :password, :role, :tags, :size, :agree], message: "can't be blank")
        |> validate_format(:email, ~r/@/, message: "must look like an email address")
        |> validate_length(:bio, min: 3, message: "must be at least 3 characters")
        |> validate_length(:password, min: 6, message: "must be at least 6 characters")
        |> validate_format(:website, ~r/^https?:\\/\\//, message: "must start with http:// or https://")
        |> validate_number(:count, greater_than: 0, less_than: 99, message: "must be between 1 and 98")
        |> validate_change(:tags, fn :tags, tags ->
          if is_list(tags) and tags != [], do: [], else: [tags: "can't be blank"]
        end)
        |> validate_acceptance(:agree, message: "must be accepted to continue")
      end
    end
    """
  end

  def form_changeset_heex, do: form_doc_controller_changeset_heex()
  def form_changeset_elixir, do: form_doc_controller_changeset_elixir()
  def form_validate_heex, do: form_doc_controller_validate_heex()
  def form_validate_elixir, do: form_doc_controller_validate_elixir()
  def form_native_heex, do: form_doc_native_heex()
  def form_native_elixir, do: form_doc_controller_native_elixir()

  def form_doc_controller_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id="native-input-form-phoenix"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.form_full_fields variant={:ecto} id_prefix="native-input-phoenix" f={@form} />
      <.action type="submit" id="native-input-form-phoenix-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def native_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(MyAppWeb.Demos.NativeInputDemo.phoenix_form_defaults(),
          as: :profile_phoenix,
          id: "native-input-form-phoenix"
        )

      render(conn, :native_input_form_page, phoenix_form: phoenix_form)
    end

    def native_input_form_submit(conn, %{"profile_phoenix" => profile}) do
      conn
      |> put_flash(:info, "Submitted: #{MyApp.Forms.NativeInputProfile.format_for_toast(profile)}")
      |> redirect(to: ~p"/native-input/form#native-input-form-phoenix")
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form
      for={@form}
      id="native-input-live-form-phoenix"
      phx-submit="save_phoenix"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <.form_full_fields variant={:ecto} id_prefix="native-input-live-phoenix" f={@form} />
      <.action type="submit" id="native-input-live-form-phoenix-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      for={@form}
      action={~p"/native-input/form"}
      method="post"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Text</p>
        <.native_input field={@form[:name]} type="text" placeholder="Your name" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:email]} type="email" placeholder="you@example.com" class="native-input">
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:bio]} type="textarea" placeholder="Short bio" class="native-input">
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:website]} type="url" placeholder="https://example.com" class="native-input">
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:phone]} type="tel" placeholder="+1 234 567 8900" class="native-input">
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:q]} type="search" placeholder="Search" class="native-input">
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:count]} type="number" min={0} max={100} step={1} class="native-input">
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:password]} type="password" class="native-input">
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Date & time</p>
        <.native_input field={@form[:birth_date]} type="date" class="native-input">
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:datetime]} type="datetime-local" class="native-input">
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:reminder_time]} type="time" class="native-input">
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:month]} type="month" class="native-input">
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:week]} type="week" class="native-input">
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Multiple</p>
        <.native_input
          field={@form[:tags]}
          type="select"
          multiple
          options={[
            "Elixir": "elixir",
            Phoenix: "phoenix",
            LiveView: "liveview",
            Ecto: "ecto",
            OTP: "otp"
          ]}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Other</p>
        <.native_input field={@form[:color]} type="color" value="#3b82f6" class="native-input">
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:role]}
          type="select"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:size]}
          type="radio"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:agree]} type="checkbox" class="native-input">
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_elixir do
    ~S"""
    def native_input_form_page(conn, _params) do
      changeset = MyApp.Forms.NativeInputProfile.changeset(%MyApp.Forms.NativeInputProfile{}, %{})

      validate_changeset =
        MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, %{})

      form =
        Phoenix.Component.to_form(changeset,
          as: :profile_changeset,
          id: "native-input-changeset-form"
        )

      validate_form =
        Phoenix.Component.to_form(validate_changeset,
          as: :profile_validate,
          id: "native-input-validate-form"
        )

      render(conn, :native_input_form_page, form: form, validate_form: validate_form)
    end

    def native_input_form_create(conn, %{"profile_changeset" => params}) do
      case MyApp.Forms.NativeInputProfile.changeset(%MyApp.Forms.NativeInputProfile{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved profile")
          |> redirect(to: "/native-input/form#native-input-form-changeset")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)
          form = Phoenix.Component.to_form(changeset, as: :profile_changeset, id: "native-input-changeset-form")

          validate_form =
            MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, %{})
            |> Phoenix.Component.to_form(as: :profile_validate, id: "native-input-validate-form")

          render(conn, :native_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_controller_validate_heex do
    form_doc_controller_changeset_heex()
    |> String.replace("native-input-changeset", "native-input-validate")
  end

  def form_doc_controller_validate_elixir do
    ~S"""
    def native_input_form_strict_create(conn, %{"profile_validate" => params}) do
      case MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          conn
          |> put_flash(:info, "Saved profile (strict)")
          |> redirect(to: "/native-input/form#native-input-form-validate")

        changeset ->
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset, as: :profile_validate, id: "native-input-validate-form")

          form =
            MyApp.Forms.NativeInputProfile.changeset(%MyApp.Forms.NativeInputProfile{}, %{})
            |> Phoenix.Component.to_form(as: :profile_changeset, id: "native-input-changeset-form")

          render(conn, :native_input_form_page, form: form, validate_form: validate_form)
      end
    end
    """
  end

  def form_doc_native_heex do
    ~S"""
    <form action={~p"/native-input/form"} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Text</p>
        <.native_input type="text" name="profile[name]" placeholder="Your name" class="native-input">
          <:label>Name</:label>
        </.native_input>
        <.native_input type="email" name="profile[email]" placeholder="you@example.com" class="native-input">
          <:label>Email</:label>
        </.native_input>
        <.native_input type="textarea" name="profile[bio]" placeholder="Short bio" class="native-input">
          <:label>Bio</:label>
        </.native_input>
        <.native_input type="url" name="profile[website]" placeholder="https://example.com" class="native-input">
          <:label>Website</:label>
        </.native_input>
        <.native_input type="tel" name="profile[phone]" placeholder="+1 234 567 8900" class="native-input">
          <:label>Phone</:label>
        </.native_input>
        <.native_input type="search" name="profile[q]" placeholder="Search" class="native-input">
          <:label>Search</:label>
        </.native_input>
        <.native_input type="number" name="profile[count]" min={0} max={100} step={1} class="native-input">
          <:label>Count</:label>
        </.native_input>
        <.native_input type="password" name="profile[password]" class="native-input">
          <:label>Password</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Date & time</p>
        <.native_input type="date" name="profile[birth_date]" class="native-input">
          <:label>Birth date</:label>
        </.native_input>
        <.native_input type="datetime-local" name="profile[datetime]" class="native-input">
          <:label>Date and time</:label>
        </.native_input>
        <.native_input type="time" name="profile[reminder_time]" class="native-input">
          <:label>Reminder time</:label>
        </.native_input>
        <.native_input type="month" name="profile[month]" class="native-input">
          <:label>Month</:label>
        </.native_input>
        <.native_input type="week" name="profile[week]" class="native-input">
          <:label>Week</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Multiple</p>
        <.native_input
          type="select"
          multiple
          name="profile[tags][]"
          options={[
            "Elixir": "elixir",
            Phoenix: "phoenix",
            LiveView: "liveview",
            Ecto: "ecto",
            OTP: "otp"
          ]}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo ui-size-sm font-medium">Other</p>
        <.native_input type="color" name="profile[color]" value="#3b82f6" class="native-input">
          <:label>Color</:label>
        </.native_input>
        <.native_input type="select" name="profile[role]" options={[Admin: "admin", User: "user"]} prompt="Choose role..." class="native-input">
          <:label>Role</:label>
        </.native_input>
        <.native_input type="radio" name="profile[size]" options={[Small: "s", Medium: "m", Large: "l"]} class="native-input">
          <:label>Size</:label>
        </.native_input>
        <.native_input type="checkbox" name="profile[agree]" class="native-input">
          <:label>I agree</:label>
        </.native_input>
      </div>
      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_controller_native_elixir do
    ~S"""
    def native_input_form_submit(conn, %{"profile" => profile}) do
      conn
      |> put_flash(:info, "Submitted: profile=#{inspect(profile)}")
      |> redirect(to: ~p"/native-input/form#native-input-form-native")
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_ecto(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id="native-input-form-ecto"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.form_full_fields variant={:ecto} id_prefix="native-input-form" f={f} />
      <.action type="submit" id="native-input-form-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_validate(assigns), do: form_preview_controller_ecto(assigns)

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/native-input/form"}
      method="post"
      id="native-input-native-form"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.form_full_fields variant={:native} id_prefix="native-input-native" name_prefix="profile" />
      <.action type="submit" id="native-input-native-submit" class="button ui-accent">
        Submit
      </.action>
    </form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_ecto(assigns) do
    ~H"""
    <.form
      for={@form}
      id="native-input-live-form-ecto"
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <.form_full_fields variant={:ecto} id_prefix="native-input-live" f={@form} />
      <.action type="submit" id="native-input-live-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_validate(assigns), do: form_preview_live_ecto(assigns)

  def form_preview_controller_changeset(assigns), do: form_preview_controller_ecto(assigns)

  def form_preview_live_changeset(assigns), do: form_preview_live_ecto(assigns)

  def form_code, do: form_native_heex()

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id="native-input-form-phoenix"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <.form_full_fields variant={:ecto} id_prefix="native-input-phoenix" f={f} />
      <.action type="submit" id="native-input-form-phoenix-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()

  def form_doc_live_ecto_heex do
    ~S"""
    <.form
      for={@form}
      id="native-input-live-form-ecto"
      phx-change="validate"
      phx-submit="save"
    >
      <.form_full_fields variant={:ecto} id_prefix="native-input-live" f={@form} />
      <.action type="submit" id="native-input-live-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_validate_heex, do: form_doc_live_ecto_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form
      for={@form}
      id="native-input-live-form-phoenix"
      phx-submit="save_phoenix"
      class="flex flex-col gap-6 w-full max-w-md"
    >
      <.form_full_fields variant={:ecto} id_prefix="native-input-live-phoenix" f={@form} />
      <.action type="submit" id="native-input-live-form-phoenix-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.NativeInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(MyAppWeb.Demos.NativeInputDemo.phoenix_form_defaults(),
            as: :profile_phoenix,
            id: "native-input-live-form-phoenix"
          )

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", %{"profile_phoenix" => profile}, socket) do
        message = "Submitted: #{MyApp.Forms.NativeInputProfile.format_for_toast(profile)}"

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(profile, as: :profile_phoenix, id: "native-input-live-form-phoenix")
         )
         |> put_flash(:info, message)}
      end
    end
    """
  end

  def form_doc_live_ecto_elixir do
    ~S"""
    defmodule MyAppWeb.NativeInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        ecto_form =
          %MyApp.Forms.NativeInputProfile{}
          |> MyApp.Forms.NativeInputProfile.changeset_validate(%{})
          |> Phoenix.Component.to_form(as: :profile_ecto, id: "native-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"profile_ecto" => params}, socket) do
        changeset =
          %MyApp.Forms.NativeInputProfile{}
          |> MyApp.Forms.NativeInputProfile.changeset_validate(params)
          |> Map.put(:action, :validate)

        {:noreply,
         assign(
           socket,
           :ecto_form,
           Phoenix.Component.to_form(changeset,
             action: :validate,
             as: :profile_ecto,
             id: "native-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"profile_ecto" => params}, socket) do
        case MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params),
                 as: :profile_ecto,
                 id: "native-input-live-form-ecto"
               )
             )}

          changeset ->
            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(changeset,
                 action: :insert,
                 as: :profile_ecto,
                 id: "native-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end
end
