defmodule Corex.TagsInput.Translation do
  @moduledoc """
  Translatable strings for the tags input (Zag `translations` and placeholders).

  Pass `translation={%Corex.TagsInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `placeholder` | Add a tag… | Main input placeholder |
  | `delete_tag_trigger_label` | Delete tag %{tag} | Per-tag remove button `aria-label` (`%{tag}` replaced at runtime) |
  | `tag_edited` | Editing tag %{tag}. Press enter to save or escape to cancel. | Inline edit `aria-label` |

  Partial override example:

      translation={%Corex.TagsInput.Translation{placeholder: Corex.Gettext.gettext("Keywords")}}
  """

  alias Corex.Gettext

  defstruct [:placeholder, :delete_tag_trigger_label, :tag_edited]

  @type t :: %__MODULE__{
          placeholder: String.t(),
          delete_tag_trigger_label: String.t(),
          tag_edited: String.t()
        }

  @doc false
  def resolve(nil), do: default()

  def resolve(%__MODULE__{} = partial), do: merge(partial, default())

  defp default do
    %__MODULE__{
      placeholder: Gettext.gettext("Add a tag…"),
      delete_tag_trigger_label: Gettext.gettext("Delete tag %{tag}", tag: "%{tag}"),
      tag_edited:
        Gettext.gettext(
          "Editing tag %{tag}. Press enter to save or escape to cancel.",
          tag: "%{tag}"
        )
    }
  end


  defp merge(%__MODULE__{} = user, %__MODULE__{} = default) do
    %__MODULE__{
      placeholder: Corex.Translation.take(user.placeholder, default.placeholder),
      delete_tag_trigger_label:
        Corex.Translation.take(user.delete_tag_trigger_label, default.delete_tag_trigger_label),
      tag_edited: Corex.Translation.take(user.tag_edited, default.tag_edited)
    }
  end

  def to_camel_map(%__MODULE__{} = t) do
    %{
      "deleteTagTriggerLabel" => t.delete_tag_trigger_label,
      "tagEdited" => t.tag_edited
    }
  end

  def format_tag(template, tag) when is_binary(template) and is_binary(tag) do
    String.replace(template, "%{tag}", tag)
  end
end
