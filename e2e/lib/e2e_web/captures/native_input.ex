defmodule CorexWeb.NativeInput do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.NativeInput
  alias E2eWeb.CoreComponents

  capture variants: [
            text_with_icon: %{
              type: "text",
              class: "native-input",
              name: "name",
              label: [%{inner_block: "Text"}],
              icon: [%{inner_block: ~s(<.icon name="hero-pencil-square" class="icon" />)}]
            },
            text_basic: %{
              type: "text",
              class: "native-input",
              name: "name",
              label: [%{inner_block: "Text"}],
              icon: []
            },
            textarea: %{
              type: "textarea",
              class: "native-input",
              name: "bio",
              label: [%{inner_block: "Bio"}],
              icon: []
            },
            date_basic: %{
              type: "date",
              class: "native-input",
              name: "date",
              label: [%{inner_block: "Date"}],
              icon: []
            },
            datetime_local: %{
              type: "datetime-local",
              class: "native-input",
              name: "datetime",
              label: [%{inner_block: "Date and time"}],
              icon: []
            },
            time: %{
              type: "time",
              class: "native-input",
              name: "time",
              label: [%{inner_block: "Time"}],
              icon: []
            },
            month: %{
              type: "month",
              class: "native-input",
              name: "month",
              label: [%{inner_block: "Month"}],
              icon: []
            },
            week: %{
              type: "week",
              class: "native-input",
              name: "week",
              label: [%{inner_block: "Week"}],
              icon: []
            },
            email_with_icon: %{
              type: "email",
              class: "native-input",
              name: "email",
              label: [%{inner_block: "Email"}],
              icon: [%{inner_block: ~s(<.icon name="hero-envelope" class="icon" />)}]
            },
            email_basic: %{
              type: "email",
              class: "native-input",
              name: "email",
              label: [%{inner_block: "Email"}],
              icon: []
            },
            url_with_icon: %{
              type: "url",
              class: "native-input",
              name: "website",
              label: [%{inner_block: "Website"}],
              icon: [%{inner_block: ~s(<.icon name="hero-link" class="icon" />)}]
            },
            url_basic: %{
              type: "url",
              class: "native-input",
              name: "website",
              label: [%{inner_block: "Website"}],
              icon: []
            },
            tel_with_icon: %{
              type: "tel",
              class: "native-input",
              name: "phone",
              label: [%{inner_block: "Phone"}],
              icon: [%{inner_block: ~s(<.icon name="hero-phone" class="icon" />)}]
            },
            tel_basic: %{
              type: "tel",
              class: "native-input",
              name: "phone",
              label: [%{inner_block: "Phone"}],
              icon: []
            },
            search_with_icon: %{
              type: "search",
              class: "native-input",
              name: "q",
              placeholder: "Search",
              label: [%{inner_block: "Search"}],
              icon: [%{inner_block: ~s(<.icon name="hero-magnifying-glass" class="icon" />)}]
            },
            search_basic: %{
              type: "search",
              class: "native-input",
              name: "q",
              placeholder: "Search",
              label: [%{inner_block: "Search"}],
              icon: []
            },
            color: %{
              type: "color",
              class: "native-input",
              name: "color",
              value: "#3b82f6",
              label: [%{inner_block: "Color"}],
              icon: []
            },
            number: %{
              type: "number",
              class: "native-input",
              name: "count",
              value: 42,
              min: 0,
              max: 100,
              step: 1,
              label: [%{inner_block: "Number"}],
              icon: []
            },
            password_with_icon: %{
              type: "password",
              class: "native-input",
              name: "password",
              label: [%{inner_block: "Password"}],
              icon: [%{inner_block: ~s(<.icon name="hero-lock-closed" class="icon" />)}]
            },
            password_basic: %{
              type: "password",
              class: "native-input",
              name: "password",
              label: [%{inner_block: "Password"}],
              icon: []
            },
            checkbox: %{
              type: "checkbox",
              class: "native-input",
              name: "agree",
              label: [%{inner_block: "I agree"}],
              icon: []
            },
            radio: %{
              type: "radio",
              class: "native-input",
              name: "size",
              value: "m",
              options: [{"Small", "s"}, {"Medium", "m"}, {"Large", "l"}],
              label: [%{inner_block: "Size"}],
              icon: []
            },
            select: %{
              type: "select",
              class: "native-input",
              name: "role",
              options: [{"Admin", "admin"}, {"User", "user"}],
              prompt: "Choose a role...",
              label: [%{inner_block: "Role"}],
              icon: []
            }
          ]

  defdelegate native_input(assigns), to: NativeInput
  defdelegate icon(assigns), to: CoreComponents
end
