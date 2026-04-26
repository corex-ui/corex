defmodule Corex.Dialog.Connect do
  @moduledoc false

  import Corex.Gettext, only: [gettext: 1]

  alias Corex.Animation.Scale
  alias Corex.Selectors

  alias Corex.Dialog.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    Props,
    Title,
    Trigger
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    animation = Map.get(assigns, :animation, "instant")

    animation_options =
      Map.get(assigns, :animation_options, %Scale{scale_start: 0.96, scale_end: 1.0})

    base = %{
      "id" => assigns.id,
      "data-default-open" => data_default_open(assigns),
      "data-open" => data_open(assigns),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-modal" => get_boolean(assigns.modal),
      "data-close-on-interact-outside" => get_boolean(assigns.close_on_interact_outside),
      "data-close-on-escape-key-down" => get_boolean(assigns.close_on_escape),
      "data-prevent-scroll" => get_boolean(assigns.prevent_scroll),
      "data-restore-focus" => get_boolean(assigns.restore_focus),
      "data-dir" => Map.get(assigns, :dir, "ltr"),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-animation" => animation
    }

    if animation == "js" do
      Map.merge(base, Scale.to_dataset(animation_options))
    else
      base
    end
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "dialog",
      "data-part" => "trigger",
      "data-state" => data_state,
      "type" => "button",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:trigger",
      "aria-haspopup" => "dialog",
      "aria-expanded" => if(assigns.open, do: "true", else: "false"),
      "aria-controls" => "dialog:#{assigns.id}:content"
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:trigger")
    )
  end

  @spec backdrop(Backdrop.t()) :: map()
  def backdrop(assigns) do
    base = %{
      "data-scope" => "dialog",
      "data-part" => "backdrop",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:backdrop"
    }

    if assigns.open, do: base, else: Map.put(base, "hidden", "")
  end

  def ignore_backdrop(assigns) do
    JS.ignore_attributes(Backdrop.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:backdrop")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    base = %{
      "data-scope" => "dialog",
      "data-part" => "content",
      "data-state" => data_state,
      "role" => "dialog",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:content",
      "aria-labelledby" => "dialog:#{assigns.id}:title",
      "aria-describedby" => "dialog:#{assigns.id}:description"
    }

    if assigns.open, do: base, else: Map.put(base, "hidden", "")
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:content")
    )
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "title",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:title"
    }
  end

  def ignore_title(assigns) do
    JS.ignore_attributes(Title.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:title")
    )
  end

  @spec description(Description.t()) :: map()
  def description(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "description",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:description"
    }
  end

  def ignore_description(assigns) do
    JS.ignore_attributes(Description.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:description")
    )
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir, "ltr"),
      "id" => "dialog:#{assigns.id}:close-trigger",
      "aria-label" => Map.get(assigns, :aria_label) || gettext("Close dialog")
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:close-trigger")
    )
  end

  defp data_default_open(assigns) do
    if !assigns.controlled && assigns.open, do: "", else: nil
  end

  defp data_open(assigns) do
    if assigns.controlled do
      if assigns.open, do: "", else: nil
    else
      nil
    end
  end
end
