defmodule Corex.MCP.Tools.Installation do
  @moduledoc false

  def tools do
    [
      %{
        name: "corex_installation",
        description: """
        Return commands and pointers for installing Corex: new Phoenix app (`mix corex.new`) or adding Corex to an existing app (`mix igniter.install corex`).
        Read-only reference for agents; does not run shell commands.
        """,
        inputSchema: %{
          type: "object",
          properties: %{
            scenario: %{
              type: "string",
              enum: ["new_project", "existing_project", "all"],
              description:
                "new_project: generator and archives only; existing_project: Igniter install only; all: both (default)."
            }
          }
        },
        annotations: %{"readOnlyHint" => true, "idempotentHint" => true},
        callback: &installation_guide/1
      }
    ]
  end

  def installation_guide(args) do
    scenario =
      case Map.get(args || %{}, "scenario") do
        s when s in ["new_project", "existing_project", "all"] -> s
        nil -> "all"
        _ -> "all"
      end

    payload =
      case scenario do
        "new_project" -> Map.put(new_project_section(), :scenario, scenario)
        "existing_project" -> Map.put(existing_project_section(), :scenario, scenario)
        "all" -> full_guide()
      end

    {:ok, Corex.Json.encode!(payload)}
  end

  defp full_guide do
    %{
      scenario: "all",
      new_project: new_project_section(),
      existing_project: existing_project_section(),
      reference_urls: %{
        hexdocs_corex: "https://hexdocs.pm/corex",
        repository: "https://github.com/corex-ui/corex"
      }
    }
  end

  defp new_project_section do
    %{
      intent: "Create a new Phoenix application with Corex preconfigured.",
      prerequisites: [
        "Install the Igniter archive once per machine.",
        "Install the corex_new archive for mix corex.new."
      ],
      commands: [
        %{step: 1, run: "mix archive.install hex igniter"},
        %{step: 2, run: "mix archive.install hex corex_new"},
        %{step: 3, run: "mix corex.new my_app"}
      ],
      update_generator: %{
        command: "mix local.corex",
        note: "Updates the corex.new archive before generating a project."
      },
      pipeline:
        "corex.new forwards phx.new (or phx.new.web) arguments, then runs igniter.install corex with Corex flags.",
      mix_help: "mix help corex.new",
      task_module: "Mix.Tasks.Corex.New"
    }
  end

  defp existing_project_section do
    %{
      intent: "Add Corex to an existing Phoenix project.",
      commands: [
        %{step: 1, run: "mix igniter.install corex --yes"}
      ],
      alternatives: [
        %{
          when: "Installing from a local corex checkout",
          run: "mix igniter.install corex@path:../corex --yes"
        }
      ],
      mix_help: "mix help igniter.install",
      task_module: "Mix.Tasks.Corex.Install",
      note:
        "The install task is Mix.Tasks.Corex.Install; igniter.install corex is the usual entry point when Igniter is available."
    }
  end
end
