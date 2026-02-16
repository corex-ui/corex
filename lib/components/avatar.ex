defmodule Corex.Avatar do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Avatar](https://zagjs.com/components/react/avatar).

  ## Examples

  ### Basic

  ```heex
  <.avatar id="avatar" src="/me.jpg" class="avatar">
    <:fallback>JD</:fallback>
  </.avatar>
  ```

  ## Styling

  Use data attributes: `[data-scope="avatar"][data-part="root"]`, `image`, `fallback`, `skeleton`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.Avatar.Anatomy.{Props, Root, Image, Fallback, Skeleton}
  alias Corex.Avatar.Connect

  attr(:id, :string, required: false, doc: "The id of the avatar")
  attr(:src, :string, default: nil, doc: "Image source URL")
  attr(:alt, :string, default: "", doc: "Alternative text for the image")

  attr(:on_status_change, :string,
    default: nil,
    doc: "Server event when image load status changes"
  )

  attr(:on_status_change_client, :string,
    default: nil,
    doc: "Client event when image load status changes"
  )

  attr(:rest, :global)

  slot(:fallback, required: true)

  def avatar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "avatar-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="Avatar"
      data-src={@src}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        on_status_change: @on_status_change,
        on_status_change_client: @on_status_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id})}>
        <span
          :if={@src}
          data-state="visible"
          {Connect.skeleton(%Skeleton{id: @id})}
        />
        <img
          :if={@src}
          hidden
          data-state="hidden"
          alt={@alt}
          {Connect.image(%Image{id: @id, src: @src})}
        />
        <span
          data-state={if @src, do: "hidden", else: "visible"}
          hidden={@src != nil}
          {Connect.fallback(%Fallback{id: @id})}
        >
          {render_slot(@fallback)}
        </span>
      </div>
    </div>
    """
  end
end
