defmodule E2eWeb.Demos.MarqueeDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def api_demo_items do
    [
      %{name: "Apple", logo: "🍎"},
      %{name: "Banana", logo: "🍌"},
      %{name: "Cherry", logo: "🍒"},
      %{name: "Grape", logo: "🍇"},
      %{name: "Lemon", logo: "🍋"}
    ]
  end

  def anatomy_minimal_code do
    ~S"""
    <.marquee
      class="marquee"
      items={[
        %{name: "Apple", logo: "🍎"},
        %{name: "Banana", logo: "🍌"},
        %{name: "Cherry", logo: "🍒"}
      ]}
      duration={20}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.marquee
      id="marquee-anatomy-minimal"
      class="marquee"
      items={[
        %{name: "Apple", logo: "🍎"},
        %{name: "Banana", logo: "🍌"},
        %{name: "Cherry", logo: "🍒"}
      ]}
      duration={20}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def anatomy_custom_slots_code do
    ~S"""
    <.marquee
      class="marquee"
      items={[
        %{name: "Home", icon: "hero-home"},
        %{name: "User", icon: "hero-user"},
        %{name: "Cog", icon: "hero-cog-6-tooth"}
      ]}
      duration={25}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <.heroicon name={item.icon} />
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def anatomy_custom_slots_example(assigns) do
    ~H"""
    <.marquee
      id="marquee-anatomy-custom-slots"
      class="marquee"
      items={[
        %{name: "Home", icon: "hero-home"},
        %{name: "User", icon: "hero-user"},
        %{name: "Cog", icon: "hero-cog-6-tooth"},
        %{name: "Heart", icon: "hero-heart"},
        %{name: "Star", icon: "hero-star"}
      ]}
      duration={25}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <.heroicon name={item.icon} />
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def anatomy_with_images_code do
    ~S"""
    <.marquee
      class="marquee"
      items={[
        %{name: "Elixir", img: "/images/tech/elixir.svg"},
        %{name: "Phoenix", img: "/images/tech/phoenix.svg"},
        %{name: "TypeScript", img: "/images/tech/typescript.svg"}
      ]}
      speed={50}
      spacing="3rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <img src={item.img} alt={item.name} class="h-8 w-auto opacity-90" />
      </:item>
    </.marquee>
    """
  end

  def anatomy_with_images_example(assigns) do
    ~H"""
    <.marquee
      id="marquee-anatomy-with-images"
      class="marquee"
      items={[
        %{name: "Elixir", img: "/images/tech/elixir.svg"},
        %{name: "Phoenix", img: "/images/tech/phoenix.svg"},
        %{name: "TypeScript", img: "/images/tech/typescript.svg"}
      ]}
      speed={50}
      spacing="3rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <img src={item.img} alt={item.name} class="h-8 w-auto opacity-90" />
      </:item>
    </.marquee>
    """
  end

  def api_pause_client_binding_code do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.pause("api-pause-client")} class="button ui-size-sm">
        Pause
      </.action>
    </div>

    #{api_marquee_snippet("api-pause-client")}
    """
  end

  def api_pause_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.pause("api-pause-client")} class="button ui-size-sm">
        Pause
      </.action>
    </div>

    <.marquee_api_fixture id="api-pause-client" items={api_demo_items()} />
    """
  end

  def api_pause_client_js_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-pause-js-btn" class="button ui-size-sm">Pause</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiPauseJs">
      export default {
        mounted() {
          const root = document.getElementById("api-pause-js")
          document.getElementById("api-pause-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:pause", { bubbles: false }))
          })
        },
      }
    </script>

    #{api_marquee_snippet("api-pause-js")}
    """
  end

  def api_pause_client_js_js do
    """
    const el = document.getElementById("api-pause-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:pause", { bubbles: false }));
    """
  end

  def api_pause_client_js_ts do
    """
    const el: HTMLElement | null = document.getElementById("api-pause-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:pause", { bubbles: false }));
    """
  end

  def api_pause_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-pause-js-btn" class="button ui-size-sm">Pause</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiPauseJs">
      export default {
        mounted() {
          const root = document.getElementById("api-pause-js")
          document.getElementById("api-pause-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:pause", { bubbles: false }))
          })
        },
      }
    </script>

    <.marquee_api_fixture id="api-pause-js" items={api_demo_items()} />
    """
  end

  def api_pause_server_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_pause" class="button ui-size-sm">Pause</.action>
    </div>

    #{api_marquee_snippet("api-pause-server")}
    """
  end

  def api_pause_server_elixir do
    ~S"""
    def handle_event("marquee_api_server_pause", _, socket) do
      {:noreply, Corex.Marquee.pause(socket, "api-pause-server")}
    end
    """
  end

  def api_pause_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_pause" class="button ui-size-sm">Pause</.action>
    </div>

    <.marquee_api_fixture id="api-pause-server" items={api_demo_items()} />
    """
  end

  def api_resume_client_binding_code do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.resume("api-resume-client")} class="button ui-size-sm">
        Resume
      </.action>
    </div>

    #{api_marquee_snippet("api-resume-client")}
    """
  end

  def api_resume_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.resume("api-resume-client")} class="button ui-size-sm">
        Resume
      </.action>
    </div>

    <.marquee_api_fixture id="api-resume-client" items={api_demo_items()} />
    """
  end

  def api_resume_client_js_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-resume-js-btn" class="button ui-size-sm">Resume</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiResumeJs">
      export default {
        mounted() {
          const root = document.getElementById("api-resume-js")
          document.getElementById("api-resume-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:resume", { bubbles: false }))
          })
        },
      }
    </script>

    #{api_marquee_snippet("api-resume-js")}
    """
  end

  def api_resume_client_js_js do
    """
    const el = document.getElementById("api-resume-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:resume", { bubbles: false }));
    """
  end

  def api_resume_client_js_ts do
    """
    const el: HTMLElement | null = document.getElementById("api-resume-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:resume", { bubbles: false }));
    """
  end

  def api_resume_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-resume-js-btn" class="button ui-size-sm">Resume</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiResumeJs">
      export default {
        mounted() {
          const root = document.getElementById("api-resume-js")
          document.getElementById("api-resume-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:resume", { bubbles: false }))
          })
        },
      }
    </script>

    <.marquee_api_fixture id="api-resume-js" items={api_demo_items()} />
    """
  end

  def api_resume_server_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_resume" class="button ui-size-sm">Resume</.action>
    </div>

    #{api_marquee_snippet("api-resume-server")}
    """
  end

  def api_resume_server_elixir do
    ~S"""
    def handle_event("marquee_api_server_resume", _, socket) do
      {:noreply, Corex.Marquee.resume(socket, "api-resume-server")}
    end
    """
  end

  def api_resume_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_resume" class="button ui-size-sm">Resume</.action>
    </div>

    <.marquee_api_fixture id="api-resume-server" items={api_demo_items()} />
    """
  end

  def api_toggle_client_binding_code do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.toggle_pause("api-toggle-client")} class="button ui-size-sm">
        Toggle pause
      </.action>
    </div>

    #{api_marquee_snippet("api-toggle-client")}
    """
  end

  def api_toggle_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Marquee.toggle_pause("api-toggle-client")} class="button ui-size-sm">
        Toggle pause
      </.action>
    </div>

    <.marquee_api_fixture id="api-toggle-client" items={api_demo_items()} />
    """
  end

  def api_toggle_client_js_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-toggle-js-btn" class="button ui-size-sm">Toggle pause</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiToggleJs">
      export default {
        mounted() {
          const root = document.getElementById("api-toggle-js")
          document.getElementById("api-toggle-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:toggle-pause", { bubbles: false }))
          })
        },
      }
    </script>

    #{api_marquee_snippet("api-toggle-js")}
    """
  end

  def api_toggle_client_js_js do
    """
    const el = document.getElementById("api-toggle-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:toggle-pause", { bubbles: false }));
    """
  end

  def api_toggle_client_js_ts do
    """
    const el: HTMLElement | null = document.getElementById("api-toggle-js");
    el?.dispatchEvent(new CustomEvent("corex:marquee:toggle-pause", { bubbles: false }));
    """
  end

  def api_toggle_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <button type="button" id="api-toggle-js-btn" class="button ui-size-sm">Toggle pause</button>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeApiToggleJs">
      export default {
        mounted() {
          const root = document.getElementById("api-toggle-js")
          document.getElementById("api-toggle-js-btn")?.addEventListener("click", () => {
            root?.dispatchEvent(new CustomEvent("corex:marquee:toggle-pause", { bubbles: false }))
          })
        },
      }
    </script>

    <.marquee_api_fixture id="api-toggle-js" items={api_demo_items()} />
    """
  end

  def api_toggle_server_heex do
    """
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_toggle_pause" class="button ui-size-sm">
        Toggle pause
      </.action>
    </div>

    #{api_marquee_snippet("api-toggle-server")}
    """
  end

  def api_toggle_server_elixir do
    ~S"""
    def handle_event("marquee_api_server_toggle_pause", _, socket) do
      {:noreply, Corex.Marquee.toggle_pause(socket, "api-toggle-server")}
    end
    """
  end

  def api_toggle_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="marquee_api_server_toggle_pause" class="button ui-size-sm">
        Toggle pause
      </.action>
    </div>

    <.marquee_api_fixture id="api-toggle-server" items={api_demo_items()} />
    """
  end

  def events_server_heex do
    ~S"""
    <.marquee
      class="marquee"
      on_pause_change="pause_changed"
      on_loop_complete="loop_complete"
      on_complete="complete"
      loop_count={3}
      items={[
        %{name: "Apple", logo: "🍎"},
        %{name: "Banana", logo: "🍌"},
        %{name: "Cherry", logo: "🍒"},
        %{name: "Grape", logo: "🍇"},
        %{name: "Lemon", logo: "🍋"}
      ]}
      duration={12}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"pause_changed", ~S|%{"paused" => paused, "id" => id} = params|},
      {"loop_complete", ~S|%{"id" => id} = params|},
      {"complete", ~S|%{"id" => id} = params|}
    ])
  end

  def events_client_heex do
    ~S"""
    <.marquee
      id="marquee-events-client"
      class="marquee"
      on_pause_change_client="marquee-pause-changed-client"
      on_loop_complete_client="marquee-loop-complete-client"
      on_complete_client="marquee-complete-client"
      loop_count={3}
      items={[
        %{name: "Apple", logo: "🍎"},
        %{name: "Banana", logo: "🍌"},
        %{name: "Cherry", logo: "🍒"},
        %{name: "Grape", logo: "🍇"},
        %{name: "Lemon", logo: "🍋"}
      ]}
      duration={12}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("marquee-events-client");
    el?.addEventListener("marquee-pause-changed-client", (e) => {
      console.log("pause", e.detail.id, e.detail.paused);
    });
    el?.addEventListener("marquee-loop-complete-client", (e) => {
      console.log("loop", e.detail.id);
    });
    el?.addEventListener("marquee-complete-client", (e) => {
      console.log("complete", e.detail.id);
    });
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("marquee-events-client");
    el?.addEventListener("marquee-pause-changed-client", (e: Event) => {
      const d = (e as CustomEvent<{ id: string; paused: boolean }>).detail;
      console.log("pause", d.id, d.paused);
    });
    el?.addEventListener("marquee-loop-complete-client", (e: Event) => {
      const d = (e as CustomEvent<{ id: string }>).detail;
      console.log("loop", d.id);
    });
    el?.addEventListener("marquee-complete-client", (e: Event) => {
      const d = (e as CustomEvent<{ id: string }>).detail;
      console.log("complete", d.id);
    });
    """
  end

  attr :id, :string, required: true
  attr :items, :list, required: true

  def marquee_api_fixture(assigns) do
    ~H"""
    <.marquee
      id={@id}
      class="marquee"
      items={@items}
      duration={20}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end

  defp styling_marquee_items do
    [
      %{name: "Apple", logo: "🍎"},
      %{name: "Banana", logo: "🍌"},
      %{name: "Cherry", logo: "🍒"},
      %{name: "Grape", logo: "🍇"},
      %{name: "Lemon", logo: "🍋"}
    ]
  end

  defp styling_marquee_slot do
    """
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    """
  end

  def styling_size_code do
    items =
      ~S|items={[{name: "Apple", logo: "🍎"}, {name: "Banana", logo: "🍌"}, {name: "Cherry", logo: "🍒"}, {name: "Grape", logo: "🍇"}, {name: "Lemon", logo: "🍋"}]}|

    slot = styling_marquee_slot()

    """
    <.marquee class="marquee ui-size-sm" #{items} duration={20} spacing="2rem" pause_on_interaction>
    #{slot}
    </.marquee>
    <.marquee class="marquee ui-size-md" #{items} duration={20} spacing="2rem" pause_on_interaction>
    #{slot}
    </.marquee>
    <.marquee class="marquee ui-size-lg" #{items} duration={20} spacing="2rem" pause_on_interaction>
    #{slot}
    </.marquee>
    <.marquee class="marquee ui-size-xl" #{items} duration={20} spacing="2rem" pause_on_interaction>
    #{slot}
    </.marquee>
    """
  end

  def styling_size_example(assigns) do
    assigns = assign(assigns, :items, styling_marquee_items())

    ~H"""
    <div class="flex flex-col gap-6 items-start w-full">
      <.marquee
        id="marquee-style-size-sm"
        class="marquee ui-size-sm"
        items={@items}
        duration={20}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={item}>
          <span>{item.logo}</span>
          <span>{item.name}</span>
        </:item>
      </.marquee>
      <.marquee
        id="marquee-style-size-md"
        class="marquee ui-size-md"
        items={@items}
        duration={20}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={item}>
          <span>{item.logo}</span>
          <span>{item.name}</span>
        </:item>
      </.marquee>
      <.marquee
        id="marquee-style-size-lg"
        class="marquee ui-size-lg"
        items={@items}
        duration={20}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={item}>
          <span>{item.logo}</span>
          <span>{item.name}</span>
        </:item>
      </.marquee>
      <.marquee
        id="marquee-style-size-xl"
        class="marquee ui-size-xl"
        items={@items}
        duration={20}
        spacing="2rem"
        pause_on_interaction
      >
        <:item :let={item}>
          <span>{item.logo}</span>
          <span>{item.name}</span>
        </:item>
      </.marquee>
    </div>
    """
  end

  def styling_max_width_code do
    items =
      ~S|items={[{name: "Apple", logo: "🍎"}, {name: "Banana", logo: "🍌"}, {name: "Cherry", logo: "🍒"}, {name: "Grape", logo: "🍇"}, {name: "Lemon", logo: "🍋"}]}|

    slot = styling_marquee_slot()

    DemoScales.max_width_variants("marquee")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("marquee", modifier)

      """
      <.marquee class="#{class}" #{items} duration={20} spacing="2rem" pause_on_interaction>
      #{slot}
      </.marquee>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns =
      assigns
      |> assign(:items, styling_marquee_items())
      |> assign(:max_width_variants, DemoScales.max_width_variants("marquee"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.marquee
          id={"marquee-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("marquee", variant.modifier)}
          items={@items}
          duration={20}
          spacing="2rem"
          pause_on_interaction
        >
          <:item :let={item}>
            <span>{item.logo}</span>
            <span>{item.name}</span>
          </:item>
        </.marquee>
      </div>
    </div>
    """
  end

  defp api_marquee_snippet(id) do
    """
    <.marquee
      id="#{id}"
      class="marquee"
      items={[
        %{name: "Apple", logo: "🍎"},
        %{name: "Banana", logo: "🍌"},
        %{name: "Cherry", logo: "🍒"},
        %{name: "Grape", logo: "🍇"},
        %{name: "Lemon", logo: "🍋"}
      ]}
      duration={20}
      spacing="2rem"
      pause_on_interaction
    >
      <:item :let={item}>
        <span>{item.logo}</span>
        <span>{item.name}</span>
      </:item>
    </.marquee>
    """
  end
end
