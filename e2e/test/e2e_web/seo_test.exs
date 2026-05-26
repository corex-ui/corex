defmodule E2eWeb.SEOTest do
  use ExUnit.Case, async: true

  test "home seo has hreflang" do
    seo = E2eWeb.SEO.home()
    assert seo.hreflang_paths == %{en: "/", ar: "/ar"}
    assert E2eWeb.SEO.document_title(seo) =~ "Corex"
  end

  test "for_post uses permalink" do
    post = %E2e.Blog.Post{
      slug: "demo",
      title: "Demo",
      description: "Desc",
      permalink: "/blog/demo/",
      html: "",
      file: "x.md"
    }

    seo = E2eWeb.SEO.for_post(post)
    assert seo.canonical_path == "/blog/demo/"
    assert E2eWeb.SEO.meta_description(seo) == "Desc"
  end
end
