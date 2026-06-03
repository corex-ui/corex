defmodule Corex.Gettext do
  @moduledoc false

  @compile {:no_warn_undefined, [Gettext]}

  def backend do
    Application.get_env(:phoenix, :gettext_backend)
  end

  def gettext(msg, opts \\ []) do
    backend = backend()

    if is_nil(backend) do
      msg
    else
      Gettext.gettext(backend, msg, opts)
    end
  end

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
