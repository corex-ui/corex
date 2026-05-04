defmodule Corex.New.BundledDesignTest do
  use ExUnit.Case, async: true

  alias Corex.New.Generate

  test "bundled design snapshot contains corex and designex trees" do
    root = Generate.bundled_design_root()

    assert File.dir?(Path.join(root, "corex")),
           "run `mix assets.build` from the corex repo root to populate installer/templates/corex_design"

    assert File.dir?(Path.join(root, "design")),
           "expected designex token tree at #{Path.join(root, "design")}"
  end
end
