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
      assert {:error, message} = Validator.validate(%{custom: %{seeds: %{accent: "#3366ff"}}})
      assert message =~ "themes.custom"
      assert message =~ "require a full spec"
    end

    test "rejects an empty themes map" do
      assert Validator.validate(%{}) == {:error, "themes must contain at least one theme"}
    end

    test "merges a preset override rather than replacing the preset" do
      assert %{neo: merged} = Validator.validate!(%{neo: %{seeds: %{"accent" => "#3366ff"}}})

      preset = Map.fetch!(Presets.all(), :neo)

      assert merged.seeds["accent"] == "#3366ff"
      assert merged.colors == preset.colors
      assert Map.keys(merged.seeds) == Map.keys(preset.seeds)
    end

    test "rejects a seed that is not a six-digit hex" do
      assert {:error, message} = Validator.validate(%{neo: %{seeds: %{"accent" => "blue"}}})

      assert message =~ ~s(invalid seed hex "blue")
      assert message =~ "#RRGGBB"
    end

    test "rejects a three-digit hex shorthand" do
      assert {:error, message} = Validator.validate(%{neo: %{seeds: %{"accent" => "#36f"}}})

      assert message =~ ~s(invalid seed hex "#36f")
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
      spec = %{seeds: %{"accent" => "#3366ff"}, colors: %{light: %{}}}

      assert %{neo: merged} = Validator.validate!(%{neo: spec})

      preset = Map.fetch!(Presets.all(), :neo)

      assert merged.colors.dark == preset.colors.dark
    end

    test "accepts a lightness token" do
      assert %{neo: _} = Validator.validate!(%{neo: token_spec(%{kind: :l, seed: :accent, l: 0.5})})
    end

    test "rejects an invalid lightness" do
      spec = token_spec(%{kind: :l, seed: :accent, l: 1.4})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ "invalid lightness"
    end

    test "rejects an unknown state name" do
      spec = token_spec(%{kind: :l, seed: :accent, l: 0.4, states: %{hovered: 0.4}})

      assert {:error, message} = Validator.validate(%{neo: spec})

      assert message =~ ~s(state :hovered must be one of)
    end

    test "accepts a contrast token" do
      spec =
        token_spec(%{kind: :contrast, seed: :accent, against: :root, target: 7.0})

      assert %{neo: _} = Validator.validate!(%{neo: spec})
    end

    test "requires the dimensions key on a custom theme so radius defaults are explicit" do
      spec = %{
        seeds: %{"accent" => "#3366ff"},
        colors: %{light: %{root: %{kind: :l, l: 0.99}}, dark: %{root: %{kind: :l, l: 0.1}}}
      }

      assert {:error, message} = Validator.validate(%{custom: spec})

      assert message =~ "themes.custom: custom theme requires :dimensions key"
    end

    test "accepts a fully resolved custom theme" do
      spec = %{
        seeds: %{"accent" => "#3366ff", "neutral" => "#eeeeee"},
        colors: %{
          light: %{"root" => %{kind: :l, seed: :neutral, l: 0.99}},
          dark: %{"root" => %{kind: :l, seed: :accent, l: 0.1}}
        },
        dimensions: %{}
      }

      assert %{custom: %Corex.Design.Theme.Spec{dimensions: %Corex.Design.Theme.Spec.Dimensions{}}} =
               Validator.validate!(%{custom: spec})
    end

    test "rejects nested legacy surface/roles color maps" do
      spec = %{
        seeds: %{"neutral" => "#eeeeee"},
        colors: %{
          light: %{surface: %{page: %{kind: :l, l: 0.99}}, roles: %{accent: %{kind: :l, l: 0.4}}},
          dark: %{"root" => %{kind: :l, seed: :neutral, l: 0.1}}
        },
        dimensions: %{}
      }

      assert {:error, message} = Validator.validate(%{custom: spec})
      assert message =~ "nested :surface/:roles/:on"
    end

    test "rejects a seed ref no anchor defines" do
      spec = %{
        seeds: %{"accent" => "#3366ff"},
        colors: %{
          light: %{"brand" => %{kind: :l, seed: :brand, l: 0.5}},
          dark: %{"root" => %{kind: :l, seed: :accent, l: 0.1}}
        },
        dimensions: %{}
      }

      resolved = Validator.validate!(%{custom: spec})

      assert_raise ArgumentError, ~r/seed refs/, fn ->
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

  defp token_spec(accent_cfg) do
    %{
      seeds: %{"accent" => "#3366ff", "neutral" => "#eeeeee"},
      colors: %{
        light: %{"accent" => accent_cfg},
        dark: %{"root" => %{kind: :l, seed: :accent, l: 0.1}}
      }
    }
  end
end
