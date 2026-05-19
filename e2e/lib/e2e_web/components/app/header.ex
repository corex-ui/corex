defmodule E2eWeb.App.Header do
  use E2eWeb, :html
  import E2eWeb.App.Aside
  import E2eWeb.{ModeToggle, ThemeToggle, Helpers}

  @doc """
  Provides the header component for the application.
  """

  attr(:path, :string, required: true)
  attr(:theme, :string, required: true)
  attr(:mode, :string, required: true)

  def header(assigns) do
    form_menu = form_menu_items()
    components_menu = components_menu_items()

    assigns =
      assigns
      |> assign(:form_menu, form_menu)
      |> assign(:components_menu, components_menu)

    ~H"""
    <header class="layout__header">
      <div class="layout__header__content">
        <div class="layout__row">
          <.dialog id="menu-dialog" animation="instant" class="dialog dialog--side lg:hidden">
            <:trigger class="button button--sm button--circle button--ghost" aria_label="Open menu">
              <.heroicon name="hero-bars-3" />
            </:trigger>

            <:content>
              <div class="layout__header">
                <div class="layout__header__content">
                  <div class="layout__row">
                    <.action
                      phx-click={Corex.Dialog.set_open("menu-dialog", false)}
                      class="button button--sm button--circle button--ghost"
                      aria_label="Close menu"
                    >
                      <.heroicon name="hero-x-mark" />
                    </.action>

                    <.navigate
                      to={~p"/"}
                      class="ui-link ui-link--brand ui-link--xl flex flex-nowrap items-center
                 gap-space font-semibold uppercase hover:no-underline"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 136 136"
                        class="icon icon--lg"
                      >
                        <path
                          d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                          fill="var(--color-ink-brand)"
                        >
                        </path>
                      </svg>
                      Corex
                    </.navigate>
                  </div>
                </div>
              </div>

              <div
                id="layout-menu-nav-scroll"
                class="flex-1 min-h-0 flex flex-col scrollbar scrollbar--sm overflow-y-auto w-full py-size gap-size bg-layer"
                aria-label="Documentation navigation"
                phx-hook="AsideNavScroll"
              >
                <.tree_view
                  id="doc-menu-dialog"
                  class="tree-view tree-view--accent max-w-3xs w-full"
                  redirect
                  value={documentation_menu_selected_ids(@path)}
                  items={documentation_menu_items()}
                >
                  <:label class="sr-only">{gettext("Corex Links")}</:label>
                  <:item :let={item}>
                    <span class="w-full">{item.label}</span>
                    <%= if item_new_tab?(item) do %>
                      <.heroicon name="hero-arrow-top-right-on-square" class="icon shrink-0" />
                    <% end %>
                  </:item>
                </.tree_view>
                <.aside_nav_tree_views
                  path={@path}
                  form_menu={@form_menu}
                  components_menu={@components_menu}
                  form_tree_id="form-menu"
                  components_tree_id="components-menu"
                  tree_class="tree-view tree-view--accent max-w-3xs"
                />
              </div>
              <div
                class="shrink-0 flex flex-wrap items-center justify-center gap-2 sm:gap-3 border-t border-[var(--color-border)] bg-[var(--color-layer)] p-3 pt-3 pb-[max(0.75rem,env(safe-area-inset-bottom))] lg:hidden"
                aria-label={gettext("Display settings")}
              >
                <.theme_toggle id="theme-select-menu" theme={@theme} />
                <.mode_toggle id="mode-switcher-menu" mode={@mode} />
              </div>
            </:content>
          </.dialog>

          <.navigate
            to={~p"/"}
            class="ui-link ui-link--brand ui-link--xl hover:text-link flex flex-nowrap items-center
         gap-space font-semibold uppercase no-underline"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 136 136"
              class="icon icon--lg"
            >
              <path
                d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                fill="var(--color-ink-brand)"
              >
              </path>
            </svg>
            Corex
          </.navigate>

          <nav
            class="hidden md:flex items-center gap-4 lg:gap-6 min-w-0"
            aria-label={gettext("Main")}
          >
            <.navigate
              to={~p"/accordion/anatomy"}
              class="ui-link ui-link--md font-medium text-ink hover:text-link no-underline"
              aria-current={header_nav_components_aria_current(@path)}
            >
              {gettext("Components")}
            </.navigate>
            <.navigate
              to={~p"/templates"}
              class="ui-link ui-link--md font-medium text-ink hover:text-link no-underline"
              aria-current={header_nav_templates_aria_current(@path)}
            >
              {gettext("Templates")}
            </.navigate>
            <.navigate
              to="https://hexdocs.pm/corex"
              class="ui-link ui-link--md font-medium text-ink hover:text-link no-underline"
              external
            >
              {gettext("Documentation")}
              <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
            </.navigate>
            <.navigate
              to="https://hexdocs.pm/corex/mcp.html"
              class="ui-link ui-link--md font-medium text-ink hover:text-link no-underline"
              external
            >
              {gettext("MCP")}
              <.heroicon name="hero-arrow-top-right-on-square" class="icon" />
            </.navigate>
          </nav>
        </div>
        <div class="hidden lg:flex layout__row gap-2 sm:gap-4 shrink-0">
          <.theme_toggle id="theme-select" theme={@theme} />
          <.mode_toggle id="mode-switcher" mode={@mode} />
        </div>
      </div>
    </header>
    """
  end

  defp documentation_menu_items do
    templates_path = E2eWeb.Path.with_current_locale("/templates")

    Corex.Tree.new([
      %{
        value: "doc-installation",
        label: gettext("Installation"),
        to: "https://hexdocs.pm/corex/installation.html",
        redirect: :href,
        new_tab: true
      },
      %{
        value: "doc-localize",
        label: gettext("Localize"),
        to: "https://hexdocs.pm/corex/localize.html",
        redirect: :href,
        new_tab: true
      },
      %{
        value: "doc-theming",
        label: gettext("Theming"),
        to: "https://hexdocs.pm/corex/theming.html",
        redirect: :href,
        new_tab: true
      },
      %{
        value: "doc-dark-mode",
        label: gettext("Dark Mode"),
        to: "https://hexdocs.pm/corex/dark_mode.html",
        redirect: :href,
        new_tab: true
      },
      %{
        value: "doc-mcp",
        label: gettext("MCP"),
        to: "https://hexdocs.pm/corex/mcp.html",
        redirect: :href,
        new_tab: true
      },
      %{
        value: "doc-templates",
        label: gettext("Templates"),
        to: templates_path,
        redirect: :href,
        new_tab: false
      }
    ])
  end

  defp item_new_tab?(%{new_tab: true}), do: true
  defp item_new_tab?(_), do: false

  defp documentation_menu_selected_ids("/templates"), do: ["doc-templates"]
  defp documentation_menu_selected_ids(_), do: []

  defp header_nav_templates_aria_current("/templates"), do: "page"
  defp header_nav_templates_aria_current(_), do: nil

  defp header_nav_components_aria_current(raw_path) do
    path = normalize_header_path(raw_path)

    cond do
      path == "" or path == "/templates" -> nil
      String.starts_with?(path, "/admins") -> nil
      not doc_navigation_path?(path) -> nil
      path == "/accordion/anatomy" -> "page"
      true -> "location"
    end
  end

  defp normalize_header_path(p) when p in [nil, ""], do: ""

  defp normalize_header_path(p) when is_binary(p) do
    p
    |> String.trim()
    |> String.trim_trailing("/")
    |> then(fn s -> if s == "/", do: "", else: s end)
  end

  defp doc_navigation_path?(path) when is_binary(path) and path != "" do
    Enum.any?(E2eWeb.Helpers.flat_navigation_list(), fn %{to: to} ->
      E2eWeb.Path.strip_after_locale(to) == path
    end)
  end

  defp doc_navigation_path?(_), do: false
end
