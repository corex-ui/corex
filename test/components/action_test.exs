defmodule Corex.ActionTest do
  use CorexTest.ComponentCase, async: false

  defp class_of(element) do
    case Floki.attribute([element], "class") do
      [class] -> class
      [] -> nil
    end
  end

  defp assert_has_classes(button, expected) do
    classes = class_of(button) |> String.split(" ", trim: true) |> MapSet.new()

    for class <- expected do
      assert MapSet.member?(classes, class),
             "expected class #{inspect(class)} in #{inspect(class_of(button))}"
    end
  end

  describe "action/1" do
    test "renders button with default type and solid styling" do
      result = render_component(&CorexTest.ComponentHelpers.render_action/1, %{})
      assert [button] = find_in_html(result, "button")
      assert text_in_html(result) =~ "Click"
      assert_has_classes(button, ~w(button button--variant-solid button--size-md))
    end

    test "renders button with type submit" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "submit",
          aria_label: nil,
          disabled: false
        )

      assert [_] = find_in_html(result, "button[type=submit]")
      assert text_in_html(result) =~ "Save"
    end

    test "renders button with aria_label" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "button",
          aria_label: "Close dialog",
          disabled: false
        )

      assert [_] = find_in_html(result, ~S(button[aria-label="Close dialog"]))
    end

    test "renders disabled button" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_opts/1,
          type: "button",
          aria_label: nil,
          disabled: true
        )

      assert [_] = find_in_html(result, "button[disabled]")
    end
  end

  describe "action/1 style attributes" do
    test "semantic and size stamp BEM modifiers" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          semantic: "accent",
          size: "lg"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-solid button--semantic-accent button--size-lg))
    end

    test "variant and radius stamp BEM modifiers" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          variant: "ghost",
          radius: "xl"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-ghost button--rounded-xl button--size-md))
    end

    test "as link stamps link BEM modifiers" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          as: "link",
          semantic: "accent"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(link link--variant-solid link--semantic-accent link--size-md))
      refute class_of(button) =~ "button--"
    end

    test "extra class is kept alongside BEM modifiers" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          semantic: "brand",
          class: "w-full"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-solid button--semantic-brand button--size-md w-full))
    end

    test "explicit class modifiers merge with defaults" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          class: "button button--semantic-accent"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-solid button--size-md button--semantic-accent))
    end

    test "with neither attrs nor class stamps default solid md button" do
      result = render_component(&CorexTest.ComponentHelpers.render_action_styled/1, %{})

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-solid button--size-md))
    end

    test "indicator slot renders data-part indicator" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_with_indicator/1, %{})

      assert [_] = find_in_html(result, ~S([data-part="indicator"]))
      assert [_] = find_in_html(result, ~S(button[aria-label="Close"]))
    end
  end

  describe "action/1 bem styling" do
    test "stamps BEM modifiers and forwards class" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_action_styled/1,
          semantic: "accent",
          size: "lg",
          class: "button"
        )

      assert [button] = find_in_html(result, "button")
      assert_has_classes(button, ~w(button button--variant-solid button--semantic-accent button--size-lg))
    end
  end
end
