defmodule Corex.Design.LintTest do
  use ExUnit.Case, async: false

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    CorexDesign.TestConfig.put(output: "assets/css/corex.tailwind.css")
    :ok
  end

  test "flags unknown semantic literals in scanned files" do
    dir = System.tmp_dir!()
    path = Path.join(dir, "lint_sample.ex")

    File.write!(
      path,
      ~s|<.badge semantic="not-a-real-role" class="badge" />|
    )

    {:ok, issues} = Corex.Design.Lint.run([path])

    assert [{^path, :semantic, "not-a-real-role", _}] = issues
  end

  test "accepts known semantic literals" do
    dir = System.tmp_dir!()
    path = Path.join(dir, "lint_ok.ex")

    File.write!(
      path,
      ~s|<.badge semantic="accent" class="badge" />|
    )

    {:ok, issues} = Corex.Design.Lint.run([path])
    assert issues == []
  end
end
