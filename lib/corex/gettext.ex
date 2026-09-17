defmodule Corex.Gettext do
  @moduledoc false

  @spec backend() :: module() | nil
  def backend do
    Application.get_env(:phoenix, :gettext_backend)
  end

  @spec gettext(String.t(), keyword()) :: String.t()
  def gettext(msg, opts \\ []) do
    backend = backend()

    if is_nil(backend) do
      msg
    else
      Gettext.gettext(backend, msg, opts)
    end
  end

  @spec translate_error({String.t(), keyword()}) :: String.t()
  def translate_error({msg, opts}) do
    backend = backend()

    cond do
      is_nil(backend) ->
        interpolate(msg, opts)

      count = opts[:count] ->
        Gettext.dngettext(backend, "errors", msg, msg, count, opts)

      true ->
        Gettext.dgettext(backend, "errors", msg, opts)
    end
  end

  defp interpolate(msg, opts) do
    Enum.reduce(opts, msg, fn
      {key, value}, acc when is_binary(value) or is_integer(value) or is_atom(value) ->
        String.replace(acc, "%{#{key}}", to_string(value))

      {_key, _value}, acc ->
        acc
    end)
  end
end
