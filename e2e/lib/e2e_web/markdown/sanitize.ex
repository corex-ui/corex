defmodule E2eWeb.Markdown.Sanitize do
  @moduledoc false

  @blocked_tags ~W(script iframe object embed form)

  def html(html) when is_binary(html) do
    case Floki.parse_fragment(html) do
      {:ok, doc} ->
        doc
        |> drop_blocked()
        |> strip_handlers()
        |> Floki.raw_html()

      {:error, _} ->
        ""
    end
  end

  defp drop_blocked(nodes) when is_list(nodes) do
    Enum.flat_map(nodes, &drop_blocked_node/1)
  end

  defp drop_blocked_node(text) when is_binary(text), do: [text]

  defp drop_blocked_node({tag, _attrs, _children}) when tag in @blocked_tags, do: []

  defp drop_blocked_node({tag, attrs, children}) do
    [{tag, attrs, drop_blocked(children)}]
  end

  defp drop_blocked_node(other), do: [other]

  defp strip_handlers(nodes) when is_list(nodes) do
    Enum.map(nodes, &strip_handlers_node/1)
  end

  defp strip_handlers_node(text) when is_binary(text), do: text

  defp strip_handlers_node({tag, attrs, children}) do
    {tag, Enum.reject(attrs, &event_or_js_attr?/1), strip_handlers(children)}
  end

  defp strip_handlers_node(other), do: other

  defp event_or_js_attr?({name, value}) when is_binary(name) do
    String.starts_with?(String.downcase(name), "on") or javascript_url?(value)
  end

  defp event_or_js_attr?(_), do: false

  defp javascript_url?(value) when is_binary(value) do
    value |> String.trim() |> String.downcase() |> String.starts_with?("javascript:")
  end

  defp javascript_url?(_), do: false
end
