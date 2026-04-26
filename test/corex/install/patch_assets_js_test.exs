defmodule Corex.Install.PatchAssetsJsTest do
  use ExUnit.Case, async: false

  alias Mix.Corex.Install.PatchAssetsJs

  @phx_18 ~s"""
  import "phoenix_html"
  import {Socket} from "phoenix"
  import {LiveSocket} from "phoenix_live_view"
  import {hooks as colocatedHooks} from "phoenix-colocated/x"
  import topbar from "../vendor/topbar"
  const liveSocket = new LiveSocket("/live", Socket, {
    longPollFallbackMs: 2500,
    params: {_csrf_token: csrfToken},
    hooks: {...colocatedHooks},
  })
  """

  test "default phoenix 1.8+ app.js: adds import and spread" do
    out = PatchAssetsJs.apply(@phx_18)
    assert out =~ ~r/import corex from "corex"/
    assert out =~ ~r/hooks:/
    assert out =~ "...colocatedHooks"
    assert out =~ "...corex"
  end

  test "stripspaced LiveSocket import" do
    src =
      @phx_18
      |> String.replace("import {LiveSocket}", "import { LiveSocket }")
      |> String.replace("import {Socket}", "import { Socket }")

    out = PatchAssetsJs.apply(src)
    assert out =~ ~r/import corex from "corex"/
  end

  test "tight and spaced hooks object" do
    a = @phx_18 |> String.replace("hooks: {...colocatedHooks}", "hooks: { ...colocatedHooks }")
    out = PatchAssetsJs.apply(a)
    assert out =~ "...colocatedHooks"
    assert out =~ "...corex"
  end

  test "multiline prettier: trailing comma on spread" do
    src =
      @phx_18
      |> String.replace(
        "hooks: {...colocatedHooks},",
        "hooks: {\n    ...colocatedHooks,\n  },"
      )

    out = PatchAssetsJs.apply(src)
    assert out =~ "...colocatedHooks"
    assert out =~ "...corex"
  end

  test "idempotent" do
    o1 = PatchAssetsJs.apply(@phx_18)
    o2 = PatchAssetsJs.apply(o1)
    assert o1 == o2
  end

  test "regex-only path: legacy formatting (COREX_PATCH_ASSETS_JS_REGEX)" do
    System.put_env("COREX_PATCH_ASSETS_JS_REGEX", "1")
    on_exit(fn -> System.delete_env("COREX_PATCH_ASSETS_JS_REGEX") end)

    out = PatchAssetsJs.apply(@phx_18)
    assert out =~ ~r/\nimport corex from "corex"\n/
    assert out =~ "hooks: {...colocatedHooks, ...corex}"
  end

  test "e2e-style already patched" do
    src =
      String.replace(
        @phx_18,
        "hooks: {...colocatedHooks}",
        "hooks: { ...colocatedHooks, ...corex }",
        global: false
      )

    src = String.replace(src, "import {LiveSocket}", "import { LiveSocket }", global: false)

    src =
      String.replace(src, "import {hooks", "import corex from \"corex\"\nimport {hooks",
        global: false
      )

    out = PatchAssetsJs.apply(src)
    assert out == src
  end
end
