defmodule E2eWeb.App.Header do
  use E2eWeb, :html
  alias E2eWeb.App.Shell
  import E2eWeb.App.MainNav
  import E2eWeb.{ModeToggle, ThemeToggle, Helpers}

  attr(:path, :string, required: true)
  attr(:theme, :string, required: true)
  attr(:mode, :string, required: true)
  attr(:id, :string, default: nil)

  def header(assigns) do
    home_current = home_aria_current(assigns.path)

    assigns =
      assigns
      |> assign(:home_current, home_current)
      |> assign(:site_nav_items, site_nav_menu_items())
      |> assign(
        :logo_class,
        "link ui-nav ui-brand ui-size-xl flex flex-nowrap items-center gap-space font-semibold uppercase"
      )

    ~H"""
    <header id={@id} class={Shell.header()}>
      <div class={Shell.header_content()}>
        <div class="flex min-w-0 items-center gap-space-xl">
          <.menu
            id="site-nav-menu"
            class="menu ui-size-sm ui-width-fit md:hidden [&_[data-part=trigger]]:me-0 [&_[data-part=trigger]]:min-w-0 [&_[data-part=trigger]]:w-auto [&_[data-part=trigger]]:justify-center [&_[data-part=trigger]]:p-0! [&_[data-part=trigger]]:aspect-square [&_[data-part=item-text]]:flex [&_[data-part=item-text]]:items-center [&_[data-part=item-text]]:justify-center [&_[data-part=item-text]]:overflow-visible"
            redirect
            items={@site_nav_items}
            aria_label={~t"Open menu"}
          >
            <:trigger>
              <.heroicon name="hero-bars-3" />
              <span class="sr-only">{~t"Open menu"}</span>
            </:trigger>
          </.menu>

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
