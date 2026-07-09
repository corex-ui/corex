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
end
