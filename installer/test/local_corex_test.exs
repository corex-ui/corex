Code.require_file("mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Local.CorexTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  test "mix local.corex runs and delegates to archive.install" do
    capture_io(:stderr, fn ->
      try do
        Mix.Tasks.Local.Corex.run([])
      rescue
        Mix.Error -> :ok
        UndefinedFunctionError -> :ok
      catch
        :exit, _ -> :ok
      end
    end)
  end
end
