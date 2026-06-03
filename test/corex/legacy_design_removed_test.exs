defmodule Corex.LegacyDesignRemovedTest do
  use ExUnit.Case, async: true

  @repo_root File.cwd!()
  @legacy_design Path.join(@repo_root, "priv/design")

  test "priv/design legacy tree is removed" do
    refute File.exists?(@legacy_design),
           "priv/design must not exist; use design/lib/corex/design/ and the :corex_design compiler"
  end

  test "guides do not reference priv/design" do
    guides_dir = Path.join(@repo_root, "guides")

    for path <- Path.wildcard(Path.join(guides_dir, "**/*.md")) do
      refute File.read!(path) =~ "priv/design",
             "#{path} must not reference removed priv/design path"
    end
  end
end
