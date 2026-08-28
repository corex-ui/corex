defmodule CorexAdmin.Live do
  @moduledoc """
  Generic admin LiveViews via `use CorexAdmin.Live, :index | :show | :form | :home`.

  Package modules (`CorexAdmin.Live.Index` and friends) are one-liners. Host apps
  override a page with `live: [index: MyAppWeb.Admin.PostIndexLive]` on the
  resource, or `mix corex.admin.gen.live PostResource` which writes a thin
  wrapper that still `use`s this module.

  Callbacks are `defoverridable` so a host LiveView can override `render/1` or
  `handle_event/3` and call `super`. Chrome is function components in
  `CorexAdmin.Components.*` — do not copy package LiveView internals into the
  host.
  """

  defmacro __using__(:index) do
    quote do
      use Phoenix.LiveView
      use Corex

      @impl true
      def mount(params, session, socket) do
        CorexAdmin.Live.Index.Controller.mount(params, session, socket)
      end

      @impl true
      def handle_params(params, uri, socket) do
        CorexAdmin.Live.Index.Controller.handle_params(params, uri, socket)
      end

      @impl true
      def handle_event(event, params, socket) do
        CorexAdmin.Live.Index.Controller.handle_event(event, params, socket)
      end

      @impl true
      def render(assigns) do
        CorexAdmin.UI.Index.page(assigns)
      end

      defoverridable mount: 3, handle_params: 3, handle_event: 3, render: 1
    end
  end

  defmacro __using__(:show) do
    quote do
      use Phoenix.LiveView
      use Corex

      @impl true
      def mount(params, session, socket) do
        CorexAdmin.Live.Show.Controller.mount(params, session, socket)
      end

      @impl true
      def handle_params(params, uri, socket) do
        CorexAdmin.Live.Show.Controller.handle_params(params, uri, socket)
      end

      @impl true
      def handle_event(event, params, socket) do
        CorexAdmin.Live.Show.Controller.handle_event(event, params, socket)
      end

      @impl true
      def render(assigns) do
        CorexAdmin.UI.Show.page(assigns)
      end

      defoverridable mount: 3, handle_params: 3, handle_event: 3, render: 1
    end
  end

  defmacro __using__(:form) do
    quote do
      use Phoenix.LiveView
      use Corex

      @impl true
      def mount(params, session, socket) do
        CorexAdmin.Live.Form.Controller.mount(params, session, socket)
      end

      @impl true
      def handle_params(params, uri, socket) do
        CorexAdmin.Live.Form.Controller.handle_params(params, uri, socket)
      end

      @impl true
      def handle_event(event, params, socket) do
        CorexAdmin.Live.Form.Controller.handle_event(event, params, socket)
      end

      @impl true
      def render(assigns) do
        CorexAdmin.UI.Form.page(assigns)
      end

      defoverridable mount: 3, handle_params: 3, handle_event: 3, render: 1
    end
  end

  defmacro __using__(:home) do
    quote do
      use Phoenix.LiveView
      use Corex

      @impl true
      def mount(params, session, socket) do
        CorexAdmin.Live.Home.Controller.mount(params, session, socket)
      end

      @impl true
      def render(assigns) do
        CorexAdmin.UI.Home.page(assigns)
      end

      defoverridable mount: 3, render: 1
    end
  end
end
