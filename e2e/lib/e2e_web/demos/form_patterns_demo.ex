defmodule E2eWeb.Demos.FormPatternsDemo do
  use E2eWeb, :html

  alias E2eWeb.FormPatternsFields

  def form_ecto do
    ~S"""
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
    """
  end

  def custom_error_heex do
    ~S"""
    <.form
      for={@form}
      id="form-patterns-custom-error"
      phx-change="validate_custom"
      phx-submit="save_custom"
    >
      <.select
        field={@form[:country]}
        class="select max-w-none w-full relative"
        id="form-patterns-custom-error-country"
        deselectable
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={country_items()}
      >
        <:label>Your country of residence</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-country-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.select>

      <.combobox
        field={@form[:currency]}
        class="combobox max-w-none w-full relative"
        id="form-patterns-custom-error-currency"
        placeholder="Search currency"
        items={currency_items()}
      >
        <:label>Preferred currency</:label>
        <:empty>No results</:empty>
        <:item :let={item}>
          <span class="font-mono text-xs uppercase place-self-end">{item.value}</span>
          <span>{item.label}</span>
        </:item>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-currency-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.combobox>

      <.tags_input
        field={@form[:tags]}
        class="tags-input max-w-none w-full relative"
        id="form-patterns-custom-error-tags"
      >
        <:label>Tags</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-tags-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.tags_input>

      <.password_input
        field={@form[:password]}
        class="password-input max-w-none w-full relative"
        id="form-patterns-custom-error-password"
      >
        <:label>Password</:label>
        <:visible_indicator>
          <.heroicon name="hero-eye" />
        </:visible_indicator>
        <:hidden_indicator>
          <.heroicon name="hero-eye-slash" />
        </:hidden_indicator>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-password-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.password_input>

      <.switch
        field={@form[:notifications]}
        class="switch max-w-none w-full relative"
        id="form-patterns-custom-error-notifications"
      >
        <:label>Email notifications</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-notifications-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.switch>

      <.checkbox
        field={@form[:terms]}
        class="checkbox max-w-xs w-full relative"
        id="form-patterns-custom-error-terms"
      >
        <:label>Accept the terms</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip
            id="form-patterns-custom-error-terms-tip"
            class="tooltip tooltip--sm"
            positioning={%Corex.Positioning{placement: "top-end"}}
          >
            <:trigger>
              <.heroicon name="hero-exclamation-circle" class="icon text-ink-alert" />
            </:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.checkbox>

      <.action type="submit" class="button button--accent">
        Submit
      </.action>
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

    def handle_event("save_custom", %{"patterns_custom" => params}, socket) do
      case PatternsForm.changeset_validate(%PatternsForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           socket
           |> put_flash(:info, "Submitted")
           |> assign(:custom_form, to_form(changeset, as: :patterns_custom, id: "form-patterns-custom-error"))}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :custom_form,
             to_form(changeset, as: :patterns_custom, id: "form-patterns-custom-error", action: :insert)
           )}
      end
    end
    """
  end

  def invalid_on_error_heex do
    ~S"""
    <.form
      for={@form}
      id="form-patterns-invalid-on-error"
      phx-change="validate_invalid"
      phx-submit="save_invalid"
    >
      <.select
        field={@form[:country]}
        class="select max-w-none w-full"
        id="form-patterns-invalid-on-error-country"
        deselectable
        invalid={Corex.FormField.invalid?(@form[:country])}
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={country_items()}
      >
        <:label>Your country of residence</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.select>

      <.combobox
        field={@form[:currency]}
        class="combobox max-w-none w-full"
        id="form-patterns-invalid-on-error-currency"
        placeholder="Search currency"
        invalid={Corex.FormField.invalid?(@form[:currency])}
        items={currency_items()}
      >
        <:label>Preferred currency</:label>
        <:empty>No results</:empty>
        <:item :let={item}>
          <span class="font-mono text-xs uppercase place-self-end">{item.value}</span>
          <span>{item.label}</span>
        </:item>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>

      <.tags_input
        field={@form[:tags]}
        class="tags-input max-w-none w-full"
        id="form-patterns-invalid-on-error-tags"
        invalid={Corex.FormField.invalid?(@form[:tags])}
      >
        <:label>Tags</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.tags_input>

      <.password_input
        field={@form[:password]}
        class="password-input max-w-none w-full"
        id="form-patterns-invalid-on-error-password"
        invalid={Corex.FormField.invalid?(@form[:password])}
      >
        <:label>Password</:label>
        <:visible_indicator>
          <.heroicon name="hero-eye" />
        </:visible_indicator>
        <:hidden_indicator>
          <.heroicon name="hero-eye-slash" />
        </:hidden_indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.password_input>

      <.switch
        field={@form[:notifications]}
        class="switch max-w-none w-full"
        id="form-patterns-invalid-on-error-notifications"
        invalid={Corex.FormField.invalid?(@form[:notifications])}
      >
        <:label>Email notifications</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.switch>

      <.checkbox
        field={@form[:terms]}
        class="checkbox max-w-xs w-full"
        id="form-patterns-invalid-on-error-terms"
        invalid={Corex.FormField.invalid?(@form[:terms])}
      >
        <:label>Accept the terms</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.checkbox>

      <.action type="submit" class="button button--accent">
        Submit
      </.action>
    </.form>
    """
  end

  def invalid_on_error_elixir do
    ~S"""
    def handle_event("validate_invalid", %{"patterns_invalid" => params}, socket) do
      form =
        %PatternsForm{}
        |> PatternsForm.changeset_validate(params)
        |> to_form(action: :validate, as: :patterns_invalid, id: "form-patterns-invalid-on-error")

      {:noreply, assign(socket, :invalid_form, form)}
    end

    def handle_event("save_invalid", %{"patterns_invalid" => params}, socket) do
      case PatternsForm.changeset_validate(%PatternsForm{}, params) do
        %Ecto.Changeset{valid?: true} = changeset ->
          {:noreply,
           socket
           |> put_flash(:info, "Submitted")
           |> assign(:invalid_form, to_form(changeset, as: :patterns_invalid, id: "form-patterns-invalid-on-error"))}

        %Ecto.Changeset{} = changeset ->
          {:noreply,
           assign(socket, :invalid_form,
             to_form(changeset, as: :patterns_invalid, id: "form-patterns-invalid-on-error", action: :insert)
           )}
      end
    end
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
