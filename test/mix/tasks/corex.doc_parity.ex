defmodule Mix.Tasks.Corex.DocParity do
  @moduledoc false
  @hidden true

  use Mix.Task

  alias Corex.DocParity

  @impl Mix.Task
  def run(args) do
    {opts, _} =
      OptionParser.parse!(args,
        strict: [sections: :string, components: :string, fail: :boolean]
      )

    sections =
      case Keyword.get(opts, :sections) do
        nil -> [:anatomy, :form]
        value -> value |> String.split(",") |> Enum.map(&String.to_atom/1)
      end

    components =
      case Keyword.get(opts, :components) do
        nil -> DocParity.component_slugs()
        value -> String.split(value, ",")
      end

    results = DocParity.run(sections: sections, components: components)
    IO.puts(DocParity.report(results))

    blocking =
      results
      |> DocParity.failures()
      |> Enum.filter(&(&1.status in [:drift, :ellipsis]))

    if Keyword.get(opts, :fail, true) and blocking != [] do
      Mix.raise("doc parity failed (#{length(blocking)} blocking checks)")
    end
  end
end
