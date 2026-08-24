defmodule E2eWeb.FormPatternsFields do
  use E2eWeb, :html

  attr(:form, :any, required: true)
  attr(:prefix, :string, required: true)

  def custom_fields(assigns) do
    ~H"""
    <.form_fieldset title={~t"Profile"}>
      <.native_input
        field={@form[:name]}
        type="text"
        class="native-input relative"
        id={"#{@prefix}-name"}
      >
        <:label>Name</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-name-tip"} msg={msg} />
        </:error>
      </.native_input>

      <.editable
        field={@form[:title]}
        placeholder="Enter title"
        activation_mode="dblclick"
        select_on_focus
        class="editable relative"
        id={"#{@prefix}-title"}
      >
        <:label>Title</:label>
        <:edit_trigger>
          <.heroicon name="hero-pencil-square" class="icon" />
        </:edit_trigger>
        <:submit_trigger>
          <.heroicon name="hero-check" class="icon" />
        </:submit_trigger>
        <:cancel_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:cancel_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-title-tip"} msg={msg} />
        </:error>
      </.editable>

      <.select
        field={@form[:country]}
        class="select relative"
        id={"#{@prefix}-country"}
        deselectable
        translation={%Corex.Select.Translation{placeholder: "Select a country"}}
        items={country_items()}
      >
        <:label>Your country of residence</:label>
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-country-tip"} msg={msg} />
        </:error>
      </.select>

      <.combobox
        field={@form[:currency]}
        class="combobox relative"
        id={"#{@prefix}-currency"}
        translation={%Corex.Combobox.Translation{placeholder: "Search currency", empty: "No results"}}
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
          <.custom_error_tip id={"#{@prefix}-currency-tip"} msg={msg} />
        </:error>
      </.combobox>
    </.form_fieldset>

    <.form_fieldset title={~t"Account"}>
      <.password_input
        field={@form[:password]}
        class="password-input relative"
        id={"#{@prefix}-password"}
      >
        <:label>Password</:label>
        <:visible_indicator>
          <.heroicon name="hero-eye" />
        </:visible_indicator>
        <:hidden_indicator>
          <.heroicon name="hero-eye-slash" />
        </:hidden_indicator>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-password-tip"} msg={msg} />
        </:error>
      </.password_input>

      <.pin_input
        field={@form[:pin]}
        count={4}
        class="pin-input relative"
        id={"#{@prefix}-pin"}
      >
        <:label>PIN</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-pin-tip"} msg={msg} />
        </:error>
      </.pin_input>

      <.number_input
        field={@form[:level]}
        min={1.0}
        max={5.0}
        step={1.0}
        class="number-input relative"
        id={"#{@prefix}-level"}
      >
        <:label>Level</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-level-tip"} msg={msg} />
        </:error>
      </.number_input>

      <.radio_group
        field={@form[:role]}
        class="radio-group relative sm:col-span-2"
        id={"#{@prefix}-role"}
        items={role_items()}
      >
        <:label>Role</:label>
        <:item_control>
          <.heroicon name="hero-check" class="data-checked" />
        </:item_control>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-role-tip"} msg={msg} />
        </:error>
      </.radio_group>
    </.form_fieldset>

    <.form_fieldset title={~t"Preferences"}>
      <.tags_input
        field={@form[:tags]}
        class="tags-input relative sm:col-span-2"
        id={"#{@prefix}-tags"}
      >
        <:label>Tags</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-tags-tip"} msg={msg} />
        </:error>
      </.tags_input>

      <.date_picker
        field={@form[:birth_date]}
        class="date-picker relative"
        id={"#{@prefix}-birth-date"}
      >
        <:label>Select a date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-birth-date-tip"} msg={msg} />
        </:error>
      </.date_picker>

      <.color_picker
        field={@form[:accent_color]}
        class="color-picker relative"
        id={"#{@prefix}-accent-color"}
        presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      >
        <:label>Accent color</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-accent-color-tip"} msg={msg} />
        </:error>
      </.color_picker>

      <.angle_slider
        field={@form[:heading_angle]}
        markers marker_values={[0, 90, 180, 270]}
        class="angle-slider relative"
        id={"#{@prefix}-heading-angle"}
      >
        <:label>Heading angle</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-heading-angle-tip"} msg={msg} />
        </:error>
      </.angle_slider>

      <.switch
        field={@form[:notifications]}
        class="switch relative"
        id={"#{@prefix}-notifications"}
      >
        <:label>Email notifications</:label>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-notifications-tip"} msg={msg} />
        </:error>
      </.switch>

      <.checkbox
        field={@form[:terms]}
        class="checkbox max-w-xs w-full relative"
        id={"#{@prefix}-terms"}
      >
        <:label>Accept the terms</:label>
        <:indicator>
          <.heroicon name="hero-check" />
        </:indicator>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-terms-tip"} msg={msg} />
        </:error>
      </.checkbox>
    </.form_fieldset>

    <.form_fieldset title={~t"Media"}>
      <.signature_pad
        field={@form[:signature]}
        class="signature-pad relative sm:col-span-2"
        id={"#{@prefix}-signature"}
      >
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-signature-tip"} msg={msg} />
        </:error>
      </.signature_pad>

      <.file_upload
        field={@form[:avatar]}
        class="file-upload relative sm:col-span-2"
        id={"#{@prefix}-avatar"}
      >
        <:label>Avatar</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg} class="absolute top-0 end-0">
          <.custom_error_tip id={"#{@prefix}-avatar-tip"} msg={msg} />
        </:error>
      </.file_upload>
    </.form_fieldset>
    """
  end

  def invalid_fields(assigns) do
    ~H"""
    <.form_fieldset title={~t"Profile"}>
      <.native_input
        field={@form[:name]}
        type="text"
        class="native-input"
        id={"#{@prefix}-name"}
        auto_invalid
      >
        <:label>Name</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.native_input>

      <.editable
        field={@form[:title]}
        placeholder="Enter title"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
        id={"#{@prefix}-title"}
        auto_invalid
      >
        <:label>Title</:label>
        <:edit_trigger>
          <.heroicon name="hero-pencil-square" class="icon" />
        </:edit_trigger>
        <:submit_trigger>
          <.heroicon name="hero-check" class="icon" />
        </:submit_trigger>
        <:cancel_trigger>
          <.heroicon name="hero-x-mark" class="icon" />
        </:cancel_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.editable>

      <.select
        field={@form[:country]}
        class="select"
        id={"#{@prefix}-country"}
        deselectable
        auto_invalid
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
        class="combobox"
        id={"#{@prefix}-currency"}
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
        <:trigger>
          <.heroicon name="hero-chevron-down" />
        </:trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.combobox>
    </.form_fieldset>

    <.form_fieldset title={~t"Account"}>
      <.password_input
        field={@form[:password]}
        class="password-input"
        id={"#{@prefix}-password"}
        auto_invalid
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

      <.pin_input
        field={@form[:pin]}
        count={4}
        class="pin-input"
        id={"#{@prefix}-pin"}
        auto_invalid
      >
        <:label>PIN</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.pin_input>

      <.number_input
        field={@form[:level]}
        min={1.0}
        max={5.0}
        step={1.0}
        class="number-input"
        id={"#{@prefix}-level"}
        auto_invalid
      >
        <:label>Level</:label>
        <:decrement_trigger>
          <.heroicon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.heroicon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.number_input>

      <.radio_group
        field={@form[:role]}
        class="radio-group sm:col-span-2"
        id={"#{@prefix}-role"}
        auto_invalid
        items={role_items()}
      >
        <:label>Role</:label>
        <:item_control>
          <.heroicon name="hero-check" class="data-checked" />
        </:item_control>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.radio_group>
    </.form_fieldset>

    <.form_fieldset title={~t"Preferences"}>
      <.tags_input
        field={@form[:tags]}
        class="tags-input sm:col-span-2"
        id={"#{@prefix}-tags"}
        auto_invalid
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

      <.date_picker
        field={@form[:birth_date]}
        class="date-picker"
        id={"#{@prefix}-birth-date"}
        auto_invalid
      >
        <:label>Select a date</:label>
        <:trigger>
          <.heroicon name="hero-calendar" class="icon" />
        </:trigger>
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" class="icon" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" class="icon" />
        </:next_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.date_picker>

      <.color_picker
        field={@form[:accent_color]}
        class="color-picker"
        id={"#{@prefix}-accent-color"}
        auto_invalid
        presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
      >
        <:label>Accent color</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.color_picker>

      <.angle_slider
        field={@form[:heading_angle]}
        markers marker_values={[0, 90, 180, 270]}
        class="angle-slider"
        id={"#{@prefix}-heading-angle"}
        auto_invalid
      >
        <:label>Heading angle</:label>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.angle_slider>

      <.switch
        field={@form[:notifications]}
        class="switch"
        id={"#{@prefix}-notifications"}
        auto_invalid
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
        id={"#{@prefix}-terms"}
        auto_invalid
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
    </.form_fieldset>

    <.form_fieldset title={~t"Media"}>
      <.signature_pad
        field={@form[:signature]}
        class="signature-pad sm:col-span-2"
        id={"#{@prefix}-signature"}
        auto_invalid
      >
        <:label>Sign here</:label>
        <:clear_trigger>
          <.heroicon name="hero-x-mark" />
        </:clear_trigger>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.signature_pad>

      <.file_upload
        field={@form[:avatar]}
        class="file-upload sm:col-span-2"
        id={"#{@prefix}-avatar"}
        auto_invalid
      >
        <:label>Avatar</:label>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
        <:error :let={msg}>
          <.heroicon name="hero-exclamation-circle" class="icon" />
          {msg}
        </:error>
      </.file_upload>
    </.form_fieldset>
    """
  end

  attr(:title, :string, required: true)
  slot(:inner_block, required: true)

  defp form_fieldset(assigns) do
    ~H"""
    <fieldset class="m-0 min-w-0 border-0 p-0">
      <legend class="mb-space-sm px-0 text-sm font-semibold tracking-wide text-ink-muted uppercase">
        {@title}
      </legend>
      <div class="grid grid-cols-1 gap-space-lg sm:grid-cols-2">
        {render_slot(@inner_block)}
      </div>
    </fieldset>
    """
  end

  attr(:id, :string, required: true)
  attr(:msg, :string, required: true)

  defp custom_error_tip(assigns) do
    ~H"""
    <.tooltip
      id={@id}
      class="tooltip ui-size-sm"
      positioning={%Corex.Positioning{placement: "top-end"}}
    >
      <:trigger>
        <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
      </:trigger>
      <:content>{@msg}</:content>
    </.tooltip>
    """
  end

  defp country_items do
    [
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
    ]
  end

  defp role_items do
    [
      %{label: "Admin", value: "admin"},
      %{label: "Editor", value: "editor"},
      %{label: "Viewer", value: "viewer"}
    ]
  end

  defp currency_items do
    [
      %{value: "eur", label: ~t"Euro"},
      %{value: "usd", label: ~t"US Dollar"},
      %{value: "gbp", label: ~t"British Pound"},
      %{value: "jpy", label: ~t"Japanese Yen"},
      %{value: "chf", label: ~t"Swiss Franc"},
      %{value: "cad", label: ~t"Canadian Dollar"},
      %{value: "aud", label: ~t"Australian Dollar"},
      %{value: "sek", label: ~t"Swedish Krona"},
      %{value: "nok", label: ~t"Norwegian Krone"},
      %{value: "sgd", label: ~t"Singapore Dollar"}
    ]
  end
end
