defmodule E2eWeb.SEO do
  @moduledoc false

  use Phoenix.Component

  @default_description "Accessible and unstyled UI components library written in Elixir and TypeScript that integrates Zag.js state machines into the Phoenix Framework"
  @default_keywords "User Interface, Accessibility, Vanilla JS, Corex, ZagJS, Elixir, Phoenix Framework, Live View"
  @suffix " · Elixir Phoenix Framework UI Library"
  @og_image_path "/corex-ui-og.jpg"

  @figtree_stylesheet_href "https://fonts.googleapis.com/css2?family=Figtree:ital,wght@0,300..900;1,300..900&display=optional"

  defstruct [
    :title,
    :description,
    :canonical_path,
    :og_image_path,
    hreflang_paths: nil
  ]

  def base_url do
    Application.get_env(:corex_web, :public_base_url) ||
      E2eWeb.Endpoint.url() |> String.trim_trailing("/")
  end

  def feed_url, do: base_url() <> "/feed.xml"

  def default_description, do: @default_description

  def default_from_conn(conn) do
    path = conn.request_path

    new(
      title: conn.assigns[:page_title],
      canonical_path: path,
      description: doc_description(path)
    )
  end

  def home do
    new(
      title: "Corex",
      description:
        "Unstyled, accessible Phoenix components with a full server-and-client API, powered by Zag.js state machines.",
      canonical_path: "/",
      hreflang_paths: %{en: "/", ar: "/ar"}
    )
  end

  def blog_index do
    new(
      title: "Blog",
      description: "Articles about Corex, Phoenix LiveView, accessibility, and UI development.",
      canonical_path: blog_index_path(),
      hreflang_paths: %{en: "/en/blog", ar: "/ar/blog"}
    )
  end

  defp blog_index_path do
    case E2eWeb.Locale.current() do
      "ar" -> "/ar/blog"
      _ -> "/en/blog"
    end
  end

  def for_post(%E2e.Blog.Post{} = post) do
    new(
      title: post.title,
      description: post.description || @default_description,
      canonical_path: post.permalink
    )
  end

  def showcases do
    new(
      title: "Showcase",
      description: "Production-ready starters and interactive demos built with Corex components.",
      canonical_path: "/en/showcases",
      hreflang_paths: %{en: "/en/showcases", ar: "/ar/showcases"}
    )
  end

  def templates, do: showcases()

  def new(opts) when is_list(opts), do: struct!(__MODULE__, opts)

  def new(opts) when is_map(opts), do: struct!(__MODULE__, Map.to_list(opts))

  def document_title(%__MODULE__{title: title}) when is_binary(title) and title != "" do
    title <> @suffix
  end

  def document_title(_), do: "Corex" <> @suffix

  def page_title(%__MODULE__{title: title}) when is_binary(title) and title != "", do: title
  def page_title(_), do: nil

  def meta_description(%__MODULE__{description: d}) when is_binary(d) and d != "", do: d
  def meta_description(_), do: @default_description

  def canonical_url(%__MODULE__{} = seo) do
    base_url() <> normalize_path(seo.canonical_path || "/")
  end

  def og_image_url(%__MODULE__{} = seo) do
    base_url() <> (seo.og_image_path || @og_image_path)
  end

  def og_title(%__MODULE__{} = seo), do: document_title(seo)

  attr :seo, :map, required: true
  attr :page_title, :string, default: nil

  def head(assigns) do
    seo = resolve_seo(assigns.seo, assigns.page_title)

    assigns =
      assigns
      |> assign(:seo, seo)
      |> assign(:suffix, @suffix)
      |> assign(:default_keywords, @default_keywords)
      |> assign(:figtree_stylesheet_href, @figtree_stylesheet_href)

    ~H"""
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
    <link rel="preload" as="style" href={@figtree_stylesheet_href} />
    <link
      rel="stylesheet"
      href={@figtree_stylesheet_href}
    />
    <.live_title default="Corex" suffix={@suffix}>
      {page_title(@seo)}
    </.live_title>

    <meta name="description" content={meta_description(@seo)} />
    <meta name="author" content="Netoum" />
    <meta name="keywords" content={@default_keywords} />
    <meta name="theme-color" content="#F5F7FA" />
    <link rel="canonical" href={canonical_url(@seo)} />
    <link
      rel="alternate"
      type="application/rss+xml"
      title="Corex Blog"
      href={feed_url()}
    />
    <%= for {locale, path} <- hreflang_entries(@seo) do %>
      <link rel="alternate" hreflang={locale} href={base_url() <> normalize_path(path)} />
    <% end %>
    <meta property="og:type" content="website" />
    <meta property="og:url" content={canonical_url(@seo)} />
    <meta property="og:title" content={og_title(@seo)} />
    <meta property="og:description" content={meta_description(@seo)} />
    <meta property="og:image" content={og_image_url(@seo)} />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={og_title(@seo)} />
    <meta name="twitter:description" content={meta_description(@seo)} />
    <meta name="twitter:image" content={og_image_url(@seo)} />
    """
  end

  defp resolve_seo(%__MODULE__{} = seo, page_title) do
    if is_binary(page_title) and page_title != "" and (seo.title == nil or seo.title == "") do
      %{seo | title: page_title}
    else
      seo
    end
  end

  defp resolve_seo(nil, page_title) do
    new(%{title: page_title, canonical_path: "/"})
  end

  defp resolve_seo(_other, page_title) do
    resolve_seo(new(title: page_title, canonical_path: "/"), page_title)
  end

  defp hreflang_entries(%__MODULE__{hreflang_paths: paths})
       when is_map(paths) and map_size(paths) > 0 do
    paths
  end

  defp hreflang_entries(_), do: []

  defp doc_description(path) when is_binary(path) do
    cond do
      String.starts_with?(path, "/blog") ->
        "Articles about Corex, Phoenix LiveView, accessibility, and UI development."

      path in ["/showcases", "/en/showcases", "/ar/showcases"] ->
        showcases().description

      String.starts_with?(path, "/showcases/") ->
        showcases().description

      true ->
        @default_description
    end
  end

  defp doc_description(_), do: @default_description

  defp normalize_path("/"), do: "/"

  defp normalize_path(path) when is_binary(path),
    do: if(String.starts_with?(path, "/"), do: path, else: "/" <> path)
end
