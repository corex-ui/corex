defmodule Corex.Design.ThemeDefinition do
  @moduledoc """
  Advanced: define Design config in a module instead of keyword `config :corex_design`.

  Prefer plain `config :corex_design, ...` plus `mix corex.design.build` unless you
  need a typed module. Example:

      defmodule MyApp.Design do
        use Corex.Design.ThemeDefinition,
          output: "assets/corex"

        @impl true
        def themes, do: ~w(neo leo)a
      end

      config :corex_design, theme: MyApp.Design
  """

  @callback output() :: String.t()
  @callback default_theme() :: atom()
  @callback default_mode() :: atom()
  @callback scales() :: keyword()
  @callback themes() :: keyword() | list() | map() | nil

  defmacro __using__(opts) do
    output = Keyword.fetch!(opts, :output)
    default_theme = Keyword.get(opts, :default_theme, :neo)
    default_mode = Keyword.get(opts, :default_mode, :light)

    quote do
      @behaviour Corex.Design.ThemeDefinition

      @impl Corex.Design.ThemeDefinition
      def output, do: unquote(output)

      @impl Corex.Design.ThemeDefinition
      def default_theme, do: unquote(default_theme)

      @impl Corex.Design.ThemeDefinition
      def default_mode, do: unquote(default_mode)

      @impl Corex.Design.ThemeDefinition
      def scales, do: []

      @impl Corex.Design.ThemeDefinition
      def themes, do: nil

      defoverridable scales: 0, themes: 0, default_theme: 0, default_mode: 0
    end
  end
end
