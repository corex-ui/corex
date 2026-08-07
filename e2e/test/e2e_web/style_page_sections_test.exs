defmodule E2eWeb.StylePageSectionsTest do
  use ExUnit.Case, async: true

  alias E2eWeb.StylePageExpectations

  test "style pages include expected sizing sections per host width" do
    for {relative_path, layout_id} <- StylePageExpectations.style_pages() do
      source = StylePageExpectations.read_page(relative_path)
      expectations = StylePageExpectations.sizing_expectations(layout_id)

      if expectations.width do
        assert source =~ "axis={:width}",
               "expected Width axis on #{relative_path} (#{layout_id})"
      else
        refute source =~ "axis={:width}",
               "fill/auto page #{relative_path} (#{layout_id}) must not include Width axis"
      end

      if expectations.max_width do
        assert source =~ "axis={:max_width}",
               "expected Max width axis on #{relative_path} (#{layout_id})"
      else
        refute source =~ "axis={:max_width}",
               "page #{relative_path} (#{layout_id}) must not include Max width axis"
      end
    end
  end

  test "block max-width demos use join_block_modifiers in styling_max_width helpers" do
    for layout_id <- StylePageExpectations.fit_max_width_block_demo_layout_ids() do
      source = StylePageExpectations.read_block_demo_module(layout_id)

      assert source =~ "join_block_modifiers",
             "expected join_block_modifiers in max-width demo for #{layout_id}"
    end
  end

  test "data table style live includes max width section and excludes width section" do
    source = StylePageExpectations.read_data_table_style_live()

    assert source =~ "data-table-styling-max-width"
    refute source =~ "data-table-styling-width"
    refute source =~ "axis={:width}"
  end

  test "variant style pages use DemoScales subtle solid and ghost" do
    steps = E2eWeb.DemoScales.styling_variant_axis_steps("button")
    assert Enum.map(steps, & &1.modifier) == ["", "ui-solid", "ui-ghost"]

    for {relative_path, layout_id} <- StylePageExpectations.style_pages() do
      source = StylePageExpectations.read_page(relative_path)

      if layout_id in StylePageExpectations.no_variant_layout_ids() do
        refute source =~ "axis={:variant}",
               "no-variant page #{relative_path} (#{layout_id}) must not include Variant axis"

        refute source =~ "Semantic × variant",
               "no-variant page #{relative_path} (#{layout_id}) must not include Semantic × variant"
      else
        if source =~ "axis={:variant}" do
          assert source =~ "styling_variant",
                 "expected styling_variant helpers on #{relative_path}"
        end
      end
    end
  end

  test "no-radius style pages omit Rounded axis" do
    for {relative_path, layout_id} <- StylePageExpectations.style_pages(),
        layout_id in StylePageExpectations.no_radius_layout_ids() do
      source = StylePageExpectations.read_page(relative_path)

      refute source =~ "axis={:radius}",
             "no-radius page #{relative_path} (#{layout_id}) must not include Rounded axis"

      refute source =~ "-styling-radius",
             "no-radius page #{relative_path} (#{layout_id}) must not include a radius section"
    end
  end

  test "compound style pages keep canonical preview plus semantic variant matrices" do
    for {relative_path, layout_id} <- StylePageExpectations.style_pages(),
        layout_id in StylePageExpectations.canonical_preview_layout_ids() do
      source = StylePageExpectations.read_page(relative_path)

      assert source =~ "styling_canonical",
             "expected canonical preview helpers on #{relative_path} (#{layout_id})"

      if layout_id in StylePageExpectations.no_variant_layout_ids() do
        refute source =~ "Semantic × variant",
               "no-variant compound page #{relative_path} (#{layout_id}) must omit Semantic × variant"

        refute source =~ "axis={:variant}",
               "no-variant compound page #{relative_path} (#{layout_id}) must omit Variant axis"
      else
        assert source =~ "Semantic × variant",
               "compound page #{relative_path} (#{layout_id}) must include Semantic × variant"

        assert source =~ "axis={:variant}",
               "compound page #{relative_path} (#{layout_id}) must include Variant axis"
      end
    end
  end

  test "matrix style pages keep semantic variant matrices" do
    for {relative_path, layout_id} <- StylePageExpectations.style_pages(),
        layout_id in StylePageExpectations.matrix_layout_ids() do
      source = StylePageExpectations.read_page(relative_path)

      assert source =~ "Semantic × variant",
             "page #{relative_path} (#{layout_id}) must keep Semantic × variant"

      assert source =~ "axis={:variant}",
             "page #{relative_path} (#{layout_id}) must keep Variant axis"
    end
  end
end
