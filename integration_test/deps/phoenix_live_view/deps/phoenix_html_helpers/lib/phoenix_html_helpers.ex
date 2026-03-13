defmodule PhoenixHTMLHelpers do
  @moduledoc """
  Collection of helpers to generate and manipulate HTML contents.

  These helpers were used in Phoenix v1.6 and earlier versions,
  before the introduction of `Phoenix.Component`.

  Replace `use Phoenix.HTML` in your applications by:

  ```elixir
  import Phoenix.HTML
  import Phoenix.HTML.Form
  use PhoenixHTMLHelpers
  ```

  To preserve backwards compatibility.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import PhoenixHTMLHelpers.Form
      import PhoenixHTMLHelpers.Link
      import PhoenixHTMLHelpers.Tag
      import PhoenixHTMLHelpers.Format
    end
  end
end
