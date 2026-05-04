defmodule Corex.Toast.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Toast.Anatomy.Group
  alias Phoenix.LiveView.JS

  @spec group(Group.t()) :: map()
  def group(assigns) do
    %{
      "data-scope" => "toast",
      "data-part" => "group",
      "id" => "toast:#{assigns.id}:group",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  @spec ignore_group(Group.t()) :: JS.t()
  def ignore_group(assigns) do
    JS.ignore_attributes(Group.ignored_attrs(),
      to: Selectors.css_id("toast:#{assigns.id}:group")
    )
  end
end
