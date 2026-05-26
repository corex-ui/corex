defmodule Mix.Corex.Gen.ContextTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO
  import MixGenHelpers

  alias Mix.Corex.Gen.Context, as: GenContext

  setup do
    tmp = Path.join(System.tmp_dir!(), "corex_gen_context_#{System.unique_integer([:positive])}")
    File.mkdir_p!(tmp)

    on_exit(fn -> File.rm_rf(tmp) end)

    %{tmp: tmp}
  end

  test "files_to_be_generated/1 without schema includes only context files", %{tmp: tmp} do
    context = build_context(tmp, generate?: false, migration?: false)

    files = GenContext.files_to_be_generated(context)
    paths = Enum.map(files, fn {_, _, path} -> path end)

    assert length(files) == 3
    assert Enum.all?(paths, &String.starts_with?(&1, tmp))
    refute Enum.any?(paths, &String.ends_with?(&1, "user.ex"))
    refute Enum.any?(paths, &String.contains?(&1, "migrations"))
  end

  test "files_to_be_generated/1 with schema and migration", %{tmp: tmp} do
    context = build_context(tmp)

    files = GenContext.files_to_be_generated(context)
    kinds = Enum.map(files, fn {kind, _, _} -> kind end)
    paths = Enum.map(files, fn {_, _, path} -> path end)

    assert :eex in kinds
    assert Enum.any?(paths, &String.ends_with?(&1, "user.ex"))
    assert Enum.any?(paths, &String.ends_with?(&1, "accounts.ex"))
    assert Enum.any?(paths, &String.match?(&1, ~r/migrations\/\d+_create_users\.exs$/))
  end

  test "files_to_be_generated/1 without migration", %{tmp: tmp} do
    context = build_context(tmp, migration?: false)

    paths =
      context
      |> GenContext.files_to_be_generated()
      |> Enum.map(fn {_, _, path} -> path end)

    refute Enum.any?(paths, &String.contains?(&1, "migrations"))
  end

  test "copy_new_files/2 creates context, tests, fixtures, schema, and migration", %{tmp: tmp} do
    context = build_context(tmp)

    copy_new_files(context)

    assert File.exists?(context.file)
    assert File.exists?(context.test_file)
    assert File.exists?(context.test_fixtures_file)
    assert File.exists?(context.schema.file)
    assert File.read!(context.file) =~ "list_users"
    assert File.read!(context.test_file) =~ "Accounts"
    assert File.read!(context.test_fixtures_file) =~ "user_fixture"
  end

  test "copy_new_files/2 injects into pre-existing context and tests", %{tmp: tmp} do
    context = build_context(tmp)

    File.write!(context.file, "defmodule Stub do\nend\n")
    File.write!(context.test_file, "defmodule StubTest do\n  use ExUnit.Case\nend\n")
    File.write!(context.test_fixtures_file, "defmodule Fixtures do\nend\n")

    copy_new_files(context)

    assert File.read!(context.file) =~ "list_users"
    assert File.read!(context.test_file) =~ "user"
    assert File.read!(context.test_fixtures_file) =~ "user_fixture"
  end

  test "copy_new_files/2 uses scoped templates when schema has scope", %{tmp: tmp} do
    scope =
      Mix.Phoenix.Scope.new!(:admin,
        module: Corex.Accounts.Scope,
        assign_key: :current_scope,
        access_path: [:user, :id],
        route_prefix: "admin",
        schema_key: :user_id,
        schema_type: :id,
        schema_table: :users
      )

    context =
      build_context(tmp, attrs: [name: :string])
      |> Map.update!(:schema, &Map.put(&1, :scope, scope))

    copy_new_files(context)

    assert File.read!(context.file) =~ "list_users(%Scope{}"
    assert File.read!(context.test_file) =~ "other_scope"
  end

  test "copy_new_files/2 without schema generation only emits context files", %{tmp: tmp} do
    context = build_context(tmp, generate?: false, migration?: false)

    copy_new_files(context)

    assert File.exists?(context.file)
    refute File.exists?(context.schema.file)
    assert File.read!(context.file) =~ ~S/raise "TODO"/
  end

  test "copy_new_files/2 generates unique fixture helpers for unique fields", %{tmp: tmp} do
    context = build_context(tmp, attrs: [email: :string], unique: ["email"])

    copy_new_files(context)

    fixtures = File.read!(context.test_fixtures_file)
    assert fixtures =~ "Generate a unique user email"
    assert fixtures =~ "unique_user_email"
  end

  test "print_shell_instructions/1 when migration enabled", %{tmp: tmp} do
    context = build_context(tmp, migration?: true)

    output =
      capture_io(fn ->
        GenContext.print_shell_instructions(context)
      end)

    assert output =~ "mix ecto.migrate"
  end

  test "copy_new_files/2 skips migration when migration? is false", %{tmp: tmp} do
    context =
      build_context(tmp)
      |> Map.update!(:schema, &%{&1 | migration?: false})

    copy_new_files(context)

    assert File.exists?(context.schema.file)
    refute File.exists?(Path.join(tmp, "migrations"))
  end

  test "print_shell_instructions/1 is silent without migration", %{tmp: tmp} do
    context =
      build_context(tmp)
      |> Map.update!(:schema, &%{&1 | migration?: false})

    output =
      capture_io(fn ->
        GenContext.print_shell_instructions(context)
      end)

    assert output == ""
  end

  test "print_shell_instructions/1 is silent without schema", %{tmp: tmp} do
    context = build_context(tmp, generate?: false, migration?: false)

    output =
      capture_io(fn ->
        GenContext.print_shell_instructions(context)
      end)

    assert output == ""
  end
end
