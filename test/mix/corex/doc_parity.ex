defmodule Corex.DocParity do
  @moduledoc false

  @root Path.expand("../../..", __DIR__)
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

  @anatomy_demo_aliases %{
    "minimal" => ["minimal_code", "anatomy_minimal_code"],
    "invalid" => ["invalid_code"],
    "label and indicator" => ["labeled_code", "anatomy_labeled_code"],
    "indeterminate" => ["indeterminate_code"],
    "disabled" => ["disabled_code"],
    "read-only" => ["read_only_code", "readonly_code"],
    "controlled" => ["controlled_code"],
    "with slots" => ["with_indicator_code", "with_slots_code"],
    "custom slots" => ["custom_slots_code", "anatomy_custom_slots_code"],
    "basic" => ["basic_code", "anatomy_basic_code"],
    "basic usage" => ["minimal_code", "anatomy_basic_code", "anatomy_minimal_code"],
    "with indicator" => ["with_indicator_code", "anatomy_indicator_code"],
    "with marks" => ["with_label_code", "custom_slots_code"],
    "title and description" => ["with_title_description_code"],
    "actions in content" => ["actions_in_content_code", "actions_code"],
    "icon only" => ["anatomy_icon_only_code"],
    "with icon" => ["anatomy_with_icon_code", "anatomy_with_icon_code"],
    "fallback" => ["anatomy_fallback_code"],
    "value slot" => ["anatomy_value_code"],
    "pending" => ["anatomy_pending_code", "anatomy_value_code"],
    "trigger only" => ["trigger_only_code", "minimal_code"],
    "multi-line with heredoc" => ["multi_line_heredoc_code", "heredoc_code"],
    "loading from a file" => ["loading_from_file_code", "from_file_code"],
    "with label" => ["anatomy_with_label_code", "with_label_code"],
    "multipart form (controller)" => ["multipart_form_controller_code", "anatomy_multipart_code"],
    "list" => ["basic_code", "anatomy_minimal_code"],
    "nested menu" => ["anatomy_nested_code", "nested_menu_code"],
    "nested menu with custom indicator" => ["nested_menu_code", "anatomy_nested_code"],
    "grouped items" => ["grouped_code", "anatomy_grouped_code"],
    "grouped" => ["grouped_code", "anatomy_grouped_code"],
    "custom item slot" => ["anatomy_extended_code", "extended_code"],
    "textarea (icon slot ignored)" => ["anatomy_textarea_code", "anatomy_text_code"],
    "checkbox, select, radio" => ["anatomy_other_code"],
    "with form field" => ["form_field_code", "anatomy_text_code"],
    "min, max, step" => ["min_max_step_code", "min_max_default_code", "minimal_code"],
    "controlled page" => ["anatomy_controlled_code", "controlled_page_code"],
    "translation" => ["translation_code", "with_translation_code", "layout_translation_code"],
    "custom error" => ["custom_error_code", "invalid_code"],
    "custom" => ["custom_code", "extended_code", "anatomy_extended_code"],
    "custom grouped" => [
      "custom_grouped_code",
      "extended_grouped_code",
      "anatomy_extended_grouped_code"
    ],
    "with callback" => ["with_label_code", "with_callback_code"],
    "custom drawing options" => ["custom_drawing_options_code", "with_presets_code"],
    "with triggers" => ["anatomy_with_triggers_code", "with_triggers_code"],
    "countdown" => ["anatomy_countdown_code", "countdown_code"],
    "interval tick" => ["anatomy_timing_code", "interval_tick_code"],
    "layout flash" => ["layout_flash_code", "flash_code"],
    "flash defaults" => ["flash_defaults_code", "defaults_code"],
    "dual label" => ["dual_label_code", "with_indicator_code"],
    "single selection" => ["anatomy_single_selection_code", "single_selection_code"],
    "with arrow" => ["anatomy_with_arrow_code"],
    "placement" => ["anatomy_placement_code"],
    "compound" => ["compound_code", "anatomy_compound_code"],
    "empty" => ["empty_code", "anatomy_empty_code"],
    "manual slots" => ["manual_slots_code", "anatomy_manual_slots_code"],
    "extended" => ["extended_code", "anatomy_extended_code"],
    "extended grouped" => ["extended_grouped_code", "anatomy_extended_grouped_code"]
  }

  @component_anatomy_overrides %{
    "file_upload_live" => %{
      "minimal" => ["live_anatomy_minimal_code"],
      "with label" => ["live_anatomy_with_label_code"],
      "custom slots" => ["live_anatomy_custom_slots_code"],
      "form with submit" => ["live_form_with_submit_code", "form_with_submit_code"]
    },
    "tree_view" => %{
      "basic" => ["anatomy_minimal_code"],
      "with label" => ["anatomy_with_label_code"],
      "with indicator" => ["anatomy_with_indicator_code"],
      "custom slots" => ["anatomy_custom_slots_code"],
      "compound" => ["anatomy_compound_code"]
    },
    "layout_heading" => %{
      "basic" => ["basic_code"],
      "title and subtitle only" => ["title_and_subtitle_code"],
      "heading tags" => ["heading_tags_code"]
    },
    "angle_slider" => %{
      "basic" => ["minimal_code"],
      "with marks" => ["with_label_code"]
    },
    "color_picker" => %{"basic" => ["minimal_code"]},
    "editable" => %{"basic" => ["minimal_code"]},
    "pin_input" => %{"basic" => ["minimal_code"]},
    "native_input" => %{
      "basic" => ["anatomy_basic_code"],
      "with icon" => ["anatomy_with_icon_code"],
      "checkbox, select, radio" => ["anatomy_other_code"]
    },
    "clipboard" => %{"trigger only" => ["trigger_only_code"]},
    "listbox" => %{"with indicator" => ["anatomy_with_indicator_code"]},
    "radio_group" => %{"with indicator" => ["indicator_code"]},
    "password_input" => %{"custom error" => ["invalid_code"]},
    "collapsible" => %{
      "minimal" => ["anatomy_basic_code"]
    },
    "code" => %{
      "basic usage" => ["basic_usage_code"],
      "multi-line with heredoc" => ["multiline_code"],
      "loading from a file" => ["from_file_code"]
    },
    "toast" => %{
      "layout flash" => ["layout_flash_code"],
      "flash defaults" => ["flash_defaults_code"]
    },
    "toggle_group" => %{
      "single selection" => ["anatomy_single_selection_code"]
    },
    "tabs" => %{
      "custom" => ["anatomy_custom_code"]
    },
    "select" => %{
      "custom" => ["extended_code"],
      "custom grouped" => ["extended_grouped_code"]
    },
    "number_input" => %{
      "minimal" => ["anatomy_minimal_quantity_code"]
    },
    "signature_pad" => %{
      "custom drawing options" => ["with_presets_code"]
    }
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
    do: Enum.reject(results, &(&1.status in [:pass, :missing_demo, :missing_moduledoc]))

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
    |> String.replace(~r/ >/u, ">")
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
    case read_within(@components_dir, component_source_file(slug)) do
      {:ok, source} -> extract_moduledoc(source)
      _ -> nil
    end
  end

  defp component_source_file("layout_heading"), do: "layout/heading.ex"
  defp component_source_file("list"), do: "typography/list_box.ex"
  defp component_source_file("form"), do: "typography/form.ex"
  defp component_source_file("badge"), do: "badge.ex"
  defp component_source_file(slug) when slug in ~w(box stack row grid container spacer divider),
    do: "layout/#{slug}.ex"

  defp component_source_file(slug) when slug in ~w(h1 h2 h3 h4 p lead small kbd blockquote),
    do: "typography/#{slug}.ex"

  defp component_source_file(slug), do: "#{slug}.ex"

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
    if valid_component_path?(name) do
      path = Path.join(base, name)
      safe_read(path, base)
    else
      {:error, :invalid_path}
    end
  end

  defp valid_component_path?(name),
    do: name =~ ~r/^[a-z][a-z0-9_.\/-]*\.ex$/ and name not in ["..", "."] and not String.contains?(name, "..")

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
      {nil, _} ->
        [anatomy_missing_source(slug, :missing_moduledoc)]

      {_, nil} ->
        [anatomy_missing_source(slug, :missing_demo)]

      {moduledoc, demo_source} ->
        moduledoc
        |> sections_under("## Anatomy")
        |> Enum.flat_map(&anatomy_heading_results(slug, demo_source, &1))
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
    demo_fns = anatomy_demo_fns(slug, heading)

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

  defp anatomy_demo_fns(slug, heading) do
    key = String.downcase(heading)

    case Map.get(@component_anatomy_overrides, slug) do
      %{^key => fns} -> fns
      _ -> Map.get(@anatomy_demo_aliases, key, ["#{slugify_heading(key)}_code"])
    end
  end

  defp slugify_heading(heading) do
    heading
    |> String.replace(~r/[^a-z0-9]+/, "_")
    |> String.trim("_")
  end

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
      ~r/def #{Regex.escape(name)}\s+do\s+~S"""\s*(.*?)\s*"""/s,
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

  defp ellipsis?(text), do: String.contains?(text, "…") or String.contains?(text, "...")
end
