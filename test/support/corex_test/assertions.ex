defmodule CorexTest.Assertions do
  @moduledoc false
  import ExUnit.Assertions

  def assert_has_data(html, selector, expected) when is_binary(html) and is_map(expected) do
    case Floki.parse_fragment(html) do
      {:ok, doc} ->
        assert_has_data(doc, selector, expected)

      {:error, reason} ->
        flunk("expected HTML fragment, got #{inspect(reason)}")
    end
  end

  def assert_has_data(doc, selector, expected) when is_map(expected) do
    assert [el | _] = Floki.find(doc, selector),
           "expected selector #{inspect(selector)} to match an element"

    for {k, want} <- expected do
      key = to_string(k)
      assert [got] = Floki.attribute(el, key), "expected attribute #{key} to be present"
      assert got == to_string_value(want)
    end

    :ok
  end

  def refute_data(html, selector, attr) when is_binary(html) do
    case Floki.parse_fragment(html) do
      {:ok, doc} ->
        refute_data(doc, selector, attr)

      {:error, reason} ->
        flunk("expected HTML fragment, got #{inspect(reason)}")
    end
  end

  def refute_data(doc, selector, attr) do
    key = to_string(attr)

    for el <- Floki.find(doc, selector) do
      refute match?([_ | _], Floki.attribute(el, key)),
             "expected #{key} to be absent on #{inspect(selector)}"
    end

    :ok
  end

  defp to_string_value(nil), do: ""
  defp to_string_value(v), do: to_string(v)
end
