defmodule Corex.Attrs do
  @moduledoc false

  def get_boolean(true), do: ""
  def get_boolean(false), do: nil
  def get_boolean(nil), do: nil

  def get_default_boolean(controlled, value) do
    if !controlled && value, do: "", else: nil
  end

  def get_boolean(controlled, value) do
    if controlled do
      if value, do: "", else: nil
    else
      nil
    end
  end

  def data_state(bool, true_val, false_val), do: if(bool, do: true_val, else: false_val)

  @spec maybe_put(map(), term(), term()) :: map()
  def maybe_put(map, _key, nil), do: map
  def maybe_put(map, key, value), do: Map.put(map, key, value)

  def joined_csv_values([]), do: nil

  def joined_csv_values(values) when is_list(values) do
    Enum.map_join(values, ",", &to_string/1)
  end

  def maybe_put_data_dir(map, nil), do: map
  def maybe_put_data_dir(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "data-dir", dir)
  def maybe_put_data_dir(map, _), do: map

  def maybe_put_dir(map, nil), do: map
  def maybe_put_dir(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "dir", dir)
  def maybe_put_dir(map, _), do: map

  def maybe_put_data_dir_from(map, assigns) when is_map(assigns),
    do: maybe_put_data_dir(map, Map.get(assigns, :dir))

  def maybe_put_dir_from(map, assigns) when is_map(assigns),
    do: maybe_put_dir(map, Map.get(assigns, :dir))

  @spec respond_to_fields(keyword()) :: %{String.t() => String.t()}
  def respond_to_fields(opts) when is_list(opts) do
    case Keyword.get(opts, :respond_to, :server) do
      :both ->
        %{respond_to: "both"}

      :server ->
        %{respond_to: "server"}

      :client ->
        %{respond_to: "client"}

      other ->
        raise ArgumentError,
              "invalid :respond_to, expected :both, :server, or :client, got: #{inspect(other)}"
    end
  end
end
