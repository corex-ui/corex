defmodule Mix.Corex do
  @moduledoc false

  alias Phoenix.Naming

  @doc """
  Evals EEx files from source dir.

  Files are evaluated against EEx according to
  the given binding.
  """
  def eval_from(apps, source_file_path, binding) do
    sources = Enum.map(apps, &to_app_source(&1, source_file_path))

    content =
      Enum.find_value(sources, fn source ->
        File.exists?(source) && File.read!(source)
      end) || raise "could not find #{source_file_path} in any of the sources"

    EEx.eval_string(content, binding)
  end

  def eval_from_roots(roots, relative_path, binding) when is_list(roots) do
    path =
      Enum.find_value(roots, fn root ->
        full = Path.join(root, relative_path)
        if File.exists?(full), do: full
      end) || raise "could not find #{relative_path} in any of the template roots"

    content = File.read!(path)
    EEx.eval_string(content, binding)
  end

  def inject_eex_before_final_end(content_to_inject, file_path, binding) do
    file = File.read!(file_path)

    if String.contains?(file, content_to_inject) do
      :ok
    else
      Mix.shell().info([:green, "* injecting ", :reset, Path.relative_to_cwd(file_path)])

      new_content =
        file
        |> String.trim_trailing()
        |> String.trim_trailing("end")
        |> EEx.eval_string(binding)
        |> Kernel.<>(content_to_inject)
        |> Kernel.<>("end\n")

      File.write!(file_path, new_content)
    end
  end

  @doc """
  Returns the Mix project root (directory containing mix.exs), falling back to cwd.
  """
  def project_root do
    if mix_project_loaded?() do
      Mix.Project.deps_path()
      |> Path.expand()
      |> Path.dirname()
    else
      mix_root(File.cwd!())
    end
  end

  defp mix_project_loaded? do
    Code.ensure_loaded?(Mix.Project) and is_atom(Mix.Project.config()[:app])
  end

  defp mix_root(dir) do
    expanded = Path.expand(dir)

    if File.regular?(Path.join(expanded, "mix.exs")) do
      expanded
    else
      parent = Path.dirname(expanded)

      if parent == expanded do
        expanded
      else
        mix_root(parent)
      end
    end
  end

  @doc """
  Raises unless `path` resolves inside `root` (default: `project_root/0`).
  """
  def assert_within_project_root!(path, root \\ nil) do
    root = Path.expand(root || project_root())
    expanded = Path.expand(path)

    if within_root?(expanded, root) do
      :ok
    else
      Mix.raise("""
      Path must stay within the project root.

      root: #{root}
      path: #{path}
      """)
    end
  end

  defp within_root?(path, root) do
    path = Path.expand(path)
    root = Path.expand(root)

    case Path.relative_to(path, root) do
      ^path -> false
      "." -> true
      relative -> not String.starts_with?(relative, "..")
    end
  end

  @doc """
  Copies files from source dir to target dir
  according to the given map.

  Files are evaluated against EEx according to
  the given binding.
  """
  def copy_from(apps, source_dir, binding, mapping) when is_list(mapping) do
    roots =
      if source_dir == "" do
        apps
      else
        Enum.map(apps, &to_app_source(&1, source_dir))
      end

    binding =
      Keyword.merge(binding,
        maybe_heex_attr_gettext: &maybe_heex_attr_gettext/2,
        maybe_eex_gettext: &maybe_eex_gettext/2,
        maybe_heex_attr_translate: &maybe_heex_attr_translate/2,
        maybe_eex_translate: &maybe_eex_translate/2,
        maybe_heex_slot_translate: &maybe_heex_slot_translate/2,
        generators_gettext_mode: generators_gettext_mode()
      )

    for {format, source_file_path, target} <- mapping do
      source = find_source(roots, source_file_path)
      copy_from_format(format, source, target, binding)
    end
  end

  defp find_source(roots, source_file_path) do
    Enum.find_value(roots, fn root ->
      path = Path.join(root, source_file_path)
      if File.exists?(path), do: path
    end) || raise "could not find #{source_file_path} in any of the sources"
  end

  defp copy_from_format(:text, source, target, _binding) do
    Mix.Generator.create_file(target, File.read!(source))
  end

  defp copy_from_format(:eex, source, target, binding) do
    Mix.Generator.create_file(target, EEx.eval_file(source, binding))
  end

  defp copy_from_format(:new_eex, source, target, binding) do
    if File.exists?(target) do
      :ok
    else
      Mix.Generator.create_file(target, EEx.eval_file(source, binding))
    end
  end

  defp to_app_source(path, source_dir) when is_binary(path),
    do: Path.join(path, source_dir)

  defp to_app_source(app, source_dir) when is_atom(app),
    do: Application.app_dir(app, source_dir)

  @doc """
  Inflects path, scope, alias and more from the given name.

  ## Examples

      iex> Mix.Corex.inflect("user")
      [alias: "User",
       human: "User",
       base: "Corex",
       web_module: "CorexWeb",
       module: "Corex.User",
       scoped: "User",
       singular: "user",
       path: "user"]

      iex> Mix.Corex.inflect("Admin.User")
      [alias: "User",
       human: "User",
       base: "Corex",
       web_module: "CorexWeb",
       module: "Corex.Admin.User",
       scoped: "Admin.User",
       singular: "user",
       path: "admin/user"]

      iex> Mix.Corex.inflect("Admin.SuperUser")
      [alias: "SuperUser",
       human: "Super user",
       base: "Corex",
       web_module: "CorexWeb",
       module: "Corex.Admin.SuperUser",
       scoped: "Admin.SuperUser",
       singular: "super_user",
       path: "admin/super_user"]

  """
  def inflect(singular) do
    base = Mix.Corex.base()
    web_module = base |> web_module() |> inspect()
    scoped = Naming.camelize(singular)
    path = Naming.underscore(scoped)
    singular = String.split(path, "/") |> List.last()
    module = Module.concat(base, scoped) |> inspect
    alias = String.split(module, ".") |> List.last()
    human = Naming.humanize(singular)

    [
      alias: alias,
      human: human,
      base: base,
      web_module: web_module,
      module: module,
      scoped: scoped,
      singular: singular,
      path: path
    ]
  end

  @doc """
  Checks the availability of a given module name.
  """
  def check_module_name_availability!(name) do
    name = Module.concat(Elixir, name)

    if Code.ensure_loaded?(name) do
      Mix.raise("Module name #{inspect(name)} is already taken, please choose another name")
    end
  end

  @doc """
  Returns the module base name based on the configuration value.

      config :my_app
        namespace: My.App

  """
  def base do
    app_base(otp_app())
  end

  @doc """
  Returns the context module base name based on the configuration value.

      config :my_app
        namespace: My.App

  """
  def context_base(ctx_app) do
    app_base(ctx_app)
  end

  defp app_base(app) do
    case Application.get_env(app, :namespace, app) do
      ^app -> app |> to_string() |> Phoenix.Naming.camelize()
      mod -> mod |> inspect()
    end
  end

  @doc """
  Returns the OTP app from the Mix project configuration.
  """
  def otp_app do
    Mix.Project.config() |> Keyword.fetch!(:app)
  end

  @doc """
  Returns all compiled modules in a project.
  """
  def modules do
    Mix.Project.compile_path()
    |> Path.join("*.beam")
    |> Path.wildcard()
    |> Enum.map(&beam_to_module/1)
  end

  defp beam_to_module(path) do
    path |> Path.basename(".beam") |> String.to_existing_atom()
  end

  @doc """
  The paths to look for template files for generators.

  Defaults to checking the current app's `priv` directory,
  and falls back to Corex's `priv` directory.
  """
  def generator_paths do
    [".", :corex]
  end

  @doc """
  Returns the list of template directory paths for a Corex generator, in lookup order.

  Used when copying generator files so that the project can override templates
  without editing Corex's priv. Order:

    1. `priv/corex_templates/<generator_name>` in the current project
    2. `priv/templates/<generator_name>` in the current project
    3. Corex's `priv/templates/<generator_name>`

  Pass the result to `copy_from/4` with `source_dir` set to `""` so files
  are resolved under each directory.
  """
  def generator_template_dirs(generator_name) do
    cwd = File.cwd!()
    corex_priv = Application.app_dir(:corex, "priv/templates")

    [
      Path.join([cwd, "priv", "corex_templates", generator_name]),
      Path.join([cwd, "priv", "templates", generator_name]),
      Path.join(corex_priv, generator_name)
    ]
  end

  @doc """
  Checks if the given `app_path` is inside an umbrella.
  """
  def in_umbrella?(app_path) do
    umbrella = Path.expand(Path.join([app_path, "..", ".."]))
    mix_path = Path.join(umbrella, "mix.exs")
    apps_path = Path.join(umbrella, "apps")
    File.exists?(mix_path) && File.exists?(apps_path)
  end

  @doc """
  Returns the web prefix to be used in generated file specs.
  """
  def web_path(ctx_app, rel_path \\ "") when is_atom(ctx_app) do
    this_app = otp_app()

    base =
      cond do
        root = Application.get_env(this_app, :mix_test_output) ->
          Path.join(root, "web")

        ctx_app == this_app ->
          Path.join("lib", "#{this_app}_web")

        true ->
          Path.join("lib", to_string(this_app))
      end

    Path.join([base, rel_path])
  end

  @doc """
  Returns the context app path prefix to be used in generated context files.
  """
  def context_app_path(ctx_app, rel_path) when is_atom(ctx_app) do
    this_app = otp_app()

    if ctx_app == this_app do
      rel_path
    else
      app_path =
        case Application.get_env(this_app, :generators)[:context_app] do
          {^ctx_app, path} -> Path.relative_to_cwd(path)
          _ -> mix_app_path(ctx_app, this_app)
        end

      Path.join(app_path, rel_path)
    end
  end

  @doc """
  Returns the context lib path to be used in generated context files.
  """
  def context_lib_path(ctx_app, rel_path) when is_atom(ctx_app) do
    context_app_path(ctx_app, Path.join(["lib", to_string(ctx_app), rel_path]))
  end

  @doc """
  Returns the context test path to be used in generated context files.
  """
  def context_test_path(ctx_app, rel_path) when is_atom(ctx_app) do
    context_app_path(ctx_app, Path.join(["test", to_string(ctx_app), rel_path]))
  end

  @doc """
  Returns the OTP context app.
  """
  def context_app do
    this_app = otp_app()

    case fetch_context_app(this_app) do
      {:ok, app} -> app
      :error -> this_app
    end
  end

  @doc """
  Returns the test prefix to be used in generated file specs.
  """
  def web_test_path(ctx_app, rel_path \\ "") when is_atom(ctx_app) do
    this_app = otp_app()

    base =
      cond do
        root = Application.get_env(this_app, :mix_test_output) ->
          Path.join(root, "test")

        ctx_app == this_app ->
          Path.join("test", "#{this_app}_web")

        true ->
          Path.join("test", to_string(this_app))
      end

    Path.join([base, rel_path])
  end

  defp fetch_context_app(this_otp_app) do
    case Application.get_env(this_otp_app, :generators)[:context_app] do
      nil ->
        :error

      false ->
        Mix.raise("""
        no context_app configured for current application #{this_otp_app}.

        Add the context_app generators config in config.exs, or pass the
        --context-app option explicitly to the generators. For example:

        via config:

            config :#{this_otp_app}, :generators,
              context_app: :some_app

        via cli option:

            mix corex.gen.[task] --context-app some_app

        Note: cli option only works when `context_app` is not set to `false`
        in the config.
        """)

      {app, _path} ->
        {:ok, app}

      app ->
        {:ok, app}
    end
  end

  defp mix_app_path(app, this_otp_app) do
    case Mix.Project.deps_paths() do
      %{^app => path} ->
        Path.relative_to_cwd(path)

      deps ->
        Mix.raise("""
        no directory for context_app #{inspect(app)} found in #{this_otp_app}'s deps.

        Ensure you have listed #{inspect(app)} as an in_umbrella dependency in mix.exs:

            def deps do
              [
                {:#{app}, in_umbrella: true},
                ...
              ]
            end

        Existing deps:

            #{inspect(Map.keys(deps))}

        """)
    end
  end

  @doc """
  Prompts to continue if any files exist.
  """
  def prompt_for_conflicts(generator_files) do
    file_paths =
      Enum.flat_map(generator_files, fn
        {:new_eex, _, _path} -> []
        {_kind, _, path} -> [path]
      end)

    case Enum.filter(file_paths, &File.exists?(&1)) do
      [] ->
        :ok

      conflicts ->
        Mix.shell().info("""
        The following files conflict with new files to be generated:

        #{Enum.map_join(conflicts, "\n", &"  * #{&1}")}

        See the --web option to namespace similarly named resources
        """)

        if Mix.shell().yes?("Proceed with interactive overwrite?") do
          :ok
        else
          System.halt()
        end
    end
  end

  @doc """
  Returns the web module prefix.
  """
  def web_module(base) do
    if base |> to_string() |> String.ends_with?("Web") do
      Module.concat([base])
    else
      Module.concat(["#{base}Web"])
    end
  end

  def to_text(data) do
    inspect(data, limit: :infinity, printable_limit: :infinity)
  end

  def prepend_newline(string) do
    "\n" <> string
  end

  @doc """
  Ensures user's LiveView is compatible with the current generators.
  """
  def ensure_live_view_compat!(generator_mod) do
    vsn = Application.spec(:corex_live_view)[:vsn]

    # if lv is not installed, such as in corex's own test env, do not raise
    if vsn && Version.compare("#{vsn}", "1.0.0-rc.7") != :gt do
      raise "#{inspect(generator_mod)} requires :corex_live_view >= 1.0.0, got: #{vsn}"
    end
  end

  # In the context of a HEEx attribute value, transforms a given message into a
  # dynamic `gettext` call or a fixed-value string attribute, depending on the
  # `gettext?` parameter.
  #
  # ## Examples
  #
  #     iex> ~s|<tag attr=#{maybe_heex_attr_gettext("Hello", true)} />|
  #     ~S|<tag attr={gettext("Hello")} />|
  #
  #     iex> ~s|<tag attr=#{maybe_heex_attr_gettext("Hello", false)} />|
  #     ~S|<tag attr="Hello" />|
  defp maybe_heex_attr_gettext(message, gettext?) do
    mode = if gettext?, do: :gettext, else: false
    maybe_heex_attr_translate(message, mode)
  end

  def maybe_heex_attr_translate(message, false), do: inspect(message)

  def maybe_heex_attr_translate(message, :gettext) do
    ~s|{gettext(#{inspect(message)})}|
  end

  def maybe_heex_attr_translate(message, :sigils) do
    ~s|{~t#{inspect(message)}}|
  end

  # In the context of an EEx template, transforms a given message into a dynamic
  # `gettext` call or the message as is, depending on the `gettext?` parameter.
  #
  # ## Examples
  #
  #     iex> ~s|<tag>#{maybe_eex_gettext("Hello", true)}</tag>|
  #     ~S|<tag><%= gettext("Hello") %></tag>|
  #
  #     iex> ~s|<tag>#{maybe_eex_gettext("Hello", false)}</tag>|
  #     ~S|<tag>Hello</tag>|
  defp maybe_eex_gettext(message, gettext?) do
    mode = if gettext?, do: :gettext, else: false
    maybe_eex_translate(message, mode)
  end

  def maybe_eex_translate(message, false), do: message

  def maybe_eex_translate(message, :gettext) do
    ~s|<%= gettext(#{inspect(message)}) %>|
  end

  def maybe_eex_translate(message, :sigils) do
    "{~t#{inspect(message)}}"
  end

  @doc "Like `maybe_eex_translate/2` but for plain HEEx slot text (no `<%= %>` wrapper)."
  def maybe_heex_slot_translate(message, mode), do: maybe_eex_translate(message, mode)

  @doc "Returns generator options from `config :corex, :generators`."
  def generators_opts do
    Application.get_env(:corex, :generators, [])
  end

  @doc "Returns `:layout` generator options from application config."
  def layout_generators_opts do
    generators_opts()[:layout] || []
  end

  @doc """
  Returns how generators should wrap user-facing copy.

  * `false` — plain strings
  * `:gettext` — `gettext("...")` / `{gettext("...")}`
  * `:sigils` — `~t"..."` / `{~t"..."}` (requires `gettext_sigils` in `html_helpers`)

  Reads `config :corex, :generators` (`:gettext`, `:gettext_sigils`) or detects
  `GettextSigils` in the current project's `lib/<app>_web.ex`.
  """
  def generators_gettext_mode do
    gens = generators_opts()

    cond do
      gens[:gettext_sigils] == true or gens[:gettext] == :sigils ->
        :sigils

      gens[:gettext] == true ->
        :gettext

      true ->
        detect_gettext_mode_from_web()
    end
  end

  defp detect_gettext_mode_from_web do
    case web_ex_path_from_project() do
      nil ->
        false

      path ->
        content = read_web_ex(path)

        cond do
          String.contains?(content, "GettextSigils") -> :sigils
          String.contains?(content, "use Gettext, backend:") -> :gettext
          true -> false
        end
    end
  end

  defp web_ex_path_from_project do
    app = otp_app() |> to_string()
    path = Path.join("lib", app <> ".ex")
    if File.exists?(path), do: path, else: nil
  end

  @doc "Returns whether the web module defines verified route path prefixes."
  def verified_routes_path_prefixes?(web_module) when is_atom(web_module) do
    web_module
    |> web_ex_path()
    |> read_web_ex()
    |> String.contains?("path_prefixes:")
  end

  @doc "Returns whether generated routes should be scoped by locale."
  def locale_scoped_routes?(web_module, layout_opts)
      when is_atom(web_module) and is_list(layout_opts) do
    verified_routes_path_prefixes?(web_module) or Keyword.has_key?(layout_opts, :locale)
  end

  @doc "Returns whether generated layout paths should include a locale segment."
  def layout_locale_paths?(web_module, layout_opts)
      when is_atom(web_module) and is_list(layout_opts) do
    Keyword.has_key?(layout_opts, :locale) and not verified_routes_path_prefixes?(web_module)
  end

  def format_generated_files(files) when is_list(files) do
    paths = for {_, _, path} <- files, do: path

    if paths != [] do
      Mix.Task.run("format", paths)
    end
  end

  defp web_ex_path(web_module) do
    web_module
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
    |> then(&Path.join("lib", &1 <> ".ex"))
  end

  defp read_web_ex(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> ""
    end
  end
end
