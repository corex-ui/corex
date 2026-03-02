defmodule CorexTest.ComponentCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint CorexTest.Endpoint
      import Phoenix.LiveViewTest

      defp find_in_html(html, selector) do
        {:ok, doc} = Floki.parse_fragment(to_string(html))
        Floki.find(doc, selector)
      end

      defp text_in_html(html) do
        {:ok, doc} = Floki.parse_fragment(to_string(html))
        Floki.text(doc)
      end
    end
  end

  setup _tags do
    :ok
  end
end
