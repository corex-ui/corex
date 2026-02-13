defmodule Corex.TreeView.Connect do
  @moduledoc false
  alias Corex.TreeView.Anatomy.{Props, Root, Label, Item, Branch}
  import Corex.Helpers, only: [validate_value!: 1]

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-redirect" => data_attr(assigns.redirect),
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
      "data-controlled" => data_attr(assigns.controlled),
      "data-selection-mode" => assigns.selection_mode,
      "data-dir" => assigns.dir,
      "data-on-selection-change" => assigns.on_selection_change,
      "data-on-expanded-change" => assigns.on_expanded_change
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "tree-view:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "tree-view:#{assigns.id}:label"
    }
  end

  @spec tree(Props.t()) :: map()
  def tree(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "tree",
      "dir" => assigns.dir,
      "id" => "tree-view:#{assigns.id}:tree"
    }
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "tree-view",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-disabled" => data_attr(assigns.disabled),
      "dir" => assigns.dir,
      "id" => "tree-view:#{assigns.id}:item:#{assigns.value}"
    }
    base = if Map.get(assigns, :name), do: Map.put(base, "data-name", assigns.name), else: base
    base = if assigns.redirect == false, do: Map.put(base, "data-redirect", "false"), else: base
    if assigns.new_tab, do: Map.put(base, "data-new-tab", ""), else: base
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
      "data-disabled" => data_attr(assigns.disabled),
      "dir" => assigns.dir,
      "id" => "tree-view:#{assigns.id}:branch:#{assigns.value}"
    }
    if Map.get(assigns, :name), do: Map.put(base, "data-name", assigns.name), else: base
  end

  @spec branch_trigger(Branch.t()) :: map()
  def branch_trigger(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"
    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-control",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "data-disabled" => data_attr(assigns.disabled),
      "dir" => assigns.dir
    }
  end

  @spec branch_content(Branch.t()) :: map()
  def branch_content(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"
    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-content",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "dir" => assigns.dir
    }
  end

  @spec branch_indicator(Branch.t()) :: map()
  def branch_indicator(assigns) do
    state = if assigns.expanded, do: "open", else: "closed"
    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-indicator",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "data-state" => state,
      "data-disabled" => data_attr(assigns.disabled),
      "dir" => assigns.dir
    }
  end

  @spec branch_text(Branch.t()) :: map()
  def branch_text(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-text",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "dir" => assigns.dir
    }
  end

  @spec branch_indent_guide(Branch.t()) :: map()
  def branch_indent_guide(assigns) do
    %{
      "data-scope" => "tree-view",
      "data-part" => "branch-indent-guide",
      "data-value" => assigns.value,
      "data-path" => encode_index_path(assigns.index_path),
      "dir" => assigns.dir
    }
  end

  defp encode_index_path(nil), do: nil
  defp encode_index_path([]), do: nil
  defp encode_index_path(path) when is_list(path), do: Enum.join(path, "/")
end
