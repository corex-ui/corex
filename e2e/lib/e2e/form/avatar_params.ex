defmodule E2e.Form.AvatarParams do
  @moduledoc false

  @doc """
  Normalize LiveView / multipart avatar params.

  - Plug.Upload → filename
  - Explicit blank `"avatar"` → keep empty and drop stale `avatar_label`
  - Missing `avatar` → promote non-empty `avatar_label` (LV upload without file)
  """
  def normalize(params) when is_map(params) do
    case Map.get(params, "avatar") do
      %Plug.Upload{filename: name} when is_binary(name) and name != "" ->
        params
        |> Map.put("avatar", name)
        |> Map.delete("avatar_label")

      list when is_list(list) ->
        case Enum.find(list, &match?(%Plug.Upload{filename: name} when name not in [nil, ""], &1)) do
          %Plug.Upload{filename: name} ->
            params
            |> Map.put("avatar", name)
            |> Map.delete("avatar_label")

          _ ->
            clear_or_label(params)
        end

      avatar when is_binary(avatar) ->
        if String.trim(avatar) != "" do
          Map.delete(params, "avatar_label")
        else
          keep_empty(params)
        end

      nil ->
        if Map.has_key?(params, "avatar") do
          keep_empty(params)
        else
          from_label(params)
        end

      _ ->
        from_label(params)
    end
  end

  def normalize(params), do: params

  defp clear_or_label(params) do
    if Map.has_key?(params, "avatar"), do: keep_empty(params), else: from_label(params)
  end

  defp keep_empty(params) do
    params
    |> Map.put("avatar", "")
    |> Map.delete("avatar_label")
  end

  defp from_label(params) do
    case Map.get(params, "avatar_label") do
      label when is_binary(label) ->
        trimmed = String.trim(label)

        if trimmed != "" do
          Map.put(params, "avatar", trimmed)
        else
          params
        end

      _ ->
        params
    end
  end
end
