defmodule Mix.Corex.Install.EsbuildFlags do
  @moduledoc false

  def insert_into_config(content) when is_binary(content) do
    if String.contains?(content, "--format=esm") do
      content
    else
      if String.contains?(content, "config :esbuild") and String.contains?(content, "--bundle") do
        String.replace(content, "--bundle", "--bundle --format=esm --splitting", global: false)
      else
        content
      end
    end
  end
end
