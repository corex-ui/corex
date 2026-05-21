defmodule Corex.Checkbox.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Checkbox.Anatomy.{
    Control,
    HiddenInput,
    Indeterminate,
    Indicator,
    Label,
    Props,
    Root
  }

  import Corex.Helpers, only: [get_boolean: 1, maybe_put_dir: 2]
  import Corex.Checkable.Helpers, only: [visual_state: 1]

  alias Corex.Checkable.Connect, as: CheckableConnect
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    CheckableConnect.props(assigns, "checkbox")
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    state = visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "root",
      "data-orientation" => orientation,
      "id" => "checkbox:#{assigns.id}",
      "htmlFor" => "checkbox:#{assigns.id}:input",
      "for" => "checkbox:#{assigns.id}:input",
      "data-state" => state,
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    CheckableConnect.hidden_input(assigns, "checkbox", input_value: "true")
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    state = visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "control",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "checkbox:#{assigns.id}:control",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:control")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "label",
      "data-orientation" => orientation,
      "id" => "checkbox:#{assigns.id}:label",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:label")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    state = visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "indicator",
      "data-orientation" => orientation,
      "id" => "checkbox:#{assigns.id}:indicator",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:indicator")
    )
  end

  @spec indeterminate(Indeterminate.t()) :: map()
  def indeterminate(assigns) do
    state = visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "indeterminate",
      "data-orientation" => orientation,
      "id" => "checkbox:#{assigns.id}:indeterminate",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_indeterminate(assigns) do
    JS.ignore_attributes(Indeterminate.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:indeterminate")
    )
  end
end
