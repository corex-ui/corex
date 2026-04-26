defmodule Mix.Corex.Install.EndpointDevPlugs do
  @moduledoc false

  @mcp_block """
    if Mix.env() == :dev do
      plug Corex.MCP
    end
  """

  @spec apply(String.t(), keyword()) :: String.t()
  def apply(content, opts) when is_binary(content) do
    mcp? = Keyword.get(opts, :mcp, true)
    to_insert = build_to_insert(String.trim_trailing(content), mcp?)

    if to_insert == "" do
      content
    else
      insert_dev_plugs(content, to_insert)
    end
  end

  defp build_to_insert(content, mcp?) do
    add_mcp = mcp? && not String.contains?(content, "plug Corex.MCP")

    if add_mcp, do: String.trim_trailing(@mcp_block), else: ""
  end

  defp insert_dev_plugs(content, block_text) do
    needle = "  # Code reloading can be explicitly"

    if String.contains?(content, needle) do
      String.replace(content, needle, block_text <> "\n\n" <> needle, global: false)
    else
      anchor = "    raise_on_missing_only: code_reloading?\n\n"

      if String.contains?(content, anchor) do
        String.replace(
          content,
          anchor,
          anchor <> block_text <> "\n",
          global: false
        )
      else
        content
      end
    end
  end
end
