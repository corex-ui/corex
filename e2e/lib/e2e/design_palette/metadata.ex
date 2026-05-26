defmodule E2e.DesignPalette.Metadata do
  @moduledoc false

  def token_set_order(config) do
    semantic = ~W(
      semantic/color
      semantic/dimension
      semantic/border
      semantic/text
      semantic/font
      semantic/effect
    )

    theme_sets =
      Enum.flat_map(E2e.DesignPalette.Config.theme_slugs(config), fn t ->
        [
          "themes/#{t}/border",
          "themes/#{t}/dimension",
          "themes/#{t}/text",
          "themes/#{t}/font",
          "themes/#{t}/color/light",
          "themes/#{t}/color/dark"
        ]
      end)

    semantic ++ theme_sets
  end

  def write!(design_dir, config) do
    path = Path.join([design_dir, "tokens", "$metadata.json"])
    data = %{"tokenSetOrder" => token_set_order(config)}
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, Jason.encode!(data, pretty: true) <> "\n")
  end
end
