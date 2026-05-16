defmodule E2eWeb.PaginationPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2e.PaginationPlayBlog, as: Blog
  alias E2eWeb.Demos.PaginationDemo, as: Demo

  @page_size Demo.pattern_page_size()

  @impl true
  def mount(_params, _session, socket) do
    page_size = @page_size

    {:ok,
     socket
     |> assign(:page, 1)
     |> assign(:page_size, page_size)
     |> assign(:post_count, Blog.count())
     |> assign(:server_page, 1)
     |> assign(:server_posts, Blog.slice(1, page_size))
     |> assign(:client_posts, Blog.slice(1, page_size))
     |> assign(:client_pages_json, pages_json(page_size))
     |> assign(:controlled_heex, Demo.patterns_controlled_heex())
     |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())
     |> assign(:patch_heex, Demo.patterns_patch_heex())
     |> assign(:patch_elixir, Demo.patterns_patch_elixir())
     |> assign(:patch_data, Demo.patterns_patch_data())
     |> assign(:server_heex, Demo.patterns_server_heex())
     |> assign(:server_elixir, Demo.patterns_server_elixir())
     |> assign(:client_heex, Demo.patterns_client_heex())
     |> assign(:client_js, Demo.patterns_client_js())}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = param_to_page(params["page"])
    posts = Blog.slice(page, socket.assigns.page_size)

    {:noreply,
     socket
     |> assign(:patch_page, page)
     |> assign(:patch_posts, posts)}
  end

  @impl true
  def handle_event("pagination_controlled_changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, parse_page(page))}
  end

  @impl true
  def handle_event("patterns_server_page", %{"page" => page}, socket) do
    page = parse_page(page)
    page_size = socket.assigns.page_size

    {:noreply,
     socket
     |> assign(:server_page, page)
     |> assign(:server_posts, Blog.slice(page, page_size))}
  end

  defp param_to_page(nil), do: 1

  defp param_to_page(raw) when is_binary(raw) do
    case Integer.parse(raw) do
      {n, _} when n > 0 -> n
      _ -> 1
    end
  end

  defp param_to_page(n) when is_integer(n) and n > 0, do: n
  defp param_to_page(_), do: 1

  defp parse_page(page) when is_integer(page), do: page

  defp parse_page(page) when is_binary(page) do
    case Integer.parse(page) do
      {n, _} when n > 0 -> n
      _ -> 1
    end
  end

  defp parse_page(_), do: 1

  defp pages_json(page_size) do
    total_pages =
      Blog.count()
      |> then(fn count ->
        if count == 0, do: 0, else: div(count + page_size - 1, page_size)
      end)

    1..max(total_pages, 1)
    |> Enum.map(fn page ->
      Blog.slice(page, page_size)
      |> Enum.map(&Map.take(&1, [:title, :excerpt]))
    end)
    |> Jason.encode!()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="pagination-patterns-page"
        title="Pagination · Patterns"
        subtitle="Controlled page, link patch, server events, and client-only updates."
      >
        <.demo_section
          id="pagination-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <Demo.patterns_controlled_example page={@page} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="pagination-patterns-patch-section"
          title="Link patch"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @patch_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @patch_elixir},
            %{value: "data", label: "Data", language: :elixir, code: @patch_data}
          ]}
        >
          <:preview>
            <Demo.patterns_patch_example
              page={@patch_page}
              posts={@patch_posts}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="pagination-patterns-server-section"
          title="Trigger server"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <Demo.patterns_server_example
              page={@server_page}
              posts={@server_posts}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="pagination-patterns-client-section"
          title="Trigger client"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js}
          ]}
        >
          <:preview>
            <Demo.patterns_client_example
              posts={@client_posts}
              pages_json={@client_pages_json}
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
