defmodule Corex.Design.Tokens.Publish do
  @moduledoc false

  alias Corex.Design.Emit.Css
  alias Corex.Design.Emit.Semantic
  alias Corex.Design.Emit.Typography
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.Naming
  alias Corex.Design.Tokens.Scales
  alias Corex.Design.Write

  @doc false
  def write_theme_tokens!(output_root) do
    Colors.clear_cache!()
    colors = Colors.generate()
    _ = Corex.Design.Tokens.Contrast.check!(colors)

    Enum.each(Theme.themes(), fn theme ->
      write_dimension!(output_root, theme)
      write_border!(output_root, theme)
      write_text!(output_root, theme)
      write_font!(output_root, theme)
      write_effect!(output_root, theme)
      Typography.write!(output_root, theme)

      Enum.each(Theme.modes(), fn mode ->
        write_color!(output_root, theme, mode, Map.fetch!(colors, {theme, mode}))
      end)
    end)

    Semantic.write_color_bridge!(output_root)
    Semantic.write_border_bridge!(output_root)
    Semantic.write_dimension_bridge!(output_root)
    Semantic.write_font_bridge!(output_root)
    Semantic.write_text_bridge!(output_root)
    Semantic.write_effect_bridge!(output_root)
    write_theme_entries!(output_root)
    Corex.Design.Emit.Preferences.write!(output_root)

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

  @theme_token_files ~w(border dimension text font effect typography)

  defp theme_entry(theme) do
    name = Atom.to_string(theme)

    paths =
      Enum.map(@theme_token_files, &"../tokens/themes/#{name}/#{&1}.css") ++
        Enum.map(Theme.modes(), &"../tokens/themes/#{name}/color/#{&1}.css")

    Css.imports(paths)
  end

  defp write_dimension!(output_root, theme) do
    vars =
      [{"spacing", Theme.spacing(theme)}] ++
        space_steps(theme) ++
        size_steps(theme) ++
        container_steps(theme)

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "dimension.css"])
    Write.atomic!(path, theme_block(theme, vars))
  end

  defp write_border!(output_root, theme) do
    radius_vars =
      for {step, value} <- Theme.radius(theme) do
        {"radius-#{dash(step)}", value}
      end

    chrome_vars = [
      {"border-width", Theme.border_width(theme)},
      {"ring-width", Theme.ring_width(theme)},
      {"ring-offset", Theme.ring_offset(theme)}
    ]

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "border.css"])
    Write.atomic!(path, theme_block(theme, radius_vars ++ chrome_vars))
  end

  defp write_text!(output_root, theme) do
    vars =
      for {step, value} <- Theme.text(theme) do
        {"text-#{text_token_step(step)}", value}
      end ++
        for {step, value} <- Scales.text_leading() do
          {"text-#{text_token_step(step)}--line-height", value}
        end ++
        for {step, value} <- Scales.leading() do
          {"leading-#{dash(step)}", Scales.num(value)}
        end ++
        for {step, value} <- Scales.tracking() do
          {"tracking-#{dash(step)}", value}
        end

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "text.css"])
    Write.atomic!(path, theme_block(theme, vars))
  end

  defp write_font!(output_root, theme) do
    stacks = Corex.Design.Emit.Tokens.font_stacks_for(theme)

    stack_vars =
      for {step, members} <- stacks do
        {"font-#{dash(step)}", Scales.font_stack(members)}
      end

    weight_vars =
      for {step, value} <- Scales.weight() do
        {"font-weight-#{dash(step)}", Integer.to_string(value)}
      end

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "font.css"])
    Write.atomic!(path, theme_block(theme, stack_vars ++ weight_vars))
  end

  defp write_effect!(output_root, theme) do
    shadow = Theme.shadow_scale(theme)
    blur = Theme.blur_scale(theme)

    shadow_vars =
      for {step, template} <- Scales.shadow() do
        {"shadow-#{dash(step)}", Scales.scale_shadow_template(template, shadow)}
      end

    inset_vars =
      for {step, template} <- Scales.inset_shadow() do
        {"inset-shadow-#{dash(step)}", Scales.scale_shadow_template(template, shadow)}
      end

    drop_vars =
      for {step, template} <- Scales.drop_shadow() do
        {"drop-shadow-#{dash(step)}", Scales.scale_shadow_template(template, shadow)}
      end

    text_shadow_vars =
      for {step, template} <- Scales.text_shadow() do
        {"text-shadow-#{dash(step)}", Scales.scale_shadow_template(template, shadow)}
      end

    blur_vars =
      for {step, value} <- Scales.blur() do
        {"blur-#{dash(step)}", scale_length(value, blur)}
      end

    motion_vars = [
      {"duration-fast", Theme.duration(theme, :fast)},
      {"duration-normal", Theme.duration(theme, :normal)},
      {"duration-slow", Theme.duration(theme, :slow)},
      {"opacity-disabled", Theme.opacity_disabled(theme)},
      {"opacity-backdrop", Theme.opacity_backdrop(theme)}
    ]

    path = Path.join([output_root, "tokens", "themes", Atom.to_string(theme), "effect.css"])

    Write.atomic!(
      path,
      theme_block(
        theme,
        shadow_vars ++ inset_vars ++ drop_vars ++ text_shadow_vars ++ blur_vars ++ motion_vars
      )
    )
  end

  defp scale_length(value, 1.0), do: value

  defp scale_length(value, scale) when is_binary(value) do
    Scales.scale_shadow_template(value, scale)
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
      {"spacing-space-#{step}", value}
    end
  end

  defp size_steps(theme) do
    for {step, value} <- Theme.size(theme) do
      {"spacing-size-#{step}", value}
    end
  end

  defp container_steps(theme) do
    for {step, value} <- Theme.container(theme) do
      {"container-#{dash(step)}", value}
    end
  end

  defp color_block(theme, mode, vars) do
    block(~s([data-theme="#{theme}"][data-mode="#{mode}"]), vars)
  end

  defp theme_block(theme, vars) do
    block(~s([data-theme="#{theme}"]), vars)
  end

  defp block(selector, vars) do
    declarations = Enum.map(vars, fn {name, value} -> Css.declaration(name, value) end)

    Css.document([Css.block(selector, declarations)])
  end

  defp dash(value), do: Naming.dash(value)

  defp text_token_step(step), do: Naming.text_token_step(step)
end
