defmodule E2eWeb.Demos.NativeInputDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

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
    <.anatomy_all_fields
      id_prefix="native-input-all"
      input_class="native-input native-input--max-w-md w-full"
    />
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
        input_class="native-input native-input--max-w-md w-full"
      />
    </div>
    """
  end

  @styling_semantic_variants [
    %{id: "default", label: "Default", modifier: ""},
    %{id: "accent", label: "Accent", modifier: "native-input--accent"},
    %{id: "brand", label: "Brand", modifier: "native-input--brand"},
    %{id: "alert", label: "Alert", modifier: "native-input--alert"},
    %{id: "info", label: "Info", modifier: "native-input--info"},
    %{id: "success", label: "Success", modifier: "native-input--success"}
  ]

  @styling_size_variants [
    %{id: "sm", label: "SM", modifier: "native-input--sm"},
    %{id: "md", label: "MD", modifier: "native-input--md"},
    %{id: "lg", label: "LG", modifier: "native-input--lg"},
    %{id: "xl", label: "XL", modifier: "native-input--xl"}
  ]

  @styling_radius_variants [
    %{id: "none", label: "None", modifier: "native-input--rounded-none"},
    %{id: "sm", label: "SM", modifier: "native-input--rounded-sm"},
    %{id: "md", label: "MD", modifier: "native-input--rounded-md"},
    %{id: "lg", label: "LG", modifier: "native-input--rounded-lg"},
    %{id: "xl", label: "XL", modifier: "native-input--rounded-xl"},
    %{id: "full", label: "Full", modifier: "native-input--rounded-full"}
  ]

  @styling_max_width_variants [
    %{id: "2xs", label: "2xs", modifier: "max-w-2xs"},
    %{id: "md", label: "MD", modifier: "max-w-md"},
    %{id: "xl", label: "XL", modifier: "max-w-xl"},
    %{id: "2xl", label: "2XL", modifier: "max-w-2xl"}
  ]

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
        <p class="typo typo--sm font-medium">{variant.label}</p>
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

  defp styling_variant_code(id_prefix, modifier, width_modifiers \\ false) do
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
    <.native_input type="text" name="demo[name]"  disabled={false}>
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
      disabled={@disabled}
    >
      <:label>Text</:label>
    </.native_input>
    """
  end

  def anatomy_textarea_code do
    ~S"""
    <.native_input type="textarea" name="user[bio]" >
      <:label>Bio</:label>
    </.native_input>
    """
  end

  def form_field_code do
    ~S"""
    <.form for={@form}>
      <.native_input type="email" field={@form[:email]} >
        <:label>Email</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
    </.form>
    """
  end

  def anatomy_basic_code do
    ~S"""
    <.native_input type="text" name="user[name]" >
      <:label>Name</:label>
    </.native_input>
    """
  end

  def anatomy_with_icon_code do
    ~S"""
    <.native_input type="email" name="user[email]" >
      <:label>Email</:label>
      <:icon><.heroicon name="hero-envelope" /></:icon>
    </.native_input>
    """
  end

  def anatomy_text_code do
    ~S"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="text" name="user[name]" >
        <:label>Text</:label>
        <:icon><.heroicon name="hero-pencil-square" /></:icon>
      </.native_input>
      <.native_input type="text" name="user[name]" >
        <:label>Text</:label>
      </.native_input>
      <.native_input type="textarea" name="user[bio]" >
        <:label>Bio</:label>
      </.native_input>
      <.native_input type="email" name="user[email]" >
        <:label>Email</:label>
        <:icon><.heroicon name="hero-envelope" /></:icon>
      </.native_input>
      <.native_input type="email" name="user[email]" >
        <:label>Email</:label>
      </.native_input>
      <.native_input type="url" name="user[website]" >
        <:label>Website</:label>
        <:icon><.heroicon name="hero-link" /></:icon>
      </.native_input>
      <.native_input type="url" name="user[website]" >
        <:label>Website</:label>
      </.native_input>
      <.native_input type="tel" name="user[phone]" >
        <:label>Phone</:label>
        <:icon><.heroicon name="hero-phone" /></:icon>
      </.native_input>
      <.native_input type="tel" name="user[phone]" >
        <:label>Phone</:label>
      </.native_input>
      <.native_input type="search" name="q"  placeholder="Search">
        <:label>Search</:label>
        <:icon><.heroicon name="hero-magnifying-glass" /></:icon>
      </.native_input>
      <.native_input type="search" name="q"  placeholder="Search">
        <:label>Search</:label>
      </.native_input>
      <.native_input type="password" name="user[password]" >
        <:label>Password</:label>
        <:icon><.heroicon name="hero-lock-closed" /></:icon>
      </.native_input>
      <.native_input type="password" name="user[password]" >
        <:label>Password</:label>
      </.native_input>
      <.native_input
        type="number"
        name="user[count]"
        value="42"
        min="0"
        max="100"
        step="1"
        
      >
        <:label>Number</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_text_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="text" id="text-with-icon" name="user[name]">
        <:label>Text</:label>
        <:icon><.heroicon name="hero-pencil-square" /></:icon>
      </.native_input>
      <.native_input type="text" id="text-basic" name="user[name]">
        <:label>Text</:label>
      </.native_input>
      <.native_input type="textarea" id="textarea" name="user[bio]">
        <:label>Bio</:label>
      </.native_input>
      <.native_input type="email" id="email-with-icon" name="user[email]">
        <:label>Email</:label>
        <:icon><.heroicon name="hero-envelope" /></:icon>
      </.native_input>
      <.native_input type="email" id="email-basic" name="user[email]">
        <:label>Email</:label>
      </.native_input>
      <.native_input type="url" id="url-with-icon" name="user[website]">
        <:label>Website</:label>
        <:icon><.heroicon name="hero-link" /></:icon>
      </.native_input>
      <.native_input type="url" id="url-basic" name="user[website]">
        <:label>Website</:label>
      </.native_input>
      <.native_input type="tel" id="tel-with-icon" name="user[phone]">
        <:label>Phone</:label>
        <:icon><.heroicon name="hero-phone" /></:icon>
      </.native_input>
      <.native_input type="tel" id="tel-basic" name="user[phone]">
        <:label>Phone</:label>
      </.native_input>
      <.native_input
        type="search"
        id="search-with-icon"
        name="q"
        placeholder="Search"
      >
        <:label>Search</:label>
        <:icon><.heroicon name="hero-magnifying-glass" /></:icon>
      </.native_input>
      <.native_input
        type="search"
        id="search-basic"
        name="q"
        placeholder="Search"
      >
        <:label>Search</:label>
      </.native_input>
      <.native_input
        type="password"
        id="password-with-icon"
        name="user[password]"
      >
        <:label>Password</:label>
        <:icon><.heroicon name="hero-lock-closed" /></:icon>
      </.native_input>
      <.native_input type="password" id="password-basic" name="user[password]">
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
      >
        <:label>Number</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_date_time_code do
    ~S"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="date" name="user[date]" >
        <:label>Date</:label>
      </.native_input>
      <.native_input type="datetime-local" name="user[datetime]" >
        <:label>Date and time</:label>
      </.native_input>
      <.native_input type="time" name="user[time]" >
        <:label>Time</:label>
      </.native_input>
      <.native_input type="month" name="user[month]" >
        <:label>Month</:label>
      </.native_input>
      <.native_input type="week" name="user[week]" >
        <:label>Week</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_date_time_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="date" id="date" name="user[date]">
        <:label>Date</:label>
      </.native_input>
      <.native_input type="datetime-local" id="datetime" name="user[datetime]">
        <:label>Date and time</:label>
      </.native_input>
      <.native_input type="time" id="time" name="user[time]">
        <:label>Time</:label>
      </.native_input>
      <.native_input type="month" id="month" name="user[month]">
        <:label>Month</:label>
      </.native_input>
      <.native_input type="week" id="week" name="user[week]">
        <:label>Week</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_multiple_code do
    ~S"""
    <div class="layout__row flex flex-col gap-4">
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
        
      >
        <:label>Tags</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_multiple_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex flex-col gap-4">
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
      >
        <:label>Tags</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_other_code do
    ~S"""
    <.native_input type="checkbox" name="user[agree]" >
      <:label>I agree</:label>
    </.native_input>
    <.native_input type="select" name="user[role]" options={["Admin": "admin", "User": "user"]} prompt="Choose role" >
      <:label>Role</:label>
    </.native_input>
    <.native_input type="radio" name="user[size]" options={["Small": "s", "Medium": "m", "Large": "l"]} value="m" >
      <:label>Size</:label>
    </.native_input>
    """
  end

  def anatomy_other_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="checkbox" id="checkbox" name="user[agree]">
        <:label>I agree</:label>
      </.native_input>
      <.native_input type="color" id="color" name="user[color]" value="#3b82f6">
        <:label>Color</:label>
      </.native_input>
      <.native_input
        type="radio"
        id="radio"
        name="user[size]"
        options={[{"Small", "s"}, {"Medium", "m"}, {"Large", "l"}]}
        value="m"
      >
        <:label>Size</:label>
      </.native_input>
      <.native_input
        type="select"
        id="select"
        name="user[role]"
        options={[{"Admin", "admin"}, {"User", "user"}]}
        prompt="Choose a role..."
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

  def styling_semantic_code do
    styling_variant_code("native-input-style-color", "native-input--accent")
  end

  def styling_semantic_example(assigns) do
    assigns = assign(assigns, :variants, @styling_semantic_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-color"
      variants={@variants}
    />
    """
  end

  def styling_size_code do
    styling_variant_code("native-input-style-size", "native-input--lg")
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

  def styling_radius_code do
    styling_variant_code("native-input-style-rounded", "native-input--rounded-lg")
  end

  def styling_radius_example(assigns) do
    assigns = assign(assigns, :variants, @styling_radius_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-rounded"
      variants={@variants}
    />
    """
  end

  def styling_max_width_code do
    styling_variant_code("native-input-style-max-width", "max-w-md", true)
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :variants, @styling_max_width_variants)

    ~H"""
    <.styling_modifier_preview
      id_prefix="native-input-style-max-width"
      variants={@variants}
      width_modifiers
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
      <.action type="submit" id="native-input-form-phoenix-submit" semantic="accent">
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
      <.action type="submit" id="native-input-live-form-phoenix-submit" semantic="accent">
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
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input field={@form[:name]} type="text" placeholder="Your name" >
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:email]} type="email" placeholder="you@example.com" >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:bio]} type="textarea" placeholder="Short bio" >
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:website]} type="url" placeholder="https://example.com" >
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:phone]} type="tel" placeholder="+1 234 567 8900" >
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:q]} type="search" placeholder="Search" >
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:count]} type="number" min={0} max={100} step={1} >
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:password]} type="password" >
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input field={@form[:birth_date]} type="date" >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:datetime]} type="datetime-local" >
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:reminder_time]} type="time" >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:month]} type="month" >
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:week]} type="week" >
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
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
          
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input field={@form[:color]} type="color" value="#3b82f6" >
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:role]}
          type="select"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:size]}
          type="radio"
          options={[Small: "s", Medium: "m", Large: "l"]}
          
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={@form[:agree]} type="checkbox" >
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" semantic="accent">
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
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input type="text" name="profile[name]" placeholder="Your name" >
          <:label>Name</:label>
        </.native_input>
        <.native_input type="email" name="profile[email]" placeholder="you@example.com" >
          <:label>Email</:label>
        </.native_input>
        <.native_input type="textarea" name="profile[bio]" placeholder="Short bio" >
          <:label>Bio</:label>
        </.native_input>
        <.native_input type="url" name="profile[website]" placeholder="https://example.com" >
          <:label>Website</:label>
        </.native_input>
        <.native_input type="tel" name="profile[phone]" placeholder="+1 234 567 8900" >
          <:label>Phone</:label>
        </.native_input>
        <.native_input type="search" name="profile[q]" placeholder="Search" >
          <:label>Search</:label>
        </.native_input>
        <.native_input type="number" name="profile[count]" min={0} max={100} step={1} >
          <:label>Count</:label>
        </.native_input>
        <.native_input type="password" name="profile[password]" >
          <:label>Password</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input type="date" name="profile[birth_date]" >
          <:label>Birth date</:label>
        </.native_input>
        <.native_input type="datetime-local" name="profile[datetime]" >
          <:label>Date and time</:label>
        </.native_input>
        <.native_input type="time" name="profile[reminder_time]" >
          <:label>Reminder time</:label>
        </.native_input>
        <.native_input type="month" name="profile[month]" >
          <:label>Month</:label>
        </.native_input>
        <.native_input type="week" name="profile[week]" >
          <:label>Week</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
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
          
        >
          <:label>Tags</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input type="color" name="profile[color]" value="#3b82f6" >
          <:label>Color</:label>
        </.native_input>
        <.native_input type="select" name="profile[role]" options={[Admin: "admin", User: "user"]} prompt="Choose role..." >
          <:label>Role</:label>
        </.native_input>
        <.native_input type="radio" name="profile[size]" options={[Small: "s", Medium: "m", Large: "l"]} >
          <:label>Size</:label>
        </.native_input>
        <.native_input type="checkbox" name="profile[agree]" >
          <:label>I agree</:label>
        </.native_input>
      </div>
      <.action type="submit" semantic="accent">
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
      <.action type="submit" id="native-input-form-submit" semantic="accent">
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
      <.action type="submit" id="native-input-native-submit" semantic="accent">
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
      <.action type="submit" id="native-input-live-submit" semantic="accent">
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
      <.action type="submit" id="native-input-form-phoenix-submit" semantic="accent">
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
      <.action type="submit" id="native-input-live-submit" semantic="accent">
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
      <.action type="submit" id="native-input-live-form-phoenix-submit" semantic="accent">
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
