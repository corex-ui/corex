defmodule E2eWeb.ComponentSourceLinks do
  @moduledoc false

  @github_base "https://github.com/corex-ui/corex/blob/main"
  @hex_base "https://hexdocs.pm/corex"

  @icon_hex "/images/tech/hex.svg"
  @icon_typescript "/images/tech/typescript.svg"
  @icon_phoenix "/images/tech/phoenix.svg"
  @icon_tailwind "/images/tech/tailwind.svg"

  @skip_segments ~W(showcases blog admins)

  @registry_to_hex_module %{
    "layout_heading" => "Corex.Layout.Heading"
  }

  @registry_to_phoenix_path %{
    "layout_heading" => "lib/components/layout/heading.ex"
  }

  def links_for_path(path) when is_binary(path) do
    with slug when is_binary(slug) <- slug_from_path(path),
         registry_id when is_binary(registry_id) <- registry_id(slug),
         true <- registered?(registry_id) do
      build_links(registry_id, slug)
    else
      _ -> nil
    end
  end

  def links_for_path(_), do: nil

  defp slug_from_path(path) do
    path
    |> E2eWeb.Path.strip_after_locale()
    |> String.trim()
    |> String.trim_leading("/")
    |> String.trim_trailing("/")
    |> String.split("/")
    |> List.first()
    |> case do
      segment when is_binary(segment) and segment != "" and segment not in @skip_segments ->
        segment

      _ ->
        nil
    end
  end

  defp registry_id(slug), do: String.replace(slug, "-", "_")

  defp registered?(registry_id) do
    registry_id in Enum.map(Corex.component_ids(), &Atom.to_string/1)
  end

  defp build_links(registry_id, slug) do
    links = []

    links = links ++ [%{label: "Hex doc", to: hex_url(registry_id), icon: @icon_hex}]

    links =
      case typescript_url(registry_id, slug) do
        nil -> links
        url -> links ++ [%{label: "TypeScript", to: url, icon: @icon_typescript}]
      end

    links = links ++ [%{label: "Phoenix", to: phoenix_url(registry_id), icon: @icon_phoenix}]

    links =
      case design_url_for(registry_id) do
        nil -> links
        url -> links ++ [%{label: "Design", to: url, icon: @icon_tailwind}]
      end

    if links == [], do: nil, else: links
  end

  defp hex_url(registry_id) do
    module = Map.get(@registry_to_hex_module, registry_id, hex_module_name(registry_id))
    "#{@hex_base}/#{module}.html"
  end

  defp hex_module_name(registry_id) do
    module =
      registry_id
      |> String.split("_")
      |> Enum.map_join("", &Macro.camelize/1)

    "Corex.#{module}"
  end

  defp phoenix_url(registry_id) do
    rel =
      Map.get(@registry_to_phoenix_path, registry_id, "lib/components/#{registry_id}.ex")

    "#{@github_base}/#{rel}"
  end

  defp design_url_for(registry_id) do
    case Corex.Design.Components.fetch_css_id(registry_id) do
      {:ok, css_id} -> design_url(css_id)
      :error -> nil
    end
  end

  defp design_url(css_id) do
    rel = "design/priv/css/components/#{css_id}.css"

    if corex_file_exists?(rel), do: "#{@github_base}/#{rel}"
  end

  defp typescript_url(registry_id, slug) do
    case hook_ts_rel(registry_id) do
      rel when is_binary(rel) ->
        "#{@github_base}/#{rel}"

      _ ->
        component_rel = "assets/components/#{slug}.ts"

        if corex_file_exists?(component_rel) do
          "#{@github_base}/#{component_rel}"
        end
    end
  end

  defp hook_ts_rel(registry_id) do
    if E2eWeb.ComponentWireIndex.hookless?(registry_id) do
      nil
    else
      kebab = slug_from_registry(registry_id)
      rel = "assets/hooks/#{kebab}.ts"
      if corex_file_exists?(rel), do: rel
    end
  end

  defp corex_file_exists?(rel) when is_binary(rel) do
    Path.expand("../../../#{rel}", __DIR__) |> File.exists?()
  end

  defp slug_from_registry(registry_id) do
    registry_id |> String.replace("_", "-")
  end
end
