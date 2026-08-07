defmodule Corex.Integration.CodeGeneration.TableauScaffoldTest do
  @moduledoc """
  End-to-end `mix corex.tableau.new` coverage: compile --warnings-as-errors,
  assets/tableau build, and scaffold content for nav/tags/mdex.
  """
  use Corex.Integration.CodeGeneratorCase, async: false

  @moduletag :extended

  describe "tableau scaffold defaults" do
    test "compiles without warnings and builds site" do
      with_installer_tmp("tableau_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_tableau_app(tmp_dir, "tableau_blog")

        assert_file(Path.join(app_root_path, "mix.exs"), fn body ->
          assert body =~ ~s({:mdex, "~> 0.13.5", override: true})
          refute body =~ "json_polyfill"
        end)

        assert_file(Path.join(app_root_path, "config/config.exs"), fn body ->
          assert body =~ "header_id_prefix"
          assert body =~ "Tableau.TagExtension"
        end)

        assert_file(
          Path.join(app_root_path, "lib/tableau_blog/layouts/root_layout.ex"),
          fn body ->
            assert body =~ ~s(to={@home_path})
            assert body =~ ~s(to={@blog_path})
            assert body =~ ~s(to={@tags_path})
            assert body =~ "defp page_path_from_page"
          end
        )

        assert_file(Path.join(app_root_path, "lib/tableau_blog/pages/tags_index_page.ex"))
        assert_file(Path.join(app_root_path, "lib/tableau_blog/layouts/tag_layout.ex"))
        assert_file(Path.join(app_root_path, "lib/tableau_blog/layouts/shell.ex"))

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        mix_run!(["assets.build"], app_root_path, env: [{"MIX_ENV", "dev"}])
        mix_run!(["tableau.build"], app_root_path, env: [{"MIX_ENV", "dev"}])
      end)
    end
  end

  describe "tableau scaffold full options" do
    test "lang theme mode a11y compile without unused helpers and build tags paths" do
      with_installer_tmp("tableau_full_opts", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_tableau_app(tmp_dir, "tableau_full", [
            "--theme",
            "--mode",
            "--lang",
            "--a11y"
          ])

        assert_file(
          Path.join(app_root_path, "lib/tableau_full/layouts/root_layout.ex"),
          fn body ->
            refute body =~ "defp page_path_from_page"
            refute body =~ ":tags_path"
            refute body =~ "Locale.swap_path(\"/tags\""
          end
        )

        assert_file(
          Path.join(app_root_path, "lib/tableau_full/pages/blog_index_page.ex"),
          fn body ->
            assert body =~ "Layouts.Shell"
            refute body =~ "Browse tags"
          end
        )

        refute File.exists?(Path.join(app_root_path, "lib/tableau_full/pages/tags_index_page.ex"))
        refute File.exists?(Path.join(app_root_path, "lib/tableau_full/layouts/tag_layout.ex"))

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        mix_run!(["assets.build"], app_root_path, env: [{"MIX_ENV", "dev"}])
        mix_run!(["tableau.build"], app_root_path, env: [{"MIX_ENV", "dev"}])

        site = Path.join(app_root_path, "_site")
        assert File.dir?(site)

        blog_html =
          ["en/blog/index.html", "en/blog.html", "blog/index.html"]
          |> Enum.map(&Path.join(site, &1))
          |> Enum.find(&File.exists?/1)

        assert blog_html, "expected a built blog HTML page under _site"
        assert File.read!(blog_html) =~ "site.css"
      end)
    end
  end
end
