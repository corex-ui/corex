defmodule Corex.MCP.Tools.Guides do
  @moduledoc false

  alias Corex.MCP.Json
  alias Corex.MCP.ToolError

  @max_query 128
  @max_results 20

  def tools do
    [
      %{
        name: "search_docs",
        description: """
        Search Corex usage-rules and Hexdocs guide markdown shipped with the package.
        Prefer this over web search when looking up Corex APIs, patterns, or install steps.
        """,
        inputSchema: %{
          type: "object",
          required: ["query"],
          properties: %{
            query: %{
              type: "string",
              description: "Search string (case-insensitive substring match)."
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &search_docs/1
      },
      %{
        name: "navigation_guide",
        description: """
        Return Corex navigation patterns: <.navigate>, <.action>, and redirect-on-select
        for select/menu/combobox/listbox/tree_view/pagination with Corex.List vs Corex.Tree.
        """,
        inputSchema: %{
          type: "object",
          properties: %{}
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &navigation_guide/1
      }
    ]
  end

  def search_docs(%{"query" => query} = args)
      when is_binary(query) and byte_size(query) > 0 and byte_size(query) <= @max_query and
             map_size(args) == 1 do
    q = String.downcase(query)

    hits =
      doc_roots()
      |> Enum.flat_map(&search_root(&1, q))
      |> Enum.take(@max_results)

    {:ok, Json.encode!(%{query: query, results: hits})}
  end

  def search_docs(_) do
    ToolError.invalid_arguments(
      "search_docs",
      "required query: non-empty string of at most #{@max_query} bytes"
    )
  end

  def navigation_guide(%{} = args) when map_size(args) == 0 do
    {:ok,
     Json.encode!(%{
       patterns: [
         %{
           name: "links",
           heex:
             ~s(<.navigate to={~p"/dashboard"} type="navigate" class="link ui-accent">…</.navigate>)
         },
         %{
           name: "buttons",
           heex:
             ~s(<.action type="button" class="button ui-accent" phx-click="save">Save</.action>)
         },
         %{
           name: "redirect_on_select",
           note:
             "Set redirect on the component. Flat lists: Corex.List; menu/tree_view: Corex.Tree. Per-item :redirect is :href | :patch | :navigate | false.",
           components: ~w(select menu combobox listbox tree_view pagination)
         }
       ],
       references: [
         "https://hexdocs.pm/corex/navigation.html",
         "usage-rules/navigation.md"
       ]
     })}
  end

  def navigation_guide(_), do: ToolError.invalid_arguments("navigation_guide", "no arguments")

  defp doc_roots do
    app_dir = Application.app_dir(:corex)

    [
      Path.join(app_dir, "usage-rules"),
      Path.join(app_dir, "guides"),
      Path.expand("../../../../usage-rules", __DIR__),
      Path.expand("../../../../guides", __DIR__)
    ]
    |> Enum.uniq()
    |> Enum.filter(&File.dir?/1)
  end

  defp search_root(root, q) do
    root
    |> Path.join("**/*.{md,MD}")
    |> Path.wildcard()
    |> Enum.flat_map(fn path ->
      case File.read(path) do
        {:ok, body} ->
          body
          |> String.split("\n")
          |> Enum.with_index(1)
          |> Enum.filter(fn {line, _} -> String.contains?(String.downcase(line), q) end)
          |> Enum.take(3)
          |> Enum.map(fn {line, n} ->
            %{
              path: Path.relative_to(path, root),
              root: Path.basename(root),
              line: n,
              text: String.trim(line) |> String.slice(0, 200)
            }
          end)

        _ ->
          []
      end
    end)
  end
end
