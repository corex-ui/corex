defmodule Corex.Integration.CodeGeneration.CorexIdempotencyTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "rerun produces no diff" do
    test "greenfield corex.new + igniter.install corex --yes is idempotent" do
      with_installer_tmp("corex_idempotent_default", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app")
        assert_no_diff_after_rerun!(app_root_path, [])
      end)
    end

    test "corex.new --mode --theme --lang re-run is idempotent" do
      with_installer_tmp("corex_idempotent_full", fn tmp_dir ->
        {app_root_path, _} =
          generate_corex_app(tmp_dir, "my_app", ["--mode", "--theme", "--lang"])

        assert_no_diff_after_rerun!(app_root_path, ["--mode", "--theme", "--lang"])
      end)
    end

    test "--no-replace re-run is idempotent" do
      with_installer_tmp("corex_idempotent_no_replace", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-replace"])
        assert_no_diff_after_rerun!(app_root_path, ["--no-replace"])
      end)
    end

    test "--no-design re-run is idempotent and starter has no design class strings" do
      with_installer_tmp("corex_idempotent_no_design", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-design"])
        assert_corex_design_off_starter_no_class!(app_root_path, "my_app")
        assert_no_diff_after_rerun!(app_root_path, ["--no-design"])
      end)
    end
  end
end
