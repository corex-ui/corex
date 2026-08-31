defmodule Corex.RatingGroupTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.RatingGroup, only: [rating_group: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.rating_group id="rating-group-unit" class="rating-group" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="RatingGroup")
    assert html =~ ~S(data-scope="rating-group")
  end

  test "item slot receives index" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.rating_group id="rating-group-smileys" class="rating-group" value={4.0}>
            <:item :let={item}>
              <span>face-{item.index}</span>
            </:item>
          </.rating_group>
          """
        end,
        %{}
      )

    assert html =~ "face-1"
    assert html =~ "face-5"
  end
end
