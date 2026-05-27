defmodule E2eWeb.Locale do
  @moduledoc false

  @backend E2eWeb.Gettext
  @locales Gettext.known_locales(@backend)

  def locales do
    case Application.get_env(:localize, :supported_locales) do
      list when is_list(list) and list != [] -> Enum.map(list, &to_string/1)
      _ -> @locales
    end
  end

  def current do
    id = Localize.get_locale().cldr_locale_id

    cond do
      is_atom(id) -> Atom.to_string(id)
      is_binary(id) -> id
      true -> to_string(id)
    end
  end

  def label(locale) do
    case Localize.Locale.display_name(locale, locale: locale) do
      {:ok, name} -> name
      _ -> String.upcase(to_string(locale))
    end
  end

  def dir(locale) when is_binary(locale) and locale != "" do
    posix = Localize.Locale.locale_id_from_posix(locale)

    with {:ok, id} <- Localize.Locale.cldr_locale_id_from(posix) do
      case Localize.Locale.get(id, [:layout, :character_order], fallback: true) do
        {:ok, :rtl} -> "rtl"
        {:ok, :ltr} -> "ltr"
        {:ok, "right-to-left"} -> "rtl"
        {:ok, "left-to-right"} -> "ltr"
        _ -> "ltr"
      end
    else
      _ -> "ltr"
    end
  end

  def dir(_), do: "ltr"
end
