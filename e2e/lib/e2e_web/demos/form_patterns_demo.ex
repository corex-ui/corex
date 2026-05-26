defmodule E2eWeb.Demos.FormPatternsDemo do
  use E2eWeb, :html

  alias E2eWeb.FormPatternsFields

  def form_ecto do
    ~S"""
    defmodule E2e.Form.PatternsForm do
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
    """
  end

  def custom_error_heex do
    ~S"""
    <.form for={@form} phx-change="validate_custom" phx-submit="save_custom">
      <.select field={@form[:country]} class="select w-full relative">
        <:label>Your country of residence</:label>
        <:error :let={_msg} class="absolute top-0 end-0">
          <.tooltip class="tooltip tooltip--sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" /></:trigger>
            <:content>{error messages}</:content>
          </.tooltip>
        </:error>
      </.select>
      <.combobox field={@form[:currency]} class="combobox max-w-none relative" items={currency_items()}>
        <:error :let={_msg} class="absolute top-0 end-0">…</:error>
      </.combobox>
    </.form>
    """
  end

  def custom_error_elixir do
    ~S"""
    def handle_event("validate_custom", %{"patterns_custom" => params}, socket) do
      form =
        %PatternsForm{}
        |> PatternsForm.changeset_validate(params)
        |> to_form(action: :validate, as: :patterns_custom, id: "form-patterns-custom-error")

      {:noreply, assign(socket, :custom_form, form)}
    end
    """
  end

  def invalid_on_error_heex do
    ~S"""
    <.select
      field={@form[:country]}
      class="select max-w-none"
      invalid={Corex.FormField.invalid?(@form[:country])}
    >
      <:label>Your country of residence</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.select>
    """
  end

  def invalid_on_error_elixir do
    ~S"""
    <.combobox field={@form[:currency]} invalid={Corex.FormField.invalid?(@form[:currency])}>
      <:error :let={msg}>…</:error>
    </.combobox>
    """
  end

  attr(:form, :any, required: true)

  def custom_error_preview(assigns) do
    ~H"""
    <.form
      for={@form}
      id="form-patterns-custom-error"
      phx-change="validate_custom"
      phx-submit="save_custom"
      class="flex flex-col gap-space-lg max-w-xs"
    >
      <FormPatternsFields.custom_fields form={@form} prefix="form-patterns-custom-error" />
      <.action type="submit" id="form-patterns-custom-error-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  attr(:form, :any, required: true)

  def invalid_on_error_preview(assigns) do
    ~H"""
    <.form
      for={@form}
      id="form-patterns-invalid-on-error"
      phx-change="validate_invalid"
      phx-submit="save_invalid"
      class="flex flex-col gap-space-lg max-w-xs"
    >
      <FormPatternsFields.invalid_fields form={@form} prefix="form-patterns-invalid-on-error" />
      <.action type="submit" id="form-patterns-invalid-on-error-submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end
end
