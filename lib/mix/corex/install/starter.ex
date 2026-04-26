defmodule Mix.Corex.Install.Starter do
  @moduledoc false

  alias Mix.Corex.Install.{Layouts, Paths, Templates}

  def add_corex_page_and_layout(igniter, web_mod, themes, opts, _i18n?) do
    w = Paths.web_ex_dir(igniter, web_mod)
    ws = inspect(web_mod)
    c_path = Path.join([w, "controllers", "corex_page_controller.ex"])
    h_path = Path.join([w, "controllers", "corex_page_html.ex"])
    i_path = Path.join([w, "controllers", "corex_page", "index.html.heex"])
    layouts_dir = Path.join([w, "components", "layouts"])
    corex_layout_path = Path.join([layouts_dir, "corex.html.heex"])

    ctrl = """
    defmodule #{ws}.CorexPageController do
      use #{ws}, :controller

      def index(conn, _params) do
        render(conn, :index, layout: {#{ws}.Layouts, :corex})
      end
    end
    """

    phtml = """
    defmodule #{ws}.CorexPageHTML do
      use #{ws}, :html

      embed_templates "corex_page/*"
    end
    """

    index = String.trim_trailing(Templates.corex_starter_index()) <> "\n"
    corex_lay = String.trim_trailing(Templates.corex_layout()) <> "\n"

    igniter
    |> Igniter.include_or_create_file(c_path, String.trim_trailing(ctrl) <> "\n")
    |> Igniter.include_or_create_file(h_path, String.trim_trailing(phtml) <> "\n")
    |> Igniter.create_new_file(i_path, index, on_exists: :skip)
    |> Igniter.create_new_file(corex_layout_path, corex_lay, on_exists: :skip)
    |> then(fn i ->
      r_path = Igniter.Project.Module.proper_location(i, Module.concat(web_mod, Router))

      Igniter.update_file(i, r_path, fn source ->
        c = source.content
        c = if String.contains?(c, "CorexPageController"), do: c, else: corex_route_snippet(c)
        %{source | content: c}
      end)
    end)
    |> then(fn i ->
      if opts[:mode] || themes != [] do
        Igniter.update_file(i, corex_layout_path, fn s ->
          case Layouts.insert_theme_mode_switchers(s) do
            {:notice, _} -> s
            s2 -> s2
          end
        end)
      else
        i
      end
    end)
  end

  defp corex_route_snippet(content) do
    if String.contains?(content, "CorexPageController") or
         String.contains?(content, "get \"/corex\"") do
      content
    else
      content2 =
        String.replace(
          content,
          "    get \"/\", PageController, :home\n",
          "    get \"/\", PageController, :home\n    get \"/corex\", CorexPageController, :index\n",
          global: false
        )

      if String.contains?(content2, "get \"/corex\"") do
        content2
      else
        String.replace(
          content2,
          "pipe_through :browser\n",
          "pipe_through :browser\n\n    get \"/corex\", CorexPageController, :index\n",
          global: false
        )
      end
    end
  end
end
