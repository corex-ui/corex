defmodule Corex.Toast.Payload do
  @moduledoc false

  alias Phoenix.LiveView.JS

  @toast_type_strings Map.new(~w(info success error warning loading)a, &{&1, Atom.to_string(&1)})

  @redirect_modes ~w(href patch navigate)

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

  def type_string(type) when is_atom(type) do
    Map.get(@toast_type_strings, type, "info")
  end

  def type_string(type) when is_binary(type) and type in ~w(info success error warning loading) do
    type
  end

  def type_string(_), do: "info"

  def duration_value(:infinity), do: "Infinity"
  def duration_value(v), do: v

  def normalize_action(%{"label" => label, "effects" => effects})
      when is_binary(label) and is_list(effects) do
    normalize_action(%{label: label, effects: effects})
  end

  def normalize_action(nil), do: nil

  def normalize_action(%{label: label, effects: effects})
      when is_binary(label) and is_list(effects) do
    normalized = effects |> Enum.map(&normalize_effect/1) |> Enum.reject(&is_nil/1)

    if normalized == [] do
      nil
    else
      %{"label" => label, "effects" => normalized}
    end
  end

  def normalize_action(_), do: nil

  defp normalize_effect(%{"kind" => "push", "event" => event} = m) when is_binary(event) do
    value = Map.get(m, "value", %{})
    %{"kind" => "push", "event" => event, "value" => value}
  end

  defp normalize_effect(%{"kind" => "redirect", "to" => to} = m) when is_binary(to) do
    redirect = Map.get(m, "redirect", "href")
    new_tab = Map.get(m, "newTab", false)

    %{
      "kind" => "redirect",
      "to" => to,
      "redirect" => redirect_mode_string(redirect),
      "newTab" => new_tab
    }
  end

  defp normalize_effect(%{"kind" => "exec_js", "encoded" => encoded}) when is_binary(encoded) do
    %{"kind" => "exec_js", "encoded" => encoded}
  end

  defp normalize_effect(%{kind: :push, event: event} = m) when is_binary(event) do
    value = Map.get(m, :value, %{})
    %{"kind" => "push", "event" => event, "value" => value}
  end

  defp normalize_effect(%{kind: :redirect, to: to} = m) when is_binary(to) do
    redirect = Map.get(m, :redirect, :href)
    new_tab = Map.get(m, :new_tab, false)

    %{
      "kind" => "redirect",
      "to" => to,
      "redirect" => redirect_mode_string(redirect),
      "newTab" => new_tab
    }
  end

  defp normalize_effect(%{kind: :exec_js, encoded: encoded}) when is_binary(encoded) do
    %{"kind" => "exec_js", "encoded" => encoded}
  end

  defp normalize_effect(%{kind: :exec_js, js: %JS{} = js}) do
    %{"kind" => "exec_js", "encoded" => encode_js_ops(js)}
  end

  defp normalize_effect(_), do: nil

  defp encode_js_ops(%JS{} = js), do: Phoenix.json_library().encode!(js.ops)

  defp redirect_mode_string(mode) do
    s =
      cond do
        is_atom(mode) -> Atom.to_string(mode)
        is_binary(mode) -> mode
        true -> "href"
      end

    if s in @redirect_modes, do: s, else: "href"
  end

  defp legal_priority(nil), do: nil

  defp legal_priority(n) when is_integer(n) and n in 1..8, do: n

  defp legal_priority(n) when is_binary(n) do
    case Integer.parse(String.trim(n)) do
      {p, _} -> legal_priority(p)
      :error -> nil
    end
  end

  defp legal_priority(_), do: nil

  def create_detail(title, description, type, opts) when is_list(opts) do
    duration = Keyword.get(opts, :duration, 5000)
    loading = Keyword.get(opts, :loading, false)
    id = Keyword.get(opts, :id)
    action = Keyword.get(opts, :action)
    priority = legal_priority(Keyword.get(opts, :priority))

    base = %{
      title: title,
      description: description,
      type: type_string(type),
      duration: duration_value(duration)
    }

    base
    |> put_optional(:id, id)
    |> put_optional_true(:loading, loading)
    |> put_optional(:action, normalize_action(action))
    |> put_optional(:priority, priority)
  end

  def create_server_data(group_id, title, description, type, opts) when is_list(opts) do
    duration = Keyword.get(opts, :duration, 5000)
    loading = Keyword.get(opts, :loading, false)
    id = Keyword.get(opts, :id)
    action = Keyword.get(opts, :action)
    priority = legal_priority(Keyword.get(opts, :priority))

    base = %{
      groupId: group_id,
      title: title,
      description: description,
      type: type_string(type),
      duration: duration_value(duration)
    }

    base
    |> put_optional(:id, id)
    |> put_optional_true(:loading, loading)
    |> put_optional(:action, normalize_action(action))
    |> put_optional(:priority, priority)
  end

  defp put_optional(map, _k, nil), do: map
  defp put_optional(map, k, v), do: Map.put(map, k, v)

  defp put_optional_true(map, :loading, true), do: Map.put(map, :loading, true)
  defp put_optional_true(map, :loading, _), do: map

  def update_detail(toast_id, attrs) when is_list(attrs) do
    update_detail(toast_id, Map.new(attrs))
  end

  def update_detail(toast_id, attrs) when is_map(attrs) do
    Enum.reduce(attrs, %{id: toast_id}, fn {k, v}, acc ->
      case update_attr_key(k) do
        nil ->
          acc

        nk when nk in [:id, :groupId] ->
          acc

        _nk when is_nil(v) ->
          acc

        nk ->
          case update_attr_value(nk, v) do
            :drop -> acc
            val -> Map.put(acc, nk, val)
          end
      end
    end)
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
    update_detail(toast_id, attrs)
    |> Map.put(:groupId, group_id)
  end
end
