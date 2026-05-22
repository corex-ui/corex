defmodule E2eWeb.ShowcaseRedirectController do
  use E2eWeb, :controller

  def to_showcases(conn, _params) do
    redirect(conn, to: E2eWeb.Path.with_current_locale("/showcases"))
  end

  def games_tetrex(conn, params) do
    rest = Map.get(params, "rest", [])
    suffix = rest |> List.wrap() |> Enum.join("/")
    path = "/showcases/tetrex" <> if(suffix == "", do: "", else: "/" <> suffix)
    redirect(conn, to: E2eWeb.Path.with_current_locale(path))
  end
end
