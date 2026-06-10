defmodule E2eWeb.Router do
  use E2eWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug(E2eWeb.Plugs.Mode)
    plug(E2eWeb.Plugs.Theme)
    plug(E2eWeb.Plugs.DocAuthoring)
    plug(E2eWeb.Plugs.PreviewContext)

    plug(Localize.Plug.PutLocale,
      from: [:path, :session, :query],
      gettext: E2eWeb.Gettext,
      param: "locale",
      default: :en
    )

    plug(Localize.Plug.PutSession)
    plug(E2eWeb.Plugs.Path)
    plug(E2eWeb.Plugs.SEO)
    plug(:put_root_layout, html: {E2eWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", E2eWeb do
    pipe_through(:browser)

    get("/sitemap.xml", SitemapController, :index)
    get("/feed.xml", FeedController, :index)

    get("/", HomeController, :index)
  end

  scope "/:locale", E2eWeb do
    pipe_through(:browser)

    get("/", HomeController, :index)
    get("/blog", BlogController, :index)
    get("/blog/:slug", BlogController, :show)
    get("/showcases", ShowcasesController, :index)

    live_session :default,
      on_mount: [
        E2eWeb.ModeLive,
        E2eWeb.ThemeLive,
        E2eWeb.DocAuthoringLive,
        E2eWeb.PathLive,
        E2eWeb.MountTelemetry,
        E2eWeb.SEO.Live
      ] do
      live("/showcases/tetrex", TetrexIndexLive, :index)
      live("/showcases/tetrex/new", TetrexLive, :new)
      live("/showcases/tetrex/:id/replay", TetrexLive, :replay)
      live("/showcases/tetrex/:id/watch", TetrexLive, :watch)
      live("/showcases/tetrex/:id", TetrexLive, :show)

      live("/admins", AdminLive.Index, :index)
      live("/admins/new", AdminLive.Form, :new)
      live("/admins/:id", AdminLive.Show, :show)
      live("/admins/:id/edit", AdminLive.Form, :edit)

      live("/forms/patterns", FormPatternsLive)

      live("/action/patterns", ActionPatternsLive)
      live("/action/style", ActionStyleLive)

      live("/accordion/playground", AccordionPlayLive)
      live("/accordion/style", AccordionStyleLive)
      live("/accordion/api", AccordionApiLive)
      live("/accordion/events", AccordionEventsLive)
      live("/accordion/patterns", AccordionPatternsLive)
      live("/accordion/animation", AccordionAnimationLive)

      live("/tree-view/playground", TreeViewPlayLive)
      live("/tree-view/api", TreeViewApiLive)
      live("/tree-view/events", TreeViewEventsLive)
      live("/tree-view/patterns", TreeViewPatternsLive)
      live("/tree-view/animation", TreeViewAnimationLive)

      live("/angle-slider/playground", AngleSliderPlayLive)
      live("/angle-slider/api", AngleSliderApiLive)
      live("/angle-slider/events", AngleSliderEventsLive)
      live("/angle-slider/patterns", AngleSliderPatternsLive)
      live("/angle-slider/controlled", AngleSliderControlledLive)
      live("/angle-slider/live-form", AngleSliderFormLive)

      live("/avatar/playground", AvatarPlayLive)
      live("/avatar/api", AvatarApiLive)
      live("/avatar/events", AvatarEventsLive)

      live("/carousel/playground", CarouselPlayLive)
      live("/carousel/api", CarouselApiLive)
      live("/carousel/events", CarouselEventsLive)

      live("/checkbox/playground", CheckboxPlayLive)
      live("/checkbox/api", CheckboxApiLive)
      live("/checkbox/events", CheckboxEventsLive)
      live("/checkbox/patterns", CheckboxPatternsLive)
      live("/checkbox/live-form", CheckboxFormLive)
      live("/clipboard/playground", ClipboardPlayLive)
      live("/clipboard/api", ClipboardApiLive)
      live("/clipboard/events", ClipboardEventsLive)

      live("/collapsible/playground", CollapsiblePlayLive)
      live("/collapsible/api", CollapsibleApiLive)
      live("/collapsible/events", CollapsibleEventsLive)
      live("/collapsible/patterns", CollapsiblePatternsLive)

      live("/color-picker/playground", ColorPickerPlayLive)
      live("/color-picker/api", ColorPickerApiLive)
      live("/color-picker/events", ColorPickerEventsLive)
      live("/color-picker/live-form", ColorPickerFormLive)

      live("/combobox/playground", ComboboxPlayLive)
      live("/combobox/api", ComboboxApiLive)
      live("/combobox/events", ComboboxEventsLive)
      live("/combobox/patterns", ComboboxPatternsLive)
      live("/combobox/live-form", ComboboxForm)

      live("/data-table/patterns", DataTablePatternsLive)
      live("/data-table/playground", DataTablePlayLive)
      live("/data-table/style", DataTableStyleLive)

      live("/data-list/playground", DataListPlayLive)
      live("/data-list/patterns", DataListPatternsLive)

      live("/date-picker/playground", DatePickerPlayLive)
      live("/date-picker/api", DatePickerApiLive)
      live("/date-picker/events", DatePickerEventsLive)
      live("/date-picker/patterns", DatePickerPatternsLive)
      live("/date-picker/live-form", DatePickerFormLive)

      live("/dialog/playground", DialogPlayLive)
      live("/dialog/api", DialogApiLive)
      live("/dialog/events", DialogEventsLive)
      live("/dialog/patterns", DialogPatternsLive)
      live("/dialog/animation", DialogAnimationLive)

      live("/editable/playground", EditablePlayLive)
      live("/editable/api", EditableApiLive)
      live("/editable/events", EditableEventsLive)
      live("/editable/live-form", EditableFormLive)

      live("/file-upload/playground", FileUploadPlayLive)
      live("/file-upload/api", FileUploadApiLive)
      live("/file-upload/events", FileUploadEventsLive)

      live("/file-upload-live/playground", FileUploadLivePlayLive)
      live("/file-upload-live/anatomy", FileUploadLiveAnatomyLive)
      live("/file-upload-live/form", FileUploadFormLive)

      live("/floating-panel/playground", FloatingPanelPlayLive)
      live("/floating-panel/api", FloatingPanelApiLive)
      live("/floating-panel/events", FloatingPanelEventsLive)

      live("/listbox/playground", ListboxPlayLive)
      live("/listbox/api", ListboxApiLive)
      live("/listbox/events", ListboxEventsLive)
      live("/listbox/patterns", ListboxPatternsLive)

      live("/marquee/api", MarqueeApiLive)
      live("/marquee/events", MarqueeEventsLive)

      live("/menu/playground", MenuPlayLive)
      live("/menu/api", MenuApiLive)
      live("/menu/events", MenuEventsLive)
      live("/menu/patterns", MenuPatternsLive)

      live("/navigate/patterns", NavigatePatternsLive)

      live("/native-input/playground", NativeInputPlayLive)
      live("/native-input/live-form", NativeInputFormLive)

      live("/number-input/playground", NumberInputPlayLive)
      live("/number-input/api", NumberInputApiLive)
      live("/number-input/events", NumberInputEventsLive)
      live("/number-input/live-form", NumberInputFormLive)

      live("/password-input/playground", PasswordInputPlayLive)
      live("/password-input/api", PasswordInputApiLive)
      live("/password-input/events", PasswordInputEventsLive)
      live("/password-input/live-form", PasswordInputFormLive)

      live("/pin-input/playground", PinInputPlayLive)
      live("/pin-input/api", PinInputApiLive)
      live("/pin-input/events", PinInputEventsLive)
      live("/pin-input/live-form", PinInputFormLive)

      live("/radio-group/playground", RadioGroupPlayLive)
      live("/radio-group/api", RadioGroupApiLive)
      live("/radio-group/events", RadioGroupEventsLive)
      live("/radio-group/patterns", RadioGroupPatternsLive)
      live("/radio-group/live-form", RadioGroupFormLive)

      live("/select/playground", SelectPlayLive)
      live("/select/api", SelectApiLive)
      live("/select/events", SelectEventsLive)
      live("/select/patterns", SelectPatternsLive)
      live("/select/live-form", SelectFormLive)

      live("/signature-pad/playground", SignaturePlayLive)
      live("/signature-pad/api", SignatureApiLive)
      live("/signature-pad/events", SignatureEventsLive)
      live("/signature-pad/live-form", SignatureFormLive)

      live("/switch/playground", SwitchPlayLive)
      live("/switch/api", SwitchApiLive)
      live("/switch/events", SwitchEventsLive)
      live("/switch/patterns", SwitchPatternsLive)
      live("/switch/live-form", SwitchFormLive)

      live("/tabs/playground", TabsPlayLive)
      live("/tabs/api", TabsApiLive)
      live("/tabs/events", TabsEventsLive)
      live("/tabs/patterns", TabsPatternsLive)

      live("/tags-input/playground", TagsInputPlayLive)
      live("/tags-input/api", TagsInputApiLive)
      live("/tags-input/events", TagsInputEventsLive)
      live("/tags-input/patterns", TagsInputPatternsLive)
      live("/tags-input/live-form", TagsInputFormLive)

      live("/timer/playground", TimerPlayLive)
      live("/timer/api", TimerApiLive)
      live("/timer/events", TimerEventsLive)

      live("/toast/playground", ToastPlayLive)
      live("/toast/api", ToastApiLive)

      live("/toggle/playground", TogglePlayLive)
      live("/toggle/api", ToggleApiLive)
      live("/toggle/events", ToggleEventsLive)
      live("/toggle/patterns", TogglePatternsLive)

      live("/pagination/playground", PaginationPlayLive)
      live("/pagination/api", PaginationApiLive)
      live("/pagination/events", PaginationEventsLive)
      live("/pagination/patterns", PaginationPatternsLive)

      live("/toggle-group/playground", ToggleGroupPlayLive)
      live("/toggle-group/api", ToggleGroupApiLive)
      live("/toggle-group/events", ToggleGroupEventsLive)
      live("/toggle-group/patterns", ToggleGroupPatternsLive)

      live("/tooltip/api", TooltipApiLive)
      live("/tooltip/events", TooltipEventsLive)
      live("/tooltip/patterns", TooltipPatternsLive)
      live("/tooltip/style", TooltipStyleLive)

      live("/angle-slider/style", AngleSliderStyleLive)
      live("/avatar/style", AvatarStyleLive)
      live("/carousel/style", CarouselStyleLive)
      live("/checkbox/style", CheckboxStyleLive)
      live("/clipboard/style", ClipboardStyleLive)
      live("/code/style", CodeStyleLive)
      live("/collapsible/style", CollapsibleStyleLive)
      live("/color-picker/style", ColorPickerStyleLive)
      live("/combobox/style", ComboboxStyleLive)
      live("/data-list/style", DataListStyleLive)
      live("/date-picker/style", DatePickerStyleLive)
      live("/dialog/style", DialogStyleLive)
      live("/editable/style", EditableStyleLive)
      live("/file-upload/style", FileUploadStyleLive)
      live("/floating-panel/style", FloatingPanelStyleLive)
      live("/layout-heading/style", LayoutHeadingStyleLive)
      live("/listbox/style", ListboxStyleLive)
      live("/marquee/style", MarqueeStyleLive)
      live("/menu/style", MenuStyleLive)
      live("/native-input/style", NativeInputStyleLive)
      live("/navigate/style", NavigateStyleLive)
      live("/number-input/style", NumberInputStyleLive)
      live("/pagination/style", PaginationStyleLive)
      live("/password-input/style", PasswordInputStyleLive)
      live("/pin-input/style", PinInputStyleLive)
      live("/radio-group/style", RadioGroupStyleLive)
      live("/select/style", SelectStyleLive)
      live("/signature-pad/style", SignaturePadStyleLive)
      live("/switch/style", SwitchStyleLive)
      live("/tabs/style", TabsStyleLive)
      live("/tags-input/style", TagsInputStyleLive)
      live("/timer/style", TimerStyleLive)
      live("/toast/style", ToastStyleLive)
      live("/toggle/style", ToggleStyleLive)
      live("/toggle-group/style", ToggleGroupStyleLive)
      live("/tree-view/style", TreeViewStyleLive)
    end

    get("/templates", ShowcaseRedirectController, :to_showcases)
    get("/games", ShowcaseRedirectController, :to_showcases)
    get("/games/tetrex/*rest", ShowcaseRedirectController, :games_tetrex)
    get("/showcases/soonex", ShowcaseRedirectController, :to_showcases)
    get("/showcases/soonex-i18n", ShowcaseRedirectController, :to_showcases)

    get("/accordion/anatomy", PageController, :accordion_page)
    get("/action/anatomy", PageController, :action_page)
    get("/checkbox/anatomy", PageController, :checkbox_page)
    get("/checkbox/form", PageController, :checkbox_form_page)
    post("/checkbox/form", PageController, :checkbox_form_submit)
    get("/switch/anatomy", PageController, :switch_page)
    get("/switch/form", PageController, :switch_form_page)
    post("/switch/form", PageController, :switch_form_submit)

    get("/clipboard/anatomy", PageController, :clipboard_page)
    get("/code/anatomy", PageController, :code_page)

    get("/navigate/anatomy", PageController, :navigate_page)
    get("/layout-heading/anatomy", PageController, :layout_heading_page)
    get("/layout-typography", PageController, :layout_typography_page)

    get("/collapsible/anatomy", PageController, :collapsible_page)

    get("/combobox/anatomy", PageController, :combobox_page)
    get("/combobox/form", PageController, :combobox_form_page)
    post("/combobox/form", PageController, :combobox_form_submit)
    get("/color-picker/anatomy", PageController, :color_picker_page)
    get("/color-picker/form", PageController, :color_picker_form_page)
    post("/color-picker/form", PageController, :color_picker_form_submit)

    get("/date-picker/anatomy", PageController, :date_picker_page)
    get("/date-picker/form", PageController, :date_picker_form_page)
    post("/date-picker/form", PageController, :date_picker_form_submit)

    get("/dialog/anatomy", PageController, :dialog_page)

    get("/select/anatomy", PageController, :select_page)
    get("/select/form", PageController, :select_form_page)
    post("/select/form", PageController, :select_form_submit)

    get("/signature-pad/anatomy", PageController, :signature_page)
    get("/signature-pad/form", PageController, :signature_form_page)
    post("/signature-pad/form", PageController, :signature_form_submit)

    get("/menu/anatomy", PageController, :menu_page)

    get("/tabs/anatomy", PageController, :tabs_page)

    get("/tags-input/anatomy", PageController, :tags_input_page)
    get("/tags-input/form", PageController, :tags_input_form_page)
    post("/tags-input/form", PageController, :tags_input_form_submit)

    get("/toggle/anatomy", PageController, :toggle_page)

    get("/pagination/anatomy", PageController, :pagination_page)

    get("/toggle-group/anatomy", PageController, :toggle_group_page)
    get("/tree-view/anatomy", PageController, :tree_view_page)
    get("/angle-slider/anatomy", PageController, :angle_slider_page)
    get("/angle-slider/form", PageController, :angle_slider_form_page)
    post("/angle-slider/form", PageController, :angle_slider_form_submit)
    get("/avatar/anatomy", PageController, :avatar_page)
    get("/carousel/anatomy", PageController, :carousel_page)
    get("/data-list/anatomy", PageController, :data_list_page)
    get("/data-table/anatomy", PageController, :data_table_page)
    get("/editable/anatomy", PageController, :editable_page)
    get("/editable/form", PageController, :editable_form_page)
    post("/editable/form", PageController, :editable_form_submit)
    get("/file-upload/anatomy", PageController, :file_upload_page)
    get("/file-upload/form", PageController, :file_upload_form_page)
    post("/file-upload/form", PageController, :file_upload_form_submit)
    get("/floating-panel/anatomy", PageController, :floating_panel_page)
    get("/listbox/anatomy", PageController, :listbox_page)
    get("/marquee/anatomy", PageController, :marquee_page)
    get("/number-input/anatomy", PageController, :number_input_page)
    get("/number-input/form", PageController, :number_input_form_page)
    post("/number-input/form", PageController, :number_input_form_submit)
    get("/password-input/anatomy", PageController, :password_input_page)
    get("/password-input/form", PageController, :password_input_form_page)
    post("/password-input/form", PageController, :password_input_form_submit)
    get("/pin-input/anatomy", PageController, :pin_input_page)
    get("/pin-input/form", PageController, :pin_input_form_page)
    post("/pin-input/form", PageController, :pin_input_form_submit)
    get("/native-input/anatomy", PageController, :native_input_page)
    get("/native-input/form", PageController, :native_input_form_page)
    post("/native-input/form", PageController, :native_input_form_submit)
    get("/radio-group/anatomy", PageController, :radio_group_page)
    get("/radio-group/form", PageController, :radio_group_form_page)
    post("/radio-group/form", PageController, :radio_group_form_submit)
    get("/timer/anatomy", PageController, :timer_page)
    get("/toast/anatomy", PageController, :toast_anatomy_page)
    get("/tooltip/anatomy", PageController, :tooltip_page)
    resources("/users", UserController)
  end

  if Application.compile_env(:corex_web, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: E2eWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
