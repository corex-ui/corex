defmodule E2eWeb.App.Header do
  use E2eWeb, :html
  alias E2eWeb.App.Shell
  import E2eWeb.App.MainNav
  import E2eWeb.App.Aside, only: [aside_nav_tree_views: 1]
  import E2eWeb.{ModeToggle, ThemeToggle, AccessibilityToggle, Helpers}

  attr(:path, :string, required: true)
  attr(:theme, :string, required: true)
  attr(:mode, :string, required: true)
  attr(:id, :string, default: nil)

  def header(assigns) do
    home_current = home_aria_current(assigns.path)

    assigns =
      assigns
      |> assign(:home_current, home_current)
      |> assign(:form_menu, form_menu_items())
      |> assign(:components_menu, components_menu_items())
      |> assign(
        :logo_class,
        "link ui-nav ui-brand ui-size-xl flex flex-nowrap items-center gap-space font-semibold uppercase"
      )

    ~H"""
    <header id={@id} class={Shell.header()}>
      <div class={Shell.header_content()}>
        <div class="flex min-w-0 items-center gap-space-xl">
          <.dialog id="site-nav-dialog" class="dialog dialog--side lg:hidden" modal prevent_scroll>
            <:trigger
              class="button ui-ghost ui-size-sm ui-trigger--circle"
              aria_label={~t"Open menu"}
            >
              <.heroicon name="hero-bars-3" />
            </:trigger>
            <:content>
              <div class="flex h-size-lg shrink-0 items-center gap-space-xl border-b border-border px-space-xl">
                <.dialog_close_trigger
                  id="site-nav-dialog"
                  class="button ui-ghost ui-size-sm ui-trigger--circle m-0"
                >
                  <.heroicon name="hero-x-mark" />
                </.dialog_close_trigger>
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

              <div class="flex min-h-0 flex-1 flex-col gap-space overflow-y-auto scrollbar scrollbar--sm px-space-xl py-space">
                <.header_main_nav path={@path} orientation={:vertical} placement={:drawer} />

                <.aside_nav_tree_views
                  path={@path}
                  form_menu={@form_menu}
                  components_menu={@components_menu}
                  form_tree_id="form-menu-mobile"
                  components_tree_id="components-menu-mobile"
                  tree_class="tree-view navigation w-full max-w-none aside-nav-tree"
                />
              </div>

              <div class="mt-auto flex shrink-0 items-center gap-space border-t border-border px-space-xl py-space">
                <.theme_toggle id="theme-select-mobile" theme={@theme} />
                <.mode_toggle id="mode-switcher-mobile" mode={@mode} />
                <.accessibility_open_button />
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

        <div class="flex shrink-0 items-center gap-space-sm">
          <div class="hidden sm:flex items-center gap-space-sm">
            <.theme_toggle id="theme-select" theme={@theme} />
            <.mode_toggle id="mode-switcher" mode={@mode} />
          </div>
          <.accessibility_panel trigger_class="button ui-ghost ui-size-sm ui-trigger--circle p-0 [--ctl-text:calc(var(--spacing-size-sm)*0.65)] hidden sm:inline-flex" />
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
