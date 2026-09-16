defmodule Mix.Corex.Gen.Auth do
  @moduledoc false

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
        Mix.Tasks.Phx.Gen.Auth.Injector.app_layout_menu_inject(binding, template_str)

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

  defp header_child_padding(template_str) do
    case Regex.run(~r/^([ \t]*)<\/header>/m, template_str) do
      [_, indent] -> String.length(indent) + 2
      _ -> 6
    end
  end
end
