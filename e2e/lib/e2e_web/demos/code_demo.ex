defmodule E2eWeb.Demos.CodeDemo do
  use E2eWeb, :html

  def examples do
    %{
      elixir: ~S"""
      def hello(name) do
        "Hello, #{name}!"
      end
      """,
      html: ~S"""
      <div class="card">
        <h2>Title</h2>
        <p>Body</p>
      </div>
      """,
      css: ~S"""
      .card {
        border: 1px solid #ddd;
        padding: 16px;
        border-radius: 12px;
      }
      """,
      js: ~S"""
      export function greet(name) {
        return `Hello, ${name}!`;
      }
      """
    }
  end

  def anatomy_inline_code do
    ~S"""
    <p class="text-sm">
      Path:
      <.code inline class="code" language={:elixir} code={~S|conn.request_path|} />
    </p>
    """
  end

  def anatomy_block_code do
    """
    <.code class="code" language={:elixir} code={\"\"\"
    defmodule Greeter do
      def hi, do: :ok
    end
    \"\"\"} />
    """
  end

  def anatomy_block_clipboard_code do
    ~S"""
    <div class="relative w-full">
      <.clipboard
        class="clipboard "
        value={\"\"\"
    def hello(name) do
      "Hello, #{name}!"
    end
    \"\"\"}
        input={false}
        trigger_aria_label="Copy code"
      >
        <:copy><.heroicon name="hero-clipboard" /></:copy>
        <:copied><.heroicon name="hero-check" /></:copied>
      </.clipboard>
      <.code class="code" language={:elixir} code={\"\"\"
    def hello(name) do
      "Hello, #{name}!"
    end
    \"\"\"} />
    </div>
    """
  end

  def anatomy_javascript_code do
    """
    <.code class="code" language={:js} code={\"\"\"
    export function greet(name) {
      return `Hello, ${name}!`;
    }
    \"\"\"} />
    """
  end

  def anatomy_from_file_code do
    """
    <.code class="code" language={:elixir} code={\"\"\"
    defmodule Hello do
      def world do
        "Hello, World!"
      end
    end
    \"\"\"} />
    """
  end

  def styling_size_code do
    c = inspect(snippet())

    """
    <.code class="code code--text-xs" language={:elixir} code={#{c}} />
    <.code class="code" language={:elixir} code={#{c}} />
    <.code class="code code--text-lg" language={:elixir} code={#{c}} />
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :styling_snippet, snippet())

    ~H"""
    <div class="flex flex-wrap gap-6 items-start justify-center w-full">
      <.code class="code code--text-xs" language={:elixir} code={@styling_snippet} />
      <.code class="code" language={:elixir} code={@styling_snippet} />
      <.code class="code code--text-lg" language={:elixir} code={@styling_snippet} />
    </div>
    """
  end

  def styling_max_width_code do
    c = inspect(snippet())

    """
    <.code class="code code--max-w-none w-full" language={:elixir} code={#{c}} />
    <.code class="code code--max-w-sm" language={:elixir} code={#{c}} />
    <.code class="code" language={:elixir} code={#{c}} />
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :styling_snippet, snippet())

    ~H"""
    <div class="flex flex-col gap-4 items-stretch w-full max-w-4xl mx-auto">
      <.code class="code code--max-w-none w-full" language={:elixir} code={@styling_snippet} />
      <.code class="code code--max-w-sm" language={:elixir} code={@styling_snippet} />
      <.code class="code" language={:elixir} code={@styling_snippet} />
    </div>
    """
  end

  defp snippet do
    """
    defmodule Demo do
      @moduledoc false
      def run, do: :ok
    end
    """
  end
end
