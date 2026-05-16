defmodule E2eWeb.ComponentBehaviorSpec do
  @moduledoc false

  use E2eWeb, :verified_routes
  import Wallaby.Query, only: [css: 1]

  @pages Enum.reduce(E2eWeb.DocA11yRoutes.all(), %{}, fn
           {"/en/" <> rest, root}, acc ->
             case String.split(rest, "/", parts: 2) do
               [slug, page_segment] ->
                 component =
                   slug |> String.replace("-", "_") |> String.to_existing_atom()

                 page_key =
                   case page_segment do
                     "live-form" -> :live_form
                     other -> other |> String.replace("-", "_") |> String.to_existing_atom()
                   end

                 path = "/" <> slug <> "/" <> page_segment
                 Map.put(acc, {component, page_key}, {path, root})

               _ ->
                 acc
             end

           _, acc ->
             acc
         end)

  @type component :: atom()
  @type page_key :: atom()

  @doc """
  `{path, ready_selector}` for doc pages used by Wallaby (path is locale-less; session uses `Localize.put_locale/1`).
  """
  @spec page(component, page_key) :: {String.t(), String.t()}
  def page(component, page_key) do
    Map.fetch!(@pages, {component, page_key})
  end

  def has_page?(component, page_key) do
    Map.has_key?(@pages, {component, page_key})
  end

  def pages_for(component) when is_atom(component) do
    @pages
    |> Enum.filter(fn {{c, _}, _} -> c == component end)
    |> Enum.map(fn {{_, k}, v} -> {k, v} end)
  end

  @doc """
  `model.visit_ready/3` for the given component page (path + `css(ready)`).
  """
  def visit_ready(session, model, component, page_key) do
    {path, ready} = page(component, page_key)
    model.visit_ready(session, path, css(ready))
  end
end
