defmodule E2eWeb.ComponentEventLogTest do
  use ExUnit.Case, async: true

  alias E2eWeb.ComponentEventLog

  test "format_numeric_value/1 prints slider lists as numbers, not charlists" do
    assert ComponentEventLog.format_numeric_value([75]) == "75"
    assert ComponentEventLog.format_numeric_value([56]) == "56"
    assert ComponentEventLog.format_numeric_value([45]) == "45"
    assert ComponentEventLog.format_numeric_value([31]) == "31"
    assert ComponentEventLog.format_numeric_value([20, 80]) == "20 – 80"
  end

  test "format_angle_value/1 prints a single angle" do
    assert ComponentEventLog.format_angle_value(90.0) == "90"
    assert ComponentEventLog.format_angle_value([180]) == "180"
  end
end
