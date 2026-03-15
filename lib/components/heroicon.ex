defmodule Corex.Heroicon do
  @moduledoc """
  Renders a [Heroicon](https://heroicons.com).

  This component requires Tailwind and uses a Tailwind v4 plugin to generate
  the `hero-*` utility classes. If you created your app with `mix corex.new` or
  `phx.new` you should have it by default. If not, run:

      mix corex.heroicon

  That adds the plugin to `assets/vendor` and instructs adding to your `app.css`:

      @plugin "../vendor/heroicons";

  Ensure the `:heroicons` dependency is in your `mix.exs` (e.g.
  `{:heroicons, github: "tailwindlabs/heroicons"}`).
  """

  @doc type: :component
  use Phoenix.Component

  @doc """
  Renders a Heroicon by class name.

  Heroicons come in outline, solid, mini, and micro. Use the default (outline),
  or add `-solid`, `-mini`, or `-micro` to the icon name. Customize size and
  colors with Tailwind width, height, and color classes.

  ## Examples

      <.heroicon name="hero-x-mark" />
      <.heroicon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
  """
  attr(:name, :string, required: true)
  attr(:class, :any, default: "")
  attr(:rest, :global)

  def heroicon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} {@rest} />
    """
  end
end
