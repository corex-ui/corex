defmodule CorexWeb.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :corex_web

  def migrate do
    load_app()

    for repo <- repos() do
      run_migrations(repo, :up, all: true)
    end
  end

  def rollback(repo, version) do
    load_app()
    run_migrations(repo, :down, to: version)
  end

  defp run_migrations(repo, direction, opts) do
    case Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, direction, opts)) do
      {:ok, _, _} ->
        :ok

      {:error, error} ->
        raise "failed to run migrations for #{inspect(repo)}: #{inspect(error)}"
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    # Many platforms require SSL when connecting to the database
    Application.ensure_all_started(:ssl)
    Application.ensure_loaded(@app)
  end
end
