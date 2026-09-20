defmodule Palaver.Plugin do
  @moduledoc """
  A tool that can sit down at the conversation and leave again.

  A plugin is a module, and the session holds nothing but the module name. That
  is what lets a plugin be recompiled underneath a running conversation: the
  next turn resolves the same atom and gets the new code, while the history and
  the session id stay exactly where they were.

      defmodule Echo do
        @behaviour Palaver.Plugin

        @impl true
        def name, do: "echo"

        @impl true
        def schema do
          %{type: "object", properties: %{"text" => %{type: "string"}}}
        end

        @impl true
        def call(%{"text" => text}, _context), do: {:ok, text}
      end
  """

  @typedoc """
  What a plugin learns about the conversation it was called from.

  `:node` is the node the plugin is actually executing on, which is not
  necessarily the node holding the conversation.
  """
  @type context :: %{
          session_id: String.t(),
          tool_call_id: String.t(),
          node: node()
        }

  @doc "The name the mind uses to ask for this tool."
  @callback name() :: String.t()

  @doc "A JSON-schema-shaped description of the arguments."
  @callback schema() :: map()

  @doc "Do the work. Runs off the session process, possibly on another node."
  @callback call(args :: map(), context()) :: {:ok, term()} | {:error, term()}
end
