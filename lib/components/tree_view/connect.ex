defmodule Corex.TreeView.Connect do
  @moduledoc false

  alias Corex.Animation.Height
  alias Corex.Json

  alias Corex.Selectors

  alias Corex.TreeView.Anatomy.{
    Branch,
    BranchContent,
    BranchControl,
    BranchIndentGuide,
    BranchIndicator,
    BranchText,
    Item,
    ItemIndicator,
    ItemText,
    Label,
    Props,
    Root,
    Tree
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [validate_value!: 1, get_boolean: 1]

  defp depth_style(index_path) when is_list(index_path), do: "--depth: #{length(index_path)}"
  defp depth_style(_), do: "--depth: 0"

  defp path_key([]), do: "root"

  defp path_key(index_path) when is_list(index_path) do
    Enum.map_join(index_path, "-", &Integer.to_string/1)
  end

  defp tree_root_id(component_id), do: "tree:#{component_id}:root"
  defp tree_label_id(component_id), do: "tree:#{component_id}:label"
  defp tree_tree_id(component_id), do: "tree:#{component_id}:tree"

  defp tree_node_id(component_id, value),
    do: "tree:#{component_id}:node:#{value}"

  defp tree_branch_wrapper_id(component_id, value),
    do: "tree:#{component_id}:branch:#{value}"

  defp tree_branch_part_id(component_id, part, path_key),
    do: "tree:#{component_id}:#{part}:#{path_key}"

  @spec props(Props.t()) :: map()
  def props(assigns) do
    animation = Map.get(assigns, :animation, "js")
    animation_options = Map.get(assigns, :animation_options, %Height{})

    base = %{
      "id" => assigns.id,
      "data-tree" => Json.encode!(assigns.tree),
      "data-animation" => animation,
      "data-redirect" => get_boolean(assigns.redirect),
      "data-default-expanded-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.expanded_value), ",")
        end,
      "data-expanded-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.expanded_value), ",")
        else
          nil
        end,
      "data-default-selected-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-selected-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-controlled" => get_boolean(assigns.controlled),
      "data-selection-mode" => assigns.selection_mode,
      "data-typeahead" => if(Map.get(assigns, :typeahead, true), do: "true", else: "false"),
      "data-dir" => assigns.dir,
      "data-on-selection-change" => assigns.on_selection_change,
      "data-on-selection-change-client" => Map.get(assigns, :on_selection_change_client),
      "data-on-expanded-change" => assigns.on_expanded_change,
      "data-on-expanded-change-client" => Map.get(assigns, :on_expanded_change_client)
    }

    if animation == "js" do
      Map.merge(base, Height.to_dataset(animation_options))
    else
      base
    end
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => tree_root_id(assigns.id)
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id(tree_root_id(assigns.id))
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => tree_label_id(assigns.id)
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id(tree_label_id(assigns.id))
    )
  end

  @spec tree(Props.t()) :: map()
  def tree(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "tree",
      "dir" => assigns.dir,
      "id" => tree_tree_id(assigns.id)
    }
  end

  def ignore_tree(assigns) do
    JS.ignore_attributes(Tree.ignored_attrs(),
      to: Selectors.css_id(tree_tree_id(assigns.id))
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "tree-view",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-disabled" => get_boolean(assigns.disabled),
      "dir" => assigns.dir,
      "id" => tree_node_id(assigns.id, assigns.value),
      "style" => depth_style(assigns.index_path)
    }

    base = if Map.get(assigns, :name), do: Map.put(base, "data-name", assigns.name), else: base
    base = if Map.get(assigns, :to), do: Map.put(base, "data-to", assigns.to), else: base

    base =
      case assigns.redirect do
        false ->
          Map.put(base, "data-redirect", "false")

        mode when mode in [:href, :patch, :navigate] ->
          Map.put(base, "data-redirect", Atom.to_string(mode))

        _ ->
          base
      end

    base = if assigns.new_tab, do: Map.put(base, "data-new-tab", ""), else: base
    base = if Map.get(assigns, :selected), do: Map.put(base, "data-selected", ""), else: base
    if Map.get(assigns, :focused), do: Map.put(base, "data-focus", ""), else: base
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id(tree_node_id(assigns.id, assigns.value))
    )
  end

  @spec branch(Branch.t()) :: map()
  def branch(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "tree-view",
      "data-part" => "branch",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "data-disabled" => get_boolean(assigns.disabled),
      "dir" => assigns.dir,
      "id" => tree_branch_wrapper_id(assigns.id, assigns.value)
    }

    base = if Map.get(assigns, :name), do: Map.put(base, "data-name", assigns.name), else: base
    base = if Map.get(assigns, :selected), do: Map.put(base, "data-selected", ""), else: base
    if Map.get(assigns, :focused), do: Map.put(base, "data-focus", ""), else: base
  end

  def ignore_branch(assigns) do
    JS.ignore_attributes(Branch.ignored_attrs(),
      to: Selectors.css_id(tree_branch_wrapper_id(assigns.id, assigns.value))
    )
  end

  @spec branch_trigger(Branch.t()) :: map()
  def branch_trigger(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "tree-view",
      "data-part" => "branch-control",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "data-disabled" => get_boolean(assigns.disabled),
      "dir" => assigns.dir,
      "style" => depth_style(assigns.index_path),
      "id" => tree_node_id(assigns.id, assigns.value)
    }

    base = if Map.get(assigns, :selected), do: Map.put(base, "data-selected", ""), else: base
    if Map.get(assigns, :focused), do: Map.put(base, "data-focus", ""), else: base
  end

  def ignore_branch_trigger(assigns) do
    JS.ignore_attributes(BranchControl.ignored_attrs(),
      to: Selectors.css_id(tree_node_id(assigns.id, assigns.value))
    )
  end

  @spec branch_content(Branch.t()) :: map()
  def branch_content(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"
    pk = path_key(assigns.index_path)
    animation = Map.get(assigns, :animation, "instant")

    base = %{
      "data-scope" => "tree-view",
      "data-part" => "branch-content",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "branch-content", pk)
    }

    cond do
      assigns.expanded ->
        base

      animation == "instant" ->
        Map.put(base, "hidden", "")

      true ->
        base
    end
  end

  def ignore_branch_content(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(BranchContent.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "branch-content", pk))
    )
  end

  @spec branch_indicator(Branch.t()) :: map()
  def branch_indicator(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"
    pk = path_key(assigns.index_path)

    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-indicator",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "data-disabled" => get_boolean(assigns.disabled),
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "branch-indicator", pk)
    }
  end

  def ignore_branch_indicator(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(BranchIndicator.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "branch-indicator", pk))
    )
  end

  @spec branch_text(Branch.t()) :: map()
  def branch_text(assigns) do
    pk = path_key(assigns.index_path)

    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-text",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "branch-text", pk)
    }
  end

  def ignore_branch_text(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(BranchText.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "branch-text", pk))
    )
  end

  @spec item_text(Item.t()) :: map()
  def item_text(assigns) do
    pk = path_key(assigns.index_path)

    %{
      "data-scope" => "tree-view",
      "data-part" => "item-text",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "item-text", pk)
    }
  end

  def ignore_item_text(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(ItemText.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "item-text", pk))
    )
  end

  @spec item_indicator(Item.t()) :: map()
  def item_indicator(assigns) do
    pk = path_key(assigns.index_path)

    base = %{
      "data-scope" => "tree-view",
      "data-part" => "item-indicator",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-disabled" => get_boolean(assigns.disabled),
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "item-indicator", pk),
      "aria-hidden" => "true"
    }

    base = if Map.get(assigns, :selected), do: Map.put(base, "data-selected", ""), else: base
    base = if Map.get(assigns, :focused), do: Map.put(base, "data-focus", ""), else: base

    if Map.get(assigns, :selected) do
      base
    else
      Map.put(base, "hidden", true)
    end
  end

  def ignore_item_indicator(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "item-indicator", pk))
    )
  end

  @spec branch_indent_guide(Branch.t()) :: map()
  def branch_indent_guide(assigns) do
    pk = path_key(assigns.index_path)

    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-indent-guide",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "dir" => assigns.dir,
      "id" => tree_branch_part_id(assigns.id, "branch-indent-guide", pk)
    }
  end

  def ignore_branch_indent_guide(assigns) do
    pk = path_key(assigns.index_path)

    JS.ignore_attributes(BranchIndentGuide.ignored_attrs(),
      to: Selectors.css_id(tree_branch_part_id(assigns.id, "branch-indent-guide", pk))
    )
  end

  defp encode_index_path(nil), do: nil
  defp encode_index_path([]), do: nil
  defp encode_index_path(path) when is_list(path), do: Enum.join(path, "/")
end
