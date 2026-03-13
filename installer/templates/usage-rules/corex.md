# Corex Components

Complete guide to Corex components. Use them correctly for forms, data structures, and UI.

## Setup

- `use Corex` in `*_web.ex` (or equivalent) to import Corex components.

## Action vs Navigate

- **`<.action>`:** Buttons — `phx-click`, `type="submit"`, `type="button"`. Use for all in-page actions.
- **`<.navigate>`:** Links — `type="navigate"`, `type="patch"`, `type="href"`. Use for navigation.
- Never use raw `<button>` or `<a>` for these cases.

## Icons

- Use `<.heroicon name="hero-x-mark" />` (or similar). Never use Heroicons Elixir modules directly.

## Forms with Corex

- Use `<.form for={@form}>` with `to_form/2`-based forms.
- Use `<.native_input type="..." field={@form[:field]}>` for text, email, textarea, select, radio, checkbox, date, etc.
- Use `<.select>`, `<.checkbox>`, `<.date_picker>`, `<.combobox>`, etc. with `field={@form[:field]}`.
- Pass `<:label>`, `<:error :let={msg}>` where supported.
- Use `phx-change="validate"`, `phx-submit="save"` and handle in LiveView.

## Data structures

- **`<.data_list>`:** Key-value style list; use `<:item title="Label">` slots.
- **`<.data_table>`:** Table with `<:col :let={row} label="...">`, optional `<:action :let={row}>`, sortable (`on_sort`, `sort_by`, `sort_order`), selectable (`selectable`, `selected`, `on_select`, `on_select_all`).
- **Streams + data_table:** Pass `rows={@streams.users}`; use `row_id` and `row_item` for stream `{id, item}` shape.

## Component catalog

- `action`, `navigate`, `heroicon`, `native_input`, `checkbox`, `select`, `combobox`, `listbox`, `data_list`, `data_table`
- `dialog`, `toast`, `toast_group`, `toast_client_error`, `toast_server_error`
- `accordion`, `tabs`, `floating_panel`, `collapsible`
- `avatar`, `switch`, `toggle_group`, `password_input`, `number_input`, `pin_input`, `date_picker`, `signature_pad`, `color_picker`
- `menu`, `tree_view`, `carousel`, `marquee`, `editable`, `clipboard`, `code`, `timer`, `angle_slider`, `hidden_input`

## Slots and attributes

- Use `attr` and `slot` per component docs; `:let` for slot variables.
- Many components use `field={@form[:x]}` for form integration.
