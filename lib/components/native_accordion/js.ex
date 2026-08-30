defmodule Corex.NativeAccordion.JS do
  @moduledoc false

  alias Corex.NativeAccordion.Ids
  alias Corex.NativeAccordion.State
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @doc """
  Open one item (set ARIA / data-state / unhide content).
  """
  @spec open_item(String.t(), String.t()) :: JS.t()
  def open_item(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    apply_open(%JS{}, accordion_id, item_value)
  end

  @doc """
  Close one item.
  """
  @spec close_item(String.t(), String.t()) :: JS.t()
  def close_item(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    apply_close(%JS{}, accordion_id, item_value)
  end

  @doc """
  Uncontrolled toggle for one item.

  When `multiple: false`, siblings are closed first; then the clicked item is
  toggled (so collapsible single-mode can close the open item).
  """
  @spec toggle_item(String.t(), String.t(), keyword()) :: JS.t()
  def toggle_item(accordion_id, item_value, opts \\ [])
      when is_binary(accordion_id) and is_binary(item_value) and is_list(opts) do
    sibling_values = Keyword.get(opts, :sibling_values, [])
    multiple? = Keyword.get(opts, :multiple, true)

    %JS{}
    |> maybe_close_siblings(accordion_id, sibling_values, item_value, multiple?)
    |> apply_toggle(accordion_id, item_value)
  end

  @doc """
  Controlled click: push `on_value_change` with toggle payload.
  """
  @spec push_toggle(String.t(), String.t(), String.t()) :: JS.t()
  def push_toggle(event, accordion_id, item_value)
      when is_binary(event) and is_binary(accordion_id) and is_binary(item_value) do
    JS.push(event, value: %{id: accordion_id, item: item_value, action: "toggle"})
  end

  @doc """
  Client `set_value` for uncontrolled mode: close all listed items, open `values`.
  """
  @spec set_value(String.t(), term(), keyword()) :: JS.t()
  def set_value(accordion_id, value, opts \\ [])
      when is_binary(accordion_id) and is_list(opts) do
    all_values = Keyword.get(opts, :all_values, [])
    open_values = State.value_list(value)

    js =
      Enum.reduce(all_values, %JS{}, fn v, acc ->
        apply_close(acc, accordion_id, v)
      end)

    Enum.reduce(open_values, js, fn v, acc ->
      apply_open(acc, accordion_id, v)
    end)
  end

  @doc """
  Focus a trigger by item value.
  """
  @spec focus_item(String.t(), String.t()) :: JS.t()
  def focus_item(accordion_id, item_value)
      when is_binary(accordion_id) and is_binary(item_value) do
    JS.focus(to: Selectors.css_id(Ids.trigger_id(accordion_id, item_value)))
  end

  @doc """
  Execute the compiled `data-nav-*` JS.focus stored on this accordion's focused trigger.

  The selector matches only this accordion's focused trigger so a missing attr
  cannot throw (`JS.exec` no-ops when `to:` matches nothing).
  """
  @spec exec_nav(atom(), String.t()) :: JS.t()
  def exec_nav(direction, accordion_id)
      when direction in [:next, :prev, :first, :last] and is_binary(accordion_id) do
    JS.exec("data-nav-#{direction}", to: focused_trigger_selector(accordion_id))
  end

  defp focused_trigger_selector(accordion_id) do
    ownedby = Ids.root_id(accordion_id)

    "[data-scope='accordion'][data-part='item-trigger'][data-ownedby='#{ownedby}']:focus"
  end

  defp maybe_close_siblings(js, _accordion_id, _sibling_values, _item_value, true), do: js

  defp maybe_close_siblings(js, accordion_id, sibling_values, item_value, false) do
    Enum.reduce(sibling_values, js, fn
      ^item_value, acc -> acc
      v, acc -> apply_close(acc, accordion_id, v)
    end)
  end

  defp apply_open(js, accordion_id, item_value) do
    item_sel = Selectors.css_id(Ids.item_id(accordion_id, item_value))
    trigger_sel = Selectors.css_id(Ids.trigger_id(accordion_id, item_value))
    content_sel = Selectors.css_id(Ids.content_id(accordion_id, item_value))
    indicator_sel = Selectors.css_id(Ids.indicator_id(accordion_id, item_value))

    js
    |> JS.set_attribute({"data-state", "open"}, to: item_sel)
    |> JS.set_attribute({"data-state", "open"}, to: trigger_sel)
    |> JS.set_attribute({"aria-expanded", "true"}, to: trigger_sel)
    |> JS.set_attribute({"data-state", "open"}, to: content_sel)
    |> JS.remove_attribute("hidden", to: content_sel)
    |> JS.set_attribute({"data-state", "open"}, to: indicator_sel)
  end

  defp apply_close(js, accordion_id, item_value) do
    item_sel = Selectors.css_id(Ids.item_id(accordion_id, item_value))
    trigger_sel = Selectors.css_id(Ids.trigger_id(accordion_id, item_value))
    content_sel = Selectors.css_id(Ids.content_id(accordion_id, item_value))
    indicator_sel = Selectors.css_id(Ids.indicator_id(accordion_id, item_value))

    js
    |> JS.set_attribute({"data-state", "closed"}, to: item_sel)
    |> JS.set_attribute({"data-state", "closed"}, to: trigger_sel)
    |> JS.set_attribute({"aria-expanded", "false"}, to: trigger_sel)
    |> JS.set_attribute({"data-state", "closed"}, to: content_sel)
    |> JS.set_attribute({"hidden", ""}, to: content_sel)
    |> JS.set_attribute({"data-state", "closed"}, to: indicator_sel)
  end

  defp apply_toggle(js, accordion_id, item_value) do
    item_sel = Selectors.css_id(Ids.item_id(accordion_id, item_value))
    trigger_sel = Selectors.css_id(Ids.trigger_id(accordion_id, item_value))
    content_sel = Selectors.css_id(Ids.content_id(accordion_id, item_value))
    indicator_sel = Selectors.css_id(Ids.indicator_id(accordion_id, item_value))

    js
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: item_sel)
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: trigger_sel)
    |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: trigger_sel)
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: content_sel)
    |> JS.toggle_attribute({"hidden", ""}, to: content_sel)
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: indicator_sel)
  end
end
