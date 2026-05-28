defmodule E2e.BlogTest do
  use ExUnit.Case, async: true

  @en_slugs [
    "how-fast-is-the-checkbox-api-play-tetrex-and-find-out",
    "two-brains-liveview-assigns-and-zag-machines",
    "the-vanilla-js-machine-that-doesnt-need-a-framework",
    "nine-thousand-airports-one-hundred-rows",
    "paint-the-parts-the-machine-already-owns",
    "anatomy-of-a-corex-component"
  ]

  test "list_posts includes english articles" do
    posts = E2e.Blog.list_posts("en")
    assert length(posts) == 6

    for slug <- @en_slugs do
      assert Enum.any?(posts, &(&1.slug == slug))
    end
  end

  test "get_by_slug returns post" do
    assert %E2e.Blog.Post{title: title} = E2e.Blog.get_by_slug("anatomy-of-a-corex-component")
    assert title =~ "Anatomy"
  end

  test "anatomy post html includes structure terms" do
    post = E2e.Blog.get_by_slug("anatomy-of-a-corex-component", "en")
    assert post.html =~ "accordion_root"
    assert post.html =~ "data-scope"
    assert post.html =~ "compound"
    assert post.html =~ "The ladder"
  end

  test "post html includes highlighted code" do
    post = E2e.Blog.get_by_slug("anatomy-of-a-corex-component")
    assert post.html =~ "accordion_trigger"
    assert post.html =~ "pre"
  end

  test "sitemap_entries include blog permalinks" do
    entries = E2e.Blog.sitemap_entries()
    assert Enum.any?(entries, &String.starts_with?(&1.loc, "/en/blog/"))
    assert Enum.any?(entries, &String.starts_with?(&1.loc, "/ar/blog/"))

    assert Enum.any?(entries, &(&1.loc == "/en/blog/anatomy-of-a-corex-component/"))
    assert Enum.any?(entries, &(&1.loc == "/en/blog/paint-the-parts-the-machine-already-owns/"))
  end

  test "suggested_reads ranks by shared tags then recency" do
    reads = E2e.Blog.suggested_reads("anatomy-of-a-corex-component", "en")
    slugs = Enum.map(reads, & &1.slug)

    assert length(reads) == 4
    refute "anatomy-of-a-corex-component" in slugs
    assert "paint-the-parts-the-machine-already-owns" in slugs
  end

  test "prev_next_post follows list order" do
    %{prev: prev, next: next} =
      E2e.Blog.prev_next_post("the-vanilla-js-machine-that-doesnt-need-a-framework", "en")

    assert %{slug: "two-brains-liveview-assigns-and-zag-machines", label: _} = prev
    assert %{slug: "nine-thousand-airports-one-hundred-rows", label: _} = next

    assert %{prev: %{slug: "how-fast-is-the-checkbox-api-play-tetrex-and-find-out"}, next: _} =
             E2e.Blog.prev_next_post("two-brains-liveview-assigns-and-zag-machines", "en")

    assert %{prev: %{slug: "paint-the-parts-the-machine-already-owns"}, next: nil} =
             E2e.Blog.prev_next_post("anatomy-of-a-corex-component", "en")
  end

  test "markdown renders corex callout fences" do
    md = """
    ```corex-callout note
    Contrast from day one
    Body text for the callout.
    ```
    """

    html = E2eWeb.Markdown.to_html!(md)

    assert html =~ "corex-callout"
    assert html =~ "Contrast from day one"
  end

  test "paint post html includes design system terms" do
    post = E2e.Blog.get_by_slug("paint-the-parts-the-machine-already-owns", "en")
    assert post.html =~ "ui-input"
    assert post.html =~ "Contrast is a number"
  end

  test "list_posts includes arabic articles" do
    posts = E2e.Blog.list_posts("ar")
    assert length(posts) == 6

    for slug <- @en_slugs do
      assert Enum.any?(posts, &(&1.slug == slug))
    end
  end
end
