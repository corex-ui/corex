defmodule Corex.Image do
  @moduledoc ~S'''
  Data struct for image slides in [`Corex.Carousel`](Corex.Carousel.html).

  Not a Phoenix component — there is no `<.image>` function. Use [`Corex.Image.new/2`](Corex.Image.html#new/2)
  to build `items` for a carousel image gallery; the carousel renders each entry as a plain HTML `<img>`.
  For custom slide markup (cards, blog posts, mixed content), pass arbitrary `items` and use
  `<:item :let={item}>` on [`<.carousel>`](Corex.Carousel.html#carousel/1) instead.

  ## Fields

  | Field | Type | Required | Description |
  | ----- | ---- | -------- | ----------- |
  | `src` | `String.t()` | yes | Image URL or path (e.g. from `~p"/images/photo.jpg"`) |
  | `alt` | `String.t()` | no | Accessible alternative text (defaults to `""`) |
  | `class` | `String.t()` | no | Optional class on the rendered `<img>` |

  ## Examples

      iex> Corex.Image.new("/images/beach.jpg", alt: "Beach")
      %Corex.Image{src: "/images/beach.jpg", alt: "Beach", class: nil}

      iex> Corex.Image.new("/images/logo.png", alt: "Logo", class: "rounded-md")
      %Corex.Image{src: "/images/logo.png", alt: "Logo", class: "rounded-md"}

  ```heex
  <.carousel
    class="carousel"
    items={[
      Corex.Image.new(~p"/images/beach.jpg", alt: "Beach"),
      Corex.Image.new(~p"/images/fall.jpg", alt: "Fall")
    ]}
  >
    <:prev_trigger><.heroicon name="hero-arrow-left" /></:prev_trigger>
    <:next_trigger><.heroicon name="hero-arrow-right" /></:next_trigger>
  </.carousel>
  ```
  '''

  @enforce_keys [:src]
  defstruct [:src, :alt, :class]

  @type t :: %__MODULE__{
          src: String.t(),
          alt: String.t(),
          class: String.t() | nil
        }

  @doc """
  Builds an image slide value for carousel `items`.

  ## Examples

      Corex.Image.new(~p"/images/beach.jpg", alt: "Beach")
  """
  @spec new(String.t(), keyword()) :: t()
  def new(src, opts \\ []) when is_binary(src) do
    %__MODULE__{
      src: src,
      alt: Keyword.get(opts, :alt, ""),
      class: Keyword.get(opts, :class)
    }
  end
end
