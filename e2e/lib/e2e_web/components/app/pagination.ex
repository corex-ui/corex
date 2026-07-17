defmodule E2eWeb.App.Pagination do
  use E2eWeb, :html

  import E2eWeb.Helpers

  attr :path, :string, required: true

  def docs_pagination(assigns) do
    assigns =
      assigns
      |> assign(:prev, prev_next_page(assigns.path, :prev))
      |> assign(:next, prev_next_page(assigns.path, :next))

    ~H"""
    <nav
      :if={@prev || @next}
      class="w-full flex justify-end items-center px-4 py-4 gap-0"
      aria-label="Adjacent doc pages"
    >
      <.navigate
        :if={@prev}
        to={@prev.to}
        class="button ui-size-sm flex items-center gap-2 rounded-e-none max-w-[min(100%,18rem)] min-w-0"
      >
        <.heroicon name="hero-chevron-left" class="shrink-0" title={@prev.label} />
      </.navigate>

      <.navigate
        :if={@next}
        to={@next.to}
        class="button ui-size-sm flex items-center gap-2 not-only:border-s-0 rounded-s-none max-w-[min(100%,18rem)] min-w-0"
      >
        <.heroicon name="hero-chevron-right" class="shrink-0" title={@next.label} />
      </.navigate>
    </nav>
    """
  end

  def docs_pagination_bottom(assigns) do
    assigns =
      assigns
      |> assign(:prev, prev_next_page(assigns.path, :prev))
      |> assign(:next, prev_next_page(assigns.path, :next))

    ~H"""
    <nav
      :if={@prev || @next}
      class="w-full flex items-center px-4 py-4 gap-3"
      aria-label="Doc page navigation"
    >
      <div class="flex min-w-0 flex-1 justify-start">
        <.navigate
          :if={@prev}
          to={@prev.to}
          class="button ui-size-sm flex items-center gap-2 max-w-full min-w-0"
        >
          <.heroicon name="hero-chevron-left" class="shrink-0" title={@prev.label} />
          <span class="truncate text-start">{@prev.label}</span>
        </.navigate>
      </div>

      <div class="flex min-w-0 flex-1 justify-end">
        <.navigate
          :if={@next}
          to={@next.to}
          class="button ui-size-sm flex items-center gap-2 max-w-full min-w-0"
        >
          <span class="truncate text-end">{@next.label}</span>
          <.heroicon name="hero-chevron-right" class="shrink-0" title={@next.label} />
        </.navigate>
      </div>
    </nav>
    """
  end
end
