defmodule Mix.Corex.Install.DesignTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Design

  test "maybe_schedule_design with :no_design does not queue mix corex.design" do
    igniter = Igniter.new() |> Design.maybe_schedule_design([no_design: true])
    assert igniter.tasks == []
  end

  test "maybe_schedule_design queues mix corex.design with --force" do
    igniter = Igniter.new() |> Design.maybe_schedule_design([no_design: false])
    assert {"corex.design", ["--force"]} in igniter.tasks
  end

  test "maybe_schedule_design with :designex passes --force and --designex" do
    igniter = Igniter.new() |> Design.maybe_schedule_design([no_design: false, designex: true])
    assert {"corex.design", ["--force", "--designex"]} in igniter.tasks
  end
end
