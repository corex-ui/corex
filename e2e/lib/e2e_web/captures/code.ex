defmodule CorexWeb.Code do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Code
  alias E2eWeb.CodeExamples

  @code_examples CodeExamples.all()

  capture variants: [
            elixir: %{
              class: "code",
              code: @code_examples.elixir,
              language: :elixir
            },
            html: %{
              class: "code",
              code: @code_examples.html,
              language: :html
            },
            css: %{
              class: "code",
              code: @code_examples.css,
              language: :css
            },
            js: %{
              class: "code",
              code: @code_examples.js,
              language: :js
            },
            inline: %{
              class: "code",
              code: "conn.request_path",
              language: :elixir,
              inline: true
            },
            from_file: %{
              class: "code",
              code: @code_examples.elixir,
              language: :elixir
            }
          ]

  defdelegate code(assigns), to: Code
end
