defmodule Corex.TagsInput.Translation do
  @moduledoc """
  Translatable strings for the tags input.

  Maps to Zag.js `translations` for delete trigger and inline tag edit (`deleteTagTriggerLabel`, `tagEdited`).
  Templates use `%{tag}` for the tag value.

  Without gettext: `translation={%Corex.TagsInput.Translation{placeholder: "Keywords"}}`

  With gettext: `translation={%Corex.TagsInput.Translation{placeholder: Corex.Gettext.gettext("Add a tag…")}}`
  """

  defstruct [:placeholder, :delete_tag_trigger_label, :tag_edited]

  @type t :: %__MODULE__{
          placeholder: String.t() | nil,
          delete_tag_trigger_label: String.t() | nil,
          tag_edited: String.t() | nil
        }

  @doc false
  def merge(%__MODULE__{} = user, %__MODULE__{} = default) do
    %__MODULE__{
      placeholder: take_override(user.placeholder, default.placeholder),
      delete_tag_trigger_label:
        take_override(user.delete_tag_trigger_label, default.delete_tag_trigger_label),
      tag_edited: take_override(user.tag_edited, default.tag_edited)
    }
  end

  @doc false
  def to_camel_map(%__MODULE__{} = t) do
    %{
      "deleteTagTriggerLabel" => t.delete_tag_trigger_label,
      "tagEdited" => t.tag_edited
    }
  end

  @doc false
  def format_tag(template, tag) when is_binary(template) and is_binary(tag) do
    String.replace(template, "%{tag}", tag)
  end

  defp take_override(nil, fallback), do: fallback
  defp take_override("", fallback), do: fallback
  defp take_override(v, _), do: v
end
