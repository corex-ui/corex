Code.require_file("mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Corex.New.WebTest do
  use ExUnit.Case
  import MixHelper
  import ExUnit.CaptureIO

  test "new without args shows help" do
    assert capture_io(fn -> Mix.Tasks.Corex.New.Web.run([]) end) =~ "phx.new.web"
  end

  test "new outside umbrella" do
    in_tmp("outside umbrella", fn ->
      assert_raise Mix.Error, ~r"The web task can only be run within an umbrella's apps directory", fn ->
        Mix.Tasks.Corex.New.Web.run(["007invalid"])
      end
    end)
  end

  @tag :integration
  test "integration: new web app in umbrella" do
    unless Mix.Task.get("phx.new.web") && Mix.Task.get("igniter.install") do
      flunk(
        "Install mix archives to run this test: phx_new (provides phx.new.web), igniter_new. Then: mix test --include integration"
      )
    end

    send(self(), {:mix_shell_input, :yes?, false})

    in_tmp_umbrella_project("corex new web integration", fn ->
      Mix.Tasks.Corex.New.Web.run(["integration_web"])
      assert File.dir?("integration_web")
      assert File.regular?("integration_web/mix.exs")
    end)
  end
end
