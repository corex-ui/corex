defmodule Corex do
  @moduledoc """
  Corex UI component library for Phoenix LiveView.
  """

  alias Corex.Accordion
  defdelegate accordion(assigns), to: Accordion
  defdelegate accordion_trigger(assigns), to: Accordion
  defdelegate accordion_content(assigns), to: Accordion

  defdelegate accordion_skeleton(assigns), to: Accordion

  alias Corex.Switch
  defdelegate switch(assigns), to: Switch

  alias Corex.Toast

  defdelegate toast_group(assigns), to: Toast
end
