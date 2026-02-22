defmodule E2eWeb.AccordionAsyncLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items =
          Corex.Content.new([
            [
              id: "lorem",
              trigger: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
            ],
            [
              id: "duis",
              trigger: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula, at interdum tellus."
            ],
            [
              id: "donec",
              trigger: "Donec condimentum ex mi",
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
            ]
          ])

        {:ok,
         %{
           accordion: %{
             items: items,
             value: ["duis", "donec"]
           }
         }}
      end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Async</h2>
      </div>

      <.async_result :let={accordion} assign={@accordion}>
        <:loading>
          <.accordion_skeleton count={3} class="accordion" />
        </:loading>

        <:failed>
          there was an error loading the accordion
        </:failed>

        <.accordion
          id="async-accordion"
          class="accordion"
          items={accordion.items}
          value={accordion.value}
        />
      </.async_result>
    </Layouts.app>
    """
  end
end
