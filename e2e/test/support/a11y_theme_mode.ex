defmodule E2eWeb.A11yThemeMode do
  import Wallaby.Browser
  import ExUnit.Assertions

  @themes ~w(neo uno duo leo)
  @modes ~w(light dark)

  def themes, do: @themes
  def modes, do: @modes

  def combos do
    for theme <- @themes, mode <- @modes, do: {theme, mode}
  end

  def visit_path_with_theme_mode(session, path, theme, mode) do
    locale_path = "/#{E2eWeb.DocA11yRoutes.locale()}#{path}"

    session
    |> visit(locale_path)
    |> execute_script(
      """
      localStorage.setItem("phx:theme", #{Jason.encode!(theme)});
      localStorage.setItem("phx:mode", #{Jason.encode!(mode)});
      """,
      []
    )
    |> set_cookie("phx_theme", theme, path: "/")
    |> set_cookie("phx_mode", mode, path: "/")
    |> visit(locale_path)
  end

  def visit_ready_with_theme_mode(session, path, %Wallaby.Query{} = ready_query, theme, mode) do
    session
    |> visit_path_with_theme_mode(path, theme, mode)
    |> assert_has(ready_query)
  end

  def assert_document_theme_mode(session, theme, mode) do
    execute_script(
      session,
      """
      const h = document.documentElement;
      return (h.getAttribute('data-theme') === #{Jason.encode!(theme)}) &&
        (h.getAttribute('data-mode') === #{Jason.encode!(mode)});
      """,
      [],
      fn v -> assert v == true end
    )

    session
  end
end
