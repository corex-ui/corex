defmodule E2eWeb.PageController do
  use E2eWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def accordion_page(conn, _params) do
    render(conn, :accordion_page)
  end

  def action_page(conn, _params) do
    render(conn, :action_page)
  end

  def navigate_page(conn, _params) do
    render(conn, :navigate_page)
  end

  def switch_page(conn, _params) do
    render(conn, :switch_page)
  end

  def toggle_group_page(conn, _params) do
    render(conn, :toggle_group_page)
  end

  def combobox_page(conn, _params) do
    render(conn, :combobox_page)
  end

  def combobox_form_page(conn, _params) do
    form =
      %E2e.Form.Combobox{}
      |> E2e.Form.Combobox.changeset(%{"name" => "", "airport" => ""})
      |> Phoenix.Component.to_form(as: :combobox, id: "combobox-form")

    render(conn, :combobox_form_page, form: form)
  end

  def combobox_form_submit(conn, params) do
    combobox_params = params["combobox"] || %{}
    name = combobox_params["name"] || ""
    country = combobox_params["country"] || combobox_params["airport"] || ""

    conn
    |> put_flash(:info, "Submitted: name=#{inspect(name)}, country=#{inspect(country)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/combobox/form")
  end

  def color_picker_page(conn, _params) do
    render(conn, :color_picker_page)
  end

  def checkbox_page(conn, _params) do
    render(conn, :checkbox_page)
  end

  def checkbox_form_page(conn, _params) do
    form =
      %E2e.Form.Terms{}
      |> E2e.Form.Terms.changeset(%{})
      |> Phoenix.Component.to_form(as: :terms, id: "checkbox-form")

    render(conn, :checkbox_form_page, form: form)
  end

  def checkbox_form_submit(conn, params) do
    terms = get_in(params, ["terms", "terms"]) || params["terms"] || params["user"]["terms"]

    conn
    |> put_flash(:info, "Submitted: terms=#{inspect(terms)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/checkbox/form")
  end

  def switch_form_page(conn, _params) do
    form =
      %E2e.Form.Preferences{}
      |> E2e.Form.Preferences.changeset(%{})
      |> Phoenix.Component.to_form(as: :preferences, id: "switch-form")

    render(conn, :switch_form_page, form: form)
  end

  def switch_form_submit(conn, params) do
    notifications =
      get_in(params, ["preferences", "notifications"]) ||
        params["notifications"] ||
        params["user"]["notifications"]

    conn
    |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/switch/form")
  end

  def toast_page(conn, params) do
    initial_values = %{
      message: params["message"] || "Hello, World!",
      type: params["type"] || "info"
    }

    changeset =
      {%{}, %{message: :string, type: :string}}
      |> Ecto.Changeset.change(initial_values)

    render(conn, :toast_page, changeset: changeset)
  end

  def create_toast(conn, %{"toast" => toast_params}) do
    changeset =
      {%{}, %{message: :string, type: :string}}
      |> Ecto.Changeset.change(%{})
      |> Ecto.Changeset.cast(toast_params, [:message, :type])
      |> Ecto.Changeset.validate_required([:message, :type])

    if changeset.valid? do
      flash_type = String.to_existing_atom(toast_params["type"])

      conn
      |> put_flash(flash_type, toast_params["message"])
      |> redirect(
        to:
          ~p"/#{conn.assigns[:locale]}/toast?message=#{toast_params["message"]}&type=#{toast_params["type"]}"
      )
    else
      render(conn, :toast_page, changeset: changeset)
    end
  end

  def select_page(conn, _params) do
    render(conn, :select_page)
  end

  def select_form_page(conn, _params) do
    form =
      %E2e.Form.SelectForm{}
      |> E2e.Form.SelectForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :select_form, id: "select-form")

    render(conn, :select_form_page, form: form)
  end

  def select_form_submit(conn, params) do
    country =
      get_in(params, ["select_form", "country"]) ||
        params["country"]

    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/select/form")
  end

  def tabs_page(conn, _params) do
    render(conn, :tabs_page)
  end

  def collapsible_page(conn, _params) do
    render(conn, :collapsible_page)
  end

  def dialog_page(conn, _params) do
    render(conn, :dialog_page)
  end

  def clipboard_page(conn, _params) do
    render(conn, :clipboard_page)
  end

  def code_page(conn, _params) do
    heredoc_example = """
    defmodule Hello do
      def world do
        "Hello, World!"
      end
    end
    """

    conn
    |> assign(:code_examples, E2eWeb.CodeExamples.all())
    |> assign(:heredoc_example, heredoc_example)
    |> render(:code_page)
  end

  def angle_slider_form_page(conn, _params) do
    render(conn, :angle_slider_form_page)
  end

  def angle_slider_form_submit(conn, params) do
    angle = get_in(params, ["angle_slider_form", "angle"]) || "0"

    conn
    |> put_flash(:info, "Submitted: angle=#{angle}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/angle-slider/form")
  end

  def color_picker_form_page(conn, _params) do
    render(conn, :color_picker_form_page)
  end

  def color_picker_form_submit(conn, params) do
    color = get_in(params, ["color_picker_form", "color"]) || "#3b82f6"

    conn
    |> put_flash(:info, "Submitted: color=#{color}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/color-picker/form")
  end

  def date_picker_page(conn, _params) do
    render(conn, :date_picker_page)
  end

  def date_picker_form_page(conn, _params) do
    form =
      %E2e.Form.DatePickerForm{}
      |> E2e.Form.DatePickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :date_picker_form, id: "date-picker-form")

    render(conn, :date_picker_form_page, form: form)
  end

  def date_picker_form_submit(conn, params) do
    date = get_in(params, ["date_picker_form", "date"]) || ""

    conn
    |> put_flash(:info, "Submitted: date=#{date}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/date-picker/form")
  end

  def signature_page(conn, _params) do
    render(conn, :signature_page)
  end

  def signature_form_page(conn, _params) do
    form =
      %E2e.Form.SignatureForm{}
      |> E2e.Form.SignatureForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :signature_form, id: "signature-form")

    render(conn, :signature_form_page, form: form)
  end

  def signature_form_submit(conn, params) do
    sig = get_in(params, ["signature_form", "signature"]) || ""
    preview = if sig != "", do: String.slice(sig, 0, 30) <> "...", else: "(empty)"

    conn
    |> put_flash(:info, "Submitted: signature=#{preview}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/signature/form")
  end

  def menu_page(conn, _params) do
    render(conn, :menu_page)
  end

  def tree_view_page(conn, _params) do
    render(conn, :tree_view_page)
  end

  def layout_heading_page(conn, _params) do
    render(conn, :layout_heading_page)
  end

  def angle_slider_page(conn, _params) do
    render(conn, :angle_slider_page)
  end

  def avatar_page(conn, _params) do
    render(conn, :avatar_page)
  end

  def carousel_page(conn, _params) do
    render(conn, :carousel_page)
  end

  def data_list_page(conn, _params) do
    render(conn, :data_list_page)
  end

  def data_table_page(conn, _params) do
    render(conn, :data_table_page)
  end

  def editable_page(conn, _params) do
    render(conn, :editable_page, value_text: "My custom value")
  end

  def editable_form_page(conn, _params) do
    render(conn, :editable_form_page)
  end

  def editable_form_submit(conn, params) do
    text = get_in(params, ["editable_form", "text"]) || ""

    conn
    |> put_flash(:info, "Submitted: text=#{inspect(text)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/editable/form")
  end

  def native_input_page(conn, _params) do
    render(conn, :native_input_page)
  end

  def native_input_form_page(conn, _params) do
    render(conn, :native_input_form_page)
  end

  def native_input_form_submit(conn, params) do
    profile = params["profile"] || %{}

    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(profile)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/native-input/form")
  end

  def floating_panel_page(conn, _params) do
    render(conn, :floating_panel_page)
  end

  def listbox_page(conn, _params) do
    render(conn, :listbox_page)
  end

  def marquee_page(conn, _params) do
    render(conn, :marquee_page)
  end

  def number_input_page(conn, _params) do
    render(conn, :number_input_page)
  end

  def number_input_form_page(conn, _params) do
    form =
      %E2e.Form.NumberInputForm{}
      |> E2e.Form.NumberInputForm.changeset(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_form, id: "number-input-form")

    render(conn, :number_input_form_page, form: form)
  end

  def number_input_form_submit(conn, params) do
    value = params["value"] || get_in(params, ["number_input_form", "value"]) || "0"

    conn
    |> put_flash(:info, "Submitted: value=#{value}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/number-input/form")
  end

  def password_input_page(conn, _params) do
    render(conn, :password_input_page)
  end

  def password_input_form_page(conn, _params) do
    form =
      %E2e.Form.PasswordInputForm{}
      |> E2e.Form.PasswordInputForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :password_input_form, id: "password-input-form")

    render(conn, :password_input_form_page, form: form)
  end

  def password_input_form_submit(conn, params) do
    _password = get_in(params, ["password_input_form", "password"])

    conn
    |> put_flash(:info, "Submitted: password=***")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/password-input/form")
  end

  def pin_input_page(conn, _params) do
    render(conn, :pin_input_page)
  end

  def pin_input_form_page(conn, _params) do
    render(conn, :pin_input_form_page)
  end

  def pin_input_form_submit(conn, params) do
    pin = get_in(params, ["pin_input_form", "pin"]) || ""

    conn
    |> put_flash(:info, "Submitted: pin=#{inspect(pin)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/pin-input/form")
  end

  def radio_group_page(conn, _params) do
    render(conn, :radio_group_page)
  end

  def radio_group_form_page(conn, _params) do
    render(conn, :radio_group_form_page)
  end

  def radio_group_form_submit(conn, params) do
    choice = get_in(params, ["radio_group_form", "choice"]) || ""

    conn
    |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
    |> redirect(to: ~p"/#{conn.assigns[:locale]}/radio-group/form")
  end

  def timer_page(conn, _params) do
    render(conn, :timer_page)
  end
end
