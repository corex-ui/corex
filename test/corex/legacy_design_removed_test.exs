defmodule Corex.LegacyDesignRemovedTest do
  use ExUnit.Case, async: true

  @repo_root File.cwd!()
  @legacy_paths [
    Path.join(@repo_root, "priv/design"),
    Path.join(@repo_root, "e2e/assets/corex"),
    Path.join(@repo_root, "e2e/priv/design/reports")
  ]

  @stale_patterns [
    ~r/assets\/corex\/components\//,
    ~r/@import\s+"\.\.\/corex\//,
    ~r/mix corex\.design[^.]/,
    ~r/mix corex\.design\.report/,
    ~r/priv\/design\//
  ]

  test "legacy design trees are removed" do
    for path <- @legacy_paths do
      refute File.exists?(path),
             "#{path} must not exist; use :corex_design compiler and assets/css/corex.tailwind.css"
    end
  end

  test "guides do not reference priv/design or assets/corex vendoring" do
    guides_dir = Path.join(@repo_root, "guides")

    for path <- Path.wildcard(Path.join(guides_dir, "**/*.md")) do
      content = File.read!(path)

      refute content =~ "priv/design",
             "#{path} must not reference removed priv/design path"

      refute content =~ "../corex/components/",
             "#{path} must not reference per-component assets/corex imports"
    end
  end

  test "usage-rules do not document removed copy-task workflow" do
    rules_dir = Path.join(@repo_root, "usage-rules")

    for path <- Path.wildcard(Path.join(rules_dir, "**/*.{md,mdc}")) do
      content = File.read!(path)

      for pattern <- @stale_patterns do
        refute Regex.match?(pattern, content),
               "#{path} must not match stale pattern #{inspect(pattern)}"
      end
    end
  end
end
