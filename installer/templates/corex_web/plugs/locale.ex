defmodule <%= @web_namespace %>.Plugs.Locale do
  import Plug.Conn

  @backend <%= @web_namespace %>.Gettext
  @cookie_key "preferred_locale"

  def init(opts), do: opts

  def path_without_locale(path, locale) when is_binary(path) and is_binary(locale) do
    case String.replace_prefix(path, "/#{locale}", "") do
      "" -> "/"
      rest -> rest
    end
  end

  def call(%{params: %{"locale" => locale}} = conn, _opts) do
    locales = Application.get_env(:<%= @app_name %>, :locales, ["en"])
    default_locale = List.first(locales) || "en"

    if locale in locales do
      conn
      |> set_locale(locale, locales)
      |> put_resp_cookie(@cookie_key, locale, max_age: 365 * 24 * 60 * 60)
    else
      redirect_with_locale(conn, default_locale, strip_invalid_locale(conn.request_path, locale))
    end
  end

  def call(conn, _opts) do
    locales = Application.get_env(:<%= @app_name %>, :locales, ["en"])
    default_locale = List.first(locales) || "en"

    locale =
      conn.cookies[@cookie_key] || get_locale_from_path(conn.request_path, locales) ||
        default_locale

    locale = if locale in locales, do: locale, else: default_locale

    if skip_locale_redirect?(conn.request_path) do
      set_locale(conn, locale, locales)
    else
      redirect_with_locale(conn, locale, conn.request_path)
    end
  end

  defp skip_locale_redirect?("/dev" <> _), do: true
  defp skip_locale_redirect?(_), do: false

  defp get_locale_from_path(path, locales) when is_binary(path) do
    case String.split(path, "/", parts: 3) do
      ["", maybe_locale | _] -> if maybe_locale in locales, do: maybe_locale, else: nil
      _ -> nil
    end
  end

  defp strip_invalid_locale(path, invalid_locale) do
    String.replace_prefix(path, "/#{invalid_locale}", "")
  end

  defp redirect_with_locale(conn, locale, path) do
    path = localize_path(path, locale)
    path = preserve_query_string(conn, path)

    conn
    |> put_resp_cookie(@cookie_key, locale, max_age: 365 * 24 * 60 * 60)
    |> Phoenix.Controller.redirect(to: path)
    |> halt()
  end

  defp localize_path("/", locale), do: "/#{locale}"
  defp localize_path(path, locale), do: "/#{locale}#{path}"

  defp preserve_query_string(%{query_string: ""}, path), do: path
  defp preserve_query_string(%{query_string: qs}, path), do: "#{path}?#{qs}"

  defp set_locale(conn, locale, locales) do
    Gettext.put_locale(@backend, locale)
    current_path = path_without_locale(conn.request_path, locale)
    rtl = Application.get_env(:<%= @app_name %>, :rtl_locales, [])
    dir = if locale in rtl, do: "rtl", else: "ltr"

    conn
    |> assign(:locale, locale)
    |> assign(:dir, dir)
    |> assign(:current_path, current_path)
    |> assign(:locales, locales)
  end
end
