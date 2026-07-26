defmodule E2eWeb.ComponentBehaviorBar do
  @moduledoc """
  Shared behavior regression bar for Corex Wallaby pilots (Accordion exemplar).

  After large hook/demo changes, do not treat green CI as proof a component works.
  Suites must assert real state so dead Zag hooks or LiveView wiring fail.

  ## Must catch (when the doc page exists)

  | Breakage | Assert |
  | --- | --- |
  | Primary interaction | Anatomy: `aria-*` / `data-state` / value / open after click |
  | LiveView → Zag API | API: binding + JS CustomEvent + server `push_event` each flip state |
  | Zag → LiveView events | Events: server and client logs mention the new value |
  | Controlled remorph | Patterns: UI matches assign after change |
  | Collection remorph | Patterns: dynamic add/reset changes DOM |
  | Keyboard / focus | One suite on anatomy minimal (not on every page) |

  ## False friend rule

  A feature that clicks then only asserts the element still exists does **not** count.
  Prefer `wait_*` + state helpers on the component model.

  ## Layers

  - Vitest owns hook/component contracts
  - LiveViewTest owns server event assigns
  - Wallaby owns visible user journeys

  Policy enforcement of per-page state asserts is phased in after blind suites are hardened;
  this module documents the bar for authors and reviewers.
  """

  @false_friend_examples [
    "click then assert trigger still exists",
    "visit page and assert host mounts without data-loading only",
    "DocComponentWallaby primary click with no aria/data-state/value assert"
  ]

  @doc "Examples of assertions that do not meet the behavior bar."
  def false_friend_examples, do: @false_friend_examples

  @doc """
  Dimension atoms the Accordion exemplar covers. Apply only when the component has that page.
  """
  def dimensions do
    [
      :anatomy_state,
      :api_binding,
      :api_js,
      :api_server,
      :events_server,
      :events_client,
      :patterns_controlled,
      :patterns_dynamic,
      :keyboard_aria
    ]
  end
end
