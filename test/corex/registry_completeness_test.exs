defmodule Corex.RegistryCompletenessTest do
  use ExUnit.Case, async: true

  @registry Corex.component_ids()
            |> Map.new(fn id ->
              case Corex.component_spec(id) do
                {:ok, spec} -> {spec.module, spec.function_components}
                :error -> flunk("missing spec for #{id}")
              end
            end)

  test "every registry function component exists on its module" do
    for {mod_str, fns} <- @registry, %{name: name, arity: arity} <- fns do
      mod = mod_str |> String.split(".") |> Module.concat()

      assert {name, arity} in mod.__info__(:functions),
             "#{mod_str}.#{name}/#{arity} is in @components but not defined on module"
    end
  end

  test "documented skeleton helpers are registered" do
    fns = function_components!(:avatar)
    assert Enum.any?(fns, &(&1.name == :avatar_skeleton))

    fns = function_components!(:timer)
    assert Enum.any?(fns, &(&1.name == :timer_skeleton))

    fns = function_components!(:angle_slider)
    assert Enum.any?(fns, &(&1.name == :angle_slider_root))
    assert Enum.any?(fns, &(&1.name == :angle_slider_control))
  end

  defp function_components!(id) do
    case Corex.component_spec(id) do
      {:ok, %{function_components: fns}} -> fns
      :error -> flunk("missing component_spec for #{id}")
    end
  end
end
