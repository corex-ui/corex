defmodule CorexTest.ComponentCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint CorexTest.Endpoint
      import Phoenix.LiveViewTest
      import CorexTest.Assertions

      defp find_in_html(html, selector) do
        case Floki.parse_fragment(to_string(html)) do
          {:ok, doc} ->
            Floki.find(doc, selector)

          {:error, reason} ->
            flunk("expected HTML fragment, got #{inspect(reason)}")
        end
      end

      defp text_in_html(html) do
        case Floki.parse_fragment(to_string(html)) do
          {:ok, doc} ->
            Floki.text(doc)

          {:error, reason} ->
            flunk("expected HTML fragment, got #{inspect(reason)}")
        end
      end
    end
  end

  setup _tags do
    :ok
  end
end
