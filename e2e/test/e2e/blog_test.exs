defmodule E2e.BlogTest do
  use ExUnit.Case, async: true

  test "list_posts includes english articles" do
    posts = E2e.Blog.list_posts("en")
    assert length(posts) == 5

    for slug <- [
          "anatomy-of-a-corex-component",
          "corex-design-a11y",
          "combobox-thousands-of-items",
          "vanilla-js",
          "state-machines"
        ] do
      assert Enum.any?(posts, &(&1.slug == slug))
    end
  end

  test "get_by_slug returns post" do
    assert %E2e.Blog.Post{title: title} = E2e.Blog.get_by_slug("anatomy-of-a-corex-component")
    assert title =~ "Anatomy"
  end

  test "anatomy post html includes structure terms" do
    post = E2e.Blog.get_by_slug("anatomy-of-a-corex-component", "en")
    assert post.html =~ "Corex.Content.new"
    assert post.html =~ "Corex.List.new"
    assert post.html =~ "compound"
    assert post.html =~ "Manual Slots"
  end

  test "post html includes highlighted code" do
    post = E2e.Blog.get_by_slug("anatomy-of-a-corex-component")
    assert post.html =~ "clipboard"
    assert post.html =~ "pre"
  end

  test "sitemap_entries include blog permalinks" do
    entries = E2e.Blog.sitemap_entries()
    assert Enum.any?(entries, &String.starts_with?(&1.loc, "/en/blog/"))
    assert Enum.any?(entries, &String.starts_with?(&1.loc, "/ar/blog/"))

    assert Enum.any?(entries, &(&1.loc == "/en/blog/anatomy-of-a-corex-component/"))
    assert Enum.any?(entries, &(&1.loc == "/en/blog/corex-design-a11y/"))
  end

  test "suggested_reads ranks by shared tags then recency" do
    reads = E2e.Blog.suggested_reads("anatomy-of-a-corex-component", "en")
    slugs = Enum.map(reads, & &1.slug)

    assert length(reads) == 4
    refute "anatomy-of-a-corex-component" in slugs
    assert "corex-design-a11y" in slugs
  end

  test "prev_next_post follows list order" do
    %{prev: prev, next: next} = E2e.Blog.prev_next_post("vanilla-js", "en")

    assert %{slug: "state-machines", label: _} = prev
    assert %{slug: "combobox-thousands-of-items", label: _} = next

    assert %{prev: nil, next: _} = E2e.Blog.prev_next_post("state-machines", "en")

    assert %{prev: %{slug: "corex-design-a11y"}, next: nil} =
             E2e.Blog.prev_next_post("anatomy-of-a-corex-component", "en")
  end

  test "post html includes corex callout when used" do
    post = E2e.Blog.get_by_slug("corex-design-a11y", "en")
    assert post.html =~ "corex-callout"
    assert post.html =~ "Contrast from day one"
  end

  test "list_posts includes arabic articles" do
    posts = E2e.Blog.list_posts("ar")
    assert length(posts) == 5

    for slug <- [
          "anatomy-of-a-corex-component",
          "corex-design-a11y",
          "combobox-thousands-of-items",
          "vanilla-js",
          "state-machines"
        ] do
      assert Enum.any?(posts, &(&1.slug == slug))
    end
  end
end
