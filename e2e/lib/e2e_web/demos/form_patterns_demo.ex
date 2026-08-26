defmodule E2eWeb.Demos.FormPatternsDemo do
  use E2eWeb, :html

  alias E2eWeb.FormPatternsFields

  def form_ecto do
    ~S"""
    defmodule MyApp.Form.PatternsForm do
      use Ecto.Schema
      import Ecto.Changeset

      embedded_schema do
        field :name, :string
        field :country, Ecto.Enum, values: [:fra, :deu, :bel]
        field :currency, :string
        field :tags, {:array, :string}
        field :birth_date, :date
        field :signature, {:array, :string}
        field :level, :integer, default: 1
        field :terms, :boolean, default: false
        field :password, :string, redact: true
        field :notifications, :boolean, default: false
        field :role, :string
        field :pin, :string
        field :accent_color, :string
        field :heading_angle, :float
        field :title, :string
        field :avatar, :string
      end

      def changeset_validate(form, attrs \\ %{}) do
        form
        |> cast(attrs, [
          :name, :country, :currency, :tags, :birth_date, :signature, :level,
          :terms, :password, :notifications, :role, :pin, :accent_color,
          :heading_angle, :title, :avatar
        ])
        |> validate_required([
          :name, :country, :currency, :tags, :birth_date, :level, :password,
          :role, :pin, :accent_color, :heading_angle, :title, :avatar
        ])
        |> validate_acceptance(:terms)
        |> validate_acceptance(:notifications)
        |> validate_inclusion(:currency, ~w(eur usd gbp))
        |> validate_length(:password, min: 8)
        |> validate_inclusion(:role, ~w(admin editor viewer))
        |> validate_length(:pin, is: 4)
        |> validate_format(:pin, ~r/^\d+$/)
        |> validate_number(:heading_angle, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
        |> validate_accent_color_not_default()
        |> validate_heading_angle_not_default()
        |> validate_level_not_default()
        |> validate_signature_present()
        |> validate_tags_present()
        |> validate_avatar_present()
      end

      # Color/angle/level machine defaults — treat as blank until changed.
      defp validate_accent_color_not_default(changeset) do
        validate_change(changeset, :accent_color, fn :accent_color, value ->
          if default_accent_color?(value), do: [accent_color: "can't be blank"], else: []
        end)
      end

      defp validate_heading_angle_not_default(changeset) do
        validate_change(changeset, :heading_angle, fn :heading_angle, value ->
          if default_heading_angle?(value), do: [heading_angle: "can't be blank"], else: []
        end)
      end

      defp validate_level_not_default(changeset) do
        if default_level?(get_field(changeset, :level)) do
          add_error(changeset, :level, "can't be blank")
        else
          changeset
        end
      end

      defp default_accent_color?(value) when is_binary(value) do
        normalized = value |> String.trim() |> String.downcase()

        normalized in ["#000000", "#000", "000000", "000"] or
          Regex.match?(~r/^rgba\(\s*0\s*,\s*0\s*,\s*0\s*,/i, normalized) or
          Regex.match?(~r/^rgb\(\s*0\s*,\s*0\s*,\s*0\s*\)$/i, normalized)
      end

      defp default_accent_color?(_), do: false

      defp default_heading_angle?(value) when value in [0, 0.0], do: true
      defp default_heading_angle?(value) when is_binary(value), do: value in ["0", "0.0", "0.00"]
      defp default_heading_angle?(_), do: false

      defp default_level?(value) when value in [1, 1.0], do: true
      defp default_level?(value) when is_binary(value), do: value in ["1", "1.0", "1.00"]
      defp default_level?(_), do: false
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
      multipart
      class="flex w-full max-w-3xl flex-col gap-size-lg"
    >
      <.native_input field={@form[:name]} type="text" class="native-input relative">
        <:label>Name</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="name-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.native_input>

      <.select
        field={@form[:country]}
        class="select relative"
        deselectable
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={country_items()}
      >
        <:label>Your country of residence</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="country-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.select>

      <.combobox
        field={@form[:currency]}
        class="combobox relative"
        translation={%Corex.Combobox.Translation{placeholder: "Search currency", empty: "No results"}}
        items={currency_items()}
      >
        <:label>Preferred currency</:label>
        <:empty>No results</:empty>
        <:item :let={item}>
          <span class="font-mono text-xs uppercase place-self-end">{item.value}</span>
          <span>{item.label}</span>
        </:item>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="currency-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.combobox>

      <.tags_input field={@form[:tags]} class="tags-input relative">
        <:label>Tags</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="tags-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.tags_input>

      <.date_picker field={@form[:birth_date]} class="date-picker relative">
        <:label>Select a date</:label>
        <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="birth-date-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.date_picker>

      <.signature_pad field={@form[:signature]} class="signature-pad relative">
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="signature-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.signature_pad>

      <.number_input field={@form[:level]} min={1.0} max={5.0} step={1.0} class="number-input relative">
        <:label>Level</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="level-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.number_input>

      <.password_input field={@form[:password]} class="password-input relative">
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="password-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.password_input>

      <.switch field={@form[:notifications]} class="switch relative">
        <:label>Email notifications</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="notifications-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.switch>

      <.checkbox field={@form[:terms]} class="checkbox max-w-xs w-full relative">
        <:label>Accept the terms</:label>
        <:indicator><.heroicon name="hero-check" /></:indicator>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="terms-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.checkbox>

      <.radio_group field={@form[:role]} class="radio-group" items={[%{label: "Admin", value: "admin"}, %{label: "Editor", value: "editor"}, %{label: "Viewer", value: "viewer"}]}>
        <:label>Role</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="role-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.radio_group>

      <.pin_input field={@form[:pin]} count={4} class="pin-input">
        <:label>PIN</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="pin-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.pin_input>

      <.color_picker field={@form[:accent_color]} class="color-picker relative" presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}>
        <:label>Accent color</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="accent-color-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.color_picker>

      <.angle_slider field={@form[:heading_angle]} markers marker_values={[0, 90, 180, 270]} class="angle-slider">
        <:label>Heading angle</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="heading-angle-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.angle_slider>

      <.editable field={@form[:title]} placeholder="Enter title" activation_mode="dblclick" select_on_focus class="editable relative">
        <:label>Title</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="title-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.editable>

      <.file_upload field={@form[:avatar]} class="file-upload relative">
        <:label>Avatar</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg} class="absolute top-0 end-0">
          <.tooltip id="avatar-tip" class="tooltip ui-size-sm" positioning={%Corex.Positioning{placement: "top-end"}}>
            <:trigger><.heroicon name="hero-exclamation-circle" class="icon text-alert-text" /></:trigger>
            <:content>{msg}</:content>
          </.tooltip>
        </:error>
      </.file_upload>

      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def custom_error_elixir do
    ~S"""
    def handle_event("validate_custom", %{"patterns_custom" => params}, socket) do
      params = PatternsForm.normalize_avatar_params(params)

      form =
        %PatternsForm{}
        |> PatternsForm.changeset_validate(params)
        |> to_form(action: :validate, as: :patterns_custom, id: "form-patterns-custom-error")

      {:noreply, assign(socket, :custom_form, form)}
    end

    def handle_event("save_custom", %{"patterns_custom" => params}, socket) do
      params = PatternsForm.normalize_avatar_params(params)

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
      multipart
      class="flex w-full max-w-3xl flex-col gap-size-lg"
    >
      <.native_input field={@form[:name]} type="text" class="native-input" auto_invalid>
        <:label>Name</:label>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.native_input>

      <.select
        field={@form[:country]}
        class="select"
        deselectable
        auto_invalid
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={country_items()}
      >
        <:label>Your country of residence</:label>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.select>

      <.combobox
        field={@form[:currency]}
        class="combobox"
        translation={%Corex.Combobox.Translation{placeholder: "Search currency", empty: "No results"}}
        auto_invalid
        items={currency_items()}
      >
        <:label>Preferred currency</:label>
        <:empty>No results</:empty>
        <:item :let={item}>
          <span class="font-mono text-xs uppercase place-self-end">{item.value}</span>
          <span>{item.label}</span>
        </:item>
        <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.combobox>

      <.tags_input field={@form[:tags]} class="tags-input" auto_invalid>
        <:label>Tags</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.tags_input>

      <.date_picker field={@form[:birth_date]} class="date-picker" auto_invalid>
        <:label>Select a date</:label>
        <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
        <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
        <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.date_picker>

      <.signature_pad field={@form[:signature]} class="signature-pad" auto_invalid>
        <:label>Sign here</:label>
        <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.signature_pad>

      <.number_input field={@form[:level]} min={1.0} max={5.0} step={1.0} class="number-input" auto_invalid>
        <:label>Level</:label>
        <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
        <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.number_input>

      <.password_input field={@form[:password]} class="password-input" auto_invalid>
        <:label>Password</:label>
        <:visible_indicator><.heroicon name="hero-eye" /></:visible_indicator>
        <:hidden_indicator><.heroicon name="hero-eye-slash" /></:hidden_indicator>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.password_input>

      <.switch field={@form[:notifications]} class="switch" auto_invalid>
        <:label>Email notifications</:label>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.switch>

      <.checkbox field={@form[:terms]} class="checkbox max-w-xs w-full" auto_invalid>
        <:label>Accept the terms</:label>
        <:indicator><.heroicon name="hero-check" /></:indicator>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.checkbox>

      <.radio_group field={@form[:role]} class="radio-group" auto_invalid items={[%{label: "Admin", value: "admin"}, %{label: "Editor", value: "editor"}, %{label: "Viewer", value: "viewer"}]}>
        <:label>Role</:label>
        <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.radio_group>

      <.pin_input field={@form[:pin]} count={4} class="pin-input" auto_invalid>
        <:label>PIN</:label>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.pin_input>

      <.color_picker field={@form[:accent_color]} class="color-picker" auto_invalid presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}>
        <:label>Accent color</:label>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.color_picker>

      <.angle_slider field={@form[:heading_angle]} markers marker_values={[0, 90, 180, 270]} class="angle-slider" auto_invalid>
        <:label>Heading angle</:label>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.angle_slider>

      <.editable field={@form[:title]} placeholder="Enter title" activation_mode="dblclick" select_on_focus class="editable" auto_invalid>
        <:label>Title</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.editable>

      <.file_upload field={@form[:avatar]} class="file-upload" auto_invalid>
        <:label>Avatar</:label>
        <:close><.heroicon name="hero-x-mark" /></:close>
        <:error :let={msg}><.heroicon name="hero-exclamation-circle" class="icon" />{msg}</:error>
      </.file_upload>

      <.action type="submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end

  def invalid_on_error_elixir do
    ~S"""
    def handle_event("validate_invalid", %{"patterns_invalid" => params}, socket) do
      params = PatternsForm.normalize_avatar_params(params)

      form =
        %PatternsForm{}
        |> PatternsForm.changeset_validate(params)
        |> to_form(action: :validate, as: :patterns_invalid, id: "form-patterns-invalid-on-error")

      {:noreply, assign(socket, :invalid_form, form)}
    end

    def handle_event("save_invalid", %{"patterns_invalid" => params}, socket) do
      params = PatternsForm.normalize_avatar_params(params)

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
      multipart
      class="flex w-full max-w-3xl flex-col gap-size-lg"
    >
      <FormPatternsFields.custom_fields form={@form} prefix="form-patterns-custom-error" />
      <.action type="submit" id="form-patterns-custom-error-submit" class="button ui-accent">
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
      multipart
      class="flex w-full max-w-3xl flex-col gap-size-lg"
    >
      <FormPatternsFields.invalid_fields form={@form} prefix="form-patterns-invalid-on-error" />
      <.action type="submit" id="form-patterns-invalid-on-error-submit" class="button ui-accent">
        Submit
      </.action>
    </.form>
    """
  end
end
