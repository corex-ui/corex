defmodule E2eWeb.SignaturePaths do
  @moduledoc false

  def path_d_list(nil), do: []
  def path_d_list(""), do: []

  def path_d_list(signature) when is_list(signature) do
    Enum.flat_map(signature, fn
      d when is_binary(d) and d != "" -> [d]
      %{"d" => d} when is_binary(d) and d != "" -> [d]
      %{d: d} when is_binary(d) and d != "" -> [d]
      _ -> []
    end)
  end

  def path_d_list(signature) when is_binary(signature) do
    case Jason.decode(signature) do
      {:ok, paths} when is_list(paths) -> from_json_list(paths)
      _ -> from_plaintext(signature)
    end
  end

  def path_view_box([]), do: "0 0 400 200"

  def path_view_box(path_d_values) when is_list(path_d_values) do
    path_d_values
    |> Enum.flat_map(&path_numbers/1)
    |> case do
      [] ->
        "0 0 400 200"

      nums ->
        {xs, ys} =
          nums
          |> Enum.with_index()
          |> Enum.split_with(fn {_, i} -> rem(i, 2) == 0 end)

        xs = Enum.map(xs, fn {n, _} -> n end)
        ys = Enum.map(ys, fn {n, _} -> n end)

        min_x = Enum.min(xs)
        max_x = Enum.max(xs)
        min_y = Enum.min(ys)
        max_y = Enum.max(ys)
        pad = 4.0
        x = min_x - pad
        y = min_y - pad
        w = max(max_x - min_x, 1.0) + pad * 2
        h = max(max_y - min_y, 1.0) + pad * 2
        "#{x} #{y} #{w} #{h}"
    end
  end

  defp path_numbers(d) when is_binary(d) do
    ~r/-?\d+(?:\.\d+)?/
    |> Regex.scan(d)
    |> List.flatten()
    |> Enum.map(fn s ->
      {n, _} = Float.parse(s)
      n
    end)
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
