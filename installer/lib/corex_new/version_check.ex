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
      Task.async(fn -> fetch_latest_version(package, installer_version) end)
    end

    def fetch_latest_version(package, installer_version) do
      try do
        with {:ok, package} <- fetch_package(package, installer_version) do
          versions =
            for release <- package["releases"],
                version = Version.parse!(release["version"]),
                version.pre == [] do
              version
            end

          Enum.max(versions, Version)
        end
      rescue
        e -> {:error, e}
      catch
        :exit, _ -> {:error, :exit}
      end
    end

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

      case :httpc.request(
             :get,
             {~c"https://hex.pm/api/packages/#{name}",
              [{~c"user-agent", ~c"Corex.New.VersionCheck/#{installer_version}"}]},
             http_options,
             options
           ) do
        {:ok, {{_, 200, _}, _headers, body}} ->
          {:ok, Jason.decode!(body)}

        {:ok, {{_, status, _}, _, _}} ->
          {:error, status}

        {:error, reason} ->
          {:error, reason}
      end
    end
  else
    def start_latest_version_task(_package, _installer_version), do: nil
  end
end
