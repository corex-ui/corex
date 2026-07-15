defmodule Corex.Checkbox.Api do
  @moduledoc false
  alias Corex.Api.RespondTo
  alias Phoenix.LiveView.JS

  def set_checked(checkbox_id, checked) when is_binary(checkbox_id) and is_boolean(checked) do
    JS.dispatch("corex:checkbox:set-checked",
      to: "##{checkbox_id}",
      detail: %{checked: checked},
      bubbles: false
    )
  end

  def set_checked(socket, checkbox_id, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) and
             is_boolean(checked) do
    RespondTo.push_event(socket, "checkbox_set_checked", %{
      "id" => checkbox_id,
      "checked" => checked
    })
  end

  def set_checked_many(socket, checkbox_ids, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_list(checkbox_ids) and
             is_boolean(checked) do
    ids = Enum.filter(checkbox_ids, &is_binary/1)

    RespondTo.push_event(socket, "checkbox_set_checked_many", %{
      "ids" => ids,
      "checked" => checked
    })
  end

  def toggle_checked(checkbox_id) when is_binary(checkbox_id) do
    JS.dispatch("corex:checkbox:toggle-checked",
      to: "##{checkbox_id}",
      bubbles: false
    )
  end

  def toggle_checked(socket, checkbox_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(checkbox_id) do
    RespondTo.push_event(socket, "checkbox_toggle_checked", %{"id" => checkbox_id})
  end
end
