defmodule Mix.Tasks.E2e.Gen.Post do
  use Mix.Task

  @shortdoc "Generate a new blog post under _posts/"
  @moduledoc """
  #{@shortdoc}

  See `_posts/README.md` for front matter, callouts, and markdown conventions.
  """

  @switches [permalink: :string, locale: :string]

  def run(argv) do
    {opts, argv, _} = OptionParser.parse(argv, switches: @switches)

    if argv == [] do
      Mix.raise("Missing argument: post title or slug")
    end

    title = Enum.join(argv, " ")
    post_date = Date.utc_today()

    slug =
      title
      |> String.replace(" ", "-")
      |> String.replace("_", "-")
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9-]/, "")

    locale = opts[:locale] || "en"
    locale_prefix = if locale == "ar", do: "ar", else: "en"

    permalink = opts[:permalink] || "/#{locale_prefix}/blog/#{slug}/"

    posts_dir =
      if locale == "ar" do
        "_posts/ar"
      else
        "_posts"
      end

    file_path = Path.expand("#{posts_dir}/#{post_date}-#{slug}.md", Mix.Project.project_file())

    if File.exists?(file_path) do
      Mix.raise("File already exists: #{file_path}")
    end

    File.mkdir_p!(Path.dirname(file_path))

    content = """
    ---
    title: "#{title}"
    description: ""
    date: #{post_date} 12:00:00 +0000
    permalink: #{permalink}
    tags: []
    sitemap:
      priority: 0.7
      changefreq: monthly
    ---

    Write your post here.

    ```elixir
    defmodule Example do
      def hello, do: :world
    end
    ```
    """

    File.write!(file_path, content)
    Mix.shell().info("Created #{file_path}")
    Mix.shell().info("Recompile or restart the server to load the new post.")
  end
end
