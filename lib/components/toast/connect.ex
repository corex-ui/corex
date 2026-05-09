defmodule Corex.Toast.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Toast.Anatomy.Group
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [maybe_put_dir_from: 2]

  @spec group(Group.t()) :: map()
  def group(assigns) do
    %{
      "data-scope" => "toast",
      "data-part" => "group",
      "id" => "toast:#{assigns.id}:group",
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
    |> maybe_put_dir_from(assigns)
  end

  @spec ignore_group(Group.t()) :: JS.t()
  def ignore_group(assigns) do
    JS.ignore_attributes(Group.ignored_attrs(),
      to: Selectors.css_id("toast:#{assigns.id}:group")
    )
  end
end
