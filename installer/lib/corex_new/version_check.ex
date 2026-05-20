defmodule Corex.New.VersionCheck do
  @moduledoc false

  def warn_if_outdated(current, latest) when is_binary(current) and is_struct(latest, Version) do
    current = Version.parse!(current)

    if Version.compare(current, latest) == :lt do
      Mix.shell().info([
        :yellow,
        "A new version of corex.new is available:",
        :green,
        " v#{latest}",
        :reset,
        ".",
        "\n",
        "You are currently running ",
        :red,
        "v#{current}",
        :reset,
        ".\n",
        "To update, run:\n\n",
        "    $ mix local.corex\n"
      ])
    end
  end

  if Version.match?(System.version(), "~> 1.18") do
    def start_latest_version_task(package, installer_version) do
      ensure_task_supervisor!()

      Task.Supervisor.async_nolink(Corex.New.VersionCheck.Supervisor, fn ->
        fetch_latest_version(package, installer_version)
      end)
    end

    defp ensure_task_supervisor! do
      case Process.whereis(Corex.New.VersionCheck.Supervisor) do
        pid when is_pid(pid) ->
          :ok

        nil ->
          case Task.Supervisor.start_link(name: Corex.New.VersionCheck.Supervisor) do
            {:ok, _} -> :ok
            {:error, {:already_started, _}} -> :ok
            {:error, _} -> :ok
          end
      end
    end

    def fetch_latest_version(package, installer_version) do
      with {:ok, hex_package} <- fetch_package(package, installer_version) do
        latest_stable_version(hex_package)
      end
    end

    def latest_stable_version(%{"releases" => releases}) when is_list(releases) do
      versions =
        for release <- releases,
            version = Version.parse!(release["version"]),
            version.pre == [] do
          version
        end

      case versions do
        [] -> {:error, :no_releases}
        _ -> Enum.max(versions, Version)
      end
    end

    def latest_stable_version(_), do: {:error, :no_releases}

    def fetch_package(name, installer_version) do
      http_options = [
        ssl: [
          verify: :verify_peer,
          cacerts: :public_key.cacerts_get(),
          depth: 2,
          customize_hostname_check: [
            match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
          ],
          versions: [:"tlsv1.2", :"tlsv1.3"]
        ]
      ]

      options = [body_format: :binary]
      url = String.to_charlist("https://hex.pm/api/packages/#{name}")
      user_agent = String.to_charlist("Corex.New.VersionCheck/#{installer_version}")

      :telemetry.span(
        [:corex_new, :hex, :fetch],
        %{package: name},
        fn ->
          case :httpc.request(
                 :get,
                 {url, [{~c"user-agent", user_agent}]},
                 http_options,
                 options
               ) do
            {:ok, {{_, 200, _}, _headers, body}} ->
              {{:ok, Jason.decode!(body)}, %{status: 200}}

            {:ok, {{_, status, _}, _, _}} ->
              {{:error, status}, %{status: status}}

            {:error, reason} ->
              {{:error, reason}, %{status: :error}}
          end
        end
      )
    end
  else
    def start_latest_version_task(_package, _installer_version), do: nil
  end
end
