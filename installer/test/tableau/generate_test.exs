defmodule Corex.New.Tableau.GenerateTest do
  use ExUnit.Case, async: false

  alias Corex.New.Tableau.Generate

  defp base_opts(overrides \\ []) do
    Keyword.merge(
      [
        otp_app: :my_blog,
        app_module: MyBlog,
        mode: false,
        theme: false,
        design: true,
        mcp: true
      ],
      overrides
    )
  end

  test "run/2 writes all core files" do
    Corex.New.MixHelper.in_tmp("tableau generate base", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))
      File.mkdir_p!(Path.join(install_dir, "lib/layouts"))
      File.mkdir_p!(Path.join(install_dir, "lib/pages"))
      File.write!(Path.join(install_dir, "lib/layouts/root_layout.ex"), "defmodule Broken do\nend\n")
      File.write!(Path.join(install_dir, "lib/pages/home_page.ex"), "defmodule BrokenPage do\nend\n")

      assert :ok == Generate.run(install_dir, base_opts())

      refute File.exists?("lib/layouts")
      refute File.exists?("lib/pages")
      assert File.exists?("lib/my_blog/layouts/root_layout.ex")
      assert File.exists?("lib/my_blog/layouts/post_layout.ex")
      assert File.exists?("lib/my_blog/pages/home_page.ex")
      assert File.exists?("lib/my_blog/pages/blog_index_page.ex")
      assert File.exists?("lib/my_blog/pages/not_found_page.ex")
      assert File.exists?("lib/my_blog/config.ex")
      assert File.exists?("lib/my_blog/application.ex")
      assert File.exists?("lib/my_blog/mcp.ex")
      assert File.exists?("lib/my_blog/md_ex_converter.ex")
      assert File.exists?("lib/mix/tasks/post.ex")
      assert File.exists?("assets/css/site.css")
      assert File.exists?("assets/js/site.js")
      assert File.exists?("assets/vendor/heroicons.js")
      assert File.exists?("config/config.exs")
      assert File.exists?("config/dev.exs")
      assert File.exists?("config/prod.exs")
      assert File.exists?("config/test.exs")
      assert File.exists?("mix.exs")
      assert File.exists?("_posts/2026-01-01-welcome.md")
      assert File.dir?("extra")

      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "defmodule MyBlog.RootLayout"
      assert File.read!("lib/mix/tasks/post.ex") =~ "defmodule Mix.Tasks.MyBlog.Gen.Post"
      assert File.read!("lib/mix/tasks/post.ex") =~ "layout: MyBlog.PostLayout"
      assert File.read!("mix.exs") =~ ":tableau"
      assert File.read!("config/config.exs") =~ "config :corex_design"
      assert File.read!("config/config.exs") =~ ~S[import_config "#{config_env()}.exs"]
      assert File.read!("assets/css/site.css") =~ "corex.css"
    end)
  end

  test "run/2 with mode and theme writes toggle modules" do
    Corex.New.MixHelper.in_tmp("tableau generate flags", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(mode: true, theme: true)
      assert :ok == Generate.run(install_dir, opts)

      assert File.exists?("lib/my_blog/theme.ex")
      assert File.exists?("lib/my_blog/mode.ex")
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Mode.head_script"
      assert File.read!("lib/my_blog/layouts/root_layout.ex") =~ "Theme.head_script"
      assert File.read!("assets/js/site.js") =~ "Select"
      assert File.read!("assets/js/site.js") =~ "Toggle"
    end)
  end

  test "run/2 without design skips corex_design" do
    Corex.New.MixHelper.in_tmp("tableau generate no design", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(design: false)
      assert :ok == Generate.run(install_dir, opts)

      refute File.read!("config/config.exs") =~ "config :corex_design"
      refute File.read!("mix.exs") =~ "corex_design"
      refute File.read!("assets/css/site.css") =~ "corex.css"
    end)
  end

  test "run/2 without mcp skips mcp module" do
    Corex.New.MixHelper.in_tmp("tableau generate no mcp", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      opts = base_opts(mcp: false)
      assert :ok == Generate.run(install_dir, opts)

      refute File.exists?("lib/my_blog/mcp.ex")
      refute File.read!("config/dev.exs") =~ "mcp_enabled"
    end)
  end

  test "run/2 without mode or theme skips those modules" do
    Corex.New.MixHelper.in_tmp("tableau generate no toggles", fn ->
      install_dir = File.cwd!()
      File.mkdir_p!(Path.join(install_dir, "assets/js"))
      File.mkdir_p!(Path.join(install_dir, "assets/css"))
      File.mkdir_p!(Path.join(install_dir, "config"))

      assert :ok == Generate.run(install_dir, base_opts())

      refute File.exists?("lib/my_blog/theme.ex")
      refute File.exists?("lib/my_blog/mode.ex")
      refute File.read!("assets/js/site.js") =~ "Select:"
      refute File.read!("assets/js/site.js") =~ "Toggle:"
    end)
  end
end
