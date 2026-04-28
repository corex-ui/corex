defmodule Mix.Corex.Install.Web do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Igniter.Libs.Phoenix, as: ILPhoenix
  alias Mix.Corex.Install.{Config, Templates}

  # --- Web module ---

  def patch_web_module(igniter, web_mod, _i18n?) do
    path = Igniter.Project.Module.proper_location(igniter, web_mod)
    Igniter.update_elixir_file(igniter, path, &inject_use_corex/1)
  end

  defp inject_use_corex(zipper) do
    with {:ok, z} <- Function.move_to_defp(zipper, :html_helpers, 0),
         {:ok, z} <- Common.move_to_do_block(z) do
      html_helpers_inject_result(z, zipper)
    else
      _ ->
        {:warning,
         "Could not find `defp html_helpers`; add `use Corex` inside its `quote` block manually."}
    end
  end

  defp html_helpers_inject_result(z, zipper) do
    if html_helpers_has_use_corex?(z) do
      {:ok, zipper}
    else
      case move_to_import_for_corex(z) do
        {:ok, iz} ->
          {:ok, Common.add_code(iz, "use Corex", placement: :after)}

        :error ->
          {:warning,
           "Could not inject `use Corex` in `html_helpers`; add `use Corex` next to your HTML imports in the web module."}
      end
    end
  end

  defp html_helpers_has_use_corex?(zipper) do
    match?(
      {:ok, _},
      Function.move_to_function_call_in_current_scope(zipper, :use, [1, 2], fn z ->
        Function.argument_equals?(z, 0, Corex)
      end)
    )
  end

  defp move_to_import_for_corex(zipper) do
    [
      {2, Phoenix.HTML},
      {2, Phoenix.Component},
      {1, Phoenix.HTML},
      {1, Phoenix.Component}
    ]
    |> Enum.find_value(:error, &import_candidate_for_corex(zipper, &1))
  end

  defp import_candidate_for_corex(zipper, {arity, mod}) do
    case Function.move_to_function_call_in_current_scope(zipper, :import, arity, fn z ->
           Function.argument_equals?(z, 0, mod)
         end) do
      {:ok, z} -> {:ok, z}
      _ -> nil
    end
  end

  # --- Endpoint ---

  def patch_endpoint_dev_plugs(igniter, web_mod, mcp?) do
    if mcp? == false do
      igniter
    else
      mod = Module.concat(web_mod, Endpoint)
      path = Igniter.Project.Module.proper_location(igniter, mod)

      Igniter.update_elixir_file(igniter, path, fn zipper ->
        inject_mcp_plug(zipper, mod)
      end)
    end
  end

  def endpoint_mcp_apply(content, opts) when is_binary(content) and is_list(opts) do
    patch_endpoint_mcp_plugs_in_string(content, Keyword.get(opts, :mcp, true))
  end

  defp inject_mcp_plug(zipper, mod) do
    root = Sourceror.Zipper.topmost(zipper)
    root_str = root.node |> Sourceror.to_string()

    if String.contains?(root_str, "plug Corex.MCP") do
      {:ok, zipper}
    else
      inject_mcp_after_socket_or_static(zipper, mod)
    end
  end

  defp inject_mcp_after_socket_or_static(zipper, mod) do
    case Function.move_to_function_call(
           zipper,
           :socket,
           [2, 3],
           fn _z -> true end
         ) do
      {:ok, socket_zipper} ->
        {:ok, Common.add_code(socket_zipper, mcp_block_string(), placement: :after)}

      :error ->
        inject_mcp_after_static_plug(zipper, mod)
    end
  end

  defp inject_mcp_after_static_plug(zipper, mod) do
    case Function.move_to_function_call(
           zipper,
           :plug,
           [1, 2],
           &static_plug?/1
         ) do
      {:ok, static_plug_zipper} ->
        {:ok, Common.add_code(static_plug_zipper, mcp_block_string(), placement: :after)}

      :error ->
        {:warning,
         "Could not insert `plug Corex.MCP` in #{inspect(mod)}. Add this near the dev-only plugs:\n\nif Mix.env() == :dev do\n  plug Corex.MCP\nend\n"}
    end
  end

  defp static_plug?(z) do
    Function.argument_equals?(z, 0, Plug.Static)
  end

  defp mcp_block_string do
    """
    if Mix.env() == :dev do
      plug Corex.MCP
    end\
    """
  end

  defp patch_endpoint_mcp_plugs_in_string(content, mcp?)
       when is_binary(content) and is_boolean(mcp?) do
    block = """
      if Mix.env() == :dev do
        plug Corex.MCP
      end\
    """

    add_mcp = mcp? && not String.contains?(content, "plug Corex.MCP")

    if add_mcp do
      insert_mcp_plug_block_in_string(content, block)
    else
      content
    end
  end

  defp insert_mcp_plug_block_in_string(content, block) do
    needle = "  # Code reloading can be explicitly"

    if String.contains?(content, needle) do
      String.replace(content, needle, block <> "\n\n" <> needle, global: false)
    else
      insert_mcp_plug_after_anchor(content, block)
    end
  end

  defp insert_mcp_plug_after_anchor(content, block) do
    anchor = "    raise_on_missing_only: code_reloading?\n\n"

    if String.contains?(content, anchor) do
      String.replace(content, anchor, anchor <> block <> "\n", global: false)
    else
      content
    end
  end

  def create_plug_files(igniter, web_mod, app, opts, i18n?) do
    themes = Config.themes_from_opts(opts)
    dir = Path.join([web_ex_dir(igniter, web_mod), "plugs"])
    web_str = inspect(web_mod)
    app_str = inspect(app)

    igniter
    |> then(fn i ->
      if opts[:mode] do
        write_plug(i, Path.join(dir, "mode.ex"), Templates.plug_mode(web_str))
      else
        i
      end
    end)
    |> then(fn i ->
      if themes != [] do
        write_plug(i, Path.join(dir, "theme.ex"), Templates.plug_theme(web_str, app_str))
      else
        i
      end
    end)
    |> then(fn i ->
      if i18n? do
        write_plug(i, Path.join(dir, "path.ex"), Templates.plug_path(web_str))
      else
        i
      end
    end)
  end

  defp write_plug(igniter, path, contents) do
    igniter = Igniter.include_or_create_file(igniter, path, contents)

    Igniter.update_file(igniter, path, fn source ->
      current = Rewrite.Source.get(source, :content)

      if current == contents do
        source
      else
        Rewrite.Source.update(source, :content, contents)
      end
    end)
  end

  # --- Router ---

  def patch_router_for_plugs(igniter, web_mod, opts, themes, i18n?) do
    {igniter, router} =
      ILPhoenix.select_router(
        igniter,
        "Corex: which router should receive localize plugs?"
      )

    router_mod = router || Module.concat(web_mod, :Router)
    path = Igniter.Project.Module.proper_location(igniter, router_mod)
    gettext_backend = Module.concat(web_mod, Gettext)
    need_plugs? = opts[:mode] || themes != [] || i18n?

    if need_plugs? do
      igniter
      |> maybe_insert_use_localize_routes(path, web_mod, gettext_backend, i18n?)
      |> maybe_insert_localize_plugs(path, gettext_backend, i18n?)
      |> maybe_wrap_home_in_localize(path, i18n?)
      |> insert_mode_theme_plugs(path, web_mod, opts, themes)
      |> maybe_insert_path_plug_after_localize(path, web_mod, i18n?)
    else
      igniter
    end
  end

  defp maybe_insert_use_localize_routes(igniter, _path, _web_mod, _gettext, false), do: igniter

  defp maybe_insert_use_localize_routes(igniter, path, web_mod, gettext_backend, true) do
    Igniter.update_elixir_file(igniter, path, fn zipper ->
      insert_localize_routes_use(zipper, web_mod, gettext_backend)
    end)
  end

  defp insert_localize_routes_use(zipper, web_mod, gettext_backend) do
    root = Sourceror.Zipper.topmost(zipper) |> source_string()

    if String.contains?(root, "use Localize.Routes") do
      {:ok, zipper}
    else
      add_localize_routes_after_router(zipper, web_mod, gettext_backend)
    end
  end

  defp add_localize_routes_after_router(zipper, web_mod, gettext_backend) do
    case Function.move_to_function_call(zipper, :use, [1, 2], fn z ->
           Function.argument_equals?(z, 0, web_mod) and
             Function.argument_equals?(z, 1, :router)
         end) do
      {:ok, use_z} ->
        {:ok,
         Common.add_code(
           use_z,
           "use Localize.Routes, gettext: #{inspect(gettext_backend)}",
           placement: :after
         )}

      :error ->
        {:warning,
         "Could not find `use #{inspect(web_mod)}, :router`; add `use Localize.Routes, gettext: #{inspect(gettext_backend)}` after it manually."}
    end
  end

  defp maybe_insert_localize_plugs(igniter, _path, _gettext, false), do: igniter

  defp maybe_insert_localize_plugs(igniter, path, gettext_backend, true) do
    Igniter.update_elixir_file(igniter, path, fn zipper ->
      insert_localize_plugs_if_needed(zipper, gettext_backend)
    end)
  end

  defp insert_localize_plugs_if_needed(zipper, gettext_backend) do
    root_str = Sourceror.Zipper.topmost(zipper) |> source_string()

    if String.contains?(root_str, "Localize.Plug.PutLocale") do
      {:ok, zipper}
    else
      add_localize_plugs_after_live_flash(zipper, gettext_backend)
    end
  end

  defp add_localize_plugs_after_live_flash(zipper, gettext_backend) do
    block =
      "plug Localize.Plug.PutLocale,\n  from: [:route, :session, :accept_language, :query, :path],\n  gettext: #{inspect(gettext_backend)}\n\nplug Localize.Plug.PutSession, as: :string"

    case Function.move_to_function_call(zipper, :plug, [1, 2], fn z ->
           Function.argument_equals?(z, 0, :fetch_live_flash)
         end) do
      {:ok, z} ->
        {:ok, Common.add_code(z, block, placement: :after)}

      :error ->
        {:warning,
         "Could not find `plug :fetch_live_flash`; add Localize plugs after it manually."}
    end
  end

  defp maybe_wrap_home_in_localize(igniter, _path, false), do: igniter

  defp maybe_wrap_home_in_localize(igniter, path, true) do
    Igniter.update_file(igniter, path, fn source ->
      content = Rewrite.Source.get(source, :content)
      Rewrite.Source.update(source, :content, wrap_home_in_localize(content))
    end)
  end

  defp maybe_insert_path_plug_after_localize(i, path, web_mod, true) do
    insert_path_plug_after_localize(i, path, web_mod)
  end

  defp maybe_insert_path_plug_after_localize(i, _path, _web_mod, false), do: i

  defp source_string(z) do
    z.node |> Sourceror.to_string()
  end

  defp insert_mode_theme_plugs(igniter, router_path, web_mod, opts, themes) do
    lines =
      []
      |> then(fn acc ->
        if opts[:mode], do: ["plug #{inspect(web_mod)}.Plugs.Mode" | acc], else: acc
      end)
      |> then(fn acc ->
        if themes != [], do: ["plug #{inspect(web_mod)}.Plugs.Theme" | acc], else: acc
      end)
      |> Enum.reverse()

    if lines == [] do
      igniter
    else
      Igniter.update_elixir_file(igniter, router_path, fn zipper ->
        inject_mode_theme_plugs(zipper, web_mod, lines)
      end)
    end
  end

  defp inject_mode_theme_plugs(zipper, web_mod, lines) do
    root = Sourceror.Zipper.topmost(zipper)
    root_str = root.node |> Sourceror.to_string()

    if router_contains_mode_theme_plugs?(root_str, web_mod) do
      {:ok, zipper}
    else
      inject_lines_after_live_flash(zipper, lines)
    end
  end

  defp router_contains_mode_theme_plugs?(root_str, web_mod) do
    String.contains?(root_str, "#{inspect(web_mod)}.Plugs.Mode") or
      String.contains?(root_str, "#{inspect(web_mod)}.Plugs.Theme")
  end

  defp inject_lines_after_live_flash(zipper, lines) do
    inject = Enum.map_join(lines, "\n", &("    " <> &1))

    case Function.move_to_function_call(zipper, :plug, [1, 2], fn z ->
           Function.argument_equals?(z, 0, :fetch_live_flash)
         end) do
      {:ok, z} ->
        {:ok, Common.add_code(z, inject, placement: :after)}

      :error ->
        {:warning,
         "Could not find `plug :fetch_live_flash`; add Corex plugs after it:\n\n#{inject}\n"}
    end
  end

  defp wrap_home_in_localize(content) do
    cond do
      String.contains?(content, "localize do") ->
        content

      String.contains?(content, "pipe_through :browser\n\n    get \"/\", PageController, :home") ->
        String.replace(
          content,
          "pipe_through :browser\n\n    get \"/\", PageController, :home",
          "pipe_through :browser\n\n    localize do\n    get \"/\", PageController, :home\n    end",
          global: false
        )

      true ->
        content
    end
  end

  defp insert_path_plug_after_localize(igniter, router_path, web_mod) do
    plug_mod = Module.concat(web_mod, :Plugs) |> Module.concat(:Path)
    plug_line = "plug #{inspect(plug_mod)}"

    Igniter.update_elixir_file(igniter, router_path, fn zipper ->
      insert_path_plug_zipper(zipper, plug_line)
    end)
  end

  defp insert_path_plug_zipper(zipper, plug_line) do
    root_str = Sourceror.Zipper.topmost(zipper) |> source_string()

    cond do
      String.contains?(root_str, "Plugs.Path") ->
        {:ok, zipper}

      not String.contains?(root_str, "Localize.Plug.PutSession") ->
        {:ok, zipper}

      true ->
        add_path_plug_after_put_session(zipper, plug_line)
    end
  end

  defp add_path_plug_after_put_session(zipper, plug_line) do
    case Function.move_to_function_call(zipper, :plug, [1, 2], fn z ->
           Function.argument_equals?(z, 0, Localize.Plug.PutSession)
         end) do
      {:ok, z} ->
        {:ok, Common.add_code(z, plug_line, placement: :after)}

      :error ->
        {:warning,
         "Could not find `plug Localize.Plug.PutSession`; add `#{plug_line}` after it manually."}
    end
  end

  def web_ex_dir(igniter, web_mod) do
    loc = Igniter.Project.Module.proper_location(igniter, web_mod)
    Path.join(Path.dirname(loc), Path.basename(loc, ".ex"))
  end
end
