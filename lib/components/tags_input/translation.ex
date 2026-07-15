defmodule Corex.TagsInput.Translation do
  @moduledoc """
  Translatable strings for [`Corex.TagsInput`](Corex.TagsInput.html).

  Pass `translation={%Corex.TagsInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Add a tag… | Main input placeholder |
  | `delete_tag_trigger_label` | Delete tag %{tag} | Per-tag remove button `aria-label` (`%{tag}` replaced at runtime) |
  | `tag_edited` | Editing tag %{tag}. Press enter to save or escape to cancel. | Inline edit `aria-label` |

  Partial override example:

      translation={%Corex.TagsInput.Translation{
        placeholder: Corex.Gettext.gettext("Keywords"),
        delete_tag_trigger_label: Corex.Gettext.gettext("Remove %{tag}", tag: "%{tag}")
      }}
  """

  use Corex.Translation,
    camel_keys: [
      delete_tag_trigger_label: "deleteTagTriggerLabel",
      tag_edited: "tagEdited"
    ],
    fields: [
      placeholder: "Add a tag…",
      delete_tag_trigger_label: "Delete tag %{tag}",
      tag_edited: "Editing tag %{tag}. Press enter to save or escape to cancel."
    ]

  @doc false
  def format_tag(template, tag) when is_binary(template) and is_binary(tag) do
    String.replace(template, "%{tag}", tag)
  end
end
