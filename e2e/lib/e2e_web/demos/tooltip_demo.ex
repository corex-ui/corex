defmodule E2eWeb.Demos.TooltipDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.tooltip class="tooltip" show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.tooltip class="tooltip" show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_with_arrow_code do
    ~S"""
    <.tooltip class="tooltip">
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_with_arrow_example(assigns) do
    _ = assigns

    ~H"""
    <.tooltip class="tooltip">
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Tooltip below</:content>
    </.tooltip>
    """
  end

  def anatomy_placement_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space gap-2">
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "bottom"}}>
        <:trigger>Bottom</:trigger>
        <:content>Tooltip below</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top"}}>
        <:trigger>Top</:trigger>
        <:content>Tooltip above</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "left"}}>
        <:trigger>Left</:trigger>
        <:content>Tooltip on the left</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "right"}}>
        <:trigger>Right</:trigger>
        <:content>Tooltip on the right</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_positioning_code do
    ~S"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", gutter: 4}}>
        <:trigger>Gutter 4</:trigger>
        <:content>Tight gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", gutter: 32}}>
        <:trigger>Gutter 32</:trigger>
        <:content>Wide gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", shift: 0}}>
        <:trigger>Shift 0</:trigger>
        <:content>Centered along the placement edge</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", shift: 32}}>
        <:trigger>Shift 32</:trigger>
        <:content>Tooltip slid along the edge</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_positioning_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", gutter: 4}}>
        <:trigger>Gutter 4</:trigger>
        <:content>Tight gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", gutter: 32}}>
        <:trigger>Gutter 32</:trigger>
        <:content>Wide gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", shift: 0}}>
        <:trigger>Shift 0</:trigger>
        <:content>Centered along the placement edge</:content>
      </.tooltip>
      <.tooltip class="tooltip" positioning={%Corex.Positioning{placement: "top", shift: 32}}>
        <:trigger>Shift 32</:trigger>
        <:content>Tooltip slid along the edge</:content>
      </.tooltip>
    </div>
    """
  end

  def patterns_multi_trigger_heex do
    ~S"""
    <.tooltip
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
    """
  end

  def patterns_multi_trigger_elixir do
    ~S"""
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
       |> assign(:active_user_detail, "Hover a first name to show the full name here.")}
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def handle_event("tooltip_pattern_trigger_value", %{"value" => value}, socket) do
      body =
        case Enum.find(socket.assigns.users, &(&1.id == value)) do
          nil -> socket.assigns.active_user_detail
          user -> user.full_name
        end

      {:noreply, assign(socket, :active_user_detail, body)}
    end
    """
  end

  def patterns_profile_links_heex do
    ~S"""
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
    """
  end

  def patterns_profile_links_elixir do
    ~S"""
    on_mount({__MODULE__, :assign_users})

    def on_mount(:assign_users, _params, _session, socket) do
      users = [
        %{id: "1", first_name: "Alice", full_name: "Alice Johnson"},
        %{id: "2", first_name: "Bob", full_name: "Bob Martinez"},
        %{id: "3", first_name: "Carol", full_name: "Carol Nguyen"}
      ]

      {:cont, assign(socket, :users, users)}
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end
    """
  end

  def patterns_profile_links_multi_heex do
    ~S"""
    <div class="flex flex-col gap-2 items-start w-full max-w-xl">
      <.tooltip
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
    """
  end

  def patterns_profile_links_multi_elixir do
    ~S"""
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
       |> assign(
         :active_link_tooltip_detail,
         "Hover a first name to show the full name here."
       )}
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def handle_event("tooltip_pattern_link_multi_value", %{"value" => value}, socket) do
      body =
        case Enum.find(socket.assigns.users, &(&1.id == value)) do
          nil -> socket.assigns.active_link_tooltip_detail
          user -> user.full_name
        end

      {:noreply, assign(socket, :active_link_tooltip_detail, body)}
    end
    """
  end

  def patterns_menu_item_items do
    Corex.Tree.new([
      %{label: "Edit", value: "edit"},
      %{label: "Support", value: "support", disabled: true}
    ])
  end

  def patterns_menu_item_heex do
    ~S"""
    <.menu id="tooltip-pattern-menu" class="menu" items={@items}>
      <:trigger>Actions</:trigger>
      <:indicator>
        <.heroicon name="hero-chevron-down" />
      </:indicator>
      <:item :let={item}>
        <%= if item.value == "support" do %>
          <.tooltip
            id="tooltip-pattern-menu-support"
            class="tooltip ui-size-sm"
            trigger_tag={:span}
            show_arrow={false}
          >
            <:trigger focusable={false}>{item.label}</:trigger>
            <:content>Coming soon</:content>
          </.tooltip>
        <% else %>
          {item.label}
        <% end %>
      </:item>
    </.menu>
    """
  end

  def patterns_menu_item_elixir do
    ~S"""
    items =
      Corex.Tree.new([
        %{label: "Edit", value: "edit"},
        %{label: "Support", value: "support", disabled: true}
      ])
    """
  end

  def api_set_open_client_binding_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} class="button ui-size-sm">Open</.action>
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} class="button ui-size-sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-cb" class="tooltip">
      <:trigger>Hover or focus</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} class="button ui-size-sm">
          Open
        </.action>
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} class="button ui-size-sm">
          Close
        </.action>
      </div>
      <.tooltip id="tooltip-api-cb" class="tooltip">
        <:trigger>Hover or focus</:trigger>
        <:content>Tooltip content</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
      >
        Open
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: false } }))"
      >
        Close
      </button>
    </div>
    <.tooltip id="tooltip-api-cjs" class="tooltip">
      <:trigger>Target</:trigger>
      <:content>Tooltip</:content>
    </.tooltip>
    """
  end

  def api_set_open_client_js_js do
    ~S"""
    const el = document.getElementById("tooltip-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:tooltip:set-open", { bubbles: false, detail: { open: true } })
    );
    """
  end

  def api_set_open_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("tooltip-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:tooltip:set-open", { bubbles: false, detail: { open: true } })
    );
    """
  end

  def api_set_open_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <button
          type="button"
          class="button ui-size-sm"
          onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
        >
          Open
        </button>
        <button
          type="button"
          class="button ui-size-sm"
          onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: false } }))"
        >
          Close
        </button>
      </div>
      <.tooltip id="tooltip-api-cjs" class="tooltip">
        <:trigger>Target</:trigger>
        <:content>Tooltip</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="tooltip_api_open" class="button ui-size-sm">Open</.action>
      <.action phx-click="tooltip_api_close" class="button ui-size-sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-srv" class="tooltip">
      <:trigger>Hover or focus</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def api_set_open_server_elixir do
    ~S"""
    def handle_event("tooltip_api_open", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", true)}
    end

    def handle_event("tooltip_api_close", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", false)}
    end
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action phx-click="tooltip_api_open" class="button ui-size-sm">Open</.action>
        <.action phx-click="tooltip_api_close" class="button ui-size-sm">Close</.action>
      </div>
      <.tooltip id="tooltip-api-srv" class="tooltip">
        <:trigger>Hover or focus</:trigger>
        <:content>Tooltip content</:content>
      </.tooltip>
    </div>
    """
  end

  def api_codes do
    %{
      set_open_client_binding: api_set_open_client_binding_heex(),
      set_open_client_js_heex: api_set_open_client_js_heex(),
      set_open_client_js: api_set_open_client_js_js(),
      set_open_client_ts: api_set_open_client_js_ts(),
      set_open_server_heex: api_set_open_server_heex(),
      set_open_server_elixir: api_set_open_server_elixir()
    }
  end

  def api_client_binding_code, do: api_set_open_client_binding_heex()

  def api_client_binding_example(assigns), do: api_set_open_client_binding_example(assigns)

  def patterns_set_open_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", true)} class="button ui-size-sm">Open</.action>
      <.action phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", false)} class="button ui-size-sm">Close</.action>
    </div>
    <.tooltip class="tooltip">
      <:trigger>Hover or buttons</:trigger>
      <:content>Open state from Corex.Tooltip.set_open/2</:content>
    </.tooltip>
    """
  end

  def patterns_set_open_elixir do
    ~S"""
    def handle_event("tooltip_pattern_open", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-patterns-set-open", true)}
    end

    def handle_event("tooltip_pattern_close", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-patterns-set-open", false)}
    end
    """
  end

  def patterns_set_open_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="flex flex-wrap items-center gap-space">
        <.action
          phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", true)}
          class="button ui-size-sm"
        >
          Open
        </.action>
        <.action
          phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", false)}
          class="button ui-size-sm"
        >
          Close
        </.action>
      </div>
      <.tooltip id="tooltip-patterns-set-open" class="tooltip">
        <:trigger>Hover or buttons</:trigger>
        <:content>Open state from Corex.Tooltip.set_open/2</:content>
      </.tooltip>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.tooltip
      class="tooltip"
      on_open_change="tooltip_open_changed"
      on_open_change_client="tooltip-open-changed"
    >
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "tooltip_open_changed",
      ~S|%{"open" => open, "id" => id} = params|
    )
  end

  def events_client_listener_js do
    ~S"""
    const el = document.getElementById("tooltip-events");
    el?.addEventListener("tooltip-open-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def styling_color_code do
    ~S"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip">
        <:trigger>Default</:trigger>
        <:content>Neutral surface</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-accent">
        <:trigger>Accent</:trigger>
        <:content>ui-accent</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-brand">
        <:trigger>Brand</:trigger>
        <:content>ui-brand</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-alert">
        <:trigger>Alert</:trigger>
        <:content>ui-alert</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-success">
        <:trigger>Success</:trigger>
        <:content>ui-success</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-info">
        <:trigger>Info</:trigger>
        <:content>ui-info</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip">
        <:trigger>Default</:trigger>
        <:content>Neutral surface</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-accent">
        <:trigger>Accent</:trigger>
        <:content>ui-accent</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-brand">
        <:trigger>Brand</:trigger>
        <:content>ui-brand</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-alert">
        <:trigger>Alert</:trigger>
        <:content>ui-alert</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-success">
        <:trigger>Success</:trigger>
        <:content>ui-success</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-info">
        <:trigger>Info</:trigger>
        <:content>ui-info</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.tooltip class="tooltip">
      <:trigger>Subtle (default)</:trigger>
      <:content>Subtle (default)</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-solid">
      <:trigger>Solid</:trigger>
      <:content>Solid</:content>
    </.tooltip>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-2">
      <.tooltip class="tooltip">
        <:trigger>Subtle (default)</:trigger>
        <:content>Subtle (default)</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-solid">
        <:trigger>Solid</:trigger>
        <:content>Solid</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("tooltip"),
        variant <- DemoScales.styling_variant_axis_steps("tooltip") do
      class = DemoScales.join_matrix_modifiers("tooltip", semantic.modifier, variant.modifier)

      ~s(<.tooltip class="#{class}">
        <:trigger>#{semantic.label}</:trigger>
        <:content>#{semantic.label}</:content>
      </.tooltip>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("tooltip"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("tooltip"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.tooltip
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("tooltip", semantic.modifier, variant.modifier)}
          >
            <:trigger>{semantic.label}</:trigger>
            <:content>{semantic.label}</:content>
          </.tooltip>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip ui-size-sm">
        <:trigger>Sm</:trigger>
        <:content>ui-size-sm</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-md">
        <:trigger>Md</:trigger>
        <:content>ui-size-md</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-lg">
        <:trigger>Lg</:trigger>
        <:content>ui-size-lg</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-xl">
        <:trigger>Xl</:trigger>
        <:content>ui-size-xl</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex-wrap gap-2">
      <.tooltip class="tooltip ui-size-sm">
        <:trigger>Sm</:trigger>
        <:content>ui-size-sm</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-md">
        <:trigger>Md</:trigger>
        <:content>ui-size-md</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-lg">
        <:trigger>Lg</:trigger>
        <:content>ui-size-lg</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-size-xl">
        <:trigger>Xl</:trigger>
        <:content>ui-size-xl</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_rounded_code do
    ~S"""
    <.tooltip class="tooltip ui-rounded-none">
      <:trigger>None</:trigger>
      <:content>ui-rounded-none</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-rounded-sm">
      <:trigger>SM</:trigger>
      <:content>ui-rounded-sm</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-rounded-md">
      <:trigger>MD</:trigger>
      <:content>ui-rounded-md</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-rounded-lg">
      <:trigger>LG</:trigger>
      <:content>ui-rounded-lg</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-rounded-xl">
      <:trigger>XL</:trigger>
      <:content>ui-rounded-xl</:content>
    </.tooltip>
    <.tooltip class="tooltip ui-rounded-full">
      <:trigger>Full</:trigger>
      <:content>ui-rounded-full</:content>
    </.tooltip>
    """
  end

  def styling_rounded_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center">
      <.tooltip class="tooltip ui-rounded-none">
        <:trigger>None</:trigger>
        <:content>ui-rounded-none</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-rounded-sm">
        <:trigger>SM</:trigger>
        <:content>ui-rounded-sm</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-rounded-md">
        <:trigger>MD</:trigger>
        <:content>ui-rounded-md</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-rounded-lg">
        <:trigger>LG</:trigger>
        <:content>ui-rounded-lg</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-rounded-xl">
        <:trigger>XL</:trigger>
        <:content>ui-rounded-xl</:content>
      </.tooltip>
      <.tooltip class="tooltip ui-rounded-full">
        <:trigger>Full</:trigger>
        <:content>ui-rounded-full</:content>
      </.tooltip>
    </div>
    """
  end
end
