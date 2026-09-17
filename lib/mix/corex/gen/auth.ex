defmodule Mix.Corex.Gen.Auth do
  @moduledoc false

  alias Mix.Tasks.Phx.Gen.Auth.Injector

  @home_route_anchor "get \"/\", PageController, :home\n"
  @locale_scope_split ~r/scope\s+"\/:locale"/
  @right_cluster_open ~r/^([ \t]*)<div class="flex shrink-0 items-center gap-space-sm">\n/m
  @header_inner_close ~r/^([ \t]*)<\/div>\n([ \t]*)<\/header>/m

  @doc """
  Injects Corex account navigation into a layout template or `Layouts` module.

  Desktop controls go in the header's right cluster (created when missing).
  Mobile controls go in the existing `site-nav-dialog` site nav.
  """
  def inject_layout_menu(binding, template_str) when is_binary(template_str) do
    if String.contains?(template_str, "#{binding[:schema].route_prefix}/log-in") do
      :already_injected
    else
      {content, desktop?} = inject_desktop_account(binding, template_str)
      {content, mobile?} = inject_mobile_account(binding, content)

      if desktop? or mobile? do
        {:ok, content}
      else
        {:error, :unable_to_inject}
      end
    end
  end

  def layout_menu_help_text(file_path, binding) do
    {_dup, desktop} = desktop_account_code(binding)
    {_dup, mobile} = mobile_account_code(binding)

    """
    Add the following #{binding[:schema].singular} menu items to #{Path.relative_to_cwd(file_path)}:

    Desktop (header right cluster):

    #{desktop}

    Mobile (inside the site-nav-dialog site nav):

    #{mobile}
    """
  end

  def layout_menu_code(binding, padding \\ 4) do
    desktop_account_code(binding, padding)
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

  defp inject_desktop_account(binding, content) do
    if Regex.match?(@right_cluster_open, content) do
      [full, indent] = Regex.run(@right_cluster_open, content)
      padding = String.length(indent) + 2
      {_already, code} = desktop_account_code(binding, padding)
      {String.replace(content, full, full <> code <> "\n", global: false), true}
    else
      inject_desktop_before_header_close(binding, content)
    end
  end

  defp inject_desktop_before_header_close(binding, content) do
    case Regex.run(@header_inner_close, content) do
      [full, div_indent, _header_indent] ->
        padding = String.length(div_indent) + 2
        {_already, code} = desktop_account_code(binding, padding)
        {String.replace(content, full, "#{code}\n#{full}", global: false), true}

      nil ->
        {content, false}
    end
  end

  defp inject_mobile_account(binding, content) do
    case String.split(content, ~S(id="site-nav-dialog"), parts: 2) do
      [head, rest] ->
        case Regex.run(~r/\n([ \t]*)<\/nav>/, rest) do
          [match, indent] ->
            padding = String.length(indent) + 2
            {_already, code} = mobile_account_code(binding, padding)
            updated = String.replace(rest, match, "\n#{code}" <> match, global: false)
            {head <> ~S(id="site-nav-dialog") <> updated, true}

          nil ->
            {content, false}
        end

      _ ->
        {content, false}
    end
  end

  defp desktop_account_code(binding, padding \\ 4) do
    {already, items} = account_item_template(binding, :desktop)

    template = """
    <nav class="hidden md:flex min-w-0 shrink-0 items-center gap-space" aria-label="Account">
    #{indent_lines(items, 2)}
    </nav>\
    """

    {already, indent_lines(template, padding)}
  end

  defp mobile_account_code(binding, padding \\ 4) do
    {already, items} = account_item_template(binding, :mobile)
    {already, indent_lines(items, padding)}
  end

  defp account_item_template(binding, variant) do
    schema = binding[:schema]
    assign_key = binding[:scope_config].scope.assign_key
    prefix = schema.route_prefix

    {login_class, nav_class} = account_classes(variant)

    template = """
    <%= if @#{assign_key} do %>
      <.navigate
        to={~p"#{prefix}/settings"}
        type="navigate"
        class="#{nav_class}"
      >
        Settings
      </.navigate>
      <.navigate
        to={~p"#{prefix}/log-out"}
        method="delete"
        class="#{nav_class}"
      >
        Log out
      </.navigate>
    <% else %>
      <.navigate
        to={~p"#{prefix}/log-in"}
        type="navigate"
        class="#{login_class}"
      >
        Log in
      </.navigate>
    <% end %>\
    """

    {"#{prefix}/log-in", template}
  end

  defp account_classes(:desktop) do
    {"button ui-accent ui-size-sm", "link ui-nav ui-size-sm"}
  end

  defp account_classes(:mobile) do
    {"button ui-accent ui-size-sm ui-width-full", "link ui-nav ui-size-md"}
  end

  defp indent_lines(template, padding) do
    indent = String.duplicate(" ", padding)

    template
    |> String.split("\n")
    |> Enum.map_join("\n", &(indent <> &1))
  end

  @oauth_catalog [
    google: %{
      id: :google,
      strategy: "Assent.Strategy.Google",
      label: "Google",
      env_keys: [client_id: "GOOGLE_CLIENT_ID", client_secret: "GOOGLE_CLIENT_SECRET"]
    },
    facebook: %{
      id: :facebook,
      strategy: "Assent.Strategy.Facebook",
      label: "Facebook",
      env_keys: [client_id: "FACEBOOK_CLIENT_ID", client_secret: "FACEBOOK_CLIENT_SECRET"]
    },
    github: %{
      id: :github,
      strategy: "Assent.Strategy.Github",
      label: "GitHub",
      env_keys: [client_id: "GITHUB_CLIENT_ID", client_secret: "GITHUB_CLIENT_SECRET"]
    },
    apple: %{
      id: :apple,
      strategy: "Assent.Strategy.Apple",
      label: "Apple",
      env_keys: [
        client_id: "APPLE_CLIENT_ID",
        team_id: "APPLE_TEAM_ID",
        private_key_id: "APPLE_PRIVATE_KEY_ID",
        private_key: "APPLE_PRIVATE_KEY"
      ]
    }
  ]

  @doc "Returns Mix switch names for OAuth providers."
  def oauth_switch_names, do: Keyword.keys(@oauth_catalog)

  @doc "Returns catalog entries for OAuth flags that are set on `opts`."
  def enabled_oauth_providers(opts) when is_list(opts) do
    @oauth_catalog
    |> Enum.filter(fn {id, _meta} -> Keyword.get(opts, id, false) end)
    |> Enum.map(fn {_id, meta} -> meta end)
  end

  @doc "Mix dependency tuple for Assent."
  def oauth_mix_dependency, do: ~S({:assent, "~> 0.3.1"})

  @doc """
  Injects `Layouts.auth/1` before the module's final `end`.
  """
  def inject_auth_layout(content, snippet)
      when is_binary(content) and is_binary(snippet) do
    if String.contains?(content, "def auth(") do
      :already_injected
    else
      Injector.inject_before_final_end(content, snippet)
    end
  end

  def auth_layout_help_text(file_path) do
    """
    Add a `Layouts.auth/1` function to #{Path.relative_to_cwd(file_path)}
    for sign-in and registration pages (full-height canvas, no site chrome).
    """
  end

  @doc """
  Appends unprefixed `/auth/:provider` routes (no CSRF) for Assent callbacks.
  """
  def inject_oauth_routes(router, snippet)
      when is_binary(router) and is_binary(snippet) do
    if String.contains?(router, ~S("/auth/:provider")) do
      :already_injected
    else
      Injector.inject_before_final_end(router, snippet)
    end
  end

  @doc "Runtime config snippet that reads OAuth client secrets from the environment."
  def oauth_runtime_config(binding) when is_list(binding) do
    context = Keyword.fetch!(binding, :context)
    providers = Keyword.fetch!(binding, :oauth_providers)
    app = context.context_app
    module = "#{inspect(context.module)}.OAuthProviders"

    entries =
      Enum.map_join(providers, ",\n", fn provider ->
        keys =
          Enum.map_join(provider.env_keys, ",\n    ", fn {key, env} ->
            "#{key}: System.get_env(#{inspect(env)})"
          end)

        "  #{provider.id}: [\n    #{keys}\n  ]"
      end)

    """
    config :#{app}, #{module},
    #{entries}
    """
  end

  @doc "Post-run help listing enabled providers and required env vars."
  def oauth_shell_help(binding) when is_list(binding) do
    providers = Keyword.get(binding, :oauth_providers, [])

    env_lines =
      providers
      |> Enum.flat_map(& &1.env_keys)
      |> Enum.map_join("\n", fn {_key, env} -> "        #{env}" end)

    """
    Social sign-in is enabled for #{Enum.map_join(providers, ", ", & &1.label)}.

    Set these environment variables (dev flashes the names if they are missing):

    #{env_lines}

    Redirect URIs (register each in the provider console):

        /auth/:provider/callback

    To add another Assent provider later (Discord, GitLab, Slack, ...), copy an
    entry in `oauth_providers.ex` and add matching env vars. No extra Hex package.
    """
  end
end
