defmodule Mix.Corex.Install.Deps do
  @moduledoc false

  alias Igniter.Project.Deps

  def maybe_add_localize_web_dep(igniter, false), do: igniter

  def maybe_add_localize_web_dep(igniter, true) do
    Deps.add_dep(igniter, {:localize_web, "~> 0.5"})
  end

  def maybe_add_usage_rules(igniter, false), do: igniter

  def maybe_add_usage_rules(igniter, true) do
    if Igniter.exists?(igniter, "mix.exs") do
      igniter
      |> Deps.add_dep({:usage_rules, "~> 1.2", only: [:dev, :test]})
      |> Igniter.update_file("mix.exs", fn source ->
        %{source | content: Mix.Corex.Install.MixProjectUsageRules.apply(source.content)}
      end)
    else
      igniter
    end
  end
end
