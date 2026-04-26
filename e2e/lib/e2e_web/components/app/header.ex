defmodule E2eWeb.App.Header do
  use E2eWeb, :html
  import E2eWeb.App.Aside
  import E2eWeb.{LocaleSwitcher, ModeToggle, ThemeToggle, Helpers}

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
      <div class="layout__header__content px-1 sm:px-4">
        <div class="layout__row gap-2 sm:gap-4">
          <.dialog id="menu-dialog" class="dialog dialog--side lg:hidden">
            <:trigger class="button button--sm button--circle button--ghost" aria_label="Open menu">
              <.heroicon name="hero-bars-3" class="icon" />
            </:trigger>

            <:content class="bg-layer">
              <div class="layout__header">
                <div class="layout__header__content px-1 sm:px-4">
                  <div class="layout__row gap-2 sm:gap-4">
                    <.action
                      phx-click={Corex.Dialog.set_open("menu-dialog", false)}
                      class="button button--sm button--circle border-0"
                    >
                      <.heroicon name="hero-x-mark" class="icon" />
                    </.action>

                    <.navigate
                      to={~p"/"}
                      class="ui-link ui-link--brand ui-link--xl flex flex-nowrap items-center
                 gap-space font-semibold uppercase hover:no-underline"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136">
                        <path
                          d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                          fill="var(--color-brand)"
                        >
                        </path>
                      </svg>
                      Corex
                    </.navigate>
                  </div>
                </div>
              </div>
              <div
                class="flex flex-col scrollbar scrollbar--sm overflow-y-auto w-full py-size gap-size bg-layer"
                aria-label="Documentation navigation"
              >
                <.aside_nav_tree_views
                  path={@path}
                  form_menu={@form_menu}
                  components_menu={@components_menu}
                  form_tree_id="form-menu"
                  components_tree_id="components-menu"
                  tree_class="tree-view tree-view--accent max-w-3xs"
                />
              </div>
            </:content>
          </.dialog>

          <.navigate
            to={~p"/"}
            class="ui-link ui-link--brand ui-link--xl flex flex-nowrap items-center
         gap-space font-semibold uppercase hover:no-underline"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 136 136">
              <path
                d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                fill="var(--color-brand)"
              >
              </path>
            </svg>
            Corex
          </.navigate>
        </div>
        <div class="layout__row gap-2 sm:gap-4">
          <.locale_switcher path={@path} />
          <.theme_toggle theme={@theme} />
          <.mode_toggle mode={@mode} />
        </div>
      </div>
    </header>
    """
  end
end
