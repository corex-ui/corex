defmodule Mix.Tasks.Corex.InstallTest do
  use ExUnit.Case, async: true
  import Igniter.Test

  test "patches app.js with corex import" do
    phx_test_project(app_name: :corex)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("assets/js/app.js", """
     +|import corex from "corex"
    """)
  end

  test "patches app.js with corex hooks" do
    phx_test_project(app_name: :corex)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("assets/js/app.js", """
     +|  hooks: {...colocatedHooks, ...corex},
    """)
  end

  test "patches esbuild config with format=esm and splitting" do
    phx_test_project(app_name: :corex)
    |> Igniter.compose_task("corex.install", ["--no-design", "--yes"])
    |> assert_has_patch("config/config.exs", """
     +|      ~w(js/app.js --bundle --format=esm --splitting --target=
    """)
  end
end
