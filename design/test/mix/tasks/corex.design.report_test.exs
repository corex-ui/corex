defmodule Mix.Tasks.Corex.Design.ReportTest do
  use ExUnit.Case, async: false

  setup do
    original = CorexDesign.TestConfig.snapshot()
    on_exit(fn -> restore_env(original) end)
    CorexDesign.TestConfig.put(default_theme: :neo)
    :ok
  end

  defp restore_env(env), do: CorexDesign.TestConfig.restore(env)

  test "mix corex.design.report writes json and markdown" do
    tmp = Path.join(System.tmp_dir!(), "corex_report_#{System.unique_integer([:positive])}")
    out = Path.join(tmp, "reports")

    mix_run(~w(corex.design.report --format all --output-dir #{out} --theme neo --mode light))

    assert File.exists?(Path.join(out, "neo-light-contrast.json"))
    assert File.exists?(Path.join(out, "neo-light-contrast.md"))
  end

  defp mix_run(args) do
    Mix.Task.reenable("corex.design.report")
    Mix.Task.run("corex.design.report", args)
  end
end
