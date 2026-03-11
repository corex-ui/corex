defmodule Corex.Integration.CodeGeneration.FullStackWithOptionsTest do
  @moduledoc """
  Full-stack code generation: mix corex.new, then mix corex.gen.live and mix corex.gen.html.
  Each test asserts: compile (no warnings), mix format --check-formatted, mix test.
  """
  use Corex.Integration.CodeGeneratorCase, async: true

  @rich_attrs ~w(name:string age:integer score:float balance:decimal active:boolean bio:text birth_date:date start_time:time published_at:utc_datetime drafted_at:naive_datetime tags:array:string status:enum:draft:published:archived)

  describe "full stack with heavy options and locale" do
    @tag database: :postgresql
    test "corex.new with --lang en:fr --mode --theme neo:uno:duo:leo --dev --live, then corex.gen.live and corex.gen.html with rich attrs, compiles formats and tests pass" do
      with_installer_tmp("full_stack_locale", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "full_app", [
            "--lang", "en:fr",
            "--mode",
            "--theme", "neo:uno:duo:leo",
            "--dev",
            "--live"
          ])

        router_path = Path.join(app_root_path, "lib/full_app_web/router.ex")

        mix_run!(
          ["corex.gen.live", "Admin", "admins" | @rich_attrs],
          app_root_path
        )

        mix_run!(
          ["corex.gen.html", "User", "users" | @rich_attrs],
          app_root_path
        )

        live_routes =
          """
            live "/admins", AdminLive.Index, :index
            live "/admins/new", AdminLive.Form, :new
            live "/admins/:id", AdminLive.Show, :show
            live "/admins/:id/edit", AdminLive.Form, :edit
          """
          |> String.replace(~r/^            /m, "      ")

        inject_live_routes(router_path, live_routes, locale_scope: true)

        resources_routes = "    resources \"/users\", UserController\n"
        inject_resources(router_path, resources_routes, locale_scope: true)

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "full stack with rich attrs without locale" do
    @tag database: :postgresql
    test "corex.new with --live, then corex.gen.live and corex.gen.html with rich attrs, compiles formats and tests pass" do
      with_installer_tmp("full_stack_no_locale", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog", ["--live"])
        router_path = Path.join(app_root_path, "lib/phx_blog_web/router.ex")

        mix_run!(
          ["corex.gen.live", "Admin", "admins" | @rich_attrs],
          app_root_path
        )

        mix_run!(
          ["corex.gen.html", "User", "users" | @rich_attrs],
          app_root_path
        )

        modify_file(router_path, fn file ->
          inject_before_final_end(file, """

            scope "/", PhxBlogWeb do
              pipe_through [:browser]

              resources "/users", UserController
            end

            scope "/", PhxBlogWeb do
              pipe_through [:browser]

              live "/admins", AdminLive.Index, :index
              live "/admins/new", AdminLive.Form, :new
              live "/admins/:id", AdminLive.Show, :show
              live "/admins/:id/edit", AdminLive.Form, :edit
            end
          """)
        end)

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end
end
