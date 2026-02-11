defmodule Corex.Dialog.Connect do
  @moduledoc false
  alias Corex.Dialog.Anatomy.{
    Props,
    Trigger,
    Backdrop,
    Positioner,
    Content,
    Title,
    Description,
    CloseTrigger
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-open" => data_default_open(assigns),
      "data-open" => data_open(assigns),
      "data-controlled" => data_attr(assigns.controlled),
      "data-modal" => data_attr(assigns.modal),
      "data-close-on-interact-outside" => data_attr(assigns.close_on_interact_outside),
      "data-close-on-escape-key-down" => data_attr(assigns.close_on_escape),
      "data-prevent-scroll" => data_attr(assigns.prevent_scroll),
      "data-restore-focus" => data_attr(assigns.restore_focus),
      "data-dir" => assigns.dir,
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "dialog",
      "data-part" => "trigger",
      "data-state" => data_state,
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:trigger",
      "aria-haspopup" => "dialog",
      "aria-expanded" => if(assigns.open, do: "true", else: "false"),
      "aria-controls" => "dialog:#{assigns.id}:content"
    }
  end

  @spec backdrop(Backdrop.t()) :: map()
  def backdrop(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "backdrop",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:backdrop"
    }
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "positioner",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:positioner"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    data_state = if assigns.open, do: "open", else: "closed"

    %{
      "data-scope" => "dialog",
      "data-part" => "content",
      "data-state" => data_state,
      "role" => "dialog",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:content",
      "aria-labelledby" => "dialog:#{assigns.id}:title",
      "aria-describedby" => "dialog:#{assigns.id}:description"
    }
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "title",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:title"
    }
  end

  @spec description(Description.t()) :: map()
  def description(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "description",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:description"
    }
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "dialog",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "dialog:#{assigns.id}:close-trigger",
      "aria-label" => "Close"
    }
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
