defmodule <%= @web_namespace %>.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use <%= @web_namespace %>, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
<%= if @mode do %>
  attr :mode, :string, default: "light"
<% end %><%= if @theme do %>
  attr :theme, :string, default: "neo"
<% end %><%= if @theme_switcher do %>
  attr :themes, :list, default: []
<% end %><%= if @language_switcher do %>
  attr :locale, :string, default: "en"
  attr :current_path, :string, default: "/"
  attr :locales, :list, default: []
<% end %>
  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="layout__header">
      <div class="layout__header__content">
        <div class="layout__row gap-0 sm:gap-1">
          <a
            href="/"
            class="link md:link--md lg:link--lg link--brand font-ui-xl uppercase after:content-none"
          >
            <span>Corex</span>
          </a>
        </div>
<%= if @mode or @theme_switcher or @language_switcher do %>
        <div class="layout__row gap-0 sm:gap-1">
<%= if @mode do %>
          <.mode_toggle mode={@mode} />
<% end %><%= if @theme_switcher do %>
          <.theme_toggle theme={@theme} themes={@themes} />
<% end %><%= if @language_switcher do %>
          <.locale_switcher locale={@locale} current_path={@current_path} />
<% end %>
        </div>
<% else %>        <div class="layout__row gap-0 sm:gap-1"></div>
<% end %>      </div>
    </header>

    <main class="layout__main">
      <div class="layout__content">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.toast_group id="layout-toast" class="toast" flash={@flash}>
      <:loading>
        <.icon name="hero-arrow-path" />
      </:loading>
    </.toast_group>

    <.toast_client_error
      toast_group_id="layout-toast"
      title={gettext("We can't find the internet")}
      description={gettext("Attempting to reconnect")}
      type={:error}
      duration={:infinity}
    />

    <.toast_server_error
      toast_group_id="layout-toast"
      title={gettext("Something went wrong!")}
      description={gettext("Attempting to reconnect")}
      type={:error}
      duration={:infinity}
    />
    """
  end
<%= if @language_switcher do %>

  attr :locale, :string, default: "en"
  attr :current_path, :string, default: "/"
  attr :locales, :list, default: []

  def locale_switcher(assigns) do
    ~H"""
    <.select
      id="locale-select"
      class="select select--sm select--micro"
      collection={Enum.map(@locales, fn loc -> %{id: "/#{loc}#{@current_path}", label: String.upcase(loc)} end)}
      value={["/#{@locale}#{@current_path}"]}
      redirect
      on_value_change="locale_change"
    >
      <:label class="sr-only">
        Language
      </:label>
      <:item :let={item}>
        {item.label}
      </:item>
      <:trigger>
        <.icon name="hero-language" />
      </:trigger>
      <:item_indicator>
        <.icon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end
<% end %><%= if @theme_switcher do %>

  attr :theme, :string, default: "neo"
  attr :themes, :list, default: []

  def theme_toggle(assigns) do
    ~H"""
    <.select
      id="theme-select"
      class="select select--sm select--micro"
      collection={Enum.map(@themes, fn t -> %{id: t, label: String.capitalize(t)} end)}
      value={[@theme]}
      on_value_change_client="phx:set-theme"
    >
      <:label class="sr-only">
        Theme
      </:label>
      <:item :let={item}>
        {item.label}
      </:item>
      <:trigger>
        <.icon name="hero-swatch" />
      </:trigger>
      <:item_indicator>
        <.icon name="hero-check" />
      </:item_indicator>
    </.select>
    """
  end
<% end %><%= if @mode do %>

  attr :mode, :string, default: "light"

  def mode_toggle(assigns) do
    ~H"""
    <.toggle_group
      id="mode-switcher"
      class="toggle-group toggle-group--sm toggle-group--circle toggle-group--inverted"
      value={if @mode == "dark", do: ["dark"], else: []}
      on_value_change_client="phx:set-mode"
    >
      <:item value="dark">
        <.icon name="hero-sun" class="icon state-on" />
        <.icon name="hero-moon" class="icon state-off" />
      </:item>
    </.toggle_group>
    """
  end
<% end %>end
