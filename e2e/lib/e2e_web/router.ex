defmodule E2eWeb.Router do
  import LiveCapture.Router
  use E2eWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug E2eWeb.Plugs.Mode
    plug E2eWeb.Plugs.Locale
    plug :put_root_layout, html: {E2eWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", E2eWeb do
    pipe_through :browser
    get "/", PageController, :home
  end


  scope "/:locale", E2eWeb do
    pipe_through :browser

    live_session :default, on_mount: [E2eWeb.ModeLive, E2eWeb.SharedEvents] do
      live "/live/accordion", AccordionLive
      live "/playground/accordion", AccordionPlayLive
      live "/controlled/accordion", AccordionControlledLive
      live "/async/accordion", AccordionAsyncLive
      live "/live/checkbox", CheckboxLive
      live "/live/clipboard", ClipboardLive
      live "/live/collapsible", CollapsibleLive
      live "/live/combobox", ComboboxLive
      live "/live/date-picker", DatePickerLive
      live "/live/dialog", DialogLive
      live "/live/menu", MenuLive
      live "/live/switch", SwitchLive
      live "/live/tabs", TabsLive

      live "/live/select", SelectLive
      live "/live/signature", SignatureLive
      live "/live/toast", ToastLive
      live "/live/toggle-group", ToggleGroupLive


    end

    get "/", PageController, :home

    get "/accordion", PageController, :accordion_page
    get "/checkbox", PageController, :checkbox_page

    get "/clipboard", PageController, :clipboard_page

    get "/collapsible", PageController, :collapsible_page

    get "/combobox", PageController, :combobox_page

    get "/date-picker", PageController, :date_picker_page

    get "/dialog", PageController, :dialog_page

    get "/select", PageController, :select_page

    get "/signature", PageController, :signature_page

    get "/menu", PageController, :menu_page
    get "/switch", PageController, :switch_page

    get "/tabs", PageController, :tabs_page

    get "/toast", PageController, :toast_page
    post "/toast", PageController, :create_toast

    get "/toggle-group", PageController, :toggle_group_page

    live_session :browser, on_mount: [E2eWeb.ModeLive, E2eWeb.SharedEvents] do
      live "/admins", AdminLive.Index, :index
      live "/admins/new", AdminLive.Form, :new
      live "/admins/:id", AdminLive.Show, :show
      live "/admins/:id/edit", AdminLive.Form, :edit
    end

    resources "/users", UserController

    live_capture "/captures", E2eWeb.LiveCapture
  end

  # Other scopes may use custom stacks.
  # scope "/api", E2eWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:e2e, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: E2eWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
