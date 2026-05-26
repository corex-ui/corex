# Blog posts (`_posts/`)

English posts live in `_posts/*.md`. Arabic posts live in `_posts/ar/*.md`.

## Front matter

```yaml
---
title: "Post title"
description: "One-line summary for index and SEO"
date: 2026-05-20 12:00:00 +0000
permalink: /en/blog/my-slug/
tags:
  - Corex
sitemap:
  priority: 0.7
  changefreq: monthly
---
```

Use `##` for in-article headings (the page template already renders the post title as `<h1>`).

## Markdown features

- Fenced code with language tags (`elixir`, `heex`, `javascript`, `bash`, …) → Makeup highlighting + clipboard copy
- GitHub-style alerts (`> [!NOTE]`, `> [!TIP]`, …) via MDEx
- Tables, task lists, footnotes (see `config :corex_web, :mdex` in `config/config.exs`)

## Corex callouts (static HTML)

Fenced blocks with language `corex-callout` render a styled callout at build time:

````markdown
```corex-callout note
Optional title on this line

Body paragraph. Blank lines become separate paragraphs.
```
````

Variants: `note`, `tip`, `warning`, `important` (first line). If the first line is not a variant, it is treated as the title with `note` styling.

## HEEx and LiveView components

You cannot embed `~H` or LiveView components directly in `.md` files. MDEx produces HTML stored on the post at compile time.

What works:

| Approach | Use for |
|----------|---------|
| Fenced `corex-callout` | Static callout boxes |
| Raw HTML with Corex BEM classes | Static markup (`render: [unsafe: true]`) |
| Fenced code | Examples with copy button |
| Links to `/en/...` routes | Demos and docs on this site |

Interactive demos belong in linked playground pages, not inside markdown bodies (a future embed API could add placeholders).

## New post

```bash
mix e2e.gen.post "My post title"
mix e2e.gen.post "Arabic title" --locale ar
```

Restart or recompile the app to load new files.

## RSS

English posts are exposed at **`/feed.xml`** (RSS 2.0). The feed is built at compile time from the same `_posts/*.md` list as the blog index and sitemap. After adding or editing a post, run `mix compile --force` in `e2e` so the feed updates.

The layout `<head>` includes `<link rel="alternate" type="application/rss+xml" …>` pointing at that URL.

## Article series (one topic per post)

| Order | Slug | Topic |
|-------|------|--------|
| 1 | [anatomy-of-a-corex-component](/en/blog/anatomy-of-a-corex-component/) | Items, slots, `:let`, manual slots, compound |
| 2 | [two-brains-liveview-assigns-and-zag-machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/) | Assigns, bindings, controlled mode, Zag machines |
| 3 | [the-vanilla-js-machine-that-doesnt-need-a-framework](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) | `LiveSocket` hooks, lifecycle, `push_event` |
| 4 | [paint-the-parts-the-machine-already-owns](/en/blog/paint-the-parts-the-machine-already-owns/) | Tokens, utilities, contrast |
| 5 | [nine-thousand-airports-one-hundred-rows](/en/blog/nine-thousand-airports-one-hundred-rows/) | Server-fed `items`, `filter={false}` |
| 6 | [how-fast-is-the-checkbox-api-play-tetrex-and-find-out](/en/blog/how-fast-is-the-checkbox-api-play-tetrex-and-find-out/) | Checkbox API at scale, client play, Presence, leaderboard replays |

Arabic editions live in `_posts/ar/*.md` with `permalink: /ar/blog/<slug>/` (same slugs as English).

Do not combine multiple topics in one post. Link forward at the end; keep the body focused.

Use `sitemap.priority: 0.9` for the lead article in the series; `0.7`–`0.8` for the rest.

## Editorial checklist

Before publishing or expanding a post:

| Check | Requirement |
|-------|-------------|
| Length | Match the topic: prefer clarity and narrative density over padding |
| Code | Snippets match HexDocs, `guides/`, and current `0.1.x` API ([update guide](https://hexdocs.pm/corex/update.html)) |
| Vanilla JS | Use `import corex from "corex"` and hook registration. Do not document fictional `corex.combobox({...}).init()` factories |
| Claims | Unique statements trace to repo source (guides, `lib/components/`, tests) |
| Headings | Only `##` and below in the body; title lives in front matter |
| Voice | Philosophy first; terminology aligned with [LiveView guides](https://hexdocs.pm/phoenix_live_view/welcome.html) (assigns, bindings, hooks); fewer purposeful examples; no fiction |
| Punctuation | Do not use em dashes (`—`); use a colon, comma, or period instead |
| Demos | Link to live routes (`/en/<component>/anatomy`, `/api`, `/events`, `/live-form`) instead of embedding LiveView in markdown |
| Cross-links | Prefer internal paths; “Continue reading” on post pages is tag-based via `E2e.Blog.suggested_reads/3` |

## Accuracy sources

When writing, verify against:

- `README.md` and `guides/installation.md`, `guides/manual_installation.md`
- Component `@moduledoc` in `lib/components/<name>.ex` (Anatomy, API, Events)
- `assets/lib/core.ts` and `assets/hooks/<name>.ts` for client behavior
- `guides/tableau.md` for static export
- `guides/design.md` for tokens and Designex

## Optional front matter (future)

`related:` with a list of slugs could override tag-based suggested reads. Not implemented yet; use tags until then.
