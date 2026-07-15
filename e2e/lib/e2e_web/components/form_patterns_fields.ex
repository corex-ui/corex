defmodule E2eWeb.FormPatternsFields do
  use E2eWeb, :html

  attr(:form, :any, required: true)
  attr(:prefix, :string, required: true)

  def custom_fields(assigns) do
    ~H"""
    <.select
      field={@form[:country]}
      class="select max-w-none w-full relative"
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
        <.tooltip
          id={"#{@prefix}-country-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
      </:error>
    </.select>

    <.combobox
      field={@form[:currency]}
      class="combobox max-w-none w-full relative"
      id={"#{@prefix}-currency"}
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
          id={"#{@prefix}-currency-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
      </:error>
    </.combobox>

    <.tags_input
      field={@form[:tags]}
      class="tags-input max-w-none w-full relative"
      id={"#{@prefix}-tags"}
    >
      <:label>Tags</:label>
      <:close>
        <.heroicon name="hero-x-mark" />
      </:close>
      <:error :let={msg} class="absolute top-0 end-0">
        <.tooltip
          id={"#{@prefix}-tags-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
      </:error>
    </.tags_input>

    <.password_input
      field={@form[:password]}
      class="password-input max-w-none w-full relative"
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
        <.tooltip
          id={"#{@prefix}-password-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
      </:error>
    </.password_input>

    <.switch
      field={@form[:notifications]}
      class="switch max-w-none w-full relative"
      id={"#{@prefix}-notifications"}
    >
      <:label>Email notifications</:label>
      <:error :let={msg} class="absolute top-0 end-0">
        <.tooltip
          id={"#{@prefix}-notifications-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
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
        <.tooltip
          id={"#{@prefix}-terms-tip"}
          class="tooltip ui-size-sm"
          positioning={%Corex.Positioning{placement: "top-end"}}
        >
          <:trigger>
            <.heroicon name="hero-exclamation-circle" class="icon text-alert-text" />
          </:trigger>
          <:content>{msg}</:content>
        </.tooltip>
      </:error>
    </.checkbox>
    """
  end

  def invalid_fields(assigns) do
    ~H"""
    <.select
      field={@form[:country]}
      class="select max-w-none w-full"
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
      class="combobox max-w-none w-full"
      id={"#{@prefix}-currency"}
      placeholder="Search currency"
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

    <.tags_input
      field={@form[:tags]}
      class="tags-input max-w-none w-full"
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

    <.password_input
      field={@form[:password]}
      class="password-input max-w-none w-full"
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

    <.switch
      field={@form[:notifications]}
      class="switch max-w-none w-full"
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
    """
  end

  defp country_items do
    [
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"}
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
