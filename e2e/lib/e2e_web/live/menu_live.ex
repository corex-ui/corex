defmodule E2eWeb.MenuLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Menu.set_open(socket, "my-menu", value == "true")}
  end

  def handle_event("handle_on_select", %{"id" => _id, "value" => value}, socket) do
    IO.inspect(value, label: "value")
    {:noreply, push_navigate(socket, to: "#{value}")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Menu</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Menu.set_open("my-menu", true)}
          class="button button--sm"
        >
          Open menu
        </button>
        <button
          phx-click={Corex.Menu.set_open("my-menu", false)}
          class="button button--sm"
        >
          Close menu
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="true" class="button button--sm">
          Open menu
        </button>
        <button
          phx-click="set_value"
          value="false"
          class="button button--sm"
        >
          Close menu
        </button>
      </div>

      <.menu
        class="menu"
        id="my-menu"
        items={[
          %Corex.Tree.Item{
            id: "edit",
            label: "Edit"
          },
          %Corex.Tree.Item{
            id: "duplicate",
            label: "Duplicate"
          },
          %Corex.Tree.Item{
            id: "delete",
            label: "Delete"
          }
        ]}
      >
        <:trigger>File</:trigger>
        <:indicator>
          <.icon name="hero-chevron-down" />
        </:indicator>
      </.menu>
      <.menu
        class="menu"
        items={[
          %Corex.Tree.Item{
            id: "new-tab",
            label: "New tab"
          },
          %Corex.Tree.Item{
            id: "share",
            label: "Share",
            children: [
              %Corex.Tree.Item{
                id: "messages",
                label: "Messages"
              },
              %Corex.Tree.Item{
                id: "airdrop",
                label: "Airdrop"
              },
              %Corex.Tree.Item{
                id: "whatsapp",
                label: "WhatsApp"
              }
            ]
          },
          %Corex.Tree.Item{
            id: "print",
            label: "Print..."
          }
        ]}
      >
        <:trigger>Menu</:trigger>
        <:indicator>
          <.icon name="hero-chevron-down" />
        </:indicator>
        <:nested_indicator>
          <.icon name="hero-chevron-right" />
        </:nested_indicator>
      </.menu>

      <.menu
        class="menu"
        items={[
          %Corex.Tree.Item{
            id: "edit",
            label: "Edit",
            group: "Actions"
          },
          %Corex.Tree.Item{
            id: "duplicate",
            label: "Duplicate",
            group: "Actions"
          },
          %Corex.Tree.Item{
            id: "account-1",
            label: "Account 1",
            group: "Accounts"
          },
          %Corex.Tree.Item{
            id: "account-2",
            label: "Account 2",
            group: "Accounts"
          }
        ]}
      >
        <:trigger>Actions</:trigger>
        <:indicator>
          <.icon name="hero-chevron-down" />
        </:indicator>
      </.menu>

      <.menu
        class="menu"
        redirect
        on_select="handle_on_select"
        items={menu_items(@locale)}
      >
        <:trigger>Corex</:trigger>
        <:indicator>
          <.icon name="hero-chevron-down" />
        </:indicator>
        <:nested_indicator>
          <.icon name="hero-chevron-right" />
        </:nested_indicator>
        <:item :let={item}>
          {item.label}
        </:item>
      </.menu>
    </Layouts.app>
    """
  end

  defp menu_items(locale) do
    Corex.Tree.new([
      [
        label: "Accordion",
        id: "/#{locale}/accordion"
      ],
      [
        label: "Checkbox",
        id: "checkbox",
        children: [
          [label: "Controller", id: "/#{locale}/checkbox"],
          [label: "Live", id: "/#{locale}/live/checkbox"]
        ]
      ],
      [
        label: "Clipboard",
        id: "clipboard",
        children: [
          [label: "Controller", id: "/#{locale}/clipboard"],
          [label: "Live", id: "/#{locale}/live/clipboard"]
        ]
      ],
      [
        label: "Collapsible",
        id: "collapsible",
        children: [
          [label: "Controller", id: "/#{locale}/collapsible"],
          [label: "Live", id: "/#{locale}/live/collapsible"]
        ]
      ],
      [
        label: "Combobox",
        id: "combobox",
        children: [
          [label: "Controller", id: "/#{locale}/combobox"],
          [label: "Live", id: "/#{locale}/live/combobox"]
        ]
      ]
    ])
  end
end
