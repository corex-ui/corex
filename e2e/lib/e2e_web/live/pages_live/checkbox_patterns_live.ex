defmodule E2eWeb.CheckboxPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_async "patterns-checkbox-async"
  @id_controlled "patterns-checkbox-controlled"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:checked, true)
      |> assign(:async_heex_full, E2eWeb.Demos.CheckboxDemo.patterns_async_heex_full())
      |> assign(:async_elixir, E2eWeb.Demos.CheckboxDemo.patterns_async_elixir())
      |> assign(:controlled_heex, E2eWeb.Demos.CheckboxDemo.patterns_controlled_heex())
      |> assign(:controlled_elixir, E2eWeb.Demos.CheckboxDemo.patterns_controlled_elixir())
      |> assign_async(:checkbox, fn ->
        Process.sleep(1000)
        {:ok, %{checkbox: %{checked: true}}}
      end)

    {:ok, socket}
  end

  def handle_event("patterns_controlled_changed", %{"checked" => checked}, socket) do
    next =
      case checked do
        true -> true
        false -> false
        "true" -> true
        "false" -> false
        "indeterminate" -> :indeterminate
        :indeterminate -> :indeterminate
        _ -> false
      end

    {:noreply, assign(socket, :checked, next)}
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
        id="checkbox-patterns-page"
        title={~t"Checkbox · Pattern"}
        subtitle={~t"Common ways to structure Checkbox state and data flows."}
      >
        <.demo_section
          id="checkbox-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={checkbox} assign={@checkbox}>
              <:loading>
                <.checkbox_skeleton class="checkbox" />
              </:loading>

              <.checkbox
                id={@id_async}
                class="checkbox"
                checked={checkbox.checked}
              >
                <:label>Accept terms</:label>
                <:indicator>
                  <.heroicon name="hero-check" />
                </:indicator>
                <:indeterminate>
                  <.heroicon name="hero-minus" />
                </:indeterminate>
              </.checkbox>
            </.async_result>
          </:preview>
        </.demo_section>

        <.demo_section
          id="checkbox-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.checkbox
              id={@id_controlled}
              class="checkbox"
              controlled
              checked={@checked}
              on_checked_change="patterns_controlled_changed"
            >
              <:label>Accept terms</:label>
              <:indicator>
                <.heroicon name="hero-check" />
              </:indicator>
              <:indeterminate>
                <.heroicon name="hero-minus" />
              </:indeterminate>
            </.checkbox>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
