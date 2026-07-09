defmodule Corex.Design.Bundle.CssFilter do
  @moduledoc false

  alias Corex.Design.Filter

  @semantic_color_line ~r/^\s*(--[\w-]+):\s*--value\(--color-/m
  @semantic_modifier_roles ~w(accent brand alert info success)

  def apply!(output_dir, component_ids) do
    semantics = Filter.semantics()
    variants = Filter.variants()

    for id <- component_ids do
      path = Path.join([output_dir, "components", "#{id}.css"])

      if File.exists?(path) do
        path
        |> File.read!()
        |> apply_semantics(semantics)
        |> apply_variants(variants)
        |> then(&File.write!(path, &1))
      end
    end

    :ok
  end

  def apply_semantics(css, roles) do
    if semantics_filtered?(roles) do
      css
      |> split_wildcard_semantic_utilities(roles)
    else
      css
    end
  end

  def apply_variants(css, variants) do
    if variants_filtered?(variants) do
      allowed = MapSet.new(variants)

      css
      |> remove_variant_utilities(allowed)
      |> simplify_variant_not_selectors(allowed)
    else
      css
      |> remove_variant_subtle_utility()
    end
  end

  defp semantics_filtered?(roles) do
    default = Enum.map(Filter.default_semantics(), &Atom.to_string/1) |> Enum.sort()
    Enum.sort(roles) != default
  end

  defp variants_filtered?(nil), do: false
  defp variants_filtered?(variants) when is_list(variants), do: true

  defp split_wildcard_semantic_utilities(css, roles) do
    modifier_roles =
      roles
      |> Enum.map(&to_string/1)
      |> Enum.filter(&(&1 in @semantic_modifier_roles))

    Regex.scan(~r/@utility\s+([\w-]+)--\*\s*\{/s, css)
    |> Enum.reduce(css, fn [full, host_utility], acc ->
      block = extract_block(acc, full)

      if block && semantic_lines?(block.body) do
        explicit =
          Enum.map_join(modifier_roles, "\n\n", fn role ->
            build_semantic_utility(host_utility, role, block.body)
          end)

        trimmed_body = strip_semantic_lines(block.body)

        updated_block =
          if String.trim(trimmed_body) == "" do
            ""
          else
            "@utility #{host_utility}--* {" <> trimmed_body <> "}"
          end

        acc
        |> String.replace(block.full, updated_block, global: false)
        |> then(fn css2 -> if explicit == "", do: css2, else: css2 <> "\n\n" <> explicit end)
      else
        acc
      end
    end)
  end

  defp semantic_lines?(body) do
    String.match?(body, @semantic_color_line)
  end

  defp strip_semantic_lines(body) do
    body
    |> String.split("\n")
    |> Enum.reject(&Regex.match?(@semantic_color_line, &1))
    |> Enum.join("\n")
  end

  defp build_semantic_utility(host, role, body) do
    semantic_body =
      body
      |> String.split("\n")
      |> Enum.filter(&Regex.match?(@semantic_color_line, &1))
      |> Enum.map(&substitute_role(&1, role))
      |> Enum.join("\n")

    "@utility #{host}--#{role} {\n#{semantic_body}\n}"
  end

  defp substitute_role(line, role) do
    line
    |> String.replace("--color-*-ink", "--color-#{role}-ink")
    |> String.replace("--color-ink-*", "--color-ink-#{role}")
    |> String.replace("--color-*-hover", "--color-#{role}-hover")
    |> String.replace("--color-*-active", "--color-#{role}-active")
    |> String.replace("--color-*-muted", "--color-#{role}-muted")
    |> String.replace("--color-*", "--color-#{role}")
  end

  defp remove_variant_subtle_utility(css) do
    remove_matching_utility_blocks(css, ~r/--variant-subtle\b/)
  end

  defp remove_variant_utilities(css, allowed) do
    all = Enum.map(Filter.default_variants(), &Atom.to_string/1)

    Enum.reduce(all, css, fn variant, acc ->
      if MapSet.member?(allowed, variant) do
        acc
      else
        acc
        |> remove_matching_utility_blocks(~r/--variant-#{variant}\b/)
        |> remove_anatomy_variant_rules(variant)
        |> simplify_not_variant(variant)
      end
    end)
    |> remove_variant_subtle_utility()
  end

  defp simplify_variant_not_selectors(css, allowed) do
    Enum.reduce(Enum.map(Filter.default_variants(), &Atom.to_string/1), css, fn variant, acc ->
      if MapSet.member?(allowed, variant) do
        acc
      else
        simplify_not_variant(acc, variant)
      end
    end)
  end

  defp simplify_not_variant(css, variant) do
    String.replace(css, ~r/:not\(\.[\w-]+--variant-#{variant}\)/, "")
  end

  defp remove_anatomy_variant_rules(css, variant) do
    pattern = ~r/--variant-#{variant}\b/

    css
    |> String.split("\n")
    |> remove_blocks_matching(pattern)
    |> Enum.join("\n")
  end

  defp remove_blocks_matching(lines, pattern) do
    {result, _} =
      Enum.reduce(lines, {[], nil}, fn line, {acc, skip_depth} ->
        cond do
          skip_depth != nil ->
            new_depth = skip_depth + brace_delta(line)

            if new_depth <= 0 do
              {acc, nil}
            else
              {acc, new_depth}
            end

          selector_line?(line) and Regex.match?(pattern, line) ->
            depth = brace_delta(line)

            if depth <= 0 do
              {acc, nil}
            else
              {acc, depth}
            end

          true ->
            {[line | acc], skip_depth}
        end
      end)

    Enum.reverse(result)
  end

  defp selector_line?(line) do
    String.match?(line, ~r/^\s+\./)
  end

  defp brace_delta(line) do
    opens = line |> String.graphemes() |> Enum.count(&(&1 == "{"))
    closes = line |> String.graphemes() |> Enum.count(&(&1 == "}"))
    opens - closes
  end

  defp remove_matching_utility_blocks(css, name_pattern) do
    Regex.scan(~r/@utility\s+([\w-]+)\s*\{/s, css)
    |> Enum.reduce(css, fn [full, name], acc ->
      if Regex.match?(name_pattern, name) do
        case extract_block(acc, full) do
          nil -> acc
          %{full: block_full} -> String.replace(acc, block_full, "", global: false)
        end
      else
        acc
      end
    end)
  end

  defp extract_block(css, header) do
    case :binary.match(css, header) do
      {start, _} ->
        rest =
          binary_part(css, start + byte_size(header), byte_size(css) - start - byte_size(header))

        {body, _} = take_brace_body(rest, 1)

        %{
          full: header <> body <> "}",
          body: body
        }

      :nomatch ->
        nil
    end
  end

  defp take_brace_body(content, depth) do
    do_take_brace_body(content, depth, "")
  end

  defp do_take_brace_body(<<>>, _depth, acc), do: {acc, 0}

  defp do_take_brace_body(<<char, rest::binary>>, depth, acc) do
    case char do
      ?{ ->
        do_take_brace_body(rest, depth + 1, acc <> <<char>>)

      ?} ->
        if depth == 1 do
          {acc, byte_size(rest)}
        else
          do_take_brace_body(rest, depth - 1, acc <> <<char>>)
        end

      _ ->
        do_take_brace_body(rest, depth, acc <> <<char>>)
    end
  end
end
