defmodule Corex.Api do
  @moduledoc false

  defmodule Doc do
    @moduledoc false

    @doc false
    defmacro api_doc(contents) do
      quote do
        @doc type: :api
        @doc unquote(contents)
      end
    end

    @doc false
    defmacro api_doc_short(contents) do
      quote do
        @doc type: :api
        @doc unquote(contents)
      end
    end

    @doc false
    defmacro api_doc_hidden do
      quote do
        @doc false
      end
    end
  end

  defmodule Response do
    @moduledoc false

    alias Phoenix.LiveView
    alias Phoenix.LiveView.JS

    def respond_to_fields(opts) when is_list(opts) do
      Corex.Helpers.respond_to_fields(opts)
    end

    def push_event(socket, event, payload)
        when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_map(payload) do
      LiveView.push_event(socket, event, payload)
    end

    def push_set_value(socket, event, id, value)
        when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_binary(id) do
      push_event(socket, event, %{id: id, value: value})
    end

    def push_set_open(socket, event, id, open)
        when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(event) and is_binary(id) and
               is_boolean(open) do
      push_event(socket, event, %{id: id, open: open})
    end

    def dispatch_set_value(component_id, value, hook_event, opts \\ []) do
      bubbles = Keyword.get(opts, :bubbles, false)

      JS.dispatch(hook_event,
        to: "##{component_id}",
        detail: %{id: component_id, value: value},
        bubbles: bubbles
      )
    end

    def dispatch_set_open(component_id, open, hook_event, opts \\ []) when is_boolean(open) do
      bubbles = Keyword.get(opts, :bubbles, false)

      JS.dispatch(hook_event,
        to: "##{component_id}",
        detail: %{id: component_id, open: open},
        bubbles: bubbles
      )
    end
  end

  defmodule Imports do
    @moduledoc false

    defmacro __using__(opts) do
      api = Keyword.fetch!(opts, :to)

      quote do
        import Corex.Api.Doc
        alias unquote(api), as: Api
      end
    end
  end
end
