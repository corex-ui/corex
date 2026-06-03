defmodule CorexDesign.TestConfig do
  @moduledoc false

  def snapshot, do: Application.get_all_env(:corex_design)

  def reset do
    for {key, _} <- Application.get_all_env(:corex_design) do
      Application.delete_env(:corex_design, key)
    end

    :ok
  end

  def put(config) do
    reset()
    for {key, value} <- config, do: Application.put_env(:corex_design, key, value)
    :ok
  end

  def restore(snapshot) do
    reset()
    for {key, value} <- snapshot, do: Application.put_env(:corex_design, key, value)
    :ok
  end
end

ExUnit.start(exclude: [integration: true, parity_report: true])
