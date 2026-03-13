defmodule Corex.New.Web do
  @moduledoc false
  use Corex.New.Generator
  alias Corex.New.{Project}

  @pre "corex_umbrella/apps/app_name_web"

  template(:new, [
    {:prod_config, :project, "#{@pre}/config/runtime.exs": "config/runtime.exs"},
    {:config, :project,
     "#{@pre}/config/config.exs": "config/config.exs",
     "#{@pre}/config/dev.exs": "config/dev.exs",
     "#{@pre}/config/prod.exs": "config/prod.exs",
     "#{@pre}/config/test.exs": "config/test.exs"},
    {:keep, :web,
     "corex_web/controllers": "lib/:web_app/controllers",
     "corex_test/channels": "test/:web_app/channels",
     "corex_test/controllers": "test/:web_app/controllers"},
    {:eex, :web,
     "#{@pre}/lib/app_name.ex": "lib/:web_app.ex",
     "#{@pre}/lib/app_name/application.ex": "lib/:web_app/application.ex",
     "corex_web/endpoint.ex": "lib/:web_app/endpoint.ex",
     "corex_web/router.ex": "lib/:web_app/router.ex",
     "corex_web/telemetry.ex": "lib/:web_app/telemetry.ex",
     "corex_web/controllers/error_json.ex": "lib/:web_app/controllers/error_json.ex",
     "#{@pre}/mix.exs": "mix.exs",
     "#{@pre}/README.md": "README.md",
     "#{@pre}/gitignore": ".gitignore",
     "#{@pre}/test/test_helper.exs": "test/test_helper.exs",
     "corex_test/support/conn_case.ex": "test/support/conn_case.ex",
     "corex_test/controllers/error_json_test.exs": "test/:web_app/controllers/error_json_test.exs",
     "#{@pre}/formatter.exs": ".formatter.exs"}
  ])

  template(:gettext, [
    {:eex, :web,
     "corex_gettext/gettext.ex": "lib/:web_app/gettext.ex",
     "corex_gettext/en/LC_MESSAGES/errors.po": "priv/gettext/en/LC_MESSAGES/errors.po",
     "corex_gettext/errors.pot": "priv/gettext/errors.pot",
     "corex_gettext/default.pot": "priv/gettext/default.pot",
     "corex_gettext/en/LC_MESSAGES/default.po": "priv/gettext/en/LC_MESSAGES/default.po"}
  ])

  template(:html, [
    {:eex, :web,
     "corex_web/components/layouts.ex": "lib/:web_app/components/layouts.ex",
     "corex_web/controllers/page_controller.ex": "lib/:web_app/controllers/page_controller.ex",
     "corex_web/controllers/error_html.ex": "lib/:web_app/controllers/error_html.ex",
     "corex_web/controllers/error_html/404.html.heex":
       "lib/:web_app/controllers/error_html/404.html.heex",
     "corex_web/controllers/page_html.ex": "lib/:web_app/controllers/page_html.ex",
     "corex_web/controllers/page_html/home.html.heex":
       "lib/:web_app/controllers/page_html/home.html.heex",
     "corex_test/controllers/page_controller_test.exs":
       "test/:web_app/controllers/page_controller_test.exs",
     "corex_test/controllers/error_html_test.exs": "test/:web_app/controllers/error_html_test.exs",
     "corex_assets/topbar.js": "assets/vendor/topbar.js",
     "corex_web/components/layouts/root.html.heex": "lib/:web_app/components/layouts/root.html.heex"},
    {:eex, :web, "corex_assets/logo.svg": "priv/static/images/logo.svg"}
  ])

  template(:a11y, [
    {:eex, :web,
     "corex_test/controllers/page_controller_a11y_test.exs":
       "test/:web_app/controllers/page_controller_a11y_test.exs"}
  ])

  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    web_path = Path.expand(project.base_path)
    project_path = Path.dirname(Path.dirname(web_path))

    %{
      project
      | in_umbrella?: true,
        project_path: project_path,
        web_path: web_path,
        web_app: app,
        generators: [context_app: false],
        web_namespace: project.app_mod
    }
  end

  def generate(%Project{} = project) do
    inject_umbrella_config_defaults(project)
    copy_from(project, __MODULE__, :new)

    if Project.html?(project), do: gen_html(project)
    if project.binding[:a11y], do: copy_from(project, __MODULE__, :a11y)
    if Project.gettext?(project), do: gen_gettext(project)

    Corex.New.Single.gen_assets(project)
    project
  end

  defp gen_html(%Project{} = project) do
    copy_from(project, __MODULE__, :html)
  end

  defp gen_gettext(%Project{} = project) do
    copy_from(project, __MODULE__, :gettext)
  end
end
