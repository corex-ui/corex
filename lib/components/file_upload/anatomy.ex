defmodule Corex.FileUpload.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      disabled: false,
      invalid: false,
      read_only: false,
      required: false,
      name: nil,
      form: nil,
      dir: "ltr",
      max_files: 1,
      max_file_size: nil,
      min_file_size: nil,
      allow_drop: true,
      prevent_document_drop: true,
      accept: nil,
      directory: false,
      on_file_change: nil,
      on_file_change_client: nil,
      on_file_accept: nil,
      on_file_accept_client: nil,
      on_file_reject: nil,
      on_file_reject_client: nil,
      dropzone: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            max_files: pos_integer(),
            max_file_size: non_neg_integer() | nil,
            min_file_size: non_neg_integer() | nil,
            allow_drop: boolean(),
            prevent_document_drop: boolean(),
            accept: String.t() | nil,
            directory: boolean(),
            on_file_change: String.t() | nil,
            on_file_change_client: String.t() | nil,
            on_file_accept: String.t() | nil,
            on_file_accept_client: String.t() | nil,
            on_file_reject: String.t() | nil,
            on_file_reject_client: String.t() | nil,
            dropzone: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs [
      "id",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-dragging"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs [
      "id",
      "for",
      "htmlFor",
      "dir",
      "data-disabled",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Dropzone do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}

    @ignored_attrs [
      "id",
      "tabIndex",
      "role",
      "aria-label",
      "aria-disabled",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-dragging"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :disabled, :name, :form]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            name: String.t() | nil,
            form: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "type",
      "name",
      "form",
      "disabled",
      "required",
      "accept",
      "multiple",
      "capture",
      "webkitdirectory",
      "aria-hidden",
      "tabIndex",
      "style",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs [
      "id",
      "type",
      "dir",
      "disabled",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule InputSentinel do
    @moduledoc false
    defstruct [:id, :name, :form]

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t() | nil,
            form: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "type",
      "name",
      "form",
      "value"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroup do
    @moduledoc false
    defstruct [:id, :type, dir: "ltr", disabled: false]

    @type t :: %__MODULE__{
            id: String.t(),
            type: String.t(),
            dir: String.t(),
            disabled: boolean()
          }

    @ignored_attrs [
      "id",
      "data-disabled",
      "data-type",
      "dir"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
