defmodule Corex.NumberInputTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.NumberInput.Connect

  describe "number_input/1" do
    test "renders" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input id="n1">
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      assert html =~ ~r/data-scope="number-input"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with label, min, max, step, disabled, invalid" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input min={0} max={10} step={2} disabled invalid allow_mouse_wheel={false} required>
              <:label>Number</:label>
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      assert html =~ "Number"
      assert html =~ "data-min=\"0\""
      assert html =~ "data-max=\"10\""
      assert html =~ "data-step=\"2\""
    end

    test "raises when increment_trigger is missing" do
      assert_raise ArgumentError, ~r/increment_trigger.*decrement_trigger/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input>
              <:decrement_trigger>-</:decrement_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )
      end
    end

    test "raises when decrement_trigger is missing" do
      assert_raise ArgumentError, ~r/increment_trigger.*decrement_trigger/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )
      end
    end

    test "renders with translation and buttons" do
      translation = %Corex.NumberInput.Translation{
        increase: "Plus",
        decrease: "Minus"
      }

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input translation={@translation}>
              <:increment_trigger>+</:increment_trigger>
              <:decrement_trigger>-</:decrement_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{translation: translation}
        )

      assert html =~ "Plus"
      assert html =~ "Minus"
      assert html =~ "+"
      assert html =~ "-"
    end

    test "does not emit data-controlled" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input id="x">
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      refute html =~ "data-controlled"
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-number"}
      result = Connect.root(assigns)
      assert result["id"] == "number-input:test-number"
      assert result["data-scope"] == "number-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-number"}
      result = Connect.label(assigns)
      assert result["id"] == "number-input:test-number:label"
      assert result["for"] == "number-input:test-number:input"
    end
  end
end
