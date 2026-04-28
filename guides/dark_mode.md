# Dark mode

Light and dark appearance is optional. Enable it when generating or installing Corex so the router, assigns, root layout script, and optional UI stay aligned.

## Enable with the installer

**New app:**

```bash
mix corex.new my_app --mode
```

**Existing app:**

```bash
mix igniter.install corex --yes --corex.mode
```

See [Installation](installation.html) for archives and defaults.

## What the installer wires

With **`--mode`**, Corex typically:

1. Adds **`YourAppWeb.Plugs.Mode`** on the **browser** pipeline **after** `plug :fetch_live_flash`. The plug reads the **`phx_mode`** cookie and puts **`assign(:mode, …)`** (and session) so the first HTML paint matches the user’s choice without a flash.
2. Ensures the root layout’s **`<html>`** exposes **`data-mode`** from **`@mode`** (with a sensible default such as **`light`** when the cookie is absent).
3. Injects a small **inline script** in **`root.html.heex`** (unless one is already present) that:
   - Resolves the effective mode from **`localStorage`** key **`phx:mode`**, then **`data-mode`**, then **prefers-color-scheme**, then writes **`phx_mode`**, **`data-mode`**, and storage so server and client agree.
   - Listens for **`phx:set-mode`** window events (from Corex toggle components) and applies the same resolution path.

Together, **`data-mode="light"`** or **`data-mode="dark"`** on **`document.documentElement`** drives CSS (including Corex Design’s **`dark`** variant when design is enabled).

## Layout components

App layouts generated or patched by Corex expect **`@mode`** where the shell renders mode-dependent UI. If you hand-roll layouts, pass **`mode`** from **`conn.assigns`** / LiveView assigns the same way the installer does.

## Design system CSS

If you use **Corex Design**, run **`mix corex.design`** (or generate with design enabled) so styles that depend on **`[data-mode=dark]`** resolve. Toggle-group styles for the mode control load when mode is enabled together with design imports — see [Installation](installation.html) and [Manual installation](manual_installation.html).

## Manual setup without `--mode`

Mirror the installer: implement **`Plugs.Mode`** like the **`Mix.Tasks.Corex.Install`** output (read **`phx_mode`**, assign **`mode`**), place it after **`fetch_live_flash`**, add **`data-mode={@mode || "light"}`** on **`<html>`**, and include the bridge script behavior described above so cookies, storage, and **`phx:set-mode`** stay consistent.

## Troubleshooting

**Wrong mode on first paint** — Confirm the inline script runs in **`head`** before body paint, **`Plugs.Mode`** runs in the browser pipeline, and **`phx_mode`** matches what the script computes. Hydration issues often come from skipping the script or rendering **`data-mode`** without reading the cookie server-side.

## Related

- [Theming](theming.html) — optional theme picker alongside mode.
- [Installation](installation.html) — flags overview.
