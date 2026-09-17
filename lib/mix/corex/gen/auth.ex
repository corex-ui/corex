defmodule Mix.Corex.Gen.Auth do
  @moduledoc false

  alias Mix.Tasks.Phx.Gen.Auth.Injector

  @home_route_anchor "get \"/\", PageController, :home\n"
  @locale_scope_split ~r/scope\s+"\/:locale"/

  @doc """
  Injects Corex account navigation into a layout template or `Layouts` module.
  """
  def inject_layout_menu(binding, template_str) when is_binary(template_str) do
    padding = header_child_padding(template_str)
    {_dup, code} = layout_menu_code(binding, padding)

    cond do
      String.contains?(template_str, "#{binding[:schema].route_prefix}/log-in") ->
        :already_injected

      String.contains?(template_str, "</header>") ->
        {:ok,
         Regex.replace(
           ~r/^([ \t]*)<\/header>/m,
           template_str,
           "#{code}\n\\1</header>",
           global: false
         )}

      String.contains?(template_str, "<body") ->
        Injector.app_layout_menu_inject(binding, template_str)

      true ->
        {:error, :unable_to_inject}
    end
  end

  def layout_menu_help_text(file_path, binding) do
    {_dup, code} = layout_menu_code(binding)

    """
    Add the following #{binding[:schema].singular} menu items to #{Path.relative_to_cwd(file_path)}:

    #{code}
    """
  end

  def layout_menu_code(binding, padding \\ 4) do
    schema = binding[:schema]
    assign_key = binding[:scope_config].scope.assign_key
    prefix = schema.route_prefix
    already = "#{prefix}/log-in"
    indent = String.duplicate(" ", padding)

    template = """
    <nav class="flex shrink-0 items-center gap-space" aria-label="Account">
      <%= if @#{assign_key} do %>
        <span class="truncate text-sm text-ink-muted">{@#{assign_key}.#{schema.singular}.email}</span>
        <.navigate to={~p"#{prefix}/settings"} type="navigate" class="link ui-nav ui-size-sm">
          Settings
        </.navigate>
        <.navigate to={~p"#{prefix}/log-out"} method="delete" class="link ui-nav ui-size-sm">
          Log out
        </.navigate>
      <% else %>
        <.navigate to={~p"#{prefix}/register"} type="navigate" class="link ui-nav ui-size-sm">
          Register
        </.navigate>
        <.navigate to={~p"#{prefix}/log-in"} type="navigate" class="link ui-nav ui-size-sm">
          Log in
        </.navigate>
      <% end %>
    </nav>\
    """

    indented =
      template
      |> String.split("\n")
      |> Enum.map_join("\n", &(indent <> &1))

    {already, indented}
  end

  @doc """
  Adds `assign_key={@assign_key}` to `<Layouts.app` call sites so the account
  menu in `Layouts.app/1` receives the plug-assigned scope.
  """
  def inject_layout_scope_assign(content, assign_key) when is_binary(content) do
    attr = "#{assign_key}={@#{assign_key}}"

    cond do
      not String.contains?(content, "<Layouts.app") ->
        :not_found

      String.contains?(content, attr) ->
        :already_injected

      String.contains?(content, "flash={@flash}\n") ->
        {:ok, String.replace(content, "flash={@flash}\n", "flash={@flash}\n  #{attr}\n")}

      String.contains?(content, "flash={@flash}") ->
        {:ok, String.replace(content, "flash={@flash}", "flash={@flash} #{attr}")}

      true ->
        {:ok, String.replace(content, "<Layouts.app", "<Layouts.app #{attr}", global: false)}
    end
  end

  @doc """
  Injects generated auth routes into a router source string.

  When the router already has `scope "/:locale"`, `inner` is spliced into that
  block (after the locale home route). Otherwise `wrapped` is appended before
  the module's final `end`. If the locale scope exists but the home-route
  anchor is missing, sibling `scope "/:locale"` blocks are appended instead.
  """
  def inject_auth_routes(router, wrapped, inner)
      when is_binary(router) and is_binary(wrapped) and is_binary(inner) do
    cond do
      already_injected?(router, wrapped, inner) ->
        :already_injected

      locale_scoped?(router) ->
        case inject_after_home_in_locale_scope(router, pad_inject(inner)) do
          {:ok, content} -> {:ok, content}
          :error -> Injector.inject_before_final_end(router, locale_wrapped_scopes(wrapped))
        end

      true ->
        Injector.inject_before_final_end(router, wrapped)
    end
  end

  defp already_injected?(router, wrapped, inner) do
    String.contains?(router, String.trim(inner)) or
      String.contains?(router, String.trim(wrapped)) or
      log_in_injected?(router, inner)
  end

  defp log_in_injected?(router, inner) do
    case Regex.run(~r{live\s+"(/[^"]+/log-in)"}, inner) do
      [_, path] -> String.contains?(router, path)
      nil -> false
    end
  end

  defp locale_scoped?(router), do: Regex.match?(@locale_scope_split, router)

  defp pad_inject(inner) do
    inner = String.trim_trailing(inner)
    inner = if String.starts_with?(inner, "\n"), do: inner, else: "\n" <> inner
    inner <> "\n"
  end

  defp inject_after_home_in_locale_scope(content, routes_to_inject) do
    parts = String.split(content, @locale_scope_split, parts: 2)

    if length(parts) == 2 do
      [head, locale_block] = parts
      locale_parts = String.split(locale_block, @home_route_anchor, parts: 2)

      if length(locale_parts) == 2 do
        [before_get, after_get] = locale_parts
        new_locale_block = before_get <> @home_route_anchor <> routes_to_inject <> after_get
        {:ok, head <> ~S(scope "/:locale") <> new_locale_block}
      else
        :error
      end
    else
      :error
    end
  end

  defp locale_wrapped_scopes(wrapped) do
    Regex.replace(~r/(scope\s+")\/(")/, wrapped, "\\1/:locale\\2")
  end

  defp header_child_padding(template_str) do
    case Regex.run(~r/^([ \t]*)<\/header>/m, template_str) do
      [_, indent] -> String.length(indent) + 2
      _ -> 6
    end
  end
end
