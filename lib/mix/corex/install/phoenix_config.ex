defmodule Mix.Corex.Install.PhoenixConfig do
  @moduledoc false

  def configure_phoenix_defaults(igniter, web_mod) do
    gettext_backend = Module.concat(web_mod, Gettext)

    igniter
    |> Igniter.Project.Config.configure_new("config.exs", :phoenix, [:json_library], Jason)
    |> Igniter.Project.Config.configure_new(
      "config.exs",
      :phoenix,
      [:gettext_backend],
      gettext_backend
    )
  end

  def maybe_configure_localize_runtime(igniter, _web_mod, false), do: igniter

  def maybe_configure_localize_runtime(igniter, web_mod, true) do
    gettext_backend = Module.concat(web_mod, Gettext)

    block =
      "config :localize,\n  supported_locales: Gettext.known_locales(#{inspect(gettext_backend)}) |> Enum.map(&String.to_atom/1)\n"

    path = "config/runtime.exs"

    if Igniter.exists?(igniter, path) do
      Igniter.update_file(igniter, path, fn source ->
        content = source.content

        if String.contains?(content, "Gettext.known_locales(#{inspect(gettext_backend)})") do
          source
        else
          base =
            if String.contains?(String.trim_leading(content), "import Config") do
              content
            else
              "import Config\n\n" <> String.trim_leading(content)
            end

          %{source | content: String.trim_trailing(base) <> "\n\n" <> block}
        end
      end)
    else
      Igniter.include_or_create_file(igniter, path, "import Config\n\n" <> block)
    end
  end

  def configure_app_env(igniter, app, themes) do
    if themes != [] do
      Igniter.Project.Config.configure_new(igniter, "config.exs", app, [:themes], themes)
    else
      igniter
    end
  end

  def configure_designex(igniter, opts) do
    if !opts[:designex] do
      igniter
    else
      block = """

      config :designex,
        version: "1.0.2",
        commit: "1da4b31",
        cd: Path.expand("../assets", __DIR__),
        dir: "corex",
        corex: [
          build_args: ~w(--dir=design --script=build.mjs --tokens=tokens)
        ]
      """

      Igniter.update_file(igniter, "config/config.exs", fn source ->
        content = source.content

        if String.contains?(content, "config :designex") do
          source
        else
          %{source | content: String.trim_trailing(content) <> block}
        end
      end)
    end
  end

  def configure_test_phoenix(igniter) do
    path = "test.exs"

    if Igniter.exists?(igniter, path) do
      Igniter.Project.Config.configure_new(
        igniter,
        path,
        :phoenix,
        [:sort_verified_routes_query_params],
        true
      )
    else
      igniter
    end
  end
end
