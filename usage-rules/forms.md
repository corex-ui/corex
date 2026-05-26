# Corex forms

Corex has **no** `<.form>` component. Forms use standard Phoenix [`to_form/1`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#to_form/1) + Corex **input** components with `field={@form[:name]}`.

Discover field-capable attrs via MCP `get_component` for each input id.

## LiveView form pattern

```elixir
def mount(_params, _session, socket) do
  form =
    %Profile{}
    |> Profile.changeset(%{})
    |> to_form(as: :profile, id: "profile-form")

  {:ok, assign(socket, :form, form)}
end

def handle_event("validate", %{"profile" => params}, socket) do
  changeset =
    %Profile{}
    |> Profile.changeset(params)
    |> Map.put(:action, :validate)

  {:noreply, assign(socket, :form, to_form(changeset, action: :validate, as: :profile, id: "profile-form"))}
end

def handle_event("save", %{"profile" => params}, socket) do
  case Profile.changeset(%Profile{}, params) |> Repo.insert() do
    {:ok, _} -> {:noreply, socket |> put_flash(:info, "Saved") |> assign_forms()}
    {:error, changeset} -> {:noreply, assign(socket, :form, to_form(changeset, as: :profile, id: "profile-form"))}
  end
end
```

```heex
<.form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
  <.native_input field={@form[:name]} type="text" class="native-input">
    <:label>Name</:label>
  </.native_input>
  <.native_input field={@form[:email]} type="email" class="native-input">
    <:label>Email</:label>
  </.native_input>
  <.action type="submit" class="button button--accent">Save</.action>
</.form>
```

## Form-capable components

Each documents **Form** pages on Hexdocs and in e2e (`*_form_live.ex`):

| Component | Typical use |
|-----------|-------------|
| `native_input` | text, email, textarea, url, … |
| `checkbox` | boolean fields |
| `switch` | boolean toggle fields |
| `radio_group` | exclusive choice |
| `select` / `combobox` | pick from list (`select` + `multiple` for `{:array, :string}`) |
| `pin_input` | OTP codes |
| `number_input` | numeric |
| `password_input` | password |
| `date_picker` / `color_picker` | specialized |
| `tags_input` | free-form tags (`{:array, :string}`, submits `name[]` list params) |
| `file_upload` | uploads |

Use `field={@form[:field_name]}` when the component supports it. Check MCP for exact attr names.

## Array fields (`{:array, :string}`)

Phoenix expects list params such as `%{"tags" => ["a", "b"]}`.

| Component | When to use |
|-----------|-------------|
| `<.select multiple field={f[:tags]} items={…}>` | Tags chosen from a fixed option list |
| `<.tags_input field={f[:tags]}>` | Free-form tags (user types or pastes values) |
| `<.native_input type="select" multiple field={f[:tags]}>` | Plain HTML multi-select styling |

Both Corex `select` (with `multiple`) and `tags_input` submit `name[]` automatically when bound with `field={…}`. Do not comma-join in the changeset.

## Rules

- Give the form a stable `id` on `to_form(..., id: "…")` for LiveView diffing
- Use `phx-change="validate"` for live validation; set `changeset action: :validate`
- Submit with `<.action type="submit" class="button …">` — not raw `<button>` unless styled
- Import matching CSS: `native-input.css`, `checkbox.css`, etc.
- Register hooks for interactive inputs in `app.js`

## References

- https://hexdocs.pm/corex/manual_installation.html
- e2e: `NativeInputFormLive`, `CheckboxFormLive`, etc.
