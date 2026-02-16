defmodule Corex.ImportMap do
  @moduledoc """
  Builds import map data for Corex JS hooks (ESM).

  Use in your root layout to output a `<script type="importmap">` with
  `Corex.ImportMap.import_map/2` and encode with `Jason.encode!/1`.

  ## Options

  - `base` – URL path prefix for Corex assets (e.g. `"/corex"`). Default `"/corex"`.
  - `only` – List of hook names to include. Default `[]` (all). Use e.g. `["accordion", "dialog"]`
    to only expose those. Names are normalized to kebab-case (e.g. `"date_picker"` → `"date-picker"`).

  ## Examples

      Corex.ImportMap.import_map()
      Corex.ImportMap.import_map("/corex", [])
      Corex.ImportMap.import_map("/corex", ["accordion", "editable"])

  In a layout (empty list = all hooks; pass base and only via assigns if needed):

      <script type="importmap"><%= raw Jason.encode!(Corex.ImportMap.import_map(assigns[:corex_import_map_base] || "/corex", assigns[:corex_import_map_only] || [])) %></script>
  """

  @hooks ~w(
    accordion angle-slider avatar carousel checkbox clipboard collapsible combobox
    date-picker dialog editable floating-panel listbox menu number-input
    password-input pin-input radio-group select signature-pad switch tabs
    timer toast toggle-group tree-view
  )

  @doc """
  Returns an import map for the single-bundle setup: `"corex"` and all `"corex/<hook>"` entries
  pointing to `corex.mjs`. Supports both `import corex from "corex"` and per-hook imports.

  Use with a single Plug.Static at `/corex`. Pass the result to `Jason.encode!/1` in your root layout.
  """
  def import_map_single_bundle(base \\ "/corex") do
    base = base |> to_string() |> String.trim_trailing("/")
    bundle = "#{base}/corex.mjs"

    imports =
      Map.new(@hooks, fn name -> {"corex/#{name}", bundle} end)
      |> Map.put("corex", bundle)

    %{"imports" => imports}
  end

  @doc """
  Returns an import map (map of maps) for the given base path and optional list of hooks.

  - `base` – Path prefix for script URLs (default `"/corex"`). No trailing slash.
  - `only` – Empty list = all hooks; non-empty = only those names (atoms or strings, any format).

  The result can be passed to `Jason.encode!/1` for use in `<script type="importmap">`.
  """
  def import_map(base \\ "/corex", only \\ [])

  def import_map(base, []) do
    base = base |> to_string() |> String.trim_trailing("/")
    core = "#{base}/corex.mjs"

    imports =
      Map.new(@hooks, fn name ->
        {"corex/#{name}", "#{base}/#{name}.mjs"}
      end)
      |> Map.put("corex", core)

    %{"imports" => imports}
  end

  def import_map(base, only) when is_list(only) do
    base = base |> to_string() |> String.trim_trailing("/")
    normalized = Enum.map(only, &normalize_name/1)
    names = MapSet.new(normalized) |> MapSet.intersection(MapSet.new(@hooks)) |> Enum.to_list()

    core = "#{base}/corex.mjs"

    imports =
      Map.new(names, fn name ->
        {"corex/#{name}", "#{base}/#{name}.mjs"}
      end)
      |> Map.put("corex", core)

    %{"imports" => imports}
  end

  defp normalize_name(name) when is_atom(name), do: name |> to_string() |> normalize_name()

  defp normalize_name(name) when is_binary(name) do
    name
    |> String.replace("_", "-")
    |> String.downcase()
  end
end
