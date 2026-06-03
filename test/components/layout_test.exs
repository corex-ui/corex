defmodule Corex.LayoutTest do
  use CorexTest.ComponentCase, async: true

  alias CorexTest.LayoutHelpers

  test "box renders padding attribute and content" do
    result = render_component(&LayoutHelpers.render_box/1, %{})
    assert [_] = find_in_html(result, ~S([data-box][data-box-padding="lg"]))
    assert text_in_html(result) =~ "boxed"
  end

  test "row renders gap and justify attributes" do
    result = render_component(&LayoutHelpers.render_row/1, %{})

    assert [_] =
             find_in_html(
               result,
               ~S([data-row][data-row-gap="lg"][data-row-justify="between"])
             )
  end

  test "row derives the padding family from its recipe and emits no margin" do
    result = render_component(&LayoutHelpers.render_row_padding/1, %{})

    assert [_] =
             find_in_html(
               result,
               ~S([data-row][data-row-padding-inline="xl"][data-row-padding-block="md"])
             )

    refute result =~ "data-row-margin"
  end

  test "stack renders default column direction with gap" do
    result = render_component(&LayoutHelpers.render_stack/1, %{})

    assert [_] =
             find_in_html(
               result,
               ~S([data-stack][data-stack-direction="column"][data-stack-gap="md"])
             )
  end

  test "grid renders column count" do
    result = render_component(&LayoutHelpers.render_grid/1, %{})
    assert [_] = find_in_html(result, ~S([data-grid][data-grid-columns="3"]))
  end

  test "container renders size and is a div by default" do
    result = render_component(&LayoutHelpers.render_container/1, %{})
    assert [_] = find_in_html(result, ~S(div[data-container][data-container-size="lg"]))
  end

  test "spacer renders a bare design attribute" do
    result = render_component(&LayoutHelpers.render_spacer/1, %{})
    assert [_] = find_in_html(result, "[data-spacer]")
  end

  test "divider renders an hr with orientation" do
    result = render_component(&LayoutHelpers.render_divider/1, %{})

    assert [_] =
             find_in_html(
               result,
               ~S(hr[data-divider][data-divider-orientation="horizontal"])
             )
  end
end
