defmodule Corex.Integration.CodeGeneration.AppWithDefaultsTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "new with defaults" do
    @tag database: :postgresql
    test "has no compilation or formatter warnings" do
      with_installer_tmp("new with defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end

    @tag database: :postgresql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "default_app")

        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end
  end

  describe "corex.gen.html" do
    @tag database: :postgresql
    test "has no compilation or formatter warnings" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        mix_run!(~w(corex.gen.html Blog Post posts title:unique body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", PhxBlogWeb do
              pipe_through [:browser]

              resources "/posts", PostController
            end
          """)
        end)

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end

    @tag database: :postgresql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        mix_run!(~w(corex.gen.html Blog Post posts title:unique body:string status:enum:unpublished:published:deleted order:integer:unique), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", PhxBlogWeb do
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
    @tag database: :postgresql
    test "has no compilation or formatter warnings" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        mix_run!(~w(phx.gen.json Blog Post posts title:unique body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/api", PhxBlogWeb do
              pipe_through [:api]

              resources "/posts", PostController, except: [:new, :edit]
            end
          """)
        end)

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end

    @tag database: :postgresql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        mix_run!(~w(phx.gen.json Blog Post posts title:unique body:string status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/api", PhxBlogWeb do
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
    @tag database: :postgresql
    test "has no compilation or formatter warnings" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog", ["--live"])

        mix_run!(~w(corex.gen.live Blog Post posts title:unique body:string p:boolean s:enum:a:b:c), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", PhxBlogWeb do
              pipe_through [:browser]

              live "/posts", PostLive.Index, :index
              live "/posts/new", PostLive.Form, :new
              live "/posts/:id", PostLive.Show, :show
              live "/posts/:id/edit", PostLive.Form, :edit
            end
          """)
        end)

        assert_no_compilation_warnings(app_root_path)
        assert_passes_formatter_check(app_root_path)
        drop_test_database(app_root_path)
        assert_tests_pass(app_root_path)
      end)
    end

    @tag database: :postgresql
    test "has a passing test suite" do
      with_installer_tmp("app_with_defaults", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog", ["--live"])

        mix_run!(~w(corex.gen.live Blog Post posts title body:string public:boolean status:enum:unpublished:published:deleted), app_root_path)

        modify_file(Path.join(app_root_path, "lib/phx_blog_web/router.ex"), fn file ->
          inject_before_final_end(file, """

            scope "/", PhxBlogWeb do
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

  describe "corex.gen.html E2E patterns" do
    @tag database: :postgresql
    test "generated templates use layout_heading, data_list, get_form_id, link method delete" do
      with_installer_tmp("gen_html_e2e", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog")

        mix_run!(
          ~w(corex.gen.html Blog Post posts title:string body:text),
          app_root_path
        )

        index_path = Path.join(app_root_path, "lib/phx_blog_web/controllers/post_html/index.html.heex")
        assert_file(index_path, fn file ->
          assert file =~ "layout_heading"
          assert file =~ "method=\"delete\""
          refute file =~ "JS.hide"
        end)

        show_path = Path.join(app_root_path, "lib/phx_blog_web/controllers/post_html/show.html.heex")
        assert_file(show_path, fn file ->
          assert file =~ "layout_heading"
          assert file =~ "data_list"
        end)

        form_path =
          Path.join(app_root_path, "lib/phx_blog_web/controllers/post_html/resource_form.html.heex")

        assert_file(form_path, fn file ->
          assert file =~ "get_form_id(@changeset)"
        end)
      end)
    end
  end

  describe "corex.gen.live E2E patterns" do
    @tag database: :postgresql
    test "generated LiveView templates use layout_heading, data_list, get_form_id, action delete" do
      with_installer_tmp("gen_live_e2e", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "phx_blog", ["--live"])

        mix_run!(
          ~w(corex.gen.live Blog Post posts title:string body:text),
          app_root_path
        )

        index_path = Path.join(app_root_path, "lib/phx_blog_web/live/post_live/index.ex")
        assert_file(index_path, fn file ->
          assert file =~ "layout_heading"
          assert file =~ "JS.push(\"delete\""
          assert file =~ "phx-click"
          refute file =~ "JS.hide"
        end)

        show_path = Path.join(app_root_path, "lib/phx_blog_web/live/post_live/show.ex")
        assert_file(show_path, fn file ->
          assert file =~ "layout_heading"
          assert file =~ "data_list"
        end)

        form_path = Path.join(app_root_path, "lib/phx_blog_web/live/post_live/form.ex")
        assert_file(form_path, fn file ->
          assert file =~ "get_form_id(@form)"
        end)
      end)
    end
  end

end
