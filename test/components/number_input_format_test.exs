defmodule Corex.NumberInput.FormatTest do
  use ExUnit.Case, async: true

  alias Corex.NumberInput.Format

  describe "format_display/2" do
    test "empty values" do
      assert Format.format_display(nil, 1.0) == ""
      assert Format.format_display("", 1.0) == ""
      assert Format.format_display("  ", 1.0) == ""
    end

    test "whole step strips .0 from whole numbers" do
      assert Format.format_display(10.0, 1.0) == "10"
      assert Format.format_display("10.0", 1.0) == "10"
      assert Format.format_display(10, 1.0) == "10"
    end

    test "whole step keeps fractional values" do
      assert Format.format_display(10.5, 1.0) == "10.5"
    end

    test "whole step adds en-US grouping" do
      assert Format.format_display(1234.5, 1.0) == "1,234.5"
      assert Format.format_display(5000, 1.0) == "5,000"
      assert Format.format_display(1_000_000, 1.0) == "1,000,000"
    end

    test "fractional step respects decimal places and grouping" do
      assert Format.format_display(10.5, 0.1) == "10.5"
      assert Format.format_display(10.55, 0.01) == "10.55"
      assert Format.format_display(1234.5, 0.1) == "1,234.5"
      assert Format.format_display(1234.567, 0.01) == "1,234.57"
    end

    test "parses grouped input strings" do
      assert Format.format_display("1,234.5", 0.1) == "1,234.5"
    end
  end

  describe "format_submit/2" do
    test "empty values" do
      assert Format.format_submit(nil, 1.0) == ""
      assert Format.format_submit("", 1.0) == ""
    end

    test "never adds grouping" do
      assert Format.format_submit(1234.5, 1.0) == "1234.5"
      assert Format.format_submit(5000, 1.0) == "5000"
      assert Format.format_submit(1234.567, 0.01) == "1234.57"
    end

    test "matches display step rules without commas" do
      assert Format.format_submit(10.0, 1.0) == "10"
      assert Format.format_submit(10.5, 0.1) == "10.5"
    end

    test "parses grouped input strings" do
      assert Format.format_submit("1,234.5", 0.1) == "1234.5"
    end
  end
end
