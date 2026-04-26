defmodule Corex.Install.PatchAssetsJsIntegrationTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.PatchAssetsJs

  @unpatched ~s"""
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

  test "patches import corex and hooks spread when missing" do
    p = PatchAssetsJs.apply(@unpatched)
    assert p =~ "import corex from \"corex\""
    assert p =~ "...colocatedHooks"
    assert p =~ "...corex"

    assert PatchAssetsJs.apply(p) == p
  end
end
