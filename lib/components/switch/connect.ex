defmodule Corex.Switch.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Switch.Anatomy.{Control, HiddenInput, Label, Props, Root, Thumb}

  import Corex.Helpers, only: [get_boolean: 1, data_state: 3, maybe_put_dir: 2]

  alias Corex.Checkable.Connect, as: CheckableConnect
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    CheckableConnect.props(assigns, "switch")
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "root",
      "data-orientation" => orientation,
      "id" => "switch:#{assigns.id}",
      "htmlFor" => "switch:#{assigns.id}:input",
      "for" => "switch:#{assigns.id}:input",
      "data-state" => state,
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    CheckableConnect.hidden_input(assigns, "switch")
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "control",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:control",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:control")
    )
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "thumb",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:thumb",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_thumb(assigns) do
    JS.ignore_attributes(Thumb.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:thumb")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "label",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:label",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:label")
    )
  end
end
