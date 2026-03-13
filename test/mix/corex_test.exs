defmodule Mix.CorexTest do
  use ExUnit.Case

  @tmp_path Path.join(__DIR__, "../../tmp/mix_corex")

  setup do
    File.rm_rf!(@tmp_path)
    File.mkdir_p!(@tmp_path)
    on_exit(fn -> File.rm_rf!(@tmp_path) end)
    :ok
  end

  test "eval_from/3" do
    source_path = Path.join(@tmp_path, "template.eex")
    File.write!(source_path, "<%= @foo %>")

    # Assuming app dir search works with absolute paths via to_app_source fallback
    result = Mix.Corex.eval_from([@tmp_path], "template.eex", assigns: %{foo: "bar"})
    assert result == "bar"

    assert_raise RuntimeError, ~r/could not find unknown.eex in any of the sources/, fn ->
      Mix.Corex.eval_from([@tmp_path], "unknown.eex", [])
    end
  end

  test "copy_from/4 text and eex" do
    source_text = Path.join(@tmp_path, "source.txt")
    source_eex = Path.join(@tmp_path, "source.eex")
    File.write!(source_text, "text content")
    File.write!(source_eex, "<%= @foo %>")

    target_text = Path.join(@tmp_path, "target.txt")
    target_eex = Path.join(@tmp_path, "target.ex")

    mapping = [
      {:text, "source.txt", target_text},
      {:eex, "source.eex", target_eex}
    ]

    Mix.Corex.copy_from([@tmp_path], "", [assigns: %{foo: "bar"}], mapping)

    assert File.read!(target_text) == "text content"
    assert File.read!(target_eex) == "bar"
  end

  test "inflect/1" do
    result = Mix.Corex.inflect("user")
    assert result[:alias] == "User"
    assert result[:human] == "User"
    assert result[:singular] == "user"
    assert result[:path] == "user"

    result = Mix.Corex.inflect("Admin.User")
    assert result[:alias] == "User"
    assert result[:human] == "User"
    assert result[:singular] == "user"
    assert result[:path] == "admin/user"
    assert result[:scoped] == "Admin.User"

    result = Mix.Corex.inflect("Admin.SuperUser")
    assert result[:alias] == "SuperUser"
    assert result[:human] == "Super user"
    assert result[:singular] == "super_user"
    assert result[:path] == "admin/super_user"
  end

  test "check_module_name_availability!" do
    # Corex should already be loaded
    assert_raise Mix.Error, ~r/Module name Corex is already taken/, fn ->
      Mix.Corex.check_module_name_availability!("Corex")
    end

    # Should not raise for available module
    assert Mix.Corex.check_module_name_availability!("Corex.SomeNonExistentModule") == nil
  end

  test "otp_app/0" do
    assert Mix.Corex.otp_app() == :corex
  end

  test "base/0" do
    assert Mix.Corex.base() == "Corex"
  end

  test "context_base/1" do
    assert Mix.Corex.context_base(:corex) == "Corex"
  end

  test "web_module/1" do
    assert Mix.Corex.web_module("Corex") == CorexWeb
    assert Mix.Corex.web_module("CorexWeb") == CorexWeb
  end

  test "generator_paths/0" do
    assert Mix.Corex.generator_paths() == [".", :corex]
  end

  test "to_text/1" do
    assert Mix.Corex.to_text(%{a: 1}) == "%{a: 1}"
  end

  test "prepend_newline/1" do
    assert Mix.Corex.prepend_newline("foo") == "\nfoo"
  end

  test "web_path/2" do
    assert Mix.Corex.web_path(:corex) == "lib/corex_web"
    assert Mix.Corex.web_path(:corex, "foo") == "lib/corex_web/foo"
    assert Mix.Corex.web_path(:other_app, "bar") == "lib/corex/bar"
  end

  test "web_test_path/2" do
    assert Mix.Corex.web_test_path(:corex) == "test/corex_web"
    assert Mix.Corex.web_test_path(:corex, "foo") == "test/corex_web/foo"
    assert Mix.Corex.web_test_path(:other_app, "bar") == "test/corex/bar"
  end

  test "context_app_path/2" do
    assert Mix.Corex.context_app_path(:corex, "lib") == "lib"
  end

  test "context_lib_path/2" do
    assert Mix.Corex.context_lib_path(:corex, "foo") == "lib/corex/foo"
  end

  test "context_test_path/2" do
    assert Mix.Corex.context_test_path(:corex, "foo") == "test/corex/foo"
  end

  test "context_app/0" do
    assert Mix.Corex.context_app() == :corex
  end

  test "in_umbrella?/1" do
    refute Mix.Corex.in_umbrella?(File.cwd!())
  end

  test "modules/0" do
    assert is_list(Mix.Corex.modules())
  end

  test "ensure_live_view_compat!/1" do
    assert Mix.Corex.ensure_live_view_compat!(MyModule) == nil
  end

  test "prompt_for_conflicts/1" do
    # when no conflict
    assert Mix.Corex.prompt_for_conflicts([{:eex, "foo", "non_existent_file"}]) == :ok
    assert Mix.Corex.prompt_for_conflicts([{:new_eex, "foo", "mix.exs"}]) == :ok
  end
end
