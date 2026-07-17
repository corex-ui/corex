defmodule Corex.Component do
  @moduledoc false

  @doc """
  Shared attrs for form-capable components. Expand inside the component module
  after `use Phoenix.Component`.
  """
  defmacro form_control_attrs do
    quote do
      attr(:id, :string, default: nil)
      attr(:field, Phoenix.HTML.FormField, default: nil)
      attr(:name, :string, default: nil)
      attr(:form, :string, default: nil)
      attr(:invalid, :boolean, default: nil)

      attr(:auto_invalid, :boolean,
        default: false,
        doc: "When true with `field`, set invalid from visible changeset errors"
      )

      attr(:controlled, :boolean, default: false)
      attr(:disabled, :boolean, default: false)
      attr(:read_only, :boolean, default: false)
      attr(:required, :boolean, default: false)
    end
  end
end
