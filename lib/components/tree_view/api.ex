defmodule Corex.TreeView.Api do
  @moduledoc false
  use Corex.Component, :api

  alias Corex.Api.RespondTo

  alias Corex.Selectors

  alias Phoenix.LiveView

  alias Phoenix.LiveView.JS

  @expanded "Corex.TreeView.set_expanded_value/2"
  @selected "Corex.TreeView.set_selected_value/2"

  def set_expanded_value(tree_view_id, value) when is_binary(tree_view_id) do
    JS.dispatch("corex:tree-view:set-expanded-value",
      to: Selectors.css_id(tree_view_id),
      detail: %{value: coerce_string_list(value, @expanded)},
      bubbles: false
    )
  end

  def set_selected_value(tree_view_id, value) when is_binary(tree_view_id) do
    JS.dispatch("corex:tree-view:set-selected-value",
      to: Selectors.css_id(tree_view_id),
      detail: %{value: coerce_string_list(value, @selected)},
      bubbles: false
    )
  end

  def set_expanded_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    RespondTo.push_set_value(
      socket,
      "tree_view_set_expanded_value",
      tree_view_id,
      coerce_string_list(value, @expanded)
    )
  end

  def set_selected_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    RespondTo.push_set_value(
      socket,
      "tree_view_set_selected_value",
      tree_view_id,
      coerce_string_list(value, @selected)
    )
  end

  def value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts) do
    JS.dispatch("corex:tree-view:value",
      to: Selectors.css_id(tree_view_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def value(tree_view_id) when is_binary(tree_view_id), do: value(tree_view_id, [])

  def value(socket, tree_view_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "tree_view_value",
      Map.merge(%{id: tree_view_id}, respond_to_fields(opts))
    )
  end

  def expanded_value(tree_view_id, opts) when is_binary(tree_view_id) and is_list(opts) do
    JS.dispatch("corex:tree-view:expanded-value",
      to: Selectors.css_id(tree_view_id),
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  def expanded_value(tree_view_id) when is_binary(tree_view_id),
    do: expanded_value(tree_view_id, [])

  def expanded_value(socket, tree_view_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "tree_view_expanded_value",
      Map.merge(%{id: tree_view_id}, respond_to_fields(opts))
    )
  end
end
