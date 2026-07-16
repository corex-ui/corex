defmodule E2eWeb.TagsInputPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:patterns_heex, E2eWeb.Demos.TagsInputDemo.patterns_controlled_heex())
      |> assign(:patterns_elixir, E2eWeb.Demos.TagsInputDemo.patterns_controlled_elixir())
      |> assign(:patterns_validation_heex, E2eWeb.Demos.TagsInputDemo.patterns_validation_heex())
      |> assign(
        :patterns_validation_elixir,
        E2eWeb.Demos.TagsInputDemo.patterns_validation_elixir()
      )
      |> assign(:allowed_tags, ["lorem", "duis", "donec"])
      |> assign(:tags, ["lorem", "duis", "donec"])
      |> assign(:tags_validated, ["lorem", "duis"])

    {:ok, socket}
  end

  @impl true
  def handle_event("tags_patterns_value_changed", %{"id" => _id, "value" => value}, socket)
      when is_list(value) do
    {:noreply, assign(socket, :tags, value)}
  end

  @impl true
  def handle_event("tags_patterns_validated_changed", %{"id" => _id, "value" => value}, socket)
      when is_list(value) do
    allowed = socket.assigns.allowed_tags
    filtered = Enum.filter(value, &(&1 in allowed))
    {:noreply, assign(socket, :tags_validated, filtered)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="tags-input-patterns-page"
        title="Tags Input · Patterns"
        subtitle="Controlled tag list and allow-list validation (both use controlled mode)."
      >
        <.demo_section
          id="tags-input-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @patterns_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @patterns_elixir}
          ]}
        >
          <:preview>
            <.tags_input
              id="tags-input-patterns-controlled"
              class="tags-input"
              value={@tags}
              on_value_change="tags_patterns_value_changed"
            >
              <:label>Labels</:label>
              <:close><.heroicon name="hero-x-mark" /></:close>
            </.tags_input>
          </:preview>
        </.demo_section>

        <.demo_section
          id="tags-input-patterns-validation-section"
          title="Validation"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @patterns_validation_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @patterns_validation_elixir}
          ]}
        >
          <:preview>
            <.tags_input
              id="tags-input-patterns-validation"
              class="tags-input"
              value={@tags_validated}
              on_value_change="tags_patterns_validated_changed"
            >
              <:label>Allowed: lorem, duis, donec</:label>
              <:close><.heroicon name="hero-x-mark" /></:close>
            </.tags_input>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
