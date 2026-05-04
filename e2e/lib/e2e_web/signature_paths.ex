defmodule E2eWeb.SignaturePaths do
  @moduledoc false

  def path_d_list(nil), do: []
  def path_d_list(""), do: []

  def path_d_list(signature) when is_binary(signature) do
    case Jason.decode(signature) do
      {:ok, paths} when is_list(paths) -> from_json_list(paths)
      _ -> from_plaintext(signature)
    end
  end

  defp from_json_list(paths) do
    Enum.flat_map(paths, fn
      d when is_binary(d) and d != "" -> [d]
      %{"d" => d} when is_binary(d) and d != "" -> [d]
      _ -> []
    end)
  end

  defp from_plaintext(s) do
    s
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
