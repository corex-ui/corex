defmodule Corex.Integration.CodeGeneration.CorexDesignAutoEnableTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "auto-enable design" do
    test "corex.new --mode auto-enables design (compiler wired)" do
      with_installer_tmp("corex_auto_enable_mode", fn tmp_dir ->
        {app_root_path, output} = generate_corex_app(tmp_dir, "my_app", ["--mode"])

        assert output =~ "installing Corex" or output =~ "corex.new"
        assert_corex_design_compiler_invariants!(app_root_path, "my_app")
        assert_corex_design_layout_classes_present!(app_root_path, "my_app")
      end)
    end

    test "corex.new --mode --no-design raises with the new validation" do
      with_installer_tmp("corex_auto_enable_conflict", fn tmp_dir ->
        app_path = Path.expand("my_app", tmp_dir)
        integration_test_root_path = Path.expand("../../", __DIR__)

        {output, exit_code} =
          mix_run(
            [
              "corex.new",
              app_path,
              "--no-install",
              "--no-version-check",
              "--no-design",
              "--mode"
            ],
            integration_test_root_path
          )

        assert exit_code != 0
        assert output =~ "--mode requires design"
      end)
    end
  end
end
