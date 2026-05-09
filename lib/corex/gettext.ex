defmodule Corex.Gettext do
  @moduledoc """
  Runtime gettext for Corex components.

  Host applications configure `config :phoenix, :gettext_backend, MyApp.Gettext` so
  `gettext/1` and `gettext/2` resolve to the app backend at **run time**.

  **Do not** call bare `gettext(...)` inside `attr(..., default: ...)` on components: that
  runs while the module compiles and can bind to the host backend before it exists when
  `:corex` is a path dependency. Use a **literal** default, then call `Corex.Gettext.gettext/1`
  at the start of the render function (see `Corex.Select` and `Corex.Combobox`).

  In component modules that `use Phoenix.Component`, prefer **`Corex.Gettext.gettext/1`**
  and **`Corex.Gettext.gettext/2`** instead of `import Corex.Gettext` + `gettext`, so calls
  are never confused with Phoenix or Gettext macros.
  """

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
