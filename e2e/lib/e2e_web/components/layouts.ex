defmodule E2eWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use E2eWeb, :html

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

      <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :mode, :string, default: "light", doc: "the mode (dark or light) from cookie/session"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :locale, :string,
    default: nil,
    doc: "current locale (from plug or LiveView assigns), used for the locale switcher"

  attr :current_path, :string,
    default: "/",
    doc:
      "current path without the locale segment (e.g. \"/accordion\"), from Phoenix.Controller.current_path(conn, %{}) then E2eWeb.Plugs.Locale.path_without_locale/2, or from LiveView handle_params URI; used so the locale switcher preserves the path"

  slot :inner_block, required: true

  def app(assigns) do
    locale = assigns.locale || "en"

    assigns =
      assigns
      |> assign(:menu, menu_items(locale))
      |> assign(:form_menu, form_menu_items(locale))
      |> assign(:prev_path, prev_next_paths(locale, assigns.current_path || "/", :prev))
      |> assign(:next_path, prev_next_paths(locale, assigns.current_path || "/", :next))

    ~H"""
    <header class="layout__header">
      <div class="layout__header__content">
        <div class="layout__row gap-mini-gap">
          <.dialog id="menu-dialog" class="dialog dialog--side lg:hidden">
            <:trigger class="button button--sm button--circle rounded-full" aria_label="Open menu">
              <.icon name="hero-bars-3" class="icon" />
            </:trigger>

            <:content>
              <div class="layout__header">
                <div class="layout__header__content">
                  <div class="layout__row">
                    <.dialog_close_trigger id="menu-dialog">
                      <.icon name="hero-x-mark" class="icon" />
                    </.dialog_close_trigger>
                    <a
                      href="/"
                      class="link md:link--md lg:link--lg link--brand gap-mini-gap font-ui-xl flex flex-nowrap grow uppercase after:content-none"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136">
                        <path
                          d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                          fill="var(--color-layer--brand)"
                        />
                      </svg>
                      Corex
                    </a>
                  </div>
                </div>
              </div>
              <div class="scrollbar scrollbar--sm overflow-y-auto">
                <.tree_view
                  id="form-menu"
                  class="tree-view navigation px-ui-padding"
                  on_selection_change="handle_menu"
                  redirect
                  value={[@current_path |> String.split("/") |> List.last()]}
                  items={@form_menu}
                >
                  <:label>Phoenix Form</:label>
                  <:indicator>
                    <.icon name="hero-chevron-right" />
                  </:indicator>
                </.tree_view>
                <.tree_view
                  id="components-menu"
                  on_selection_change="handle_menu"
                  class="tree-view navigation px-ui-padding "
                  redirect
                  value={[@current_path |> String.split("/") |> List.last()]}
                  items={@menu}
                >
                  <:label>Corex Components</:label>
                  <:indicator>
                    <.icon name="hero-chevron-right" />
                  </:indicator>
                </.tree_view>
              </div>
            </:content>
          </.dialog>

          <a
            href="/"
            class="link md:link--md lg:link--lg link--brand gap-mini-gap font-ui-xl flex flex-nowrap px-1 uppercase after:content-none"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136">
              <path
                d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                fill="var(--color-layer--brand)"
              />
            </svg>
            Corex
          </a>
        </div>
        <div class="layout__row">
          <.locale_switcher :if={@locale} locale={@locale} current_path={@current_path} />
          <.mode_toggle mode={@mode} />
        </div>
      </div>
    </header>
    <div class="layout__wrapper">
      <aside class="layout__side hidden lg:flex scrollbar scrollbar--sm overflow-y-auto">
        <.tree_view
          id="form-menu-side"
          class="tree-view navigation px-ui-padding"
          on_selection_change="handle_menu"
          redirect
          value={[@current_path |> String.split("/") |> List.last()]}
          items={@form_menu}
        >
          <:label>Phoenix Form</:label>
          <:indicator>
            <.icon name="hero-chevron-right" />
          </:indicator>
        </.tree_view>
        <.tree_view
          id="components-menu-side"
          on_selection_change="handle_menu"
          class="tree-view navigation px-ui-padding"
          redirect
          value={[@current_path |> String.split("/") |> List.last()]}
          items={@menu}
        >
          <:label>Corex Components</:label>
          <:indicator>
            <.icon name="hero-chevron-right" />
          </:indicator>
        </.tree_view>
      </aside>

      <main class="layout__main py-ui">
        <nav
          :if={@prev_path || @next_path}
          class="layout__page-nav w-full flex justify-between items-center px-ui-padding py-micro"
        >
          <div>
            <.link :if={@prev_path} navigate={@prev_path} class="button button--sm gap-mini-gap">
              <.icon name="hero-chevron-left" /> Previous
            </.link>
          </div>
          <div>
            <.link :if={@next_path} navigate={@next_path} class="button button--sm gap-mini-gap">
              Next <.icon name="hero-chevron-right" />
            </.link>
          </div>
        </nav>
        <div class="layout__content">
          <div class="layout__article">
            {render_slot(@inner_block)}
          </div>
        </div>
      </main>
    </div>
    <.footer />

    <Corex.Toast.toast_group id="layout-toast" flash={@flash}>
      <:loading>
        <.icon name="hero-arrow-path" />
      </:loading>
    </Corex.Toast.toast_group>
    <.toast_client_error
      title={gettext("We can't find the internet")}
      description={gettext("Attempting to reconnect")}
      type={:error}
      duration={:infinity}
    />
    <.toast_server_error
      title={gettext("Something went wrong!")}
      description={gettext("Attempting to reconnect")}
      type={:error}
      duration={:infinity}
    />
    """
  end

  attr :locale, :string, required: true, doc: "current locale"

  attr :current_path, :string,
    default: "/",
    doc: "path without locale segment so switching language preserves the URL"

  @doc """
  Language switcher (English / Arabic) using the select component.

  Uses the server event "locale_change" so the LiveView pushes navigate to /locale/path;
  the plug runs and updates lang/dir. Pass current_path (e.g. from
  `E2eWeb.Plugs.Locale.path_without_locale(conn.request_path, conn.assigns.locale)` or
  from LiveView URI in handle_params) to preserve the path when switching.
  """
  def locale_switcher(assigns) do
    ~H"""
    <.select
      id="locale-select"
      class="select select--sm select--micro"
      collection={[
        %{id: "/en#{@current_path}", label: "English"},
        %{id: "/ar#{@current_path}", label: "العربية"}
      ]}
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

  attr :mode, :string,
    default: "light",
    values: ["light", "dark"],
    doc: "the mode (dark or light) from cookie/session"

  @doc """
  Provides dark vs light theme toggle using toggle_group.

  """
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

  defp flat_navigation_paths(locale) do
    form_paths =
      form_menu_items(locale)
      |> flatten_tree_ids()

    menu_paths =
      menu_items(locale)
      |> flatten_tree_ids()

    form_paths ++ menu_paths
  end

  defp flatten_tree_ids(items) when is_list(items) do
    Enum.flat_map(items, fn
      %{id: id, children: []} when is_binary(id) ->
        [id]

      %{id: id, children: nil} when is_binary(id) ->
        [id]

      %{id: _id, children: children} when is_list(children) and children != [] ->
        flatten_tree_ids(children)

      _ ->
        []
    end)
  end

  defp prev_next_paths(locale, current_path, direction) do
    full_path = "/#{locale}#{current_path}"
    paths = flat_navigation_paths(locale)
    index = Enum.find_index(paths, &(&1 == full_path))

    case {direction, index} do
      {:prev, nil} -> nil
      {:prev, 0} -> nil
      {:prev, i} when i > 0 -> Enum.at(paths, i - 1)
      {:next, nil} -> nil
      {:next, i} when i >= 0 and i < length(paths) - 1 -> Enum.at(paths, i + 1)
      _ -> nil
    end
  end

  defp menu_items(locale) do
    Corex.Tree.new([
      [
        label: "Accordion",
        id: "accordion",
        children: [
          [label: "Controller", id: "/#{locale}/accordion"],
          [label: "Live", id: "/#{locale}/live/accordion"],
          [label: "Playground", id: "/#{locale}/playground/accordion"],
          [label: "Controlled", id: "/#{locale}/controlled/accordion"],
          [label: "Async", id: "/#{locale}/async/accordion"]
        ]
      ],
      [
        label: "Angle Slider",
        id: "angle-slider",
        children: [
          [label: "Controller", id: "/#{locale}/angle-slider"],
          [label: "Live", id: "/#{locale}/live/angle-slider"],
          [label: "Playground", id: "/#{locale}/playground/angle-slider"],
          [label: "Controlled", id: "/#{locale}/controlled/angle-slider"]
        ]
      ],
      [
        label: "Avatar",
        id: "avatar",
        children: [
          [label: "Controller", id: "/#{locale}/avatar"],
          [label: "Live", id: "/#{locale}/live/avatar"]
        ]
      ],
      [
        label: "Carousel",
        id: "carousel",
        children: [
          [label: "Controller", id: "/#{locale}/carousel"],
          [label: "Live", id: "/#{locale}/live/carousel"]
        ]
      ],
      [
        label: "Checkbox",
        id: "checkbox",
        children: [
          [label: "Controller", id: "/#{locale}/checkbox"],
          [label: "Live", id: "/#{locale}/live/checkbox"]
        ]
      ],
      [
        label: "Clipboard",
        id: "clipboard",
        children: [
          [label: "Controller", id: "/#{locale}/clipboard"],
          [label: "Live", id: "/#{locale}/live/clipboard"]
        ]
      ],
      [
        label: "Collapsible",
        id: "collapsible",
        children: [
          [label: "Controller", id: "/#{locale}/collapsible"],
          [label: "Live", id: "/#{locale}/live/collapsible"]
        ]
      ],
      [
        label: "Combobox",
        id: "combobox",
        children: [
          [label: "Controller", id: "/#{locale}/combobox"],
          [label: "Live", id: "/#{locale}/live/combobox"]
        ]
      ],
      [
        label: "Date Picker",
        id: "date-picker",
        children: [
          [label: "Controller", id: "/#{locale}/date-picker"],
          [label: "Live", id: "/#{locale}/live/date-picker"]
        ]
      ],
      [
        label: "Dialog",
        id: "dialog",
        children: [
          [label: "Controller", id: "/#{locale}/dialog"],
          [label: "Live", id: "/#{locale}/live/dialog"]
        ]
      ],
      [
        label: "Editable",
        id: "editable",
        children: [
          [label: "Controller", id: "/#{locale}/editable"],
          [label: "Live", id: "/#{locale}/live/editable"]
        ]
      ],
      [
        label: "Floating Panel",
        id: "floating-panel",
        children: [
          [label: "Controller", id: "/#{locale}/floating-panel"],
          [label: "Live", id: "/#{locale}/live/floating-panel"]
        ]
      ],
      [
        label: "Listbox",
        id: "listbox",
        children: [
          [label: "Controller", id: "/#{locale}/listbox"],
          [label: "Live", id: "/#{locale}/live/listbox"]
        ]
      ],
      [
        label: "Menu",
        id: "menu",
        children: [
          [label: "Controller", id: "/#{locale}/menu"],
          [label: "Live", id: "/#{locale}/live/menu"]
        ]
      ],
      [
        label: "Number Input",
        id: "number-input",
        children: [
          [label: "Controller", id: "/#{locale}/number-input"],
          [label: "Live", id: "/#{locale}/live/number-input"]
        ]
      ],
      [
        label: "Password Input",
        id: "password-input",
        children: [
          [label: "Controller", id: "/#{locale}/password-input"],
          [label: "Live", id: "/#{locale}/live/password-input"]
        ]
      ],
      [
        label: "Pin Input",
        id: "pin-input",
        children: [
          [label: "Controller", id: "/#{locale}/pin-input"],
          [label: "Live", id: "/#{locale}/live/pin-input"]
        ]
      ],
      [
        label: "Radio Group",
        id: "radio-group",
        children: [
          [label: "Controller", id: "/#{locale}/radio-group"],
          [label: "Live", id: "/#{locale}/live/radio-group"]
        ]
      ],
      [
        label: "Select",
        id: "select",
        children: [
          [label: "Controller", id: "/#{locale}/select"],
          [label: "Live", id: "/#{locale}/live/select"]
        ]
      ],
      [
        label: "Signature",
        id: "signature",
        children: [
          [label: "Controller", id: "/#{locale}/signature"],
          [label: "Live", id: "/#{locale}/live/signature"]
        ]
      ],
      [
        label: "Switch",
        id: "switch",
        children: [
          [label: "Controller", id: "/#{locale}/switch"],
          [label: "Live", id: "/#{locale}/live/switch"]
        ]
      ],
      [
        label: "Tabs",
        id: "tabs",
        children: [
          [label: "Controller", id: "/#{locale}/tabs"],
          [label: "Live", id: "/#{locale}/live/tabs"]
        ]
      ],
      [
        label: "Timer",
        id: "timer",
        children: [
          [label: "Controller", id: "/#{locale}/timer"],
          [label: "Live", id: "/#{locale}/live/timer"]
        ]
      ],
      [
        label: "Toast",
        id: "toast",
        children: [
          [label: "Controller", id: "/#{locale}/toast"],
          [label: "Live", id: "/#{locale}/live/toast"]
        ]
      ],
      [
        label: "Toggle Group",
        id: "toggle-group",
        children: [
          [label: "Controller", id: "/#{locale}/toggle-group"],
          [label: "Live", id: "/#{locale}/live/toggle-group"]
        ]
      ],
      [
        label: "Tree view",
        id: "tree-view",
        children: [
          [label: "Controller", id: "/#{locale}/tree-view"],
          [label: "Live", id: "/#{locale}/live/tree-view"]
        ]
      ]
    ])
  end

  defp form_menu_items(locale) do
    Corex.Tree.new([
      [label: "Controller View", id: "/#{locale}/users"],
      [label: "Live View", id: "/#{locale}/admins"]
    ])
  end

  def footer(assigns) do
    ~H"""
    <footer class="layout__footer">
      <div class="layout__footer__content gap-ui-gap justify-center md:justify-between">
        <div class="layout__row">
          <a class="link link--sm link--success" href="https://netoum.com" target="_blank">
            Open source by Netoum
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <title>Opens in a new window</title>
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
              >
              </path>
            </svg>
          </a>
          <a
            class="link link--sm link--success"
            href="https://donate.stripe.com/dRm8wO75h5hH2G96gy4Rq00"
            target="_blank"
          >
            Support the project
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <title>Opens in a new window</title>
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
              >
              </path>
            </svg>
          </a>
        </div>
        <div class="layout__row gap-ui-gap">
          <a
            href="https://github.com/corex-ui/corex"
            target="_blank"
            class="button button--sm button--circle"
            aria-label="Go to Corex UI Github"
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
            aria-label="Go to Corex UI Github"
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
      </div>
    </footer>
    """
  end
end
