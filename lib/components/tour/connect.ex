defmodule Corex.Tour.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.Tour.Anatomy.{
    Backdrop,
    CloseTrigger,
    Content,
    Description,
    Positioner,
    ProgressText,
    Props,
    Root,
    Spotlight,
    Title
  }

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    steps_json =
      Map.get(assigns, :steps_json) ||
        Corex.Dataset.encode_json(assigns.steps || Corex.Tour.default_steps())

    %{
      "id" => assigns.id,
      "data-steps" => steps_json
    }
    |> maybe_put(
      "data-on-step-change",
      Map.get(assigns, :on_step_change) || Map.get(assigns, :on_value_change)
    )
    |> maybe_put(
      "data-on-step-change-client",
      Map.get(assigns, :on_step_change_client) || Map.get(assigns, :on_value_change_client)
    )
    |> put_data_dir_attr(Map.get(assigns, :dir))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":root")
    )
  end

  @spec spotlight(Spotlight.t()) :: map()
  def spotlight(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "spotlight",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":spotlight",
      "data-state" => "closed",
      "hidden" => true,
      "aria-hidden" => "true"
    }
  end

  def ignore_spotlight(assigns) do
    JS.ignore_attributes(Spotlight.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":spotlight")
    )
  end

  @spec backdrop(Backdrop.t()) :: map()
  def backdrop(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "backdrop",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":backdrop",
      "data-state" => "closed",
      "hidden" => true,
      "aria-hidden" => "true"
    }
  end

  def ignore_backdrop(assigns) do
    JS.ignore_attributes(Backdrop.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":backdrop")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":positioner",
      "data-state" => "closed",
      "style" =>
        "position:fixed;isolation:isolate;pointer-events:none;top:0px;left:0px;transform:translate3d(0, -100vh, 0);"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":positioner")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":content",
      "data-state" => "closed",
      "hidden" => true,
      "aria-hidden" => "true"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":content")
    )
  end

  @spec title(Title.t()) :: map()
  def title(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "title",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":title"
    }
  end

  def ignore_title(assigns) do
    JS.ignore_attributes(Title.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":title")
    )
  end

  @spec description(Description.t()) :: map()
  def description(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "description",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":description"
    }
  end

  def ignore_description(assigns) do
    JS.ignore_attributes(Description.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":description")
    )
  end

  @spec close_trigger(CloseTrigger.t()) :: map()
  def close_trigger(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "close-trigger",
      "type" => "button",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":close-trigger"
    }
  end

  def ignore_close_trigger(assigns) do
    JS.ignore_attributes(CloseTrigger.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":close-trigger")
    )
  end

  @spec progress_text(ProgressText.t()) :: map()
  def progress_text(assigns) do
    %{
      "data-scope" => "tour",
      "data-part" => "progress-text",
      "dir" => Map.get(assigns, :dir),
      "id" => "tour:" <> assigns.id <> ":progress-text"
    }
  end

  def ignore_progress_text(assigns) do
    JS.ignore_attributes(ProgressText.ignored_attrs(),
      to: Selectors.css_id("tour:" <> assigns.id <> ":progress-text")
    )
  end
end
