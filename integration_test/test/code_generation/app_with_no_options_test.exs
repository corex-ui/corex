defmodule Corex.Integration.CodeGeneration.AppWithNoOptionsTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  @epoch {{1970, 1, 1}, {0, 0, 0}}

  test "newly generated app has no warnings or errors" do
    with_installer_tmp("app_with_no_options", fn tmp_dir ->
      {app_root_path, _} =
        generate_corex_app(tmp_dir, "phx_blog", [
          "--no-ecto",
          "--no-dashboard"
        ])

      assert_no_compilation_warnings(app_root_path)
      assert_passes_formatter_check(app_root_path)
      assert_tests_pass(app_root_path)
    end)
  end

  test "development workflow works as expected" do
    with_installer_tmp("development_workflow", [autoremove?: false], fn tmp_dir ->
      {app_root_path, _} =
        generate_corex_app(tmp_dir, "phx_blog", [
          "--dev",
          "--no-dashboard"
        ])

      assert_no_compilation_warnings(app_root_path)

      File.touch!(Path.join(app_root_path, "lib/phx_blog_web/controllers/page_html.ex"), @epoch)

      port = run_phx_server(app_root_path)

      :inets.start()
      {:ok, response} = request_with_retries("http://localhost:#{port}", 20)
      assert response.status_code == 200
      assert response.body =~ "Corex"

      assert File.stat!(Path.join(app_root_path, "lib/phx_blog_web/controllers/page_html.ex")) > @epoch
      assert_tests_pass(app_root_path)
    end)
  end

end
