defmodule E2eWeb.Router do
  import LiveCapture.Router
  use E2eWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug E2eWeb.Plugs.Mode
    plug E2eWeb.Plugs.Theme
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

  scope "/" do
    pipe_through :browser
    live_capture "/captures", [E2eWeb.LiveCapture]
  end

  scope "/:locale", E2eWeb do
    pipe_through :browser

    live_session :default, on_mount: [E2eWeb.ModeLive, E2eWeb.ThemeLive, E2eWeb.SharedEvents] do
      live "/live/accordion", AccordionLive
      live "/playground/accordion", AccordionPlayLive
      live "/controlled/accordion", AccordionControlledLive
      live "/async/accordion", AccordionAsyncLive
      live "/live/checkbox", CheckboxLive
      live "/live/checkbox/form", CheckboxFormLive
      live "/live/checkbox/controlled", CheckboxControlledLive
      live "/live/switch/form", SwitchFormLive
      live "/live/switch/controlled", SwitchControlledLive
      live "/live/clipboard", ClipboardLive
      live "/live/code", CodeLive
      live "/live/action", ActionLive
      live "/live/navigate", NavigateLive
      live "/live/layout-heading", LayoutHeadingLive
      live "/live/collapsible", CollapsibleLive
      live "/live/combobox", ComboboxLive
      live "/live/combobox-fetch", ComboboxFetch
      live "/live/combobox-form", ComboboxForm
      live "/live/date-picker", DatePickerLive
      live "/live/date-picker/form", DatePickerFormLive
      live "/live/date-picker/controlled", DatePickerControlledLive
      live "/live/dialog", DialogLive
      live "/live/menu", MenuLive
      live "/live/switch", SwitchLive
      live "/live/tabs", TabsLive

      live "/live/select", SelectLive
      live "/live/select/form", SelectFormLive
      live "/live/select/controlled", SelectControlledLive
      live "/live/signature", SignatureLive
      live "/live/signature/form", SignatureFormLive
      live "/live/toast", ToastLive
      live "/live/toggle-group", ToggleGroupLive
      live "/live/tree-view", TreeViewLive
      live "/live/angle-slider", AngleSliderLive
      live "/live/angle-slider/form", AngleSliderFormLive
      live "/playground/angle-slider", AngleSliderPlayLive
      live "/controlled/angle-slider", AngleSliderControlledLive
      live "/live/avatar", AvatarLive
      live "/live/carousel", CarouselLive
      live "/live/data-list", DataListLive
      live "/live/data-table", DataTableLive
      live "/live/data-table/stream", DataTableStreamLive
      live "/live/data-table/sorting", DataTableSortingLive
      live "/live/data-table/selection", DataTableSelectionLive
      live "/live/data-table/full", DataTableFullLive
      live "/live/editable", EditableLive
      live "/live/editable/form", EditableFormLive
      live "/live/floating-panel", FloatingPanelLive
      live "/live/listbox", ListboxLive
      live "/live/listbox/stream", ListboxStreamLive
      live "/live/marquee", MarqueeLive
      live "/live/color-picker", ColorPickerLive
      live "/live/color-picker/form", ColorPickerFormLive
      live "/live/number-input", NumberInputLive
      live "/live/number-input/form", NumberInputFormLive
      live "/live/number-input/controlled", NumberInputControlledLive
      live "/live/password-input", PasswordInputLive
      live "/live/password-input/form", PasswordInputFormLive
      live "/live/pin-input", PinInputLive
      live "/live/pin-input/form", PinInputFormLive
      live "/live/native-input", NativeInputLive
      live "/live/native-input/form", NativeInputFormLive
      live "/live/radio-group", RadioGroupLive
      live "/live/radio-group/form", RadioGroupFormLive
      live "/live/timer", TimerLive
    end

    get "/", PageController, :home

    get "/accordion", PageController, :accordion_page
    get "/action", PageController, :action_page
    get "/checkbox", PageController, :checkbox_page
    get "/checkbox/form", PageController, :checkbox_form_page
    post "/checkbox/form", PageController, :checkbox_form_submit
    get "/switch/form", PageController, :switch_form_page
    post "/switch/form", PageController, :switch_form_submit

    get "/clipboard", PageController, :clipboard_page
    get "/code", PageController, :code_page

    get "/navigate", PageController, :navigate_page
    get "/layout-heading", PageController, :layout_heading_page

    get "/collapsible", PageController, :collapsible_page

    get "/combobox", PageController, :combobox_page
    get "/combobox/form", PageController, :combobox_form_page
    post "/combobox/form", PageController, :combobox_form_submit
    get "/color-picker", PageController, :color_picker_page
    get "/color-picker/form", PageController, :color_picker_form_page
    post "/color-picker/form", PageController, :color_picker_form_submit

    get "/date-picker", PageController, :date_picker_page
    get "/date-picker/form", PageController, :date_picker_form_page
    post "/date-picker/form", PageController, :date_picker_form_submit

    get "/dialog", PageController, :dialog_page

    get "/select", PageController, :select_page
    get "/select/form", PageController, :select_form_page
    post "/select/form", PageController, :select_form_submit

    get "/signature", PageController, :signature_page
    get "/signature/form", PageController, :signature_form_page
    post "/signature/form", PageController, :signature_form_submit

    get "/menu", PageController, :menu_page
    get "/switch", PageController, :switch_page

    get "/tabs", PageController, :tabs_page

    get "/toast", PageController, :toast_page
    post "/toast", PageController, :create_toast

    get "/toggle-group", PageController, :toggle_group_page
    get "/tree-view", PageController, :tree_view_page
    get "/angle-slider", PageController, :angle_slider_page
    get "/angle-slider/form", PageController, :angle_slider_form_page
    post "/angle-slider/form", PageController, :angle_slider_form_submit
    get "/avatar", PageController, :avatar_page
    get "/carousel", PageController, :carousel_page
    get "/data-list", PageController, :data_list_page
    get "/data-table", PageController, :data_table_page
    get "/editable", PageController, :editable_page
    get "/editable/form", PageController, :editable_form_page
    post "/editable/form", PageController, :editable_form_submit
    get "/floating-panel", PageController, :floating_panel_page
    get "/listbox", PageController, :listbox_page
    get "/marquee", PageController, :marquee_page
    get "/number-input", PageController, :number_input_page
    get "/number-input/form", PageController, :number_input_form_page
    post "/number-input/form", PageController, :number_input_form_submit
    get "/password-input", PageController, :password_input_page
    get "/password-input/form", PageController, :password_input_form_page
    post "/password-input/form", PageController, :password_input_form_submit
    get "/pin-input", PageController, :pin_input_page
    get "/pin-input/form", PageController, :pin_input_form_page
    post "/pin-input/form", PageController, :pin_input_form_submit
    get "/native-input", PageController, :native_input_page
    get "/native-input/form", PageController, :native_input_form_page
    post "/native-input/form", PageController, :native_input_form_submit
    get "/radio-group", PageController, :radio_group_page
    get "/radio-group/form", PageController, :radio_group_form_page
    post "/radio-group/form", PageController, :radio_group_form_submit
    get "/timer", PageController, :timer_page

    live_session :browser, on_mount: [E2eWeb.ModeLive, E2eWeb.ThemeLive, E2eWeb.SharedEvents] do
      live "/admins", AdminLive.Index, :index
      live "/admins/new", AdminLive.Form, :new
      live "/admins/:id", AdminLive.Show, :show
      live "/admins/:id/edit", AdminLive.Form, :edit
    end

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", E2eWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:corex_web, :dev_routes) do
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
