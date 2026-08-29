defmodule Mix.Tasks.Corex.Admin.Doctor do
  @shortdoc "Reports admin chrome you have ejected that has fallen behind"

  @moduledoc """
  Compares the blocks you copied with `mix corex.admin.gen.admin` against the
  installed package.

      $ mix corex.admin.doctor

  For each ejected block it reports one of:

    * **current** — the package source is unchanged since you copied it
    * **behind** — the package source has changed; diff it and decide
    * **unknown** — the package source could not be read

  This does not merge anything. Copied markup cannot be merged automatically,
  which is exactly why the copy is the last resort. What it does is turn a
  silent divergence into a listed one.

  Exits non-zero when any block is behind, so a CI job can fail on unreviewed
  drift.

  See the [eject](eject.html) guide.
  """

  use Mix.Task

  alias CorexAdmin.Eject

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")

    manifest = Eject.read_manifest()

    if manifest == %{} do
      Mix.shell().info("""
      Nothing ejected. All admin chrome comes from the package, so there is
      nothing to fall behind.
      """)
    else
      report(Eject.audit(manifest))
    end
  end

  defp report(results) do
    Enum.each(results, fn {key, result} -> Mix.shell().info(line(key, result)) end)

    behind = Enum.count(results, fn {_key, result} -> match?({:stale, _, _}, result) end)

    Mix.shell().info("""

    #{length(results)} ejected block(s), #{behind} behind.
    """)

    if behind > 0 do
      Mix.shell().info("""
      Diff each block against the package source to see what changed:

          diff lib/*/admin/components/<block>.ex deps/corex_admin/lib/corex_admin/ui/<block>.ex

      Re-running `mix corex.admin.gen.admin` overwrites your copy, so diff first.
      """)

      exit({:shutdown, 1})
    end
  end

  defp line(key, :current), do: [:green, "  current  ", :reset, key]

  defp line(key, {:stale, from, to}) do
    [:yellow, "  behind   ", :reset, "#{key} (copied from #{from}, installed #{to})"]
  end

  defp line(key, {:unknown, reason}) do
    [:red, "  unknown  ", :reset, "#{key} — #{reason}"]
  end
end
