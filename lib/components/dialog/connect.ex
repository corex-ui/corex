defmodule Corex.Dialog.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

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

  @spec props(Props.t()) :: map()
  def props(assigns) do
    animation = assigns.animation
    animation_options = assigns.animation_options

    base = %{
      "id" => assigns.id,
      "data-default-open" => default_presence_attr(assigns.controlled, assigns.open),
      "data-open" => presence_attr(assigns.controlled, assigns.open),
      "data-controlled" => presence_attr(assigns.controlled),
      "data-modal" => presence_attr(assigns.modal),
      "data-close-on-interact-outside" => presence_attr(assigns.close_on_interact_outside),
      "data-close-on-escape-key-down" => presence_attr(assigns.close_on_escape),
      "data-prevent-scroll" => presence_attr(assigns.prevent_scroll),
      "data-restore-focus" => presence_attr(assigns.restore_focus),
      "data-role" => assigns.role,
      "data-initial-focus" => assigns.initial_focus,
      "data-final-focus" => assigns.final_focus,
      "data-dir" => Map.get(assigns, :dir),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client,
      "data-animation" => animation
    }

    merged =
      if animation == "js" do
        Map.merge(base, Scale.to_dataset(animation_options))
      else
        base
      end

    Map.put(merged, "data-dialog-default-label", assigns.label)
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "trigger",
      "data-state" => data_state(assigns.open, "open", "closed"),
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
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

  @spec backdrop(Backdrop.t(), String.t()) :: map()
  def backdrop(assigns, animation \\ "instant") do
    base = %{
      "data-scope" => "dialog",
      "data-part" => "backdrop",
      "data-state" => data_state(assigns.open, "open", "closed"),
      "dir" => Map.get(assigns, :dir),
      "id" => "dialog:#{assigns.id}:backdrop"
    }

    cond do
      assigns.open -> base
      animation in ["js", "custom"] -> base
      true -> Map.put(base, "hidden", "")
    end
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
      "data-state" => data_state(Map.get(assigns, :open, false), "open", "closed"),
      "dir" => Map.get(assigns, :dir),
      "id" => "dialog:#{assigns.id}:positioner"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:positioner")
    )
  end

  @spec content(Content.t(), String.t()) :: map()
  def content(assigns, animation \\ "instant") do
    base = %{
      "data-scope" => "dialog",
      "data-part" => "content",
      "data-state" => data_state(assigns.open, "open", "closed"),
      "role" => Map.get(assigns, :role, "dialog"),
      "dir" => Map.get(assigns, :dir),
      "id" => "dialog:#{assigns.id}:content"
    }

    base =
      if Map.get(assigns, :has_title, false) do
        Map.put(base, "aria-labelledby", "dialog:#{assigns.id}:title")
      else
        Map.put(base, "aria-label", Map.get(assigns, :label) || "Dialog")
      end

    base =
      if Map.get(assigns, :has_description, false) do
        Map.put(base, "aria-describedby", "dialog:#{assigns.id}:description")
      else
        base
      end

    cond do
      assigns.open -> base
      animation in ["js", "custom"] -> base
      true -> Map.put(base, "hidden", "")
    end
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
      "dir" => Map.get(assigns, :dir),
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
      "dir" => Map.get(assigns, :dir),
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
      "dir" => Map.get(assigns, :dir),
      "id" => "dialog:#{assigns.id}:close-trigger",
      "aria-label" => assigns.aria_label
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("dialog:#{assigns.id}:close-trigger")
    )
  end
end
