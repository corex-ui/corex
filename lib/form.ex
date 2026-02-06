defmodule Corex.Form do
  @moduledoc ~S'''
  Helper functions to work with forms.

  Corex form components such as `Corex.Checkbox` and `Corex.Select` with classic form and with Phoenix form using the `Phoenix.Component.form/1` function.

  ## Examples

  ### Classic Form

  In a classic form, you can use the `name` attribute to identify the checkbox.
  The generated parameters will be as follows:  `/?terms=true`

  This works in Controller View and Live View

  ```heex
  <form id="my-form">
    <.checkbox name="terms" class="checkbox">
      <:label>I accept the terms</:label>
    </.checkbox>
    <button type="submit">Submit</button>
  </form>
  ```

  ### Phoenix Form

   When using with Phoenix forms, you must add an id to the form using the `Corex.Form.get_form_id/1` function.

  ### Controller

```elixir
defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  def home(conn, params) do
    form = Phoenix.Component.to_form(Map.get(params, "user", %{}), as: :user)
    render(conn, :home, form: form)
  end
end
```

  ```heex
<.form :let={f} as={:user} for={@form} id={get_form_id(@form)} method="get">
  <.checkbox field={f[:terms]} class="checkbox">
    <:label>I accept the terms</:label>
      <:error :let={msg}>
    <.icon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
  </.checkbox>
  <button type="submit">Submit</button>
</.form>
  ```

  #### In a Live View


 You must use the `Corex.Form.get_form_id/1` function to get the form id and pass it to the form component.


  ```elixir
 defmodule MyAppWeb.CheckboxLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    form = to_form(%{"terms" => "false"}, as: :user)
    {:ok, socket |> assign(:form, form)}
  end

  def render(assigns) do
    ~H"""
    <.form as={:user} for={@form} id={get_form_id(@form)}>
    <.checkbox field={@form[:terms]} class="checkbox">
      <:label>I accept the terms</:label>
        <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
    """
  end
  end
  ```

    ### With Ecto changeset

When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

This allows the Live View to be the source of truth and the component to be in sync accordingly


  '''

  alias Phoenix.Component
  alias Phoenix.HTML.Form
  alias Ecto.Changeset

  @doc """
  Returns the form id.

  Accepts either:
    * an `Ecto.Changeset`
    * a `Phoenix.HTML.Form`

  ## Examples

  #### In a Controller

  ```heex
  <.form :let={f} for={@changeset} id={get_form_id(@changeset)}>
    <.checkbox field={f[:terms]} class="checkbox">
      <:label>I accept the terms</:label>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
  ```

  #### In a Live View

  ```heex
  <.form for={@form} id={get_form_id(@form)}>
    <.checkbox field={@form[:terms]} controlled class="checkbox">
      <:label>I accept the terms</:label>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
  ```
  """
  @spec get_form_id(Form.t() | Changeset.t()) :: binary()
  def get_form_id(%Form{id: id}) when is_binary(id), do: id

  def get_form_id(%Changeset{} = changeset) do
    changeset
    |> Component.to_form()
    |> Map.fetch!(:id)
  end

  def get_form_id(other) do
    raise ArgumentError,
          "expected Ecto.Changeset or Phoenix.HTML.Form, got: #{inspect(other)}"
  end
end
