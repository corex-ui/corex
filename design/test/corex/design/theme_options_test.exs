defmodule Corex.Design.ThemeOptionsTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Theme.Options
  alias Corex.Design.Theme.Presets

  test "built-in presets validate" do
    assert {:ok, _} = Options.validate(Presets.all())
  end

  test "rejects invalid seed hex" do
    assert {:error, msg} =
             Options.validate(%{
               bad: %{
                 seeds: %{"accent" => "not-a-color"},
                 colors: %{light: %{}, dark: %{}}
               }
             })

    assert msg =~ "invalid seed hex"
  end
end
