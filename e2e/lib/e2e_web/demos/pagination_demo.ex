defmodule E2eWeb.Demos.PaginationDemo do
  use E2eWeb, :html

  @count 95
  @page_size 10
  @style_count 50
  @style_page_size 10
  @style_page 3

  def anatomy_minimal_code do
    ~S"""
    <.pagination id="pagination-anatomy" class="pagination" count={95} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def anatomy_minimal_example(assigns) do
    assigns = Map.merge(mount_assigns(), assigns)

    ~H"""
    <.pagination id="pagination-anatomy" class="pagination" count={@count} page_size={@page_size}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_color_heex do
    ~S"""
    <.pagination id="pagination-style-color-default" class="pagination" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-color-accent" class="pagination pagination--accent" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-color-brand" class="pagination pagination--brand" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-color-alert" class="pagination pagination--alert" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-color-success" class="pagination pagination--success" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-color-info" class="pagination pagination--info" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_color_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
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
    <.pagination id="pagination-style-size-sm" class="pagination pagination--sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-size-md" class="pagination pagination--md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-size-lg" class="pagination pagination--lg" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-size-xl" class="pagination pagination--xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_size_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.style_pagination id="pagination-style-size-sm" class="pagination pagination--sm" />
      <.style_pagination id="pagination-style-size-md" class="pagination pagination--md" />
      <.style_pagination id="pagination-style-size-lg" class="pagination pagination--lg" />
      <.style_pagination id="pagination-style-size-xl" class="pagination pagination--xl" />
    </div>
    """
  end

  def styling_text_heex do
    ~S"""
    <.pagination id="pagination-style-text-sm" class="pagination pagination--text-sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-text-xl" class="pagination pagination--text-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-text-2xl" class="pagination pagination--text-2xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-text-4xl" class="pagination pagination--text-4xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_text_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.style_pagination id="pagination-style-text-sm" class="pagination pagination--text-sm" />
      <.style_pagination id="pagination-style-text-xl" class="pagination pagination--text-xl" />
      <.style_pagination id="pagination-style-text-2xl" class="pagination pagination--text-2xl" />
      <.style_pagination id="pagination-style-text-4xl" class="pagination pagination--text-4xl" />
    </div>
    """
  end

  def styling_radius_heex do
    ~S"""
    <.pagination id="pagination-style-radius-none" class="pagination pagination--rounded-none" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-radius-sm" class="pagination pagination--rounded-sm" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-radius-md" class="pagination pagination--rounded-md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-radius-lg" class="pagination pagination--rounded-lg" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-radius-xl" class="pagination pagination--rounded-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-radius-full" class="pagination pagination--rounded-full" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_radius_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
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
    <.pagination id="pagination-style-max-2xs" class="pagination max-w-2xs" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-max-md" class="pagination max-w-md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-max-xl" class="pagination max-w-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-max-2xl" class="pagination max-w-2xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.style_pagination id="pagination-style-max-2xs" class="pagination max-w-2xs" />
      <.style_pagination id="pagination-style-max-md" class="pagination max-w-md" />
      <.style_pagination id="pagination-style-max-xl" class="pagination max-w-xl" />
      <.style_pagination id="pagination-style-max-2xl" class="pagination max-w-2xl" />
    </div>
    """
  end

  def styling_mix_modifiers_heex do
    ~S"""
    <.pagination id="pagination-style-mix-1" class="pagination pagination--sm pagination--brand max-w-2xs" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-mix-2" class="pagination pagination--accent pagination--rounded-xl max-w-md" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    <.pagination id="pagination-style-mix-3" class="pagination pagination--alert pagination--lg pagination--text-xl max-w-xl" count={50} page={3} page_size={10}>
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def styling_mix_modifiers_example(assigns) do
    assigns = styling_assigns(assigns)

    ~H"""
    <div class="flex flex-col gap-space-lg w-full">
      <.style_pagination
        id="pagination-style-mix-1"
        class="pagination pagination--sm pagination--brand max-w-2xs"
      />
      <.style_pagination
        id="pagination-style-mix-2"
        class="pagination pagination--accent pagination--rounded-xl max-w-md"
      />
      <.style_pagination
        id="pagination-style-mix-3"
        class="pagination pagination--alert pagination--lg pagination--text-xl max-w-xl"
      />
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
      |> assign_new(:page, fn -> @style_page end)
      |> assign_new(:count, fn -> @style_count end)
      |> assign_new(:page_size, fn -> @style_page_size end)

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
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 1)} class="button button--sm">1</.action>
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 5)} class="button button--sm">5</.action>
      <.action phx-click={Corex.Pagination.set_page("pagination-api-bind", 9)} class="button button--sm">9</.action>
    </div>
    <.pagination id="pagination-api-bind" class="pagination" count={95} page={5} page_size={10}>
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
          class="button button--sm"
        >
          1
        </.action>
        <.action
          phx-click={Corex.Pagination.set_page("pagination-api-bind", 5)}
          class="button button--sm"
        >
          5
        </.action>
        <.action
          phx-click={Corex.Pagination.set_page("pagination-api-bind", 9)}
          class="button button--sm"
        >
          9
        </.action>
      </div>
      <.pagination
        id="pagination-api-bind"
        class="pagination"
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
    <.action phx-click="pagination_api_page_3" class="button button--sm">Page 3</.action>
    <.pagination id="pagination-api-srv" class="pagination" count={95} page={@page} page_size={10} controlled on_page_change="pagination_api_page_changed">
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
      <.action phx-click="pagination_api_page_3" class="button button--sm">Page 3</.action>
      <.pagination
        id="pagination-api-srv"
        class="pagination"
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
    <.pagination id="pagination-events-server" class="pagination" count={95} page_size={10} on_page_change="pagination_page_changed">
      <:prev><.heroicon name="hero-chevron-left" /></:prev>
      <:next><.heroicon name="hero-chevron-right" /></:next>
      <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
    </.pagination>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("pagination_page_changed", %{"id" => id, "page" => page}, socket) do
      {:noreply, socket}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.pagination
      id="pagination-events-client"
      class="pagination"
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
      id="pagination-patterns-controlled"
      class="pagination"
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
    <p class="text-ink-muted text-sm">Current page: {@page}</p>
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
        class="pagination"
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
      <p class="text-ink-muted text-sm">Current page: {@page}</p>
    </div>
    """
  end

  def patterns_patch_heex do
    ~S"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li :for={post <- @posts} class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border">
        <h3>{post.title}</h3>
        <p class="text-ink-muted text-sm">{post.excerpt}</p>
      </li>
    </ul>

    <.pagination
      id="pagination-patterns-patch"
      class="pagination"
      count={18}
      page={@page}
      page_size={4}
      controlled
      controlled_page_size
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

  def patterns_patch_elixir do
    ~S"""
    @page_size 4

    def handle_params(params, _uri, socket) do
      page = param_to_page(params["page"])
      posts = MyApp.Blog.slice(page, @page_size)

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
    """
  end

  def patterns_patch_data do
    posts_lines =
      E2e.PaginationPlayBlog.posts()
      |> Enum.map(fn %{title: title, excerpt: excerpt} ->
        "    %{title: #{inspect(title)}, excerpt: #{inspect(excerpt)}}"
      end)
      |> Enum.join(",\n")

    """
    http://localhost:4000/en/pagination/patterns?page=1&page_size=4

    live "/pagination/patterns", MyAppWeb.PaginationPatternsLive

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

  def patterns_server_heex do
    ~S"""
    <ul class="flex flex-col gap-space w-full max-w-md">
      <li :for={post <- @posts} class="flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border">
        <h3>{post.title}</h3>
        <p class="text-ink-muted text-sm">{post.excerpt}</p>
      </li>
    </ul>

    <.pagination
      id="pagination-patterns-server"
      class="pagination"
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

  def patterns_server_elixir do
    ~S"""
    @page_size 4

    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign(:page, 1)
       |> assign(:posts, MyApp.Blog.slice(1, @page_size))}
    end

    def handle_event("patterns_server_page", %{"page" => page}, socket) do
      page = if is_integer(page), do: page, else: String.to_integer(page)

      {:noreply,
       socket
       |> assign(:page, page)
       |> assign(:posts, MyApp.Blog.slice(page, @page_size))}
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
                  excerpt.className = "text-ink-muted text-sm";
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
          <p class="text-ink-muted text-sm">{post.excerpt}</p>
        </li>
      </ul>
    </div>

    <.pagination
      id="pagination-patterns-client"
      class="pagination"
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

  def patterns_client_js do
    ~S"""
    const pages = JSON.parse(document.getElementById("pagination-patterns-client-wrap").dataset.pages);
    const list = document.getElementById("pagination-patterns-client-list");
    const pagination = document.getElementById("pagination-patterns-client");

    function render(page) {
      list.replaceChildren(
        ...(pages[page - 1] ?? []).map((post) => {
          const li = document.createElement("li");
          li.className = "flex flex-col gap-space-xs p-space rounded-md bg-layer border border-border";
          const title = document.createElement("h3");
          title.textContent = post.title;
          const excerpt = document.createElement("p");
          excerpt.className = "text-ink-muted text-sm";
          excerpt.textContent = post.excerpt;
          li.append(title, excerpt);
          return li;
        })
      );
    }

    pagination?.addEventListener("pagination-page-changed", (e) => {
      render(e.detail.page);
    });
    """
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
        <p class="text-ink-muted text-sm">{post.excerpt}</p>
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
        class="pagination"
        count={@count}
        page={@page}
        page_size={@page_size}
        controlled
        controlled_page_size
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
        class="pagination"
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
                    excerpt.className = "text-ink-muted text-sm";
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
            <p class="text-ink-muted text-sm">{post.excerpt}</p>
          </li>
        </ul>
      </div>

      <.pagination
        id="pagination-patterns-client"
        class="pagination"
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

  def mount_assigns do
    %{count: @count, page_size: @page_size}
  end
end
