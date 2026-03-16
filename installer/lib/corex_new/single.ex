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
     "corex_gettext/en/LC_MESSAGES/default.po": "priv/gettext/en/LC_MESSAGES/default.po",
     "corex_gettext/locale_errors.po.eex": nil}
  ])

  template(:html, [
    {:eex, :web,
     "corex_web/controllers/error_html.ex": "lib/:lib_web_name/controllers/error_html.ex",
     "corex_web/controllers/error_html/404.html.heex":
       "lib/:lib_web_name/controllers/error_html/404.html.heex",
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

  template(:no_css, [
    {:text, :web,
     "corex_static/default.css": "priv/static/assets/css/app.css"}
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

  template(:design, [
    {:text, :web,
     "corex_design/components/accordion.css": "assets/corex/components/accordion.css",
     "corex_design/components/angle-slider.css": "assets/corex/components/angle-slider.css",
     "corex_design/components/avatar.css": "assets/corex/components/avatar.css",
     "corex_design/components/badge.css": "assets/corex/components/badge.css",
     "corex_design/components/button.css": "assets/corex/components/button.css",
     "corex_design/components/carousel.css": "assets/corex/components/carousel.css",
     "corex_design/components/checkbox.css": "assets/corex/components/checkbox.css",
     "corex_design/components/clipboard.css": "assets/corex/components/clipboard.css",
     "corex_design/components/code.css": "assets/corex/components/code.css",
     "corex_design/components/collapsible.css": "assets/corex/components/collapsible.css",
     "corex_design/components/color-picker.css": "assets/corex/components/color-picker.css",
     "corex_design/components/combobox.css": "assets/corex/components/combobox.css",
     "corex_design/components/data-list.css": "assets/corex/components/data-list.css",
     "corex_design/components/data-table.css": "assets/corex/components/data-table.css",
     "corex_design/components/date-picker.css": "assets/corex/components/date-picker.css",
     "corex_design/components/dialog.css": "assets/corex/components/dialog.css",
     "corex_design/components/editable.css": "assets/corex/components/editable.css",
     "corex_design/components/floating-panel.css": "assets/corex/components/floating-panel.css",
     "corex_design/components/icon.css": "assets/corex/components/icon.css",
     "corex_design/components/layout.css": "assets/corex/components/layout.css",
     "corex_design/components/layout-heading.css": "assets/corex/components/layout-heading.css",
     "corex_design/components/link.css": "assets/corex/components/link.css",
     "corex_design/components/listbox.css": "assets/corex/components/listbox.css",
     "corex_design/components/marquee.css": "assets/corex/components/marquee.css",
     "corex_design/components/menu.css": "assets/corex/components/menu.css",
     "corex_design/components/native-input.css": "assets/corex/components/native-input.css",
     "corex_design/components/number-input.css": "assets/corex/components/number-input.css",
     "corex_design/components/password-input.css": "assets/corex/components/password-input.css",
     "corex_design/components/pin-input.css": "assets/corex/components/pin-input.css",
     "corex_design/components/radio-group.css": "assets/corex/components/radio-group.css",
     "corex_design/components/scrollbar.css": "assets/corex/components/scrollbar.css",
     "corex_design/components/select.css": "assets/corex/components/select.css",
     "corex_design/components/signature-pad.css": "assets/corex/components/signature-pad.css",
     "corex_design/components/switch.css": "assets/corex/components/switch.css",
     "corex_design/componesnts/tabs.css": "assets/corex/components/tabs.css",
     "corex_design/components/timer.css": "assets/corex/components/timer.css",
     "corex_design/components/tooltip.css": "assets/corex/components/tooltip.css",
     "corex_design/components/toast.css": "assets/corex/components/toast.css",
     "corex_design/components/toggle-group.css": "assets/corex/components/toggle-group.css",
     "corex_design/components/tree-view.css": "assets/corex/components/tree-view.css",
     "corex_design/components/typo.css": "assets/corex/components/typo.css",
     "corex_design/design/build.mjs": "assets/corex/design/build.mjs",
     "corex_design/design/tokens/$metadata.json": "assets/corex/design/tokens/$metadata.json",
     "corex_design/design/tokens/semantic/border.json": "assets/corex/design/tokens/semantic/border.json",
     "corex_design/design/tokens/semantic/color.json": "assets/corex/design/tokens/semantic/color.json",
     "corex_design/design/tokens/semantic/dimension.json": "assets/corex/design/tokens/semantic/dimension.json",
     "corex_design/design/tokens/semantic/effect.json": "assets/corex/design/tokens/semantic/effect.json",
     "corex_design/design/tokens/semantic/font.json": "assets/corex/design/tokens/semantic/font.json",
     "corex_design/design/tokens/semantic/text.json": "assets/corex/design/tokens/semantic/text.json",
     "corex_design/design/tokens/themes/duo/dark.json": "assets/corex/design/tokens/themes/duo/dark.json",
     "corex_design/design/tokens/themes/duo/light.json": "assets/corex/design/tokens/themes/duo/light.json",
     "corex_design/design/tokens/themes/leo/dark.json": "assets/corex/design/tokens/themes/leo/dark.json",
     "corex_design/design/tokens/themes/leo/light.json": "assets/corex/design/tokens/themes/leo/light.json",
     "corex_design/design/tokens/themes/neo/dark.json": "assets/corex/design/tokens/themes/neo/dark.json",
     "corex_design/design/tokens/themes/neo/light.json": "assets/corex/design/tokens/themes/neo/light.json",
     "corex_design/design/tokens/themes/uno/dark.json": "assets/corex/design/tokens/themes/uno/dark.json",
     "corex_design/design/tokens/themes/uno/light.json": "assets/corex/design/tokens/themes/uno/light.json",
     "corex_design/design/transform.mjs": "assets/corex/design/transform.mjs",
     "corex_design/main.css": "assets/corex/main.css",
     "corex_design/tokens.css": "assets/corex/tokens.css",
     "corex_design/tokens/semantic/border.css": "assets/corex/tokens/semantic/border.css",
     "corex_design/tokens/semantic/color.css": "assets/corex/tokens/semantic/color.css",
     "corex_design/tokens/semantic/dimension.css": "assets/corex/tokens/semantic/dimension.css",
     "corex_design/tokens/semantic/effect.css": "assets/corex/tokens/semantic/effect.css",
     "corex_design/tokens/semantic/font.css": "assets/corex/tokens/semantic/font.css",
     "corex_design/tokens/semantic/text.css": "assets/corex/tokens/semantic/text.css",
     "corex_design/tokens/themes/duo/dark.css": "assets/corex/tokens/themes/duo/dark.css",
     "corex_design/tokens/themes/duo/light.css": "assets/corex/tokens/themes/duo/light.css",
     "corex_design/tokens/themes/leo/dark.css": "assets/corex/tokens/themes/leo/dark.css",
     "corex_design/tokens/themes/leo/light.css": "assets/corex/tokens/themes/leo/light.css",
     "corex_design/tokens/themes/neo/dark.css": "assets/corex/tokens/themes/neo/dark.css",
     "corex_design/tokens/themes/neo/light.css": "assets/corex/tokens/themes/neo/light.css",
     "corex_design/tokens/themes/uno/dark.css": "assets/corex/tokens/themes/uno/dark.css",
     "corex_design/tokens/themes/uno/light.css": "assets/corex/tokens/themes/uno/light.css",
     "corex_design/utilities.css": "assets/corex/utilities.css"}
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
    copy_from(project, __MODULE__, :design)

    unless project.binding[:designex] do
      design_subfolder = Project.join_path(project, :web, "assets/corex/design")
      if File.exists?(design_subfolder), do: File.rm_rf!(design_subfolder)
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

    for locale <- locales do
      path =
        project
        |> Project.join_path(:web, "priv/gettext/#{locale}/LC_MESSAGES/errors.po")

      binding = Keyword.merge(project.binding, [locale: locale, ecto: project.binding[:ecto]])
      content = __MODULE__.render(:gettext, "corex_gettext/locale_errors.po.eex", binding)
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
      copy_from(project, __MODULE__, :no_css)
    end
  end

  def gen_mailer(%Project{} = project) do
    copy_from(project, __MODULE__, :mailer)
  end
end
