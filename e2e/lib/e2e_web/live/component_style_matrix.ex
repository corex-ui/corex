defmodule E2eWeb.ComponentStyleMatrix do
  @moduledoc false

  use E2eWeb, :html

  import E2eWeb.DemoPage, only: [demo_section: 1, demo_style_matrix: 1]

  attr :component, :atom, required: true

  def style_matrix(assigns) do
    config = E2eWeb.ComponentStyleConfig.get(assigns.component)
    assigns = assign(assigns, :config, config)

    ~H"""
    <.demo_style_matrix id={"#{@config.slug}-style-matrix"}>
      <.demo_section
        :for={section <- @config.matrix_sections}
        id={section_id(@config.slug, section.key)}
        title={section.title}
        values={section.values}
        code={section.code}
        code_tabs={section.code_tabs}
      >
        <:preview>
          {render_section_example(assigns, section)}
        </:preview>
      </.demo_section>
    </.demo_style_matrix>
    """
  end

  defp section_id(slug, key) do
    "#{slug}-style-#{key |> Atom.to_string() |> String.replace("_", "-")}"
  end

  defp render_section_example(assigns, %{demo_module: demo_module, example_fun: example_fun}) do
    apply(demo_module, example_fun, [assigns])
  end
end
