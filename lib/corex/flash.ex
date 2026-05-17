defmodule Corex.Flash do
  @moduledoc """
  Configuration for Phoenix flash messages rendered as Zag toasts.

  Used by [`Corex.Toast.toast_group/1`](Corex.Toast.html#toast_group/1) via the
  `flash_info` and `flash_error` attributes. When `flash={@flash}` is set on the
  layout toaster, `:info` and `:error` entries from `Phoenix.Flash` become toasts
  with titles and durations from these structs (or equivalent maps).

  If you omit `flash_info` / `flash_error`, [`Corex.Toast.Translation`](Corex.Toast.Translation.html)
  supplies default titles and a 5000 ms duration.

  ## Example

      <.toast_group
        id="layout-toast"
        class="toast"
        flash={@flash}
        flash_info={%Corex.Flash.Info{title: "Saved", type: :success, duration: 5000}}
        flash_error={%Corex.Flash.Error{title: "Problem", type: :error, duration: :infinity}}
      >
        <:loading>
          <.heroicon name="hero-arrow-path" />
        </:loading>
        <:close>
          <.heroicon name="hero-x-mark" />
        </:close>
      </.toast_group>

  Plain maps with the same keys (`:title`, `:type`, `:duration`) are also accepted.
  """

  defmodule Info do
    @moduledoc """
    Defaults for Phoenix `:info` flashes shown by [`toast_group/1`](Corex.Toast.html#toast_group/1).

    | Field | Type | Role |
    | ----- | ---- | ---- |
    | `title` | `String.t()` | Toast title; body text comes from the flash message |
    | `type` | `:info` \\| `:success` \\| `:error` | Zag toast type / styling |
    | `duration` | `integer()` \\| `:infinity` | Visible time in ms, or no auto-dismiss |

    ## Example

        <.toast_group
          id="layout-toast"
          class="toast"
          flash={@flash}
          flash_info={%Corex.Flash.Info{title: "Success", type: :success, duration: 5000}}
        >
          <:loading>
            <.heroicon name="hero-arrow-path" />
          </:loading>
          <:close>
            <.heroicon name="hero-x-mark" />
          </:close>
        </.toast_group>
    """

    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end

  defmodule Error do
    @moduledoc """
    Defaults for Phoenix `:error` flashes shown by [`toast_group/1`](Corex.Toast.html#toast_group/1).

    | Field | Type | Role |
    | ----- | ---- | ---- |
    | `title` | `String.t()` | Toast title; body text comes from the flash message |
    | `type` | `:info` \\| `:success` \\| `:error` | Zag toast type / styling |
    | `duration` | `integer()` \\| `:infinity` | Visible time in ms, or no auto-dismiss |

    ## Example

        <.toast_group
          id="layout-toast"
          class="toast"
          flash={@flash}
          flash_error={%Corex.Flash.Error{title: "Error", type: :error, duration: :infinity}}
        >
          <:loading>
            <.heroicon name="hero-arrow-path" />
          </:loading>
          <:close>
            <.heroicon name="hero-x-mark" />
          </:close>
        </.toast_group>
    """

    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end
end
