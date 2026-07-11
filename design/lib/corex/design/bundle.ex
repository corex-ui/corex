defmodule Corex.Design.Bundle do
  @moduledoc false

  alias Corex.Design.Bundle.Components
  alias Corex.Design.Bundle.CssFilter
  alias Corex.Design.Filter
  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Publish
  alias Corex.Design.Write

  @header "/* Corex generated design - do not edit */\n"

  @infra_files ~w(main.css tokens.css utilities.css)

  @semantic_static ~w(border.css text.css font.css effect.css)

  @doc false
  def write!(output_dir) do
    output_dir = Path.expand(output_dir)
    static_root = Path.join(:code.priv_dir(:corex_design), "css")

    File.mkdir_p!(output_dir)
    copy_infrastructure!(static_root, output_dir)

    component_ids = Components.resolve_ids(Filter.components())

    if Filter.components() do
      Filter.validate_component_ids!(Filter.components())
    end

    Components.copy!(static_root, output_dir, component_ids)
    Publish.write_theme_tokens!(output_dir)
    CssFilter.apply!(output_dir, component_ids)
    Components.write_entry!(output_dir, component_ids)
    write_corex_entry!(output_dir)

    Write.atomic!(
      Path.join(output_dir, "GENERATED"),
      @header <> "generated_at=#{DateTime.utc_now() |> DateTime.to_iso8601()}\n"
    )

    :ok
  end

  defp copy_infrastructure!(static_root, output_dir) do
    for file <- @infra_files do
      copy_file!(Path.join(static_root, file), Path.join(output_dir, file))
    end

    semantic_root = Path.join([static_root, "tokens", "semantic"])
    semantic_dest = Path.join([output_dir, "tokens", "semantic"])
    File.mkdir_p!(semantic_dest)

    for file <- @semantic_static do
      copy_file!(Path.join(semantic_root, file), Path.join(semantic_dest, file))
    end

    for theme <- Theme.themes() do
      copy_file!(
        Path.join([static_root, "theme", "#{theme}.css"]),
        Path.join([output_dir, "theme", "#{theme}.css"])
      )
    end

    :ok
  end

  defp copy_file!(source, dest) do
    File.mkdir_p!(Path.dirname(dest))
    File.cp!(source, dest)
  end

  defp write_corex_entry!(output_dir) do
    imports =
      [
        ~s(@import "./main.css";),
        ~s(@import "./tokens.css";),
        ~s(@import "./utilities.css";)
      ] ++
        Enum.map(Theme.themes(), fn theme ->
          ~s(@import "./theme/#{theme}.css";)
        end) ++
        [~s(@import "./components.css";)]

    Write.atomic!(
      Path.join(output_dir, "corex.css"),
      @header <> Enum.join(imports, "\n") <> "\n"
    )
  end
end
