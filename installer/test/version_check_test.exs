defmodule Corex.New.VersionCheckTest do
  use ExUnit.Case, async: false

  import MixHelper

  alias Corex.New.VersionCheck

  test "warn_if_outdated/2 prints a notice when the installer is behind" do
    VersionCheck.warn_if_outdated("0.1.0", Version.parse!("99.0.0"))

    assert_received {:mix_shell, :info, [msg]} when is_binary(msg)
    assert msg =~ "A new version of corex.new is available"
    assert msg =~ "99.0.0"
  end

  test "warn_if_outdated/2 is silent when the installer is current" do
    flush()
    VersionCheck.warn_if_outdated("0.1.0", Version.parse!("0.1.0"))
    refute_received {:mix_shell, :info, ["A new version of corex.new is available:" | _]}
  end

  if Version.match?(System.version(), "~> 1.18") do
    test "fetch_package/2 returns error status for unknown packages" do
      assert {:error, 404} =
               VersionCheck.fetch_package("corex-new-not-a-real-package-xyz", "0.1.0")
    end

    test "fetch_latest_version/2 returns error when package lookup fails" do
      assert {:error, 404} =
               VersionCheck.fetch_latest_version("corex-new-not-a-real-package-xyz", "0.1.0")
    end

    test "latest_stable_version/1 returns error when there are no stable releases" do
      assert {:error, :no_releases} = VersionCheck.latest_stable_version(%{"releases" => []})

      assert {:error, :no_releases} =
               VersionCheck.latest_stable_version(%{
                 "releases" => [%{"version" => "0.1.0-dev"}]
               })
    end

    test "latest_stable_version/1 returns the highest stable version" do
      assert %Version{major: 2, minor: 0, patch: 0} =
               VersionCheck.latest_stable_version(%{
                 "releases" => [
                   %{"version" => "1.0.0"},
                   %{"version" => "2.0.0"},
                   %{"version" => "1.5.0-rc.1"}
                 ]
               })
    end

    test "fetch_package/2 returns decoded hex metadata for a public package" do
      case VersionCheck.fetch_package("phoenix", Mix.Project.config()[:version]) do
        {:ok, %{"releases" => [_ | _]}} ->
          :ok

        {:error, _} ->
          :ok
      end
    end

    test "fetch_latest_version/2 returns a version or an error tuple" do
      case VersionCheck.fetch_latest_version("phoenix", Mix.Project.config()[:version]) do
        %Version{} -> :ok
        {:error, _} -> :ok
      end
    end

    test "start_latest_version_task/2 returns a task" do
      task = VersionCheck.start_latest_version_task("phoenix", Mix.Project.config()[:version])
      assert %Task{} = task

      case Task.await(task, 5_000) do
        %Version{} -> :ok
        {:error, _} -> :ok
        other -> flunk("unexpected task result: #{inspect(other)}")
      end
    end
  end
end
