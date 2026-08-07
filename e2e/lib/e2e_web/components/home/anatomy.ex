defmodule E2eWeb.Home.Anatomy do
  @moduledoc false
  use E2eWeb, :html

  def section(assigns) do
    ~H"""
    <section
      id="home-anatomy"
      class="relative isolate flex min-h-dvh w-full flex-col justify-center overflow-x-hidden border-t border-border py-size-xl"
      aria-labelledby="home-anatomy-heading"
    >
      <div class="relative z-1 mx-auto flex w-full max-w-6xl flex-col gap-size-xl px-space">
        <div class="flex flex-col items-center gap-space-lg text-center">
          <p class="m-0 text-sm font-medium tracking-wide text-brand-text uppercase">
            {~t"Authoring"}
          </p>
          <h2
            id="home-anatomy-heading"
            class="display m-0 text-balance text-3xl tracking-tighter text-ink sm:text-4xl lg:text-5xl"
          >
            {~t"Flexible anatomy with HEEx"}
          </h2>
          <p class="m-0 max-w-2xl text-pretty text-lg text-ink-muted">
            {~t"Same Zag machine. Items, manual slots, or custom slots. Pick the shape that fits your markup."}
          </p>
        </div>

        <div class="flex flex-col gap-size-lg">
          <.anatomy_row
            id="home-anatomy-items"
            title={~t"Items + indicator"}
            body={~t"Declarative items list with a shared indicator slot."}
            code_tabs={[
              %{
                value: "heex",
                label: ~t"Heex",
                language: :heex,
                code: items_heex()
              },
              %{
                value: "elixir",
                label: ~t"Elixir",
                language: :elixir,
                code: items_elixir()
              }
            ]}
          >
            <.accordion
              id="home-anatomy-items-preview"
              class="accordion"
              value="lorem"
              items={items()}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </.anatomy_row>

          <.anatomy_row
            id="home-anatomy-manual"
            title={~t"Manual slots"}
            body={~t"Author each trigger and content by value. No items list required."}
            code_tabs={[
              %{
                value: "heex",
                label: ~t"Heex",
                language: :heex,
                code: manual_slots_heex()
              }
            ]}
          >
            <.accordion id="home-anatomy-manual-preview" class="accordion" value="lorem">
              <:trigger value="lorem">
                <.heroicon name="hero-chat-bubble-left-right" /> Lorem ipsum dolor sit amet
              </:trigger>
              <:content value="lorem">
                <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
              </:content>
              <:indicator value="lorem">
                <.heroicon name="hero-chevron-right" />
              </:indicator>

              <:trigger value="duis">
                <.heroicon name="hero-device-phone-mobile" /> Duis dictum gravida odio
              </:trigger>
              <:content value="duis">
                <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
              </:content>
              <:indicator value="duis">
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </.anatomy_row>

          <.anatomy_row
            id="home-anatomy-custom"
            title={~t"Custom slots"}
            body={
              ~t"Own the trigger, content, and indicator with :let={item}. Stack your own chrome."
            }
            code_tabs={[
              %{
                value: "heex",
                label: ~t"Heex",
                language: :heex,
                code: custom_slots_heex()
              },
              %{
                value: "elixir",
                label: ~t"Elixir",
                language: :elixir,
                code: custom_slots_elixir()
              }
            ]}
          >
            <.accordion
              id="home-anatomy-custom-preview"
              class="accordion"
              value="server"
              items={custom_items()}
            >
              <:trigger :let={item}>
                <span class="inline-flex shrink-0 -space-x-2">
                  <img
                    :for={tech <- item.meta.tech}
                    src={tech.src}
                    alt={tech.alt}
                    title={tech.name}
                    class="pointer-events-none size-6 rounded-full bg-surface object-contain ring-2 ring-surface"
                  />
                </span>
                {item.label}
              </:trigger>
              <:content :let={item}>
                <p>{item.content}</p>
              </:content>
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </.anatomy_row>
        </div>

        <div class="flex justify-center">
          <.navigate to={~p"/accordion/anatomy"} class="button ui-ghost ui-size-lg">
            {~t"Explore accordion anatomy"}
            <.heroicon name="hero-arrow-right" />
          </.navigate>
        </div>
      </div>
    </section>
    """
  end

  attr(:id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:body, :string, required: true)
  attr(:code_tabs, :list, required: true)
  slot(:inner_block, required: true)

  defp anatomy_row(assigns) do
    ~H"""
    <div
      id={@id}
      class="grid grid-cols-1 gap-space-lg overflow-hidden rounded-md border border-border bg-surface shadow-sm lg:grid-cols-2"
    >
      <div class="flex min-h-0 flex-col gap-space-sm border-b border-border p-space-lg lg:border-b-0 lg:border-e">
        <div class="flex flex-col gap-space-sm">
          <h3 class="m-0 text-lg font-semibold text-ink">{@title}</h3>
          <p class="m-0 text-pretty text-sm text-ink-muted">{@body}</p>
        </div>
        <div class="flex min-h-0 flex-1 flex-col items-center overflow-y-auto scrollbar scrollbar--sm pt-space lg:items-stretch">
          {render_slot(@inner_block)}
        </div>
      </div>

      <div class="relative flex min-h-0 flex-col p-space-lg">
        <.tabs
          id={"#{@id}-code-tabs"}
          class="tabs w-full max-w-none [&>[data-scope=tabs][data-part=root]>[data-scope=tabs][data-part=list]]:place-self-end"
          value={hd(@code_tabs).value}
        >
          <:trigger :for={tab <- @code_tabs} value={tab.value} class="ui-size-sm">
            {tab.label}
          </:trigger>
          <:content
            :for={tab <- @code_tabs}
            value={tab.value}
            class="relative max-h-64 overflow-y-auto scrollbar scrollbar--sm bg-root p-0"
          >
            <.clipboard
              id={"#{@id}-#{tab.value}-clipboard"}
              class="clipboard ui-size-sm absolute top-2 right-2 z-10"
              value={tab.code}
              input={false}
              trigger_aria_label={~t"Copy code"}
            >
              <:copy>
                <.heroicon name="hero-clipboard" />
              </:copy>
              <:copied>
                <.heroicon name="hero-check" />
              </:copied>
            </.clipboard>
            <.code
              id={"#{@id}-#{tab.value}-code"}
              class="code ui-width-full ui-size-sm"
              language={tab.language}
              code={tab.code}
            />
          </:content>
        </.tabs>
      </div>
    </div>
    """
  end

  defp items do
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit."
      },
      %{
        value: "duis",
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula."
      }
    ])
  end

  defp custom_items do
    Corex.Content.new([
      %{
        value: "server",
        label: "Server stack",
        content: "Elixir, Phoenix, and Ecto on the server. One assign feeds the accordion.",
        meta: %{
          tech: [
            %{name: "Elixir", alt: "Elixir", src: ~p"/images/tech/elixir.svg"},
            %{name: "Phoenix", alt: "Phoenix", src: ~p"/images/tech/phoenix.svg"},
            %{name: "Ecto", alt: "Ecto", src: ~p"/images/tech/ecto.png"}
          ]
        }
      },
      %{
        value: "client",
        label: "Client machine",
        content: "Zag.js and TypeScript drive accessible state in the browser.",
        meta: %{
          tech: [
            %{name: "Zag.js", alt: "Zag.js", src: ~p"/images/tech/zag.webp"},
            %{name: "TypeScript", alt: "TypeScript", src: ~p"/images/tech/typescript.svg"},
            %{name: "Tailwind CSS", alt: "Tailwind CSS", src: ~p"/images/tech/tailwind.svg"}
          ]
        }
      }
    ])
  end

  defp items_heex do
    ~S"""
    <.accordion class="accordion" value="lorem" items={@items}>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  defp items_elixir do
    ~S"""
    items =
      Corex.Content.new([
        %{
          value: "lorem",
          label: "Lorem ipsum dolor sit amet",
          content: "Consectetur adipiscing elit."
        },
        %{
          value: "duis",
          label: "Duis dictum gravida odio ac pharetra?",
          content: "Nullam eget vestibulum ligula."
        }
      ])
    """
  end

  defp manual_slots_heex do
    ~S"""
    <.accordion class="accordion" value="lorem">
      <:trigger value="lorem">
        <.heroicon name="hero-chat-bubble-left-right" /> Lorem ipsum dolor sit amet
      </:trigger>
      <:content value="lorem">
        <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
      </:content>
      <:indicator value="lorem">
        <.heroicon name="hero-chevron-right" />
      </:indicator>

      <:trigger value="duis">
        <.heroicon name="hero-device-phone-mobile" /> Duis dictum gravida odio
      </:trigger>
      <:content value="duis">
        <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
      </:content>
      <:indicator value="duis">
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  defp custom_slots_heex do
    ~S"""
    <.accordion class="accordion" value="server" items={@items}>
      <:trigger :let={item}>
        <span class="inline-flex -space-x-2">
          <img
            :for={tech <- item.meta.tech}
            src={tech.src}
            alt={tech.alt}
            class="size-6 rounded-full ring-2 ring-surface"
          />
        </span>
        {item.label}
      </:trigger>
      <:content :let={item}><p>{item.content}</p></:content>
      <:indicator>
        <.heroicon name="hero-chevron-right" />
      </:indicator>
    </.accordion>
    """
  end

  defp custom_slots_elixir do
    ~S"""
    items =
      Corex.Content.new([
        %{
          value: "server",
          label: "Server stack",
          content: "Elixir, Phoenix, and Ecto on the server.",
          meta: %{
            tech: [
              %{name: "Elixir", alt: "Elixir", src: "/images/tech/elixir.svg"},
              %{name: "Phoenix", alt: "Phoenix", src: "/images/tech/phoenix.svg"},
              %{name: "Ecto", alt: "Ecto", src: "/images/tech/ecto.png"}
            ]
          }
        },
        %{
          value: "client",
          label: "Client machine",
          content: "Zag.js and TypeScript in the browser.",
          meta: %{
            tech: [
              %{name: "Zag.js", alt: "Zag.js", src: "/images/tech/zag.webp"},
              %{name: "TypeScript", alt: "TypeScript", src: "/images/tech/typescript.svg"},
              %{name: "Tailwind CSS", alt: "Tailwind CSS", src: "/images/tech/tailwind.svg"}
            ]
          }
        }
      ])
    """
  end
end
