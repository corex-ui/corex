defmodule Mix.Corex.Install.LayoutBuilderDetectionTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.LayoutBuilder

  defp stock_app_module do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      embed_templates "layouts/*"

      attr :flash, :map, required: true
      attr :current_scope, :map, default: nil
      slot :inner_block, required: true

      def app(assigns) do
        ~H\"""
        <header class="navbar px-4 sm:px-6 lg:px-8">
          <div class="flex-1">
            <a href="/" class="flex-1 flex items-center w-fit gap-2">
              <span>v\#{Application.spec(:phoenix, :vsn)}</span>
            </a>
          </div>
          <div class="flex-none">
            <ul class="flex column gap-4">
              <li><a href="https://phoenixframework.org/">Website</a></li>
              <li><a href="https://github.com/phoenixframework/phoenix">GitHub</a></li>
            </ul>
          </div>
        </header>

        <main>
          {render_slot(@inner_block)}
        </main>
        <.flash_group flash={@flash} />
        \"""
      end
    end
    """
  end

  defp touched_app_module do
    """
    defmodule MyAppWeb.Layouts do
      use MyAppWeb, :html

      attr :flash, :map, required: true
      slot :inner_block, required: true

      def app(assigns) do
        ~H\"""
        <header class="layout__header">
          <div class="layout__header__content">
            <a href="/" class="ui-link ui-link--brand">Corex</a>
          </div>
        </header>
        <main class="layout__main">
          {render_slot(@inner_block)}
        </main>
        <.toast_group id="layout-toast" flash={@flash}>
          <:loading>Loading…</:loading>
          <:close>Close</:close>
        </.toast_group>
        \"""
      end
    end
    """
  end

  describe "stock_phx_app_def?/1" do
    test "detects stock Phoenix 1.8 def app" do
      assert LayoutBuilder.stock_phx_app_def?(stock_app_module())
    end

    test "rejects Corex-touched def app" do
      refute LayoutBuilder.stock_phx_app_def?(touched_app_module())
    end

    test "rejects content with no def app at all" do
      refute LayoutBuilder.stock_phx_app_def?("defmodule X do\nend\n")
    end

    test "rejects body that has phoenixframework.org but no <.flash_group flash={@flash}" do
      content = """
      defmodule X do
        def app(assigns) do
          ~H\"""
          <a href="https://phoenixframework.org/">Website</a>
          \"""
        end
      end
      """

      refute LayoutBuilder.stock_phx_app_def?(content)
    end
  end

  describe "stock_phx_home?/1" do
    test "detects stock Phoenix home page content" do
      content = """
      <Layouts.app flash={@flash}>
        <h1>Phoenix Framework</h1>
        <p>Peace of mind from prototype to production.</p>
      </Layouts.app>
      """

      assert LayoutBuilder.stock_phx_home?(content)
    end

    test "rejects Corex-replaced home" do
      content = """
      <Layouts.app flash={@flash}>
        <h1>Welcome to Corex</h1>
      </Layouts.app>
      """

      refute LayoutBuilder.stock_phx_home?(content)
    end
  end
end
