# API function documentation

Imperative helpers (`play/1`, `set_value/2`, …) appear in Hex under the **API** group when tagged with `@doc type: :api` (see `groups_for_docs` in `mix.exs`).

## Required pattern

Every public API arity needs a **second** `@doc` with description and copy-paste examples. Reference implementation: `Corex.Accordion.set_value/2`.

    @doc type: :api
    @doc ~S"""
    One-line purpose (client or server).

    (heex example with phx-click and id on the component)

    (javascript CustomEvent or elixir handle_event for server)
    """
    def fn(id) when is_binary(id) do
      ...
    end

Server arities document the `push_event` name and payload keys. Link the matching client arity when useful.

## Delegate arities

Thin wrappers (`scroll_next/1` → `scroll_next/2`, `value/1` → `value/2`) use `@doc false` so Hex does not show empty duplicate pages. Document the primary arity instead.

## Examples in docs

- Stable `id="..."` on the component host (API examples require it).
- No `E2eWeb` or `~p` routes in fenced blocks.
- Prefer the same markup as e2e `api_*` demo snippets when they exist.

## Check before release

    MIX_ENV=docs mix docs

Open `doc/index.html`, pick a component, and confirm each **API** entry has Doc text and rendered examples.
