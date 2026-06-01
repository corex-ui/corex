defmodule Corex.ConnectRegistryContractTest do
  use ExUnit.Case, async: true

  @components_root Path.expand("../../lib/components", __DIR__)

  test "hooked components declare loadable connect modules with props/1" do
    for row <- hooked_wire_rows() do
      mod = row["connect_module"]

      assert is_binary(mod) and mod != "",
             "missing connect_module for #{row["id"]}"

      path = connect_path(mod)
      assert File.exists?(path), "missing connect module file #{path} for #{row["id"]}"

      module = mod |> String.split(".") |> Module.concat()
      assert Code.ensure_loaded?(module), "connect module #{mod} is not loadable"

      content = File.read!(path)

      assert content =~ "def props" or content =~ "def group",
             "#{path} must define props/1 or group/1 for hook wiring"
    end
  end

  test "connect_module follows Corex.<Component>.Connect convention" do
    for row <- hooked_wire_rows() do
      id = row["id"]
      expected = "Corex.#{Macro.camelize(id)}.Connect"

      assert row["connect_module"] == expected,
             "expected #{expected} for #{id}, got #{inspect(row["connect_module"])}"
    end
  end

  test "component_wire connect_module paths match registry ids" do
    wire_ids =
      wire_rows()
      |> Enum.map(& &1["id"])
      |> Enum.sort()

    registry_ids = Corex.component_ids() |> Enum.map(&Atom.to_string/1) |> Enum.sort()
    assert wire_ids == registry_ids
  end

  defp hooked_wire_rows do
    wire_rows() |> Enum.filter(& &1["phx_hook"])
  end

  defp wire_rows do
    Application.app_dir(:corex, "priv/doc/component_wire.json")
    |> File.read!()
    |> Jason.decode!()
  end

  defp connect_path(module_string) do
    module_string
    |> String.replace_prefix("Corex.", "")
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> then(&Path.join([@components_root | &1]))
    |> Kernel.<>(".ex")
  end
end
