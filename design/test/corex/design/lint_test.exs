defmodule Corex.Design.LintTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Lint

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> CorexDesign.TestConfig.restore(original) end)
    :ok
  end

  test "scan/1 flags axis values dropped from scale subset" do
    CorexDesign.TestConfig.put(
      output: "assets/css/corex.tailwind.css",
      scales: [size: ~w(sm md)a]
    )

    tmp = System.tmp_dir!() |> Path.join("corex-lint-#{System.unique_integer()}")
    lib = Path.join(tmp, "lib")
    File.mkdir_p!(lib)
    on_exit(fn -> File.rm_rf(tmp) end)

    File.write!(
      Path.join(lib, "page.ex"),
      ~s|<.button size="xl" semantic="accent" />|
    )

    [issue | _] = Lint.scan(tmp)
    assert {_, 1, "size", "xl", _} = issue
    refute Enum.any?(Lint.scan(tmp), fn {_, _, axis, _, _} -> axis == "semantic" end)
  end

  test "run!/1 passes when literals match resolved vocabulary" do
    CorexDesign.TestConfig.put(output: "assets/css/corex.tailwind.css")

    tmp = System.tmp_dir!() |> Path.join("corex-lint-#{System.unique_integer()}")
    lib = Path.join(tmp, "lib")
    File.mkdir_p!(lib)
    on_exit(fn -> File.rm_rf(tmp) end)

    File.write!(
      Path.join(lib, "page.ex"),
      ~s|<.button size="md" semantic="accent" />|
    )

    assert :ok = Lint.run!(tmp)
  end
end
