defmodule E2eWeb.Markdown.CodeBlocks do
  @moduledoc false

  alias E2eWeb.Markdown.BlockRenderer

  @newline_marker "<!--corex-md-nl-->"

  def transform(html) when is_binary(html) do
    case Floki.parse_fragment(html) do
      {:ok, doc} ->
        doc
        |> walk_fragment(false)
        |> Floki.raw_html()
        |> restore_newlines_after_floki()

      {:error, _} ->
        html
    end
  end

  defp walk_fragment(nodes, in_pre) when is_list(nodes) do
    Enum.flat_map(nodes, &walk_node(&1, in_pre))
  end

  defp walk_node(text, _in_pre) when is_binary(text), do: [text]

  defp walk_node({"pre", attrs, children}, false) do
    case fence_replacement({"pre", attrs, children}) do
      {:ok, html} ->
        parsed_fragment(html)

      :keep ->
        [{"pre", attrs, walk_fragment(children, true)}]
    end
  end

  defp walk_node({"code", attrs, children}, false) do
    case inline_replacement({"code", attrs, children}) do
      {:ok, html} ->
        inline_fragment(html)

      :keep ->
        [{"code", attrs, walk_fragment(children, false)}]
    end
  end

  defp walk_node({"code", attrs, children}, true) do
    [{"code", attrs, walk_fragment(children, true)}]
  end

  defp walk_node({tag, attrs, children}, in_pre) do
    next_in_pre = in_pre or tag == "pre"
    [{tag, attrs, walk_fragment(children, next_in_pre)}]
  end

  defp walk_node(other, _in_pre), do: [other]

  defp parsed_fragment(html) when is_binary(html) do
    html =
      html
      |> makeup_html_before_floki()
      |> preserve_newlines_for_floki()

    case Floki.parse_fragment(html) do
      {:ok, nodes} when is_list(nodes) -> nodes
      _ -> []
    end
  end

  defp inline_fragment(html) when is_binary(html) do
    case Floki.parse_fragment(html) do
      {:ok, nodes} when is_list(nodes) -> nodes
      _ -> []
    end
  end

  defp preserve_newlines_for_floki(html), do: String.replace(html, "\n", @newline_marker)

  defp restore_newlines_after_floki(html), do: String.replace(html, @newline_marker, "\n")

  defp makeup_html_before_floki(html) do
    BlockRenderer.preserve_makeup_whitespace(html)
  end

  defp fence_replacement({"pre", _p_attrs, children}) do
    case normalize_pre_children(children) do
      {:ok, code_attrs, inner} ->
        fence_for_code_block(code_attrs, inner)

      :error ->
        :keep
    end
  end

  defp fence_replacement(_), do: :keep

  defp fence_for_code_block(code_attrs, inner) do
    raw = inner |> code_inner_text() |> HtmlEntities.decode()

    case language_from_class(code_attrs) do
      "corex-callout" ->
        callout_render_or_keep(raw)

      nil ->
        :keep

      lang_str ->
        fence_render_or_keep(raw, lang_str)
    end
  end

  defp callout_render_or_keep(raw) do
    case BlockRenderer.render_callout_html(raw) do
      html when is_binary(html) -> {:ok, html}
      _ -> :keep
    end
  end

  defp fence_render_or_keep(raw, lang_str) do
    atom = lang_atom(lang_str)
    id = fence_id(lang_str, raw)

    case BlockRenderer.render_fence_html(raw, atom, id) do
      html when is_binary(html) -> {:ok, html}
      _ -> :keep
    end
  end

  defp inline_replacement({"code", attrs, children}) do
    raw = children |> code_inner_text() |> HtmlEntities.decode()
    language = inline_language(attrs, raw)

    case BlockRenderer.render_inline_html(raw, language) do
      html when is_binary(html) -> {:ok, html}
      _ -> :keep
    end
  end

  defp inline_language(attrs, raw) do
    case language_from_class(attrs) do
      nil -> infer_inline_language(raw)
      lang_str -> lang_atom(lang_str)
    end
  end

  defp infer_inline_language(raw) do
    cond do
      heex_inline?(raw) -> :heex
      elixir_inline?(raw) -> :elixir
      true -> :plain_text
    end
  end

  defp heex_inline?(raw) do
    Regex.match?(~r/<[:.]|@\{|%\{|:let=|:for=/, raw)
  end

  defp elixir_inline?(raw) do
    Regex.match?(~r/\b(def|alias|import|use|module)\b/, raw) or
      Regex.match?(~r/^[A-Z][\w.]+\b/, raw)
  end

  defp normalize_pre_children(children) do
    filtered =
      Enum.reject(children, fn
        b when is_binary(b) -> String.trim(b) == ""
        _ -> false
      end)

    case filtered do
      [{"code", attrs, inner}] -> {:ok, attrs, inner}
      _ -> :error
    end
  end

  defp language_from_class(attrs) do
    case List.keyfind(attrs, "class", 0) do
      {"class", classes} -> first_language_token(String.split(classes))
      _ -> nil
    end
  end

  defp first_language_token([]), do: nil

  defp first_language_token([class | rest]) do
    case Regex.run(~r/^language-([\w+-]+)$/, class) do
      [_, lang] -> lang
      _ -> first_language_token(rest)
    end
  end

  defp code_inner_text(children) when is_list(children) do
    Enum.map_join(children, "", &code_inner_piece/1)
  end

  defp code_inner_piece(bin) when is_binary(bin), do: bin

  defp code_inner_piece({_tag, _attrs, inner}) do
    code_inner_text(inner)
  end

  defp code_inner_piece(_), do: ""

  defp fence_id(lang_str, raw) do
    h = :crypto.hash(:sha256, lang_str <> <<0>> <> raw)
    "e2e-md-" <> (h |> Base.encode16(case: :lower) |> String.slice(0, 24))
  end

  defp lang_atom("elixir"), do: :elixir
  defp lang_atom("heex"), do: :heex
  defp lang_atom("eex"), do: :eex
  defp lang_atom("html"), do: :html
  defp lang_atom("css"), do: :css
  defp lang_atom("javascript"), do: :javascript
  defp lang_atom("js"), do: :javascript
  defp lang_atom("json"), do: :javascript
  defp lang_atom("bash"), do: :bourne_again_shell_bash
  defp lang_atom("shell"), do: :bourne_again_shell_bash
  defp lang_atom("sh"), do: :bourne_again_shell_bash
  defp lang_atom("zsh"), do: :"shell-unix-generic"
  defp lang_atom("bourne_again_shell_bash"), do: :bourne_again_shell_bash
  defp lang_atom("yaml"), do: :yaml
  defp lang_atom("yml"), do: :yaml

  defp lang_atom(other) when is_binary(other) do
    case String.downcase(other) do
      "plaintext" -> :plain_text
      "text" -> :plain_text
      "txt" -> :plain_text
      _ -> try_atom(other)
    end
  end

  defp try_atom(s) do
    String.to_existing_atom(s)
  rescue
    ArgumentError -> :elixir
  end
end
