defmodule Corex.Integration.CodeGeneration.CorexDesignOffTest do
  use Corex.Integration.CodeGeneratorCase, async: true

  describe "--no-design" do
    test "produces class-free starter and Layouts.corex def" do
      with_installer_tmp("corex_design_off", fn tmp_dir ->
        {app_root_path, _} = generate_corex_app(tmp_dir, "my_app", ["--no-design"])

        assert_corex_no_design_replace_invariants!(app_root_path, "my_app")
        assert_no_compilation_warnings(app_root_path)
      end)
    end
  end
end
