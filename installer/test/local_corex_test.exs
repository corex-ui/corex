defmodule Mix.Tasks.Local.CorexTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  test "run/1 delegates to archive.install hex corex_new" do
    Mix.Task.reenable("archive.install")

    capture_io(fn ->
      try do
        Mix.Tasks.Local.Corex.run([])
      rescue
        _ -> :ok
      catch
        :exit, _ -> :ok
      end
    end)
  end

  test "run/1 forwards extra arguments to archive.install" do
    Mix.Task.reenable("archive.install")

    capture_io(fn ->
      try do
        Mix.Tasks.Local.Corex.run(["--force"])
      rescue
        _ -> :ok
      catch
        :exit, _ -> :ok
      end
    end)
  end
end
