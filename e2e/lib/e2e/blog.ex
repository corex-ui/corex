defmodule E2e.Blog do
  @moduledoc false

  alias E2e.Blog.{Loader, Post}

  @posts_root Path.expand("../../_posts", __DIR__)

  @en_paths Path.wildcard(Path.join(@posts_root, "*.md"))
  @ar_paths Path.wildcard(Path.join(@posts_root, "ar/*.md"))

  for path <- @en_paths ++ @ar_paths do
    @external_resource path
  end

  @posts_en @en_paths
            |> Enum.map(&Loader.load/1)
            |> Enum.reject(&is_nil/1)
            |> Enum.sort_by(
              fn
                %Post{date: %DateTime{} = dt} ->
                  DateTime.to_unix(dt)

                %Post{date: %Date{} = d} ->
                  d
                  |> Date.to_erl()
                  |> Tuple.to_list()
                  |> Enum.reduce(0, fn n, acc -> acc * 100 + n end)

                _ ->
                  0
              end,
              :desc
            )

  @posts_ar @ar_paths
            |> Enum.map(&Loader.load/1)
            |> Enum.reject(&is_nil/1)
            |> Enum.sort_by(
              fn
                %Post{date: %DateTime{} = dt} ->
                  DateTime.to_unix(dt)

                %Post{date: %Date{} = d} ->
                  d
                  |> Date.to_erl()
                  |> Tuple.to_list()
                  |> Enum.reduce(0, fn n, acc -> acc * 100 + n end)

                _ ->
                  0
              end,
              :desc
            )

  def posts_dir, do: Application.get_env(:corex_web, :posts_dir, @posts_root)

  def list_posts(locale \\ nil) do
    case locale_id(locale) do
      "ar" -> @posts_ar
      _ -> @posts_en
    end
  end

  def get_by_slug(slug, locale \\ nil) when is_binary(slug) do
    Enum.find(list_posts(locale), &(&1.slug == slug))
  end

  def prev_next_post(slug, locale \\ nil) when is_binary(slug) do
    posts = list_posts(locale)
    index = Enum.find_index(posts, &(&1.slug == slug))

    %{
      prev: post_neighbor(posts, index, :prev),
      next: post_neighbor(posts, index, :next)
    }
  end

  @read_next_limit 4

  def suggested_reads(slug, locale \\ nil, limit \\ @read_next_limit)
      when is_binary(slug) and is_integer(limit) and limit > 0 do
    posts = list_posts(locale)

    case Enum.find(posts, &(&1.slug == slug)) do
      nil ->
        []

      current ->
        tags = Map.get(current, :tags) || []

        posts
        |> Enum.reject(&(&1.slug == slug))
        |> Enum.sort_by(fn post ->
          other_tags = Map.get(post, :tags) || []
          {-tag_overlap(tags, other_tags), -post_date_sort_key(post)}
        end)
        |> Enum.take(limit)
    end
  end

  defp tag_overlap(left, right) do
    MapSet.intersection(MapSet.new(left), MapSet.new(right)) |> MapSet.size()
  end

  defp post_date_sort_key(%Post{date: %DateTime{} = dt}), do: DateTime.to_unix(dt)

  defp post_date_sort_key(%Post{date: %Date{} = d}) do
    d |> Date.to_erl() |> Tuple.to_list() |> Enum.reduce(0, fn n, acc -> acc * 100 + n end)
  end

  defp post_date_sort_key(_), do: 0

  defp post_neighbor(_posts, nil, _direction), do: nil
  defp post_neighbor(_posts, 0, :prev), do: nil

  defp post_neighbor(posts, index, :prev) when index > 0 do
    post = Enum.at(posts, index - 1)
    %{slug: post.slug, label: post.title}
  end

  defp post_neighbor(posts, index, :next) when index >= 0 do
    case Enum.at(posts, index + 1) do
      nil -> nil
      post -> %{slug: post.slug, label: post.title}
    end
  end

  def get_by_permalink(permalink) when is_binary(permalink) do
    normalized = normalize_permalink(permalink)
    Enum.find(@posts_en ++ @posts_ar, &(normalize_permalink(&1.permalink) == normalized))
  end

  def sitemap_entries do
    Enum.map(@posts_en, &post_sitemap_entry/1) ++ Enum.map(@posts_ar, &post_sitemap_entry/1)
  end

  defp post_sitemap_entry(%Post{} = post) do
    %{
      loc: post.permalink,
      lastmod: post_lastmod(post),
      priority: sitemap_priority(post),
      changefreq: sitemap_changefreq(post)
    }
  end

  defp locale_id(nil), do: E2eWeb.Locale.current()
  defp locale_id(locale) when is_atom(locale), do: Atom.to_string(locale)
  defp locale_id(locale) when is_binary(locale), do: locale

  defp normalize_permalink(path) do
    path
    |> String.trim()
    |> then(fn p -> if String.starts_with?(p, "/"), do: p, else: "/" <> p end)
    |> String.trim_trailing("/")
    |> then(fn p -> p <> "/" end)
  end

  defp post_lastmod(%Post{date: %DateTime{} = dt}), do: Calendar.strftime(dt, "%Y-%m-%d")
  defp post_lastmod(%Post{date: %Date{} = d}), do: Calendar.strftime(d, "%Y-%m-%d")
  defp post_lastmod(_), do: nil

  defp sitemap_priority(%Post{sitemap: %{"priority" => p}}) when is_number(p), do: p
  defp sitemap_priority(%Post{sitemap: %{priority: p}}) when is_number(p), do: p
  defp sitemap_priority(_), do: 0.7

  defp sitemap_changefreq(%Post{sitemap: %{"changefreq" => f}}) when is_binary(f), do: f
  defp sitemap_changefreq(%Post{sitemap: %{changefreq: f}}) when is_binary(f), do: f
  defp sitemap_changefreq(_), do: "monthly"
end
