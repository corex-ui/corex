defmodule Corex.Typography.Form do
  @moduledoc ~S'''
  Phoenix form helper with Corex form panel styling and sizing axes.

  Apps must exclude Phoenix's `form/1` and use Corex:

      use Phoenix.Component
      import Phoenix.Component, except: [form: 1]
      use Corex

  ```heex
  <.form :let={f} for={@form} phx-submit="save" max_width="lg">
    <.native_input field={f[:name]} />
    <.action type="submit" semantic="accent">Save</.action>
  </.form>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "form",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      gap: :space
    ]

  attr(:for, :any, required: true, doc: "An existing form or the form source data.")
  attr(:as, :atom, default: nil, doc: "Parameter prefix for form fields.")
  attr(:action, :string, default: nil, doc: "Form action URL for non-LiveView submits.")
  attr(:method, :string, default: nil, doc: "HTTP method when `:action` is set.")
  attr(:csrf_token, :any, default: nil, doc: "CSRF token override.")
  attr(:errors, :list, default: nil, doc: "Manual field errors keyword list.")
  attr(:multipart, :boolean, default: false, doc: "Sets multipart encoding for uploads.")

  attr(:rest, :global,
    include:
      ~W(autocomplete name rel enctype novalidate target id phx-submit phx-change phx-trigger-action)
  )

  slot(:inner_block, required: true, doc: "Fields and actions inside the form.")

  @doc type: :component
  def form(assigns) do
    class =
      Corex.Style.merge_class([
        corex_style_class(assigns),
        Map.get(assigns, :class),
        Map.get(assigns.rest || %{}, :class)
      ])

    rest =
      (Map.get(assigns, :rest) || %{})
      |> then(fn rest ->
        if class == "", do: rest, else: Map.put(rest, :class, class)
      end)

    assigns
    |> assign(:rest, rest)
    |> Phoenix.Component.form()
  end
end
