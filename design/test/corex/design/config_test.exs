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

  test "validate!/0 rejects scale steps outside Corex.Scales" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      scales: [size: ~w(sm huge)a]
    )

    assert_raise ArgumentError, ~r/subset of Corex.Scales/, fn ->
      Config.validate!()
    end
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

  test "customization_map lists flat corex_design keys" do
    map = Config.customization_map()
    assert Keyword.has_key?(map, :corex_design)
    refute Keyword.has_key?(map, :corex)

    keys = map[:corex_design] |> Enum.map(&elem(&1, 0))
    assert :output in keys
    assert :default_theme in keys
    assert :default_mode in keys
    assert :themes in keys
    assert :scales in keys
    assert :recipes in keys
    assert :aliases in keys
    refute :theme in keys
    refute :vocabulary in keys
  end

  test "normalize maps flat keys to canonical options" do
    config = [
      output: "assets/css/corex.tailwind.css",
      default_theme: :uno,
      default_mode: :dark,
      themes: ~w(neo uno)a,
      scales: [size: ~w(sm lg)a],
      recipes: [include: [:button], sources: []],
      aliases: %{promo: :brand}
    ]

    flat = Resolved.resolved_options(config)

    assert Keyword.get(flat, :default_theme) == :uno
    assert Keyword.get(flat, :default_mode) == :dark
    assert Keyword.get(flat, :themes) == ~w(neo uno)a
    assert Keyword.get(flat, :scales) == [size: ~w(sm lg)a]
    assert Keyword.get(flat, :include_recipes) == [:button]
    assert Keyword.get(flat, :role_aliases) == %{promo: :brand}
  end
end
