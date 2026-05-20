defmodule E2eWeb.AccordionApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_sv_client "api-set-value-client"
  @id_sv_js "api-set-value-client-js"
  @id_sv_server "api-set-value-server"
  @id_val_client "api-value-client"
  @id_val_js "api-value-client-js"
  @id_val_server "api-value-server"
  @id_foc_client "api-focused-client"
  @id_foc_js "api-focused-client-js"
  @id_foc_server "api-focused-server"
  @id_item_client "api-item-client"
  @id_item_js "api-item-client-js"
  @id_item_server "api-item-server"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_sv_client, @id_sv_client)
      |> assign(:id_sv_js, @id_sv_js)
      |> assign(:id_sv_server, @id_sv_server)
      |> assign(:id_val_client, @id_val_client)
      |> assign(:id_val_js, @id_val_js)
      |> assign(:id_val_server, @id_val_server)
      |> assign(:id_foc_client, @id_foc_client)
      |> assign(:id_foc_js, @id_foc_js)
      |> assign(:id_foc_server, @id_foc_server)
      |> assign(:id_item_client, @id_item_client)
      |> assign(:id_item_js, @id_item_js)
      |> assign(:id_item_server, @id_item_server)
      |> assign(:codes, demo_codes())

    {:ok, socket}
  end

  defp demo_codes do
    m = E2eWeb.Demos.AccordionDemo

    %{
      set_value_binding: m.api_set_value_client_binding_code(),
      set_value_server_heex: m.api_set_value_server_heex(),
      set_value_server_elixir: m.api_set_value_server_elixir(),
      set_value_js: m.api_set_value_client_js_js(),
      set_value_js_ts: m.api_set_value_client_js_ts(),
      set_value_js_heex: m.api_set_value_client_js_heex(),
      value_client_heex: m.api_value_client_heex(),
      value_server_heex: m.api_value_server_heex(),
      value_elixir: m.api_value_server_elixir(),
      value_js_heex: m.api_value_client_js_heex(),
      value_js: m.api_value_client_js_js(),
      value_js_ts: m.api_value_client_js_ts(),
      focused_client_heex: m.api_focused_client_heex(),
      focused_server_heex: m.api_focused_server_heex(),
      focused_elixir: m.api_focused_server_elixir(),
      focused_js_heex: m.api_focused_client_js_heex(),
      focused_js: m.api_focused_client_js_js(),
      focused_js_ts: m.api_focused_client_js_ts(),
      item_state_client_heex: m.api_item_state_client_heex(),
      item_state_server_heex: m.api_item_state_server_heex(),
      item_state_elixir: m.api_item_state_server_elixir(),
      item_state_js_heex: m.api_item_state_client_js_heex(),
      item_state_js: m.api_item_state_client_js_js(),
      item_state_js_ts: m.api_item_state_client_js_ts()
    }
  end

  def handle_event("api_set_value_server", %{"value" => value}, socket) do
    {:noreply, Corex.Accordion.set_value(socket, @id_sv_server, value)}
  end

  def handle_event("api_value_server", _params, socket) do
    {:noreply, Corex.Accordion.value(socket, @id_val_server)}
  end

  def handle_event("api_value_server_client_only", _params, socket) do
    {:noreply, Corex.Accordion.value(socket, @id_val_server, respond_to: :client)}
  end

  def handle_event("api_focused_client", _params, socket) do
    Process.send_after(self(), {:accordion_api_focused_after_delay, @id_foc_client, []}, 5_000)
    {:noreply, socket}
  end

  def handle_event("api_focused_client_client_only", _params, socket) do
    Process.send_after(
      self(),
      {:accordion_api_focused_after_delay, @id_foc_client, [respond_to: :client]},
      5_000
    )

    {:noreply, socket}
  end

  def handle_event("api_focused_js", _params, socket) do
    Process.send_after(self(), {:accordion_api_focused_after_delay, @id_foc_js, []}, 5_000)
    {:noreply, socket}
  end

  def handle_event("api_focused_js_client_only", _params, socket) do
    Process.send_after(
      self(),
      {:accordion_api_focused_after_delay, @id_foc_js, [respond_to: :client]},
      5_000
    )

    {:noreply, socket}
  end

  def handle_event("api_focused_server", _params, socket) do
    Process.send_after(self(), {:accordion_api_focused_after_delay, @id_foc_server, []}, 5_000)
    {:noreply, socket}
  end

  def handle_event("api_focused_server_client_only", _params, socket) do
    Process.send_after(
      self(),
      {:accordion_api_focused_after_delay, @id_foc_server, [respond_to: :client]},
      5_000
    )

    {:noreply, socket}
  end

  def handle_event("api_item_state_server_lorem", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, @id_item_server, "lorem", disabled: false)}
  end

  def handle_event("api_item_state_server_duis", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, @id_item_server, "duis", disabled: false)}
  end

  def handle_event("api_item_state_server_donec", _params, socket) do
    {:noreply, Corex.Accordion.item_state(socket, @id_item_server, "donec", disabled: true)}
  end

  def handle_event("accordion_value_response", %{"id" => id, "value" => value}, socket)
      when id in [@id_val_client, @id_val_js, @id_val_server] do
    {:noreply, toast_accordion_value(socket, id, value)}
  end

  def handle_event("accordion_focused_response", %{"id" => id, "value" => value}, socket)
      when id in [@id_foc_client, @id_foc_js, @id_foc_server] do
    {:noreply, toast_accordion_focused(socket, id, value)}
  end

  def handle_event(
        "accordion_item_state_response",
        %{"id" => id, "value" => v, "state" => state},
        socket
      )
      when id in [@id_item_client, @id_item_js, @id_item_server] do
    {:noreply, toast_accordion_item_state(socket, id, v, state)}
  end

  def handle_info({:accordion_api_focused_after_delay, accordion_id, opts}, socket)
      when is_binary(accordion_id) and is_list(opts) do
    {:noreply, Corex.Accordion.focused(socket, accordion_id, opts)}
  end

  defp toast_accordion_value(socket, id, value) do
    desc = "#{id}\n#{inspect(value)}"

    Corex.Toast.create(socket, "layout-toast", "accordion_value_response", desc, :info,
      duration: 5000
    )
  end

  defp toast_accordion_focused(socket, id, value) do
    desc = "#{id}\n#{inspect(value)}"

    Corex.Toast.create(
      socket,
      "layout-toast",
      "accordion_focused_response",
      desc,
      :info,
      duration: 5000
    )
  end

  defp toast_accordion_item_state(socket, id, v, state) do
    desc = "#{id} · #{inspect(v)}\n#{inspect(state)}"

    Corex.Toast.create(
      socket,
      "layout-toast",
      "accordion_item_state_response",
      desc,
      :info,
      duration: 5000
    )
  end

  def render(assigns) do
    assigns = assign(assigns, :demo_items, demo_items())

    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="accordion-api-page"
        title={~t"Accordion · API"}
        subtitle={~t"Control and interact with the accordion from LiveView or the client."}
      >
        <.demo_section
          id="accordion-api-set-value-binding"
          title={~t"Set Value (Client Binding)"}
          code={@codes.set_value_binding}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 mb-4">
              <.action
                phx-click={Corex.Accordion.set_value(@id_sv_client, "lorem")}
                class="button button--sm"
              >
                Open Lorem
              </.action>
              <.action
                phx-click={Corex.Accordion.set_value(@id_sv_client, ["lorem", "donec"])}
                class="button button--sm"
              >
                Lorem and Donec
              </.action>
              <.action
                phx-click={Corex.Accordion.set_value(@id_sv_client, [])}
                class="button button--sm"
              >
                Close all
              </.action>
            </div>
            <.accordion class="accordion" id={@id_sv_client} items={@demo_items}>
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>
        <.demo_section
          id="accordion-api-set-value-js"
          title={~t"Set Value (Client JS)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.set_value_js_heex
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: @codes.set_value_js
            },
            %{
              value: "ts",
              label: ~t"TS",
              language: :javascript,
              code: @codes.set_value_js_ts
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_set_value_client_js_example
              id={@id_sv_js}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-set-value-server"
          title={~t"Set Value (Server)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.set_value_server_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.set_value_server_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_set_value_server_example
              id={@id_sv_server}
              items={@demo_items}
              event="api_set_value_server"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-value-binding"
          title={~t"Value (Client Binding)"}
          code={@codes.value_client_heex}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_value_client_binding_example
              id={@id_val_client}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-value-js"
          title={~t"Value (Client JS)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.value_js_heex
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: @codes.value_js
            },
            %{
              value: "ts",
              label: ~t"TS",
              language: :javascript,
              code: @codes.value_js_ts
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_value_client_js_example
              id={@id_val_js}
              items={@demo_items}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-value-server"
          title={~t"Value (Server)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.value_server_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.value_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_value_server_example
              id={@id_val_server}
              items={@demo_items}
              event_value="api_value_server"
              event_value_client_only="api_value_server_client_only"
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-focused-binding"
          title={~t"Focused (Client Binding)"}
          code={@codes.focused_client_heex}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_focused_client_example
              id={@id_foc_client}
              items={@demo_items}
              event_focused="api_focused_client"
              event_focused_client_only="api_focused_client_client_only"
            />
            <p class="text-sm text-zinc-600 mt-2">
              Each trigger waits 5 seconds, then runs the focused read.
            </p>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-focused-js"
          title={~t"Focused (Client JS)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.focused_js_heex
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: @codes.focused_js
            },
            %{
              value: "ts",
              label: ~t"TS",
              language: :javascript,
              code: @codes.focused_js_ts
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_focused_client_js_example
              id={@id_foc_js}
              items={@demo_items}
              event_focused="api_focused_js"
              event_focused_client_only="api_focused_js_client_only"
            />
            <p class="text-sm text-zinc-600 mt-2">
              Each trigger waits 5 seconds, then runs the focused read.
            </p>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-focused-server"
          title={~t"Focused (Server)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.focused_server_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.focused_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_focused_server_example
              id={@id_foc_server}
              items={@demo_items}
              event_focused="api_focused_server"
              event_focused_client_only="api_focused_server_client_only"
            />
            <p class="text-sm text-zinc-600 mt-2">
              Each trigger waits 5 seconds, then runs the focused read.
            </p>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-item-state-binding"
          title={~t"Item State (Client Binding)"}
          code={@codes.item_state_client_heex}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_item_state_client_example
              id={@id_item_client}
              items={@demo_items}
              event_lorem={Corex.Accordion.item_state(@id_item_client, "lorem", disabled: false)}
              event_duis={Corex.Accordion.item_state(@id_item_client, "duis", disabled: false)}
              event_donec={Corex.Accordion.item_state(@id_item_client, "donec", disabled: true)}
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-item-state-js"
          title={~t"Item State (Client JS)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.item_state_js_heex
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: @codes.item_state_js
            },
            %{
              value: "ts",
              label: ~t"TS",
              language: :javascript,
              code: @codes.item_state_js_ts
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_item_state_client_js_example
              id={@id_item_js}
              items={@demo_items}
              event_lorem={
                JS.dispatch("corex:accordion:item-state",
                  to: "##{@id_item_js}",
                  detail: %{value: "lorem", disabled: false},
                  bubbles: false
                )
              }
              event_duis={
                JS.dispatch("corex:accordion:item-state",
                  to: "##{@id_item_js}",
                  detail: %{value: "duis", disabled: false},
                  bubbles: false
                )
              }
              event_donec={
                JS.dispatch("corex:accordion:item-state",
                  to: "##{@id_item_js}",
                  detail: %{value: "donec", disabled: true},
                  bubbles: false
                )
              }
            />
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-api-item-state-server"
          title={~t"Item State (Server)"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: @codes.item_state_server_heex
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: @codes.item_state_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.AccordionDemo.api_item_state_server_example
              id={@id_item_server}
              items={@demo_items}
              event_lorem="api_item_state_server_lorem"
              event_duis="api_item_state_server_duis"
              event_donec="api_item_state_server_donec"
            />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp demo_items do
    Corex.Content.new([
      %{
        value: "lorem",
        label: ~t"Lorem ipsum dolor sit amet",
        content: ~t"Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        value: "duis",
        label: ~t"Duis dictum gravida odio ac pharetra?",
        content: ~t"Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        value: "donec",
        label: ~t"Donec condimentum ex mi",
        content: ~t"Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  end
end
