defmodule Corex.Code do
  @moduledoc ~S'''
  Displays syntax-highlighted code with Makeup.

  ## Installation

  Add `makeup` and the lexer packages for each language you use:

  ```elixir
  defp deps do
    [
      {:makeup, "~> 1.2"},
      {:makeup_elixir, "~> 1.0.1 or ~> 1.1"},
      {:makeup_html, "~> 1.0"},
      {:makeup_css, "~> 1.0"},
      {:makeup_js, "~> 1.0"}
    ]
  end
  ```

  Only `makeup` is required. Add the lexer packages you need; without a lexer, code renders as plain escaped text.

  ## Examples

  ### Basic Usage

  ```heex
  <.code code="def hello, do: :world" />
  ```

  ### Multi-line with heredoc

  Use `"""` heredoc for readable multi-line code in templates:

  ```heex
  <.code code={"""
  defmodule Hello do
    def world, do: "Hello, World!"
  end
  """} />
  ```

  ### Loading from a file

  ```heex
  <.code code={File.read!("priv/code_examples/example.ex")} language={:elixir} />
  ```

  Or in a controller, load the file and pass the contents:

  ```elixir
  def my_page(conn, _params) do
    code = File.read!("priv/code_examples/example.ex")

    render(conn, :my_page, code: code)
  end
  ```

  ```heex
  <.code code={@code} language={:elixir} />
  ```

  The `language` attribute maps to Makeup's registry (e.g. `:elixir` → `"elixir"`).
  Add the corresponding lexer package to your deps for each language. Without it, code renders as plain escaped text.

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="code"][data-part="root"] {}
  [data-scope="code"][data-part="content"] {}
  ```

  With Corex Design (`mix corex.design`), syntax highlighting styles are included in
  `code.css`. Nothing else is required.

  Without Corex Design, run `mix corex.code` to generate the Makeup stylesheet and
  import it in your CSS:

  ```bash
  mix corex.code
  mix corex.code assets/styles/syntax.css
  mix corex.code --force
  ```

  ```css
  @import "./code_highlight.css";
  ```
  '''

  @doc type: :component
  use Phoenix.Component

  attr(:code, :string, required: true, doc: "The raw source code to display")

  attr(:language, :atom,
    default: :elixir,
    doc:
      "The language name in Makeup's registry (e.g. :elixir, :html). Add the lexer package to deps; otherwise renders as plain escaped text."
  )

  attr(:rest, :global)

  def code(assigns) do
    makeup = Module.concat(["Elixir", "Makeup"])

    unless Code.ensure_loaded?(makeup) do
      raise """
      Corex.Code requires makeup.

      Add it to your mix.exs:

        {:makeup, "~> 1.2"}

      Add lexer packages for each language you use (e.g. makeup_elixir, makeup_html).
      """
    end

    assigns =
      assigns
      |> assign(:lexer, lexer_for(assigns.language))
      |> then(&assign(&1, :highlighted_html, highlight_code(&1)))

    ~H"""
    <div data-scope="code" data-part="root" {@rest}>
      <div data-scope="code" data-part="content">
        <pre class="highlight" tabindex="0"><code>{Phoenix.HTML.raw(@highlighted_html)}</code></pre>
      </div>
    </div>
    """
  end

  defp lexer_for(language) do
    name = to_string(language)
    registry = Module.concat(["Elixir", "Makeup", "Registry"])

    case apply(registry, :fetch_lexer_by_name, [name]) do
      {:ok, {lexer, _opts}} -> lexer
      :error -> nil
    end
  end

  defp highlight_code(assigns) do
    case assigns.lexer do
      nil ->
        assigns.code
        |> Phoenix.HTML.html_escape()
        |> Phoenix.HTML.safe_to_string()

      lexer ->
        makeup = Module.concat(["Elixir", "Makeup"])
        apply(makeup, :highlight_inner_html, [assigns.code, [lexer: lexer]])
    end
  end
end
