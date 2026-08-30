defmodule E2eWeb.NativeAccordionApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.NativeAccordion
  alias E2eWeb.Demos.NativeAccordionDemo, as: Demo

  @id_sv_client "api-set-value-client"
  @all_values ~W(lorem duis donec)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_sv_client, @id_sv_client)
     |> assign(:all_values, @all_values)
     |> assign(:items, Demo.shared_items_full())
     |> assign(:set_value_binding, Demo.api_set_value_client_binding_code())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="native-accordion-api-page"
        title={~t"Native Accordion · API"}
        subtitle={~t"Drive open state with LiveView JS pipes (no Zag machine queries)."}
      >
        <.demo_section
          id="native-accordion-api-set-value"
          title={~t"set_value (client JS)"}
          code={@set_value_binding}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <div class="flex flex-wrap gap-space-sm justify-center">
                <.action
                  phx-click={
                    NativeAccordion.set_value(@id_sv_client, "lorem", all_values: @all_values)
                  }
                  class="button ui-size-sm"
                >
                  Open Lorem
                </.action>
                <.action
                  phx-click={
                    NativeAccordion.set_value(@id_sv_client, ["lorem", "donec"],
                      all_values: @all_values
                    )
                  }
                  class="button ui-size-sm"
                >
                  Lorem and Donec
                </.action>
                <.action
                  phx-click={NativeAccordion.set_value(@id_sv_client, [], all_values: @all_values)}
                  class="button ui-size-sm"
                >
                  Close all
                </.action>
              </div>
              <.native_accordion
                id={@id_sv_client}
                class="accordion"
                controlled={false}
                value={["lorem"]}
                items={@items}
              >
                <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
              </.native_accordion>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
