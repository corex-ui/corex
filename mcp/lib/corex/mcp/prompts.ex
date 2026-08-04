defmodule Corex.MCP.Prompts do
  @moduledoc false

  @prompts [
    %{
      name: "corex_form",
      description:
        "Recipe for Phoenix to_form + Corex inputs with field, auto_invalid, controlled.",
      arguments: []
    },
    %{
      name: "corex_controlled",
      description: "Controlled LiveView pattern: value + on_*_change + API set_* helpers.",
      arguments: [
        %{
          name: "id",
          description: "Component id (e.g. accordion, select)",
          required: false
        }
      ]
    },
    %{
      name: "corex_style",
      description:
        "Pick ui-* modifiers for a component via get_component_style / list_modifiers.",
      arguments: [
        %{
          name: "id",
          description: "Component id (snake or kebab)",
          required: true
        }
      ]
    }
  ]

  def list, do: @prompts

  def get("corex_form", _args) do
    {:ok,
     %{
       description: "Corex form recipe",
       messages: [
         %{
           role: "user",
           content: %{
             type: "text",
             text: """
             Build a Phoenix LiveView form with `to_form/2` and Corex inputs.
             Use `field={@form[:name]}`, `auto_invalid` for alert borders, and `controlled`
             on select/combobox/listbox. Submit with `<.action type="submit" class="button ui-accent">`.
             Call MCP `get_component` for each input id before inventing attrs.
             """
           }
         }
       ]
     }}
  end

  def get("corex_controlled", args) do
    id = Map.get(args, "id", "accordion")

    {:ok,
     %{
       description: "Controlled #{id}",
       messages: [
         %{
           role: "user",
           content: %{
             type: "text",
             text: """
             Implement a controlled LiveView pattern for Corex `#{id}`:
             1. MCP `get_component { id: "#{id}" }` for value attrs, on_* events, and api helpers.
             2. Keep state in assigns; pass controlled + explicit value; handle on_*_change.
             3. Prefer module API (set_value/set_open/…) when updating from the server.
             """
           }
         }
       ]
     }}
  end

  def get("corex_style", %{"id" => id}) when is_binary(id) and id != "" do
    {:ok,
     %{
       description: "Style #{id}",
       messages: [
         %{
           role: "user",
           content: %{
             type: "text",
             text: """
             Style Corex `#{id}` with Design modifiers only (no custom BEM).
             Call `get_component_style { id: "#{id}" }` and `list_modifiers` if needed.
             Stack `ui-*` on the host class; use Tailwind for layout width.
             """
           }
         }
       ]
     }}
  end

  def get("corex_style", _), do: {:error, "corex_style requires id"}
  def get(_, _), do: {:error, "Unknown prompt"}
end
