defmodule Mix.Corex.Install.Plugs do
  @moduledoc false

  alias Mix.Corex.Install.{Options, Paths, Templates}

  def create_plug_files(igniter, web_mod, app, opts, _multi_locale?) do
    themes = Options.themes_from_opts(opts)
    dir = Path.join([Paths.web_ex_dir(igniter, web_mod), "plugs"])
    web_str = inspect(web_mod)
    app_str = inspect(app)

    igniter =
      if opts[:mode] do
        write_plug(igniter, Path.join(dir, "mode.ex"), Templates.plug_mode(web_str))
      else
        igniter
      end

    igniter =
      if themes != [] do
        write_plug(igniter, Path.join(dir, "theme.ex"), Templates.plug_theme(web_str, app_str))
      else
        igniter
      end

    igniter
  end

  defp write_plug(igniter, path, contents) do
    if Igniter.exists?(igniter, path) do
      igniter
    else
      Igniter.include_or_create_file(igniter, path, contents)
    end
  end
end
