defmodule Corex.PasswordInput.Connect do
  @moduledoc false
  alias Corex.PasswordInput.Anatomy.{Props, Root, Label, Control, Input, VisibilityTrigger, Indicator}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-visible" => if(assigns.controlled_visible, do: data_attr(assigns.visible), else: nil),
      "data-default-visible" => if(assigns.controlled_visible, do: nil, else: data_attr(assigns.visible)),
      "data-controlled-visible" => data_attr(assigns.controlled_visible),
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "data-read-only" => data_attr(assigns.read_only),
      "data-required" => data_attr(assigns.required),
      "data-ignore-password-managers" => data_attr(assigns.ignore_password_managers),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-auto-complete" => assigns.auto_complete,
      "data-on-visibility-change" => assigns.on_visibility_change,
      "data-on-visibility-change-client" => assigns.on_visibility_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "password-input:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "password-input:#{assigns.id}:label"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "password-input:#{assigns.id}:control"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "input",
      "disabled" => data_attr(assigns.disabled),
      "id" => "password-input:#{assigns.id}:input"
    }
  end

  @spec visibility_trigger(VisibilityTrigger.t()) :: map()
  def visibility_trigger(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "visibility-trigger",
      "type" => "button",
      "dir" => assigns.dir,
      "id" => "password-input:#{assigns.id}:visibility-trigger"
    }
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "indicator",
      "dir" => assigns.dir,
      "id" => "password-input:#{assigns.id}:indicator"
    }
  end
end
