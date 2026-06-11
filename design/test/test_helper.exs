defmodule CorexDesign.TestConfig do
  @moduledoc false

  def snapshot do
    %{
      design: Application.get_env(:corex, Corex.Design),
      legacy: Application.get_all_env(:corex_design)
    }
  end

  def reset do
    Application.delete_env(:corex, Corex.Design)

    for {key, _} <- Application.get_all_env(:corex_design) do
      Application.delete_env(:corex_design, key)
    end

    :ok
  end

  def put(config) do
    reset()
    Application.put_env(:corex, Corex.Design, config)
    :ok
  end

  def restore(%{design: design, legacy: legacy}) do
    reset()

    if design do
      Application.put_env(:corex, Corex.Design, design)
    end

    for {key, value} <- legacy, do: Application.put_env(:corex_design, key, value)
    :ok
  end
end

ExUnit.start(exclude: [integration: true, parity_report: true])
