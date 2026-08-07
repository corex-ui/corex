defmodule Mix.Tasks.Corex.DocParity do
  @moduledoc false

  use Mix.Task

  alias Corex.DocParity

  @sections %{"anatomy" => :anatomy, "form" => :form}

  @impl Mix.Task
  def run(args) do
    {opts, _} =
      OptionParser.parse!(args,
        strict: [sections: :string, components: :string, fail: :boolean]
      )

    sections =
      case Keyword.get(opts, :sections) do
        nil -> Map.values(@sections)
        value -> value |> String.split(",") |> Enum.map(&parse_section!/1)
      end

    components =
      case Keyword.get(opts, :components) do
        nil -> DocParity.component_slugs()
        value -> String.split(value, ",")
      end

    results = DocParity.run(sections: sections, components: components)
    IO.puts(DocParity.report(results))

    blocking = DocParity.failures(results)

    if Keyword.get(opts, :fail, true) and blocking != [] do
      Mix.raise("doc parity failed (#{length(blocking)} blocking checks)")
    end
  end

  defp parse_section!(name) do
    case Map.fetch(@sections, String.trim(name)) do
      {:ok, section} ->
        section

      :error ->
        Mix.raise(
          "unknown --sections value #{inspect(name)}, expected one of: " <>
            Enum.join(Map.keys(@sections), ", ")
        )
    end
  end
end
