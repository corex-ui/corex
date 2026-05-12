defmodule Corex.New.BundledDesignTest do
  use ExUnit.Case, async: true

  alias Corex.New.Generate

  test "bundled design snapshot contains corex and designex trees" do
    root = Generate.bundled_design_root()

    assert File.dir?(Path.join(root, "corex")),
           "run `mix assets.build` from the corex repo root to populate installer/priv/corex_design"

    assert File.dir?(Path.join(root, "design")),
           "expected designex token tree at #{Path.join(root, "design")}"

    assert String.ends_with?(root, "priv/corex_design"),
           "bundled root should resolve to installer/priv/corex_design (archive or repo checkout)"
  end
end
