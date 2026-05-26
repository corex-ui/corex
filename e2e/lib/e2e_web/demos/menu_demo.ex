defmodule E2eWeb.Demos.MenuDemo do
  use E2eWeb, :html

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
    <div class="layout__row">
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} class="button button--sm">Open</.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} class="button button--sm">Close</.action>
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
    <div class="layout__row">
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} class="button button--sm">
        Open
      </.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} class="button button--sm">
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
    <div class="layout__row">
      <button type="button" data-menu-api-open class="button button--sm">Open</button>
      <button type="button" data-menu-api-close class="button button--sm">Close</button>
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
      <div class="layout__row">
        <button type="button" data-menu-api-open class="button button--sm">Open</button>
        <button type="button" data-menu-api-close class="button button--sm">Close</button>
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
    <div class="layout__row">
      <.action phx-click="menu_api_server_open" class="button button--sm">Open</.action>
      <.action phx-click="menu_api_server_close" class="button button--sm">Close</.action>
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
    <div class="layout__row">
      <.action phx-click="menu_api_server_open" class="button button--sm">Open</.action>
      <.action phx-click="menu_api_server_close" class="button button--sm">Close</.action>
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
end
