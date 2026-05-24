defmodule E2eWeb.FormDemoContractTest do
  use ExUnit.Case, async: true

  @demo_dir Path.expand("../../lib/e2e_web/demos", __DIR__)

  @form_doc_function ~r/^  def (form_ecto|form_doc_|form_phoenix_|form_ecto_|form_changeset_|form_validate_)/

  @forbidden_patterns [
    {"E2eWeb.Demos.", "E2eWeb.Demos."},
    {"E2e.Form.", "E2e.Form."},
    {"assign(:form_ecto", "assign(:form_ecto"},
    {"assign(:phoenix_heex", "assign(:phoenix_heex"},
    {"FormDemoDocs", "FormDemoDocs"},
    {~r/assign_\w+_form_docs/, "assign_*_form_docs"}
  ]

  test "demo modules do not use action=\"//\" or stricter wording" do
    demo_files = demo_files()

    violations =
      for file <- demo_files,
          path = Path.join(@demo_dir, file),
          contents = File.read!(path),
          String.contains?(contents, ["action=\"//", "stricter"]) do
        reasons =
          []
          |> maybe_add(contents, "action=\"//", "action=\"//\"")
          |> maybe_add(contents, "stricter", ~s("stricter"))

        {file, reasons}
      end
      |> Enum.reject(fn {_file, reasons} -> reasons == [] end)

    assert violations == [],
           "form demo contract violations:\n#{format_violations(violations)}"
  end

  @forbidden_preview_aliases [
    {~r/def form_preview_controller_phoenix\(assigns\), do: form_preview_controller_(changeset|validate|basic)/,
     "form_preview_controller_phoenix aliased to changeset/validate/basic"},
    {~r/def form_preview_live_phoenix\(assigns\), do: form_preview_live_(changeset|validate|basic)/,
     "form_preview_live_phoenix aliased to changeset/validate/basic"}
  ]

  test "form doc snippet functions do not contain e2e-only references" do
    violations =
      demo_files()
      |> Enum.flat_map(&form_doc_violations/1)

    assert violations == [],
           "form doc snippet violations:\n#{Enum.join(violations, "\n")}"
  end

  test "phoenix preview helpers are not aliased to changeset or validate previews" do
    violations =
      demo_files()
      |> Enum.flat_map(fn file ->
        path = Path.join(@demo_dir, file)
        contents = File.read!(path)

        for {pattern, label} <- @forbidden_preview_aliases,
            Regex.match?(pattern, contents) do
          "#{file}: #{label}"
        end
      end)

    assert violations == [],
           "phoenix preview alias violations:\n#{Enum.join(violations, "\n")}"
  end

  defp demo_files do
    @demo_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, "_demo.ex"))
  end

  defp form_doc_violations(file) do
    path = Path.join(@demo_dir, file)
    contents = File.read!(path)

  for {line, snippet} <- form_doc_snippets(contents),
      {pattern, label} <- @forbidden_patterns,
      matches?(snippet, pattern) do
      "#{file}:#{line}: #{label} in form doc snippet"
    end
  end

  defp form_doc_snippets(contents) do
    contents
    |> String.split("\n")
    |> Enum.with_index(1)
    |> Enum.filter(fn {line, _index} -> Regex.match?(@form_doc_function, line) end)
    |> Enum.map(fn {line, index} ->
      {index, extract_function_body(contents, line)}
    end)
  end

  defp extract_function_body(contents, def_line) do
    lines = String.split(contents, "\n")

    start_index =
      lines
      |> Enum.find_index(&(&1 == def_line))
      |> Kernel.+(0)

    lines
    |> Enum.drop(start_index)
    |> Enum.take_while(fn line ->
      line == def_line or not String.match?(line, ~r/^  def /)
    end)
    |> Enum.join("\n")
  end

  defp matches?(snippet, pattern) when is_binary(pattern), do: String.contains?(snippet, pattern)
  defp matches?(snippet, pattern), do: Regex.match?(pattern, snippet)

  defp maybe_add(reasons, contents, needle, label) do
    if String.contains?(contents, needle) do
      reasons ++ [label]
    else
      reasons
    end
  end

  defp format_violations(violations) do
    violations
    |> Enum.flat_map(fn {_file, reasons} -> reasons end)
    |> Enum.join("\n")
  end
end
