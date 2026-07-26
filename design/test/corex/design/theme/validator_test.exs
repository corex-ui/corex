defmodule Corex.Design.Theme.ValidatorTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Theme.Validator
  alias Corex.Design.Theme.Presets

  describe "validate/1" do
    test "accepts a preset id with an empty override map" do
      assert Validator.validate(%{neo: %{}}) == {:ok, Map.take(Presets.all(), [:neo])}
    end

    test "validates every configured theme, not only the first" do
      assert {:error, message} = Validator.validate(%{neo: %{}, custom: %{}})
      assert message =~ "themes.custom"
    end

    test "rejects a non-atom theme id" do
      assert {:error, message} = Validator.validate(%{"neo" => %{}})
      assert message =~ ~s(invalid theme id "neo")
    end

    test "rejects a theme spec that is not a map" do
      assert {:error, message} = Validator.validate(%{neo: "solid"})
      assert message =~ "themes.neo: theme spec must be a map"
      assert message =~ ~s("solid")
    end

    test "requires a full spec on a custom theme" do
      assert {:error, message} = Validator.validate(%{custom: %{palette: %{accent: "#3366ff"}}})
      assert message =~ "themes.custom"
      assert message =~ "require a full spec"
    end

    test "rejects an empty themes map" do
      assert Validator.validate(%{}) == {:error, "themes must contain at least one theme"}
    end

    test "merges a preset override rather than replacing the preset" do
      assert %{neo: merged} = Validator.validate!(%{neo: %{palette: %{"accent" => "#3366ff"}}})

      preset = Map.fetch!(Presets.all(), :neo)

      assert merged.palette["accent"] == "#3366ff"
      assert merged.colors == preset.colors
      assert Map.keys(merged.palette) == Map.keys(preset.palette)
    end

    test "rejects a palette anchor that is not a six-digit hex" do
      assert {:error, message} = Validator.validate(%{neo: %{palette: %{"accent" => "blue"}}})

      assert message =~ ~s(invalid palette hex "blue")
      assert message =~ "#RRGGBB"
    end

    test "rejects a three-digit hex shorthand" do
      assert {:error, message} = Validator.validate(%{neo: %{palette: %{"accent" => "#36f"}}})

      assert message =~ ~s(invalid palette hex "#36f")
    end

    test "rejects a global scale key set per theme" do
      assert {:error, message} =
               Validator.validate(%{neo: %{dimensions: %{space_scale: 1.2}}})

      assert message =~ "themes.neo: space_scale is not allowed in host theme overrides"
      assert message =~ "global via top-level scales:"
    end

    test "names the offending scale key when given as a string" do
      assert {:error, message} =
               Validator.validate(%{neo: %{"dimensions" => %{"text_scale" => 1.2}}})

      assert message =~ "text_scale is not allowed"
    end

    test "fills the untouched mode from the preset when an override names only one" do
      spec = %{palette: %{"accent" => "#3366ff"}, colors: %{light: %{}}}

      assert %{neo: merged} = Validator.validate!(%{neo: spec})

      preset = Map.fetch!(Presets.all(), :neo)

      assert merged.colors.dark == preset.colors.dark
    end

    test "accepts a role that names a palette anchor without a lightness" do
      assert %{neo: _} = Validator.validate!(%{neo: role_spec(%{palette: "accent"})})
    end

    test "rejects a role whose lightness is not an integer" do
      spec = role_spec(%{palette: "accent", lightness: "50"})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ ~s(themes colors roles :accent requires :lightness or :states)
    end

    test "rejects a role config that is not a map" do
      spec = role_spec("accent")

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ ~s(themes colors roles :accent must be a map)
    end

    test "rejects a lightness outside 0 to 100" do
      spec = role_spec(%{palette: "accent", lightness: 140})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ "lightness 140 must be from 0 to 100"
    end

    test "rejects an unknown state name" do
      spec = role_spec(%{palette: "accent", states: %{hovered: 40}})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ ~s(state :hovered must be one of)
    end

    test "rejects a non-integer state lightness" do
      spec = role_spec(%{palette: "accent", states: %{hover: "40"}})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ ~s(state :hover lightness must be an integer)
    end

    test "accepts a role given as states" do
      spec = role_spec(%{palette: "accent", states: %{hover: 40}})

      assert %{neo: _} = Validator.validate!(%{neo: spec})
    end

    test "requires the dimensions key on a custom theme so radius defaults are explicit" do
      spec = %{
        palette: %{"accent" => "#3366ff"},
        colors: %{light: %{roles: %{}}, dark: %{roles: %{}}}
      }

      assert {:error, message} = Validator.validate(%{custom: spec})

      assert message =~ "themes.custom: custom theme requires :dimensions key"
    end

    test "accepts a fully resolved custom theme" do
      spec = %{
        palette: %{"accent" => "#3366ff"},
        colors: %{light: %{roles: %{}}, dark: %{roles: %{}}},
        dimensions: %{}
      }

      assert %{custom: _} = Validator.validate!(%{custom: spec})
    end

    test "rejects a palette ref no anchor defines" do
      spec = %{
        palette: %{"accent" => "#3366ff"},
        colors: %{
          light: %{roles: %{accent: %{palette: "brand", lightness: 50}}},
          dark: %{roles: %{}}
        },
        dimensions: %{}
      }

      resolved = Validator.validate!(%{custom: spec})

      assert_raise ArgumentError, ~r/palette refs \["brand"\] missing from palette/, fn ->
        Validator.validate_resolved!(resolved)
      end
    end
  end

  describe "validate!/1" do
    test "raises with the validation message" do
      assert_raise ArgumentError, ~r/theme spec must be a map/, fn ->
        Validator.validate!(%{neo: "solid"})
      end
    end

    test "returns the normalized themes on success" do
      assert %{neo: _} = Validator.validate!(%{neo: %{}})
    end
  end

  describe "preset_ids/0" do
    test "lists the shipped presets" do
      assert Enum.sort(Validator.preset_ids()) == Enum.sort(Map.keys(Presets.all()))
    end
  end

  defp role_spec(accent_cfg) do
    %{
      palette: %{"accent" => "#3366ff"},
      colors: %{light: %{roles: %{accent: accent_cfg}}, dark: %{roles: %{}}}
    }
  end
end
