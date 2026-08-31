defmodule Corex.PresenceTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Presence, only: [presence: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.presence id="presence-unit" class="presence" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Presence")
    assert html =~ ~S(data-scope="presence")
  end
end
