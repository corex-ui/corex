defmodule Corex.DocParity do
  @moduledoc false

  @root Path.expand("../..", __DIR__)
  @components_dir Path.join(@root, "lib/components")
  @demos_dir Path.join(@root, "e2e/lib/e2e_web/demos")

  @type status :: :pass | :drift | :missing_demo | :missing_moduledoc | :ellipsis

  @type result :: %{
          component: String.t(),
          section: String.t(),
          demo_fn: String.t(),
          status: status(),
          detail: String.t() | nil
        }

  @form_demo_pairs [
    {"phoenix form (changeset)", "heex",
     ["form_doc_controller_phoenix_heex", "form_phoenix_heex"]},
    {"phoenix form (changeset)", "elixir",
     ["form_doc_controller_phoenix_elixir", "form_phoenix_elixir"]},
    {"ecto changeset (validation)", "heex",
     ["form_doc_controller_ecto_heex", "form_ecto_heex", "form_validate_heex"]},
    {"ecto changeset (validation)", "elixir",
     ["form_doc_controller_ecto_elixir", "form_ecto_elixir", "form_validate_elixir"]},
    {"native form (plain html)", "heex", ["form_native_heex", "form_doc_controller_native_heex"]},
    {"native form (plain html)", "elixir",
     ["form_native_elixir", "form_doc_controller_native_elixir"]}
  ]

  @doc """
  Returns parity results for all registered component/demo pairs.
  """
  @spec run(keyword()) :: [result()]
  def run(opts \\ []) do
    sections = Keyword.get(opts, :sections, [:anatomy, :form])
    components = Keyword.get(opts, :components, component_slugs())

    components
    |> Enum.flat_map(fn slug ->
      moduledoc = moduledoc_for(slug)
      demo_source = demo_source_for(slug)

      anatomy_results =
        if :anatomy in sections do
          anatomy_pairs(slug, moduledoc, demo_source)
        else
          []
        end

      form_results =
        if :form in sections do
          form_pairs(slug, moduledoc, demo_source)
        else
          []
        end

      anatomy_results ++ form_results
    end)
  end

  @spec failures([result()]) :: [result()]
  def failures(results),
    do: Enum.reject(results, &(&1.status in [:pass, :missing_moduledoc]))

  @doc """
  Ensures Style CSS snippets in component docs prefer `@import \"../corex/corex.css\"`
  and do not teach the obsolete `tokens/themes/neo/light.css` path.
  """
  @spec css_style_results([String.t()] | nil) :: [result()]
  def css_style_results(components \\ nil) do
    (components || component_slugs())
    |> Enum.map(&css_style_result/1)
  end

  defp css_style_result(slug) do
    case moduledoc_for(slug) do
      nil ->
        %{
          component: slug,
          section: "style / css",
          demo_fn: "-",
          status: :missing_moduledoc,
          detail: "missing source"
        }

      doc ->
        cond do
          String.contains?(doc, "tokens/themes/neo/light.css") ->
            %{
              component: slug,
              section: "style / css",
              demo_fn: "-",
              status: :drift,
              detail: "obsolete tokens/themes/neo/light.css path"
            }

          String.contains?(doc, ~s(@import "../corex/main.css")) and
              not String.contains?(doc, ~s(@import "../corex/corex.css")) ->
            %{
              component: slug,
              section: "style / css",
              demo_fn: "-",
              status: :drift,
              detail: "Style docs still teach main.css without corex.css"
            }

          true ->
            %{
              component: slug,
              section: "style / css",
              demo_fn: "-",
              status: :pass,
              detail: nil
            }
        end
    end
  end

  @spec report([result()]) :: String.t()
  def report(results) do
    failures = failures(results)

    summary =
      Enum.frequencies_by(results, & &1.status)
      |> Enum.map_join("\n", fn {status, count} -> "  #{status}: #{count}" end)

    body =
      if failures == [] do
        "All #{length(results)} parity checks passed."
      else
        failures
        |> Enum.map_join("\n\n", fn r ->
          """
          - #{r.component} / #{r.section} (#{r.demo_fn}): #{r.status}
            #{r.detail}
          """
        end)
      end

    """
    Doc parity report (#{length(results)} checks)
    #{summary}

    #{body}
    """
  end

  @spec normalize(String.t()) :: String.t()
  def normalize(text) when is_binary(text) do
    text
    |> String.replace(~r/\sid="[^"]*"/, "")
    |> String.replace(~r/\sid=\{[^}]+\}/, "")
    |> String.replace(~r/action=\{~p"([^"]+)"\}/, ~S|action="/path"|)
    |> String.replace(~r/action="[^"]*"/, ~S|action="/path"|)
    |> String.replace(~r/to: ~p"([^"]+)"/, ~S|to: "/path"|)
    |> String.replace(~r/to: "[^"]*"/, ~S|to: "/path"|)
    |> String.replace(~r/\bE2eWeb\.Demos\.[A-Za-z]+\.[a-z_!?]+\(\)/, "DEMO_HELPER()")
    |> String.replace(~r/\bE2e\.[A-Za-z.]+/, "MyApp.Module")
    |> String.replace(~r/@phoenix_form/, "@form")
    |> String.replace(~r/@ecto_form/, "@form")
    |> String.replace(~r/:let=\{f\}/, "")
    |> String.replace(~r/field=\{f\[/, "field={@form[")
    |> String.replace(~r/upload=\{@uploads\.[^}]+\}/, "upload={@uploads.FIELD}")
    |> String.replace(~r/@uploads\.[a-z_]+/, "@uploads.FIELD")
    |> String.replace(~r/field=\{:[a-z_]+\}/, "field={:FIELD}")
    |> String.replace("…", "")
    |> String.replace("...", "")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end

  @spec compare(String.t(), String.t()) :: :pass | :drift
  def compare(moduledoc_snippet, demo_snippet) do
    if normalize(moduledoc_snippet) == normalize(demo_snippet) do
      :pass
    else
      :drift
    end
  end

  @spec component_slugs() :: [String.t()]
  def component_slugs do
    @components_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.map(&String.trim_trailing(&1, ".ex"))
    |> Enum.reject(&(&1 in ["heroicon", "hidden_input", "image"]))
    |> Enum.sort()
  end

  defp moduledoc_for(slug) do
    case read_within(@components_dir, "#{slug}.ex") do
      {:ok, source} -> doc_with_anatomy(source)
      _ -> nil
    end
  end

  defp doc_with_anatomy(source) do
    moduledoc = extract_moduledoc(source)

    if is_binary(moduledoc) and String.contains?(moduledoc, "## Anatomy") do
      moduledoc
    else
      case extract_component_doc(source) do
        doc when is_binary(doc) -> doc
        _ -> moduledoc
      end
    end
  end

  defp demo_source_for(slug) do
    case read_within(@demos_dir, demo_filename(slug)) do
      {:ok, source} -> source
      _ -> nil
    end
  end

  defp demo_filename("signature_pad"), do: "signature_demo.ex"
  defp demo_filename("layout_heading"), do: "layout_heading_demo.ex"
  defp demo_filename("file_upload_live"), do: "file_upload_demo.ex"
  defp demo_filename(slug), do: "#{slug}_demo.ex"

  defp read_within(base, name) do
    if valid_basename?(name) do
      path = Path.join(base, name)
      safe_read(path, base)
    else
      {:error, :invalid_path}
    end
  end

  defp valid_basename?(name), do: name =~ ~r/^[a-z][a-z0-9_.-]*$/

  defp safe_read(path, base) do
    expanded_base = Path.expand(base) <> "/"
    expanded_path = Path.expand(path)

    if String.starts_with?(expanded_path, expanded_base) do
      File.read(path)
    else
      {:error, :invalid_path}
    end
  end

  defp anatomy_pairs(slug, moduledoc, demo_source) do
    case {moduledoc, demo_source} do
      {nil, _} -> [anatomy_missing_source(slug, :missing_moduledoc)]
      {_, nil} -> [anatomy_missing_source(slug, :missing_demo)]
      {moduledoc, demo_source} -> anatomy_pairs_from_docs(slug, moduledoc, demo_source)
    end
  end

  defp anatomy_pairs_from_docs(slug, moduledoc, demo_source) do
    case anatomy_heading_pairs(slug, moduledoc) do
      [] -> anatomy_root_results(slug, moduledoc, demo_source)
      pairs -> Enum.flat_map(pairs, &anatomy_heading_results(slug, demo_source, &1))
    end
  end

  defp anatomy_root_results(slug, moduledoc, demo_source) do
    case root_anatomy_heex(moduledoc) do
      nil -> []
      heex -> anatomy_heex_results(slug, "minimal", heex, demo_source)
    end
  end

  defp anatomy_heading_pairs(slug, moduledoc) do
    anatomy_section_names(slug)
    |> Enum.flat_map(&sections_under(moduledoc, &1))
  end

  defp anatomy_section_names("carousel"), do: ["## Anatomy", "## Items"]
  defp anatomy_section_names(_slug), do: ["## Anatomy"]

  defp root_anatomy_heex(moduledoc) do
    with [_, body] <- Regex.run(~r/^\s*## Anatomy\s*\n(.*?)(?=\n\s*## |\z)/ms, moduledoc),
         [_, snippet] <- Regex.run(~r/```heex\s*\n(.*?)```/s, body) do
      String.trim(snippet)
    else
      _ -> nil
    end
  end

  defp anatomy_missing_source(slug, status) do
    %{
      component: slug,
      section: "anatomy",
      demo_fn: "-",
      status: status,
      detail: "missing source"
    }
  end

  defp anatomy_heading_results(slug, demo_source, {heading, blocks}) do
    case Map.get(blocks, "heex") do
      nil -> []
      heex -> anatomy_heex_results(slug, heading, heex, demo_source)
    end
  end

  defp anatomy_heex_results(slug, heading, heex, demo_source) do
    demo_fns = anatomy_demo_fns(slug, heading, demo_source)

    case pick_demo_snippet(demo_source, demo_fns) do
      nil ->
        [anatomy_missing_demo(slug, heading, demo_fns)]

      {demo_fn, demo_snippet} ->
        [anatomy_compare_result(slug, heading, demo_fn, heex, demo_snippet)]
    end
  end

  defp anatomy_missing_demo(slug, heading, demo_fns) do
    %{
      component: slug,
      section: "anatomy / #{heading}",
      demo_fn: Enum.join(demo_fns, "|"),
      status: :missing_demo,
      detail: "no matching demo function"
    }
  end

  defp anatomy_compare_result(slug, heading, demo_fn, heex, demo_snippet) do
    status = compare(heex, demo_snippet) |> maybe_ellipsis_status(heex, demo_snippet)

    %{
      component: slug,
      section: "anatomy / #{heading}",
      demo_fn: demo_fn,
      status: status,
      detail: if(status == :drift, do: "normalized snippets differ", else: nil)
    }
  end

  defp maybe_ellipsis_status(status, left, right) do
    if ellipsis?(left) or ellipsis?(right), do: :ellipsis, else: status
  end

  defp form_pairs(slug, moduledoc, demo_source) do
    if moduledoc && demo_source do
      moduledoc
      |> sections_under("## Form")
      |> Enum.flat_map(&form_section_results(slug, demo_source, &1))
    else
      []
    end
  end

  defp form_section_results(slug, demo_source, {heading, blocks}) do
    Enum.flat_map(@form_demo_pairs, &form_pair_results(slug, demo_source, heading, blocks, &1))
  end

  defp form_pair_results(slug, demo_source, heading, blocks, {pair_heading, lang, demo_fn_list}) do
    if String.downcase(heading) != pair_heading do
      []
    else
      case Map.get(blocks, lang) do
        nil -> []
        snippet -> [form_snippet_result(slug, heading, lang, snippet, demo_source, demo_fn_list)]
      end
    end
  end

  defp form_snippet_result(slug, heading, lang, snippet, demo_source, demo_fn_list) do
    case pick_demo_snippet(demo_source, demo_fn_list) do
      nil ->
        %{
          component: slug,
          section: "form / #{heading} / #{lang}",
          demo_fn: Enum.join(demo_fn_list, "|"),
          status: :missing_demo,
          detail: "no matching demo function"
        }

      {demo_fn, demo_snippet} ->
        status = compare(snippet, demo_snippet) |> maybe_ellipsis_status(snippet, demo_snippet)

        %{
          component: slug,
          section: "form / #{heading} / #{lang}",
          demo_fn: demo_fn,
          status: status,
          detail: if(status == :drift, do: "normalized snippets differ", else: nil)
        }
    end
  end

  defp sections_under(source, section_heading) do
    case Regex.run(~r/^\s*#{Regex.escape(section_heading)}\s*\n(.*?)(?=\n\s*## |\z)/ms, source) do
      [_, body] -> body |> split_tab_sections() |> Enum.map(&section_blocks/1)
      _ -> []
    end
  end

  defp section_blocks({heading, content}), do: {heading, code_blocks(content)}

  defp code_blocks(content) do
    [
      {"heex", ~r/```heex\s*\n(.*?)```/s},
      {"elixir", ~r/```elixir\s*\n(.*?)```/s}
    ]
    |> Enum.reduce(%{}, &code_block_reduce(&1, &2, content))
  end

  defp code_block_reduce({lang, regex}, acc, content) do
    case Regex.run(regex, content) do
      [_, snippet] -> Map.put(acc, lang, String.trim(snippet))
      _ -> acc
    end
  end

  defp split_tab_sections(body) do
    parts =
      Regex.split(~r/\n\s*### /, body)
      |> Enum.reject(&(String.trim(&1) == ""))

    parts
    |> Enum.map(fn part ->
      [heading_line | rest] = String.split(part, "\n", parts: 2)
      heading = heading_line |> String.trim() |> String.trim_leading("#") |> String.trim()
      content = rest |> List.first() |> Kernel.||("")
      {heading, content}
    end)
    |> Enum.reject(fn {heading, _} ->
      heading == "" or
        String.starts_with?(heading, "<!--") or
        String.contains?(heading, "```") or
        String.starts_with?(heading, "|")
    end)
    |> Enum.map(fn {heading, content} -> {String.downcase(heading), content} end)
  end

  defp anatomy_demo_fns(slug, heading, demo_source) do
    case demo_parity_fns(demo_source, heading) do
      [_ | _] = fns ->
        fns

      [] ->
        case Corex.DocParity.Markers.anatomy(slug, heading) do
          {:ok, fns} -> fns
          :error -> []
        end
    end
  end

  defp demo_parity_fns(source, heading) when is_binary(source) do
    key = String.downcase(heading)

    ~r/#\s*@parity\s+anatomy:\s+"([^"]+)"\s*\ndef\s+([a-z0-9_]+)/
    |> Regex.scan(source)
    |> Enum.filter(fn [_, h, _] -> String.downcase(h) == key end)
    |> Enum.map(fn [_, _, name] -> name end)
  end

  defp demo_parity_fns(_, _), do: []

  defp pick_demo_snippet(demo_source, fn_names) do
    Enum.find_value(fn_names, fn name ->
      case extract_demo_function(demo_source, name) do
        nil -> nil
        snippet -> {name, snippet}
      end
    end)
  end

  defp extract_demo_function(source, name) do
    patterns = [
      ~r/def #{Regex.escape(name)}\s+do\s+~S'''\s*(.*?)\s*'''/s,
      ~r/def #{Regex.escape(name)}\s+do\s+~S"""\s*(.*?)\s*"""/s,
      ~r/def #{Regex.escape(name)}\s+do\s+'''\s*(.*?)\s*'''/s,
      ~r/def #{Regex.escape(name)}\s+do\s+"""\s*(.*?)\s*"""/s
    ]

    Enum.find_value(patterns, fn regex ->
      case Regex.run(regex, source) do
        [_, body] -> String.trim(body)
        _ -> nil
      end
    end)
  end

  defp extract_moduledoc(source) do
    case Regex.run(~r/@moduledoc\s+~S'''(.*?)'''/s, source) do
      [_, doc] ->
        doc

      _ ->
        case Regex.run(~r/@moduledoc\s+"""(.*?)"""/s, source) do
          [_, doc] -> doc
          _ -> nil
        end
    end
  end

  defp extract_component_doc(source) do
    [
      ~r/@doc\s+~S'''(.*?)'''/s,
      ~r/@doc\s+"""(.*?)"""/s
    ]
    |> Enum.flat_map(&Regex.scan(&1, source))
    |> Enum.find_value(&anatomy_doc_body/1)
  end

  defp anatomy_doc_body([_, doc]) do
    if String.contains?(doc, "## Anatomy"), do: doc
  end

  defp anatomy_doc_body(_), do: nil

  defp ellipsis?(text), do: String.contains?(text, "…") or String.contains?(text, "...")
end
