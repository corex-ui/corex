defmodule Mix.CorexTest do
  use ExUnit.Case, async: false

  alias Mix.Phoenix.Schema

  @moduletag capture_log: true

  @tmp_path Path.join(__DIR__, "../../tmp/mix_corex")

  setup do
    shell = Mix.shell()
    Mix.shell(Mix.Shell.Quiet)

    File.rm_rf!(@tmp_path)
    File.mkdir_p!(@tmp_path)

    on_exit(fn ->
      File.rm_rf!(@tmp_path)
      Mix.shell(shell)
    end)

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

  test "eval_from_roots/3" do
    File.write!(Path.join(@tmp_path, "nested.eex"), "<%= @value %>")

    assert Mix.Corex.eval_from_roots([@tmp_path], "nested.eex", assigns: %{value: "ok"}) == "ok"

    assert_raise RuntimeError, ~r/could not find missing.eex/, fn ->
      Mix.Corex.eval_from_roots([@tmp_path], "missing.eex", [])
    end
  end

  test "inject_eex_before_final_end/3" do
    path = Path.join(@tmp_path, "module.ex")
    File.write!(path, "defmodule Sample do\n  existing()\nend\n")

    assert :ok = Mix.Corex.inject_eex_before_final_end("  injected()\n", path, [])

    content = File.read!(path)
    assert content =~ "injected()"
    assert String.ends_with?(content, "end\n")

    assert :ok = Mix.Corex.inject_eex_before_final_end("  injected()\n", path, [])
  end

  test "assert_within_project_root!/2 allows paths under root" do
    root = Path.expand(@tmp_path)
    inside = Path.join(root, "assets/code.css")
    assert :ok = Mix.Corex.assert_within_project_root!(inside, root)
  end

  test "assert_within_project_root!/2 rejects paths outside root" do
    root = Path.expand(@tmp_path)
    outside = Path.expand(Path.join([@tmp_path, "..", "outside.css"]))

    assert_raise Mix.Error, ~r/within the project root/, fn ->
      Mix.Corex.assert_within_project_root!(outside, root)
    end
  end

  test "validate_identifier!/1 accepts snake_case names" do
    assert :ok = Mix.Corex.validate_identifier!("user_id")
    assert :ok = Mix.Corex.validate_identifier!(:posts)
  end

  test "validate_identifier!/1 rejects invalid names" do
    assert_raise Mix.Error, ~r/Invalid generator identifier/, fn ->
      Mix.Corex.validate_identifier!("id\"; evil")
    end

    assert_raise Mix.Error, ~r/Invalid generator identifier/, fn ->
      Mix.Corex.validate_identifier!("../evil")
    end
  end

  test "validate_migration_dir!/1 rejects paths outside the project root" do
    outside = Path.join(System.tmp_dir!(), "corex_migration_outside")

    assert_raise Mix.Error, ~r/within the project root/, fn ->
      Mix.Corex.validate_migration_dir!(outside)
    end
  end

  test "validate_generator_schema!/1 validates primary_key and migration_dir" do
    schema =
      Schema.new("User", "users", ["name:string"],
        primary_key: "id\"; evil",
        migration_dir: Path.join(System.tmp_dir!(), "migrations")
      )

    assert_raise Mix.Error, ~r/Invalid generator identifier/, fn ->
      Mix.Corex.validate_generator_schema!(schema)
    end

    schema =
      Schema.new("User", "users", ["name:string"],
        migration_dir: Path.join(System.tmp_dir!(), "migrations")
      )

    assert_raise Mix.Error, ~r/within the project root/, fn ->
      Mix.Corex.validate_generator_schema!(schema)
    end
  end

  test "generator_template_dirs/1" do
    dirs = Mix.Corex.generator_template_dirs("html")
    assert length(dirs) == 3
    assert Enum.all?(dirs, &is_binary/1)
  end

  test "copy_from/4 new_eex skips existing target" do
    source_eex = Path.join(@tmp_path, "new.eex")
    target_eex = Path.join(@tmp_path, "target.ex")
    File.write!(source_eex, "<%= @foo %>")
    File.write!(target_eex, "keep")

    Mix.Corex.copy_from([@tmp_path], "", [assigns: %{foo: "bar"}], [
      {:new_eex, "new.eex", target_eex}
    ])

    assert File.read!(target_eex) == "keep"
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

  test "web_path/2 and web_test_path/2 honor :mix_test_output" do
    tmp = Path.join(@tmp_path, "mix_out")
    prev = Application.get_env(:corex, :mix_test_output)
    Application.put_env(:corex, :mix_test_output, tmp)

    on_exit(fn ->
      case prev do
        nil -> Application.delete_env(:corex, :mix_test_output)
        val -> Application.put_env(:corex, :mix_test_output, val)
      end
    end)

    assert Mix.Corex.web_path(:corex) == Path.join(tmp, "web")
    assert Mix.Corex.web_test_path(:corex, "live") == Path.join(tmp, "test/live")
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
    assert Mix.Corex.prompt_for_conflicts([{:eex, "foo", "non_existent_file"}]) == :ok
    assert Mix.Corex.prompt_for_conflicts([{:new_eex, "foo", "mix.exs"}]) == :ok

    conflict = Path.join(@tmp_path, "conflict.txt")
    File.write!(conflict, "existing")

    ExUnit.CaptureIO.capture_io([input: "\n"], fn ->
      assert Mix.Corex.prompt_for_conflicts([{:eex, "foo", conflict}]) == :ok
    end)
  end

  test "copy_from/4 with source_dir and gettext helpers" do
    templates = Path.join(@tmp_path, "templates")
    File.mkdir_p!(templates)
    source = Path.join(templates, "gettext.eex")

    File.write!(
      source,
      "<%= maybe_eex_gettext.(\"Hi\", @gettext?) %><%= maybe_heex_attr_gettext.(\"Bye\", @gettext?) %>"
    )

    target = Path.join(@tmp_path, "out.txt")

    Mix.Corex.copy_from([@tmp_path], "templates", [assigns: %{gettext?: true}], [
      {:eex, "gettext.eex", target}
    ])

    assert File.read!(target) =~ "gettext(\"Hi\")"
    assert File.read!(target) =~ ~S|{gettext("Bye")}|

    target2 = Path.join(@tmp_path, "out2.txt")

    Mix.Corex.copy_from([@tmp_path], "templates", [assigns: %{gettext?: false}], [
      {:eex, "gettext.eex", target2}
    ])

    assert File.read!(target2) == "Hi\"Bye\""
  end

  test "maybe_heex_attr_translate/2 supports gettext sigils" do
    assert Mix.Corex.maybe_heex_attr_translate("Hello", :sigils) == ~S|{~t"Hello"}|
    assert Mix.Corex.maybe_heex_slot_translate("Hi", :sigils) == ~S|{~t"Hi"}|
    assert Mix.Corex.maybe_eex_translate("Bye", :gettext) == ~S|<%= gettext("Bye") %>|
  end

  test "generators_gettext_mode/0 reads config" do
    prev = Application.get_env(:corex, :generators)

    on_exit(fn ->
      case prev do
        nil -> Application.delete_env(:corex, :generators)
        val -> Application.put_env(:corex, :generators, val)
      end
    end)

    Application.put_env(:corex, :generators, gettext: :sigils)
    assert Mix.Corex.generators_gettext_mode() == :sigils

    Application.put_env(:corex, :generators, gettext_sigils: true)
    assert Mix.Corex.generators_gettext_mode() == :sigils

    Application.put_env(:corex, :generators, gettext: true)
    assert Mix.Corex.generators_gettext_mode() == :gettext

    Application.put_env(:corex, :generators, [])
    assert Mix.Corex.generators_gettext_mode() == false
  end

  test "context_app_path/2 uses generators context_app when configured" do
    prev = Application.get_env(:corex, :generators)

    Application.put_env(:corex, :generators, context_app: {:other_app, "apps/other"})

    on_exit(fn ->
      if prev do
        Application.put_env(:corex, :generators, prev)
      else
        Application.delete_env(:corex, :generators)
      end
    end)

    assert Mix.Corex.context_app_path(:other_app, "lib/foo") == "apps/other/lib/foo"
  end
end
