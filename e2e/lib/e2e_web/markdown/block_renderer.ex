defmodule E2eWeb.Markdown.BlockRenderer do
  @moduledoc false

  use Phoenix.Component
  use Corex

  attr(:code, :string, required: true)
  attr(:language, :atom, required: true)
  attr(:clipboard_id, :string, required: true)
  attr(:inner_html, :string, default: nil)

  def fence(assigns) do
    ~H"""
    <div class="relative">
      <%= if @inner_html do %>
        <pre data-scope="code" data-part="root" tabindex="0" class="code max-w-none">
          <code data-scope="code" data-part="content">{Phoenix.HTML.raw(@inner_html)}</code>
        </pre>
      <% else %>
        <.code class="code max-w-none" language={@language} code={@code} />
      <% end %>
      <.clipboard
        id={@clipboard_id}
        class="clipboard ui-size-sm absolute top-2 right-2 z-10"
        value={@code}
        input={false}
        trigger_aria_label="Copy code"
      >
        <:copy>
          <.heroicon name="hero-clipboard" />
        </:copy>
        <:copied>
          <.heroicon name="hero-check" />
        </:copied>
      </.clipboard>
    </div>
    """
  end

  attr(:code, :string, required: true)
  attr(:language, :atom, required: true)

  def inline(assigns) do
    ~H"""
    <.code class="code" inline language={@language} code={@code} />
    """
  end

  def render_fence_html(code, language, clipboard_id) do
    ensure_makeup_apps()

    inner_html = highlight_fence_lines(code, language)

    %{
      __changed__: %{},
      code: code,
      language: language,
      clipboard_id: clipboard_id,
      inner_html: inner_html
    }
    |> fence()
    |> rendered_to_string()
  end

  def render_inline_html(code, language) do
    ensure_makeup_apps()

    %{__changed__: %{}, code: code, language: language}
    |> inline()
    |> rendered_to_string()
    |> preserve_makeup_whitespace()
  end

  def preserve_makeup_whitespace(html) when is_binary(html) do
    String.replace(html, ~r/<span class="w">\s*<\/span>/, "<span class=\"w\">&nbsp;</span>")
  end

  defp highlight_fence_lines(code, language) do
    lexer = to_string(language)

    code
    |> String.split("\n", trim: false)
    |> Enum.map(&highlight_line(&1, lexer))
    |> Enum.intersperse("<br />")
    |> IO.iodata_to_binary()
  end

  defp highlight_line(line, lexer) do
    case Makeup.highlight_inner_html(line, lexer: lexer) do
      html when is_binary(html) -> html
      _ -> escape_html(line)
    end
  end

  defp rendered_to_string(rendered) do
    rendered
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
    |> strip_component_comments()
  end

  defp strip_component_comments(html) do
    Regex.replace(~r/<!--.*?-->\s*/s, html, "")
  end

  @callout_variants ~W(note tip warning important)

  def render_callout_html(raw) when is_binary(raw) do
    {variant, title, body} = parse_callout(raw)

    title_html =
      if title,
        do: "<p class=\"markdown corex-callout-title\">#{escape_html(title)}</p>",
        else: ""

    body_html = callout_body_html(body)

    """
    <div class="markdown corex-callout corex-callout--#{variant}">
    #{title_html}
    <div class="markdown corex-callout-body">#{body_html}</div>
    </div>
    """
  end

  defp parse_callout(raw) do
    lines =
      raw
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    case lines do
      [] ->
        {"note", nil, ""}

      [variant | rest] when variant in @callout_variants ->
        case rest do
          [title | body_lines] -> {variant, title, Enum.join(body_lines, "\n\n")}
          [] -> {variant, nil, ""}
        end

      [title | body_lines] ->
        {"note", title, Enum.join(body_lines, "\n\n")}
    end
  end

  defp callout_body_html(""), do: ""

  defp callout_body_html(body) do
    body
    |> String.split(~r/\n\s*\n/, trim: true)
    |> Enum.map_join("", fn paragraph ->
      "<p>#{escape_html(String.trim(paragraph))}</p>"
    end)
  end

  defp escape_html(text) do
    text
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
  end

  defp ensure_makeup_apps do
    Enum.each(
      [
        :makeup_elixir,
        :makeup_eex,
        :makeup_html,
        :makeup_css,
        :makeup_js,
        :makeup_syntect
      ],
      &Application.ensure_all_started/1
    )
  end
end
