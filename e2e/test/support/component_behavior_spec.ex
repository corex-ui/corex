defmodule E2eWeb.ComponentBehaviorSpec do
  @moduledoc false

  use E2eWeb, :verified_routes
  import Wallaby.Query, only: [css: 1]

  @type component ::
          :accordion
          | :angle_slider
          | :checkbox
          | :combobox
          | :listbox
          | :switch
          | :tags_input
          | :toggle
  @type page_key ::
          :anatomy
          | :api
          | :events
          | :playground
          | :patterns
          | :animation
          | :controlled

  @doc """
  `{path, ready_selector}` for pilot Zag doc pages used by Wallaby models.

  Full doc route coverage (HTTP 200, router resolution, LiveView mounts) lives in
  `E2eWeb.DocA11yRoutesCoverageTest`. Tier 3 Wallaby depth exceptions: `E2eWeb.E2eBehaviorExceptions`.
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
  def page(:angle_slider, :playground), do: {~p"/angle-slider/playground", "#my-angle-slider"}

  def page(:angle_slider, :patterns),
    do: {~p"/angle-slider/patterns", "#angle-slider-patterns-page"}

  def page(:angle_slider, :controlled), do: {~p"/angle-slider/controlled", "#my-angle-slider"}

  def page(:checkbox, :anatomy), do: {~p"/checkbox/anatomy", "#checkbox-anatomy-page"}
  def page(:checkbox, :api), do: {~p"/checkbox/api", "#checkbox-api-page"}
  def page(:checkbox, :events), do: {~p"/checkbox/events", "#checkbox-events-page"}
  def page(:checkbox, :playground), do: {~p"/checkbox/playground", "#checkbox-playground"}
  def page(:checkbox, :patterns), do: {~p"/checkbox/patterns", "#checkbox-patterns-page"}

  def page(:listbox, :anatomy), do: {~p"/listbox/anatomy", "#listbox-anatomy-page"}
  def page(:listbox, :playground), do: {~p"/listbox/playground", "#listbox-playground-page"}
  def page(:listbox, :api), do: {~p"/listbox/api", "#listbox-api-page"}
  def page(:listbox, :events), do: {~p"/listbox/events", "#listbox-events-page"}
  def page(:listbox, :patterns), do: {~p"/listbox/patterns", "#listbox-patterns-page"}

  def page(:switch, :anatomy), do: {~p"/switch/anatomy", "#switch-anatomy-page"}
  def page(:switch, :api), do: {~p"/switch/api", "#switch-api-page"}
  def page(:switch, :events), do: {~p"/switch/events", "#switch-events-page"}
  def page(:switch, :playground), do: {~p"/switch/playground", "#switch-playground"}
  def page(:switch, :patterns), do: {~p"/switch/patterns", "#switch-patterns-page"}

  def page(:combobox, :anatomy), do: {~p"/combobox/anatomy", "#combobox-anatomy-page"}
  def page(:combobox, :api), do: {~p"/combobox/api", "#combobox-api-page"}
  def page(:combobox, :events), do: {~p"/combobox/events", "#combobox-events-page"}
  def page(:combobox, :playground), do: {~p"/combobox/playground", "#combobox-playground"}
  def page(:combobox, :patterns), do: {~p"/combobox/patterns", "#combobox-patterns-page"}

  def page(:tags_input, :anatomy), do: {~p"/tags-input/anatomy", "#tags-input-anatomy-page"}
  def page(:tags_input, :api), do: {~p"/tags-input/api", "#tags-input-api-page"}
  def page(:tags_input, :events), do: {~p"/tags-input/events", "#tags-input-events-page"}
  def page(:tags_input, :playground), do: {~p"/tags-input/playground", "#tags-input-playground"}
  def page(:tags_input, :patterns), do: {~p"/tags-input/patterns", "#tags-input-patterns-page"}

  def page(:toggle, :anatomy), do: {~p"/toggle/anatomy", "#toggle-anatomy-page"}
  def page(:toggle, :api), do: {~p"/toggle/api", "#toggle-api-page"}
  def page(:toggle, :events), do: {~p"/toggle/events", "#toggle-events-page"}
  def page(:toggle, :playground), do: {~p"/toggle/playground", "#toggle-playground"}
  def page(:toggle, :style), do: {~p"/toggle/style", "#toggle-styling-page"}

  @doc """
  `model.visit_ready/3` for the given component page (path + `css(ready)`).
  """
  def visit_ready(session, model, component, page_key) do
    {path, ready} = page(component, page_key)
    model.visit_ready(session, path, css(ready))
  end
end
