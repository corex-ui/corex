defmodule Corex.Pagination.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id, :count]

    defstruct [
      :id,
      :count,
      page: 1,
      page_size: 10,
      controlled: false,
      controlled_page_size: false,
      sibling_count: 1,
      boundary_count: 1,
      type: "button",
      to: nil,
      page_param: "page",
      page_size_param: "page_size",
      redirect: nil,
      dir: "ltr",
      on_page_change: nil,
      on_page_change_client: nil,
      on_page_size_change: nil,
      on_page_size_change_client: nil,
      translation: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            count: integer(),
            page: integer(),
            page_size: integer(),
            controlled: boolean(),
            controlled_page_size: boolean(),
            sibling_count: integer(),
            boundary_count: integer(),
            type: String.t(),
            to: String.t() | nil,
            page_param: String.t(),
            page_size_param: String.t(),
            redirect: String.t() | nil,
            dir: String.t(),
            on_page_change: String.t() | nil,
            on_page_change_client: String.t() | nil,
            on_page_size_change: String.t() | nil,
            on_page_size_change_client: String.t() | nil,
            translation: Corex.Pagination.Translation.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr", aria_label: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            aria_label: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-scope",
      "data-part",
      "aria-label"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule PrevTrigger do
    @moduledoc false
    defstruct [
      :id,
      dir: "ltr",
      disabled: false,
      aria_label: nil,
      href: nil,
      redirect: nil,
      tag: "button"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            aria_label: String.t() | nil,
            href: String.t() | nil,
            redirect: String.t() | nil,
            tag: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-scope",
      "data-part",
      "type",
      "disabled",
      "data-disabled",
      "href",
      "data-phx-link",
      "data-phx-link-state",
      "aria-label",
      "tabindex",
      "data-focus",
      "data-focus-visible"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule NextTrigger do
    @moduledoc false
    defstruct [
      :id,
      dir: "ltr",
      disabled: false,
      aria_label: nil,
      href: nil,
      redirect: nil,
      tag: "button"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            aria_label: String.t() | nil,
            href: String.t() | nil,
            redirect: String.t() | nil,
            tag: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-scope",
      "data-part",
      "type",
      "disabled",
      "data-disabled",
      "href",
      "data-phx-link",
      "data-phx-link-state",
      "aria-label",
      "tabindex",
      "data-focus",
      "data-focus-visible"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrPageItem do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :page,
      :index,
      selected: false,
      aria_label: nil,
      href: nil,
      redirect: nil,
      tag: "button"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            page: pos_integer(),
            index: non_neg_integer(),
            selected: boolean(),
            aria_label: String.t() | nil,
            href: String.t() | nil,
            redirect: String.t() | nil,
            tag: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "type",
      "disabled",
      "href",
      "data-phx-link",
      "data-phx-link-state",
      "data-scope",
      "data-part",
      "data-index",
      "data-selected",
      "aria-current",
      "aria-label",
      "tabindex",
      "data-focus",
      "data-focus-visible"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrEllipsis do
    @moduledoc false
    defstruct [:id, :dir, :index]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            index: non_neg_integer()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-scope",
      "data-part",
      "tabindex",
      "data-focus",
      "data-focus-visible"
    ]

    def ignored_attrs, do: @ignored_attrs
  end
end
