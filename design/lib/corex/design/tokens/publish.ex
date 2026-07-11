defmodule Corex.Design.Tokens.Publish do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Scales
  alias Corex.Design.Write

  @header "/**\n * Do not edit directly, this file was auto-generated.\n */\n\n"

  @doc false
  def write_theme_tokens!(output_root) do
    colors = Colors.generate()

    for theme <- Theme.themes() do
      write_dimension!(output_root, theme)
      write_border!(output_root, theme)
      write_text!(output_root, theme)
      write_font!(output_root, theme)

      for mode <- Theme.modes() do
        write_color!(output_root, theme, mode, Map.fetch!(colors, {theme, mode}))
      end
    end

    Corex.Design.Emit.Semantic.write_color_bridge!(output_root)
    Corex.Design.Emit.Semantic.write_dimension_bridge!(output_root)
    Corex.Design.Emit.Semantic.remove_legacy_color_scope!(output_root)
    write_theme_entries!(output_root)

    :ok
  end

  @doc false
  def write_theme_entries!(output_root) do
    for theme <- Theme.themes() do
      path = Path.join([output_root, "theme", "#{theme}.css"])
      File.mkdir_p!(Path.dirname(path))
      Write.atomic!(path, theme_entry(theme))
    end

    :ok
  end

  defp theme_entry(theme) do
    name = Atom.to_string(theme)

    imports =
      [
        ~s(@import "../tokens/themes/#{name}/border.css";),
        ~s(@import "../tokens/themes/#{name}/dimension.css";),
        ~s(@import "../tokens/themes/#{name}/text.css";),
        ~s(@import "../tokens/themes/#{name}/font.css";)
      ] ++
        Enum.map(Theme.modes(), fn mode ->
          ~s(@import "../tokens/themes/#{name}/color/#{mode}.css";)
        end)

    Enum.join(imports, "\n") <> "\n"
  end

  defp write_dimension!(output_root, theme) do
    vars =
      [{"theme-spacing", Theme.spacing(theme)}] ++
        space_steps(theme) ++
        size_steps(theme) ++
        container_steps(theme)

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "dimension.css"])
    Write.atomic!(path, theme_block(theme, vars))
  end

  defp write_border!(output_root, theme) do
    vars =
      for {step, value} <- Theme.radius(theme) do
        {"theme-radius-#{dash(step)}", value}
      end

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "border.css"])
    Write.atomic!(path, theme_block(theme, vars))
  end

  defp write_text!(output_root, theme) do
    vars =
      for {step, value} <- Theme.text(theme) do
        {"theme-text-#{text_token_step(step)}", value}
      end ++
        for {step, value} <- Scales.text_leading() do
          {"theme-text-#{text_token_step(step)}--line-height", value}
        end ++
        for {step, value} <- Scales.leading() do
          {"theme-text-leading-#{dash(step)}", Scales.num(value)}
        end ++
        for {step, value} <- Scales.tracking() do
          {"theme-text-tracking-#{dash(step)}", value}
        end

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "text.css"])
    Write.atomic!(path, theme_block(theme, vars))
  end

  defp write_font!(output_root, theme) do
    stacks = Corex.Design.Emit.Tokens.font_stacks_for(theme)

    stack_vars =
      for {step, members} <- stacks do
        {"theme-font-#{dash(step)}", Scales.font_stack(members)}
      end

    weight_vars =
      for {step, value} <- Scales.weight() do
        {"theme-font-weight-#{dash(step)}", Integer.to_string(value)}
      end

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "font.css"])
    Write.atomic!(path, theme_block(theme, stack_vars ++ weight_vars))
  end

  defp write_color!(output_root, theme, mode, tokens) do
    sorted =
      tokens
      |> Enum.sort_by(fn {role, _} -> role end)

    runtime_vars = Enum.map(sorted, fn {role, hex} -> {"color-#{role}", hex} end)

    path =
      Path.join([
        output_root,
        "tokens",
        "themes",
        Atom.to_string(theme),
        "color",
        "#{mode}.css"
      ])

    Write.atomic!(path, color_block(theme, mode, runtime_vars))
  end

  defp space_steps(theme) do
    for {step, value} <- Theme.density(theme) do
      {"theme-spacing-space-#{step}", value}
    end
  end

  defp size_steps(theme) do
    for {step, value} <- Theme.size(theme) do
      {"theme-spacing-size-#{step}", value}
    end
  end

  defp container_steps(theme) do
    for {step, value} <- Theme.container(theme) do
      {"theme-container-#{dash(step)}", value}
    end
  end

  defp color_block(theme, mode, vars) do
    @header <>
      ~s([data-theme="#{theme}"][data-mode="#{mode}"] {\n) <>
      format_vars(vars) <> "\n}\n"
  end

  defp theme_block(theme, vars) do
    @header <> selector_theme(theme) <> "\n" <> format_vars(vars) <> "\n}\n"
  end

  defp selector_theme(theme), do: ~s([data-theme="#{theme}"] {)

  defp format_vars(vars) do
    Enum.map_join(vars, "\n", fn {name, value} -> "  --#{name}: #{value};" end)
  end

  defp dash(value), do: value |> to_string() |> String.replace("_", "-")

  defp text_token_step(:md), do: "base"
  defp text_token_step(step), do: dash(step)
end
