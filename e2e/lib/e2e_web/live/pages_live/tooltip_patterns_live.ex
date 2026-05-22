defmodule E2eWeb.TooltipPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  on_mount({__MODULE__, :assign_users})

  def on_mount(:assign_users, _params, _session, socket) do
    users = [
      %{id: "1", first_name: "Alice", full_name: "Alice Johnson"},
      %{id: "2", first_name: "Bob", full_name: "Bob Martinez"},
      %{id: "3", first_name: "Carol", full_name: "Carol Nguyen"}
    ]

    {:cont,
     socket
     |> assign(:users, users)
     |> assign(:active_user_detail, "Hover a first name to show the full name here.")
     |> assign(
       :active_link_tooltip_detail,
       "Hover a first name to show the full name here."
     )}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("tooltip_pattern_trigger_value", %{"value" => value}, socket) do
    body =
      case Enum.find(socket.assigns.users, &(&1.id == value)) do
        nil -> socket.assigns.active_user_detail
        user -> user.full_name
      end

    {:noreply, assign(socket, :active_user_detail, body)}
  end

  @impl true
  def handle_event("tooltip_pattern_link_multi_value", %{"value" => value}, socket) do
    body =
      case Enum.find(socket.assigns.users, &(&1.id == value)) do
        nil -> socket.assigns.active_link_tooltip_detail
        user -> user.full_name
      end

    {:noreply, assign(socket, :active_link_tooltip_detail, body)}
  end

  @impl true
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
        id="tooltip-patterns-page"
        title="Tooltip · Pattern"
        subtitle="Multi-trigger with LiveView, per-row tooltips in a ul, and one tooltip with several link triggers."
      >
        <.demo_section
          id="tooltip-pattern-multi-trigger-lv"
          title="Multi-trigger and dynamic content"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.TooltipDemo.patterns_multi_trigger_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.TooltipDemo.patterns_multi_trigger_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full max-w-xl">
              <.tooltip
                id="tooltip-pattern-users"
                class="tooltip"
                show_arrow={false}
                on_trigger_value_change="tooltip_pattern_trigger_value"
              >
                <:trigger :for={user <- @users} value={user.id}>
                  {user.first_name}
                </:trigger>
                <:content>
                  {@active_user_detail}
                </:content>
              </.tooltip>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="tooltip-pattern-profile-links"
          title={~t"List of profile links (one tooltip per row)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: E2eWeb.Demos.TooltipDemo.patterns_profile_links_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.TooltipDemo.patterns_profile_links_elixir()
            }
          ]}
        >
          <:preview>
            <ul class="flex flex-col gap-2 list-none p-0 m-0 w-full max-w-xl">
              <li :for={user <- @users}>
                <.tooltip
                  id={"tooltip-profile-" <> user.id}
                  class="tooltip"
                  show_arrow={false}
                  trigger_tag={:span}
                >
                  <:trigger>
                    <.navigate to={~p"/admins"} type="navigate" class="link">
                      {user.first_name}
                    </.navigate>
                  </:trigger>
                  <:content>
                    {user.full_name}
                  </:content>
                </.tooltip>
              </li>
            </ul>
          </:preview>
        </.demo_section>

        <.demo_section
          id="tooltip-pattern-profile-link-multi"
          title={~t"One tooltip, multiple profile links as triggers"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: E2eWeb.Demos.TooltipDemo.patterns_profile_links_multi_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.TooltipDemo.patterns_profile_links_multi_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-2 items-start w-full max-w-xl">
              <.tooltip
                id="tooltip-pattern-profile-link-multi-tool"
                class="tooltip"
                show_arrow={false}
                trigger_tag={:span}
                on_trigger_value_change="tooltip_pattern_link_multi_value"
              >
                <:trigger :for={user <- @users} value={user.id}>
                  <.navigate to={~p"/admins"} type="navigate" class="link">
                    {user.first_name}
                  </.navigate>
                </:trigger>
                <:content>
                  {@active_link_tooltip_detail}
                </:content>
              </.tooltip>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
