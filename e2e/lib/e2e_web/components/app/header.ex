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
  attr(:variant, :atom, default: :app, values: [:app, :marketing])

  def header(assigns) do
    form_menu = form_menu_items()
    components_menu = components_menu_items()
    home_current = home_aria_current(assigns.path)
    marketing? = assigns.variant == :marketing

    assigns =
      assigns
      |> assign(:form_menu, form_menu)
      |> assign(:components_menu, components_menu)
      |> assign(:home_current, home_current)
      |> assign(
        :logo_class,
        "link ui-nav ui-brand ui-size-xl flex flex-nowrap items-center gap-space font-semibold uppercase"
      )
      |> assign(
        :header_class,
        if(marketing?, do: Shell.header_marketing(), else: Shell.header())
      )
      |> assign(
        :header_content_class,
        if(marketing?, do: Shell.header_content_marketing(), else: Shell.header_content())
      )
      |> assign(
        :menu_trigger_class,
        if(marketing?,
          do: "button ui-ghost ui-size-sm ui-rounded-full",
          else: "button ui-size-sm ui-trigger--circle"
        )
      )

    ~H"""
    <header id={if(@variant == :marketing, do: "home-header")} class={@header_class}>
      <div class={@header_content_class}>
        <div class={"#{Shell.row()} min-w-0"}>
          <.dialog id="menu-dialog" animation="instant" modal class="dialog dialog--side lg:hidden">
            <:trigger
              class={@menu_trigger_class}
              aria_label={~t"Open menu"}
            >
              <.heroicon name="hero-bars-3" />
            </:trigger>

            <:content class="p-0! bg-transparent! shadow-none! border-0!">
              <div class="flex shrink-0 items-center px-space py-space">
                <div class={Shell.row()}>
                  <.action
                    phx-click={Corex.Dialog.set_open("menu-dialog", false)}
                    class="button ui-ghost ui-size-sm ui-rounded-full"
                    aria_label={~t"Close menu"}
                  >
                    <.heroicon name="hero-x-mark" />
                  </.action>

                  <.navigate to={~p"/"} class={@logo_class} aria-current={@home_current}>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 136 136"
                      class="icon ui-size-lg"
                    >
                      <path
                        d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                        fill="currentColor"
                      >
                      </path>
                    </svg>
                    Corex
                  </.navigate>
                </div>
              </div>

              <div
                id="layout-menu-nav-scroll"
                class="flex-1 min-h-0 flex flex-col scrollbar scrollbar--sm overflow-y-auto w-full py-size gap-size"
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
                class="shrink-0 flex flex-wrap items-center justify-center gap-2 sm:gap-3 border-t border-border p-3 pt-3 pb-[max(0.75rem,env(safe-area-inset-bottom))] lg:hidden"
                aria-label={~t"Display settings"}
              >
                <.theme_toggle id="theme-select-menu" theme={@theme} />
                <.mode_toggle id="mode-switcher-menu" mode={@mode} />
              </div>
            </:content>
          </.dialog>

          <.navigate to={~p"/"} class={@logo_class} aria-current={@home_current}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 136 136"
              class="icon ui-size-lg"
            >
              <path
                d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                fill="currentColor"
              >
              </path>
            </svg>
            Corex
          </.navigate>

          <.header_main_nav path={@path} orientation={:horizontal} placement={:header} />
        </div>
        <div class={[
          "hidden lg:flex shrink-0",
          Shell.row(),
          if(@variant == :marketing, do: "gap-space-lg", else: "gap-2 sm:gap-4")
        ]}>
          <.theme_toggle id="theme-select" theme={@theme} />
          <.mode_toggle id="mode-switcher" mode={@mode} />
        </div>
      </div>
    </header>
    """
  end

  defp home_aria_current(path) when path in [nil, "", "/"], do: "page"

  defp home_aria_current(path) when is_binary(path) do
    trimmed =
      path
      |> String.trim()
      |> String.trim_trailing("/")

    if trimmed in ["", "/"], do: "page", else: nil
  end

  defp home_aria_current(_), do: nil
end
