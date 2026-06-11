defmodule Corex.Design.ConfigTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Config
  alias Corex.Design.Config.Resolved

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    :ok
  end

  test "validate!/0 requires output" do
    CorexDesign.TestConfig.put([])

    assert_raise ArgumentError, ~r/output/, fn ->
      Config.validate!()
    end
  end

  test "validate!/0 accepts output-only config" do
    CorexDesign.TestConfig.put(output: "assets/css/corex.tailwind.css")
    assert :ok = Config.validate!()
  end

  test "validate!/0 accepts custom scale steps with values" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      scales: [size: [sm: 0.5, md: 1.0, huge: 2.0]]
    )

    assert :ok = Config.validate!()
  end

  test "validate!/0 rejects unknown scale axes" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      scales: [unknown: ~w(a b)a]
    )

    assert_raise ArgumentError, ~r/unknown axis/, fn ->
      Config.validate!()
    end
  end

  test "customization_map lists corex and Corex.Design keys" do
    map = Config.customization_map()
    assert Map.has_key?(map, :corex)
    assert Map.has_key?(map, Corex.Design)

    corex_keys = map[:corex] |> Enum.map(&elem(&1, 0))
    assert :emit_style_classes in corex_keys

    design_keys = map[Corex.Design] |> Enum.map(&elem(&1, 0))
    assert :on_invalid_style in design_keys
    assert :output in design_keys
    assert :default_theme in design_keys
    assert :default_mode in design_keys
    assert :themes in design_keys
    assert :scales in design_keys
    assert :recipes in design_keys
    assert :aliases in design_keys
    refute :theme in design_keys
    refute :vocabulary in design_keys
  end

  test "normalize maps flat keys to canonical options" do
    config = [
      output: "assets/css/corex.tailwind.css",
      default_theme: :uno,
      default_mode: :dark,
      themes: ~w(neo uno)a,
      scales: [size: [sm: 0.5, md: 1.0]],
      recipes: [include: [:button], sources: []],
      aliases: %{promo: :brand}
    ]

    flat = Resolved.resolved_options(config)

    assert Keyword.get(flat, :default_theme) == :uno
    assert Keyword.get(flat, :default_mode) == :dark
    assert Keyword.get(flat, :themes) == ~w(neo uno)a
    assert Keyword.get(flat, :scales) == [size: [sm: 0.5, md: 1.0]]
    assert Keyword.get(flat, :include_recipes) == [:button]
    assert Keyword.get(flat, :role_aliases) == %{promo: :brand}
  end
end
