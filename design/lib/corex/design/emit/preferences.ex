defmodule Corex.Design.Emit.Preferences do
  @moduledoc false

  alias Corex.Design.Accessibility
  alias Corex.Design.Emit.Css
  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Write

  @header "/* Corex generated preferences - do not edit */\n"

  @doc false
  def write!(output_root) do
    axes = Accessibility.axes()

    if axes == [] do
      remove_preferences!(output_root)
      :ok
    else
      File.mkdir_p!(Path.join(output_root, "tokens/preferences"))

      case Enum.flat_map(axes, &write_axis!(output_root, &1)) do
        [] ->
          remove_preferences!(output_root)

        paths ->
          write_entry!(output_root, paths)
      end

      :ok
    end
  end

  @doc false
  def entry_import?, do: Accessibility.enabled?()

  defp write_axis!(output_root, :text), do: [write_text!(output_root)]
  defp write_axis!(output_root, :contrast), do: [write_contrast!(output_root)]
  defp write_axis!(output_root, :motion), do: [write_motion!(output_root)]
  defp write_axis!(output_root, :cursor), do: [write_cursor!(output_root)]
  defp write_axis!(output_root, :focus), do: [write_focus!(output_root)]
  defp write_axis!(output_root, :links), do: [write_links!(output_root)]
  defp write_axis!(_output_root, _), do: []

  defp write_text!(output_root) do
    blocks =
      Accessibility.values(:text)
      |> Enum.flat_map(fn value ->
        zoom = Accessibility.text_zoom(value)

        if zoom == 1.0 do
          []
        else
          zoom_css = format_zoom(zoom)
          font_pct = format_zoom_percent(zoom)
          selector = ~s([data-text="#{value}"])

          [
            Css.block(selector, [Css.property("zoom", zoom_css)]),
            [
              "@supports not (zoom: 1) {\n",
              Css.block(selector, [Css.property("font-size", font_pct)]),
              "}\n"
            ]
          ]
        end
      end)

    path = "tokens/preferences/text.css"
    Write.atomic!(Path.join(output_root, path), Css.document(blocks))
    path
  end

  defp format_zoom(zoom) when is_integer(zoom), do: Integer.to_string(zoom)
  defp format_zoom(zoom) when is_float(zoom), do: :erlang.float_to_binary(zoom * 1.0, decimals: 2)

  defp format_zoom_percent(zoom) when is_number(zoom) do
    pct = zoom * 100
    truncated = trunc(pct)

    if pct == truncated do
      "#{truncated}%"
    else
      :erlang.float_to_binary(pct * 1.0, decimals: 2) <> "%"
    end
  end

  defp write_contrast!(output_root) do
    colors = Colors.generate(contrast: :more)
    _ = Corex.Design.Tokens.Contrast.check!(colors)

    blocks =
      for {{theme, mode}, tokens} <- Enum.sort_by(colors, fn {{t, m}, _} -> {t, m} end) do
        decls =
          tokens
          |> Enum.sort_by(fn {role, _} -> role end)
          |> Enum.map(fn {role, hex} -> Css.declaration("color-#{role}", hex) end)

        Css.block(
          ~s([data-theme="#{theme}"][data-mode="#{mode}"][data-contrast="more"]),
          decls
        )
      end

    path = "tokens/preferences/contrast.css"
    Write.atomic!(Path.join(output_root, path), Css.document(blocks))
    path
  end

  defp write_motion!(output_root) do
    decls = [
      Css.declaration("duration-fast", "0.01ms"),
      Css.declaration("duration-normal", "0.01ms"),
      Css.declaration("duration-slow", "0.01ms")
    ]

    block = Css.block(~s([data-motion="reduce"]), decls)
    path = "tokens/preferences/motion.css"
    Write.atomic!(Path.join(output_root, path), Css.document([block]))
    path
  end

  defp write_cursor!(output_root) do
    svg =
      "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"48\" height=\"48\" viewBox=\"0 0 24 24\">" <>
        "<path fill=\"#000\" stroke=\"#fff\" stroke-width=\"1.75\" stroke-linejoin=\"round\" " <>
        "d=\"M7.921 2.299C6.936 1.533 5.5 2.235 5.5 3.483V20.492c0 1.422 1.795 2.046 2.677.93" <>
        "l4.191-5.3c.313-.396.79-.627 1.294-.627h6.852c1.428 0 2.048-1.807.921-2.684L7.921 2.299z\"/>" <>
        "</svg>"

    encoded = URI.encode(svg, &URI.char_unreserved?/1)
    cursor = ~s|url("data:image/svg+xml,#{encoded}") 11 5, auto|

    blocks = [
      Css.block(~s([data-cursor="large"], [data-cursor="large"] *), [
        Css.property("cursor", cursor)
      ])
    ]

    path = "tokens/preferences/cursor.css"
    Write.atomic!(Path.join(output_root, path), Css.document(blocks))
    path
  end

  defp write_focus!(output_root) do
    decls = [
      Css.declaration("ring-width", "4px"),
      Css.declaration("ring-offset", "2px")
    ]

    path = "tokens/preferences/focus.css"

    Write.atomic!(
      Path.join(output_root, path),
      Css.document([Css.block(~s([data-focus="strong"]), decls)])
    )

    path
  end

  defp write_links!(output_root) do
    selector =
      "[data-links=\"underline\"] a:not(.link--skip), [data-links=\"underline\"] .link:not(.link--skip)"

    blocks = [
      Css.block(selector, [
        Css.property("text-decoration-line", "underline"),
        Css.property("text-decoration-thickness", "from-font")
      ])
    ]

    path = "tokens/preferences/links.css"
    Write.atomic!(Path.join(output_root, path), Css.document(blocks))
    path
  end

  defp write_entry!(output_root, paths) do
    imports =
      paths
      |> Enum.uniq()
      |> Enum.map(&Path.basename/1)
      |> Enum.map(&"./tokens/preferences/#{&1}")

    Write.atomic!(
      Path.join(output_root, "preferences.css"),
      [@header, Css.imports(imports)]
    )
  end

  defp remove_preferences!(output_root) do
    entry = Path.join(output_root, "preferences.css")
    dir = Path.join(output_root, "tokens/preferences")

    if File.exists?(entry), do: File.rm!(entry)
    if File.dir?(dir), do: File.rm_rf!(dir)

    :ok
  end
end
