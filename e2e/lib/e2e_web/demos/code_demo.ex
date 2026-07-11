defmodule E2eWeb.Demos.CodeDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

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
        class="clipboard"
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

  def styling_variant_code do
    c = inspect(snippet())

    DemoScales.styling_variant_axis_steps("code")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("code", modifier)
      ~s|<.code class="#{class}" language={:elixir} code={#{c}} />|
    end)
    |> DemoScales.join_code()
  end

  def styling_variant_example(assigns) do
    assigns =
      assigns
      |> assign(:styling_snippet, snippet())
      |> assign(:variants, DemoScales.styling_variant_axis_steps("code"))

    ~H"""
    <div class="flex flex-wrap gap-4 items-start w-full max-w-4xl">
      <.code
        :for={variant <- @variants}
        id={"code-style-variant-#{variant.label |> String.downcase() |> String.replace(" ", "-") |> String.replace("(", "") |> String.replace(")", "")}"}
        class={DemoScales.join_modifiers("code", variant.modifier)}
        language={:elixir}
        code={@styling_snippet}
      />
    </div>
    """
  end

  def styling_variant_matrix_code do
    c = inspect(snippet())

    for semantic <- DemoScales.styling_semantic_axis_steps("code"),
        variant <- DemoScales.styling_variant_axis_steps("code") do
      class = DemoScales.join_matrix_modifiers("code", semantic.modifier, variant.modifier)
      ~s|<.code class="#{class}" language={:elixir} code={#{c}} />|
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:styling_snippet, snippet())
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("code"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("code"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.code
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("code", semantic.modifier, variant.modifier)}
            language={:elixir}
            code={@styling_snippet}
          />
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    c = inspect(snippet())

    DemoScales.text_steps()
    |> Enum.map(fn step ->
      modifier = if step == "md", do: "code", else: "code text-#{step}"
      ~s|<.code class="#{modifier}" language={:elixir} code={#{c}} />|
    end)
    |> DemoScales.join_code()
  end

  def styling_size_example(assigns) do
    assigns =
      assigns
      |> assign(:styling_snippet, snippet())
      |> assign(:text_steps, DemoScales.text_steps())

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={step <- @text_steps} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{step}</p>
        <.code
          class={if step == "md", do: "code", else: "code text-#{step}"}
          language={:elixir}
          code={@styling_snippet}
        />
      </div>
    </div>
    """
  end

  def styling_max_width_code do
    c = inspect(snippet())

    DemoScales.max_width_variants("code")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("code", modifier)
      ~s|<.code class="#{class}" language={:elixir} code={#{c}} />|
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assigns
      |> assign(:styling_snippet, snippet())
      |> assign(:max_width_variants, DemoScales.max_width_variants("code"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.code
          class={DemoScales.join_modifiers("code", variant.modifier)}
          language={:elixir}
          code={@styling_snippet}
        />
      </div>
    </div>
    """
  end

  def styling_rounded_code do
    c = inspect(snippet())

    DemoScales.radius_steps()
    |> Enum.map(fn step ->
      ~s|<.code class="code ui-rounded-#{step}" language={:elixir} code={#{c}} />|
    end)
    |> DemoScales.join_code()
  end

  def styling_rounded_example(assigns) do
    assigns =
      assigns
      |> assign(:styling_snippet, snippet())
      |> assign(:radius_steps, DemoScales.radius_steps())

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={step <- @radius_steps} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{step}</p>
        <.code class={"code ui-rounded-#{step}"} language={:elixir} code={@styling_snippet} />
      </div>
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
