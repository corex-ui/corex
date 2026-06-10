defmodule E2e.PaginationPlayBlog do
  @posts [
    %{title: "Getting started with Corex", excerpt: "Tokens, components, and zero custom CSS."},
    %{
      title: "Pagination with LiveView patch",
      excerpt: "Link mode updates the URL; the server loads the next slice."
    },
    %{
      title: "Design tokens in practice",
      excerpt: "Spacing, ink, and layer colors stay consistent across themes."
    },
    %{
      title: "BEM modifiers on buttons",
      excerpt: "button button--semantic-accent button--size-lg — no new class names."
    },
    %{title: "Zag.js under the hood", excerpt: "Accessible behavior with Phoenix-friendly SSR."},
    %{
      title: "Async lists feel faster",
      excerpt: "assign_async plus a short delay shows real loading states."
    },
    %{
      title: "Playground controls",
      excerpt: "Tune page size and sibling windows without leaving the demo."
    },
    %{
      title: "Ellipsis in pagination",
      excerpt: "Large page counts collapse into prev · 1 … 5 · 10 · next."
    },
    %{title: "RTL support", excerpt: "Flip direction in the toolbar and pagination follows."},
    %{
      title: "Controlled vs link mode",
      excerpt: "Events for in-memory state; patch for shareable URLs."
    },
    %{title: "Short blog excerpts", excerpt: "Demo content only — no database required."},
    %{title: "Skeleton placeholders", excerpt: "Dotted squares while the next page loads."},
    %{title: "Patch navigation", excerpt: "data-phx-link on every page control anchor."},
    %{title: "Page size in the query", excerpt: "?page=2&page_size=5 keeps bookmarkable state."},
    %{
      title: "Corex in Phoenix 1.8",
      excerpt: "LiveView, HEEx, and hooks wired for production apps."
    },
    %{title: "One more post", excerpt: "Enough items to paginate comfortably."},
    %{title: "Almost done", excerpt: "Three pages at five per page."},
    %{title: "Last demo post", excerpt: "End of the sample blog list."}
  ]

  def posts, do: @posts

  def count, do: length(@posts)

  def slice(page, page_size) do
    offset = max(page - 1, 0) * page_size
    Enum.slice(@posts, offset, page_size)
  end
end
