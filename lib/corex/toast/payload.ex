defmodule Corex.Toast.Payload do
  @moduledoc false

  import Corex.Helpers, only: [maybe_put: 3]

  alias Corex.Toast.Action, as: ToastAction
  alias Phoenix.LiveView.JS

  @toast_type_strings Map.new(~W(info success error warning loading)a, &{&1, Atom.to_string(&1)})

  @update_attr_strings %{
    "title" => :title,
    "description" => :description,
    "type" => :type,
    "duration" => :duration,
    "loading" => :loading,
    "action" => :action,
    "id" => :id,
    "groupId" => :groupId,
    "priority" => :priority
  }

  @action_string_keys MapSet.new(~W(label js class))

  def type_string(type) when is_atom(type) do
    Map.get(@toast_type_strings, type, "info")
  end

  def type_string(type) when is_binary(type) and type in ~W(info success error warning loading) do
    type
  end

  def type_string(_), do: "info"

  def duration_value(:infinity), do: "Infinity"
  def duration_value(v), do: v

  def normalize_action(nil), do: nil

  def normalize_action(%ToastAction{} = a) do
    with html when is_binary(html) <- action_label_html(a.label),
         %JS{ops: [_ | _]} = js <- a.js do
      %{"label" => html, "effects" => [%{"kind" => "exec_js", "encoded" => encode_js_ops(js)}]}
      |> maybe_put_class(a.class)
    else
      _ -> nil
    end
  end

  def normalize_action(m) when is_map(m) do
    case toast_action_from_map(m) do
      {:ok, %ToastAction{} = a} -> normalize_action(a)
      :error -> nil
    end
  end

  def normalize_action(_), do: nil

  defp toast_action_from_map(m) when is_map(m) do
    if valid_action_map_keys?(m) do
      s = stringify_action_keys(m)

      case {Map.get(s, "label"), Map.get(s, "js")} do
        {label, js} when not is_nil(label) and not is_nil(js) ->
          {:ok, %ToastAction{label: label, js: js, class: Map.get(s, "class")}}

        _ ->
          :error
      end
    else
      :error
    end
  end

  defp valid_action_map_keys?(m) do
    Enum.all?(Map.keys(m), fn k ->
      (is_atom(k) or is_binary(k)) and
        MapSet.member?(@action_string_keys, action_key_string(k))
    end)
  end

  defp stringify_action_keys(m) do
    Map.new(m, fn {k, v} -> {action_key_string(k), v} end)
  end

  defp action_key_string(k) when is_binary(k), do: k
  defp action_key_string(k) when is_atom(k), do: Atom.to_string(k)

  defp maybe_put_class(map, class) do
    case class_string(class) do
      nil -> map
      cls -> Map.put(map, "class", cls)
    end
  end

  defp class_string(nil), do: nil

  defp class_string(s) when is_binary(s) do
    case String.trim(s) do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp class_string(_), do: nil

  defp action_label_html(label) when is_binary(label), do: label
  defp action_label_html(_), do: nil

  defp encode_js_ops(%JS{} = js), do: Phoenix.json_library().encode!(js.ops)

  defp legal_priority(nil), do: nil
  defp legal_priority(n) when is_integer(n) and n in 1..8, do: n

  defp legal_priority(n) when is_binary(n) do
    n
    |> String.trim()
    |> Integer.parse()
    |> priority_from_parse()
  end

  defp legal_priority(_), do: nil

  defp priority_from_parse({p, _}) when p in 1..8, do: p
  defp priority_from_parse(_), do: nil

  def create_detail(title, description, type, opts) when is_list(opts) do
    opts
    |> Keyword.get(:duration, 5000)
    |> base_create_map(title, description, type)
    |> apply_create_opts(opts)
  end

  def create_server_data(group_id, title, description, type, opts) when is_list(opts) do
    opts
    |> Keyword.get(:duration, 5000)
    |> base_create_map(title, description, type)
    |> Map.put(:groupId, group_id)
    |> apply_create_opts(opts)
  end

  defp base_create_map(duration, title, description, type) do
    %{
      title: title,
      description: description,
      type: type_string(type),
      duration: duration_value(duration)
    }
  end

  defp apply_create_opts(map, opts) do
    map
    |> maybe_put(:id, Keyword.get(opts, :id))
    |> put_optional_true(:loading, Keyword.get(opts, :loading, false))
    |> maybe_put(:action, normalize_action(Keyword.get(opts, :action)))
    |> maybe_put(:priority, legal_priority(Keyword.get(opts, :priority)))
  end

  defp put_optional_true(map, :loading, true), do: Map.put(map, :loading, true)
  defp put_optional_true(map, :loading, _), do: map

  def update_detail(toast_id, attrs) when is_list(attrs) do
    update_detail(toast_id, Map.new(attrs))
  end

  def update_detail(toast_id, attrs) when is_map(attrs) do
    Enum.reduce(attrs, %{id: toast_id}, &reduce_update_attr/2)
  end

  defp reduce_update_attr({k, v}, acc) do
    case update_attr_key(k) do
      nil ->
        acc

      nk when nk in [:id, :groupId] ->
        acc

      _nk when is_nil(v) ->
        acc

      nk ->
        put_update_attr(acc, nk, v)
    end
  end

  defp put_update_attr(acc, nk, v) do
    case update_attr_value(nk, v) do
      :drop -> acc
      val -> Map.put(acc, nk, val)
    end
  end

  defp update_attr_key(k) when is_atom(k) and k not in [:id, :groupId], do: k

  defp update_attr_key(k) when is_binary(k) do
    Map.get(@update_attr_strings, k)
  end

  defp update_attr_key(_), do: nil

  defp update_attr_value(:type, v), do: type_string(v)
  defp update_attr_value(:duration, v), do: duration_value(v)
  defp update_attr_value(:action, v), do: normalize_action(v)

  defp update_attr_value(:priority, v) do
    case legal_priority(v) do
      nil -> :drop
      n -> n
    end
  end

  defp update_attr_value(_, v), do: v

  def update_server_data(group_id, toast_id, attrs) when is_list(attrs) do
    update_server_data(group_id, toast_id, Map.new(attrs))
  end

  def update_server_data(group_id, toast_id, attrs) when is_map(attrs) do
    toast_id
    |> update_detail(attrs)
    |> Map.put(:groupId, group_id)
  end
end
