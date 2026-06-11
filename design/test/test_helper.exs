defmodule CorexDesign.TestConfig do
  @moduledoc false

  def snapshot do
    %{design: Application.get_env(:corex, Corex.Design)}
  end

  def reset do
    Application.delete_env(:corex, Corex.Design)
    :ok
  end

  def put(config) do
    reset()
    Application.put_env(:corex, Corex.Design, config)
    :ok
  end

  def restore(%{design: design}) do
    reset()

    if design do
      Application.put_env(:corex, Corex.Design, design)
    end

    :ok
  end
end

ExUnit.start(exclude: [integration: true, parity_report: true])
