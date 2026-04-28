defmodule Mix.Corex.Install.DesignTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Design

  test "maybe_schedule_design with design: false does not queue mix corex.design" do
    igniter = Igniter.new() |> Design.maybe_schedule_design(design: false)
    assert igniter.tasks == []
  end

  test "maybe_schedule_design queues mix corex.design" do
    igniter = Igniter.new() |> Design.maybe_schedule_design(design: true)
    assert {"corex.design", []} in igniter.tasks
  end

  test "maybe_schedule_design with :designex passes --designex" do
    igniter = Igniter.new() |> Design.maybe_schedule_design(design: true, designex: true)
    assert {"corex.design", ["--designex"]} in igniter.tasks
  end
end
