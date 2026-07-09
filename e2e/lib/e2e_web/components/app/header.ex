defmodule E2eWeb.App.Header do
  use E2eWeb, :html
  import E2eWeb.App.Aside
  alias E2eWeb.App.Shell
  import E2eWeb.App.MainNav
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
    <header class={Shell.header()}>
      <div class={Shell.header_content()}>
        <div class={Shell.row()}>
          <.dialog id="menu-dialog" animation="instant" class="dialog dialog--side lg:hidden">
            <:trigger
              class="button button--sm button--circle button--variant-ghost"
              aria_label={~t"Open menu"}
            >
              <.heroicon name="hero-bars-3" />
            </:trigger>

            <:content>
              <div class={Shell.header()}>
                <div class={Shell.header_content()}>
                  <div class={Shell.row()}>
                    <.action
                      phx-click={Corex.Dialog.set_open("menu-dialog", false)}
                      class="button button--sm button--circle button--variant-ghost"
                      aria_label={~t"Close menu"}
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
                aria-label={~t"Documentation navigation"}
                phx-hook="AsideNavScroll"
              >
                <.drawer_site_nav_tree path={@path} site_nav_tree_id="site-nav-menu" />
                <.aside_nav_tree_views
                  path={@path}
                  form_menu={@form_menu}
                  components_menu={@components_menu}
                  form_tree_id="form-menu"
                  components_tree_id="components-menu"
                  tree_class="tree-view navigation max-w-3xs"
                />
              </div>
              <div
                class="shrink-0 flex flex-wrap items-center justify-center gap-2 sm:gap-3 border-t border-[var(--color-border)] bg-[var(--color-layer)] p-3 pt-3 pb-[max(0.75rem,env(safe-area-inset-bottom))] lg:hidden"
                aria-label={~t"Display settings"}
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

          <.header_main_nav path={@path} orientation={:horizontal} placement={:header} />
        </div>
        <div class={"hidden lg:flex #{Shell.row()} gap-2 sm:gap-4 shrink-0"}>
          <.theme_toggle id="theme-select" theme={@theme} />
          <.mode_toggle id="mode-switcher" mode={@mode} />
        </div>
      </div>
    </header>
    """
  end
end
