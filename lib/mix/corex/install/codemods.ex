defmodule Mix.Corex.Install.Codemods do
  @moduledoc false

  alias Igniter.Code.Common
  alias Igniter.Code.Function
  alias Sourceror.Zipper

  def patch_web_module(igniter, web_mod, _multi_locale?) do
    path = Igniter.Project.Module.proper_location(igniter, web_mod)

    igniter
    |> Igniter.update_elixir_file(path, &inject_use_corex/1)
  end

  defp inject_use_corex(zipper) do
    with {:ok, z} <- Function.move_to_defp(zipper, :html_helpers, 0),
         {:ok, z} <- Common.move_to_do_block(z) do
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
    else
      _ ->
        {:warning,
         "Could not find `defp html_helpers`; add `use Corex` inside its `quote` block manually."}
    end
  end

  defp html_helpers_has_use_corex?(zipper) do
    case Function.move_to_function_call_in_current_scope(zipper, :use, [1, 2], fn z ->
           Function.argument_equals?(z, 0, Corex)
         end) do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp move_to_import_for_corex(zipper) do
    cond do
      match?(
        {:ok, _},
        Function.move_to_function_call_in_current_scope(zipper, :import, 2, fn z ->
          Function.argument_equals?(z, 0, Phoenix.HTML)
        end)
      ) ->
        Function.move_to_function_call_in_current_scope(zipper, :import, 2, fn z ->
          Function.argument_equals?(z, 0, Phoenix.HTML)
        end)

      match?(
        {:ok, _},
        Function.move_to_function_call_in_current_scope(zipper, :import, 2, fn z ->
          Function.argument_equals?(z, 0, Phoenix.Component)
        end)
      ) ->
        Function.move_to_function_call_in_current_scope(zipper, :import, 2, fn z ->
          Function.argument_equals?(z, 0, Phoenix.Component)
        end)

      match?(
        {:ok, _},
        Function.move_to_function_call_in_current_scope(zipper, :import, 1, fn z ->
          Function.argument_equals?(z, 0, Phoenix.HTML)
        end)
      ) ->
        Function.move_to_function_call_in_current_scope(zipper, :import, 1, fn z ->
          Function.argument_equals?(z, 0, Phoenix.HTML)
        end)

      match?(
        {:ok, _},
        Function.move_to_function_call_in_current_scope(zipper, :import, 1, fn z ->
          Function.argument_equals?(z, 0, Phoenix.Component)
        end)
      ) ->
        Function.move_to_function_call_in_current_scope(zipper, :import, 1, fn z ->
          Function.argument_equals?(z, 0, Phoenix.Component)
        end)

      true ->
        :error
    end
  end

  def patch_router_plugs(igniter, web_mod, opts, themes, multi_locale?, locales) do
    need? = opts[:mode] || themes != [] || (multi_locale? && locales != [])

    if !need? do
      igniter
    else
      lines =
        []
        |> then(fn acc ->
          if opts[:mode], do: ["    plug #{inspect(web_mod)}.Plugs.Mode" | acc], else: acc
        end)
        |> then(fn acc ->
          if themes != [], do: ["    plug #{inspect(web_mod)}.Plugs.Theme" | acc], else: acc
        end)
        |> Enum.reverse()

      inject = if lines != [], do: "\n" <> Enum.join(lines, "\n"), else: ""

      if inject == "" do
        igniter
      else
        marker_mode = "#{inspect(web_mod)}.Plugs.Mode"
        marker_theme = "#{inspect(web_mod)}.Plugs.Theme"
        marker_locale = "#{inspect(web_mod)}.Plugs.Locale"

        {igniter, router} =
          Igniter.Libs.Phoenix.select_router(
            igniter,
            "Corex install: which router should receive plugs?"
          )

        if router == nil do
          Igniter.add_warning(
            igniter,
            "No router found to insert Corex plugs; add them after `plug :fetch_live_flash` in your browser pipeline."
          )
        else
          path = Igniter.Project.Module.proper_location(igniter, router)

          Igniter.update_elixir_file(igniter, path, fn zipper ->
            root = Zipper.topmost(zipper)
            root_str = root.node |> Sourceror.to_string()

            if String.contains?(root_str, marker_mode) or String.contains?(root_str, marker_theme) or
                 String.contains?(root_str, marker_locale) do
              {:ok, zipper}
            else
              case Function.move_to_function_call(zipper, :plug, [1, 2], fn z ->
                     Function.argument_equals?(z, 0, :fetch_live_flash)
                   end) do
                {:ok, z} ->
                  {:ok, Common.add_code(z, String.trim_leading(inject), placement: :after)}

                :error ->
                  {:warning,
                   "Could not find `plug :fetch_live_flash` in #{inspect(router)}; add Corex plugs after it in the `:browser` pipeline."}
              end
            end
          end)
        end
      end
    end
  end
end
