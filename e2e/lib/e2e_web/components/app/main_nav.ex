defmodule E2eWeb.App.MainNav do
  @moduledoc false

  use E2eWeb, :html

  import E2eWeb.Helpers, only: [hexdocs_url: 0]

  attr(:path, :string, required: true)
  attr(:orientation, :atom, default: :horizontal, values: [:horizontal, :vertical])

  attr(:placement, :atom,
    default: :header,
    values: [:header, :sidebar, :drawer],
    doc: "Distinguishes duplicate nav landmarks on the same page"
  )

  def header_main_nav(assigns) do
    assigns = assign(assigns, :aria_label, nav_aria_label(assigns.placement))

    ~H"""
    <.row
      :if={@orientation == :horizontal}
      tag="nav"
      hide_below="md"
      align="center"
      gap="lg"
      aria-label={@aria_label}
    >
      <.nav_links path={@path} placement={@placement} />
    </.row>
    <.stack
      :if={@orientation == :vertical}
      tag="nav"
      gap="sm"
      width="full"
      aria-label={@aria_label}
    >
      <.nav_links path={@path} placement={@placement} />
    </.stack>
    """
  end

  attr(:path, :string, required: true)
  attr(:placement, :atom, required: true)

  defp nav_links(assigns) do
    ~H"""
    <.navigate
      to={~p"/accordion/anatomy"}
      size="md"
      class="font-medium no-underline"
      aria-current={nav_components_aria_current(@path)}
    >
      {~t"Components"}
    </.navigate>
    <.navigate
      to={~p"/showcases"}
      size="md"
      class="font-medium no-underline"
      aria-current={nav_showcases_aria_current(@path)}
    >
      {~t"Showcase"}
    </.navigate>
    <.navigate
      to={~p"/blog"}
      size="md"
      class="font-medium no-underline"
      aria-current={nav_blog_aria_current(@path)}
    >
      {~t"Blog"}
    </.navigate>
    <.navigate
      :if={@placement == :header}
      to={hexdocs_url()}
      size="md"
      class="font-medium no-underline inline-flex items-center gap-1"
      external
    >
      {~t"Hex Doc"}
      <.heroicon name="hero-arrow-top-right-on-square" />
    </.navigate>
    """
  end

  defp nav_aria_label(:header), do: ~t"Main navigation"
  defp nav_aria_label(:sidebar), do: ~t"Sidebar navigation"
  defp nav_aria_label(:drawer), do: ~t"Menu navigation"

  defp nav_showcases_aria_current(path) when is_binary(path) do
    if normalize_path(path) == "/showcases", do: "page", else: nil
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
      String.starts_with?(path, "/users") -> nil
      String.starts_with?(path, "/forms") -> nil
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
