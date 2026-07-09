defmodule CorexDesign.TestConfig do
  @moduledoc false

  def snapshot do
    Application.get_all_env(:corex_design)
  end

  def put(config) when is_list(config) do
    for {key, value} <- config do
      Application.put_env(:corex_design, key, value)
    end
  end

  def restore(nil) do
    for {key, _} <- Application.get_all_env(:corex_design) do
      Application.delete_env(:corex_design, key)
    end
  end

  def restore(config) when is_list(config) do
    restore(nil)
    put(config)
  end
end
