defmodule E2eWeb.Demos.NativeInputFormFields do
  @moduledoc false
  use E2eWeb, :html

  attr(:id_prefix, :string, default: "native-input-all")
  attr(:input_class, :string, default: "native-input")
  attr(:dir, :string, default: nil)
  attr(:name_prefix, :string, default: "user")

  def anatomy_all_fields(assigns) do
    ~H"""
    <div class="flex flex-col gap-8" dir={@dir}>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Text</p>
        <.native_input
          type="text"
          id={"#{@id_prefix}-text-icon"}
          name={"#{@name_prefix}[name]"}
          class={@input_class}
        >
          <:label>Text</:label>
          <:icon><.heroicon name="hero-pencil-square" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="text"
          id={"#{@id_prefix}-text"}
          name={"#{@name_prefix}[name]"}
          class={@input_class}
        >
          <:label>Text</:label>
        </.native_input>
        <.native_input
          type="textarea"
          id={"#{@id_prefix}-bio"}
          name={"#{@name_prefix}[bio]"}
          class={@input_class}
        >
          <:label>Bio</:label>
        </.native_input>
        <.native_input
          type="email"
          id={"#{@id_prefix}-email-icon"}
          name={"#{@name_prefix}[email]"}
          class={@input_class}
        >
          <:label>Email</:label>
          <:icon><.heroicon name="hero-envelope" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="email"
          id={"#{@id_prefix}-email"}
          name={"#{@name_prefix}[email]"}
          class={@input_class}
        >
          <:label>Email</:label>
        </.native_input>
        <.native_input
          type="url"
          id={"#{@id_prefix}-url-icon"}
          name={"#{@name_prefix}[website]"}
          class={@input_class}
        >
          <:label>Website</:label>
          <:icon><.heroicon name="hero-link" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="url"
          id={"#{@id_prefix}-url"}
          name={"#{@name_prefix}[website]"}
          class={@input_class}
        >
          <:label>Website</:label>
        </.native_input>
        <.native_input
          type="tel"
          id={"#{@id_prefix}-tel-icon"}
          name={"#{@name_prefix}[phone]"}
          class={@input_class}
        >
          <:label>Phone</:label>
          <:icon><.heroicon name="hero-phone" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="tel"
          id={"#{@id_prefix}-tel"}
          name={"#{@name_prefix}[phone]"}
          class={@input_class}
        >
          <:label>Phone</:label>
        </.native_input>
        <.native_input
          type="search"
          id={"#{@id_prefix}-search-icon"}
          name="q"
          class={@input_class}
          placeholder="Search"
        >
          <:label>Search</:label>
          <:icon><.heroicon name="hero-magnifying-glass" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="search"
          id={"#{@id_prefix}-search"}
          name="q"
          class={@input_class}
          placeholder="Search"
        >
          <:label>Search</:label>
        </.native_input>
        <.native_input
          type="password"
          id={"#{@id_prefix}-password-icon"}
          name={"#{@name_prefix}[password]"}
          class={@input_class}
        >
          <:label>Password</:label>
          <:icon><.heroicon name="hero-lock-closed" class="icon" /></:icon>
        </.native_input>
        <.native_input
          type="password"
          id={"#{@id_prefix}-password"}
          name={"#{@name_prefix}[password]"}
          class={@input_class}
        >
          <:label>Password</:label>
        </.native_input>
        <.native_input
          type="number"
          id={"#{@id_prefix}-number"}
          name={"#{@name_prefix}[count]"}
          value="42"
          min="0"
          max="100"
          step="1"
          class={@input_class}
        >
          <:label>Number</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Date & time</p>
        <.native_input
          type="date"
          id={"#{@id_prefix}-date"}
          name={"#{@name_prefix}[date]"}
          class={@input_class}
        >
          <:label>Date</:label>
        </.native_input>
        <.native_input
          type="datetime-local"
          id={"#{@id_prefix}-datetime"}
          name={"#{@name_prefix}[datetime]"}
          class={@input_class}
        >
          <:label>Date and time</:label>
        </.native_input>
        <.native_input
          type="time"
          id={"#{@id_prefix}-time"}
          name={"#{@name_prefix}[time]"}
          class={@input_class}
        >
          <:label>Time</:label>
        </.native_input>
        <.native_input
          type="month"
          id={"#{@id_prefix}-month"}
          name={"#{@name_prefix}[month]"}
          class={@input_class}
        >
          <:label>Month</:label>
        </.native_input>
        <.native_input
          type="week"
          id={"#{@id_prefix}-week"}
          name={"#{@name_prefix}[week]"}
          class={@input_class}
        >
          <:label>Week</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Multiple</p>
        <.native_input
          type="select"
          multiple
          id={"#{@id_prefix}-tags"}
          name={"#{@name_prefix}[tags][]"}
          options={E2eWeb.Demos.NativeInputDemo.tag_options()}
          prompt="Choose tags..."
          class={@input_class}
        >
          <:label>Tags</:label>
        </.native_input>
      </div>
      <div class="flex flex-col gap-3">
        <p class="typo typo--sm font-medium">Other</p>
        <.native_input
          type="checkbox"
          id={"#{@id_prefix}-agree"}
          name={"#{@name_prefix}[agree]"}
          class={@input_class}
        >
          <:label>I agree</:label>
        </.native_input>
        <.native_input
          type="color"
          id={"#{@id_prefix}-color"}
          name={"#{@name_prefix}[color]"}
          value="#3b82f6"
          class={@input_class}
        >
          <:label>Color</:label>
        </.native_input>
        <.native_input
          type="radio"
          id={"#{@id_prefix}-size"}
          name={"#{@name_prefix}[size]"}
          options={[{"Small", "s"}, {"Medium", "m"}, {"Large", "l"}]}
          value="m"
          class={@input_class}
        >
          <:label>Size</:label>
        </.native_input>
        <.native_input
          type="select"
          id={"#{@id_prefix}-role"}
          name={"#{@name_prefix}[role]"}
          options={[{"Admin", "admin"}, {"User", "user"}]}
          prompt="Choose a role..."
          class={@input_class}
        >
          <:label>Role</:label>
        </.native_input>
      </div>
    </div>
    """
  end

  attr(:variant, :atom, required: true, values: [:ecto, :native])
  attr(:id_prefix, :string, required: true)
  attr(:f, :any, default: nil)
  attr(:name_prefix, :string, default: "profile")

  def form_full_fields(%{variant: :ecto, f: f} = assigns) when not is_nil(f) do
    assigns = assign(assigns, :f, f)

    ~H"""
    <div class="flex flex-col gap-3">
      <p class="typo typo--sm font-medium">Text</p>
      <.native_input
        field={@f[:name]}
        type="text"
        id={"#{@id_prefix}-name"}
        placeholder="Your name"
        class="native-input"
      >
        <:label>Name</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:email]}
        type="email"
        id={"#{@id_prefix}-email"}
        placeholder="you@example.com"
        class="native-input"
      >
        <:label>Email</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:bio]}
        type="textarea"
        id={"#{@id_prefix}-bio"}
        placeholder="Short bio"
        class="native-input"
      >
        <:label>Bio</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:website]}
        type="url"
        id={"#{@id_prefix}-website"}
        placeholder="https://example.com"
        class="native-input"
      >
        <:label>Website</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:phone]}
        type="tel"
        id={"#{@id_prefix}-phone"}
        placeholder="+1 234 567 8900"
        class="native-input"
      >
        <:label>Phone</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:q]}
        type="search"
        id={"#{@id_prefix}-q"}
        placeholder="Search"
        class="native-input"
      >
        <:label>Search</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:count]}
        type="number"
        id={"#{@id_prefix}-count"}
        min={0}
        max={100}
        step={1}
        class="native-input"
      >
        <:label>Count</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:password]}
        type="password"
        id={"#{@id_prefix}-password"}
        class="native-input"
      >
        <:label>Password</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
    </div>
    <div class="flex flex-col gap-3">
      <p class="typo typo--sm font-medium">Date & time</p>
      <.native_input
        field={@f[:birth_date]}
        type="date"
        id={"#{@id_prefix}-birth-date"}
        class="native-input"
      >
        <:label>Birth date</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:datetime]}
        type="datetime-local"
        id={"#{@id_prefix}-datetime"}
        class="native-input"
      >
        <:label>Date and time</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:reminder_time]}
        type="time"
        id={"#{@id_prefix}-reminder-time"}
        class="native-input"
      >
        <:label>Reminder time</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input field={@f[:month]} type="month" id={"#{@id_prefix}-month"} class="native-input">
        <:label>Month</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input field={@f[:week]} type="week" id={"#{@id_prefix}-week"} class="native-input">
        <:label>Week</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
    </div>
    <div class="flex flex-col gap-3">
      <p class="typo typo--sm font-medium">Multiple</p>
      <.native_input
        field={@f[:tags]}
        type="select"
        multiple
        id={"#{@id_prefix}-tags"}
        options={E2eWeb.Demos.NativeInputDemo.tag_options()}
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
        field={@f[:color]}
        type="color"
        id={"#{@id_prefix}-color"}
        value="#3b82f6"
        class="native-input"
      >
        <:label>Color</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:role]}
        type="select"
        id={"#{@id_prefix}-role"}
        options={[Admin: "admin", User: "user"]}
        prompt="Choose role..."
        class="native-input"
      >
        <:label>Role</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:size]}
        type="radio"
        id={"#{@id_prefix}-size"}
        options={[Small: "s", Medium: "m", Large: "l"]}
        class="native-input"
      >
        <:label>Size</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
      <.native_input
        field={@f[:agree]}
        type="checkbox"
        id={"#{@id_prefix}-agree"}
        class="native-input"
      >
        <:label>I agree</:label>
        <:error :let={msg}>{msg}</:error>
      </.native_input>
    </div>
    """
  end

  def form_full_fields(%{variant: :native} = assigns) do
    ~H"""
    <div class="flex flex-col gap-3">
      <p class="typo typo--sm font-medium">Text</p>
      <.native_input
        type="text"
        name={"#{@name_prefix}[name]"}
        id={"#{@id_prefix}-name"}
        placeholder="Your name"
        class="native-input"
      >
        <:label>Name</:label>
      </.native_input>
      <.native_input
        type="email"
        name={"#{@name_prefix}[email]"}
        id={"#{@id_prefix}-email"}
        placeholder="you@example.com"
        class="native-input"
      >
        <:label>Email</:label>
      </.native_input>
      <.native_input
        type="textarea"
        name={"#{@name_prefix}[bio]"}
        id={"#{@id_prefix}-bio"}
        placeholder="Short bio"
        class="native-input"
      >
        <:label>Bio</:label>
      </.native_input>
      <.native_input
        type="url"
        name={"#{@name_prefix}[website]"}
        id={"#{@id_prefix}-website"}
        placeholder="https://example.com"
        class="native-input"
      >
        <:label>Website</:label>
      </.native_input>
      <.native_input
        type="tel"
        name={"#{@name_prefix}[phone]"}
        id={"#{@id_prefix}-phone"}
        placeholder="+1 234 567 8900"
        class="native-input"
      >
        <:label>Phone</:label>
      </.native_input>
      <.native_input
        type="search"
        name={"#{@name_prefix}[q]"}
        id={"#{@id_prefix}-q"}
        placeholder="Search"
        class="native-input"
      >
        <:label>Search</:label>
      </.native_input>
      <.native_input
        type="number"
        name={"#{@name_prefix}[count]"}
        id={"#{@id_prefix}-count"}
        min={0}
        max={100}
        step={1}
        class="native-input"
      >
        <:label>Count</:label>
      </.native_input>
      <.native_input
        type="password"
        name={"#{@name_prefix}[password]"}
        id={"#{@id_prefix}-password"}
        class="native-input"
      >
        <:label>Password</:label>
      </.native_input>
    </div>
    <div class="flex flex-col gap-3">
      <p class="typo typo--sm font-medium">Date & time</p>
      <.native_input
        type="date"
        name={"#{@name_prefix}[birth_date]"}
        id={"#{@id_prefix}-birth-date"}
        class="native-input"
      >
        <:label>Birth date</:label>
      </.native_input>
      <.native_input
        type="datetime-local"
        name={"#{@name_prefix}[datetime]"}
        id={"#{@id_prefix}-datetime"}
        class="native-input"
      >
        <:label>Date and time</:label>
      </.native_input>
      <.native_input
        type="time"
        name={"#{@name_prefix}[reminder_time]"}
        id={"#{@id_prefix}-reminder-time"}
        class="native-input"
      >
        <:label>Reminder time</:label>
      </.native_input>
      <.native_input
        type="month"
        name={"#{@name_prefix}[month]"}
        id={"#{@id_prefix}-month"}
        class="native-input"
      >
        <:label>Month</:label>
      </.native_input>
      <.native_input
        type="week"
        name={"#{@name_prefix}[week]"}
        id={"#{@id_prefix}-week"}
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
        name={"#{@name_prefix}[tags][]"}
        id={"#{@id_prefix}-tags"}
        options={E2eWeb.Demos.NativeInputDemo.tag_options()}
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
        name={"#{@name_prefix}[color]"}
        id={"#{@id_prefix}-color"}
        value="#3b82f6"
        class="native-input"
      >
        <:label>Color</:label>
      </.native_input>
      <.native_input
        type="select"
        name={"#{@name_prefix}[role]"}
        id={"#{@id_prefix}-role"}
        options={[Admin: "admin", User: "user"]}
        prompt="Choose role..."
        class="native-input"
      >
        <:label>Role</:label>
      </.native_input>
      <.native_input
        type="radio"
        name={"#{@name_prefix}[size]"}
        id={"#{@id_prefix}-size"}
        options={[Small: "s", Medium: "m", Large: "l"]}
        class="native-input"
      >
        <:label>Size</:label>
      </.native_input>
      <.native_input
        type="checkbox"
        name={"#{@name_prefix}[agree]"}
        id={"#{@id_prefix}-agree"}
        class="native-input"
      >
        <:label>I agree</:label>
      </.native_input>
    </div>
    """
  end
end
