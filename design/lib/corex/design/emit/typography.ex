defmodule Corex.Design.Emit.Typography do
  @moduledoc false

  alias Corex.Design.Emit.Css
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Naming
  alias Corex.Design.Write

  @doc false
  def write!(output_root, theme) when is_atom(theme) do
    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "typography.css"])

    Write.atomic!(path, generate(theme, Theme.typography(theme)))
  end

  @doc """
  The `.typo` rules for one theme, scoped to `[data-theme="<theme>"]`.

  Takes the typography map rather than reading it, so a caller can emit a shape
  no preset defines.
  """
  @spec generate(atom(), map()) :: iolist()
  def generate(theme, typography) when is_atom(theme) and is_map(typography) do
    Css.document(rules(theme, typography))
  end

  defp rules(_theme, map) when map_size(map) == 0, do: []

  defp rules(theme, map) do
    [Enum.map_join(map, "\n", &rule_for_selector(theme, &1)), "\n"]
  end

  defp rule_for_selector(theme, {selector, props}) when is_map(props) do
    {base, nested} = split_props(props)
    base_block = theme_selector_block(theme, selector, base)

    nested_blocks =
      Enum.map_join(nested, "\n", fn {bp, nested_props} ->
        media_block(bp, theme, selector, nested_props)
      end)

    [base_block, nested_blocks] |> Enum.reject(&(&1 == "")) |> Enum.join("\n")
  end

  defp split_props(props) do
    Enum.reduce(props, {%{}, %{}}, fn {key, value}, {base, nested} ->
      key_s = to_string(key)

      if Naming.breakpoint?(key_s) and is_map(value) do
        {base, Map.put(nested, key_s, value)}
      else
        {Map.put(base, key, value), nested}
      end
    end)
  end

  defp theme_selector_block(_theme, _selector, props) when map_size(props) == 0, do: ""

  defp theme_selector_block(theme, selector, props) do
    theme
    |> typo_selector(selector)
    |> Css.block(decls(props, "  "))
    |> IO.iodata_to_binary()
  end

  defp media_block(_bp, _theme, _selector, props) when map_size(props) == 0, do: ""

  defp media_block(bp, theme, selector, props) do
    inner = [
      "  ",
      typo_selector(theme, selector),
      " {\n",
      Enum.intersperse(decls(props, "      "), "\n"),
      "\n  }\n"
    ]

    IO.iodata_to_binary([
      "@media (min-width: ",
      Naming.breakpoint_width!(bp),
      ") {\n",
      inner,
      "}\n"
    ])
  end

  defp typo_selector(theme, selector) do
    ~s|[data-theme="#{theme}"] .typo #{css_selector(selector)}:not(:where([data-scope] *))|
  end

  defp css_selector(selector) when is_binary(selector), do: selector
  defp css_selector(selector), do: to_string(selector)

  defp decls(props, pad) do
    props
    |> Enum.sort_by(fn {key, _value} -> to_string(key) end)
    |> Enum.map(fn {prop, value} ->
      Css.property(css_property(prop), css_value(prop, value), pad)
    end)
  end

  defp css_property(:font_family), do: "font-family"
  defp css_property(:font_weight), do: "font-weight"
  defp css_property(:font_style), do: "font-style"
  defp css_property(:font_size), do: "font-size"
  defp css_property(:letter_spacing), do: "letter-spacing"
  defp css_property(:line_height), do: "line-height"
  defp css_property(other), do: other |> to_string() |> String.replace("_", "-")

  defp css_value(_prop, {:font, step}), do: "var(--font-#{dash(step)})"
  defp css_value(_prop, {:weight, step}), do: "var(--font-weight-#{dash(step)})"
  defp css_value(_prop, {:tracking, step}), do: "var(--tracking-#{dash(step)})"
  defp css_value(:font_size, {:text, step}), do: "var(--text-#{text_step(step)})"
  defp css_value(:line_height, {:text, step}), do: "var(--text-#{text_step(step)}--line-height)"
  defp css_value(:line_height, {:leading, step}), do: "var(--leading-#{dash(step)})"
  defp css_value(_prop, {:leading, step}), do: "var(--leading-#{dash(step)})"
  defp css_value(_prop, {:text, step}), do: "var(--text-#{text_step(step)})"
  defp css_value(_prop, atom) when is_atom(atom), do: Atom.to_string(atom)
  defp css_value(_prop, value) when is_binary(value) or is_number(value), do: to_string(value)

  defp text_step(:md), do: "base"
  defp text_step(step), do: dash(step)

  defp dash(value), do: Naming.dash(value)
end
