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
            <Corex.NumberInput.number_input id="test-number-input" min={0} max={10} step={2} disabled invalid allow_mouse_wheel={false} required>
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
            <Corex.NumberInput.number_input id="test-number-input">
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
            <Corex.NumberInput.number_input id="test-number-input">
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
            <Corex.NumberInput.number_input id="test-number-input" translation={@translation}>
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

    test "does not emit data-controlled without value" do
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
      refute html =~ ~r/data-default-value="/
    end

    test "value sets data-default-value" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input id="x" value="7">
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-default-value="7")
      refute html =~ "data-value="
    end

    test "value sets data-default-value and visible input" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input id="x" value="5">
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-default-value="5")
      assert html =~ ~r/<input\b[^>]*\bvalue="5"[^>]*\bdata-part="input"/
    end

    test "field sets data-default-value from form value" do
      changeset =
        {%{}, %{value: :string}}
        |> Ecto.Changeset.cast(%{"value" => "99"}, [:value])

      form = to_form(changeset, as: :item, id: "item-form")

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input field={@form[:value]}>
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{form: form}
        )

      refute html =~ "data-controlled"
      assert html =~ ~S(data-default-value="99")
      assert html =~ ~r/<input\b[^>]*\bvalue="99"[^>]*\bdata-part="input"/
    end

    test "hidden form input ignores LiveView patches to value and uses text type for used_input tracking" do
      changeset =
        {%{}, %{amount: :string}}
        |> Ecto.Changeset.cast(%{"amount" => "42"}, [:amount])

      form = to_form(changeset, as: :item, id: "item-form")

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input field={@form[:amount]}>
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{form: form}
        )

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="item\[amount\]")(?=[^>]*\bvalue="42")[^>]*\bdata-part="value-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\bdata-part="value-input")[^>]*\bphx-mounted="[^"]*ignore_attrs[^"]*value/
    end

    test "visible input renders server-side value attribute to survive morphdom patches" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.NumberInput.number_input id="n1" value="5000">
              <:decrement_trigger>-</:decrement_trigger>
              <:increment_trigger>+</:increment_trigger>
            </Corex.NumberInput.number_input>
            """
          end,
          %{}
        )

      assert html =~ ~r/<input\b[^>]*\bvalue="5000"[^>]*\bdata-part="input"/
    end

    test "visible input renders empty value attribute when no value is provided" do
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

      assert html =~ ~r/<input\b[^>]*\bvalue=""[^>]*\bdata-part="input"/
    end
  end

  alias Corex.NumberInput

  describe "set_value/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.set_value("n1", 42)
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = NumberInput.set_value(socket, "n1", 42)
    end
  end

  describe "clear_value/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.clear_value("n1")
    end
  end

  describe "increment/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.increment("n1")
    end
  end

  describe "decrement/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.decrement("n1")
    end
  end

  describe "set_to_min/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.set_to_min("n1")
    end
  end

  describe "set_to_max/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.set_to_max("n1")
    end
  end

  describe "focus/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.focus("n1")
    end
  end

  describe "state/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = NumberInput.state("n1")
    end
  end

  describe "state/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = NumberInput.state(socket, "n1")
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
