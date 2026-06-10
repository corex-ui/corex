defmodule Mix.Tasks.Corex.Design.Report do
  use Mix.Task

  @shortdoc "Writes WCAG contrast reports for design tokens"

  @moduledoc """
  Generates design-token contrast evidence from resolved themes.

  ## Options

    * `--format` — `json`, `md`, or `all` (default `all`); repeatable
    * `--output-dir` — destination directory (default `priv/static/design/reports`)
    * `--theme` — limit to theme id(s); repeatable
    * `--mode` — `light` and/or `dark`; repeatable
    * `--target` — override thresholds: `aa`, `aa_large`, or `aaa` (omit to use each theme/mode level)
    * `--strict` — exit 1 when **text** contrast pairs fail (for CI); chrome borders are not strict failures

  ## Examples

      mix corex.design.report
      mix corex.design.report --format json --theme neo --mode dark
      mix corex.design.report --strict
      mix corex.design.report --strict --target aaa
  """

  @requirements ["app.start"]

  alias Corex.Design.Accessibility.ContrastReport
  alias Corex.Design.Accessibility.Report.JSON
  alias Corex.Design.Accessibility.Report.Markdown

  @impl true
  def run(argv) do
    unless Corex.Design.configured?() do
      Mix.raise("config :corex_design is required to run mix corex.design.report")
    end

    {opts, _} =
      OptionParser.parse!(argv,
        strict: [
          format: :keep,
          output_dir: :string,
          theme: :keep,
          mode: :keep,
          target: :string,
          strict: :boolean
        ]
      )

    formats = formats(opts)
    output_dir = Keyword.get(opts, :output_dir, "priv/static/design/reports")

    report_opts =
      theme_mode_opts(opts)
      |> maybe_put_target(Keyword.get(opts, :target))

    reports = ContrastReport.run(report_opts)

    for report <- reports do
      base = Path.join(output_dir, "#{report.theme}-#{report.mode}-contrast")

      if "json" in formats do
        JSON.write!(report, base <> ".json")
        Mix.shell().info("Wrote #{base}.json")
      end

      if "md" in formats do
        Markdown.write!(report, base <> ".md")
        Mix.shell().info("Wrote #{base}.md")
      end
    end

    if Keyword.get(opts, :strict, false) and ContrastReport.strict_fail?(reports) do
      failing =
        reports
        |> Enum.filter(fn r -> r.pairs_failing > 0 end)
        |> Enum.map_join(", ", fn r -> "#{r.theme}/#{r.mode} (#{r.target})" end)

      Mix.raise("contrast report has pairs below threshold: #{failing}")
    end

    :ok
  end

  defp formats(opts) do
    case Keyword.get_values(opts, :format) do
      [] ->
        ["json", "md"]

      ["all"] ->
        ["json", "md"]

      list ->
        Enum.flat_map(list, &String.split(&1, ",")) |> Enum.map(&String.trim/1) |> Enum.uniq()
    end
  end

  defp maybe_put_target(opts, nil), do: opts
  defp maybe_put_target(opts, target), do: Keyword.put(opts, :target, target)

  defp theme_mode_opts(opts) do
    [theme: Keyword.get_values(opts, :theme), mode: Keyword.get_values(opts, :mode)]
    |> Enum.flat_map(fn
      {_, []} -> []
      {k, v} -> [{k, v}]
    end)
  end
end
