defmodule Corex.Gettext do
  @moduledoc false

  def backend do
    Application.get_env(:corex, :gettext_backend)
  end

  @doc """
  Translates an error message using gettext.
  """
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
