defmodule E2eWeb.Plugs.Locale do
  @moduledoc """
  A plug that sets the locale for the current request.
  Based of [SetLocale](https://github.com/smeevil/set_locale), all credit to [smeevil](https://github.com/smeevil)
  """
  import Plug.Conn

  @backend E2eWeb.Gettext
  @locales Gettext.known_locales(@backend)
  @default_locale @backend.__gettext__(:default_locale)
  @cookie_key "preferred_locale"

  def init(opts), do: opts

  @doc """
  Returns the path without the locale prefix, for building locale-switch URLs.

  ## Examples

      path_without_locale("/en/accordion", "en")  # => "/accordion"
      path_without_locale("/ar", "ar")            # => "/"
  """
  def path_without_locale(path, locale) when is_binary(path) and is_binary(locale) do
    case String.replace_prefix(path, "/#{locale}", "") do
      "" -> "/"
      rest -> rest
    end
  end

  def call(%{params: %{"locale" => locale}} = conn, _opts) when locale in @locales do
    conn
    |> set_locale(locale)
    |> put_resp_cookie(@cookie_key, locale, max_age: 365 * 24 * 60 * 60)
  end

  def call(%{params: %{"locale" => invalid_locale}} = conn, _opts) do
    locale = determine_locale(conn)
    redirect_with_locale(conn, locale, strip_invalid_locale(conn.request_path, invalid_locale))
  end

  def call(conn, _opts) do
    locale = determine_locale(conn)
    redirect_with_locale(conn, locale, conn.request_path)
  end

  defp determine_locale(conn) do
    conn.cookies[@cookie_key] ||
      get_locale_from_referer(conn) ||
      get_locale_from_accept_language(conn) ||
      @default_locale
  end

  defp get_locale_from_referer(conn) do
    case get_req_header(conn, "referer") do
      [referer] when is_binary(referer) ->
        referer
        |> URI.parse()
        |> Map.get(:path)
        |> extract_locale_from_path()
        |> validate_locale()

      _ ->
        nil
    end
  end

  defp get_locale_from_accept_language(conn) do
    conn
    |> E2eWeb.Plugs.Locale.Headers.extract_accept_language()
    |> Enum.find(&(&1 in @locales))
  end

  defp extract_locale_from_path(path) when is_binary(path) do
    case String.split(path, "/", parts: 3) do
      ["", maybe_locale | _] -> maybe_locale
      _ -> nil
    end
  end

  defp extract_locale_from_path(_), do: nil

  defp validate_locale(locale) when locale in @locales, do: locale
  defp validate_locale(_), do: nil

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

  defp set_locale(conn, locale) do
    Gettext.put_locale(@backend, locale)
    current_path = path_without_locale(conn.request_path, locale)
    dir = if locale in Application.get_env(:corex, :rtl_locales, []), do: "rtl", else: "ltr"

    conn
    # |> put_session(:locale, locale)
    |> assign(:locale, locale)
    |> assign(:dir, dir)
    |> assign(:current_path, current_path)
  end

  defmodule Headers do
    def extract_accept_language(conn) do
      case Plug.Conn.get_req_header(conn, "accept-language") do
        [value | _] ->
          value
          |> String.split(",")
          |> Enum.map(&parse_language_option/1)
          |> Enum.sort(&(&1.quality > &2.quality))
          |> Enum.map(& &1.tag)
          |> Enum.reject(&is_nil/1)
          |> ensure_language_fallbacks()

        _ ->
          []
      end
    end

    defp parse_language_option(string) do
      captures =
        Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

      quality =
        case Float.parse(captures["quality"] || "1.0") do
          {val, _} -> val
          _ -> 1.0
        end

      %{tag: captures["tag"], quality: quality}
    end

    defp ensure_language_fallbacks(tags) do
      Enum.flat_map(tags, fn tag ->
        [language | _] = String.split(tag, "-")
        if Enum.member?(tags, language), do: [tag], else: [tag, language]
      end)
    end
  end
end
