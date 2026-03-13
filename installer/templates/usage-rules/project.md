# Project and Tools

Elixir, Mix, testing, and project conventions. Everything needed to work correctly in an Elixir/Phoenix project without guessing.

## Elixir fundamentals

- **List access:** Elixir lists do not support index access (`mylist[i]`). Use `Enum.at/2`, `Enum.fetch/2`, or pattern matching.
- **Immutability:** Variables are immutable; rebind with `socket = assign(socket, ...)`. Never rebind inside `if`/`case` and expect the outer variable to change.
- **Struct access:** Do not use `map[:field]` on structs. Use `struct.field` or APIs like `Ecto.Changeset.get_field/2`.
- **Date/time:** Use stdlib `Date`, `Time`, `DateTime`, `Calendar`. Avoid extra date libs unless parsing is required.
- **`String.to_atom/1`:** Never on user input (memory leak).
- **Predicates:** End with `?`, avoid `is_` prefix (reserved for guards).
- **Modules:** One module per file; nesting causes cyclic dependency issues.

## Mix and tooling

- Run `mix precommit` before considering changes complete (compile, format, test, deps.unlock --unused).
- Run `mix format` to enforce style; respect `.formatter.exs` inputs.
- Run `mix compile --warnings-as-errors` in CI.
- Use `mix help task_name` before using tasks.
- Debug tests: `mix test path/to/test.exs` or `mix test --failed`.
- Avoid `mix deps.clean --all` unless necessary.

## ExUnit best practices

- Use `async: true` when tests do not share mutable state.
- **ConnCase** for controller/LiveView tests; **DataCase** for context/schema tests.
- Use `start_supervised!/1` for processes; avoid `Process.sleep/1` and `Process.alive?/1`.
- Use `Process.monitor/1` and `assert_receive {:DOWN, ...}` instead of sleeping.
- Use `Phoenix.LiveViewTest` with `element/2`, `has_element?/2`; never assert on raw HTML strings.
- Use DOM IDs from templates in selectors.
- For Ecto tests: `DataCase.setup_sandbox(tags)` in ConnCase; use repo from config.

## HTTP

- Use **Req** for HTTP; avoid `:httpoison`, `:tesla`, `:httpc`. Req is the Phoenix default.

## Project layout

- `lib/` for application code; `lib/my_app_web/` for web layer.
- `test/support/` for test helpers; `elixirc_paths(:test)` includes it.
- Follow existing module organization; place new code in the appropriate context.
