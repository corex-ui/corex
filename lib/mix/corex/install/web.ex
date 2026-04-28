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

      Igniter.update_file(igniter, path, fn source ->
        endpoint_mcp_update(source, mod, mcp?)
      end)
    end
  end

  def endpoint_mcp_apply(content, opts) when is_binary(content) and is_list(opts) do
    patch_endpoint_mcp_plugs(content, Keyword.get(opts, :mcp, true))
  end

  defp endpoint_mcp_update(source, mod, mcp?) do
    content = Rewrite.Source.get(source, :content)
    patched = patch_endpoint_mcp_plugs(content, mcp?)

    if patched == content and mcp? and not String.contains?(content, "plug Corex.MCP") do
      {:warning,
       "Could not insert `plug Corex.MCP` in #{inspect(mod)}. Add this near the dev-only plugs:\n\nif Mix.env() == :dev do\n  plug Corex.MCP\nend\n"}
    else
      Rewrite.Source.update(source, :content, patched)
    end
  end

  defp patch_endpoint_mcp_plugs(content, mcp?) when is_binary(content) and is_boolean(mcp?) do
    mcp_block = """
      if Mix.env() == :dev do
        plug Corex.MCP
      end
    """

    add_mcp = mcp? && not String.contains?(content, "plug Corex.MCP")

    if add_mcp do
      insert_mcp_plug_block(content, String.trim_trailing(mcp_block))
    else
      content
    end
  end

  defp insert_mcp_plug_block(content, block) do
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
    if Igniter.exists?(igniter, path) do
      igniter
    else
      Igniter.include_or_create_file(igniter, path, contents)
    end
  end

  # --- Router ---

  defp merge_router_localize_plugs(source, i18n?, web_mod, gettext_backend) do
    content = Rewrite.Source.get(source, :content)

    patched =
      if i18n? && not String.contains?(content, "Localize.Plug.PutLocale") do
        content
        |> insert_use_localize_routes(web_mod, gettext_backend)
        |> insert_localize_plugs(gettext_backend)
        |> wrap_home_in_localize()
      else
        content
      end

    Rewrite.Source.update(source, :content, patched)
  end

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
      |> Igniter.update_file(path, fn source ->
        merge_router_localize_plugs(source, i18n?, web_mod, gettext_backend)
      end)
      |> insert_mode_theme_plugs(path, web_mod, opts, themes)
      |> maybe_insert_path_plug_after_localize(path, web_mod, i18n?)
    else
      igniter
    end
  end

  defp maybe_insert_path_plug_after_localize(i, path, web_mod, true) do
    insert_path_plug_after_localize(i, path, web_mod)
  end

  defp maybe_insert_path_plug_after_localize(i, _path, _web_mod, false), do: i

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

  defp insert_use_localize_routes(content, web_mod, gettext_backend) do
    needle = "use #{inspect(web_mod)}, :router\n"

    if String.contains?(content, "use Localize.Routes") do
      content
    else
      String.replace(
        content,
        needle,
        needle <> "  use Localize.Routes, gettext: #{inspect(gettext_backend)}\n",
        global: false
      )
    end
  end

  defp insert_localize_plugs(content, gettext_backend) do
    if String.contains?(content, "Localize.Plug.PutLocale") do
      content
    else
      String.replace(
        content,
        "plug :fetch_live_flash",
        "plug :fetch_live_flash\n    plug Localize.Plug.PutLocale,\n      from: [:route, :session, :accept_language, :query, :path],\n      gettext: #{inspect(gettext_backend)}\n\n    plug Localize.Plug.PutSession, as: :string",
        global: false
      )
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
    plug_line = "    plug #{inspect(web_mod)}.Plugs.Path"

    Igniter.update_file(igniter, router_path, fn source ->
      c = Rewrite.Source.get(source, :content)

      if String.contains?(c, "Plugs.Path") do
        source
      else
        c2 = insert_path_plug_after_localize_in_content(c, web_mod, plug_line)
        Rewrite.Source.update(source, :content, c2)
      end
    end)
  end

  defp insert_path_plug_after_localize_in_content(content, web_mod, plug_line) do
    if String.contains?(content, "Localize.Plug.PutSession, as: :string") and
         not String.contains?(content, "#{inspect(web_mod)}.Plugs.Path") do
      String.replace(
        content,
        "    plug Localize.Plug.PutSession, as: :string",
        "    plug Localize.Plug.PutSession, as: :string\n" <> plug_line,
        global: false
      )
    else
      content
    end
  end

  def web_ex_dir(igniter, web_mod) do
    loc = Igniter.Project.Module.proper_location(igniter, web_mod)
    Path.join(Path.dirname(loc), Path.basename(loc, ".ex"))
  end
end
