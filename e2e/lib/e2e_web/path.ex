defmodule E2eWeb.Path do
  @moduledoc false

  def strip_after_locale(request_path) when is_binary(request_path) do
    loc = locale_leading_from_path(request_path) || E2eWeb.Locale.current()
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

    if first in E2eWeb.Locale.locales() do
      first
    else
      nil
    end
  end

  def after_locale(path, loc) when is_binary(path) and is_binary(loc) do
    base = "/#{loc}"

    cond do
      path in ["/", base] -> ""
      String.starts_with?(path, base <> "/") -> String.replace_prefix(path, base, "")
      true -> path
    end
  end

  def join_locale_path(locale, after_path)
      when is_binary(locale) and (is_binary(after_path) or after_path == "") do
    base = "/#{locale}"

    cond do
      after_path == "" or after_path == nil -> base
      String.starts_with?(after_path, "/") -> base <> after_path
      true -> base <> "/" <> after_path
    end
  end

  def with_current_locale(after_path) when is_binary(after_path) or after_path == "" do
    join_locale_path(E2eWeb.Locale.current(), after_path)
  end
end
