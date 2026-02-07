defmodule E2eWeb.Router do
  import LiveCapture.Router
  use E2eWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
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

    get "/switch", PageController, :switch_page
    get "/toggle-group", PageController, :toggle_group_page
    get "/combobox", PageController, :combobox_page
    get "/toast", PageController, :toast_page
    post "/toast", PageController, :create_toast
    get "/select", PageController, :select_page
    live "/live/toast", ToastLive
    live "/live/select", SelectLive
    live "/live/combobox", ComboboxLive
    live "/live/switch", SwitchLive
    get "/checkbox", PageController, :checkbox_page
    live "/live/checkbox", CheckboxLive
    live "/admins", AdminLive.Index, :index
    live "/admins/new", AdminLive.Form, :new
    live "/admins/:id", AdminLive.Show, :show
    live "/admins/:id/edit", AdminLive.Form, :edit
    live_capture "/captures", E2eWeb.LiveCapture
    resources "/users", UserController
    get "/tabs", PageController, :tabs_page
    live "/live/tabs", TabsLive
    live "/live/toggle-group", ToggleGroupLive
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
