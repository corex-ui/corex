defmodule Corex.Design.Tokens.ContrastTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Tokens.Contrast

  describe "ratio/2" do
    test "black on white is the maximum WCAG ratio" do
      assert_in_delta Contrast.ratio("#000000", "#ffffff"), 21.0, 0.01
    end

    test "a color against itself has no contrast" do
      assert_in_delta Contrast.ratio("#3366ff", "#3366ff"), 1.0, 0.01
    end

    test "the ratio is symmetric" do
      assert_in_delta Contrast.ratio("#111827", "#f9fafb"),
                      Contrast.ratio("#f9fafb", "#111827"),
                      0.01
    end
  end

  describe "audit/1" do
    test "reports nothing when every audited pair clears its target" do
      assert Contrast.audit(%{{:probe, :light} => passing_tokens()}) == []
    end

    test "reports the pair, ratio and target of a failing text pair" do
      tokens = %{passing_tokens() | "ink" => "#eeeeee"}

      violations = Contrast.audit(%{{:probe, :light} => tokens})

      assert [%{theme: :probe, mode: :light} | _] = violations
      assert violation = Enum.find(violations, &(&1.label == "body text on page"))
      assert violation.fg == "ink (#eeeeee)"
      assert violation.bg == "root (#ffffff)"
      assert violation.target == 4.5
      assert violation.severity == :error
      assert violation.ratio < 4.5
    end

    test "grades a disabled pair as a warning rather than an error" do
      tokens = %{passing_tokens() | "ink-muted" => "#767676", "ui-muted" => "#6f6f6f"}

      assert [violation] =
               Contrast.audit(%{{:probe, :light} => tokens})
               |> Enum.filter(&(&1.label == "disabled neutral control text"))

      assert violation.severity == :warning
      assert violation.target == 3.0
    end

    test "skips a pair whose roles are absent from the token set" do
      assert Contrast.audit(%{{:probe, :light} => %{"ink" => "#000000"}}) == []
    end
  end

  describe "check!/1" do
    test "returns warnings and does not raise when no error pair fails" do
      tokens = %{passing_tokens() | "ink-muted" => "#767676", "ui-muted" => "#6f6f6f"}

      assert [%{severity: :warning}] = Contrast.check!(%{{:probe, :light} => tokens})
    end

    test "raises with the formatted failures when an error pair fails" do
      tokens = %{passing_tokens() | "ink" => "#eeeeee"}

      assert_raise ArgumentError, ~r/contrast check failed/, fn ->
        Contrast.check!(%{{:probe, :light} => tokens})
      end
    end

    test "passes on the real generated tokens" do
      assert is_list(Contrast.check!())
    end
  end

  describe "format/1" do
    test "names the theme, mode, pair, achieved ratio and target" do
      violation = %{
        theme: :probe,
        mode: :light,
        fg: "ink (#eeeeee)",
        bg: "root (#ffffff)",
        ratio: 1.1234,
        target: 4.5,
        severity: :error,
        label: "body text on page"
      }

      assert Contrast.format([violation]) ==
               "  [probe/light] ink (#eeeeee) on root (#ffffff): 1.12:1 (need 4.5:1) -- body text on page"
    end
  end

  defp passing_tokens do
    %{
      "ink" => "#000000",
      "ink-muted" => "#595959",
      "link" => "#0000cc",
      "root" => "#ffffff",
      "surface" => "#ffffff",
      "ui" => "#ffffff",
      "ui-hover" => "#ffffff",
      "ui-active" => "#ffffff",
      "ui-muted" => "#ffffff"
    }
  end
end
