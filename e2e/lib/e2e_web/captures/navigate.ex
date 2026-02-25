defmodule CorexWeb.Navigate do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Navigate

  capture variants: [
            basic: %{
              class: "link",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            with_icon: %{
              class: "link",
              to: "#",
              inner_block: [
                %{
                  inner_block:
                    ~s(Internal Link <span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            icon_only: %{
              class: "link",
              to: "#",
              aria_label: "Internal link icon only",
              inner_block: [
                %{
                  inner_block:
                    ~s(<span aria-hidden="true"><.icon name="hero-arrow-right" class="icon" /></span>)
                }
              ]
            },
            external: %{
              class: "link",
              to: "https://example.com",
              external: true,
              inner_block: [
                %{
                  inner_block:
                    ~s(External Link <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><title>Opens in a new window</title><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"/></svg>)
                }
              ]
            },
            download: %{
              class: "link",
              to: "#",
              download: "report.pdf",
              inner_block: [
                %{
                  inner_block:
                    ~s(Download Link <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><title>Download PDF, 2MB</title><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>)
                }
              ]
            },
            color_accent: %{
              class: "link link--accent",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            color_brand: %{
              class: "link link--brand",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            color_alert: %{
              class: "link link--alert",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            color_info: %{
              class: "link link--info",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            color_success: %{
              class: "link link--success",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            size_sm: %{
              class: "link link--sm",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            size_md: %{
              class: "link link--md",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            size_lg: %{
              class: "link link--lg",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            },
            size_xl: %{
              class: "link link--xl",
              to: "#",
              inner_block: [%{inner_block: "Internal Link"}]
            }
          ]

  defdelegate navigate(assigns), to: Navigate
  defdelegate icon(assigns), to: E2eWeb.CoreComponents
end
