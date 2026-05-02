defmodule Corex.Integration.CodeGeneration.CorexReplaceTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "default corex.new home layout" do
    test "home uses Layouts.app starter body, no flash_group/theme_toggle defs, no /home route" do
      with_installer_tmp("corex_replace_new", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")

        web = Path.join(app_root_path, "lib/my_app_web")
        home = File.read!(Path.join(web, "controllers/page_html/home.html.heex"))
        layouts = File.read!(Path.join(web, "components/layouts.ex"))
        router = File.read!(Path.join(web, "router.ex"))

        assert home =~ ~r/<Layouts\.app[\s\n]/
        assert home =~ "flash={@flash}"
        assert home =~ "Corex for Phoenix"
        refute home =~ ~s|<.accordion id="welcome-accordion"|
        refute home =~ "corex.html.heex"
        refute layouts =~ "def flash_group"
        refute layouts =~ "def theme_toggle"
        refute router =~ ~s[get "/home"]
      end)
    end
  end
end
