defmodule E2eWeb.Demos.TooltipDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def anatomy_minimal_code do
    ~S"""
    <.tooltip  show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.tooltip show_arrow={false}>
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_with_arrow_code do
    ~S"""
    <.tooltip >
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_with_arrow_example(assigns) do
    _ = assigns

    ~H"""
    <.tooltip>
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <.tooltip  positioning={%Corex.Positioning{placement: "bottom"}}>
      <:trigger>Bottom</:trigger>
      <:content>Tooltip below</:content>
    </.tooltip>
    """
  end

  def anatomy_placement_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.tooltip positioning={%Corex.Positioning{placement: "bottom"}}>
        <:trigger>Bottom</:trigger>
        <:content>Tooltip below</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "top"}}>
        <:trigger>Top</:trigger>
        <:content>Tooltip above</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "left"}}>
        <:trigger>Left</:trigger>
        <:content>Tooltip on the left</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "right"}}>
        <:trigger>Right</:trigger>
        <:content>Tooltip on the right</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_positioning_code do
    ~S"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip  positioning={%Corex.Positioning{placement: "top", gutter: 4}}>
        <:trigger>Gutter 4</:trigger>
        <:content>Tight gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip  positioning={%Corex.Positioning{placement: "top", gutter: 32}}>
        <:trigger>Gutter 32</:trigger>
        <:content>Wide gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip  positioning={%Corex.Positioning{placement: "top", shift: 0}}>
        <:trigger>Shift 0</:trigger>
        <:content>Centered along the placement edge</:content>
      </.tooltip>
      <.tooltip  positioning={%Corex.Positioning{placement: "top", shift: 32}}>
        <:trigger>Shift 32</:trigger>
        <:content>Tooltip slid along the edge</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_positioning_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip positioning={%Corex.Positioning{placement: "top", gutter: 4}}>
        <:trigger>Gutter 4</:trigger>
        <:content>Tight gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "top", gutter: 32}}>
        <:trigger>Gutter 32</:trigger>
        <:content>Wide gap between trigger and tooltip</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "top", shift: 0}}>
        <:trigger>Shift 0</:trigger>
        <:content>Centered along the placement edge</:content>
      </.tooltip>
      <.tooltip positioning={%Corex.Positioning{placement: "top", shift: 32}}>
        <:trigger>Shift 32</:trigger>
        <:content>Tooltip slid along the edge</:content>
      </.tooltip>
    </div>
    """
  end

  def patterns_multi_trigger_heex do
    ~S"""
    <.tooltip
      
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
          
          show_arrow={false}
          trigger_tag={:span}
        >
          <:trigger>
            <.navigate to={~p"/admins"} type="navigate"  >
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
        
        show_arrow={false}
        trigger_tag={:span}
        on_trigger_value_change="tooltip_pattern_link_multi_value"
      >
        <:trigger :for={user <- @users} value={user.id}>
          <.navigate to={~p"/admins"} type="navigate"  >
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

  def api_set_open_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} size="sm">Open</.action>
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} size="sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-cb" >
      <:trigger>Hover or focus</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4 items-center">
      <div class="layout__row">
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} size="sm">
          Open
        </.action>
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} size="sm">
          Close
        </.action>
      </div>
      <.tooltip id="tooltip-api-cb">
        <:trigger>Hover or focus</:trigger>
        <:content>Tooltip content</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_client_js_heex do
    ~S"""
    <div class="layout__row">
      <button
        type="button"
        size="sm"
        onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
      >
        Open
      </button>
      <button
        type="button"
        size="sm"
        onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: false } }))"
      >
        Close
      </button>
    </div>
    <.tooltip id="tooltip-api-cjs" >
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
      <div class="layout__row">
        <button
          type="button"
          size="sm"
          onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
        >
          Open
        </button>
        <button
          type="button"
          size="sm"
          onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: false } }))"
        >
          Close
        </button>
      </div>
      <.tooltip id="tooltip-api-cjs">
        <:trigger>Target</:trigger>
        <:content>Tooltip</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="tooltip_api_open" size="sm">Open</.action>
      <.action phx-click="tooltip_api_close" size="sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-srv" >
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
      <div class="layout__row">
        <.action phx-click="tooltip_api_open" size="sm">Open</.action>
        <.action phx-click="tooltip_api_close" size="sm">Close</.action>
      </div>
      <.tooltip id="tooltip-api-srv">
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
    <div class="layout__row">
      <.action phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", true)} size="sm">Open</.action>
      <.action phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", false)} size="sm">Close</.action>
    </div>
    <.tooltip >
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
      <div class="layout__row">
        <.action
          phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", true)}
          size="sm"
        >
          Open
        </.action>
        <.action
          phx-click={Corex.Tooltip.set_open("tooltip-patterns-set-open", false)}
          size="sm"
        >
          Close
        </.action>
      </div>
      <.tooltip id="tooltip-patterns-set-open">
        <:trigger>Hover or buttons</:trigger>
        <:content>Open state from Corex.Tooltip.set_open/2</:content>
      </.tooltip>
    </div>
    """
  end

  def events_server_heex do
    ~S"""
    <.tooltip
      
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

  def styling_semantic_code do
    ~S"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip >
        <:trigger>Default</:trigger>
        <:content>Neutral surface</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--accent">
        <:trigger>Accent</:trigger>
        <:content>tooltip--accent</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--brand">
        <:trigger>Brand</:trigger>
        <:content>tooltip--brand</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--alert">
        <:trigger>Alert</:trigger>
        <:content>tooltip--alert</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--success">
        <:trigger>Success</:trigger>
        <:content>tooltip--success</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--info">
        <:trigger>Info</:trigger>
        <:content>tooltip--info</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--selected">
        <:trigger>Selected</:trigger>
        <:content>tooltip--selected</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip>
        <:trigger>Default</:trigger>
        <:content>Neutral surface</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--accent">
        <:trigger>Accent</:trigger>
        <:content>tooltip--accent</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--brand">
        <:trigger>Brand</:trigger>
        <:content>tooltip--brand</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--alert">
        <:trigger>Alert</:trigger>
        <:content>tooltip--alert</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--success">
        <:trigger>Success</:trigger>
        <:content>tooltip--success</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--info">
        <:trigger>Info</:trigger>
        <:content>tooltip--info</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--selected">
        <:trigger>Selected</:trigger>
        <:content>tooltip--selected</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip class="tooltip tooltip--sm">
        <:trigger>Sm</:trigger>
        <:content>tooltip--sm</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--md">
        <:trigger>Md</:trigger>
        <:content>tooltip--md</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--lg">
        <:trigger>Lg</:trigger>
        <:content>tooltip--lg</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--xl">
        <:trigger>Xl</:trigger>
        <:content>tooltip--xl</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip class="tooltip tooltip--sm">
        <:trigger>Sm</:trigger>
        <:content>tooltip--sm</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--md">
        <:trigger>Md</:trigger>
        <:content>tooltip--md</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--lg">
        <:trigger>Lg</:trigger>
        <:content>tooltip--lg</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--xl">
        <:trigger>Xl</:trigger>
        <:content>tooltip--xl</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_text_code do
    ~S"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip class="tooltip tooltip--text-sm">
        <:trigger>Text sm</:trigger>
        <:content>tooltip--text-sm</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-xl">
        <:trigger>Text xl</:trigger>
        <:content>tooltip--text-xl</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-2xl">
        <:trigger>Text 2xl</:trigger>
        <:content>tooltip--text-2xl</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-4xl">
        <:trigger>Text 4xl</:trigger>
        <:content>tooltip--text-4xl</:content>
      </.tooltip>
    </div>
    """
  end

  def styling_text_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row flex-wrap gap-2">
      <.tooltip class="tooltip tooltip--text-sm">
        <:trigger>Text sm</:trigger>
        <:content>tooltip--text-sm</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-xl">
        <:trigger>Text xl</:trigger>
        <:content>tooltip--text-xl</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-2xl">
        <:trigger>Text 2xl</:trigger>
        <:content>tooltip--text-2xl</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--text-4xl">
        <:trigger>Text 4xl</:trigger>
        <:content>tooltip--text-4xl</:content>
      </.tooltip>
    </div>
    """
  end
end
