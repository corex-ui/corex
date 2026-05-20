defmodule E2e.Blog.Loader do
  @moduledoc false

  alias E2e.Blog.Post
  alias E2eWeb.Markdown

  @front_matter_re ~r/\A---\r?\n(.*?)\r?\n---\r?\n([\s\S]*)\z/s

  def load(path) when is_binary(path) do
    content = File.read!(path)

    case Regex.run(@front_matter_re, content) do
      [_, fm, body] ->
        meta = parse_front_matter(fm)
        permalink = meta["permalink"]
        slug = slug_from_permalink(permalink) || slug_from_filename(path)
        permalink = permalink || "/blog/#{slug}/"

        %Post{
          slug: slug,
          title: meta["title"] || "Untitled",
          description: meta["description"],
          permalink: permalink,
          date: parse_date(meta["date"]),
          tags: normalize_tags(meta["tags"]),
          html: Markdown.to_html!(String.trim(body)),
          sitemap: normalize_sitemap(meta["sitemap"]),
          file: path
        }

      _ ->
        nil
    end
  end

  defp parse_front_matter(fm) do
    case YamlElixir.read_from_string(fm) do
      {:ok, map} when is_map(map) -> string_key_map(map)
      _ -> %{}
    end
  end

  defp string_key_map(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} when is_binary(key) -> {key, value}
    end)
  end

  defp slug_from_permalink(nil), do: nil

  defp slug_from_permalink(permalink) when is_binary(permalink) do
    permalink
    |> String.trim_trailing("/")
    |> Path.basename()
    |> case do
      "" -> nil
      slug -> slug
    end
  end

  defp slug_from_filename(path) do
    path
    |> Path.basename(".md")
    |> String.replace(~r/^\d{4}-\d{2}-\d{2}-/, "")
  end

  defp parse_date(nil), do: nil
  defp parse_date(%DateTime{} = dt), do: dt
  defp parse_date(%NaiveDateTime{} = ndt), do: DateTime.from_naive!(ndt, "Etc/UTC")

  defp parse_date(%Date{} = d) do
    DateTime.new!(d, ~T[00:00:00], "Etc/UTC")
  end

  defp parse_date(s) when is_binary(s) do
    s = String.trim(s)

    case DateTime.from_iso8601(s) do
      {:ok, dt, _} ->
        dt

      _ ->
        case NaiveDateTime.from_iso8601(s) do
          {:ok, ndt} -> DateTime.from_naive!(ndt, "Etc/UTC")
          _ -> parse_date_prefix(s)
        end
    end
  end

  defp parse_date_prefix(s) do
    case Date.from_iso8601(String.slice(s, 0, 10)) do
      {:ok, d} -> DateTime.new!(d, ~T[00:00:00], "Etc/UTC")
      _ -> nil
    end
  end

  defp normalize_tags(nil), do: []
  defp normalize_tags(tags) when is_list(tags), do: tags
  defp normalize_tags(_), do: []

  defp normalize_sitemap(nil), do: %{}
  defp normalize_sitemap(map) when is_map(map), do: map
  defp normalize_sitemap(_), do: %{}
end
