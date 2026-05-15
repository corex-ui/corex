defmodule Corex.Integration.RouterPatch do
  @moduledoc false

  @home_route_anchor "get \"/\", PageController, :home\n"
  @example_live_line "live \"/live\", ExampleLive\n"

  def inject_before_final_end(code, code_to_inject)
      when is_binary(code) and is_binary(code_to_inject) do
    code
    |> String.trim_trailing()
    |> String.trim_trailing("end")
    |> Kernel.<>(code_to_inject)
    |> Kernel.<>("end\n")
  end

  def inject_live_routes(router_path, live_routes, opts \\ []) do
    content = File.read!(router_path)

    new_content =
      if Keyword.get(opts, :locale_scope) do
        cond do
          String.contains?(content, @home_route_anchor) ->
            String.replace(content, @home_route_anchor, @home_route_anchor <> live_routes,
              global: true
            )

          String.contains?(content, @example_live_line) ->
            String.replace(content, @example_live_line, @example_live_line <> live_routes,
              global: false
            )

          true ->
            inject_before_final_end(content, live_routes)
        end
      else
        inject_before_final_end(content, live_routes)
      end

    File.write!(router_path, new_content)
  end

  def inject_resources(router_path, resources_routes, opts \\ []) do
    content = File.read!(router_path)

    new_content =
      if Keyword.get(opts, :locale_scope) do
        if String.contains?(content, @home_route_anchor) do
          String.replace(content, @home_route_anchor, @home_route_anchor <> resources_routes,
            global: true
          )
        else
          parts = String.split(content, ~r/scope "\/:locale"/, parts: 2)

          if length(parts) == 2 do
            [head, locale_block] = parts
            get_pattern = @home_route_anchor
            locale_parts = String.split(locale_block, get_pattern, parts: 2)

            if length(locale_parts) == 2 do
              [before_get, after_get] = locale_parts
              new_locale_block = before_get <> get_pattern <> resources_routes <> after_get
              head <> "scope \"/:locale\"" <> new_locale_block
            else
              inject_before_final_end(content, resources_routes)
            end
          else
            inject_before_final_end(content, resources_routes)
          end
        end
      else
        inject_before_final_end(content, resources_routes)
      end

    File.write!(router_path, new_content)
  end
end
