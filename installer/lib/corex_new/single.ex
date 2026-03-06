defmodule Corex.New.Single do
  @moduledoc false
  use Corex.New.Generator
  alias Corex.New.{Project}

  template(:new, [
    {:config, :project,
     "corex_single/config/config.exs": "config/config.exs",
     "corex_single/config/dev.exs": "config/dev.exs",
     "corex_single/config/prod.exs": "config/prod.exs",
     "corex_single/config/runtime.exs": "config/runtime.exs",
     "corex_single/config/test.exs": "config/test.exs"},
    {:eex, :web,
     "corex_single/lib/app_name/application.ex": "lib/:app/application.ex",
     "corex_single/lib/app_name.ex": "lib/:app.ex",
     "corex_web/controllers/error_json.ex": "lib/:lib_web_name/controllers/error_json.ex",
     "corex_web/endpoint.ex": "lib/:lib_web_name/endpoint.ex",
     "corex_web/router.ex": "lib/:lib_web_name/router.ex",
     "corex_web/telemetry.ex": "lib/:lib_web_name/telemetry.ex",
     "corex_single/lib/app_name_web.ex": "lib/:lib_web_name.ex",
     "corex_single/mix.exs": "mix.exs",
     "corex_single/README.md": "README.md",
     "corex_single/formatter.exs": ".formatter.exs",
     "corex_single/gitignore": ".gitignore",
     "corex_test/support/conn_case.ex": "test/support/conn_case.ex",
     "corex_single/test/test_helper.exs": "test/test_helper.exs",
     "corex_test/controllers/error_json_test.exs":
       "test/:lib_web_name/controllers/error_json_test.exs"},
    {:keep, :web,
     "corex_web/controllers": "lib/:lib_web_name/controllers",
     "corex_test/controllers": "test/:lib_web_name/controllers"}
  ])

  template(:gettext, [
    {:eex, :web,
     "corex_gettext/gettext.ex": "lib/:lib_web_name/gettext.ex",
     "corex_gettext/errors.pot": "priv/gettext/errors.pot",
     "corex_gettext/default.pot": "priv/gettext/default.pot",
     "corex_gettext/en/LC_MESSAGES/default.po": "priv/gettext/en/LC_MESSAGES/default.po"}
  ])

  template(:html, [
    {:eex, :web,
     "corex_web/controllers/error_html.ex": "lib/:lib_web_name/controllers/error_html.ex",
     "corex_test/controllers/error_html_test.exs":
       "test/:lib_web_name/controllers/error_html_test.exs",
     "corex_web/controllers/page_controller.ex": "lib/:lib_web_name/controllers/page_controller.ex",
     "corex_web/controllers/page_html.ex": "lib/:lib_web_name/controllers/page_html.ex",
     "corex_web/controllers/page_html/home.html.heex":
       "lib/:lib_web_name/controllers/page_html/home.html.heex",
     "corex_web/live/example_live.ex": "lib/:lib_web_name/live/example_live.ex",
    "corex_test/controllers/page_controller_test.exs":
       "test/:lib_web_name/controllers/page_controller_test.exs",
    "corex_test/live/example_live_test.exs":
       "test/:lib_web_name/live/example_live_test.exs",
    "corex_web/components/layouts/root.html.heex":
       "lib/:lib_web_name/components/layouts/root.html.heex",
     "corex_web/components/layouts.ex": "lib/:lib_web_name/components/layouts.ex"},
    {:eex, :web, "corex_assets/logo.svg": "priv/static/images/logo.svg"}
  ])

  template(:a11y, [
    {:eex, :web,
     "corex_test/controllers/page_controller_a11y_test.exs":
       "test/:lib_web_name/controllers/page_controller_a11y_test.exs"}
  ])

  template(:ecto, [
    {:eex, :app,
     "corex_ecto/repo.ex": "lib/:app/repo.ex",
     "corex_ecto/formatter.exs": "priv/repo/migrations/.formatter.exs",
     "corex_ecto/seeds.exs": "priv/repo/seeds.exs",
     "corex_ecto/data_case.ex": "test/support/data_case.ex"},
    {:keep, :app, "corex_ecto/priv/repo/migrations": "priv/repo/migrations"}
  ])

  template(:css, [
    {:eex, :web,
     "corex_assets/app.css": "assets/css/app.css",
     "corex_assets/heroicons.js": "assets/vendor/heroicons.js"}
  ])

  template(:js, [
    {:eex, :web,
     "corex_assets/app.js": "assets/js/app.js",
     "corex_assets/topbar.js": "assets/vendor/topbar.js",
     "corex_assets/tsconfig.json": "assets/tsconfig.json"}
  ])

  template(:static, [
    {:text, :web,
     "corex_static/robots.txt": "priv/static/robots.txt",
     "corex_static/favicon.ico": "priv/static/favicon.ico"}
  ])

  template(:mailer, [
    {:eex, :app, "corex_mailer/lib/app_name/mailer.ex": "lib/:app/mailer.ex"}
  ])

  template(:mode, [
    {:eex, :web,
     "corex_web/plugs/mode.ex": "lib/:lib_web_name/plugs/mode.ex",
     "corex_web/live/hooks/mode_live.ex": "lib/:lib_web_name/live/hooks/mode_live.ex",
     "corex_test/plugs/mode_test.exs": "test/:lib_web_name/plugs/mode_test.exs",
     "corex_test/controllers/mode_controller_test.exs":
       "test/:lib_web_name/controllers/mode_controller_test.exs",
     "corex_test/live/mode_live_test.exs": "test/:lib_web_name/live/mode_live_test.exs"}
  ])

  template(:theme, [
    {:eex, :web,
     "corex_web/plugs/theme.ex": "lib/:lib_web_name/plugs/theme.ex",
     "corex_web/live/hooks/theme_live.ex": "lib/:lib_web_name/live/hooks/theme_live.ex"}
  ])

  template(:language, [
    {:eex, :web,
     "corex_web/plugs/locale.ex": "lib/:lib_web_name/plugs/locale.ex",
     "corex_web/shared_events.ex": "lib/:lib_web_name/shared_events.ex"}
  ])

  template(:cldr, [
    {:eex, :app,
     "corex_cldr/cldr.ex": "lib/:app/cldr.ex"}
  ])

  def prepare_project(%Project{app: app, base_path: base_path} = project) when not is_nil(app) do
    if in_umbrella?(base_path) do
      %{project | in_umbrella?: true, project_path: Path.dirname(Path.dirname(base_path))}
    else
      %{project | in_umbrella?: false, project_path: base_path}
    end
    |> put_app()
    |> put_root_app()
    |> put_web_app()
  end

  defp put_app(%Project{base_path: base_path} = project) do
    %{project | app_path: base_path}
  end

  defp put_root_app(%Project{app: app, opts: opts} = project) do
    %{
      project
      | root_app: app,
        root_mod: Module.concat([opts[:module] || Macro.camelize(app)])
    }
  end

  defp put_web_app(%Project{app: app} = project) do
    %{
      project
      | web_app: app,
        lib_web_name: "#{app}_web",
        web_namespace: Module.concat(["#{project.root_mod}Web"]),
        web_path: project.base_path
    }
  end

  def generate(%Project{} = project) do
    copy_from(project, __MODULE__, :new)

    generate_agents_md(project)

    if Project.ecto?(project), do: gen_ecto(project)
    if Project.html?(project), do: gen_html(project)
    if project.binding[:a11y], do: copy_from(project, __MODULE__, :a11y)
    if project.binding[:mode], do: copy_from(project, __MODULE__, :mode)
    if project.binding[:theme], do: copy_from(project, __MODULE__, :theme)
    if project.binding[:language_switcher] do
      copy_from(project, __MODULE__, :language)
      copy_from(project, __MODULE__, :cldr)
    end
    if Project.mailer?(project), do: gen_mailer(project)
    if Project.gettext?(project), do: gen_gettext(project)

    gen_assets(project)
    if Project.html?(project) and project.binding[:design], do: gen_design(project)
    project
  end

  def gen_design(%Project{} = project) do
    design_src = Path.expand("../../templates/corex_design", __DIR__)
    dest = Project.join_path(project, :web, "assets/corex")
    designex = project.binding[:designex]

    if File.dir?(design_src) do
      File.mkdir_p!(Path.dirname(dest))
      File.cp_r!(design_src, dest)
      unless designex do
        design_subfolder = Path.join(dest, "design")
        if File.exists?(design_subfolder), do: File.rm_rf!(design_subfolder)
      end
    end
  end

  def gen_html(project) do
    copy_from(project, __MODULE__, :html)
  end

  def gen_gettext(project) do
    copy_from(project, __MODULE__, :gettext)
    gen_locale_errors(project)
  end

  defp gen_locale_errors(project) do
    locales = project.binding[:locales] || ["en"]
    ecto = project.binding[:ecto]
    template_path = Path.expand("../../templates/corex_gettext/locale_errors.po.eex", __DIR__)

    for locale <- locales do
      path =
        project
        |> Project.join_path(:web, "priv/gettext/#{locale}/LC_MESSAGES/errors.po")

      content = EEx.eval_file(template_path, locale: locale, ecto: ecto)
      File.mkdir_p!(Path.dirname(path))
      Mix.Generator.create_file(path, content)
    end
  end

  def gen_ecto(project) do
    copy_from(project, __MODULE__, :ecto)
    gen_ecto_config(project)
  end

  def gen_assets(%Project{} = project) do
    copy_from(project, __MODULE__, :static)
    copy_from(project, __MODULE__, :js)

    if project.binding[:tailwind] do
      copy_from(project, __MODULE__, :css)
    else
      copy_default_css(project)
    end
  end

  defp copy_default_css(%Project{} = project) do
    src = Path.expand("../../templates/corex_static/default.css", __DIR__)
    dest = Project.join_path(project, :web, "priv/static/assets/css/app.css")
    File.mkdir_p!(Path.dirname(dest))
    File.cp!(src, dest)
  end

  def gen_mailer(%Project{} = project) do
    copy_from(project, __MODULE__, :mailer)
  end
end
