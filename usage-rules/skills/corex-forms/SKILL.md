---
name: corex-forms
description: >-
  Load when building Phoenix forms with to_form, phx-change validate, phx-submit,
  field={@form[:name]}, native_input checkbox select switch radio_group in
  lib/*_web/*_form_live.ex or *_form_live.ex, or when asked about Corex form
  inputs. Corex has no .form component — use Phoenix.Component.to_form/1.
---

# Corex forms

No `<.form>` component — Phoenix `to_form/1` + Corex inputs with `field={@form[:…]}`.

## Minimal profile form

```heex
<.form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
  <.native_input field={@form[:name]} type="text" class="native-input">
    <:label>Name</:label>
  </.native_input>
  <.action type="submit" class="button ui-accent">Save</.action>
</.form>
```

```elixir
def handle_event("validate", %{"profile" => params}, socket) do
  changeset = %Profile{} |> Profile.changeset(params) |> Map.put(:action, :validate)
  {:noreply, assign(socket, :form, to_form(changeset, action: :validate, as: :profile, id: "profile-form"))}
end
```

Import matching CSS (`native-input.css`, etc.) and register hooks. MCP `get_component` for `field` attr on each input.

For `{:array, :string}` fields, use `field :tags, {:array, :string}` and either `<.select multiple field={@form[:tags]} items={…}>` (fixed options) or `<.tags_input field={@form[:tags]}>` (free-form). Both submit `%{"tags" => ["a", "b"]}` via `name[]`; do not use comma strings on `:string` fields.

Full checklist: sub-rule `corex:forms`.
