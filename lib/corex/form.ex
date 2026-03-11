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
  def checkbox_form_page(conn, _params) do
    form =
      %MyApp.Form.Terms{}
      |> MyApp.Form.Terms.changeset(%{})
      |> Phoenix.Component.to_form(as: :terms, id: "checkbox-form")
    render(conn, :checkbox_form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} id={Corex.Form.get_form_id(@form)} method="get">
  <.checkbox field={f[:terms]} class="checkbox">
    <:label>I accept the terms</:label>
      <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" class="icon" />
    {msg}
  </:error>
  </.checkbox>
  <button type="submit">Submit</button>
  </.form>
  ```

  #### In a Live View

  Use `Corex.Form.get_form_id/1` for the form `id`. For a form without Ecto validation you can build the form from a map:

  ```elixir
  def mount(_params, _session, socket) do
    form = to_form(%{"terms" => "false"}, as: :terms)
    {:ok, assign(socket, :form, form)}
  end
  ```

  ```heex
  <.form for={@form} id={Corex.Form.get_form_id(@form)}>
    <.checkbox field={@form[:terms]} class="checkbox">
      <:label>I accept the terms</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### With Ecto changeset

  When using Ecto changeset for validation and inside a Live view you must enable the controlled mode.

  This allows the Live View to be the source of truth and the component to be in sync accordingly

  First create an embedded schema and changeset:

  ```elixir
  defmodule MyApp.Form.Terms do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :terms, :boolean, default: false
    end

    def changeset(terms, attrs \\ %{}) do
      terms
      |> cast(attrs, [:terms])
      |> validate_required([:terms])
      |> validate_acceptance(:terms)
    end
  end
  ```

  ```elixir
  defmodule MyAppWeb.CheckboxFormLive do
    use MyAppWeb, :live_view
    alias MyApp.Form.Terms
    alias Corex.Form

    def mount(_params, _session, socket) do
      form = %Terms{} |> Terms.changeset(%{}) |> to_form(as: :terms)
      {:ok, assign(socket, :form, form)}
    end

    def handle_event("validate", %{"terms" => params}, socket) do
      changeset = Terms.changeset(%Terms{}, params)
      {:noreply, assign(socket, :form, to_form(changeset, action: :validate, as: :terms))}
    end

    def render(assigns) do
      ~H"""
      <.form for={@form} id={Form.get_form_id(@form)} phx-change="validate" phx-submit="save">
        <.checkbox field={@form[:terms]} class="checkbox" controlled>
        <:label>I accept the terms</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
        </.checkbox>
      </.form>
      """
    end
  end
  ```

  Other Corex form components (e.g. `Corex.Select`, `Corex.RadioGroup`, `Corex.Switch`) follow the same pattern: use `Corex.Form.get_form_id/1` on the form and pass `field={@form[:field_name]}` or `field={f[:field_name]}` with `:let={f}`.
  '''

  alias Ecto.Changeset
  alias Phoenix.Component
  alias Phoenix.HTML.Form

  @doc """
  Returns the form id.

  Accepts either:
    * an `Ecto.Changeset`
    * a `Phoenix.HTML.Form`

  ## Examples

  When the form is built with `Phoenix.Component.to_form/2`, use the form assign:

  ```heex
  <.form :let={f} for={@form} id={Corex.Form.get_form_id(@form)}>
    <.checkbox field={f[:terms]} class="checkbox">
      <:label>I accept the terms</:label>
    </.checkbox>
    <button type="submit">Submit</button>
  </.form>
  ```

  In a LiveView with controlled checkbox:

  ```heex
  <.form for={@form} id={Corex.Form.get_form_id(@form)} phx-change="validate" phx-submit="save">
    <.checkbox field={@form[:terms]} class="checkbox" controlled>
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
