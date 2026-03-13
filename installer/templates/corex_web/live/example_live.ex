defmodule <%= @web_namespace %>.ExampleLive do
  use <%= @web_namespace %>, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :logs, [])}
  end

  @impl true
  def handle_event("demo_checkbox_change", %{"checked" => checked}, socket) do
    at =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_time()
      |> Time.to_string()

    message = if checked, do: gettext("Checked"), else: gettext("Unchecked")
    entry = %{id: System.unique_integer([:positive]), at: at, message: message}

    socket =
      socket
      |> stream_insert(:logs, entry, at: 0)
      |> push_event("console_log", %{at: at, message: message})

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_log", %{"dom_id" => dom_id}, socket) do
    {:noreply, stream_delete_by_dom_id(socket, :logs, dom_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
<%= if @mode or @theme or @theme_switcher or @locale do %>    <Layouts.app
      flash={@flash}
<%= if @mode do %>      mode={@mode}
<% end %><%= if @theme do %>      theme={@theme}
<% end %><%= if @theme_switcher do %>      themes={@themes}
<% end %><%= if @locale do %>      locale={@locale}
      current_path={@current_path}
<% end %>    >
<% else %>    <Layouts.app flash={@flash}>
<% end %>      <section
        aria-label={gettext("Hero")}
        class="relative flex flex-col flex-1 w-full overflow-hidden min-h-screen justify-start items-center"
      >
        <div aria-hidden="true" class="pointer-events-none absolute inset-0 opacity-[0.04]">
          <div class="absolute top-1/4 left-0 right-0 h-px bg-root--brand"></div>
          <div class="absolute top-1/2 left-0 right-0 h-px bg-root--brand"></div>
          <div class="absolute top-3/4 left-0 right-0 h-px bg-root--brand"></div>
          <div class="absolute inset-y-0 left-1/4 w-px bg-root--brand"></div>
          <div class="absolute inset-y-0 left-1/2 w-px bg-root--brand"></div>
          <div class="absolute inset-y-0 left-3/4 w-px bg-root--brand"></div>
        </div>

        <div class="relative w-full max-w-ui-xl mx-auto px-ui-padding-xl py-12 sm:py-16 flex flex-col gap-ui justify-start flex-shrink-0">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-ui-xl items-center">
            <div class="flex flex-col gap-ui-gap-md text-center md:text-start">
              <h1 class="text-ui-brand text-5xl md:text-6xl font-bold tracking-tight leading-tight my-0">
                {gettext("Corex")}
              </h1>
              <h2 class="text-3xl md:text-4xl font-semibold tracking-tight text-root--muted my-0">
                {gettext("for Phoenix Framework")}
              </h2>
              <p class="text-base md:text-lg text-root--muted max-w-ui-md text-center">
                {gettext(
                  "An unstyled and accessible UI component system powered by Zag.js state machines and designed for Phoenix applications."
                )}
              </p>
              <div class="flex flex-wrap gap-ui-gap-sm justify-center md:justify-start pt-ui">
                <.navigate
                  to={if @locale, do: "/#{@locale}", else: "/"}
                  type="href"
                  class="button button--brand"
                >
                  {gettext("Switch to Controller")}
                  <.heroicon name="hero-arrow-right" />
                </.navigate>
                <.navigate to="https://hexdocs.pm/corex" external type="href" class="button">
                  {gettext("Corex Docs")}
                  <.heroicon name="hero-arrow-top-right-on-square" />
                </.navigate>
              </div>
            </div>
            <div class="flex justify-center md:justify-end w-full">
              <div class="w-full max-w-ui-md border border-ui--border rounded-ui bg-layer p-ui-padding-xl flex flex-col items-center gap-ui-gap-lg">
                <.checkbox
                  id="demo_checkbox"
                  class="checkbox checkbox--xl"
                  on_checked_change="demo_checkbox_change"
                >
                  <:label>
                    {gettext("Check me")}
                  </:label>
                  <:indicator>
                    <.heroicon name="hero-check" class="data-checked" />
                  </:indicator>
                </.checkbox>
                <div class="flex flex-wrap gap-ui-gap-sm justify-center">
                  <span class="badge badge--sm bg-root text-root--success">
                    <.heroicon name="hero-signal" class="text-root--success animate-pulse" />
                    {gettext("Client Events")}
                  </span>
                  <span class="badge badge--sm bg-root text-root--success">
                    <.heroicon name="hero-signal" class="text-root--success animate-pulse" />
                    {gettext("Server Events")}
                  </span>
                </div>
                <.navigate
                  to={if @locale, do: "/#{@locale}", else: "/"}
                  type="href"
                  class="link link--sm"
                >
                  {gettext("Switch to Controller")}
                  <.heroicon name="hero-arrow-right" />
                </.navigate>
              </div>
            </div>
          </div>
        </div>

        <.data_table id="log-table" class="data-table max-h-[25vh]" rows={@streams.logs}>
          <:col :let={{_id, row}} label={gettext("Time")}>{row.at}</:col>
          <:col :let={{_id, row}} label={gettext("Message")}>{row.message}</:col>
          <:action :let={{dom_id, row}}>
            <.action
              phx-click="delete_log"
              phx-value-dom_id={dom_id}
              class="button button--sm button--alert"
              aria-label={"Delete #{row.message}"}
            >
              <.heroicon name="hero-trash" />
            </.action>
          </:action>
          <:empty>
            <p class="px-ui-padding py-ui-padding-sm text-root--muted">
              {gettext("There are no logs yet.")}
            </p>
          </:empty>
        </.data_table>
      </section>

      <section
        aria-label={gettext("About this page")}
        class="min-h-screen flex flex-col justify-center w-full border-t border-ui--border"
      >
        <div class="w-full max-w-ui-xl mx-auto px-ui-padding-xl py-12 sm:py-16 flex flex-col gap-ui-gap-2xl">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-ui-gap-xl items-start">
            <div class="flex flex-col gap-ui-gap-md">
              <h2 class="text-xl font-bold text-root--muted my-0">
                {gettext("LiveView")}
              </h2>
              <p class="text-root--muted my-0">
                {gettext("This page is rendered from a LiveView. Edit this file to change it:")}
              </p>
              <div class="flex flex-col gap-ui-gap-sm">
                <code
                  tabindex="0"
                  class="font-mono text-sm border border-ui--border bg-ui px-ui-padding py-ui-padding-sm text-ui--text block overflow-x-auto scrollbar scrollbar--sm"
                >
                  lib/<%= @lib_web_name %>/live/example_live.ex
                </code>
              </div>
            </div>
            <div class="flex flex-col gap-ui-gap-md">
              <h2 class="text-xl font-bold text-root--muted my-0">
                {gettext("Client and server events")}
              </h2>
              <p class="text-root--muted my-0">
                {gettext(
                  "The checkbox fires on_checked_change (server). Each check or uncheck inserts a log row in the table above and logs to the browser console."
                )}
              </p>
            </div>
          </div>
        </div>
      </section>
    </Layouts.app>
    """
  end
end
