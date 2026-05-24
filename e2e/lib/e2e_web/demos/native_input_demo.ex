defmodule E2eWeb.Demos.NativeInputDemo do
  use E2eWeb, :html

  def tag_options do
    [
      "Elixir": "elixir",
      Phoenix: "phoenix",
      LiveView: "liveview",
      Ecto: "ecto",
      OTP: "otp"
    ]
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

  def anatomy_text_code do
    ~S"""
    <div class="layout__row flex flex-col gap-4">
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
    <div class="layout__row flex flex-col gap-4">
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
    <div class="layout__row flex flex-col gap-4">
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
    <div class="layout__row flex flex-col gap-4">
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
        class="native-input"
      >
        <:label>Tags</:label>
      </.native_input>
    </div>
    """
  end

  def anatomy_other_code do
    ~S"""
    <div class="layout__row flex flex-col gap-4">
      <.native_input type="checkbox" name="user[agree]" class="native-input">
        <:label>I agree</:label>
      </.native_input>
      <.native_input type="color" name="user[color]" value="#3b82f6" class="native-input">
        <:label>Color</:label>
      </.native_input>
      <.native_input
        type="radio"
        name="user[size]"
        options={[{"Small", "s"}, {"Medium", "m"}, {"Large", "l"}]}
        value="m"
        class="native-input"
      >
        <:label>Size</:label>
      </.native_input>
      <.native_input
        type="select"
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

  def anatomy_other_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex flex-col gap-4">
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

  def showcase_code do
    [
      anatomy_text_code(),
      anatomy_date_time_code(),
      anatomy_multiple_code(),
      anatomy_other_code()
    ]
    |> Enum.join("\n")
  end

  def showcase_example(assigns) do
    ~H"""
    <div class="layout__row flex flex-col gap-8">
      {anatomy_text_example(assigns)}
      {anatomy_date_time_example(assigns)}
      {anatomy_multiple_example(assigns)}
      {anatomy_other_example(assigns)}
    </div>
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
        |> validate_required([:name, :email, :role, :count, :agree], message: "can't be blank")
        |> validate_format(:email, ~r/@/, message: "must look like an email address")
        |> validate_length(:bio, min: 3, message: "must be at least 3 characters")
        |> validate_number(:count, greater_than: 0, less_than: 99, message: "must be between 1 and 98")
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
      :let={f}
      for={@phoenix_form}
      action={~p"/native-input/form"}
      method="post"
      id={@phoenix_form.id}
    >
      <.native_input field={f[:email]} type="email" placeholder="you@example.com" class="native-input">
        <:label>Email</:label>
      </.native_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_phoenix_elixir do
    ~S"""
    def native_input_form_page(conn, _params) do
      phoenix_form =
        Phoenix.Component.to_form(%{"email" => "", "website" => "", "age" => ""},
          as: :native_input_phoenix,
          id: "native-input-form-phoenix"
        )

      render(conn, :native_input_form_page, phoenix_form: phoenix_form)
    end

    def native_input_form_submit(conn, params) do
      if is_map(params["native_input_phoenix"]) do
        email = params["native_input_phoenix"]["email"] || ""

        conn
        |> put_flash(:info, "Submitted: email=#{inspect(email)}")
        |> redirect(to: ~p"/native-input/form#native-input-form-phoenix")
      end
    end
    """
  end

  def form_doc_live_phoenix_heex do
    ~S"""
    <.form for={@phoenix_form} id={@phoenix_form.id} phx-submit="save_phoenix">
      <.native_input field={@phoenix_form[:email]} type="email" placeholder="you@example.com" class="native-input">
        <:label>Email</:label>
      </.native_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_doc_controller_changeset_heex do
    ~S"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id={@form.id}
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input field={f[:name]} type="text" placeholder="Your name" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:email]} type="email" placeholder="you@example.com" class="native-input">
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:bio]} type="textarea" placeholder="Short bio" class="native-input">
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:website]} type="url" placeholder="https://example.com" class="native-input">
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:phone]} type="tel" placeholder="+1 234 567 8900" class="native-input">
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:q]} type="search" placeholder="Search" class="native-input">
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:count]} type="number" min={0} max={100} step={1} class="native-input">
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:password]} type="password" class="native-input">
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input field={f[:birth_date]} type="date" class="native-input">
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:datetime]} type="datetime-local" class="native-input">
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:reminder_time]} type="time" class="native-input">
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:month]} type="month" class="native-input">
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:week]} type="week" class="native-input">
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          field={f[:tags]}
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
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input field={f[:color]} type="color" value="#3b82f6" class="native-input">
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:role]}
          type="select"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:size]}
          type="radio"
          value="m"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input field={f[:agree]} type="checkbox" class="native-input">
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" class="button button--accent">
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
        <p class="typo typo--sm font-medium">Date & time</p>
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
          class="native-input"
        >
          <:label>Tags</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input type="color" name="profile[color]" value="#3b82f6" class="native-input">
          <:label>Color</:label>
        </.native_input>
        <.native_input type="select" name="profile[role]" options={[Admin: "admin", User: "user"]} prompt="Choose role..." class="native-input">
          <:label>Role</:label>
        </.native_input>
        <.native_input type="radio" name="profile[size]" value="m" options={[Small: "s", Medium: "m", Large: "l"]} class="native-input">
          <:label>Size</:label>
        </.native_input>
        <.native_input type="checkbox" name="profile[agree]" class="native-input">
          <:label>I agree</:label>
        </.native_input>
      </div>
      <.action type="submit" class="button button--accent">
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

  def form_preview_controller_changeset(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id={@form.id}
      class="flex flex-col gap-6 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input
          field={f[:name]}
          type="text"
          id="native-input-changeset-name"
          placeholder="Your name"
          class="native-input"
        >
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:email]}
          type="email"
          id="native-input-changeset-email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:bio]}
          type="textarea"
          id="native-input-changeset-bio"
          placeholder="Short bio"
          class="native-input"
        >
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:website]}
          type="url"
          id="native-input-changeset-website"
          placeholder="https://example.com"
          class="native-input"
        >
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:phone]}
          type="tel"
          id="native-input-changeset-phone"
          placeholder="+1 234 567 8900"
          class="native-input"
        >
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:q]}
          type="search"
          id="native-input-changeset-q"
          placeholder="Search"
          class="native-input"
        >
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:count]}
          type="number"
          id="native-input-changeset-count"
          min={0}
          max={100}
          step={1}
          class="native-input"
        >
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:password]}
          type="password"
          id="native-input-changeset-password"
          class="native-input"
        >
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          field={f[:birth_date]}
          type="date"
          id="native-input-changeset-birth-date"
          class="native-input"
        >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:datetime]}
          type="datetime-local"
          id="native-input-changeset-datetime"
          class="native-input"
        >
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:reminder_time]}
          type="time"
          id="native-input-changeset-reminder-time"
          class="native-input"
        >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:month]}
          type="month"
          id="native-input-changeset-month"
          class="native-input"
        >
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:week]}
          type="week"
          id="native-input-changeset-week"
          class="native-input"
        >
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          field={f[:tags]}
          type="select"
          multiple
          id="native-input-changeset-tags"
          options={tag_options()}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input
          field={f[:color]}
          type="color"
          id="native-input-changeset-color"
          value="#3b82f6"
          class="native-input"
        >
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:role]}
          type="select"
          id="native-input-changeset-role"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:size]}
          type="radio"
          id="native-input-changeset-size"
          value="m"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:agree]}
          type="checkbox"
          id="native-input-changeset-agree"
          class="native-input"
        >
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" id="native-input-changeset-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_controller_validate(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id={@form.id}
      class="flex flex-col gap-6 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input
          field={f[:name]}
          type="text"
          id="native-input-validate-name"
          placeholder="Your name"
          class="native-input"
        >
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:email]}
          type="email"
          id="native-input-validate-email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:bio]}
          type="textarea"
          id="native-input-validate-bio"
          placeholder="Short bio"
          class="native-input"
        >
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:website]}
          type="url"
          id="native-input-validate-website"
          placeholder="https://example.com"
          class="native-input"
        >
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:phone]}
          type="tel"
          id="native-input-validate-phone"
          placeholder="+1 234 567 8900"
          class="native-input"
        >
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:q]}
          type="search"
          id="native-input-validate-q"
          placeholder="Search"
          class="native-input"
        >
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:count]}
          type="number"
          id="native-input-validate-count"
          min={0}
          max={100}
          step={1}
          class="native-input"
        >
          <:label>Count</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:password]}
          type="password"
          id="native-input-validate-password"
          class="native-input"
        >
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          field={f[:birth_date]}
          type="date"
          id="native-input-validate-birth-date"
          class="native-input"
        >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:datetime]}
          type="datetime-local"
          id="native-input-validate-datetime"
          class="native-input"
        >
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:reminder_time]}
          type="time"
          id="native-input-validate-reminder-time"
          class="native-input"
        >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:month]}
          type="month"
          id="native-input-validate-month"
          class="native-input"
        >
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:week]}
          type="week"
          id="native-input-validate-week"
          class="native-input"
        >
          <:label>Week</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          field={f[:tags]}
          type="select"
          multiple
          id="native-input-validate-tags"
          options={tag_options()}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input
          field={f[:color]}
          type="color"
          id="native-input-validate-color"
          value="#3b82f6"
          class="native-input"
        >
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:role]}
          type="select"
          id="native-input-validate-role"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:size]}
          type="radio"
          id="native-input-validate-size"
          value="m"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={f[:agree]}
          type="checkbox"
          id="native-input-validate-agree"
          class="native-input"
        >
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" id="native-input-validate-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_native(assigns) do
    _ = assigns

    ~H"""
    <form
      action={~p"/native-input/form"}
      method="post"
      id="native-input-plain-form"
      class="flex flex-col gap-6 w-full max-w-lg"
    >
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input
          type="text"
          name="profile[name]"
          id="native-input-form-name"
          placeholder="Your name"
          class="native-input"
        >
          <:label>Name</:label>
        </.native_input>
        <.native_input
          type="email"
          name="profile[email]"
          id="native-input-form-email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
        </.native_input>
        <.native_input
          type="textarea"
          name="profile[bio]"
          id="native-input-form-bio"
          placeholder="Short bio"
          class="native-input"
        >
          <:label>Bio</:label>
        </.native_input>
        <.native_input
          type="url"
          name="profile[website]"
          id="native-input-form-website"
          placeholder="https://example.com"
          class="native-input"
        >
          <:label>Website</:label>
        </.native_input>
        <.native_input
          type="tel"
          name="profile[phone]"
          id="native-input-form-phone"
          placeholder="+1 234 567 8900"
          class="native-input"
        >
          <:label>Phone</:label>
        </.native_input>
        <.native_input
          type="search"
          name="profile[q]"
          id="native-input-form-q"
          placeholder="Search"
          class="native-input"
        >
          <:label>Search</:label>
        </.native_input>
        <.native_input
          type="number"
          name="profile[count]"
          id="native-input-form-count"
          min={0}
          max={100}
          step={1}
          class="native-input"
        >
          <:label>Count</:label>
        </.native_input>
        <.native_input
          type="password"
          name="profile[password]"
          id="native-input-form-password"
          class="native-input"
        >
          <:label>Password</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          type="date"
          name="profile[birth_date]"
          id="native-input-form-birth-date"
          class="native-input"
        >
          <:label>Birth date</:label>
        </.native_input>
        <.native_input
          type="datetime-local"
          name="profile[datetime]"
          id="native-input-form-datetime"
          class="native-input"
        >
          <:label>Date and time</:label>
        </.native_input>
        <.native_input
          type="time"
          name="profile[reminder_time]"
          id="native-input-form-reminder-time"
          class="native-input"
        >
          <:label>Reminder time</:label>
        </.native_input>
        <.native_input
          type="month"
          name="profile[month]"
          id="native-input-form-month"
          class="native-input"
        >
          <:label>Month</:label>
        </.native_input>
        <.native_input
          type="week"
          name="profile[week]"
          id="native-input-form-week"
          class="native-input"
        >
          <:label>Week</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          type="select"
          multiple
          name="profile[tags][]"
          id="native-input-form-tags"
          options={tag_options()}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input
          type="color"
          name="profile[color]"
          id="native-input-form-color"
          value="#3b82f6"
          class="native-input"
        >
          <:label>Color</:label>
        </.native_input>
        <.native_input
          type="select"
          name="profile[role]"
          id="native-input-form-role"
          options={[Admin: "admin", User: "user"]}
          prompt="Choose role..."
          class="native-input"
        >
          <:label>Role</:label>
        </.native_input>
        <.native_input
          type="radio"
          name="profile[size]"
          id="native-input-form-size"
          value="m"
          options={[Small: "s", Medium: "m", Large: "l"]}
          class="native-input"
        >
          <:label>Size</:label>
        </.native_input>
        <.native_input
          type="checkbox"
          name="profile[agree]"
          id="native-input-form-agree"
          class="native-input"
        >
          <:label>I agree</:label>
        </.native_input>
      </div>
      <.action type="submit" id="native-input-form-submit" class="button button--accent">
        Submit
      </.action>
    </form>
    """
  end

  def form_doc_live_changeset_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
    >
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input field={@form[:name]} type="text" placeholder="Your name" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
    </.form>
    """
  end

  def form_doc_live_changeset_elixir do
    ~S"""
    def handle_event("validate", %{"profile" => params}, socket) do
      changeset =
        %MyApp.Forms.NativeInputProfile{}
        |> MyApp.Forms.NativeInputProfile.changeset(params)
        |> Map.put(:action, :validate)

      {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :validate, as: :profile, id: "native-input-live-profile-form"))}
    end

    def handle_event("save", %{"profile" => params}, socket) do
      case MyApp.Forms.NativeInputProfile.changeset(%MyApp.Forms.NativeInputProfile{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)
          {:noreply, assign(socket, :form, Phoenix.Component.to_form(MyApp.Forms.NativeInputProfile.changeset(%MyApp.Forms.NativeInputProfile{}, %{}), as: :profile, id: "native-input-live-profile-form"))}

        changeset ->
          {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, action: :insert, as: :profile, id: "native-input-live-profile-form"))}
      end
    end
    """
  end

  def form_doc_live_validate_heex do
    ~S"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
    >
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input field={@form[:name]} type="text" placeholder="Your name" class="native-input">
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
    </.form>
    """
  end

  def form_doc_live_validate_elixir do
    ~S"""
    def handle_event("validate_strict", %{"profile_strict" => params}, socket) do
      changeset =
        %MyApp.Forms.NativeInputProfile{}
        |> MyApp.Forms.NativeInputProfile.changeset_validate(params)
        |> Map.put(:action, :validate)

      {:noreply,
       assign(
         socket,
         :strict_form,
         Phoenix.Component.to_form(changeset, action: :validate, as: :profile_strict, id: "native-input-live-strict-form")
       )}
    end

    def handle_event("save_strict", %{"profile_strict" => params}, socket) do
      case MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          _data = Ecto.Changeset.apply_changes(changeset)

          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(
               MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, %{}),
               as: :profile_strict,
               id: "native-input-live-strict-form"
             )
           )}

        changeset ->
          {:noreply,
           assign(
             socket,
             :strict_form,
             Phoenix.Component.to_form(changeset, action: :insert, as: :profile_strict, id: "native-input-live-strict-form")
           )}
      end
    end
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_changeset(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate"
      phx-submit="save"
      class="flex flex-col gap-6 w-full max-w-lg"
    >
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
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
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          field={@form[:birth_date]}
          type="date"
          id="native-input-form-birth-date"
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
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          field={@form[:tags]}
          type="select"
          multiple
          id="native-input-form-tags"
          options={tag_options()}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
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
      </div>
      <.action type="submit" id="native-input-form-live-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def form_preview_live_validate(assigns) do
    ~H"""
    <.form
      for={@form}
      id={@form.id}
      phx-change="validate_strict"
      phx-submit="save_strict"
      class="flex flex-col gap-6 w-full max-w-lg"
    >
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input
          field={@form[:name]}
          type="text"
          id="native-input-strict-name"
          placeholder="Your name"
          class="native-input"
        >
          <:label>Name</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:email]}
          type="email"
          id="native-input-strict-email"
          placeholder="you@example.com"
          class="native-input"
        >
          <:label>Email</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:bio]}
          type="textarea"
          id="native-input-strict-bio"
          placeholder="Short bio (min 3 chars)"
          class="native-input"
        >
          <:label>Bio</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:website]}
          type="url"
          id="native-input-strict-website"
          placeholder="https://example.com"
          class="native-input"
        >
          <:label>Website</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:phone]}
          type="tel"
          id="native-input-strict-phone"
          placeholder="+1 234 567 8900"
          class="native-input"
        >
          <:label>Phone</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:q]}
          type="search"
          id="native-input-strict-q"
          placeholder="Search"
          class="native-input"
        >
          <:label>Search</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:count]}
          type="number"
          id="native-input-strict-count"
          min={0}
          max={100}
          step={1}
          class="native-input"
        >
          <:label>Count (1–98)</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:password]}
          type="password"
          id="native-input-strict-password"
          class="native-input"
        >
          <:label>Password</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          field={@form[:birth_date]}
          type="date"
          id="native-input-strict-birth-date"
          class="native-input"
        >
          <:label>Birth date</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:datetime]}
          type="datetime-local"
          id="native-input-strict-datetime"
          class="native-input"
        >
          <:label>Date and time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:reminder_time]}
          type="time"
          id="native-input-strict-reminder-time"
          class="native-input"
        >
          <:label>Reminder time</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:month]}
          type="month"
          id="native-input-strict-month"
          class="native-input"
        >
          <:label>Month</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:week]}
          type="week"
          id="native-input-strict-week"
          class="native-input"
        >
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
          id="native-input-strict-tags"
          options={tag_options()}
          prompt="Choose tags..."
          class="native-input"
        >
          <:label>Tags</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input
          field={@form[:color]}
          type="color"
          id="native-input-strict-color"
          value="#3b82f6"
          class="native-input"
        >
          <:label>Color</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
        <.native_input
          field={@form[:role]}
          type="select"
          id="native-input-strict-role"
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
          id="native-input-strict-size"
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
          id="native-input-strict-agree"
          class="native-input"
        >
          <:label>I agree</:label>
          <:error :let={msg}>{msg}</:error>
        </.native_input>
      </div>
      <.action type="submit" id="native-input-form-live-strict-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_code, do: form_native_heex()

  attr(:form, :any, required: true)

  def form_preview_controller_phoenix(assigns) do
    ~H"""
    <.form
      :let={f}
      for={@form}
      action={~p"/native-input/form"}
      method="post"
      id={@form.id}
    >
      <.native_input field={f[:email]} type="email" placeholder="you@example.com" class="native-input">
        <:label>Email</:label>
      </.native_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_controller_ecto(assigns), do: form_preview_controller_validate(assigns)
  def form_phoenix_heex, do: form_doc_controller_phoenix_heex()
  def form_phoenix_elixir, do: form_doc_controller_phoenix_elixir()
  def form_ecto_heex, do: form_validate_heex()
  def form_ecto_elixir, do: form_validate_elixir()
  def form_doc_live_ecto_heex, do: form_doc_live_validate_heex()

  attr(:form, :any, required: true)

  def form_preview_live_phoenix(assigns) do
    ~H"""
    <.form for={@form} id={@form.id} phx-submit="save_phoenix">
      <.native_input
        field={@form[:email]}
        type="email"
        placeholder="you@example.com"
        class="native-input"
      >
        <:label>Email</:label>
      </.native_input>
      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def form_preview_live_ecto(assigns), do: form_preview_live_validate(assigns)

  def form_doc_live_phoenix_elixir do
    ~S"""
    defmodule MyAppWeb.NativeInputFormLive do
      use MyAppWeb, :live_view

      def mount(_params, _session, socket) do
        phoenix_form =
          Phoenix.Component.to_form(%{"email" => "", "website" => "", "age" => ""}, as: :native_input_phoenix, id: "native-input-live-form-phoenix")

        {:ok, assign(socket, :phoenix_form, phoenix_form)}
      end

      def handle_event("save_phoenix", params, socket) do
        email = params["email"] || ""

        {:noreply,
         assign(
           socket,
           :phoenix_form,
           Phoenix.Component.to_form(%{"email" => email}, as: :native_input_phoenix, id: "native-input-live-form-phoenix")
         )}
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
          |> Phoenix.Component.to_form(as: :native_input_ecto, id: "native-input-live-form-ecto")

        {:ok, assign(socket, :ecto_form, ecto_form)}
      end

      def handle_event("validate", %{"native_input_ecto" => params}, socket) do
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
             as: :native_input_ecto,
             id: "native-input-live-form-ecto"
           )
         )}
      end

      def handle_event("save", %{"native_input_ecto" => params}, socket) do
        case MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params) do
          %Ecto.Changeset{valid?: true} = changeset ->
            _data = Ecto.Changeset.apply_changes(changeset)

            {:noreply,
             assign(
               socket,
               :ecto_form,
               Phoenix.Component.to_form(
                 MyApp.Forms.NativeInputProfile.changeset_validate(%MyApp.Forms.NativeInputProfile{}, params),
                 as: :native_input_ecto,
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
                 as: :native_input_ecto,
                 id: "native-input-live-form-ecto"
               )
             )}
        end
      end
    end
    """
  end
end
