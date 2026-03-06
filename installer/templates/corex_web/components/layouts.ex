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
<%= if @mode or @theme_switcher do %>
        <div class="layout__row gap-0 sm:gap-1">
<%= if @mode do %>          <.mode_toggle mode={@mode} />
<% end %><%= if @theme_switcher do %>          <.theme_toggle theme={@theme} themes={@themes} />
<% end %>        </div>
<% else %>        <div class="layout__row gap-0 sm:gap-1"></div>
<% end %>      </div>
    </header>

    <main class="layout__main">
      <div class="layout__content">
        {render_slot(@inner_block)}
      </div>
    </main>

    <footer class="layout__footer">
      <div class="layout__footer__content gap-ui-gap justify-center md:justify-between">
        <div class="layout__row gap-0 sm:gap-1">
          <a
            href="https://github.com/corex-ui/corex"
            target="_blank"
            class="button button--sm button--circle"
            aria-label=<%= maybe_heex_attr_gettext.("Go to Corex UI Github", @gettext) %>
          >
            <svg
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 102 102"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z"
                fill="currentColor"
              />
            </svg>
          </a>
          <a
            href="https://hexdocs.pm/corex"
            target="_blank"
            class="button button--sm button--circle"
            aria-label=<%= maybe_heex_attr_gettext.("Go to Corex Hex docs", @gettext) %>
          >
            <svg
              aria-hidden="true"
              width="114"
              height="100"
              viewBox="0 0 114 100"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <g id="Group">
                <g id="Group_2">
                  <path
                    id="Vector"
                    d="M47.7086 28.06H65.1941C66.3521 28.06 67.3942 28.4064 68.4364 28.8683L84.1849 0.923785C82.9112 0.346419 81.5216 0 80.0162 0H32.8865C31.1495 0 29.5283 0.461893 28.1388 1.2702L44.2347 28.8683C45.2769 28.2909 46.4348 28.06 47.7086 28.06Z"
                    fill="#FFCC1D"
                  />
                </g>
                <g id="Group_3">
                  <path
                    id="Vector_2"
                    d="M71.2156 31.5242L79.9005 46.5357C80.4794 47.575 80.8268 48.8452 80.8268 49.9999L113.019 50.0001C113.019 48.3834 112.44 46.7667 111.629 45.381L88.1221 4.61897C87.1957 3.00234 85.8061 1.73214 84.185 0.923828L68.4316 28.8608C69.5896 29.5536 70.5208 30.3695 71.2156 31.5242Z"
                    fill="#57CC99"
                  />
                </g>
                <g id="Group_4">
                  <path
                    id="Vector_3"
                    d="M80.827 50C80.827 51.1547 80.4796 52.4249 79.9006 53.4642L71.2158 68.4757C70.6368 69.515 69.7104 70.4387 68.784 71.0161L84.8799 98.6142C86.1537 97.8059 87.3117 96.6511 88.1222 95.3809L111.745 54.6189C112.556 53.2332 113.019 51.6166 113.019 50H80.827Z"
                    fill="#1597E5"
                  />
                </g>
                <g id="Group_5">
                  <path
                    id="Vector_4"
                    d="M65.1943 71.9394H47.7088C46.5508 71.9394 45.5045 71.7067 44.5781 71.2448L28.8325 99.0767C30.1063 99.654 31.3813 99.9994 32.7709 99.9994H80.0164C81.7534 99.9994 83.4993 99.532 84.8889 98.6082L68.784 71.0156C67.626 71.593 66.468 71.9394 65.1943 71.9394Z"
                    fill="#AE4CCF"
                  />
                </g>
                <g id="Group_6">
                  <path
                    id="Vector_5"
                    d="M33.0024 46.535L41.6872 31.5235C42.2662 30.4842 43.3099 29.435 44.2363 28.8577L28.1389 1.26953C26.8651 2.07784 25.7071 3.23257 24.8965 4.61825L1.27378 45.3803C0.463192 46.7659 0 48.3826 0 49.9992H32.076C32.076 48.8445 32.4234 47.5743 33.0024 46.535Z"
                    fill="#FF8243"
                  />
                </g>
                <g id="Group_7">
                  <path
                    id="Vector_6"
                    d="M41.6872 68.4757L33.0024 53.4642C32.4234 52.4249 32.076 51.1547 32.076 50H0C0 51.6166 0.463192 53.2332 1.27378 54.6189L24.8965 95.3809C25.8229 96.9976 27.2125 98.2678 28.8337 99.0761L44.5822 71.2471C43.3084 70.5542 42.382 69.6304 41.6872 68.4757Z"
                    fill="#FF4848"
                  />
                </g>
              </g>
            </svg>
          </a>
        </div>
<%= if @language_switcher do %>
        <div class="layout__row gap-0 sm:gap-1">
          <.locale_switcher locale={@locale} current_path={@current_path} />
        </div>
<% end %>      </div>
    </footer>

    <.toast_group id="layout-toast" class="toast" flash={@flash}>
      <:loading>
        <.heroicon name="hero-arrow-path" />
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

  def locale_switcher(assigns) do
    locales = Application.get_env(:<%= @app_name %>, :locales, ["en"])

    collection =
      Enum.map(locales, fn loc ->
        label =
          case <%= @app_module %>.Cldr.Language.to_string(loc, locale: loc) do
            {:ok, name} -> String.capitalize(name)
            _ -> String.upcase(loc)
          end

        %{id: "/#{loc}#{assigns.current_path}", label: label}
      end)

    assigns = assign(assigns, :collection, collection)

    ~H"""
    <.select
      id="locale-select"
      class="select select--sm select--micro"
      collection={@collection}
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
        <.heroicon name="hero-language" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
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
        <.heroicon name="hero-swatch" />
      </:trigger>
      <:item_indicator>
        <.heroicon name="hero-check" />
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
        <.heroicon name="hero-sun" class="icon state-on" />
        <.heroicon name="hero-moon" class="icon state-off" />
      </:item>
    </.toggle_group>
    """
  end
<% end %>end
