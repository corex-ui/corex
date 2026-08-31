defmodule Corex.ImageCropper.Connect do
  @moduledoc false
  use Corex.Connect.Mounted
  use Corex.Component, :connect

  alias Corex.ImageCropper.Anatomy.{Handle, Image, Props, Root, Selection, Viewport}
  alias Corex.Selectors
  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-dir" => Map.get(assigns, :dir),
      "data-src" => Map.get(assigns, :src),
      "data-on-value-change" => Map.get(assigns, :on_value_change),
      "data-on-value-change-client" => Map.get(assigns, :on_value_change_client)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "image-cropper",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "id" => "image-cropper:" <> assigns.id <> ":root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("image-cropper:" <> assigns.id <> ":root")
    )
  end

  @spec viewport(Viewport.t()) :: map()
  def viewport(assigns) do
    %{
      "data-scope" => "image-cropper",
      "data-part" => "viewport",
      "dir" => Map.get(assigns, :dir),
      "id" => "image-cropper:" <> assigns.id <> ":viewport"
    }
  end

  def ignore_viewport(assigns) do
    JS.ignore_attributes(Viewport.ignored_attrs(),
      to: Selectors.css_id("image-cropper:" <> assigns.id <> ":viewport")
    )
  end

  @spec image(Image.t()) :: map()
  def image(assigns) do
    %{
      "data-scope" => "image-cropper",
      "data-part" => "image",
      "dir" => Map.get(assigns, :dir),
      "id" => "image-cropper:" <> assigns.id <> ":image"
    }
  end

  def ignore_image(assigns) do
    JS.ignore_attributes(Image.ignored_attrs(),
      to: Selectors.css_id("image-cropper:" <> assigns.id <> ":image")
    )
  end

  @spec selection(Selection.t()) :: map()
  def selection(assigns) do
    %{
      "data-scope" => "image-cropper",
      "data-part" => "selection",
      "dir" => Map.get(assigns, :dir),
      "id" => "image-cropper:" <> assigns.id <> ":selection"
    }
  end

  def ignore_selection(assigns) do
    JS.ignore_attributes(Selection.ignored_attrs(),
      to: Selectors.css_id("image-cropper:" <> assigns.id <> ":selection")
    )
  end

  @spec handle(Handle.t()) :: map()
  def handle(assigns) do
    %{
      "data-scope" => "image-cropper",
      "data-part" => "handle",
      "dir" => Map.get(assigns, :dir),
      "data-position" => assigns.position,
      "id" => "image-cropper:" <> assigns.id <> ":handle:" <> assigns.position
    }
  end

  def ignore_handle(assigns) do
    JS.ignore_attributes(Handle.ignored_attrs(),
      to: Selectors.css_id("image-cropper:" <> assigns.id <> ":handle:" <> assigns.position)
    )
  end
end
