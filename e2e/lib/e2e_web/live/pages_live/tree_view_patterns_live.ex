defmodule E2eWeb.TreeViewPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_async "patterns-tree-async"
  @id_redirect "patterns-tree-redirect"

  @async_heex """
  <.async_result :let={tree} assign={@tree_data}>
    <:loading>
      <.tree_view_skeleton count={3}  />
    </:loading>

    <.tree_view
      id="patterns-tree-async"
      
      items={tree.items}
      expanded_value={tree.expanded_value}
      value={tree.value}
    >
      <:label>Repository</:label>
      <:branch_indicator :let={_row}>
        <.heroicon name="hero-chevron-right" />
      </:branch_indicator>
    </.tree_view>
  </.async_result>
  """

  @async_elixir """
  def mount(_params, _session, socket) do
    socket =
      assign_async(socket, :tree_data, fn ->
        Process.sleep(1000)

        items = E2e.TreeViewDemo.repo_tree()

        {:ok,
         %{
           tree_data: %{
             items: items,
             expanded_value: ["repo-lib"],
             value: []
           }
         }}
      end)

    {:ok, socket}
  end
  """
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_redirect, @id_redirect)
      |> assign(:redirect_items, E2eWeb.Demos.TreeViewDemo.patterns_redirect_items())
      |> assign(:redirect_expanded, E2eWeb.Demos.TreeViewDemo.patterns_redirect_expanded())
      |> assign(:redirect_value, E2eWeb.Demos.TreeViewDemo.patterns_redirect_value())
      |> assign(:async_heex, @async_heex)
      |> assign(:async_elixir, @async_elixir)
      |> assign(:redirect_heex, E2eWeb.Demos.TreeViewDemo.patterns_redirect_heex())
      |> assign_async(:tree_data, fn ->
        Process.sleep(1000)

        items = E2e.TreeViewDemo.repo_tree()

        {:ok,
         %{
           tree_data: %{
             items: items,
             expanded_value: E2e.TreeViewDemo.repo_expanded_default(),
             value: []
           }
         }}
      end)

    {:ok, socket}
  end

  def handle_event(
        "patterns_tree_redirect_nav",
        %{"selectedValue" => paths, "isItem" => is_item},
        socket
      ) do
    path = List.first(paths || [])

    if is_item == true and is_binary(path) and path != "" do
      {:noreply, push_navigate(socket, to: path)}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="tree-view-patterns-page"
        title={~t"Tree view · Pattern"}
        subtitle={~t"Async loading and redirect navigation."}
      >
        <.demo_section
          id="patterns-tree-async-section"
          tabs_id="tabs-tree-view-patterns-async"
          title={~t"Async"}
          trigger_class="button button--sm"
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={tree} assign={@tree_data}>
              <:loading>
                <.tree_view_skeleton count={3} />
              </:loading>

              <.tree_view
                id={@id_async}
                items={tree.items}
                expanded_value={tree.expanded_value}
                value={tree.value}
              >
                <:label>Repository</:label>
                <:branch_indicator :let={_row}>
                  <.heroicon name="hero-chevron-right" />
                </:branch_indicator>
              </.tree_view>
            </.async_result>
          </:preview>
        </.demo_section>

        <section class="flex flex-col gap-4 items-start">
          <.tabs
            id="tabs-tree-view-patterns-redirect"
            class="tabs tabs--max-w-6xl [&>[data-scope=tabs][data-part=root]>[data-scope=tabs][data-part=list]]:place-self-end"
            value="preview"
          >
            <:trigger value="preview" class="button button--sm">Preview</:trigger>
            <:trigger value="heex" class="button button--sm">Heex</:trigger>
            <:content value="preview" class="items-center shadow-sm p-ui-padding">
              <h3 class="font-medium">Redirect (navigation)</h3>
              <.tree_view
                id={@id_redirect}
                redirect
                on_selection_change="patterns_tree_redirect_nav"
                expanded_value={@redirect_expanded}
                value={@redirect_value}
                items={@redirect_items}
              >
                <:label>Navigate</:label>
                <:branch_indicator :let={_row}>
                  <.heroicon name="hero-chevron-right" />
                </:branch_indicator>
              </.tree_view>
            </:content>
            <:content value="heex" class="items-center bg-stone-100 p-0">
              <.code class="code code--max-w-none w-full" language={:heex} code={@redirect_heex} />
            </:content>
          </.tabs>
        </section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
