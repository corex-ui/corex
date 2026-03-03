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

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="layout__header">
      <div class="layout__header__content">
      <div class="layout__row">
          <a href="/" class="link md:link--md lg:link--lg link--brand font-ui-xl uppercase after:content-none">
            <span>Corex</span>
          </a>
        </div>
      </div>
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
end
