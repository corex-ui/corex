defmodule Corex.Design.ThemeOptionsTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Theme.Options
  alias Corex.Design.Theme.Presets

  test "built-in presets validate" do
    assert {:ok, _} = Options.validate(Presets.all())
  end

  test "rejects invalid palette hex" do
    assert {:error, msg} =
             Options.validate(%{
               bad: %{
                 palette: %{"accent" => "not-a-color"},
                 colors: %{light: %{}, dark: %{}}
               }
             })

    assert msg =~ "invalid palette hex"
  end
end
