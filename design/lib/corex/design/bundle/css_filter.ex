defmodule Corex.Design.Bundle.CssFilter do
  @moduledoc false

  alias Corex.Design.Filter

  @palette_roles ~w(accent brand alert info success)

  def apply!(output_dir, component_ids) do
    semantics = Filter.semantics()

    for id <- component_ids do
      path = Path.join([output_dir, "components", "#{id}.css"])

      if File.exists?(path) do
        path
        |> File.read!()
        |> then(&File.write!(path, &1))
      end
    end

    utilities_path = Path.join(output_dir, "utilities.css")

    if File.exists?(utilities_path) do
      utilities_path
      |> File.read!()
      |> apply_utilities_semantics(semantics)
      |> then(&File.write!(utilities_path, &1))
    end

    :ok
  end

  def apply_utilities_semantics(css, roles) do
    if semantics_filtered?(roles) do
      allowed =
        roles
        |> Enum.map(&to_string/1)
        |> MapSet.new()

      @palette_roles
      |> Enum.reject(&MapSet.member?(allowed, &1))
      |> Enum.reduce(css, fn role, acc ->
        remove_matching_utility_blocks(acc, ~r/^ui-#{role}$/)
      end)
    else
      css
    end
  end

  defp semantics_filtered?(roles) do
    default = Enum.map(Filter.default_semantics(), &Atom.to_string/1) |> Enum.sort()
    Enum.sort(roles) != default
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
