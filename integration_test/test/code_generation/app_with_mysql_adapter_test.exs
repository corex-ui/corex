defmodule Corex.Integration.CodeGeneration.AppWithMySqlAdapterTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "corex.gen.html" do
    @tag database: :mysql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "default_mysql_app", ["--database", "mysql"])

        mix_run!(~w(corex.gen.html Blog Post posts title body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/default_mysql_app_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", DefaultMysqlAppWeb do
              pipe_through [:browser]

              resources "/posts", PostController
            end
          """)
        end)

        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "phx.gen.json" do
    @tag database: :mysql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "default_mysql_app", ["--database", "mysql"])

        mix_run!(~w(phx.gen.json Blog Post posts title body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/default_mysql_app_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/api", DefaultMysqlAppWeb do
              pipe_through [:api]

              resources "/posts", PostController, except: [:new, :edit]
            end
          """)
        end)

        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "corex.gen.live" do
    @tag database: :mysql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "default_mysql_app", ["--database", "mysql", "--live"])

        mix_run!(~w(corex.gen.live Blog Post posts title body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/default_mysql_app_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", DefaultMysqlAppWeb do
              pipe_through [:browser]

              live "/posts", PostLive.Index, :index
              live "/posts/new", PostLive.Form, :new
              live "/posts/:id", PostLive.Show, :show
              live "/posts/:id/edit", PostLive.Form, :edit
            end
          """)
        end)

        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

end
