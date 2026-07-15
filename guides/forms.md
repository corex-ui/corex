# Forms

Corex form components accept `field={@form[:name]}` from [`Phoenix.Component.to_form/2`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#to_form/2). Set the form `id` in `to_form/2` and wrap fields in `<.form for={@form}>`.

The examples below use [`Corex.Checkbox`](Corex.Checkbox.html) and [`Corex.Select`](Corex.Select.html). The same patterns apply to other form components; see each module's **Form** section in Hexdocs.

## Example schema

```elixir
defmodule MyApp.Form.Preferences do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :terms, :boolean, default: false
    field :country, Ecto.Enum, values: [:fra, :deu, :bel]
  end

  def changeset(preferences, attrs \\ %{}) do
    preferences
    |> cast(attrs, [:terms, :country])
    |> validate_required([:terms, :country])
    |> validate_acceptance(:terms)
  end

  def changeset_validate(preferences, attrs \\ %{}) do
    preferences
    |> cast(attrs, [:terms, :country])
    |> validate_required([:terms, :country], message: "can't be blank")
    |> validate_acceptance(:terms, message: "must be accepted to continue")
  end
end
```

## Controller

Build the form from a changeset, render with `<.form>`, and post to a controller action.

```elixir
def preferences_page(conn, _params) do
  form =
    %MyApp.Form.Preferences{}
    |> MyApp.Form.Preferences.changeset(%{})
    |> Phoenix.Component.to_form(as: :preferences, id: "preferences-form")

  render(conn, :preferences, form: form)
end

def preferences_create(conn, %{"preferences" => params}) do
  case MyApp.Form.Preferences.changeset(%MyApp.Form.Preferences{}, params) do
    %Ecto.Changeset{valid?: true} = changeset ->
      data = Ecto.Changeset.apply_changes(changeset)
      conn
      |> put_flash(:info, "Saved: terms=#{data.terms}, country=#{data.country}")
      |> redirect(to: "/account")

    changeset ->
      changeset = Map.put(changeset, :action, :insert)

      form =
        Phoenix.Component.to_form(changeset, as: :preferences, id: "preferences-form")

      render(conn, :preferences, form: form)
  end
end
```

```heex
<.form :let={f} for={@form} action="/account/preferences" method="post">
  <.checkbox field={f[:terms]} class="checkbox">
    <:label>Accept terms</:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>

  <.select
    field={f[:country]}
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:label>Country</:label>
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.select>

  <.action type="submit" class="button button--accent">Submit</.action>
</.form>
```

## LiveView

Use an Ecto changeset as the source of truth. Add `phx-change` so validation runs as the user edits. On `<.select>`, pass `controlled` when the form is driven by LiveView (see [`Corex.Select`](Corex.Select.html#module-form)).

```elixir
def mount(_params, _session, socket) do
  form =
    %MyApp.Form.Preferences{}
    |> MyApp.Form.Preferences.changeset_validate(%{})
    |> to_form(action: :validate, as: :preferences, id: "preferences-form")

  {:ok, assign(socket, :form, form)}
end

def handle_event("validate", %{"preferences" => params}, socket) do
  form =
    %MyApp.Form.Preferences{}
    |> MyApp.Form.Preferences.changeset_validate(params)
    |> to_form(action: :validate, as: :preferences, id: "preferences-form")

  {:noreply, assign(socket, :form, form)}
end

def handle_event("save", %{"preferences" => params}, socket) do
  case MyApp.Form.Preferences.changeset(%MyApp.Form.Preferences{}, params) do
    %Ecto.Changeset{valid?: true} = changeset ->
      data = Ecto.Changeset.apply_changes(changeset)
      {:noreply, put_flash(socket, :info, "Saved: country=#{data.country}")}

    changeset ->
      {:noreply,
       assign(socket, :form, to_form(changeset, action: :validate, as: :preferences, id: "preferences-form"))}
  end
end
```

```heex
<.form for={@form} id="preferences-form" phx-change="validate" phx-submit="save">
  <.checkbox
    field={@form[:terms]}
    class="checkbox"
  >
    <:label>Accept terms</:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.checkbox>

  <.select
    field={@form[:country]}
    class="select"
    controlled
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:label>Country</:label>
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.select>

  <.action type="submit" class="button button--accent">Save</.action>
</.form>
```

## Native form (plain HTML)

Use `name` on the component when you are not using `to_form/2`. Checkbox values follow Phoenix's checkbox param convention.

```heex
<form action="/register" method="post">
  <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

  <.checkbox name="user[accept_terms]" class="checkbox">
    <:label>Accept terms</:label>
  </.checkbox>

  <.select
    name="user[country]"
    class="select"
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:label>Country</:label>
    <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  </.select>

  <.action type="submit" class="button button--accent">Submit</.action>
</form>
```

```elixir
def register_create(conn, %{"user" => %{"accept_terms" => terms, "country" => country}}) do
  checked = Phoenix.HTML.Form.normalize_value("checkbox", terms)

  conn
  |> put_flash(:info, "Submitted: terms=#{inspect(checked)}, country=#{country}")
  |> redirect(to: "/register")
end
```

## Ecto validation (strict messages)

Use a dedicated `changeset_validate/2` with stricter messages for controller re-render or LiveView `phx-change`. The HEEx is the same as in **Controller** or **LiveView**; only the changeset function differs.

```elixir
def preferences_validate_page(conn, _params) do
  changeset =
    MyApp.Form.Preferences.changeset_validate(%MyApp.Form.Preferences{}, %{})

  form =
    Phoenix.Component.to_form(changeset, as: :preferences_validate, id: "preferences-validate-form")

  render(conn, :preferences_validate, form: form)
end

def preferences_validate_create(conn, %{"preferences_validate" => params}) do
  case MyApp.Form.Preferences.changeset_validate(%MyApp.Form.Preferences{}, params) do
    %Ecto.Changeset{valid?: true} = changeset ->
      data = Ecto.Changeset.apply_changes(changeset)
      conn
      |> put_flash(:info, "Saved: country=#{data.country}")
      |> redirect(to: "/account")

    changeset ->
      form =
        Phoenix.Component.to_form(
          Map.put(changeset, :action, :insert),
          as: :preferences_validate,
          id: "preferences-validate-form"
        )

      render(conn, :preferences_validate, form: form)
  end
end
```

In LiveView, call `changeset_validate/2` inside `handle_event("validate", ...)` the same way as in the **LiveView** section above.

## Error messages and `invalid` styling

Pass `field={@form[:name]}` so the component picks up ids, names, and errors.

- **Messages** render through the `:error` slot when the field has errors and was used (`used_input?/1`).
- **Alert borders** (`data-invalid`) stay off by default. Pass `auto_invalid` to derive them from visible errors, `invalid={true}` to force, or `invalid={false}` to suppress when `auto_invalid` is also set. For a custom `invalid={...}` expression, use [`Corex.FormField.invalid?/1`](Corex.FormField.html#invalid?/1).

```heex
<.checkbox field={@form[:terms]} auto_invalid class="checkbox">
  <:label>Accept terms</:label>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
</.checkbox>

<.select
  field={@form[:country]}
  auto_invalid
  class="select"
  controlled
  items={Corex.List.new([
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"}
  ])}
>
  <:label>Country</:label>
  <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
</.select>
```

Static demos without a changeset can pass `invalid` directly on the component.

## LiveView used-input tracking

Corex form hooks sync values into named inputs and notify LiveView so `used_input?/1` and `_unused_*` omission stay correct. Use `phoenix_live_view` `~> 1.1`.

Pass `field={@form[:name]}` (or an explicit stable `id`) so morphdom patches keep the same input nodes across LiveView updates. Without a stable id, remounts can drop client-side used state until the next interaction. Form components raise at render time when neither `field` nor a non-empty `id` is provided (including styling demos and Hexdocs samples you copy into LiveView).

## Custom error presentation

Omit `auto_invalid` (the default) if you only want a custom affordance (for example a tooltip) without `data-invalid` on the host.

```heex
<.select field={@form[:country]} class="select relative" controlled>
  <:label>Country</:label>
  <:error :let={msg} class="absolute top-0 end-0">
    <.tooltip class="tooltip tooltip--sm" positioning={%Corex.Positioning{placement: "top-end"}}>
      <:trigger>
        <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
      </:trigger>
      <:content>{msg}</:content>
    </.tooltip>
  </:error>
</.select>
```

The `:error` slot still receives translated messages from the changeset; only the presentation changes.

## Component reference

Hover a **Component** link for the Hexdocs summary card. **Form** links jump to that module's Form section.

| Component | Form |
| --------- | ---- |
| [Corex.AngleSlider](Corex.AngleSlider.html) | [Form](Corex.AngleSlider.html#module-form) |
| [Corex.Checkbox](Corex.Checkbox.html) | [Form](Corex.Checkbox.html#module-form) |
| [Corex.ColorPicker](Corex.ColorPicker.html) | [Form](Corex.ColorPicker.html#module-form) |
| [Corex.Combobox](Corex.Combobox.html) | [Form](Corex.Combobox.html#module-form) |
| [Corex.DatePicker](Corex.DatePicker.html) | [Form](Corex.DatePicker.html#module-form) |
| [Corex.Editable](Corex.Editable.html) | [Form](Corex.Editable.html#module-form) |
| [Corex.FileUpload](Corex.FileUpload.html) | [Form](Corex.FileUpload.html#module-form) |
| [Corex.FileUploadLive](Corex.FileUploadLive.html) | [Form with submit](Corex.FileUploadLive.html#module-form-with-submit) |
| [Corex.NativeInput](Corex.NativeInput.html) | [Form](Corex.NativeInput.html#module-form) |
| [Corex.NumberInput](Corex.NumberInput.html) | [Form](Corex.NumberInput.html#module-form) |
| [Corex.PasswordInput](Corex.PasswordInput.html) | [Form](Corex.PasswordInput.html#module-form) |
| [Corex.PinInput](Corex.PinInput.html) | [Form](Corex.PinInput.html#module-form) |
| [Corex.RadioGroup](Corex.RadioGroup.html) | [Form](Corex.RadioGroup.html#module-form) |
| [Corex.Select](Corex.Select.html) | [Form](Corex.Select.html#module-form) |
| [Corex.SignaturePad](Corex.SignaturePad.html) | [Form](Corex.SignaturePad.html#module-form) |
| [Corex.Switch](Corex.Switch.html) | [Form](Corex.Switch.html#module-form) |
| [Corex.TagsInput](Corex.TagsInput.html) | [Form](Corex.TagsInput.html#module-form) |
