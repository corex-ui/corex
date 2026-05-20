defmodule MixGenHelpers do
  @moduledoc false

  alias Mix.Corex.Gen.Context, as: GenContext
  alias Mix.Phoenix.{Context, Schema}

  def with_test_output(fun) when is_function(fun, 1) do
    tmp = Path.join(System.tmp_dir!(), "corex_mix_out_#{System.unique_integer([:positive])}")
    prev = Application.get_env(:corex, :mix_test_output)
    File.mkdir_p!(tmp)
    Application.put_env(:corex, :mix_test_output, tmp)

    try do
      fun.(tmp)
    after
      case prev do
        nil -> Application.delete_env(:corex, :mix_test_output)
        val -> Application.put_env(:corex, :mix_test_output, val)
      end

      File.rm_rf(tmp)
    end
  end

  def with_quiet_shell(fun) when is_function(fun, 0) do
    shell = Mix.shell()
    Mix.shell(Mix.Shell.Quiet)

    try do
      fun.()
    after
      Mix.shell(shell)
    end
  end

  def build_schema(opts \\ []) do
    attrs = Keyword.get(opts, :attrs, name: :string)
    unique = Keyword.get(opts, :unique, [])

    cli_attrs =
      Enum.map(attrs, fn
        {key, type} -> "#{key}:#{type}"
      end) ++ Enum.map(unique, &"#{&1}:unique")

    schema_opts =
      [
        context_app: :corex,
        repo: Corex.Repo,
        migration_dir: Keyword.get(opts, :migration_dir),
        migration: Keyword.get(opts, :migration?, true),
        schema: Keyword.get(opts, :generate?, true)
      ]
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    Schema.new(
      Keyword.get(opts, :schema_name, "User"),
      Keyword.get(opts, :table, "users"),
      cli_attrs,
      schema_opts
    )
  end

  def build_context(tmp, opts \\ []) do
    schema = build_schema(Keyword.merge(opts, migration_dir: Path.join(tmp, "migrations")))

    context =
      Context.new(
        Keyword.get(opts, :context_name, "Accounts"),
        schema,
        context_app: :corex,
        context: Keyword.get(opts, :context?, true)
      )

    remap_context_paths(context, schema, tmp)
  end

  def remap_context_paths(%Context{} = context, %Schema{} = schema, tmp) do
    basename = context.basename
    migrations = Path.join(tmp, "migrations")

    schema = %{
      schema
      | file: Path.join(tmp, "#{schema.singular}.ex"),
        opts: Keyword.put(schema.opts, :migration_dir, migrations)
    }

    %{
      context
      | file: Path.join(tmp, "#{basename}.ex"),
        test_file: Path.join(tmp, "#{basename}_test.exs"),
        test_fixtures_file: Path.join(tmp, "#{basename}_fixtures.ex"),
        dir: tmp,
        schema: schema
    }
  end

  def context_binding(%Context{} = context) do
    schema = context.schema

    [
      context: context,
      schema: schema,
      scope: schema.scope,
      primary_key: schema.opts[:primary_key] || :id
    ]
  end

  def files_to_be_generated(context), do: GenContext.files_to_be_generated(context)

  def copy_new_files(context, binding \\ nil) do
    binding = binding || context_binding(context)
    GenContext.copy_new_files(context, binding)
  end

  def run_generator(task, args, opts \\ []) do
    Mix.Task.reenable(task)
    run = fn -> run_generator_input(task, args, opts) end

    if Keyword.get(opts, :loud, false) do
      run.()
    else
      with_quiet_shell(run)
    end
  end

  defp run_generator_input(task, args, opts) do
    case Keyword.get(opts, :cd) do
      nil -> run_with_input(task, args)
      cd -> File.cd!(cd, fn -> run_with_input(task, args) end)
    end
  end

  defp run_with_input(task, args) do
    ExUnit.CaptureIO.capture_io([input: "\n"], fn ->
      Mix.Task.run(task, args)
    end)
  end

  def rm_rf(paths) when is_list(paths) do
    Enum.each(paths, fn path ->
      if File.exists?(path), do: File.rm_rf!(path)
    end)
  end
end
