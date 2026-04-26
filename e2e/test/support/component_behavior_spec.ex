defmodule E2eWeb.ComponentBehaviorSpec do
  @moduledoc false

  use E2eWeb, :verified_routes
  import Wallaby.Query, only: [css: 1]

  @type component :: :accordion | :angle_slider | :checkbox
  @type page_key ::
          :anatomy
          | :api
          | :events
          | :playground
          | :patterns
          | :animation

  @doc """
  `{path, ready_selector}` for a pilot Zag component doc page. Paths use the `~p` sigil
  (locale prefix from `E2eWeb.Locale.current/0`); in tests set `Localize.put_locale/1` when needed.
  """
  @spec page(component, page_key) :: {String.t(), String.t()}
  def page(:accordion, :anatomy), do: {~p"/accordion/anatomy", "#accordion-anatomy-page"}
  def page(:accordion, :api), do: {~p"/accordion/api", "#accordion-api-page"}
  def page(:accordion, :events), do: {~p"/accordion/events", "#accordion-events-page"}
  def page(:accordion, :playground), do: {~p"/accordion/playground", "#my-accordion"}
  def page(:accordion, :patterns), do: {~p"/accordion/patterns", "#accordion-patterns-page"}
  def page(:accordion, :animation), do: {~p"/accordion/animation", "#accordion-animation-page"}

  def page(:angle_slider, :anatomy), do: {~p"/angle-slider/anatomy", "#angle-slider-anatomy-page"}
  def page(:angle_slider, :api), do: {~p"/angle-slider/api", "#angle-slider-api-page"}
  def page(:angle_slider, :events), do: {~p"/angle-slider/events", "#angle-slider-events-page"}

  def page(:checkbox, :anatomy), do: {~p"/checkbox/anatomy", "#checkbox-anatomy-page"}
  def page(:checkbox, :api), do: {~p"/checkbox/api", "#checkbox-api-page"}
  def page(:checkbox, :events), do: {~p"/checkbox/events", "#checkbox-events-page"}

  @doc """
  `model.visit_ready/3` for the given component page (path + `css(ready)`).
  """
  def visit_ready(_session, model, component, page_key) do
    {path, ready} = page(component, page_key)
    model.visit_ready(path, css(ready))
  end
end
