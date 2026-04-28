defmodule Corex.Integration.CodeGeneration.CorexReplaceTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "--replace flag coverage" do
    test "corex.new --replace overwrites home with starter body, no flash_group/theme_toggle defs, no /home" do
      with_installer_tmp("corex_replace_new", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--replace"])

        web = Path.join(app_root_path, "lib/my_app_web")
        home = File.read!(Path.join(web, "controllers/page_html/home.html.heex"))
        layouts = File.read!(Path.join(web, "components/layouts.ex"))
        router = File.read!(Path.join(web, "router.ex"))

        assert home =~ ~r/<Layouts\.app[\s\n]/
        assert home =~ "flash={@flash}"
        assert home =~ "Welcome to Corex"
        assert home =~ ~s|<.accordion id="welcome-accordion"|
        assert home =~ "home.html.heex"
        refute home =~ "corex.html.heex"
        refute layouts =~ "def flash_group"
        refute layouts =~ "def theme_toggle"
        refute router =~ ~s[get "/home"]
      end)
    end

    test "mix igniter.install corex --replace produces same invariants" do
      with_installer_tmp("corex_replace_igniter", fn tmp_dir ->
        {app_root_path, _} = generate_plain_phoenix_app(tmp_dir, "my_app")

        mix_run!(
          [
            "igniter.install",
            "corex",
            "--yes",
            "--replace",
            "--no-design"
          ],
          app_root_path
        )

        web = Path.join(app_root_path, "lib/my_app_web")
        home = File.read!(Path.join(web, "controllers/page_html/home.html.heex"))
        layouts = File.read!(Path.join(web, "components/layouts.ex"))
        router = File.read!(Path.join(web, "router.ex"))

        assert home =~ ~r/<Layouts\.app[\s\n]/
        assert home =~ "flash={@flash}"
        assert home =~ "Welcome to Corex"
        assert home =~ ~s|<.accordion id="welcome-accordion"|
        assert home =~ "home.html.heex"
        refute home =~ "corex.html.heex"
        refute layouts =~ "def flash_group"
        refute router =~ ~s[get "/home"]
      end)
    end
  end
end
