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

    if is_nil(backend) do
      msg
    else
      if count = opts[:count] do
        Gettext.dngettext(backend, "errors", msg, msg, count, opts)
      else
        Gettext.dgettext(backend, "errors", msg, opts)
      end
    end
  end
end
