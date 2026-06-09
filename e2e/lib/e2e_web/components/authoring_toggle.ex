defmodule E2eWeb.AuthoringToggle do
  use E2eWeb, :html

  attr :authoring, :string,
    default: "attr",
    values: ["attr", "class", "markup"],
    doc: "the authoring mode from cookie/session"

  attr :id, :string, default: "doc-authoring-mode"

  attr :disable_markup, :boolean,
    default: false,
    doc: "disable Unstyled on style pages; cookie may still be markup"

  def authoring_toggle(assigns) do
    ~H"""
    <.toggle_group
      id={@id}
      size="sm"
      width="fit"
      max_width="none"
      value={[@authoring]}
      multiple={false}
      deselectable={false}
      on_value_change_client="corex:preview:set-authoring"
    >
      <:item value="attr">Attrs</:item>
      <:item value="class">Class</:item>
      <:item :if={@disable_markup} value="markup" disabled>Unstyled</:item>
      <:item :if={!@disable_markup} value="markup">Unstyled</:item>
    </.toggle_group>
    """
  end
end
