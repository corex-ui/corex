defmodule Corex.Design.AccessibilityTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Accessibility

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)
    :ok
  end

  test "false and nil yield no axes" do
    CorexDesign.TestConfig.put(accessibility: false)
    assert Accessibility.axes() == []
    refute Accessibility.enabled?()

    CorexDesign.TestConfig.put(accessibility: nil)
    assert Accessibility.axes() == []
  end

  test "true enables all known axes" do
    CorexDesign.TestConfig.put(accessibility: true)
    assert Accessibility.axes() == Accessibility.preferred_axes()
  end

  test "list enables a subset and sanitizes values" do
    CorexDesign.TestConfig.put(accessibility: [:text, :contrast])

    assert Accessibility.axes() == [:text, :contrast]
    assert Accessibility.defaults() == %{"text" => "md", "contrast" => "normal"}

    assert Accessibility.parse("text=lg&contrast=more&cursor=large") == %{
             "text" => "lg",
             "contrast" => "more"
           }

    assert Accessibility.parse("text=xl") == %{"text" => "md", "contrast" => "normal"}
    assert Accessibility.parse("text=huge") == %{"text" => "md", "contrast" => "normal"}
  end

  test "encode round-trips sanitized prefs" do
    CorexDesign.TestConfig.put(accessibility: [:text, :contrast])

    encoded = Accessibility.encode(%{"text" => "lg", "contrast" => "more", "cursor" => "large"})
    assert Accessibility.parse(encoded) == %{"text" => "lg", "contrast" => "more"}
  end

  test "text_zoom and attr_name helpers" do
    assert Accessibility.text_zoom("md") == 1.0
    assert Accessibility.text_zoom("lg") == 1.25
    assert Accessibility.attr_name(:motion) == "data-motion"
    assert Accessibility.axis_enabled?(:text) == false

    CorexDesign.TestConfig.put(accessibility: [:text])
    assert Accessibility.axis_enabled?(:text)
    refute Accessibility.axis_enabled?(:motion)
  end
end
