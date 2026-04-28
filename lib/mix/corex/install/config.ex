defmodule Mix.Corex.Install.Config do
  @moduledoc false

  alias Igniter.Project.{Config, Deps, TaskAliases}

  @all_themes ~w(neo uno duo leo)

  def validate_opts!(opts) do
    if opts[:designex] == true and opts[:design] == false do
      Mix.raise(
        "--designex requires design. Remove `--no-design` or disable `--designex`." <>
          "\n\n" <> manual_install_hint()
      )
    end

    if opts[:mode] == true and opts[:design] == false do
      Mix.raise(
        "--mode requires design. Remove `--no-design` (design will auto-enable for `--mode`)." <>
          "\n\n" <> manual_install_hint()
      )
    end

    if opts[:theme] == true and opts[:design] == false do
      Mix.raise(
        "--theme requires design. Remove `--no-design` (design will auto-enable for `--theme`)." <>
          "\n\n" <> manual_install_hint()
      )
    end

    :ok
  end

  @doc """
  Returns `opts` with `:design` set to `true` when any UI flag (`--mode`, `--theme`, `--designex`)
  implies design. Caller may pass `notify: false` to suppress the printed notice.
  """
  def maybe_auto_enable_design(opts, notify_opts \\ []) when is_list(opts) do
    notify? = Keyword.get(notify_opts, :notify, true)
    needs_design? = opts[:mode] == true or opts[:theme] == true or opts[:designex] == true

    cond do
      not needs_design? ->
        opts

      Keyword.get(opts, :design) == true ->
        opts

      true ->
        if notify? do
          Mix.shell().info(
            "* Corex: enabling --design because --mode/--theme/--designex was set; pass --no-design to opt out."
          )
        end

        Keyword.put(opts, :design, true)
    end
  end

  def themes_from_opts(opts) do
    if opts[:theme] == true, do: @all_themes, else: []
  end

  def design_on?(opts), do: Keyword.get(opts, :design, true)

  defp manual_install_hint do
    """
    If automated install is not an option, add Corex to an app yourself:

      * Follow https://hexdocs.pm/corex/manual_installation.html (or guides/manual_installation.md in the repo) — add the dependency, `import corex` and hooks in `assets/js/app.js`, and esbuild ESM flags in `config/config.exs` as shown there.
    """
  end

  def maybe_add_localize_web_dep(igniter, false), do: igniter

  def maybe_add_localize_web_dep(igniter, true) do
    Deps.add_dep(igniter, {:localize_web, "~> 0.5"})
  end

  def maybe_configure_localize_runtime(igniter, _web_mod, false), do: igniter

  def maybe_configure_localize_runtime(igniter, web_mod, true) do
    gettext_backend = Module.concat(web_mod, Gettext)

    block =
      "config :localize,\n  supported_locales: Gettext.known_locales(#{inspect(gettext_backend)}) |> Enum.map(&String.to_atom/1)\n"

    path = "config/runtime.exs"

    if Igniter.exists?(igniter, path) do
      Igniter.update_file(
        igniter,
        path,
        &merge_localize_runtime_into_source(&1, gettext_backend, block)
      )
    else
      Igniter.include_or_create_file(igniter, path, "import Config\n\n" <> block)
    end
  end

  defp merge_localize_runtime_into_source(source, gettext_backend, block) do
    content = Rewrite.Source.get(source, :content)

    if String.contains?(content, "Gettext.known_locales(#{inspect(gettext_backend)})") do
      source
    else
      base = runtime_exs_base_content(content)
      Rewrite.Source.update(source, :content, String.trim_trailing(base) <> "\n\n" <> block)
    end
  end

  defp runtime_exs_base_content(content) do
    if String.contains?(String.trim_leading(content), "import Config") do
      content
    else
      "import Config\n\n" <> String.trim_leading(content)
    end
  end

  defp append_designex_config_block(source, block) do
    content = Rewrite.Source.get(source, :content)

    if String.contains?(content, "config :designex") do
      source
    else
      Rewrite.Source.update(source, :content, String.trim_trailing(content) <> block)
    end
  end

  def configure_app_env(igniter, app, themes) do
    if themes != [] do
      Config.configure_new(igniter, "config.exs", app, [:themes], themes)
    else
      igniter
    end
  end

  def configure_designex(igniter, opts) do
    if opts[:designex] do
      block = """

      config :designex,
        version: "1.0.2",
        commit: "1da4b31",
        cd: Path.expand("../assets", __DIR__),
        dir: "corex",
        corex: [
          build_args: ~w(--dir=design --script=build.mjs --tokens=tokens)
        ]
      """

      Igniter.update_file(igniter, "config/config.exs", &append_designex_config_block(&1, block))
    else
      igniter
    end
  end

  def maybe_add_designex_dep(igniter, opts) do
    if opts[:designex] do
      Deps.add_dep(
        igniter,
        {:designex, "~> 1.0", [runtime: quote(do: Mix.env() == :dev)]}
      )
    else
      igniter
    end
  end

  def maybe_add_designex_alias(igniter, opts) do
    if opts[:designex] do
      igniter
      |> insert_designex_before_tailwind(:"assets.build")
      |> insert_designex_before_tailwind(:"assets.deploy")
    else
      igniter
    end
  end

  defp insert_designex_before_tailwind(igniter, alias_name) do
    TaskAliases.modify_existing_alias(igniter, alias_name, fn zipper ->
      zipper = ensure_alias_value_is_list(zipper)

      cond do
        not Igniter.Code.List.list?(zipper) ->
          :error

        designex_corex_present?(zipper) ->
          {:ok, zipper}

        true ->
          case Igniter.Code.List.move_to_list_item(zipper, &tailwind_string_item?/1) do
            {:ok, item_zipper} ->
              {:ok, Sourceror.Zipper.insert_left(item_zipper, string_node("designex corex"))}

            :error ->
              :error
          end
      end
    end)
  end

  defp ensure_alias_value_is_list(zipper) do
    if Igniter.Code.List.list?(zipper) do
      zipper
    else
      Igniter.Code.Common.replace_code(zipper, [zipper.node])
    end
  end

  defp designex_corex_present?(list_zipper) do
    case Igniter.Code.List.move_to_list_item(list_zipper, &designex_corex_item?/1) do
      {:ok, _} -> true
      :error -> false
    end
  end

  defp designex_corex_item?(zipper), do: literal_string(zipper) == "designex corex"

  defp tailwind_string_item?(zipper) do
    case literal_string(zipper) do
      s when is_binary(s) -> Elixir.String.starts_with?(s, "tailwind ")
      _ -> false
    end
  end

  defp literal_string(%{node: node}), do: literal_string(node)
  defp literal_string({:__block__, _, [v]}) when is_binary(v), do: v
  defp literal_string(v) when is_binary(v), do: v
  defp literal_string(_), do: nil

  defp string_node(s), do: {:__block__, [delimiter: "\""], [s]}

  def configure_test_phoenix(igniter) do
    path = "test.exs"

    if Igniter.exists?(igniter, path) do
      Config.configure_new(
        igniter,
        path,
        :phoenix,
        [:sort_verified_routes_query_params],
        true
      )
    else
      igniter
    end
  end
end
