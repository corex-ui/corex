defmodule Mix.Tasks.Corex.Gen.Live do
  @shortdoc "Generates LiveView, templates, and context for a resource"

  @moduledoc """
  Generates LiveView, templates, and context for a resource.

  The format is:

  ```console
  $ mix corex.gen.live [<context>] <schema> <table> <attr:type> [<attr:type>...]
  ```

  For example:

  ```console
  $ mix corex.gen.live User users name:string age:integer
  ```

  Will generate a `User` schema for the `users` table within the `Users` context,
  with the attributes `name` (as a string) and `age` (as an integer).

  You can also explicitly pass the context name as argument, whenever the context
  is well defined:

  ```console
  $ mix corex.gen.live Accounts User users name:string age:integer
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

    * a context module in `lib/app/accounts.ex` for the accounts API
    * a schema in `lib/app/accounts/user.ex`, with a `users` table
    * a LiveView in `lib/app_web/live/user_live/show.ex`
    * a LiveView in `lib/app_web/live/user_live/index.ex`
    * a LiveView in `lib/app_web/live/user_live/form.ex`

  After file generation is complete, there will be output regarding required
  updates to the `lib/app_web/router.ex` file.

      Add the live routes to your browser scope in lib/app_web/router.ex:

        live "/users", UserLive.Index, :index
        live "/users/new", UserLive.Form, :new
        live "/users/:id", UserLive.Show, :show
        live "/users/:id/edit", UserLive.Form, :edit

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

  By default, the LiveView modules are defined within a folder named
  after the schema, such as `lib/app_web/live/user_live`. You can add
  additional namespaces by passing the `--web` flag with a module name,
  for example:

  ```console
  $ mix corex.gen.live Accounts User users --web Accounts name:string
  ```

  Which would generate the LiveViews in `lib/app_web/live/accounts/user_live/`,
  namespaced `AppWeb.Accounts.UserLive` instead of `AppWeb.UserLive`.

  ## Customizing generated output

  To override the default LiveView and test templates, copy the generator
  templates from Corex into your project at `priv/corex_templates/corex.gen.live/`.
  The generator looks there first, then `priv/templates/corex.gen.live/`, then
  Corex's bundled templates. Adjust the copied `.ex` and `.exs` EEx files to
  match your style; they use the same bindings as the originals.

  ## Customizing the context, schema, tables and migrations

  In some cases, you may wish to bootstrap HTML templates, LiveViews,
  and tests, but leave internal implementation of the context or schema
  to yourself. You can use the `--no-context` and `--no-schema` flags
  flags for file generation control. Note `--no-context` implies `--no-schema`:

  ```console
  $ mix corex.gen.live Accounts User users --no-context name:string
  ```

  In the cases above, tests are still generated, but they will all fail.

  You can also change the table name or configure the migrations to
  use binary ids for primary keys, see `mix help phx.gen.schema` for more
  information. Context and schema generation use Phoenix; run `mix phx.gen.context`
  or `mix phx.gen.schema` when you need only context or schema.
  """
  use Mix.Task

  alias Mix.Phoenix.{Context, Schema, Scope}
  alias Mix.Tasks.Phx.Gen

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix corex.gen.live must be invoked from within your *_web application root directory"
      )
    end

    Mix.Phoenix.ensure_live_view_compat!(__MODULE__)

    {context, schema} = Gen.Context.build(args, name_optional: true)
    validate_context!(context)

    if schema.attrs == [] do
      Mix.raise("""
      No attributes provided. The corex.gen.live generator requires at least one attribute. For example:

        mix corex.gen.live Accounts User users name:string

      """)
    end

    Gen.Context.prompt_for_code_injection(context)

    {socket_scope, context_scope_prefix, assign_scope, assign_scope_prefix} =
      if schema.scope do
        base_socket = "socket.assigns.#{schema.scope.assign_key}"
        base_assign = "@#{schema.scope.assign_key}"
        {base_socket, "#{base_socket}, ", base_assign, "#{base_assign}, "}
      else
        {"", "", "", ""}
      end

    layout_opts = layout_generators_opts(context, web_app_name(context))

    binding = [
      context: context,
      schema: schema,
      primary_key: schema.opts[:primary_key] || :id,
      scope: schema.scope,
      layout_mode: layout_mode?(layout_opts),
      layout_theme: layout_theme?(layout_opts),
      layout_themes: layout_themes?(layout_opts),
      layout_locale: layout_locale?(layout_opts),
      inputs: inputs(schema),
      socket_scope: socket_scope,
      context_scope_prefix: context_scope_prefix,
      assign_scope: assign_scope,
      assign_scope_prefix: assign_scope_prefix,
      scope_param_route_prefix: Scope.route_prefix("scope", schema),
      scope_param: scope_param(schema),
      scope_param_prefix: scope_param_prefix(schema),
      scope_socket_route_prefix: Scope.route_prefix(socket_scope, schema),
      scope_assign_route_prefix: scope_assign_route_prefix(schema),
      test_context_scope:
        if(schema.scope && schema.scope.route_prefix, do: ", scope: scope", else: "")
    ]

    prompt_for_conflicts(context)

    context
    |> copy_new_files(binding)
    |> print_shell_instructions()
  end

  defp validate_context!(context) do
    if context.schema.singular == "form" do
      Gen.Context.raise_with_help(
        "cannot use form as the schema name because it conflicts with the LiveView assigns!"
      )
    end
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

  defp files_to_be_generated(%Context{schema: schema, context_app: context_app}) do
    web_prefix = Mix.Corex.web_path(context_app)
    test_prefix = Mix.Corex.web_test_path(context_app)
    web_path = to_string(schema.web_path)
    live_subdir = "#{schema.singular}_live"
    web_live = Path.join([web_prefix, "live", web_path, live_subdir])
    test_live = Path.join([test_prefix, "live", web_path])

    [
      {:eex, "show.ex", Path.join(web_live, "show.ex")},
      {:eex, "index.ex", Path.join(web_live, "index.ex")},
      {:eex, "form.ex", Path.join(web_live, "form.ex")},
      {:eex, "live_test.exs", Path.join(test_live, "#{schema.singular}_live_test.exs")}
    ]
  end

  defp copy_new_files(%Context{} = context, binding) do
    files = files_to_be_generated(context)

    binding =
      Keyword.merge(binding,
        assigns: %{
          web_namespace: inspect(context.web_module),
          gettext: true,
          live: true,
          javascript: true
        }
      )

    template_dirs = Mix.Corex.generator_template_dirs("corex.gen.live")
    Mix.Corex.copy_from(template_dirs, "", binding, files)

    if context.generate?, do: Mix.Corex.Gen.Context.copy_new_files(context, binding)

    context
  end

  @doc false
  def print_shell_instructions(%Context{schema: schema, context_app: ctx_app} = context) do
    layout_opts = layout_generators_opts(context, web_app_name(context))
    layout_locale = layout_locale?(layout_opts)
    prefix = Module.concat(context.web_module, schema.web_namespace)
    web_path = Mix.Corex.web_path(ctx_app)

    scope_instruction =
      if layout_locale do
        "Add the live routes inside the existing scope \"/:locale\" block in #{web_path}/router.ex:"
      else
        "Add the live routes to your browser scope in #{web_path}/router.ex:"
      end

    if schema.web_namespace do
      Mix.shell().info("""

      #{scope_instruction}

          scope "/#{schema.web_path}", #{inspect(prefix)} do
            pipe_through :browser
            ...

      #{for line <- live_route_instructions(schema), do: "      #{line}"}
          end
      """)
    else
      Mix.shell().info("""

      #{scope_instruction}

      #{for line <- live_route_instructions(schema), do: "    #{line}"}
      """)
    end

    if schema.scope do
      Mix.shell().info(
        "Ensure the routes are defined in a block that sets the `#{inspect(context.scope.assign_key)}` assign."
      )
    end

    if context.generate?, do: Mix.Corex.Gen.Context.print_shell_instructions(context)
    maybe_print_upgrade_info()
  end

  defp maybe_print_upgrade_info do
    unless Code.ensure_loaded?(Phoenix.LiveView.JS) do
      Mix.shell().info("""

      You must update :phoenix_live_view to v0.18 or later and
      :phoenix_live_dashboard to v0.7 or later to use the features
      in this generator.
      """)
    end
  end

  defp live_route_instructions(schema) do
    route_base =
      if schema.scope && schema.scope.route_prefix do
        scope_prefix = schema.scope.route_prefix
        "#{scope_prefix}/#{schema.plural}"
      else
        "/#{schema.plural}"
      end

    [
      ~s|live "#{route_base}", #{inspect(schema.alias)}Live.Index, :index\n|,
      ~s|live "#{route_base}/new", #{inspect(schema.alias)}Live.Form, :new\n|,
      ~s|live "#{route_base}/:#{schema.opts[:primary_key] || :id}", #{inspect(schema.alias)}Live.Show, :show\n|,
      ~s|live "#{route_base}/:#{schema.opts[:primary_key] || :id}/edit", #{inspect(schema.alias)}Live.Form, :edit|
    ]
  end

  @doc false
  def inputs(%Schema{} = schema) do
    schema.attrs
    |> Enum.reject(fn {_key, type} -> type == :map end)
    |> Enum.map(fn
      {key, :integer} ->
        number_input_block(key, nil)

      {key, :float} ->
        number_input_block(key, 0.1)

      {key, :decimal} ->
        number_input_block(key, 0.1)

      {key, :boolean} ->
        checkbox_block(key)

      {key, :text} ->
        native_input_block("textarea", key, error_slot: true)

      {key, :date} ->
        date_picker_block(key)

      {key, :time} ->
        native_input_block("time", key, error_slot: true)

      {key, :utc_datetime} ->
        native_input_block("datetime-local", key, error_slot: true)

      {key, :naive_datetime} ->
        native_input_block("datetime-local", key, error_slot: true)

      {key, {:array, _} = type} ->
        native_input_select_multiple_block(key, type)

      {key, {:enum, _}} ->
        select_enum_block(schema, key)

      {key, _} ->
        native_input_block("text", key, error_slot: true)
    end)
  end

  defp number_input_block(key, step) do
    step_attr = if step, do: " step={0.1}", else: ""

    ~s"""
    <.number_input field={@form[#{inspect(key)}]} class="number-input"#{step_attr}>
      <:label>#{label(key)}</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.number_input>
    """
  end

  defp checkbox_block(key) do
    ~s"""
    <.checkbox field={@form[#{inspect(key)}]} class="checkbox">
      <:label>#{label(key)}</:label>
      <:indicator>
        <.heroicon name="hero-check" class="data-checked" />
      </:indicator>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.checkbox>
    """
  end

  defp date_picker_block(key) do
    ~s"""
    <.date_picker field={@form[#{inspect(key)}]} class="date-picker">
      <:label>#{label(key)}</:label>
      <:trigger>
        <.heroicon name="hero-calendar" class="icon" />
      </:trigger>
      <:prev_trigger>
        <.heroicon name="hero-chevron-left" class="icon" />
      </:prev_trigger>
      <:next_trigger>
        <.heroicon name="hero-chevron-right" class="icon" />
      </:next_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.date_picker>
    """
  end

  defp native_input_select_multiple_block(key, type) do
    opts = default_options(type)
    opts_inspect = inspect(opts)

    ~s"""
    <.native_input
      field={@form[#{inspect(key)}]}
      type="select"
      multiple
      options={#{opts_inspect}}
      class="native-input"
    >
      <:label>#{label(key)}</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.native_input>
    """
  end

  defp select_enum_block(%Schema{} = schema, key) do
    ~s"""
    <.select
      field={@form[#{inspect(key)}]}
      class="select"
      items={
        Enum.map(Ecto.Enum.values(#{inspect(schema.module)}, #{inspect(key)}), fn v ->
          %{id: v, label: Phoenix.Naming.humanize(to_string(v))}
        end)
      }
      translation={%Corex.Select.Translation{placeholder: "Choose a value"}}
    >
      <:label>#{label(key)}</:label>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.select>
    """
  end

  defp native_input_block(type, key, opts) do
    error = if Keyword.get(opts, :error_slot, false), do: "\n  " <> error_slot(), else: ""

    ~s"""
    <.native_input
      field={@form[#{inspect(key)}]}
      type="#{type}"
      class="native-input"
    >
      <:label>#{label(key)}</:label>#{error}
    </.native_input>
    """
  end

  defp error_slot do
    ~s"""
    <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    """
  end

  defp default_options({:array, :string}),
    do: Enum.map([1, 2], &{"Option #{&1}", "option#{&1}"})

  defp default_options({:array, :integer}),
    do: Enum.map([1, 2], &{"#{&1}", &1})

  defp default_options({:array, _}), do: []

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))

  defp scope_param(%{scope: nil}), do: ""

  defp scope_param(%{scope: %{route_prefix: route_prefix}}) when not is_nil(route_prefix),
    do: "scope"

  defp scope_param(_), do: "_scope"

  defp scope_param_prefix(schema) do
    param = scope_param(schema)
    if param != "", do: "#{param}, ", else: ""
  end

  defp scope_assign_route_prefix(
         %{scope: %{route_prefix: route_prefix, assign_key: assign_key}} = schema
       )
       when not is_nil(route_prefix) do
    Scope.route_prefix("@#{assign_key}", schema)
  end

  defp scope_assign_route_prefix(_), do: ""

  defp web_app_name(%Context{} = context) do
    context.web_module
    |> inspect()
    |> Phoenix.Naming.underscore()
  end

  defp layout_generators_opts(_context, _web_app_name) do
    Application.get_env(:corex, :generators, [])[:layout] || []
  end

  defp layout_locale?(opts), do: Keyword.has_key?(opts, :locale)
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
end
