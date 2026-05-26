defmodule E2eWeb.Markdown do
  @moduledoc false

  alias E2eWeb.Markdown.CodeBlocks

  def to_html!(body) when is_binary(body) do
    opts = Application.get_env(:corex_web, :mdex, [])
    html = MDEx.to_html!(body, opts)
    CodeBlocks.transform(html)
  end
end
