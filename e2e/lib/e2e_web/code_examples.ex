defmodule E2eWeb.CodeExamples do
  def load(name) do
    path = Path.join(code_examples_path(), name)

    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> ""
    end
  end

  defp code_examples_path do
    Path.join(:code.priv_dir(:corex_web), "code_examples")
  end

  def all do
    %{
      elixir: load("hello.ex"),
      html: load("component.html"),
      css: load("styles.css"),
      js: load("app.js")
    }
  end
end
