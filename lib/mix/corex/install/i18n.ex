defmodule Mix.Corex.Install.I18n do
  @moduledoc false

  alias Igniter.Code.{Common, Function}
  alias Igniter.Project.Module, as: ProjectModule
  alias Mix.Corex.Install.Web

  def maybe_create_localize_helpers(igniter, _web_mod, false), do: igniter

  def maybe_create_localize_helpers(igniter, web_mod, true) do
    gettext_backend = Module.concat(web_mod, Gettext)
    web_base = Web.web_ex_dir(igniter, web_mod)

    layout_path = Path.join([web_base, "localize_layout.ex"])
    path_ex_path = Path.join([web_base, "path.ex"])

    layouts_mod = Module.concat(web_mod, Layouts)
    layouts_ex_path = ProjectModule.proper_location(igniter, layouts_mod)

    igniter
    |> create_or_refresh_file(layout_path, localize_layout_module(web_mod, gettext_backend))
    |> create_or_refresh_file(path_ex_path, path_module(web_mod, gettext_backend))
    |> patch_layouts_embed_language_switch(layouts_ex_path, web_mod, gettext_backend)
  end

  defp create_or_refresh_file(igniter, path, contents) do
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

  def maybe_patch_layouts_for_language_switch(igniter, _web_mod, false), do: igniter

  def maybe_patch_layouts_for_language_switch(igniter, web_mod, true) do
    layouts_mod = Module.concat(web_mod, Layouts)

    igniter
    |> insert_path_attr_into_layouts_app(layouts_mod)
    |> ensure_path_in_page_templates(web_mod)
  end

  @path_attr_line ~S|attr :path, :string, default: nil, doc: "locale-stripped path (from Plugs.Path)"|

  defp insert_path_attr_into_layouts_app(igniter, layouts_mod) do
    ProjectModule.find_and_update_module!(igniter, layouts_mod, fn zipper ->
      apply_path_attr_to_app(zipper)
    end)
  end

  defp apply_path_attr_to_app(zipper) do
    case Function.move_to_def(zipper, :app, 1, target: :before) do
      {:ok, app_z} ->
        maybe_add_path_attr_line(app_z, zipper)

      :error ->
        {:ok, zipper}
    end
  end

  defp maybe_add_path_attr_line(app_z, zipper) do
    if path_attr_already_attached?(app_z) do
      {:ok, zipper}
    else
      {:ok, Common.add_code(app_z, @path_attr_line, placement: :before)}
    end
  end

  defp path_attr_already_attached?(app_z) do
    walk_attrs_above(app_z, &attr_is_path?/1)
  end

  defp attr_is_path?(node) do
    case node do
      {:attr, _, [{:__block__, _, [:path]} | _]} -> true
      {:attr, _, [:path | _]} -> true
      _ -> false
    end
  end

  defp walk_attrs_above(zipper, predicate) do
    case Sourceror.Zipper.left(zipper) do
      nil ->
        false

      left ->
        node = Sourceror.Zipper.node(left)

        cond do
          predicate.(node) -> true
          attr_or_doc_like?(node) -> walk_attrs_above(left, predicate)
          true -> false
        end
    end
  end

  defp attr_or_doc_like?({:attr, _, _}), do: true
  defp attr_or_doc_like?({:slot, _, _}), do: true
  defp attr_or_doc_like?({:@, _, [{name, _, _}]}) when name in [:doc, :spec, :impl], do: true
  defp attr_or_doc_like?(_), do: false

  def maybe_patch_web_verified_routes(igniter, _web_mod, false), do: igniter

  def maybe_patch_web_verified_routes(igniter, web_mod, true) do
    path = Igniter.Project.Module.proper_location(igniter, web_mod)
    gettext_backend = Module.concat(web_mod, Gettext)

    Igniter.update_file(igniter, path, fn source ->
      content = source.content

      content =
        String.replace(
          content,
          "use Phoenix.Router, helpers: false",
          "use Phoenix.Router, helpers: true",
          global: true
        )

      content =
        if String.contains?(content, "Localize.VerifiedRoutes") do
          content
        else
          new =
            "use Localize.VerifiedRoutes,\n        endpoint: #{inspect(web_mod)}.Endpoint,\n        router: #{inspect(web_mod)}.Router,\n        gettext: #{inspect(gettext_backend)},\n        statics: #{inspect(web_mod)}.static_paths()"

          Regex.replace(
            ~r/use Phoenix\.VerifiedRoutes,\s*\n\s*endpoint:[\s\S]*?statics:\s*#{Regex.escape(inspect(web_mod))}\.static_paths\(\)/,
            content,
            new,
            global: false
          )
        end

      %{source | content: content}
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
    |> Igniter.add_notice(
      "A `Plugs.Path` is added in the browser pipeline (after Localize) so `assigns[:path]` is " <>
        "the request path with an optional `/:locale` prefix stripped, matching the Corex e2e setup."
    )
  end

  defp patch_layouts_embed_language_switch(igniter, _layouts_ex_path, web_mod, gettext_backend) do
    layouts_mod = Module.concat(web_mod, Layouts)

    ProjectModule.find_and_update_module!(igniter, layouts_mod, fn zipper ->
      case Function.move_to_def(zipper, :language_switch, 1) do
        {:ok, _} ->
          {:ok, zipper}

        :error ->
          block = language_switch_def_in_layouts(web_mod, gettext_backend)
          {:ok, Common.add_code(zipper, block, placement: :after)}
      end
    end)
  end

  defp language_switch_def_in_layouts(web_mod, gettext_backend) do
    b = inspect(gettext_backend)
    path_mod = inspect(Module.concat(web_mod, Path))

    ~s'''
    attr :path, :string, default: nil, doc: "locale-stripped path (from Plugs.Path)"

    def language_switch(assigns) do
      backend = #{b}
      p = assigns.path || ""

      items =
        for loc <- Gettext.known_locales(backend), into: [] do
          %{
            id: #{path_mod}.join_locale_path(loc, p),
            label: Localize.Locale.display_name!(loc, locale: loc)
          }
        end

      value = [#{path_mod}.with_current_locale(p)]

      assigns =
        assigns
        |> assign(:items, items)
        |> assign(:value, value)

      ~H"""
      <.select
        id="corex-language-switch"
        class="select select--sm w-4xs"
        items={@items}
        value={@value}
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
    '''
  end

  defp ensure_path_in_page_templates(igniter, web_mod) do
    w = Web.web_ex_dir(igniter, web_mod)
    home = Path.join([w, "controllers", "page_html", "home.html.heex"])

    if Igniter.exists?(igniter, home) do
      Igniter.update_file(igniter, home, &append_path_to_layouts_app/1)
    else
      igniter
    end
  end

  defp append_path_to_layouts_app(source) do
    c = source.content

    if c =~ ~r/<Layouts\.app[^>]*\bpath=[^>]+>/m do
      source
    else
      c =
        String.replace(
          c,
          ~r/<Layouts\.app(\s)/m,
          "<Layouts.app\\1path={@path} ",
          global: false
        )

      %{source | content: c}
    end
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

  defp path_module(web_mod, gettext_backend) do
    m = Module.concat(web_mod, :Path)

    """
    defmodule #{inspect(m)} do
      @moduledoc false

      def strip_after_locale(request_path) when is_binary(request_path) do
        loc = locale_leading_from_path(request_path) || Gettext.get_locale(#{inspect(gettext_backend)})
        after_locale(request_path, loc)
      end

      defp locale_leading_from_path(path) do
        first =
          path
          |> String.trim_leading("/")
          |> String.split("/")
          |> List.first()
          |> case do
            s when s in ["", nil] -> nil
            s -> s
          end

        if is_binary(first) and first in Gettext.known_locales(#{inspect(gettext_backend)}),
          do: first,
          else: nil
      end

      defp after_locale(path, loc) when is_binary(path) and is_binary(loc) do
        base = "/" <> loc

        cond do
          path in ["/", base] -> ""
          String.starts_with?(path, base <> "/") -> String.replace_prefix(path, base, "")
          true -> path
        end
      end

      def join_locale_path(locale, after_path)
          when is_binary(locale) and (is_binary(after_path) or after_path == "") do
        base = "/" <> locale

        cond do
          after_path == "" or after_path == nil -> base
          String.starts_with?(after_path, "/") -> base <> after_path
          true -> base <> "/" <> after_path
        end
      end

      def with_current_locale(after_path) when is_binary(after_path) or after_path == "" do
        join_locale_path(Gettext.get_locale(#{inspect(gettext_backend)}), after_path)
      end
    end
    """
  end
end
