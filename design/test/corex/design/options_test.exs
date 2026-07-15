defmodule Corex.Design.OptionsTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Options

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)

    CorexDesign.TestConfig.put(
      default_theme: :neo,
      default_mode: :light,
      components: nil,
      semantics: nil
    )

    :ok
  end

  test "report lists allowed components, themes, and current defaults" do
    out = Options.report()

    assert out =~ "accordion"
    assert out =~ "neo"
    assert out =~ "Allowed components:"
    assert out =~ "Allowed themes:"
    assert out =~ "Current default_theme: neo"
    assert out =~ "Current default_mode: light"
    assert out =~ "Current components: all"
  end
end
