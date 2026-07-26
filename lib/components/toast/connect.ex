defmodule Corex.Toast.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.Toast.Anatomy.Group

  alias Phoenix.LiveView.JS

  @spec group(Group.t()) :: map()
  def group(assigns) do
    %{
      "data-scope" => "toast",
      "data-part" => "group",
      "id" => "toast:#{assigns.id}:group",
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
    |> put_dir_attr_from_assigns(assigns)
  end

  @spec ignore_group(Group.t()) :: JS.t()
  def ignore_group(assigns) do
    JS.ignore_attributes(Group.ignored_attrs(),
      to: Selectors.css_id("toast:#{assigns.id}:group")
    )
  end
end
