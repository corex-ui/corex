defmodule Mix.Corex.Gen.Context do
  @moduledoc false

  alias Mix.Phoenix.{Context, Schema}

  def files_to_be_generated(%Context{schema: schema} = context) do
    base = [
      {:eex, "context.ex", context.file},
      {:eex, "context_test.exs", context.test_file},
      {:eex, "fixtures.ex", context.test_fixtures_file}
    ]

    if schema.generate? do
      migration_path = migration_path_for(schema)
      schema_files = [{:eex, "schema.ex", schema.file}]
      migration_files = if migration_path, do: [{:eex, "migration.exs", migration_path}], else: []
      schema_files ++ base ++ migration_files
    else
      base
    end
  end

  def copy_new_files(%Context{schema: schema} = context, binding) do
    if schema.generate?, do: copy_schema_and_migration(schema, binding)
    ensure_context_file_exists(context, binding)
    inject_schema_access(context, binding)
    inject_tests(context, binding)
    inject_test_fixture(context, binding)
    maybe_print_unimplemented_fixture_functions(context)
    context
  end

  def print_shell_instructions(%Context{schema: schema}) do
    if schema.generate? and schema.migration? do
      Mix.shell().info("""

      Remember to update your repository by running migrations:

          $ mix ecto.migrate
      """)
    end
  end

  defp copy_schema_and_migration(schema, binding) do
    roots = Mix.Corex.generator_template_dirs("corex.gen.schema")
    content = Mix.Corex.eval_from_roots(roots, "schema.ex", binding)
    Mix.Generator.create_file(schema.file, content)

    if schema.migration? do
      path = migration_path_for(schema)
      migration_content = Mix.Corex.eval_from_roots(roots, "migration.exs", binding)
      File.mkdir_p!(Path.dirname(path))
      Mix.Generator.create_file(path, migration_content)
    end
  end

  defp migration_path_for(%Schema{migration?: false}), do: nil

  defp migration_path_for(%Schema{context_app: ctx_app, repo: repo, opts: opts} = schema) do
    dir =
      cond do
        migration_dir = opts[:migration_dir] ->
          migration_dir

        opts[:repo] ->
          repo_name = repo |> Module.split() |> List.last() |> Macro.underscore()
          Mix.Phoenix.context_app_path(ctx_app, "priv/#{repo_name}/migrations/")

        true ->
          Mix.Phoenix.context_app_path(ctx_app, "priv/repo/migrations/")
      end

    Path.join(dir, "#{timestamp()}_create_#{schema.table}.exs")
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  defp ensure_context_file_exists(%Context{file: file} = context, binding) do
    unless Context.pre_existing?(context) do
      roots = Mix.Corex.generator_template_dirs("corex.gen.context")
      content = Mix.Corex.eval_from_roots(roots, "context.ex", binding)
      Mix.Generator.create_file(file, content)
    end
  end

  defp inject_schema_access(context, binding) do
    ensure_context_file_exists(context, binding)
    roots = Mix.Corex.generator_template_dirs("corex.gen.context")
    template = schema_access_template(context)
    content = Mix.Corex.eval_from_roots(roots, template, binding)
    Mix.Corex.inject_eex_before_final_end(content, context.file, binding)
  end

  defp schema_access_template(%Context{schema: schema}) do
    cond do
      schema.generate? && schema.scope -> "schema_access_scope.ex"
      schema.generate? -> "schema_access.ex"
      schema.scope -> "access_no_schema_scope.ex"
      true -> "access_no_schema.ex"
    end
  end

  defp ensure_test_file_exists(context, binding) do
    unless Context.pre_existing_tests?(context) do
      roots = Mix.Corex.generator_template_dirs("corex.gen.context")
      content = Mix.Corex.eval_from_roots(roots, "context_test.exs", binding)
      Mix.Generator.create_file(context.test_file, content)
    end
  end

  defp inject_tests(context, binding) do
    ensure_test_file_exists(context, binding)
    roots = Mix.Corex.generator_template_dirs("corex.gen.context")
    file = if context.schema.scope, do: "test_cases_scope.exs", else: "test_cases.exs"
    content = Mix.Corex.eval_from_roots(roots, file, binding)
    Mix.Corex.inject_eex_before_final_end(content, context.test_file, binding)
  end

  defp ensure_test_fixtures_file_exists(context, binding) do
    unless Context.pre_existing_test_fixtures?(context) do
      roots = Mix.Corex.generator_template_dirs("corex.gen.context")
      content = Mix.Corex.eval_from_roots(roots, "fixtures_module.ex", binding)
      Mix.Generator.create_file(context.test_fixtures_file, content)
    end
  end

  defp inject_test_fixture(context, binding) do
    ensure_test_fixtures_file_exists(context, binding)
    roots = Mix.Corex.generator_template_dirs("corex.gen.context")
    content = Mix.Corex.eval_from_roots(roots, "fixtures.ex", binding)
    content = Mix.Corex.prepend_newline(content)
    Mix.Corex.inject_eex_before_final_end(content, context.test_fixtures_file, binding)
  end

  defp maybe_print_unimplemented_fixture_functions(%Context{} = context) do
    fixture_functions_needing_implementations =
      Enum.flat_map(
        context.schema.fixture_unique_functions,
        fn
          {_field, {_function_name, function_def, true}} -> [function_def]
          {_field, {_function_name, _function_def, false}} -> []
        end
      )

    if Enum.any?(fixture_functions_needing_implementations) do
      Mix.shell().info("""

      Some of the generated database columns are unique. Please provide
      unique implementations for the following fixture function(s) in
      #{context.test_fixtures_file}:

      #{fixture_functions_needing_implementations |> Enum.map_join(&indent(&1, 2)) |> String.trim_trailing()}
      """)
    end
  end

  defp indent(string, spaces) do
    indent_string = String.duplicate(" ", spaces)

    string
    |> String.split("\n")
    |> Enum.map_join(fn line ->
      if String.trim(line) == "" do
        "\n"
      else
        indent_string <> line <> "\n"
      end
    end)
  end
end
