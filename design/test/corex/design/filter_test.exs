defmodule Corex.Design.FilterTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Filter

  @utilities """
  @utility ui-solid {
    --ctl-bg: var(--ctl-fill);
  }

  @utility ui-accent {
    --ctl-fill: var(--color-accent);
    --ctl-fill-hover: var(--color-accent-hover);
  }

  @utility ui-brand {
    --ctl-fill: var(--color-brand);
  }

  @utility ui-alert {
    --ctl-fill: var(--color-alert);
  }

  @utility ui-size-lg {
    --ctl-size: var(--spacing-size-lg);
  }
  """

  describe "apply_utilities_semantics/2" do
    test "returns the css untouched when every default role is configured" do
      assert Filter.apply_utilities_semantics(@utilities, Filter.default_semantic_strings()) ==
               @utilities
    end

    test "accepts role atoms as the config supplies them" do
      assert Filter.apply_utilities_semantics(@utilities, Filter.default_semantics()) ==
               @utilities
    end

    test "drops the utility block of a role the config omits" do
      css = Filter.apply_utilities_semantics(@utilities, ~w(base accent))

      assert css =~ "@utility ui-accent {"
      refute css =~ "@utility ui-brand {"
      refute css =~ "@utility ui-alert {"
      refute css =~ "--ctl-fill: var(--color-brand);"
    end

    test "keeps utilities that are not palette roles" do
      css = Filter.apply_utilities_semantics(@utilities, ~w(base))

      assert css =~ "@utility ui-solid {"
      assert css =~ "@utility ui-size-lg {"
    end

    test "matches a role name exactly, so a longer utility survives" do
      css = """
      @utility ui-accent {
        --ctl-fill: var(--color-accent);
      }

      @utility ui-accent-soft {
        --ctl-fill: var(--color-accent-muted);
      }
      """

      filtered = Filter.apply_utilities_semantics(css, ~w(base))

      refute filtered =~ "@utility ui-accent {"
      assert filtered =~ "@utility ui-accent-soft {"
    end

    test "is idempotent" do
      once = Filter.apply_utilities_semantics(@utilities, ~w(base accent))

      assert Filter.apply_utilities_semantics(once, ~w(base accent)) == once
    end
  end

  describe "validate_component_ids/1" do
    test "accepts known ids as strings and atoms" do
      assert Filter.validate_component_ids(["button", :select]) == :ok
    end

    test "accepts an empty list" do
      assert Filter.validate_component_ids([]) == :ok
    end

    test "names the unknown ids and the allowed set" do
      assert {:error, message} = Filter.validate_component_ids(["button", "buton", "nope"])

      assert message =~ ~s(unknown ids ["buton", "nope"])
      assert message =~ "config :corex_design, components:"
      assert message =~ ~s("button")
    end

    test "the bang version raises the same message" do
      assert_raise ArgumentError, ~r/unknown ids \["buton"\]/, fn ->
        Filter.validate_component_ids!(["buton"])
      end
    end
  end

  describe "validate_semantics/1" do
    test "accepts the default roles" do
      assert Filter.validate_semantics(Filter.default_semantics()) == :ok
    end

    test "names the unknown roles and the allowed set" do
      assert {:error, message} = Filter.validate_semantics(["accent", "danger"])

      assert message =~ ~s(unknown roles ["danger"])
      assert message =~ ~s("accent")
    end

    test "the bang version raises the same message" do
      assert_raise ArgumentError, ~r/unknown roles \["danger"\]/, fn ->
        Filter.validate_semantics!(["danger"])
      end
    end
  end

  describe "semantic_atom/1" do
    test "maps a known role name to its atom" do
      assert Filter.semantic_atom("accent") == :accent
      assert Filter.semantic_atom(:accent) == :accent
    end

    test "raises on a role outside the allowlist rather than interning it" do
      assert_raise ArgumentError, fn -> Filter.semantic_atom("danger") end
    end
  end
end
