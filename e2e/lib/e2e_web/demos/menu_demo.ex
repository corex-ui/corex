defmodule E2eWeb.Demos.MenuDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def demo_leaf_items do
    [
      %Corex.Tree.Item{value: "menu", label: "Menu"},
      %Corex.Tree.Item{value: "combobox", label: "Combobox"},
      %Corex.Tree.Item{value: "select", label: "Select"}
    ]
  end

  def anatomy_shared_leaf_items, do: demo_leaf_items()

  def anatomy_minimal_code do
    ~S"""
    <.menu
      class="menu"
      items={[
        %Corex.Tree.Item{
          value: "edit",
          label: "Edit"
        },
        %Corex.Tree.Item{
          value: "duplicate",
          label: "Duplicate"
        },
        %Corex.Tree.Item{
          value: "delete",
          label: "Delete"
        }
      ]}
    >
      <:trigger>Actions</:trigger>
      <:indicator>
        <.heroicon name="hero-chevron-down" />
      </:indicator>
    </.menu>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.menu
      id="menu-anatomy-minimal"
      class="menu"
      items={demo_leaf_items()}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def basic_code, do: anatomy_minimal_code()
  def basic_example(assigns), do: anatomy_minimal_example(assigns)

  def demo_grouped_items do
    [
      %Corex.Tree.Item{value: "combobox", label: "Combobox", group: "Pickers"},
      %Corex.Tree.Item{value: "listbox", label: "Listbox", group: "Pickers"},
      %Corex.Tree.Item{value: "menu", label: "Menu", group: "Overlays"},
      %Corex.Tree.Item{value: "dialog", label: "Dialog", group: "Overlays"}
    ]
  end

  def anatomy_grouped_code do
    ~S"""
    <.menu
      class="menu"
      items={[
        %Corex.Tree.Item{
          value: "edit",
          label: "Edit",
          group: "Actions"
        },
        %Corex.Tree.Item{
          value: "duplicate",
          label: "Duplicate",
          group: "Actions"
        },
        %Corex.Tree.Item{
          value: "account-1",
          label: "Account 1",
          group: "Accounts"
        },
        %Corex.Tree.Item{
          value: "account-2",
          label: "Account 2",
          group: "Accounts"
        }
      ]}
    >
      <:trigger>Actions</:trigger>
      <:indicator>
        <.heroicon name="hero-chevron-down" />
      </:indicator>
    </.menu>
    """
  end

  def anatomy_grouped_example(assigns) do
    ~H"""
    <.menu
      id="menu-anatomy-grouped"
      class="menu"
      items={demo_grouped_items()}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def grouped_code, do: anatomy_grouped_code()
  def grouped_example(assigns), do: anatomy_grouped_example(assigns)

  def anatomy_nested_code do
    ~S"""
    <.menu
      class="menu"
      items={[
        %Corex.Tree.Item{
          value: "new-tab",
          label: "New tab"
        },
        %Corex.Tree.Item{
          value: "share",
          label: "Share",
          children: [
            %Corex.Tree.Item{
              value: "messages",
              label: "Messages"
            },
            %Corex.Tree.Item{
              value: "airdrop",
              label: "Airdrop"
            },
            %Corex.Tree.Item{
              value: "whatsapp",
              label: "WhatsApp"
            }
          ]
        },
        %Corex.Tree.Item{
          value: "print",
          label: "Print"
        }
      ]}
    >
      <:trigger>Click me</:trigger>
    </.menu>
    """
  end

  def nested_menu_code do
    ~S"""
    <.menu
      class="menu"
      items={[
        %Corex.Tree.Item{
          value: "share",
          label: "Share",
          children: [
            %Corex.Tree.Item{value: "messages", label: "Messages"}
          ]
        }
      ]}
    >
      <:trigger>Click me</:trigger>
      <:nested_indicator>
        <.heroicon name="hero-arrow-right" />
      </:nested_indicator>
    </.menu>
    """
  end

  def anatomy_nested_example(assigns) do
    ~H"""
    <.menu
      id="menu-anatomy-nested"
      class="menu"
      items={[
        %Corex.Tree.Item{value: "listbox", label: "Listbox"},
        %Corex.Tree.Item{
          value: "corex",
          label: "Corex",
          children: demo_nested_flat_children()
        },
        %Corex.Tree.Item{value: "tabs", label: "Tabs"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      <:nested_indicator><.heroicon name="hero-chevron-right" /></:nested_indicator>
    </.menu>
    """
  end

  def nested_code, do: anatomy_nested_code()
  def nested_example(assigns), do: anatomy_nested_example(assigns)

  def demo_nested_grouped_children do
    [
      %Corex.Tree.Item{value: "combobox", label: "Combobox", group: "Pickers"},
      %Corex.Tree.Item{value: "date-picker", label: "Date picker", group: "Pickers"},
      %Corex.Tree.Item{value: "menu", label: "Menu", group: "Overlays"},
      %Corex.Tree.Item{value: "dialog", label: "Dialog", group: "Overlays"}
    ]
  end

  def demo_nested_flat_children do
    [
      %Corex.Tree.Item{value: "combobox", label: "Combobox"},
      %Corex.Tree.Item{value: "date-picker", label: "Date picker"},
      %Corex.Tree.Item{value: "menu", label: "Menu"},
      %Corex.Tree.Item{value: "dialog", label: "Dialog"}
    ]
  end

  def anatomy_nested_grouped_code do
    ~S"""
    <.menu
      class="menu"
      items={[
        %Corex.Tree.Item{value: "tabs", label: "Tabs"},
        %Corex.Tree.Item{
          value: "corex",
          label: "Corex",
          children: [
            %Corex.Tree.Item{value: "combobox", label: "Combobox", group: "Pickers"},
            %Corex.Tree.Item{value: "date-picker", label: "Date picker", group: "Pickers"},
            %Corex.Tree.Item{value: "menu", label: "Menu", group: "Overlays"},
            %Corex.Tree.Item{value: "dialog", label: "Dialog", group: "Overlays"}
          ]
        }
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      <:nested_indicator><.heroicon name="hero-chevron-right" /></:nested_indicator>
    </.menu>
    """
  end

  def anatomy_nested_grouped_example(assigns) do
    ~H"""
    <.menu
      id="menu-anatomy-nested-grouped"
      class="menu"
      items={[
        %Corex.Tree.Item{value: "tabs", label: "Tabs"},
        %Corex.Tree.Item{
          value: "corex",
          label: "Corex",
          children: demo_nested_grouped_children()
        }
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      <:nested_indicator><.heroicon name="hero-chevron-right" /></:nested_indicator>
    </.menu>
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} class="button ui-size-sm">Open</.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} class="button ui-size-sm">Close</.action>
    </div>

    <.menu
      id="menu-api"
      class="menu"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} class="button ui-size-sm">
        Open
      </.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} class="button ui-size-sm">
        Close
      </.action>
    </div>

    <.menu
      id="menu-api"
      class="menu"
      items={demo_leaf_items()}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def api_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" data-menu-api-open class="button ui-size-sm">Open</button>
      <button type="button" data-menu-api-close class="button ui-size-sm">Close</button>
    </div>

    <.menu
      id="menu-api-js"
      class="menu"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def api_client_js_js do
    ~S"""
    const root = document.getElementById("menu:menu-api-js");
    document.querySelector("[data-menu-api-open]")?.addEventListener("click", () => {
      root?.dispatchEvent(new CustomEvent("corex:menu:set-open", { bubbles: false, detail: { open: true } }));
    });
    document.querySelector("[data-menu-api-close]")?.addEventListener("click", () => {
      root?.dispatchEvent(new CustomEvent("corex:menu:set-open", { bubbles: false, detail: { open: false } }));
    });
    """
  end

  def api_client_js_ts do
    ~S"""
    const root: HTMLElement | null = document.getElementById("menu:menu-api-js");
    document.querySelector("[data-menu-api-open]")?.addEventListener("click", () => {
      root?.dispatchEvent(
        new CustomEvent<{ open: boolean }>("corex:menu:set-open", { bubbles: false, detail: { open: true } })
      );
    });
    document.querySelector("[data-menu-api-close]")?.addEventListener("click", () => {
      root?.dispatchEvent(
        new CustomEvent<{ open: boolean }>("corex:menu:set-open", { bubbles: false, detail: { open: false } })
      );
    });
    """
  end

  def api_client_js_example(assigns) do
    ~H"""
    <div id="menu-api-js-demo" phx-update="ignore" phx-hook=".MenuApiJsDemo">
      <div class="flex flex-wrap items-center gap-space">
        <button type="button" data-menu-api-open class="button ui-size-sm">Open</button>
        <button type="button" data-menu-api-close class="button ui-size-sm">Close</button>
      </div>

      <.menu
        id="menu-api-js"
        class="menu"
        items={demo_leaf_items()}
      >
        <:trigger>Corex</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <script :type={Phoenix.LiveView.ColocatedHook} name=".MenuApiJsDemo">
        export default {
          mounted() {
            const root = document.getElementById("menu:menu-api-js");
            this.el.querySelector("[data-menu-api-open]")?.addEventListener("click", () => {
              root?.dispatchEvent(
                new CustomEvent("corex:menu:set-open", { bubbles: false, detail: { open: true } })
              );
            });
            this.el.querySelector("[data-menu-api-close]")?.addEventListener("click", () => {
              root?.dispatchEvent(
                new CustomEvent("corex:menu:set-open", { bubbles: false, detail: { open: false } })
              );
            });
          }
        }
      </script>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="menu_api_server_open" class="button ui-size-sm">Open</.action>
      <.action phx-click="menu_api_server_close" class="button ui-size-sm">Close</.action>
    </div>

    <.menu
      id="menu-api-server"
      class="menu"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("menu_api_server_open", _, socket) do
      {:noreply, Corex.Menu.set_open(socket, "menu-api-server", true)}
    end

    def handle_event("menu_api_server_close", _, socket) do
      {:noreply, Corex.Menu.set_open(socket, "menu-api-server", false)}
    end
    """
  end

  def api_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="menu_api_server_open" class="button ui-size-sm">Open</.action>
      <.action phx-click="menu_api_server_close" class="button ui-size-sm">Close</.action>
    </div>

    <.menu
      id="menu-api-server"
      class="menu"
      items={demo_leaf_items()}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def events_binding_code do
    ~S"""
    <.menu
      class="menu"
      on_select="menu_bind_selected"
      on_open_change="menu_bind_open"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def events_binding_example(assigns) do
    ~H"""
    <.menu
      id="menu-events-bind"
      class="menu"
      on_select="menu_bind_selected"
      on_open_change="menu_bind_open"
      items={demo_leaf_items()}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def events_binding_elixir do
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"menu_bind_open", ~S|%{"open" => open, "id" => id} = params|},
      {"menu_bind_selected", ~S|%{"value" => value, "id" => id} = params|}
    ])
  end

  def events_server_heex do
    ~S"""
    <.menu
      class="menu"
      on_select="menu_selected"
      on_open_change="menu_open_changed"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"menu_open_changed", ~S|%{"open" => open, "id" => id} = params|},
      {"menu_selected", ~S|%{"value" => value, "id" => id} = params|}
    ])
  end

  def events_client_heex do
    ~S"""
    <.menu
      id="menu-events-client"
      class="menu"
      on_select_client="menu-item-selected"
      on_open_change_client="menu-open-changed"
      items={[
        %Corex.Tree.Item{value: "menu", label: "Menu"},
        %Corex.Tree.Item{value: "combobox", label: "Combobox"},
        %Corex.Tree.Item{value: "select", label: "Select"}
      ]}
    >
      <:trigger>Corex</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("menu:menu-events-client");
    el?.addEventListener("menu-open-changed", (e) => console.log(e.detail));
    el?.addEventListener("menu-item-selected", (e) => console.log(e.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("menu:menu-events-client");
    el?.addEventListener("menu-open-changed", (e: Event) =>
      console.log((e as CustomEvent<unknown>).detail)
    );
    el?.addEventListener("menu-item-selected", (e: Event) =>
      console.log((e as CustomEvent<unknown>).detail)
    );
    """
  end

  def patterns_redirect_code do
    items = patterns_redirect_items()

    item_lines =
      Enum.map_join(items, ",\n      ", fn item ->
        ~s|%Corex.Tree.Item{value: #{inspect(item.value)}, label: #{inspect(item.label)}}|
      end)

    """
    <.menu class="menu" redirect items={[
      #{item_lines}
    ]}>
      <:trigger>Navigate</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_items do
    [
      %Corex.Tree.Item{value: ~p"/menu/anatomy", label: "Anatomy"},
      %Corex.Tree.Item{value: ~p"/menu/api", label: "API"}
    ]
  end

  def patterns_redirect_example(assigns) do
    ~H"""
    <.menu id="menu-pattern-redirect" class="menu" redirect items={patterns_redirect_items()}>
      <:trigger>Navigate</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_external_code do
    ~S"""
    <.menu
      class="menu"
      redirect
      items={[
        %Corex.Tree.Item{value: "https://zagjs.com/components/react/menu", label: "Zag menu", new_tab: true},
        %Corex.Tree.Item{value: "https://hexdocs.pm/phoenix_live_view/", label: "Phoenix LiveView", new_tab: true}
      ]}
    >
      <:trigger>External</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_external_example(assigns) do
    ~H"""
    <.menu
      id="menu-pattern-external"
      class="menu"
      redirect
      items={[
        %Corex.Tree.Item{
          value: "https://zagjs.com/components/react/menu",
          label: "Zag menu",
          new_tab: true
        },
        %Corex.Tree.Item{
          value: "https://hexdocs.pm/phoenix_live_view/",
          label: "Phoenix LiveView",
          new_tab: true
        }
      ]}
    >
      <:trigger>External</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_types_code do
    items = patterns_redirect_types_items()

    item_lines =
      Enum.map_join(items, ",\n        ", fn item ->
        ~s|%Corex.Tree.Item{value: #{inspect(item.value)}, label: #{inspect(item.label)}, redirect: #{inspect(item.redirect)}}|
      end)

    """
    <.menu
      class="menu"
      redirect
      items={[
        #{item_lines}
      ]}
    >
      <:trigger>Redirect kinds</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_types_items do
    [
      %Corex.Tree.Item{value: ~p"/menu/playground", label: "href (default)", redirect: :href},
      %Corex.Tree.Item{value: ~p"/menu/events", label: "LiveView navigate", redirect: :navigate}
    ]
  end

  def patterns_redirect_types_example(assigns) do
    ~H"""
    <.menu
      id="menu-pattern-types"
      class="menu"
      redirect
      items={patterns_redirect_types_items()}
    >
      <:trigger>Redirect kinds</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  defp styling_items_attr do
    ~S|items={[
      %Corex.Tree.Item{value: "menu", label: "Menu"},
      %Corex.Tree.Item{value: "combobox", label: "Combobox"},
      %Corex.Tree.Item{value: "select", label: "Select"}
    ]}|
  end

  def styling_color_code do
    items = styling_items_attr()

    """
    <.menu class="menu" value="menu" #{items}>
      <:trigger>Default</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-accent" value="menu" #{items}>
      <:trigger>Accent</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-brand" value="menu" #{items}>
      <:trigger>Brand</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-alert" value="menu" #{items}>
      <:trigger>Alert</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-info" value="menu" #{items}>
      <:trigger>Info</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-success" value="menu" #{items}>
      <:trigger>Success</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def styling_color_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-color-default" class="menu w-full" items={@items} value="menu">
        <:trigger>Default</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-accent" class="menu ui-accent w-full" items={@items} value="menu">
        <:trigger>Accent</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-brand" class="menu ui-brand w-full" items={@items} value="menu">
        <:trigger>Brand</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-alert" class="menu ui-alert w-full" items={@items} value="menu">
        <:trigger>Alert</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-info" class="menu ui-info w-full" items={@items} value="menu">
        <:trigger>Info</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu
        id="menu-style-color-success"
        class="menu ui-success w-full"
        items={@items}
        value="menu"
      >
        <:trigger>Success</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end

  def styling_variant_code do
    items = styling_items_attr()

    """
    <.menu class="menu" value="menu" #{items}>
      <:trigger>Subtle (default)</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-solid" value="menu" #{items}>
      <:trigger>Solid</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>

    """
  end

  def styling_variant_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-variant-subtle" class="menu w-full" items={@items} value="menu">
        <:trigger>Subtle (default)</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu
        id="menu-style-variant-solid"
        class="menu ui-solid w-full"
        items={@items}
        value="menu"
      >
        <:trigger>Solid</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end

  def styling_variant_matrix_code do
    items = styling_items_attr()

    for semantic <- DemoScales.styling_semantic_axis_steps("menu"),
        variant <- DemoScales.styling_variant_axis_steps("menu") do
      class = DemoScales.join_matrix_modifiers("menu", semantic.modifier, variant.modifier)

      """
      <.menu class="#{class}" value="menu" #{items}>
        <:trigger>#{semantic.label}</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:items, demo_leaf_items())
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("menu"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("menu"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.menu
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("menu", semantic.modifier, variant.modifier) <> " w-full"}
            items={@items}
            value="menu"
          >
            <:trigger>{semantic.label}</:trigger>
            <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
          </.menu>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    items = styling_items_attr()

    """
    <.menu class="menu ui-size-sm" #{items}>
      <:trigger>SM</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-size-md" #{items}>
      <:trigger>MD</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-size-lg" #{items}>
      <:trigger>LG</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-size-xl" #{items}>
      <:trigger>XL</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-size-sm" class="menu ui-size-sm w-full" items={@items}>
        <:trigger>SM</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-md" class="menu ui-size-md w-full" items={@items}>
        <:trigger>MD</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-lg" class="menu ui-size-lg w-full" items={@items}>
        <:trigger>LG</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-xl" class="menu ui-size-xl w-full" items={@items}>
        <:trigger>XL</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end

  def styling_rounded_code do
    items = styling_items_attr()

    """
    <.menu class="menu ui-rounded-none" #{items}>
      <:trigger>None</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-rounded-sm" #{items}>
      <:trigger>SM</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-rounded-md" #{items}>
      <:trigger>MD</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-rounded-lg" #{items}>
      <:trigger>LG</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-rounded-xl" #{items}>
      <:trigger>XL</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu ui-rounded-full" #{items}>
      <:trigger>Full</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def styling_rounded_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-rounded-none" class="menu ui-rounded-none w-full" items={@items}>
        <:trigger>None</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-rounded-sm" class="menu ui-rounded-sm w-full" items={@items}>
        <:trigger>SM</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-rounded-md" class="menu ui-rounded-md w-full" items={@items}>
        <:trigger>MD</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-rounded-lg" class="menu ui-rounded-lg w-full" items={@items}>
        <:trigger>LG</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-rounded-xl" class="menu ui-rounded-xl w-full" items={@items}>
        <:trigger>XL</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-rounded-full" class="menu ui-rounded-full w-full" items={@items}>
        <:trigger>Full</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end
end
