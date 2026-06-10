defmodule E2eWeb.Demos.MenuDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

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
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} size="sm">Open</.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} size="sm">Close</.action>
    </div>

    <.menu
      id="menu-api"
      
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
      <.action phx-click={Corex.Menu.set_open("menu-api", true)} size="sm">
        Open
      </.action>
      <.action phx-click={Corex.Menu.set_open("menu-api", false)} size="sm">
        Close
      </.action>
    </div>

    <.menu
      id="menu-api"
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
      <button type="button" data-menu-api-open size="sm">Open</button>
      <button type="button" data-menu-api-close size="sm">Close</button>
    </div>

    <.menu
      id="menu-api-js"
      
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
        <button type="button" data-menu-api-open size="sm">Open</button>
        <button type="button" data-menu-api-close size="sm">Close</button>
      </div>

      <.menu
        id="menu-api-js"
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
      <.action phx-click="menu_api_server_open" size="sm">Open</.action>
      <.action phx-click="menu_api_server_close" size="sm">Close</.action>
    </div>

    <.menu
      id="menu-api-server"
      
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
      <.action phx-click="menu_api_server_open" size="sm">Open</.action>
      <.action phx-click="menu_api_server_close" size="sm">Close</.action>
    </div>

    <.menu
      id="menu-api-server"
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
    <.menu  redirect items={[
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
    <.menu id="menu-pattern-redirect" redirect items={patterns_redirect_items()}>
      <:trigger>Navigate</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def patterns_redirect_external_code do
    ~S"""
    <.menu
      
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

  def styling_semantic_code do
    items = styling_items_attr()

    """
    <.menu  value="menu" #{items}>
      <:trigger>Default</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--semantic-accent" value="menu" #{items}>
      <:trigger>Accent</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--semantic-brand" value="menu" #{items}>
      <:trigger>Brand</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--semantic-alert" value="menu" #{items}>
      <:trigger>Alert</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--semantic-info" value="menu" #{items}>
      <:trigger>Info</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--semantic-success" value="menu" #{items}>
      <:trigger>Success</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def styling_semantic_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-color-default" class="menu w-full" items={@items} value="menu">
        <:trigger>Default</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-accent" class="menu menu--semantic-accent w-full" items={@items} value="menu">
        <:trigger>Accent</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-brand" class="menu menu--semantic-brand w-full" items={@items} value="menu">
        <:trigger>Brand</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-alert" class="menu menu--semantic-alert w-full" items={@items} value="menu">
        <:trigger>Alert</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-color-info" class="menu menu--semantic-info w-full" items={@items} value="menu">
        <:trigger>Info</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu
        id="menu-style-color-success"
        class="menu menu--semantic-success w-full"
        items={@items}
        value="menu"
      >
        <:trigger>Success</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end

  def styling_size_code do
    items = styling_items_attr()

    """
    <.menu class="menu menu--size-sm" #{items}>
      <:trigger>SM</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--size-md" #{items}>
      <:trigger>MD</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--size-lg" #{items}>
      <:trigger>LG</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    <.menu class="menu menu--size-xl" #{items}>
      <:trigger>XL</:trigger>
      <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
    </.menu>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :items, demo_leaf_items())

    ~H"""
    <div class="flex flex-col gap-4 max-w-md">
      <.menu id="menu-style-size-sm" class="menu menu--size-sm w-full" items={@items}>
        <:trigger>SM</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-md" class="menu menu--size-md w-full" items={@items}>
        <:trigger>MD</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-lg" class="menu menu--size-lg w-full" items={@items}>
        <:trigger>LG</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
      <.menu id="menu-style-size-xl" class="menu menu--size-xl w-full" items={@items}>
        <:trigger>XL</:trigger>
        <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
      </.menu>
    </div>
    """
  end

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:menu, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
