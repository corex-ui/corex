defmodule E2eWeb.DocDemoCoveragePolicyTest do
  use ExUnit.Case, async: true

  alias E2eWeb.{ComponentBehaviorSpec, DocA11yRoutes, DocPageMatrix}

  @feature_pattern ~r/\bfeature\s+"/

  test "every wallaby matrix page has DocA11yRoutes and ComponentBehaviorSpec entries" do
    for component <- DocPageMatrix.all_components(),
        page_key <- DocPageMatrix.wallaby_pages(component) do
      assert ComponentBehaviorSpec.has_page?(component, page_key),
             "missing ComponentBehaviorSpec.page(#{inspect(component)}, #{inspect(page_key)})"

      {path, root} = ComponentBehaviorSpec.page(component, page_key)
      locale_path = "/en" <> path

      assert Enum.any?(DocA11yRoutes.all(), fn {route_path, route_root} ->
               route_path == locale_path and route_root == root
             end),
             "missing DocA11yRoutes for #{locale_path} #{root}"
    end
  end

  test "every non-pilot component has Wallaby features for each matrix page" do
    for component <- DocPageMatrix.all_components(),
        not DocPageMatrix.pilot?(component) do
      paths = wallaby_test_paths(component)
      assert paths != [], "missing Wallaby test for #{component}"

      contents = paths |> Enum.map(&File.read!/1) |> Enum.join("\n")
      expected = length(DocPageMatrix.wallaby_pages(component))

      feature_count =
        if String.contains?(contents, "DocComponentWallaby") do
          expected
        else
          length(Regex.scan(@feature_pattern, contents))
        end

      assert feature_count >= expected,
             "#{inspect(paths)}: expected at least #{expected} feature(s), found #{feature_count}"
    end
  end

  @pilot_test_files %{
    accordion: "accordion_test.exs",
    angle_slider: "angle_slider_test.exs",
    checkbox: "checkbox_test.exs",
    combobox: "combobox_test.exs",
    listbox: "listbox_test.exs",
    switch: "switch_test.exs",
    tags_input: "tags_input_test.exs",
    toggle: "toggle_test.exs"
  }

  test "pilots keep dedicated Wallaby test modules" do
    base = Path.expand("../components", __DIR__)

    for {component, file} <- @pilot_test_files do
      path = Path.join(base, file)
      assert File.exists?(path), "missing pilot #{path}"
      refute String.contains?(File.read!(path), "DocComponentWallaby")
    end
  end

  defp wallaby_test_paths(component) do
    slug = component |> Atom.to_string() |> String.replace("_", "-")
    underscore = Atom.to_string(component)
    base = Path.expand("../components", __DIR__)

    (Path.wildcard(Path.join(base, "#{slug}*test.exs")) ++
       Path.wildcard(Path.join(base, "#{underscore}*test.exs")))
    |> Enum.uniq()
    |> Enum.filter(fn path ->
      contents = File.read!(path)

      String.contains?(contents, "use Wallaby.Feature") or
        String.contains?(contents, "DocComponentWallaby")
    end)
  end
end
