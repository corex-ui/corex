# Forms

Corex form components accept `field={@form[:name]}` from [`Phoenix.Component.to_form/2`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#to_form/2). Set the form `id` in `to_form/2` and wrap fields in `<.form for={@form}>`.

Per-component wiring (checkbox, select, combobox, and others) lives in each module's **Form** section in Hexdocs. This guide covers patterns that apply across components.

## Error messages and `invalid` styling

[`Corex.FormField`](Corex.FormField.html) wires `id`, `name`, `form`, and errors into components that accept `field={...}`. It does **not** set `invalid` from changeset errors automatically.

- **Messages** still render through the `:error` slot when the field has errors and was used (`used_input?/1`).
- **Alert borders** (`data-invalid`) are opt-in: pass `invalid` yourself when you want visible invalid styling.

```heex
<.select
  field={@form[:country]}
  class="select"
  invalid={Corex.FormField.invalid?(@form[:country])}
>
  <:label>Your country of residence</:label>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
</.select>
```

Use `Corex.FormField.invalid?/1` on LiveView forms with `phx-change` so borders appear after the user interacts with a field, not on the initial empty render.

Static anatomy examples without a changeset can pass `invalid` directly on the component.

## LiveView validate flow

```heex
<.form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
  <.select
    field={@form[:country]}
    class="select"
    invalid={Corex.FormField.invalid?(@form[:country])}
    items={Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ])}
  >
    <:label>Country</:label>
    <:error :let={msg}>
      <.heroicon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.select>
  <.action type="submit" class="button button--accent">Save</.action>
</.form>
```

```elixir
def handle_event("validate", %{"profile" => params}, socket) do
  form =
    %MyApp.Form.Profile{}
    |> MyApp.Form.Profile.changeset_validate(params)
    |> to_form(action: :validate, as: :profile, id: "profile-form")

  {:noreply, assign(socket, :form, form)}
end
```

## Custom error presentation

Keep `invalid` off the control if you only want a custom affordance (for example a tooltip) without `data-invalid` on the host.

```heex
<.select field={@form[:country]} class="select relative">
  <:label>Your country of residence</:label>
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

## Invalid on error (inline + border)

Combine `:error` with explicit `invalid` when you want both inline messages and alert styling:

```heex
<.combobox
  field={@form[:currency]}
  class="combobox"
  invalid={Corex.FormField.invalid?(@form[:currency])}
  items={Corex.List.new([
    %{label: "Euro", value: "eur"},
    %{label: "US Dollar", value: "usd"},
    %{label: "British Pound", value: "gbp"}
  ])}
>
  <:label>Preferred currency</:label>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
</.combobox>
```

## Example schema

```elixir
defmodule MyApp.Form.PatternsForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :country, Ecto.Enum, values: [:fra, :deu, :bel]
    field :currency, :string
    field :tags, {:array, :string}
    field :terms, :boolean, default: false
    field :notifications, :boolean, default: false
    field :password, :string, redact: true
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:country, :currency, :tags, :terms, :notifications, :password])
    |> validate_required([:country, :currency, :tags, :password])
    |> validate_acceptance(:terms)
    |> validate_acceptance(:notifications)
    |> validate_inclusion(:currency, ~w(eur usd gbp))
    |> validate_length(:password, min: 8)
  end
end
```

## Component reference

Hover a **Component** link for the Hexdocs summary card. **Form** links jump to that module's Form section (anchors differ per component).

| Component | Form |
| --------- | ---- |
| [Corex.Checkbox](Corex.Checkbox.html) | [Form](Corex.Checkbox.html#module-form) |
| [Corex.Switch](Corex.Switch.html) | [Form](Corex.Switch.html#module-form) |
| [Corex.Select](Corex.Select.html) | [Form](Corex.Select.html#module-form) |
| [Corex.Combobox](Corex.Combobox.html) | [Form](Corex.Combobox.html#module-form) |
| [Corex.TagsInput](Corex.TagsInput.html) | [Form](Corex.TagsInput.html#module-form) |
| [Corex.RadioGroup](Corex.RadioGroup.html) | [Form](Corex.RadioGroup.html#module-form) |
| [Corex.NumberInput](Corex.NumberInput.html) | [Form](Corex.NumberInput.html#module-form) |
| [Corex.PasswordInput](Corex.PasswordInput.html) | [Form](Corex.PasswordInput.html#module-form) |
| [Corex.PinInput](Corex.PinInput.html) | [Form](Corex.PinInput.html#module-form) |
| [Corex.AngleSlider](Corex.AngleSlider.html) | [Form](Corex.AngleSlider.html#module-form) |
| [Corex.ColorPicker](Corex.ColorPicker.html) | — |
| [Corex.DatePicker](Corex.DatePicker.html) | [Form](Corex.DatePicker.html#module-form) |
| [Corex.Editable](Corex.Editable.html) | [Form](Corex.Editable.html#module-form) |
| [Corex.SignaturePad](Corex.SignaturePad.html) | [Form](Corex.SignaturePad.html#module-form) |
| [Corex.FileUpload](Corex.FileUpload.html) | [Form](Corex.FileUpload.html#module-form) |
| [Corex.NativeInput](Corex.NativeInput.html) | [Form](Corex.NativeInput.html#module-form) |
| [Corex.FileUploadLive](Corex.FileUploadLive.html) | [Form with submit](Corex.FileUploadLive.html#module-form-with-submit) |
