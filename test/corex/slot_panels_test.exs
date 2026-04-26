defmodule Corex.SlotTest do
  use ExUnit.Case, async: true

  alias Corex.Slot

  defp slot(value, extras \\ %{}) do
    Map.merge(%{value: value, inner_block: fn _ -> nil end}, extras)
  end

  describe "resolve_panels!/2 happy path" do
    test "pairs required slots and merges optional in trigger order" do
      triggers = [slot("lorem"), slot("duis"), slot("donec")]
      contents = [slot("donec"), slot("lorem"), slot("duis")]
      indicators = [slot("lorem")]

      panels =
        Slot.resolve_panels!(
          %{trigger: triggers, content: contents, indicator: indicators},
          required: [:trigger, :content],
          optional: [:indicator],
          component: "Accordion"
        )

      assert Enum.map(panels, & &1.value) == ["lorem", "duis", "donec"]

      [lorem, _duis, donec] = panels
      assert lorem.trigger == Enum.at(triggers, 0)
      assert lorem.content == Enum.at(contents, 1)
      assert lorem.indicator == hd(indicators)
      assert donec.indicator == nil
      assert Enum.all?(panels, &(&1.disabled == false))
    end

    test "missing optional slot list is treated as empty" do
      panels =
        Slot.resolve_panels!(
          %{trigger: [slot("a")], content: [slot("a")]},
          required: [:trigger, :content],
          optional: [:indicator]
        )

      assert [%{value: "a", indicator: nil}] = panels
    end
  end

  describe "positional fallback" do
    test "uses item-N when value is missing or empty" do
      triggers = [%{}, %{value: ""}, %{value: "named"}]
      contents = [%{}, %{value: ""}, %{value: "named"}]

      panels =
        Slot.resolve_panels!(
          %{trigger: triggers, content: contents},
          required: [:trigger, :content]
        )

      assert Enum.map(panels, & &1.value) == ["item-0", "item-1", "named"]
    end

    test "custom :fallback callback is honored" do
      triggers = [%{}, %{}]
      contents = [%{}, %{}]

      panels =
        Slot.resolve_panels!(
          %{trigger: triggers, content: contents},
          required: [:trigger, :content],
          fallback: fn i -> "row-#{i}" end
        )

      assert Enum.map(panels, & &1.value) == ["row-0", "row-1"]
    end
  end

  describe "disabled callback" do
    test "OR semantics across all matched entries" do
      triggers = [slot("a", %{disabled: true}), slot("b")]
      contents = [slot("a"), slot("b", %{disabled: true})]

      panels =
        Slot.resolve_panels!(
          %{trigger: triggers, content: contents},
          required: [:trigger, :content],
          disabled: fn entries ->
            entries |> Map.values() |> Enum.any?(&Map.get(&1 || %{}, :disabled, false))
          end
        )

      assert Enum.map(panels, & &1.disabled) == [true, true]
    end

    test "defaults to false when callback is omitted" do
      panels =
        Slot.resolve_panels!(
          %{trigger: [slot("a", %{disabled: true})], content: [slot("a", %{disabled: true})]},
          required: [:trigger, :content]
        )

      assert [%{disabled: false}] = panels
    end
  end

  describe "validation errors" do
    test "raises on duplicate value within a single slot kind" do
      assert_raise ArgumentError, ~r/duplicate value\(s\) "a" in :trigger slots/, fn ->
        Slot.resolve_panels!(
          %{trigger: [slot("a"), slot("a")], content: [slot("a")]},
          required: [:trigger, :content],
          component: "Accordion"
        )
      end
    end

    test "raises when required slot value sets do not match" do
      assert_raise ArgumentError, ~r/:trigger and :content slot values must match exactly/, fn ->
        Slot.resolve_panels!(
          %{trigger: [slot("a"), slot("b")], content: [slot("a"), slot("c")]},
          required: [:trigger, :content],
          component: "Accordion"
        )
      end
    end

    test "raises when an optional value is not in the required value set" do
      assert_raise ArgumentError, ~r/:indicator value "x" has no matching required slot/, fn ->
        Slot.resolve_panels!(
          %{trigger: [slot("a")], content: [slot("a")], indicator: [slot("x")]},
          required: [:trigger, :content],
          optional: [:indicator],
          component: "Accordion"
        )
      end
    end
  end
end
