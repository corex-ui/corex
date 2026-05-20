defmodule E2eWeb.PaginationPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias E2e.PaginationPlayBlog, as: Blog

  @default_page_size 5
  @load_ms 500

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:controls, %{dir: "ltr"})
     |> assign(:sibling_count, 1)
     |> assign(:boundary_count, 1)
     |> assign(:post_count, Blog.count())}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page_size = parse_int(params["page_size"], @default_page_size, 1, 10)
    total_pages = total_pages(socket.assigns.post_count, page_size)
    page = parse_int(params["page"], 1, 1, max(total_pages, 1))

    socket =
      socket
      |> assign(:page, page)
      |> assign(:page_size, page_size)
      |> assign(:total_pages, total_pages)
      |> assign_async(:blog_page, fn ->
        Process.sleep(@load_ms)

        {:ok,
         %{
           blog_page: %{
             posts: Blog.slice(page, page_size)
           }
         }}
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "dir"}, socket)
      when value in ["ltr", "rtl"] do
    {:noreply, update(socket, :controls, &%{&1 | dir: value})}
  end

  @impl true
  def handle_event("control_changed", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("page_size_changed", %{"value" => value}, socket) do
    page_size = parse_int(value, socket.assigns.page_size, 1, 10)

    {:noreply,
     push_patch(socket,
       to: ~p"/pagination/playground?#{%{page: 1, page_size: page_size}}"
     )}
  end

  @impl true
  def handle_event("sibling_count_changed", %{"value" => value}, socket) do
    sibling_count = parse_int(value, socket.assigns.sibling_count, 0, 3)
    {:noreply, assign(socket, :sibling_count, sibling_count)}
  end

  @impl true
  def handle_event("boundary_count_changed", %{"value" => value}, socket) do
    boundary_count = parse_int(value, socket.assigns.boundary_count, 0, 3)
    {:noreply, assign(socket, :boundary_count, boundary_count)}
  end

  defp total_pages(count, page_size) do
    count = max(count, 0)
    page_size = max(page_size, 1)

    if count == 0, do: 0, else: div(count + page_size - 1, page_size)
  end

  defp parse_int(raw, fallback, min, max) do
    case Integer.parse(to_string(raw || "")) do
      {n, _} -> min(max(n, min), max)
      _ -> min(max(fallback, min), max)
    end
  end

  attr :count, :integer, required: true

  defp blog_placeholders(assigns) do
    ~H"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li
        :for={_ <- 1..@count}
        class="h-16 rounded-md border border-dashed border-border bg-layer"
      />
    </ul>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_playground
        id="pagination-playground-page"
        title="Pagination · Playground"
        subtitle="Blog list loads per URL (?page, ?page_size). Pagination uses link mode with LiveView patch."
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.number_input
            id="pagination-playground-page-size"
            class="number-input number-input--sm w-4xs"
            value={to_string(@page_size)}
            step={1.0}
            min={1.0}
            max={10.0}
            on_value_change="page_size_changed"
          >
            <:label>Page size</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="pagination-playground-sibling"
            class="number-input number-input--sm w-4xs"
            value={to_string(@sibling_count)}
            step={1.0}
            min={0.0}
            max={3.0}
            on_value_change="sibling_count_changed"
          >
            <:label>Sibling count</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>

          <.number_input
            id="pagination-playground-boundary"
            class="number-input number-input--sm w-4xs"
            value={to_string(@boundary_count)}
            step={1.0}
            min={0.0}
            max={3.0}
            on_value_change="boundary_count_changed"
          >
            <:label>Boundary count</:label>
            <:decrement_trigger>
              <.heroicon name="hero-chevron-down" class="icon" />
            </:decrement_trigger>
            <:increment_trigger>
              <.heroicon name="hero-chevron-up" class="icon" />
            </:increment_trigger>
          </.number_input>
        </:controls>
        <:canvas>
          <div
            id="pagination-playground-canvas"
            class="flex flex-col items-center gap-space-lg w-full max-w-md"
            dir={@controls.dir}
          >
            <div class="w-full flex flex-col gap-space-xs">
              <h2 class="text-lg font-medium">Blog posts</h2>
              <p class="text-ink-muted text-sm">
                Page {@page} of {@total_pages} · {@post_count} posts
              </p>
            </div>

            <.async_result :let={blog} assign={@blog_page}>
              <:loading>
                <.blog_placeholders count={@page_size} />
              </:loading>

              <ul class="flex flex-col gap-space w-full">
                <li
                  :for={post <- blog.posts}
                  class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border"
                >
                  <h3>{post.title}</h3>
                  <p class="text-ink-muted text-sm">{post.excerpt}</p>
                </li>
              </ul>
            </.async_result>

            <.pagination
              id="pagination-playground"
              class="pagination"
              count={@post_count}
              page={@page}
              page_size={@page_size}
              sibling_count={@sibling_count}
              boundary_count={@boundary_count}
              dir={@controls.dir}
              controlled={:all}
              type={:link}
              to={~p"/pagination/playground"}
              redirect={:patch}
            >
              <:prev><.heroicon name="hero-chevron-left" /></:prev>
              <:next><.heroicon name="hero-chevron-right" /></:next>
              <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
            </.pagination>
          </div>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
