defmodule Mix.Corex.Install.Router do
  @moduledoc false

  def patch_router_for_plugs(igniter, web_mod, opts, themes, i18n?) do
    {igniter, router} =
      Igniter.Libs.Phoenix.select_router(
        igniter,
        "Corex: which router should receive localize plugs?"
      )

    router_mod = router || Module.concat(web_mod, :Router)
    path = Igniter.Project.Module.proper_location(igniter, router_mod)
    gettext_backend = Module.concat(web_mod, Gettext)

    need_plugs? =
      opts[:mode] || themes != [] || i18n?

    if !need_plugs? do
      igniter
    else
      igniter
      |> Igniter.update_file(path, fn source ->
        content = source.content

        patched =
          if i18n? && !String.contains?(content, "Localize.Plug.PutLocale") do
            content
            |> maybe_insert_use_localize_routes(web_mod, gettext_backend)
            |> maybe_insert_localize_plugs_into_browser_pipeline(gettext_backend)
            |> maybe_wrap_home_route_in_localize()
          else
            content
          end

        %{source | content: patched}
      end)
      |> insert_router_mode_theme_plugs(path, web_mod, opts, themes)
    end
  end

  def insert_router_mode_theme_plugs(igniter, router_path, web_mod, opts, themes) do
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
        root = Sourceror.Zipper.topmost(zipper)
        root_str = root.node |> Sourceror.to_string()

        if String.contains?(root_str, "#{inspect(web_mod)}.Plugs.Mode") or
             String.contains?(root_str, "#{inspect(web_mod)}.Plugs.Theme") do
          {:ok, zipper}
        else
          inject = Enum.map_join(lines, "\n", &("    " <> &1))

          case Igniter.Code.Function.move_to_function_call(zipper, :plug, [1, 2], fn z ->
                 Igniter.Code.Function.argument_equals?(z, 0, :fetch_live_flash)
               end) do
            {:ok, z} ->
              {:ok, Igniter.Code.Common.add_code(z, inject, placement: :after)}

            :error ->
              {:warning,
               "Could not find `plug :fetch_live_flash` in your router; add Corex plugs after it in the `:browser` pipeline:\n\n#{inject}\n"}
          end
        end
      end)
    end
  end

  defp maybe_insert_use_localize_routes(content, web_mod, gettext_backend) do
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

  defp maybe_insert_localize_plugs_into_browser_pipeline(content, gettext_backend) do
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

  defp maybe_wrap_home_route_in_localize(content) do
    cond do
      String.contains?(content, "localize do") ->
        content

      String.contains?(content, "pipe_through :browser\n\n    get \"/\", PageController, :home") ->
        content
        |> String.replace(
          "pipe_through :browser\n\n    get \"/\", PageController, :home",
          "pipe_through :browser\n\n    localize do\n    get \"/\", PageController, :home\n    end",
          global: false
        )

      true ->
        content
    end
  end
end
