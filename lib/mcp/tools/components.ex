# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 Dashbit

defmodule Corex.MCP.Tools.Components do
  @moduledoc false

  alias Corex.MCP.ComponentDocs

  @max_id_length 64
  @unknown_id_message "Unknown component id. Use list_components for valid ids."

  def tools do
    [
      %{
        name: "list_components",
        description:
          "List all Corex component ids from the package registry (atoms serialized as strings, e.g. accordion, date_picker).",
        inputSchema: %{
          type: "object",
          properties: %{}
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &list_components/1
      },
      %{
        name: "get_component",
        description: """
        Return the Elixir module, function component names/arity, optional markdown module docs, source path when known, and docs_note when docs are absent or non-markdown.
        Pass id as from list_components (e.g. accordion, date_picker).
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
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &get_component/1
      }
    ]
  end

  def list_components(%{} = args) when map_size(args) == 0 do
    ids = Enum.map(Corex.component_ids(), &to_string/1)
    {:ok, Corex.Json.encode!(%{components: ids})}
  end

  def list_components(_), do: {:error, :invalid_arguments}

  def get_component(%{"id" => id} = args)
      when is_binary(id) and byte_size(id) <= @max_id_length and map_size(args) == 1 do
    with {:ok, mod} <- Corex.component_module_for_mcp_id(id),
         atom_id = String.to_existing_atom(id),
         {:ok, spec} <- Corex.component_spec(atom_id) do
      spec
      |> ComponentDocs.enrich(mod)
      |> Corex.Json.encode!()
      |> then(&{:ok, &1})
    else
      :error -> {:error, @unknown_id_message}
    end
  end

  def get_component(_), do: {:error, :invalid_arguments}
end
