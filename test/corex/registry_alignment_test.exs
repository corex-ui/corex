defmodule Corex.RegistryAlignmentTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Components

  @expected_heex_only MapSet.new([
                        "action",
                        "file-upload-live",
                        "heroicon",
                        "hidden-input",
                        "navigate"
                      ])

  @expected_css_only MapSet.new([
                       "badge",
                       "button",
                       "icon",
                       "link",
                       "scrollbar",
                       "typo"
                     ])

  defp normalize(id), do: id |> to_string() |> String.replace("_", "-")

  test "locks intentional HEEx-only and CSS-only registry splits" do
    heex = Corex.component_ids() |> MapSet.new(&normalize/1)
    design = Components.ids() |> MapSet.new(&normalize/1)

    assert MapSet.difference(heex, design) == @expected_heex_only
    assert MapSet.difference(design, heex) == @expected_css_only
  end

  test "Corex.heex_only_ids/0 matches the HEEx-only split" do
    assert MapSet.new(Corex.heex_only_ids(), &normalize/1) == @expected_heex_only
  end

  test "Design.css_only_ids/0 is the fetch_elixir_id CSS-only list" do
    css_only = MapSet.new(Components.css_only_ids())

    assert css_only == MapSet.new(~W(badge scrollbar typo))

    for id <- Components.ids() do
      if id in css_only do
        assert Components.fetch_elixir_id(id) == :error
      else
        assert match?({:ok, _}, Components.fetch_elixir_id(id))
      end
    end
  end

  test "Design ids minus css_only_ids match HEEx-mapped CSS hosts" do
    heex_css_ids =
      Corex.component_ids()
      |> Enum.map(&to_string/1)
      |> Enum.flat_map(fn id ->
        case Components.fetch_css_id(id) do
          {:ok, css_id} -> [css_id]
          :error -> []
        end
      end)
      |> MapSet.new()

    design_with_heex =
      Components.ids()
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(Components.css_only_ids()))

    assert design_with_heex == heex_css_ids
  end

  test "design anatomy CSS files match design registry ids" do
    css_dir =
      :corex_design
      |> :code.priv_dir()
      |> List.to_string()
      |> Path.join("css/components")

    css_ids =
      css_dir
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, ".css"))
      |> Enum.map(&String.trim_trailing(&1, ".css"))
      |> Enum.reject(&(&1 == "keyframes"))
      |> MapSet.new()

    assert css_ids == MapSet.new(Components.ids())
  end
end
