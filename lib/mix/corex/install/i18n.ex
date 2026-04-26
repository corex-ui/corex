defmodule Mix.Corex.Install.I18n do
  @moduledoc false

  alias Mix.Corex.Install.Paths

  def maybe_create_localize_helpers(igniter, _web_mod, false), do: igniter

  def maybe_create_localize_helpers(igniter, web_mod, true) do
    app = Igniter.Project.Application.app_name(igniter)
    gettext_backend = Module.concat(web_mod, Gettext)
    web_base = Paths.web_ex_dir(igniter, web_mod)

    layout_path = Path.join([web_base, "localize_layout.ex"])
    switch_path = Path.join([web_base, "language_switch.ex"])

    layout_contents = localize_layout_module(web_mod, gettext_backend)
    switch_contents = language_switch_module(web_mod, gettext_backend, app)

    igniter
    |> Igniter.include_or_create_file(layout_path, layout_contents)
    |> Igniter.include_or_create_file(switch_path, switch_contents)
    |> patch_layouts_import_language_switch(web_mod)
  end

  def maybe_patch_layouts_for_language_switch(igniter, _web_mod, false), do: igniter

  def maybe_patch_layouts_for_language_switch(igniter, web_mod, true) do
    layouts_path =
      web_mod
      |> Paths.web_ex_dir(igniter)
      |> Path.join("components/layouts.ex")

    igniter
    |> Igniter.update_file(layouts_path, fn source ->
      c = source.content
      c = maybe_insert_layouts_app_conn_attr(c)
      c = maybe_insert_language_switch_in_app_header(c)
      %{source | content: c}
    end)
    |> ensure_conn_in_page_templates(web_mod)
  end

  def maybe_enable_phoenix_route_helpers_for_localize(igniter, _web_mod, false), do: igniter

  def maybe_enable_phoenix_route_helpers_for_localize(igniter, web_mod, true) do
    path = Igniter.Project.Module.proper_location(igniter, web_mod)

    Igniter.update_file(igniter, path, fn source ->
      c = source.content

      c =
        cond do
          String.contains?(c, "use Phoenix.Router, helpers: false") ->
            String.replace(
              c,
              "use Phoenix.Router, helpers: false",
              "use Phoenix.Router, helpers: true",
              global: false
            )

          true ->
            c
        end

      %{source | content: c}
    end)
  end

  def maybe_patch_web_verified_routes(igniter, _web_mod, false), do: igniter

  def maybe_patch_web_verified_routes(igniter, web_mod, true) do
    path = Igniter.Project.Module.proper_location(igniter, web_mod)
    gettext_backend = Module.concat(web_mod, Gettext)

    Igniter.update_file(igniter, path, fn source ->
      content = source.content

      if String.contains?(content, "Localize.VerifiedRoutes") do
        source
      else
        new =
          "use Localize.VerifiedRoutes,\n        endpoint: #{inspect(web_mod)}.Endpoint,\n        router: #{inspect(web_mod)}.Router,\n        gettext: #{inspect(gettext_backend)},\n        statics: #{inspect(web_mod)}.static_paths()"

        content =
          Regex.replace(
            ~r/use Phoenix\.VerifiedRoutes,\s*\n\s*endpoint:[\s\S]*?statics:\s*#{Regex.escape(inspect(web_mod))}\.static_paths\(\)/,
            content,
            new,
            global: false
          )

        %{source | content: content}
      end
    end)
  end

  def maybe_locale_notices(igniter, false), do: igniter

  def maybe_locale_notices(igniter, true) do
    igniter
    |> Igniter.add_notice(
      "i18n (Localize + Gettext) was enabled. Add a `scope \"/:locale\", ...` in your router " <>
        "and move routes so URLs can include a locale prefix when you have more than one " <>
        "Gettext locale. See guides/locale.html."
    )
    |> Igniter.add_notice(
      "Add or update translation catalogs with `mix gettext.extract` and `mix gettext.merge` " <>
        "after adding new translatable strings or new Gettext locales under `priv/gettext`."
    )
  end

  defp ensure_conn_in_page_templates(igniter, web_mod) do
    w = Paths.web_ex_dir(igniter, web_mod)
    home = Path.join([w, "controllers", "page_html", "home.html.heex"])
    corex = Path.join([w, "controllers", "corex_page", "index.html.heex"])

    igniter
    |> then(fn i ->
      if Igniter.exists?(i, home),
        do: Igniter.update_file(i, home, &append_conn_to_layouts_app/1),
        else: i
    end)
    |> then(fn i ->
      if Igniter.exists?(i, corex),
        do: Igniter.update_file(i, corex, &append_conn_to_layouts_app/1),
        else: i
    end)
  end

  defp append_conn_to_layouts_app(source) do
    c = source.content

    if c =~ ~r/<Layouts\.app[^>]*\bconn=[^>]+>/m do
      source
    else
      c =
        String.replace(
          c,
          ~r/<Layouts\.app(\s)/m,
          "<Layouts.app\\1conn={@conn} ",
          global: false
        )

      %{source | content: c}
    end
  end

  defp maybe_insert_layouts_app_conn_attr(content) do
    if String.contains?(content, "attr :conn,") or String.contains?(content, "attr(:conn,") do
      content
    else
      String.replace(
        content,
        "attr :flash, :map,",
        "attr :conn, Plug.Conn, default: nil\n  attr :flash, :map,",
        global: false
      )
    end
  end

  defp maybe_insert_language_switch_in_app_header(content) do
    if String.contains?(content, "language_switch") or
         not String.contains?(content, "theme_toggle") do
      content
    else
      String.replace(
        content,
        "            <.theme_toggle />",
        "            <.language_switch conn={@conn} />\n            <.theme_toggle />",
        global: false
      )
    end
  end

  defp patch_layouts_import_language_switch(igniter, web_mod) do
    layouts_path =
      igniter
      |> Paths.web_ex_dir(web_mod)
      |> Path.join("components/layouts.ex")

    Igniter.update_file(igniter, layouts_path, fn source ->
      content = source.content

      imp =
        "  import #{inspect(Module.concat(web_mod, LanguageSwitch))}, only: [language_switch: 1]\n"

      if String.contains?(content, "LanguageSwitch") do
        source
      else
        needle = "  use #{inspect(web_mod)}, :html\n"
        %{source | content: String.replace(content, needle, needle <> imp, global: false)}
      end
    end)
  end

  defp localize_layout_module(web_mod, gettext_backend) do
    """
    defmodule #{inspect(web_mod)}.LocalizeLayout do
      @moduledoc false

      def html_lang(conn) do
        case Localize.Plug.PutLocale.get_locale(conn) do
          %Localize.LanguageTag{} = tag ->
            Localize.LanguageTag.to_string(tag)

          _ ->
            Gettext.get_locale(#{inspect(gettext_backend)})
        end
      end

      def html_dir(conn) do
        locale_id =
          case Localize.Plug.PutLocale.get_locale(conn) do
            %Localize.LanguageTag{} = tag ->
              Localize.Locale.to_locale_id(tag)

            _ ->
              Gettext.get_locale(#{inspect(gettext_backend)})
              |> Localize.Locale.locale_id_from_posix()
              |> Localize.LanguageTag.parse!()
              |> Localize.Locale.to_locale_id()
          end

        case Localize.Locale.get(locale_id, [:layout, :character_order], fallback: true) do
          {:ok, :rtl} -> "rtl"
          {:ok, :ltr} -> "ltr"
          {:ok, "right-to-left"} -> "rtl"
          _ -> "ltr"
        end
      end
    end
    """
  end

  defp language_switch_module(web_mod, gettext_backend, _app) do
    ~s'''
    defmodule #{inspect(web_mod)}.LanguageSwitch do
      @moduledoc false

      use Phoenix.Component

      use Corex

      attr(:conn, :any, default: nil)

      def language_switch(assigns) do
        base =
          case assigns.conn do
            %Plug.Conn{} = c -> Phoenix.Controller.current_path(c, %{})
            _ -> "/"
          end

        items =
          for loc <- Gettext.known_locales(#{inspect(gettext_backend)}) do
            q = URI.encode_query(%{"locale" => loc})
            sep = if base =~ "?", do: "&", else: "?"
            label = Localize.Locale.display_name!(loc, locale: loc)

            %{id: base <> sep <> q, label: label}
          end

        cur =
          case assigns.conn do
            %Plug.Conn{} = conn ->
              loc =
                case conn.query_params do
                  %{"locale" => l} when is_binary(l) -> l
                  _ -> Gettext.get_locale(#{inspect(gettext_backend)})
                end

              if is_binary(loc) do
                found = Enum.find_value(items, fn i -> String.contains?(i.id, "locale=" <> loc) && i.id end)
                [found || hd(items).id]
              else
                [hd(items).id]
              end

            _ ->
              [hd(items).id]
          end

        assigns = assign(assigns, :collection, items)
        assigns = assign(assigns, :cur, cur)

        ~H"""
        <.select
          id="corex-language-switch"
          class="select select--sm w-4xs"
          items={@collection}
          value={@cur}
          redirect
        >
          <:label class="sr-only">Language</:label>
          <:item :let={item}>{item.label}</:item>
          <:trigger>
            <.heroicon name="hero-language" class="icon" />
          </:trigger>
          <:item_indicator>
            <.heroicon name="hero-check" class="icon" />
          </:item_indicator>
        </.select>
        """
      end
    end
    '''
  end
end
