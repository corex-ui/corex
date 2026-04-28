defmodule Corex.Install.PatchAssetsJsTest do
  use ExUnit.Case, async: false

  alias Mix.Corex.Install.Assets

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
    out = Assets.patch_app_js_source(@phx_18)
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

    out = Assets.patch_app_js_source(src)
    assert out =~ ~r/import corex from "corex"/
  end

  test "tight and spaced hooks object" do
    a = @phx_18 |> String.replace("hooks: {...colocatedHooks}", "hooks: { ...colocatedHooks }")
    out = Assets.patch_app_js_source(a)
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

    out = Assets.patch_app_js_source(src)
    assert out =~ "...colocatedHooks"
    assert out =~ "...corex"
  end

  test "idempotent" do
    o1 = Assets.patch_app_js_source(@phx_18)
    o2 = Assets.patch_app_js_source(o1)
    assert o1 == o2
  end

  test "import_line option: relative path to corex.mjs" do
    line = "import corex from \"../../deps/corex/priv/static/corex.mjs\"\n"
    out = Assets.patch_app_js_source(@phx_18, import_line: line)
    assert out =~ "import corex from \"../../deps/corex/priv/static/corex.mjs\""
    assert out =~ "...corex"
  end

  test "does not replace import when import corex from already present" do
    line = "import corex from \"../../other/corex.mjs\"\n"

    src =
      String.replace(@phx_18, "import {hooks", "import corex from \"corex\"\nimport {hooks",
        global: false
      )

    out = Assets.patch_app_js_source(src, import_line: line)
    assert out =~ "import corex from \"corex\""
    refute out =~ "other/corex.mjs"
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

    out = Assets.patch_app_js_source(src)
    assert out == src
  end
end
