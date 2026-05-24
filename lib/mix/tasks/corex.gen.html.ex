defmodule Mix.Tasks.Corex.Gen.Html do
  @shortdoc "Generates context and controller for an HTML resource"

  @moduledoc """
  Generates controller with view, templates, schema and context for an HTML resource.

  The format is:

  ```console
  $ mix corex.gen.html [<context>] <schema> <table> <attr:type> [<attr:type>...]
  ```

  For example:

  ```console
  $ mix corex.gen.html User users name:string age:integer
  ```

  Will generate a `User` schema for the `users` table within the `Users` context,
  with the attributes `name` (as a string) and `age` (as an integer).

  You can also explicitly pass the context name as argument, whenever the context
  is well defined:

  ```console
  $ mix corex.gen.html Accounts User users name:string age:integer
  ```

  The first argument is the context module (`Accounts`) followed by
  the schema module (`User`), table name (`users`), and attributes.

  The context is an Elixir module that serves as an API boundary for
  the given resource. A context often holds many related resources.
  Therefore, if the context already exists, it will be augmented with
  functions for the given resource.

  The schema is responsible for mapping the database fields into an
  Elixir struct. It is followed by a list of attributes with their
  respective names and types. See `mix phx.gen.schema` for more
  information on attributes.

  Overall, this generator will add the following files to `lib/`:

    * a controller in `lib/my_app_web/controllers/user_controller.ex`
    * default CRUD HTML templates in `lib/my_app_web/controllers/user_html`
    * an HTML view collocated with the controller in `lib/my_app_web/controllers/user_html.ex`
    * a schema in `lib/my_app/accounts/user.ex`, with an `users` table
    * a context module in `lib/my_app/accounts.ex` for the accounts API

  Additionally, this generator creates the following files:

    * a migration for the schema in `priv/repo/migrations`
    * a controller test module in `test/my_app/controllers/user_controller_test.exs`
    * a context test module in `test/my_app/accounts_test.exs`
    * a context test helper module in `test/support/fixtures/accounts_fixtures.ex`

  If the context already exists, this generator injects functions for the given resource into
  the context, context test, and context test helper modules.

  ## Scopes

  If your application configures its own default [scope](https://hexdocs.pm/phoenix/scopes.html), then this generator
  will automatically make sure all of your context operations are correctly scoped.
  You can pass the `--no-scope` flag to disable the scoping.

  ## Umbrella app configuration

  By default, Phoenix injects both web and domain specific functionality into the same
  application. When using umbrella applications, those concerns are typically broken
  into two separate apps, your context application - let's call it `my_app` - and its web
  layer, which Phoenix assumes to be `my_app_web`.

  You can teach Phoenix to use this style via the `:context_app` configuration option
  in your `my_app_umbrella/config/config.exs`:

      config :my_app_web,
        ecto_repos: [Stuff.Repo],
        generators: [context_app: :my_app]

  Alternatively, the `--context-app` option may be supplied to the generator:

  ```console
  $ mix corex.gen.html Accounts User users --context-app my_app
  ```

  ## Web namespace

  By default, the controller and HTML views are not namespaced but you can add
  a namespace by passing the `--web` flag with a module name, for example:

  ```console
  $ mix corex.gen.html Accounts User users --web Accounts
  ```

  Which would generate a `lib/app_web/controllers/accounts/user_controller.ex` and
  `lib/app_web/controllers/accounts/user_html.ex`.

  ## Customizing generated output

  To override the default controller and HTML templates, copy the generator
  templates from Corex into your project at `priv/corex_templates/corex.gen.html/`.
  The generator looks there first, then `priv/templates/corex.gen.html/`, then
  Corex's bundled templates. Adjust the copied `.ex`, `.heex`, and `.exs` EEx
  files to match your style; they use the same bindings as the originals.

  Array fields (`tags:array:string`) generate a multi-select `Corex.Select` with
  placeholder options. Swap to `Corex.TagsInput` when values are free-form tags.

  ## Customizing the context, schema, tables and migrations

  In some cases, you may wish to bootstrap HTML templates, controllers,
  and controller tests, but leave internal implementation of the context
  or schema to yourself. You can use the `--no-context` and `--no-schema`
  flags for file generation control. Note `--no-context` implies `--no-schema`:

  ```console
  $ mix corex.gen.live Accounts User users --no-context name:string
  ```

  In the cases above, tests are still generated, but they will all fail.

  You can also change the table name or configure the migrations to
  use binary ids for primary keys, see `mix phx.gen.schema` for more
  information. Context and schema generation use Phoenix; run `mix phx.gen.context`
  or `mix phx.gen.schema` when you need only context or schema.
  """
  use Mix.Task

  alias Mix.Corex, as: Corex
  alias Mix.Corex.Gen.Inputs
  alias Mix.Phoenix.{Context, Schema, Scope}
  alias Mix.Tasks.Phx.Gen

  @impl Mix.Task
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix corex.gen.html must be invoked from within your *_web application root directory"
      )
    end

    Mix.Phoenix.ensure_live_view_compat!(__MODULE__)

    {context, schema} = Gen.Context.build(args, name_optional: true)

    if schema.attrs == [] do
      Mix.raise("""
      No attributes provided. The corex.gen.html generator requires at least one attribute. For example:

        mix corex.gen.html Accounts User users name:string

      """)
    end

    Gen.Context.prompt_for_code_injection(context)

    {conn_scope, context_scope_prefix} =
      if schema.scope do
        base = "conn.assigns.#{schema.scope.assign_key}"
        {base, "#{base}, "}
      else
        {"", ""}
      end

    layout_opts = Mix.Corex.layout_generators_opts()

    gettext_mode = Mix.Corex.generators_gettext_mode()

    binding = [
      context: context,
      schema: schema,
      primary_key: schema.opts[:primary_key] || :id,
      scope: schema.scope,
      layout_mode: layout_mode?(layout_opts),
      layout_theme: layout_theme?(layout_opts),
      layout_themes: layout_themes?(layout_opts),
      layout_locale: Mix.Corex.layout_locale_paths?(context.web_module, layout_opts),
      inputs: inputs(schema),
      conn_scope: conn_scope,
      context_scope_prefix: context_scope_prefix,
      scope_conn_route_prefix: Scope.route_prefix(conn_scope, schema),
      scope_param_route_prefix: Scope.route_prefix("scope", schema),
      scope_assign_route_prefix: scope_assign_route_prefix(schema),
      test_context_scope:
        if(schema.scope && schema.scope.route_prefix, do: ", scope: scope", else: ""),
      assigns: %{
        gettext: gettext_mode != false,
        gettext_mode: gettext_mode
      }
    ]

    prompt_for_conflicts(context)

    context
    |> copy_new_files(binding)
    |> print_shell_instructions()
  end

  defp prompt_for_conflicts(context) do
    context
    |> files_to_be_generated()
    |> Kernel.++(context_files(context))
    |> Mix.Corex.prompt_for_conflicts()
  end

  defp context_files(%Context{generate?: true} = context) do
    Mix.Corex.Gen.Context.files_to_be_generated(context)
  end

  defp context_files(%Context{generate?: false}) do
    []
  end

  @doc "Lists files emitted by the HTML generator for conflict prompts."
  def files_to_be_generated(%Context{schema: schema, context_app: context_app}) do
    singular = schema.singular
    web_prefix = Mix.Corex.web_path(context_app)
    test_prefix = Mix.Corex.web_test_path(context_app)
    web_path = to_string(schema.web_path)
    controller_pre = Path.join([web_prefix, "controllers", web_path])
    test_pre = Path.join([test_prefix, "controllers", web_path])

    [
      {:eex, "controller.ex", Path.join([controller_pre, "#{singular}_controller.ex"])},
      {:eex, "edit.html.heex", Path.join([controller_pre, "#{singular}_html", "edit.html.heex"])},
      {:eex, "index.html.heex",
       Path.join([controller_pre, "#{singular}_html", "index.html.heex"])},
      {:eex, "new.html.heex", Path.join([controller_pre, "#{singular}_html", "new.html.heex"])},
      {:eex, "show.html.heex", Path.join([controller_pre, "#{singular}_html", "show.html.heex"])},
      {:eex, "resource_form.html.heex",
       Path.join([controller_pre, "#{singular}_html", "#{singular}_form.html.heex"])},
      {:eex, "html.ex", Path.join([controller_pre, "#{singular}_html.ex"])},
      {:eex, "controller_test.exs", Path.join([test_pre, "#{singular}_controller_test.exs"])}
    ]
  end

  defp copy_new_files(%Context{} = context, binding) do
    files = files_to_be_generated(context)
    template_dirs = Corex.generator_template_dirs("corex.gen.html")
    Corex.copy_from(template_dirs, "", binding, files)

    if context.generate?, do: Mix.Corex.Gen.Context.copy_new_files(context, binding)

    Corex.format_generated_files(files)

    context
  end

  defp print_shell_instructions(%Context{schema: schema, context_app: ctx_app} = context) do
    layout_opts = Mix.Corex.layout_generators_opts()
    locale_scoped = Mix.Corex.locale_scoped_routes?(context.web_module, layout_opts)

    resource_path =
      if schema.scope && schema.scope.route_prefix do
        "#{schema.scope.route_prefix}/#{schema.plural}"
      else
        "/#{schema.plural}"
      end

    scope_instruction =
      if locale_scoped do
        "Add the resource inside the existing scope \"/:locale\" block in #{Mix.Phoenix.web_path(ctx_app)}/router.ex:"
      else
        "Add the resource to your browser scope in #{Mix.Phoenix.web_path(ctx_app)}/router.ex:"
      end

    if schema.web_namespace do
      Mix.shell().info("""

      #{scope_instruction}

          scope "/#{schema.web_path}", #{inspect(Module.concat(context.web_module, schema.web_namespace))} do
            pipe_through :browser
            ...
            resources "#{resource_path}", #{inspect(schema.alias)}Controller#{if schema.opts[:primary_key], do: ~s[, param: "#{schema.opts[:primary_key]}"]}
          end
      """)
    else
      Mix.shell().info("""

      #{scope_instruction}

          resources "#{resource_path}", #{inspect(schema.alias)}Controller#{if schema.opts[:primary_key], do: ~s[, param: "#{schema.opts[:primary_key]}"]}
      """)
    end

    if schema.scope do
      Mix.shell().info(
        "Ensure the routes are defined in a block that sets the `#{inspect(context.scope.assign_key)}` assign."
      )
    end

    if context.generate?, do: Mix.Corex.Gen.Context.print_shell_instructions(context)
  end

  defp scope_assign_route_prefix(
         %{scope: %{route_prefix: route_prefix, assign_key: assign_key}} = schema
       )
       when not is_nil(route_prefix) do
    Scope.route_prefix("@#{assign_key}", schema)
  end

  defp scope_assign_route_prefix(_), do: ""

  defp layout_theme?(opts), do: Keyword.has_key?(opts, :theme)
  defp layout_mode?(opts), do: Keyword.has_key?(opts, :mode)

  defp layout_themes?(opts) do
    layout_theme?(opts) and app_has_themes?()
  end

  defp app_has_themes? do
    app = Mix.Project.config()[:app]
    str = to_string(app)

    root_app =
      if String.ends_with?(str, "_web") do
        String.to_atom(String.replace_suffix(str, "_web", ""))
      else
        app
      end

    themes = Application.get_env(app, :themes) || Application.get_env(root_app, :themes)
    is_list(themes)
  end

  @doc "Builds HEEx snippets for each schema attribute used by corex.gen.html templates."
  def inputs(%Schema{} = schema) do
    Inputs.inputs(schema, "f")
  end

  @doc "Pads generated input snippets when emitted into generator templates."
  def indent_inputs(inputs, column_padding) do
    columns = String.duplicate(" ", column_padding)

    inputs
    |> Enum.map(fn input ->
      lines = input |> String.split("\n") |> Enum.reject(&(&1 == ""))

      case lines do
        [] ->
          []

        [line] ->
          [columns, line]

        [first_line | rest] ->
          rest = Enum.map_join(rest, "\n", &(columns <> &1))
          [columns, first_line, "\n", rest]
      end
    end)
    |> Enum.intersperse("\n")
  end
end
