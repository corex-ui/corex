defmodule E2eWeb.App.MainNav do
  @moduledoc false

  use E2eWeb, :html

  attr(:path, :string, required: true)
  attr(:orientation, :atom, default: :horizontal, values: [:horizontal, :vertical])

  attr(:placement, :atom,
    default: :header,
    values: [:header, :sidebar, :drawer],
    doc: "Distinguishes duplicate nav landmarks on the same page"
  )

  def header_main_nav(assigns) do
    nav_class =
      case assigns.orientation do
        :vertical -> "flex flex-col gap-space-sm w-full"
        :horizontal -> "hidden md:flex items-center gap-4 lg:gap-6 min-w-0"
      end

    link_class = "ui-link ui-link--md font-medium text-ink hover:text-link no-underline"
    aria_label = nav_aria_label(assigns.placement)

    assigns =
      assigns
      |> assign(:nav_class, nav_class)
      |> assign(:link_class, link_class)
      |> assign(:aria_label, aria_label)

    ~H"""
    <nav class={@nav_class} aria-label={@aria_label}>
      <.navigate
        to={~p"/accordion/anatomy"}
        class={@link_class}
        aria-current={nav_components_aria_current(@path)}
      >
        {~t"Components"}
      </.navigate>
      <.navigate
        to={~p"/showcases"}
        class={@link_class}
        aria-current={nav_showcases_aria_current(@path)}
      >
        {~t"Showcases"}
      </.navigate>
      <.navigate
        to={~p"/blog"}
        class={@link_class}
        aria-current={nav_blog_aria_current(@path)}
      >
        {~t"Blog"}
      </.navigate>
    </nav>
    """
  end

  defp nav_aria_label(:header), do: ~t"Main navigation"
  defp nav_aria_label(:sidebar), do: ~t"Sidebar navigation"
  defp nav_aria_label(:drawer), do: ~t"Menu navigation"

  defp nav_showcases_aria_current(path) when is_binary(path) do
    if String.starts_with?(path, "/showcases"), do: "page", else: nil
  end

  defp nav_showcases_aria_current(_), do: nil

  defp nav_blog_aria_current(path) when is_binary(path) do
    if String.starts_with?(path, "/blog"), do: "page", else: nil
  end

  defp nav_blog_aria_current(_), do: nil

  defp nav_components_aria_current(raw_path) do
    path = normalize_path(raw_path)

    cond do
      path == "" or String.starts_with?(path, "/showcases") -> nil
      String.starts_with?(path, "/admins") -> nil
      not doc_navigation_path?(path) -> nil
      path == "/accordion/anatomy" -> "page"
      true -> "location"
    end
  end

  defp normalize_path(p) when p in [nil, ""], do: ""

  defp normalize_path(p) when is_binary(p) do
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
