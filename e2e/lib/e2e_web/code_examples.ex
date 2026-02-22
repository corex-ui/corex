defmodule E2eWeb.CodeExamples do
  @code_examples_path Path.join(:code.priv_dir(:e2e), "code_examples")

  def load(name) do
    path = Path.join(@code_examples_path, name)

    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> ""
    end
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
