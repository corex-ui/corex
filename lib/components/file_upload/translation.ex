defmodule Corex.FileUpload.Translation do
  @moduledoc """
  Translatable strings for [`Corex.FileUpload`](Corex.FileUpload.html).

  Pass `translation={%Corex.FileUpload.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

  | Field | Default | Used for |
  | ----- | ------- | -------- |
  | `dropzone` | Drag your file(s) here | Dropzone label when the slot is empty |
  | `open` | Upload file(s) | Open picker button when the slot is empty |

  Partial override example:

      translation={%Corex.FileUpload.Translation{
        dropzone: Corex.Gettext.gettext("Drop files here"),
        open: Corex.Gettext.gettext("Browse files")
      }}
  """

  use Corex.Translation,
    fields: [dropzone: "Drag your file(s) here", open: "Upload file(s)"]
end
