defmodule CorexAdmin.Gettext do
  @moduledoc false

  @domain "admin"

  @doc """
  Translates admin chrome through `Corex.Gettext` on the `"admin"` domain.

  Returns the English `msgid` (with `%{bindings}` interpolated) when the host
  has no Gettext backend. Resource labels stay developer strings.
  """
  @spec t(String.t(), keyword()) :: String.t()
  def t(msgid, bindings \\ []) when is_binary(msgid) and is_list(bindings) do
    backend = Corex.Gettext.backend()
    bindings = Keyword.drop(bindings, [:domain])

    if is_nil(backend) do
      interpolate(msgid, bindings)
    else
      Gettext.dgettext(backend, @domain, msgid, bindings)
    end
  end

  defp interpolate(msgid, bindings) do
    Enum.reduce(bindings, msgid, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
