# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit
# Derived from: https://github.com/tidewave-ai/tidewave_phoenix (lib/tidewave/mcp/tools/logs.ex) tidewave v0.5.5

defmodule Corex.MCP.Tools.Components do
  @moduledoc false

  def tools do
    [
      %{
        name: "corex_list_components",
        description:
          "List all Corex component ids from the project registry (kebab-style atoms such as :accordion, :combobox).",
        inputSchema: %{
          type: "object",
          properties: %{}
        },
        callback: &list_components/1
      },
      %{
        name: "corex_get_component",
        description: """
        Return the Elixir module and function component names/arity for one Corex component.
        The id is a string matching the component key (e.g. "accordion", "date_picker").
        The JSON includes the full English @moduledoc for the component module as `docs`.
        """,
        inputSchema: %{
          type: "object",
          required: ["id"],
          properties: %{
            id: %{
              type: "string",
              description: "Component id, e.g. accordion or data_table"
            }
          }
        },
        callback: &get_component/1
      }
    ]
  end

  def list_components(_args) do
    ids = for id <- Corex.component_ids(), do: to_string(id)
    {:ok, Corex.Json.encode!(%{"components" => ids})}
  end

  def get_component(%{"id" => id}) when is_binary(id) do
    case Corex.component_module_for_mcp_id(id) do
      {:ok, mod} ->
        {:ok, spec} = Corex.component_spec(String.to_existing_atom(id))
        out = Map.put(spec, :docs, raw_moduledoc(mod))
        {:ok, Corex.Json.encode!(out)}

      :error ->
        {:error, "Unknown component id. Use corex_list_components for valid ids."}
    end
  end

  def get_component(_), do: {:error, :invalid_arguments}

  defp raw_moduledoc(mod) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _, _, _mime, %{"en" => doc}, _anno, _rest} when is_binary(doc) ->
        doc

      {:docs_v1, _, _, _mime, doc_map, _anno, _rest} when is_map(doc_map) ->
        Map.get(doc_map, "en", "No en documentation in docs chunk.")

      _other ->
        "No module documentation could be read for #{inspect(mod)} (docs may be stripped or unavailable)."
    end
  end
end
