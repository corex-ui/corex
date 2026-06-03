defmodule E2eWeb.Demos.PaginationDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  @anatomy_count 18
  @anatomy_page_size 6
  @count 95
  @page_size 10
  @style_count 50
  @style_page_size 10
  @style_page 3

  def anatomy_minimal_code do
    ~S"""
    <.pagination count={95} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def anatomy_minimal_example(assigns) do
    assigns = anatomy_assigns(assigns)

    ~H"""
    <.pagination id="pagination-anatomy" count={@count} page_size={@page_size}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_semantic_heex do
    ~S"""
    <.pagination  count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--accent" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--brand" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--alert" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--success" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--info" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_semantic_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full items-center">
      <.style_pagination id="pagination-style-color-default" class="pagination" />
      <.style_pagination id="pagination-style-color-accent" class="pagination pagination--accent" />
      <.style_pagination id="pagination-style-color-brand" class="pagination pagination--brand" />
      <.style_pagination id="pagination-style-color-alert" class="pagination pagination--alert" />
      <.style_pagination id="pagination-style-color-success" class="pagination pagination--success" />
      <.style_pagination id="pagination-style-color-info" class="pagination pagination--info" />
    </div>
    """
  end

  def styling_size_heex do
    ~S"""
    <.pagination class="pagination pagination--sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--lg" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_size_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full items-center">
      <.style_pagination id="pagination-style-size-sm" class="pagination pagination--sm" />
      <.style_pagination id="pagination-style-size-md" class="pagination pagination--md" />
      <.style_pagination id="pagination-style-size-lg" class="pagination pagination--lg" />
      <.style_pagination id="pagination-style-size-xl" class="pagination pagination--xl" />
    </div>
    """
  end

  def styling_text_heex do
    ~S"""
    <.pagination class="pagination pagination--text-sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--text-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--text-2xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--text-4xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_text_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full items-center">
      <.style_pagination id="pagination-style-text-sm" class="pagination pagination--text-sm" />
      <.style_pagination id="pagination-style-text-xl" class="pagination pagination--text-xl" />
      <.style_pagination id="pagination-style-text-2xl" class="pagination pagination--text-2xl" />
      <.style_pagination id="pagination-style-text-4xl" class="pagination pagination--text-4xl" />
    </div>
    """
  end

  def styling_radius_heex do
    ~S"""
    <.pagination class="pagination pagination--rounded-none" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--rounded-sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--rounded-md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--rounded-lg" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--rounded-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--rounded-full" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_radius_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full items-center">
      <.style_pagination
        id="pagination-style-radius-none"
        class="pagination pagination--rounded-none"
      />
      <.style_pagination id="pagination-style-radius-sm" class="pagination pagination--rounded-sm" />
      <.style_pagination id="pagination-style-radius-md" class="pagination pagination--rounded-md" />
      <.style_pagination id="pagination-style-radius-lg" class="pagination pagination--rounded-lg" />
      <.style_pagination id="pagination-style-radius-xl" class="pagination pagination--rounded-xl" />
      <.style_pagination
        id="pagination-style-radius-full"
        class="pagination pagination--rounded-full"
      />
    </div>
    """
  end

  def styling_max_width_heex do
    ~S"""
    <.pagination class="pagination pagination--max-w-2xs" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--max-w-md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--max-w-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination class="pagination pagination--max-w-2xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full items-center">
      <.style_pagination id="pagination-style-max-2xs" class="pagination pagination--max-w-2xs" />
      <.style_pagination id="pagination-style-max-md" class="pagination pagination--max-w-md" />
      <.style_pagination id="pagination-style-max-xl" class="pagination pagination--max-w-xl" />
      <.style_pagination id="pagination-style-max-2xl" class="pagination pagination--max-w-2xl" />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :class, :string, required: true
  attr :page, :integer, default: nil
  attr :count, :integer, default: nil
  attr :page_size, :integer, default: nil

  def style_pagination(assigns) do
    assigns =
      assigns
      |> assign(:page, assigns[:page] || @style_page)
      |> assign(:count, assigns[:count] || @style_count)
      |> assign(:page_size, assigns[:page_size] || @style_page_size)

    ~H"""
    <.pagination
      id={@id}
      class={@class}
      count={@count}
      page={@page}
      page_size={@page_size}
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  defp styling_assigns(assigns) do
    assigns
    |> Map.merge(mount_assigns())
    |> Map.put(:count, @style_count)
    |> Map.put(:page_size, @style_page_size)
    |> Map.put(:page, @style_page)
  end

  def api_set_page_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 1)} size="sm">1</.action>
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 5)} size="sm">5</.action>
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 9)} size="sm">9</.action>
    </div>
    <.pagination id="pagination-api-bind"  count={95} page={5} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def api_set_page_client_binding_example(assigns) do
    assigns = Map.merge(mount_assigns(), assigns)

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <.action
          phx-click={Corex.Pagination.set_page("pagination-api-bind", 1)}
          size="sm"
        >
          1
        </.action>
        <.action
          phx-click={Corex.Pagination.set_page("pagination-api-bind", 5)}
          size="sm"
        >
          5
        </.action>
        <.action
          phx-click={Corex.Pagination.set_page("pagination-api-bind", 9)}
          size="sm"
        >
          9
        </.action>
      </div>
      <.pagination
        id="pagination-api-bind"
        count={@count}
        page={5}
        page_size={@page_size}
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </div>
    """
  end

  def api_set_page_server_heex do
    ~S"""
    <.action phx-click="pagination_api_page_3" size="sm">Page 3</.action>
    <.pagination id="pagination-api-srv"  count={95} page={@page} page_size={10} controlled on_page_change="pagination_api_page_changed">
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def api_set_page_server_elixir do
    ~S"""
    def handle_event("pagination_api_page_3", _, socket) do
      {:noreply, Corex.Pagination.set_page(socket, "pagination-api-srv", 3)}
    end

    def handle_event("pagination_api_page_changed", %{"page" => page}, socket) do
      {:noreply, assign(socket, :page, page)}
    end
    """
  end

  def api_set_page_server_example(assigns) do
    assigns =
      mount_assigns()
      |> Map.merge(assigns)
      |> Map.put_new(:page, 1)

    ~H"""
    <div class="flex flex-col gap-4 items-center w-full">
      <.action phx-click="pagination_api_page_3" size="sm">Page 3</.action>
      <.pagination
        id="pagination-api-srv"
        count={@count}
        page={@page}
        page_size={@page_size}
        controlled
        on_page_change="pagination_api_page_changed"
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.pagination  count={95} page_size={10} on_page_change="pagination_page_changed">
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "pagination_page_changed",
      ~S|%{"id" => id, "page" => page} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.pagination
      id="pagination-events-client"
      
      count={95}
      page_size={10}
      on_page_change_client="pagination-page-changed"
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def events_client_js do
    ~S"""
    document.getElementById("pagination-events-client")?.addEventListener("pagination-page-changed", (e) => {
      console.log(e.detail);
    });
    """
  end

  def events_client_ts do
    ~S"""
    type PageDetail = { id: string; page: number; page_size: number };

    document.getElementById("pagination-events-client")?.addEventListener("pagination-page-changed", (e: CustomEvent<PageDetail>) => {
      console.log(e.detail);
    });
    """
  end

  @pattern_page_size 4
  @pattern_count 18

  def pattern_page_size, do: @pattern_page_size
  def pattern_count, do: @pattern_count

  def patterns_controlled_heex do
    ~S"""
    <.pagination
      
      count={18}
      page={@page}
      page_size={4}
      controlled
      on_page_change="pagination_controlled_changed"
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <p class="text-ui-ink-muted text-sm">Current page: {@page}</p>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :page, 1)}
    end

    def handle_event("pagination_controlled_changed", %{"page" => page}, socket) do
      {:noreply, assign(socket, :page, page)}
    end
    """
  end

  def patterns_controlled_example(assigns) do
    assigns =
      pattern_assigns()
      |> Map.merge(assigns)
      |> Map.put_new(:page, 1)

    ~H"""
    <div class="flex flex-col items-center gap-space-lg w-full">
      <.pagination
        id="pagination-patterns-controlled"
        count={@count}
        page={@page}
        page_size={@page_size}
        controlled
        on_page_change="pagination_controlled_changed"
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
      <p class="text-ui-ink-muted text-sm">Current page: {@page}</p>
    </div>
    """
  end

  def patterns_patch_heex do
    ~S"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li :for={post <- @posts} class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border">
        <h3>{post.title}</h3>
        <p class="text-ui-ink-muted text-sm">{post.excerpt}</p>
      </li>
    </ul>

    <.pagination
      
      count={18}
      page={@page}
      page_size={4}
      controlled={:all}
      type={:link}
      to="/pagination/patterns"
      redirect={:patch}
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def patterns_patch_liveview do
    """
    defmodule MyAppWeb.PaginationPatternsLive do
      use MyAppWeb, :live_view

      alias MyApp.Blog

      @page_size 4

      @impl true
      def mount(_params, _session, socket) do
        {:ok,
         socket
         |> assign(:page, 1)
         |> assign(:posts, Blog.slice(1, @page_size))}
      end

      @impl true
      def handle_params(params, _uri, socket) do
        page = param_to_page(params["page"])
        posts = Blog.slice(page, @page_size)

        {:noreply,
         socket
         |> assign(:page, page)
         |> assign(:posts, posts)}
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
    end
    """
  end

  def patterns_patch_data do
    """
    live "/pagination/patterns", MyAppWeb.PaginationPatternsLive

    # Example URL: /en/pagination/patterns?page=2&page_size=4

    #{patterns_blog_data()}
    """
  end

  def patterns_server_heex do
    ~S"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li :for={post <- @posts} class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border">
        <h3>{post.title}</h3>
        <p class="text-ui-ink-muted text-sm">{post.excerpt}</p>
      </li>
    </ul>

    <.pagination
      
      count={18}
      page={@page}
      page_size={4}
      controlled
      on_page_change="patterns_server_page"
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def patterns_server_liveview do
    """
    defmodule MyAppWeb.PaginationPatternsLive do
      use MyAppWeb, :live_view

      alias MyApp.Blog

      @page_size 4

      @impl true
      def mount(_params, _session, socket) do
        {:ok,
         socket
         |> assign(:page, 1)
         |> assign(:posts, Blog.slice(1, @page_size))}
      end

      @impl true
      def handle_event("patterns_server_page", %{"page" => page}, socket) do
        page = parse_page(page)

        {:noreply,
         socket
         |> assign(:page, page)
         |> assign(:posts, Blog.slice(page, @page_size))}
      end

      defp parse_page(page) when is_integer(page) and page > 0, do: page

      defp parse_page(page) when is_binary(page) do
        case Integer.parse(page) do
          {n, _} when n > 0 -> n
          _ -> 1
        end
      end

      defp parse_page(_), do: 1
    end
    """
  end

  def patterns_client_heex do
    ~S"""
    <div
      id="pagination-patterns-client-wrap"
      phx-hook=".PaginationPatternsClient"
      phx-update="ignore"
      data-pagination-id="pagination-patterns-client"
      data-pages={@pages_json}
    >
      <script :type={Phoenix.LiveView.ColocatedHook} name=".PaginationPatternsClient">
        export default {
          mounted() {
            const pages = JSON.parse(this.el.dataset.pages);
            const list = document.getElementById("pagination-patterns-client-list");
            const pagination = document.getElementById(this.el.dataset.paginationId);

            const render = (page) => {
              list.replaceChildren(
                ...(pages[page - 1] ?? []).map((post) => {
                  const li = document.createElement("li");
                  li.className =
                    "flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border";
                  const title = document.createElement("h3");
                  title.textContent = post.title;
                  const excerpt = document.createElement("p");
                  excerpt.className = "text-ui-ink-muted text-sm";
                  excerpt.textContent = post.excerpt;
                  li.append(title, excerpt);
                  return li;
                })
              );
            };

            pagination?.addEventListener("pagination-page-changed", (e) => {
              render(e.detail.page);
            });
          },
        };
      </script>

      <ul id="pagination-patterns-client-list" class="flex flex-col gap-space w-full max-w-md">
        <li
          :for={post <- @posts}
          class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border"
        >
          <h3>{post.title}</h3>
          <p class="text-ui-ink-muted text-sm">{post.excerpt}</p>
        </li>
      </ul>
    </div>

    <.pagination
      id="pagination-patterns-client"
      
      count={18}
      page_size={4}
      on_page_change_client="pagination-page-changed"
    >
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def patterns_client_liveview do
    """
    defmodule MyAppWeb.PaginationPatternsLive do
      use MyAppWeb, :live_view

      alias MyApp.Blog

      @page_size 4

      @impl true
      def mount(_params, _session, socket) do
        {:ok,
         socket
         |> assign(:posts, Blog.slice(1, @page_size))
         |> assign(:pages_json, pages_json(@page_size))}
      end

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
    end
    """
  end

  def patterns_blog_data do
    posts_lines =
      Enum.map_join(E2e.PaginationPlayBlog.posts(), ",\n", fn %{title: title, excerpt: excerpt} ->
        "    %{title: #{inspect(title)}, excerpt: #{inspect(excerpt)}}"
      end)

    """
    defmodule MyApp.Blog do
      @posts [
    #{posts_lines}
      ]

      def posts, do: @posts

      def count, do: length(@posts)

      def slice(page, page_size) do
        offset = max(page - 1, 0) * page_size
        Enum.slice(@posts, offset, page_size)
      end
    end
    """
  end

  def patterns_controlled_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_controlled_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_controlled_elixir()}
    ]
  end

  def patterns_patch_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_patch_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_patch_liveview()},
      %{value: "data", label: "Data", language: :elixir, code: patterns_patch_data()}
    ]
  end

  def patterns_server_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_server_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_server_liveview()},
      %{value: "data", label: "Data", language: :elixir, code: patterns_blog_data()}
    ]
  end

  def patterns_client_code_tabs do
    [
      %{value: "heex", label: "Heex", language: :heex, code: patterns_client_heex()},
      %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_client_liveview()},
      %{value: "data", label: "Data", language: :elixir, code: patterns_blog_data()}
    ]
  end

  attr :posts, :list, required: true

  def patterns_posts_list(assigns) do
    ~H"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li
        :for={post <- @posts}
        class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border"
      >
        <h3>{post.title}</h3>
        <p class="text-ui-ink-muted text-sm">{post.excerpt}</p>
      </li>
    </ul>
    """
  end

  def patterns_patch_example(assigns) do
    assigns = Map.merge(pattern_assigns(), assigns)

    ~H"""
    <div class="flex flex-col items-center gap-space-lg w-full">
      <.patterns_posts_list posts={@posts} />
      <.pagination
        id="pagination-patterns-patch"
        count={@count}
        page={@page}
        page_size={@page_size}
        controlled={:all}
        type={:link}
        to={~p"/pagination/patterns"}
        redirect={:patch}
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </div>
    """
  end

  def patterns_server_example(assigns) do
    assigns = Map.merge(pattern_assigns(), assigns)

    ~H"""
    <div class="flex flex-col items-center gap-space-lg w-full">
      <.patterns_posts_list posts={@posts} />
      <.pagination
        id="pagination-patterns-server"
        count={@count}
        page={@page}
        page_size={@page_size}
        controlled
        on_page_change="patterns_server_page"
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </div>
    """
  end

  def patterns_client_example(assigns) do
    assigns = Map.merge(pattern_assigns(), assigns)

    ~H"""
    <div class="flex flex-col items-center gap-space-lg w-full">
      <div
        id="pagination-patterns-client-wrap"
        phx-hook=".PaginationPatternsClient"
        phx-update="ignore"
        data-pagination-id="pagination-patterns-client"
        data-pages={@pages_json}
      >
        <script :type={Phoenix.LiveView.ColocatedHook} name=".PaginationPatternsClient">
          export default {
            mounted() {
              const pages = JSON.parse(this.el.dataset.pages);
              const list = document.getElementById("pagination-patterns-client-list");
              const pagination = document.getElementById(this.el.dataset.paginationId);

              const render = (page) => {
                list.replaceChildren(
                  ...(pages[page - 1] ?? []).map((post) => {
                    const li = document.createElement("li");
                    li.className =
                      "flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border";
                    const title = document.createElement("h3");
                    title.textContent = post.title;
                    const excerpt = document.createElement("p");
                    excerpt.className = "text-ui-ink-muted text-sm";
                    excerpt.textContent = post.excerpt;
                    li.append(title, excerpt);
                    return li;
                  })
                );
              };

              pagination?.addEventListener("pagination-page-changed", (e) => {
                render(e.detail.page);
              });
            },
          };
        </script>

        <ul id="pagination-patterns-client-list" class="flex flex-col gap-space w-full max-w-md">
          <li
            :for={post <- @posts}
            class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border"
          >
            <h3>{post.title}</h3>
            <p class="text-ui-ink-muted text-sm">{post.excerpt}</p>
          </li>
        </ul>
      </div>

      <.pagination
        id="pagination-patterns-client"
        count={@count}
        page_size={@page_size}
        on_page_change_client="pagination-page-changed"
      >
        <:prev><.heroicon name="hero-chevron-left" /></:prev>
        <:next><.heroicon name="hero-chevron-right" /></:next>
        <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
      </.pagination>
    </div>
    """
  end

  defp pattern_assigns do
    %{count: @pattern_count, page_size: @pattern_page_size}
  end

  defp anatomy_assigns(assigns) do
    assigns
    |> Map.merge(mount_assigns())
    |> Map.put(:count, @anatomy_count)
    |> Map.put(:page_size, @anatomy_page_size)
  end

  def mount_assigns do
    Map.merge(E2eWeb.Demos.DocExamples.pagination_defaults(), %{
      count: @count,
      page_size: @page_size
    })
  end
end
