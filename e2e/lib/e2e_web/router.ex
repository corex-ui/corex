defmodule E2eWeb.Router do
  import LiveCapture.Router
  use E2eWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug E2eWeb.Plugs.Mode
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

      get "/accordion", PageController, :accordion_page
      live "/live/accordion", AccordionLive
      live "/playground/accordion", AccordionPlayLive
      live "/controlled/accordion", AccordionControlledLive
      live "/async/accordion", AccordionAsyncLive

      get "/checkbox", PageController, :checkbox_page
      live "/live/checkbox", CheckboxLive

      get "/clipboard", PageController, :clipboard_page
      live "/live/clipboard", ClipboardLive

      get "/collapsible", PageController, :collapsible_page
      live "/live/collapsible", CollapsibleLive

      get "/combobox", PageController, :combobox_page
      live "/live/combobox", ComboboxLive

      get "/date-picker", PageController, :date_picker_page
      live "/live/date-picker", DatePickerLive

      get "/dialog", PageController, :dialog_page
      live "/live/dialog", DialogLive

      get "/select", PageController, :select_page
      live "/live/select", SelectLive

      get "/switch", PageController, :switch_page
      live "/live/switch", SwitchLive

      get "/tabs", PageController, :tabs_page
      live "/live/tabs", TabsLive

      get "/toast", PageController, :toast_page
      post "/toast", PageController, :create_toast
      live "/live/toast", ToastLive

      get "/toggle-group", PageController, :toggle_group_page
      live "/live/toggle-group", ToggleGroupLive

      live "/admins", AdminLive.Index, :index
      live "/admins/new", AdminLive.Form, :new
      live "/admins/:id", AdminLive.Show, :show
      live "/admins/:id/edit", AdminLive.Form, :edit

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
