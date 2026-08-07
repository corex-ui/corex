defmodule Corex.Design.Emit.PreferencesTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Emit.Preferences

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)
    :ok
  end

  test "entry_import? follows enabled accessibility axes" do
    CorexDesign.TestConfig.put(accessibility: false)
    refute Preferences.entry_import?()

    CorexDesign.TestConfig.put(accessibility: [:motion])
    assert Preferences.entry_import?()
  end

  test "write! emits motion css under preferences when motion is enabled" do
    output = Path.expand("_build/test_preferences_motion", File.cwd!())
    File.rm_rf!(output)
    File.mkdir_p!(output)

    CorexDesign.TestConfig.put(accessibility: [:motion])
    assert :ok = Preferences.write!(output)

    motion = File.read!(Path.join(output, "tokens/preferences/motion.css"))
    assert motion =~ ~s([data-motion="reduce"])
    assert motion =~ "--duration-fast: 0.01ms;"

    entry = File.read!(Path.join(output, "preferences.css"))
    assert entry =~ ~s(@import "./tokens/preferences/motion.css";)
  end

  test "write! emits cursor focus and links preference css" do
    output = Path.expand("_build/test_preferences_misc", File.cwd!())
    File.rm_rf!(output)
    File.mkdir_p!(output)

    CorexDesign.TestConfig.put(accessibility: [:cursor, :focus, :links])
    assert :ok = Preferences.write!(output)

    assert File.read!(Path.join(output, "tokens/preferences/cursor.css")) =~
             ~s([data-cursor="large"])

    assert File.read!(Path.join(output, "tokens/preferences/focus.css")) =~
             ~s([data-focus="strong"])

    assert File.read!(Path.join(output, "tokens/preferences/links.css")) =~
             ~s([data-links="underline"])
  end

  test "write! removes preferences when accessibility is off" do
    output = Path.expand("_build/test_preferences_off", File.cwd!())
    File.rm_rf!(output)
    File.mkdir_p!(output)
    File.mkdir_p!(Path.join(output, "tokens/preferences"))
    File.write!(Path.join(output, "preferences.css"), "stale")

    CorexDesign.TestConfig.put(accessibility: false)
    assert :ok = Preferences.write!(output)

    refute File.exists?(Path.join(output, "preferences.css"))
    refute File.dir?(Path.join(output, "tokens/preferences"))
  end
end
