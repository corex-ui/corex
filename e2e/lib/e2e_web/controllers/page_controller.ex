defmodule E2eWeb.PageController do
  use E2eWeb, :controller

  def accordion_page(conn, _params) do
    render(conn, :accordion_page)
  end

  def accordion_styling_page(conn, _params) do
    render(conn, :accordion_styling_page)
  end

  def action_page(conn, _params) do
    render(conn, :action_page)
  end

  def action_styling_page(conn, _params) do
    render(conn, :action_styling_page)
  end

  def navigate_page(conn, _params) do
    render(conn, :navigate_page)
  end

  def navigate_styling_page(conn, _params) do
    render(conn, :navigate_styling_page)
  end

  def switch_page(conn, _params) do
    render(conn, :switch_page)
  end

  def switch_styling_page(conn, _params) do
    render(conn, :switch_styling_page)
  end

  def pagination_page(conn, _params) do
    render(conn, :pagination_page)
  end

  def pagination_styling_page(conn, _params) do
    render(conn, :pagination_styling_page)
  end

  def toggle_group_page(conn, _params) do
    render(conn, :toggle_group_page)
  end

  def toggle_group_styling_page(conn, _params) do
    render(conn, :toggle_group_styling_page)
  end

  def combobox_page(conn, _params) do
    render(conn, :combobox_page)
  end

  def combobox_styling_page(conn, _params) do
    render(conn, :combobox_styling_page)
  end

  def combobox_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"country" => ""},
        as: :combobox_phoenix,
        id: "combobox-form-phoenix"
      )

    ecto_form =
      %E2e.Form.Combobox{}
      |> E2e.Form.Combobox.changeset_validate(%{"country" => ""})
      |> Phoenix.Component.to_form(as: :combobox_ecto, id: "combobox-form-ecto")

    conn
    |> assign_combobox_form_docs(nil)
    |> render(:combobox_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  defp assign_combobox_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.ComboboxDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.ComboboxDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.ComboboxDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.ComboboxDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.ComboboxDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.ComboboxDemo.form_doc_controller_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.ComboboxDemo.form_native_elixir())
  end

  def combobox_form_submit(conn, %{"combobox_phoenix" => phoenix_params}) do
    country = Map.get(phoenix_params, "country", "")

    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/combobox/form#combobox-form-phoenix")
  end

  def combobox_form_submit(conn, %{"combobox_ecto" => combobox_params}) do
    changeset =
      %E2e.Form.Combobox{}
      |> E2e.Form.Combobox.changeset_validate(combobox_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: country=#{inspect(data.country)}")
      |> redirect(to: ~p"/combobox/form#combobox-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :combobox_ecto, id: "combobox-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"country" => ""},
          as: :combobox_phoenix,
          id: "combobox-form-phoenix"
        )

      conn
      |> assign_combobox_form_docs("combobox-form-ecto")
      |> render(:combobox_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def combobox_form_submit(conn, %{"combobox_native" => native_params}) do
    country = Map.get(native_params, "country", "")

    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/combobox/form#combobox-form-native")
  end

  def combobox_form_submit(conn, %{"combobox" => combobox_params}) do
    country = Map.get(combobox_params, "country", "")

    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/combobox/form#combobox-form-native")
  end

  def combobox_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: country=#{inspect("")}")
    |> redirect(to: ~p"/combobox/form#combobox-form-native")
  end

  def color_picker_page(conn, _params) do
    render(conn, :color_picker_page)
  end

  def checkbox_page(conn, _params) do
    render(conn, :checkbox_page)
  end

  def checkbox_styling_page(conn, _params) do
    render(conn, :checkbox_styling_page)
  end

  defp assign_checkbox_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.CheckboxDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.CheckboxDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.CheckboxDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.CheckboxDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.CheckboxDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.CheckboxDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.CheckboxDemo.form_native_elixir())
  end

  def checkbox_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"terms" => false},
        as: :terms_phoenix,
        id: "checkbox-form-phoenix"
      )

    ecto_form =
      %E2e.Form.Terms{}
      |> E2e.Form.Terms.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :terms_ecto, id: "checkbox-form-ecto")

    conn
    |> assign_checkbox_form_docs(nil)
    |> render(:checkbox_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def checkbox_form_submit(conn, %{"terms_phoenix" => phoenix_params}) do
    terms = form_checkbox_checked?(phoenix_params["terms"])

    conn
    |> put_flash(:info, "Submitted: terms=#{inspect(terms)}")
    |> redirect(to: ~p"/checkbox/form#checkbox-form-phoenix")
  end

  def checkbox_form_submit(conn, %{"terms_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.Terms{}
      |> E2e.Form.Terms.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: terms=#{inspect(data.terms)}")
      |> redirect(to: ~p"/checkbox/form#checkbox-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :terms_ecto, id: "checkbox-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"terms" => false},
          as: :terms_phoenix,
          id: "checkbox-form-phoenix"
        )

      conn
      |> assign_checkbox_form_docs("checkbox-form-ecto")
      |> render(:checkbox_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def checkbox_form_submit(conn, %{"terms" => %{"terms" => terms}}) do
    checked = Phoenix.HTML.Form.normalize_value("checkbox", terms)

    conn
    |> put_flash(:info, "Submitted: terms=#{inspect(checked)}")
    |> redirect(to: ~p"/checkbox/form#checkbox-form-native")
  end

  def checkbox_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: terms=#{inspect(false)}")
    |> redirect(to: ~p"/checkbox/form#checkbox-form-native")
  end

  defp assign_switch_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.SwitchDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.SwitchDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.SwitchDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.SwitchDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.SwitchDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.SwitchDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.SwitchDemo.form_native_elixir())
  end

  def switch_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"notifications" => false},
        as: :preferences_phoenix,
        id: "switch-form-phoenix"
      )

    ecto_form =
      %E2e.Form.Preferences{}
      |> E2e.Form.Preferences.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :preferences_ecto, id: "switch-form-ecto")

    conn
    |> assign_switch_form_docs(nil)
    |> render(:switch_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def switch_form_submit(conn, %{"preferences_phoenix" => phoenix_params}) do
    notifications = form_checkbox_checked?(phoenix_params["notifications"])

    conn
    |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
    |> redirect(to: ~p"/switch/form#switch-form-phoenix")
  end

  def switch_form_submit(conn, %{"preferences_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.Preferences{}
      |> E2e.Form.Preferences.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: notifications=#{inspect(data.notifications)}")
      |> redirect(to: ~p"/switch/form#switch-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :preferences_ecto, id: "switch-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"notifications" => false},
          as: :preferences_phoenix,
          id: "switch-form-phoenix"
        )

      conn
      |> assign_switch_form_docs("switch-form-ecto")
      |> render(:switch_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def switch_form_submit(conn, %{"user" => %{"notifications" => notifications}}) do
    conn
    |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
    |> redirect(to: ~p"/switch/form#switch-form-native")
  end

  def switch_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: notifications=nil")
    |> redirect(to: ~p"/switch/form#switch-form-native")
  end

  def select_page(conn, _params) do
    render(conn, :select_page)
  end

  def select_styling_page(conn, _params) do
    render(conn, :select_styling_page)
  end

  defp assign_select_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.SelectDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.SelectDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.SelectDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.SelectDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.SelectDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.SelectDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.SelectDemo.form_native_elixir())
  end

  def select_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"country" => ""},
        as: :select_phoenix,
        id: "select-form-phoenix"
      )

    ecto_form =
      %E2e.Form.SelectForm{}
      |> E2e.Form.SelectForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :select_ecto, id: "select-form-ecto")

    conn
    |> assign_select_form_docs(nil)
    |> render(:select_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def select_form_submit(conn, %{"select_phoenix" => %{"country" => country}}) do
    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/select/form#select-form-phoenix")
  end

  def select_form_submit(conn, %{"select_ecto" => select_params}) do
    changeset =
      %E2e.Form.SelectForm{}
      |> E2e.Form.SelectForm.changeset_validate(select_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: country=#{inspect(data.country)}")
      |> redirect(to: ~p"/select/form#select-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :select_ecto, id: "select-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"country" => ""},
          as: :select_phoenix,
          id: "select-form-phoenix"
        )

      conn
      |> assign_select_form_docs("select-form-ecto")
      |> render(:select_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def select_form_submit(conn, %{"user" => user_params}) do
    country = Map.get(user_params, "country", "")

    conn
    |> put_flash(:info, "Submitted: country=#{inspect(country)}")
    |> redirect(to: ~p"/select/form#select-form-native")
  end

  def select_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: country=#{inspect("")}")
    |> redirect(to: ~p"/select/form#select-form-native")
  end

  def tabs_page(conn, _params) do
    render(conn, :tabs_page)
  end

  def tabs_styling_page(conn, _params) do
    render(conn, :tabs_styling_page)
  end

  def tags_input_page(conn, _params) do
    render(conn, :tags_input_page)
  end

  def tags_input_styling_page(conn, _params) do
    render(conn, :tags_input_styling_page)
  end

  def toggle_page(conn, _params) do
    render(conn, :toggle_page)
  end

  def toggle_styling_page(conn, _params) do
    render(conn, :toggle_styling_page)
  end

  def collapsible_page(conn, _params) do
    render(conn, :collapsible_page)
  end

  def collapsible_styling_page(conn, _params) do
    render(conn, :collapsible_styling_page)
  end

  def dialog_page(conn, _params) do
    render(conn, :dialog_page)
  end

  def dialog_styling_page(conn, _params) do
    render(conn, :dialog_styling_page)
  end

  def clipboard_page(conn, _params) do
    render(conn, :clipboard_page)
  end

  def clipboard_styling_page(conn, _params) do
    render(conn, :clipboard_styling_page)
  end

  def code_page(conn, _params) do
    conn
    |> assign(:code_examples, E2eWeb.CodeExamples.all())
    |> render(:code_page)
  end

  def code_styling_page(conn, _params) do
    render(conn, :code_styling_page)
  end

  defp assign_angle_slider_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.AngleSliderDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.AngleSliderDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.AngleSliderDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.AngleSliderDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.AngleSliderDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.AngleSliderDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.AngleSliderDemo.form_native_elixir())
  end

  def angle_slider_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"angle" => "0"},
        as: :angle_slider_phoenix,
        id: "angle-slider-form-phoenix"
      )

    ecto_form =
      %E2e.Form.AngleSliderForm{}
      |> E2e.Form.AngleSliderForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :angle_slider_ecto, id: "angle-slider-form-ecto")

    conn
    |> assign_angle_slider_form_docs(nil)
    |> render(:angle_slider_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def angle_slider_form_submit(conn, %{"angle_slider_phoenix" => %{"angle" => angle}}) do
    conn
    |> put_flash(:info, "Submitted: angle=#{angle}")
    |> redirect(to: ~p"/angle-slider/form#angle-slider-form-phoenix")
  end

  def angle_slider_form_submit(conn, %{"angle_slider_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.AngleSliderForm{}
      |> E2e.Form.AngleSliderForm.changeset_validate(ecto_params)

    if changeset.valid? do
      angle = ecto_params["angle"] || "0"

      conn
      |> put_flash(:info, "Submitted: angle=#{angle}")
      |> redirect(to: ~p"/angle-slider/form#angle-slider-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset,
          as: :angle_slider_ecto,
          id: "angle-slider-form-ecto"
        )

      phoenix_form =
        Phoenix.Component.to_form(%{"angle" => "0"},
          as: :angle_slider_phoenix,
          id: "angle-slider-form-phoenix"
        )

      conn
      |> assign_angle_slider_form_docs("angle-slider-form-ecto")
      |> render(:angle_slider_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def angle_slider_form_submit(conn, %{"angle_slider_form" => form_params}) do
    angle = Map.get(form_params, "angle", "0")

    conn
    |> put_flash(:info, "Submitted: angle=#{angle}")
    |> redirect(to: ~p"/angle-slider/form#angle-slider-form-native")
  end

  def angle_slider_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: angle=0")
    |> redirect(to: ~p"/angle-slider/form#angle-slider-form-native")
  end

  defp assign_color_picker_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.ColorPickerDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.ColorPickerDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.ColorPickerDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.ColorPickerDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.ColorPickerDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.ColorPickerDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.ColorPickerDemo.form_native_elixir())
  end

  def color_picker_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"color" => "#3b82f6"},
        as: :color_picker_phoenix,
        id: "color-picker-form-phoenix"
      )

    ecto_form =
      %E2e.Form.ColorPickerForm{}
      |> E2e.Form.ColorPickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :color_picker_ecto, id: "color-picker-form-ecto")

    conn
    |> assign_color_picker_form_docs(nil)
    |> render(:color_picker_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def color_picker_form_submit(conn, %{"color_picker_phoenix" => %{"color" => color}}) do
    conn
    |> put_flash(:info, "Submitted: color=#{color}")
    |> redirect(to: ~p"/color-picker/form#color-picker-form-phoenix")
  end

  def color_picker_form_submit(conn, %{"color_picker_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.ColorPickerForm{}
      |> E2e.Form.ColorPickerForm.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: color=#{data.color}")
      |> redirect(to: ~p"/color-picker/form#color-picker-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset,
          as: :color_picker_ecto,
          id: "color-picker-form-ecto"
        )

      phoenix_form =
        Phoenix.Component.to_form(%{"color" => "#3b82f6"},
          as: :color_picker_phoenix,
          id: "color-picker-form-phoenix"
        )

      conn
      |> assign_color_picker_form_docs("color-picker-form-ecto")
      |> render(:color_picker_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def color_picker_form_submit(conn, %{"color_picker_form" => form_params}) do
    color = Map.get(form_params, "color", "#3b82f6")

    conn
    |> put_flash(:info, "Submitted: color=#{color}")
    |> redirect(to: ~p"/color-picker/form#color-picker-form-native")
  end

  def color_picker_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: color=#3b82f6")
    |> redirect(to: ~p"/color-picker/form#color-picker-form-native")
  end

  def date_picker_page(conn, _params) do
    render(conn, :date_picker_page)
  end

  defp assign_date_picker_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.DatePickerDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.DatePickerDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.DatePickerDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.DatePickerDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.DatePickerDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.DatePickerDemo.form_doc_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.DatePickerDemo.form_native_elixir())
  end

  def date_picker_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"date" => ""},
        as: :date_picker_phoenix,
        id: "date-picker-form-phoenix"
      )

    ecto_form =
      %E2e.Form.DatePickerForm{}
      |> E2e.Form.DatePickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :date_picker_ecto, id: "date-picker-form-ecto")

    conn
    |> assign_date_picker_form_docs(nil)
    |> render(:date_picker_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def date_picker_form_submit(conn, %{"date_picker_phoenix" => %{"date" => date}}) do
    conn
    |> put_flash(:info, "Submitted: date=#{date}")
    |> redirect(to: ~p"/date-picker/form#date-picker-form-phoenix")
  end

  def date_picker_form_submit(conn, %{"date_picker_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.DatePickerForm{}
      |> E2e.Form.DatePickerForm.changeset_validate(ecto_params)

    if changeset.valid? do
      date = ecto_params["date"] || ""

      conn
      |> put_flash(:info, "Submitted: date=#{date}")
      |> redirect(to: ~p"/date-picker/form#date-picker-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset,
          as: :date_picker_ecto,
          id: "date-picker-form-ecto"
        )

      phoenix_form =
        Phoenix.Component.to_form(%{"date" => ""},
          as: :date_picker_phoenix,
          id: "date-picker-form-phoenix"
        )

      conn
      |> assign_date_picker_form_docs("date-picker-form-ecto")
      |> render(:date_picker_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def date_picker_form_submit(conn, %{"date_picker_form" => form_params}) do
    date = Map.get(form_params, "date", "")

    conn
    |> put_flash(:info, "Submitted: date=#{date}")
    |> redirect(to: ~p"/date-picker/form#date-picker-form-native")
  end

  def date_picker_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: date=")
    |> redirect(to: ~p"/date-picker/form#date-picker-form-native")
  end

  def signature_page(conn, _params) do
    render(conn, :signature_page)
  end

  defp assign_signature_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.SignatureDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.SignatureDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.SignatureDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.SignatureDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.SignatureDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.SignatureDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.SignatureDemo.form_native_elixir())
  end

  def signature_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"signature" => []},
        as: :signature_phoenix,
        id: "signature-form-phoenix"
      )

    ecto_form =
      %E2e.Form.SignatureForm{}
      |> E2e.Form.SignatureForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :signature_ecto, id: "signature-form-ecto")

    conn
    |> assign_signature_form_docs(nil)
    |> render(:signature_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def signature_form_submit(conn, %{"signature_phoenix" => %{"signature" => sig}}) do
    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.SignatureForm.format_for_toast(sig)}")
    |> redirect(to: ~p"/signature-pad/form#signature-form-phoenix")
  end

  def signature_form_submit(conn, %{"signature_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.SignatureForm{}
      |> E2e.Form.SignatureForm.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: #{E2e.Form.SignatureForm.format_for_toast(data)}")
      |> redirect(to: ~p"/signature-pad/form#signature-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :signature_ecto, id: "signature-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"signature" => []},
          as: :signature_phoenix,
          id: "signature-form-phoenix"
        )

      conn
      |> assign_signature_form_docs("signature-form-ecto")
      |> render(:signature_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def signature_form_submit(conn, %{"user" => user_params}) do
    sig = Map.get(user_params, "signature", "")

    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.SignatureForm.format_for_toast(sig)}")
    |> redirect(to: ~p"/signature-pad/form#signature-form-native")
  end

  def signature_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.SignatureForm.format_for_toast([])}")
    |> redirect(to: ~p"/signature-pad/form#signature-form-native")
  end

  def menu_page(conn, _params) do
    render(conn, :menu_page)
  end

  def tree_view_page(conn, _params) do
    render(conn, :tree_view_page)
  end

  def tree_view_styling_page(conn, _params) do
    render(conn, :tree_view_styling_page)
  end

  def layout_heading_page(conn, _params) do
    render(conn, :layout_heading_page)
  end

  def layout_heading_styling_page(conn, _params) do
    render(conn, :layout_heading_styling_page)
  end

  def angle_slider_page(conn, _params) do
    render(conn, :angle_slider_page)
  end

  def angle_slider_styling_page(conn, _params) do
    render(conn, :angle_slider_styling_page)
  end

  def avatar_page(conn, _params) do
    render(conn, :avatar_page)
  end

  def avatar_styling_page(conn, _params) do
    render(conn, :avatar_styling_page)
  end

  def carousel_page(conn, _params) do
    render(conn, :carousel_page)
  end

  def carousel_styling_page(conn, _params) do
    render(conn, :carousel_styling_page)
  end

  def data_list_page(conn, _params) do
    render(conn, :data_list_page)
  end

  def data_list_styling_page(conn, _params) do
    render(conn, :data_list_styling_page)
  end

  def data_table_page(conn, _params) do
    render(conn, :data_table_page)
  end

  def editable_page(conn, _params) do
    render(conn, :editable_page, value_text: "My custom value")
  end

  def editable_styling_page(conn, _params) do
    render(conn, :editable_styling_page)
  end

  defp assign_editable_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.EditableDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.EditableDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.EditableDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.EditableDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.EditableDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.EditableDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.EditableDemo.form_native_elixir())
  end

  def editable_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"text" => ""},
        as: :editable_phoenix,
        id: "editable-form-phoenix"
      )

    ecto_form =
      %E2e.Form.EditableForm{}
      |> E2e.Form.EditableForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :editable_ecto, id: "editable-form-ecto")

    conn
    |> assign_editable_form_docs(nil)
    |> render(:editable_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def editable_form_submit(conn, %{"editable_phoenix" => %{"text" => text}}) do
    conn
    |> put_flash(:info, "Submitted: text=#{inspect(text)}")
    |> redirect(to: ~p"/editable/form#editable-form-phoenix")
  end

  def editable_form_submit(conn, %{"editable_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.EditableForm{}
      |> E2e.Form.EditableForm.changeset(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: text=#{inspect(data.text)}")
      |> redirect(to: ~p"/editable/form#editable-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :editable_ecto, id: "editable-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"text" => ""},
          as: :editable_phoenix,
          id: "editable-form-phoenix"
        )

      conn
      |> assign_editable_form_docs("editable-form-ecto")
      |> render(:editable_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def editable_form_submit(conn, %{"editable" => editable_params}) do
    text = Map.get(editable_params, "text", "")

    conn
    |> put_flash(:info, "Submitted: text=#{inspect(text)}")
    |> redirect(to: ~p"/editable/form#editable-form-native")
  end

  def editable_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: text=#{inspect("")}")
    |> redirect(to: ~p"/editable/form#editable-form-native")
  end

  def native_input_page(conn, _params) do
    render(conn, :native_input_page)
  end

  defp assign_native_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.NativeInputDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.NativeInputDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.NativeInputDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.NativeInputDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.NativeInputDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.NativeInputDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.NativeInputDemo.form_native_elixir())
  end

  defp native_input_phoenix_defaults do
    %{
      "name" => "",
      "email" => "",
      "bio" => "",
      "birth_date" => "",
      "datetime" => "",
      "reminder_time" => "",
      "month" => "",
      "week" => "",
      "website" => "",
      "phone" => "",
      "q" => "",
      "color" => "",
      "count" => "",
      "password" => "",
      "role" => "",
      "tags" => "",
      "size" => "",
      "agree" => false
    }
  end

  def native_input_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(native_input_phoenix_defaults(),
        as: :profile_phoenix,
        id: "native-input-form-phoenix"
      )

    ecto_form =
      %E2e.Form.NativeInputProfile{}
      |> E2e.Form.NativeInputProfile.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :profile_ecto, id: "native-input-form-ecto")

    conn
    |> assign_native_input_form_docs(nil)
    |> render(:native_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def native_input_form_submit(conn, %{"profile_phoenix" => profile}) do
    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(profile)}")
    |> redirect(to: ~p"/native-input/form#native-input-form-phoenix")
  end

  def native_input_form_submit(conn, %{"profile_ecto" => profile_params}) do
    case E2e.Form.NativeInputProfile.changeset_validate(
           %E2e.Form.NativeInputProfile{},
           profile_params
         ) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        conn
        |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(data)}")
        |> redirect(to: ~p"/native-input/form#native-input-form-ecto")

      changeset ->
        changeset = Map.put(changeset, :action, :insert)

        ecto_form =
          Phoenix.Component.to_form(changeset,
            as: :profile_ecto,
            id: "native-input-form-ecto"
          )

        phoenix_form =
          Phoenix.Component.to_form(native_input_phoenix_defaults(),
            as: :profile_phoenix,
            id: "native-input-form-phoenix"
          )

        conn
        |> assign_native_input_form_docs("native-input-form-ecto")
        |> render(:native_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def native_input_form_submit(conn, %{"profile" => profile}) do
    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(profile)}")
    |> redirect(to: ~p"/native-input/form#native-input-form-native")
  end

  def native_input_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(%{})}")
    |> redirect(to: ~p"/native-input/form#native-input-form-native")
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

  def number_input_styling_page(conn, _params) do
    render(conn, :number_input_styling_page)
  end

  defp assign_number_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.NumberInputDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.NumberInputDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.NumberInputDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.NumberInputDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.NumberInputDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.NumberInputDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.NumberInputDemo.form_native_elixir())
  end

  def number_input_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"value" => "1234"},
        as: :number_input_phoenix,
        id: "number-input-form-phoenix"
      )

    ecto_form =
      %E2e.Form.NumberInputForm{}
      |> E2e.Form.NumberInputForm.changeset_validate(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_ecto, id: "number-input-form-ecto")

    conn
    |> assign_number_input_form_docs(nil)
    |> render(:number_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def number_input_form_submit(conn, %{"number_input_phoenix" => %{"value" => value}}) do
    conn
    |> put_flash(:info, "Submitted: value=#{value}")
    |> redirect(to: ~p"/number-input/form#number-input-form-phoenix")
  end

  def number_input_form_submit(conn, %{"number_input_ecto" => ecto_params}) do
    case E2e.Form.NumberInputForm.changeset_validate(
           %E2e.Form.NumberInputForm{},
           ecto_params
         ) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        conn
        |> put_flash(:info, "Submitted: #{E2e.Form.NumberInputForm.format_for_toast(data)}")
        |> redirect(to: ~p"/number-input/form#number-input-form-ecto")

      changeset ->
        changeset = Map.put(changeset, :action, :insert)

        ecto_form =
          Phoenix.Component.to_form(changeset,
            as: :number_input_ecto,
            id: "number-input-form-ecto"
          )

        phoenix_form =
          Phoenix.Component.to_form(%{"value" => "1234"},
            as: :number_input_phoenix,
            id: "number-input-form-phoenix"
          )

        conn
        |> assign_number_input_form_docs("number-input-form-ecto")
        |> render(:number_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def number_input_form_submit(conn, %{"number_input_form" => %{"value" => value}}) do
    conn
    |> put_flash(:info, "Submitted: value=#{value}")
    |> redirect(to: ~p"/number-input/form#number-input-form-native")
  end

  def number_input_form_submit(conn, %{"value" => value}) do
    conn
    |> put_flash(:info, "Submitted: value=#{value}")
    |> redirect(to: ~p"/number-input/form#number-input-form-native")
  end

  def number_input_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: value=0")
    |> redirect(to: ~p"/number-input/form#number-input-form-native")
  end

  def file_upload_page(conn, _params) do
    render(conn, :file_upload_page)
  end

  defp assign_file_upload_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.FileUploadDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.FileUploadDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.FileUploadDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.FileUploadDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.FileUploadDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.FileUploadDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.FileUploadDemo.form_native_elixir())
  end

  def file_upload_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"attachment" => nil},
        as: :file_upload_phoenix,
        id: "file-upload-phoenix-form"
      )

    ecto_form =
      %E2e.Form.FileUploadForm{}
      |> E2e.Form.FileUploadForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :file_upload_ecto, id: "file-upload-ecto-form")

    conn
    |> assign_file_upload_form_docs(nil)
    |> render(:file_upload_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def file_upload_form_submit(conn, params) do
    case file_upload_form_target(params) do
      :phoenix ->
        nested = file_upload_nested_params(params, "file_upload_phoenix", "attachment")
        upload = file_upload_param_attachment(nested)

        conn
        |> put_flash(
          :info,
          "Submitted: attachment=#{file_upload_submit_label(upload, nested, "attachment")}"
        )
        |> redirect(to: ~p"/file-upload/form#file-upload-form-phoenix")

      :ecto ->
        nested = file_upload_nested_params(params, "file_upload_ecto", "attachment")
        upload = file_upload_param_attachment(nested)

        changeset =
          %E2e.Form.FileUploadForm{}
          |> E2e.Form.FileUploadForm.changeset_validate(nested)

        if changeset.valid? do
          conn
          |> put_flash(
            :info,
            "Submitted: attachment=#{file_upload_submit_label(upload, nested, "attachment")}"
          )
          |> redirect(to: ~p"/file-upload/form#file-upload-form-ecto")
        else
          changeset = Map.put(changeset, :action, :insert)

          ecto_form =
            Phoenix.Component.to_form(changeset,
              as: :file_upload_ecto,
              id: "file-upload-ecto-form"
            )

          phoenix_form =
            Phoenix.Component.to_form(%{"attachment" => nil},
              as: :file_upload_phoenix,
              id: "file-upload-phoenix-form"
            )

          conn
          |> assign_file_upload_form_docs("file-upload-form-ecto")
          |> render(:file_upload_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
        end

      :native ->
        nested = file_upload_nested_params(params, "user", "avatar")
        upload = normalize_single_upload(Map.get(nested, "avatar"))

        conn
        |> put_flash(
          :info,
          "Submitted: avatar=#{file_upload_submit_label(upload, nested, "avatar")}"
        )
        |> redirect(to: ~p"/file-upload/form#file-upload-form-native")

      :unknown ->
        conn
        |> put_flash(:error, "Unexpected form payload")
        |> redirect(to: ~p"/file-upload/form")
    end
  end

  defp file_upload_form_target(params) do
    case Map.get(params, "_file_upload_form") do
      "phoenix" -> :phoenix
      "ecto" -> :ecto
      "native" -> :native
      _ -> file_upload_form_target_fallback(params)
    end
  end

  defp file_upload_form_target_fallback(params) do
    cond do
      Map.has_key?(params, "file_upload_phoenix") or
          Map.has_key?(params, "file_upload_phoenix[attachment]") ->
        :phoenix

      Map.has_key?(params, "file_upload_ecto") or
          Map.has_key?(params, "file_upload_ecto[attachment]") ->
        :ecto

      Map.has_key?(params, "user") or Map.has_key?(params, "user[avatar]") ->
        :native

      true ->
        :unknown
    end
  end

  defp file_upload_nested_params(params, namespace, field) do
    flat_key = "#{namespace}[#{field}]"

    cond do
      is_map(params[namespace]) ->
        params[namespace]

      is_list(params[namespace]) ->
        %{field => normalize_single_upload(params[namespace])}

      Map.has_key?(params, flat_key) ->
        %{field => params[flat_key]}

      true ->
        %{}
    end
  end

  defp file_upload_param_attachment(params) when is_map(params) do
    cond do
      Map.has_key?(params, "attachment") ->
        normalize_single_upload(params["attachment"])

      Map.has_key?(params, "attachment[]") ->
        normalize_single_upload(params["attachment[]"])

      true ->
        nil
    end
  end

  defp normalize_single_upload(values) when is_list(values) do
    case Enum.find(values, &match?(%Plug.Upload{}, &1)) do
      %Plug.Upload{} = upload ->
        upload

      _ ->
        values
        |> Enum.reject(&blank_upload_param?/1)
        |> List.first()
    end
  end

  defp normalize_single_upload(value), do: value

  defp blank_upload_param?(value), do: value in [nil, ""]

  defp file_upload_submit_label(upload, nested, field) do
    label_field = E2e.Form.FileUploadForm.label_field_for(field)
    E2e.Form.FileUploadForm.submit_label(upload, nested, label_field)
  end

  defp form_checkbox_checked?(value),
    do: Phoenix.HTML.Form.normalize_value("checkbox", value)

  def password_input_page(conn, _params) do
    render(conn, :password_input_page)
  end

  defp assign_password_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.PasswordInputDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.PasswordInputDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.PasswordInputDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.PasswordInputDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.PasswordInputDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.PasswordInputDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.PasswordInputDemo.form_native_elixir())
  end

  def password_input_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"password" => ""},
        as: :password_input_phoenix,
        id: "password-input-form-phoenix"
      )

    ecto_form =
      %E2e.Form.PasswordInputForm{}
      |> E2e.Form.PasswordInputForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :password_input_ecto, id: "password-input-form-ecto")

    conn
    |> assign_password_input_form_docs(nil)
    |> render(:password_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def password_input_form_submit(conn, %{"password_input_phoenix" => %{"password" => password}}) do
    message =
      if password == "", do: "Submitted: password=", else: "Submitted: password=***"

    conn
    |> put_flash(:info, message)
    |> redirect(to: ~p"/password-input/form#password-input-form-phoenix")
  end

  def password_input_form_submit(conn, %{"password_input_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.PasswordInputForm{}
      |> E2e.Form.PasswordInputForm.changeset_validate(ecto_params)

    if changeset.valid? do
      conn
      |> put_flash(:info, "Submitted: password=***")
      |> redirect(to: ~p"/password-input/form#password-input-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset,
          as: :password_input_ecto,
          id: "password-input-form-ecto"
        )

      phoenix_form =
        Phoenix.Component.to_form(%{"password" => ""},
          as: :password_input_phoenix,
          id: "password-input-form-phoenix"
        )

      conn
      |> assign_password_input_form_docs("password-input-form-ecto")
      |> render(:password_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def password_input_form_submit(conn, %{"user" => user_params}) do
    password = Map.get(user_params, "password", "")

    message =
      if password == "", do: "Submitted: password=", else: "Submitted: password=***"

    conn
    |> put_flash(:info, message)
    |> redirect(to: ~p"/password-input/form#password-input-form-native")
  end

  def password_input_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: password=")
    |> redirect(to: ~p"/password-input/form#password-input-form-native")
  end

  def pin_input_page(conn, _params) do
    render(conn, :pin_input_page)
  end

  defp assign_pin_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.PinInputDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.PinInputDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.PinInputDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.PinInputDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.PinInputDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.PinInputDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.PinInputDemo.form_native_elixir())
  end

  def pin_input_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"pin" => []}, as: :pin_phoenix, id: "pin-input-form-phoenix")

    ecto_form =
      %E2e.Form.PinInputForm{}
      |> E2e.Form.PinInputForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :pin_ecto, id: "pin-input-form-ecto")

    conn
    |> assign_pin_input_form_docs(nil)
    |> render(:pin_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def pin_input_form_submit(conn, %{"pin_phoenix" => %{"pin" => pin}}) do
    conn
    |> put_flash(:info, "Submitted: pin=#{inspect(List.wrap(pin))}")
    |> redirect(to: ~p"/pin-input/form#pin-input-form-phoenix")
  end

  def pin_input_form_submit(conn, %{"pin_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.PinInputForm{}
      |> E2e.Form.PinInputForm.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: pin=#{inspect(data.pin)}")
      |> redirect(to: ~p"/pin-input/form#pin-input-form-ecto")
    else
      changeset = Map.put(changeset, :action, :validate)

      ecto_form =
        Phoenix.Component.to_form(changeset, as: :pin_ecto, id: "pin-input-form-ecto")

      phoenix_form =
        Phoenix.Component.to_form(%{"pin" => []},
          as: :pin_phoenix,
          id: "pin-input-form-phoenix"
        )

      conn
      |> assign_pin_input_form_docs("pin-input-form-ecto")
      |> render(:pin_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def pin_input_form_submit(conn, %{"pin_input" => pin_params}) do
    pin = Map.get(pin_params, "pin", []) |> List.wrap()

    conn
    |> put_flash(:info, "Submitted: pin=#{inspect(pin)}")
    |> redirect(to: ~p"/pin-input/form#pin-input-form-native")
  end

  def pin_input_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: pin=#{inspect([])}")
    |> redirect(to: ~p"/pin-input/form#pin-input-form-native")
  end

  defp assign_tags_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.TagsInputDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.TagsInputDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.TagsInputDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.TagsInputDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.TagsInputDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.TagsInputDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.TagsInputDemo.form_native_elixir())
  end

  def tags_input_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"tags" => ["alpha", "beta"]},
        as: :tags_input_phoenix,
        id: "tags-input-form-phoenix"
      )

    ecto_form =
      %E2e.Form.TagsInputForm{}
      |> E2e.Form.TagsInputForm.changeset_validate(%{"tags" => ["alpha", "beta"]})
      |> Phoenix.Component.to_form(as: :tags_input_ecto, id: "tags-input-form-ecto")

    conn
    |> assign_tags_input_form_docs(nil)
    |> render(:tags_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def tags_input_form_submit(conn, %{"tags_input_phoenix" => params}) when is_map(params) do
    tags = params |> Map.get("tags", []) |> List.wrap()

    conn
    |> put_flash(:info, "Submitted: tags=#{inspect(tags)}")
    |> redirect(to: ~p"/tags-input/form#tags-input-form-phoenix")
  end

  def tags_input_form_submit(conn, %{"tags_input_ecto" => ecto_params}) do
    case E2e.Form.TagsInputForm.changeset_validate(
           %E2e.Form.TagsInputForm{},
           ecto_params
         ) do
      %Ecto.Changeset{valid?: true} = changeset ->
        data = Ecto.Changeset.apply_changes(changeset)

        conn
        |> put_flash(:info, "Submitted: tags=#{inspect(data.tags)}")
        |> redirect(to: ~p"/tags-input/form#tags-input-form-ecto")

      changeset ->
        changeset = Map.put(changeset, :action, :validate)

        ecto_form =
          Phoenix.Component.to_form(changeset,
            as: :tags_input_ecto,
            id: "tags-input-form-ecto"
          )

        phoenix_form =
          Phoenix.Component.to_form(%{"tags" => ["alpha", "beta"]},
            as: :tags_input_phoenix,
            id: "tags-input-form-phoenix"
          )

        conn
        |> assign_tags_input_form_docs("tags-input-form-ecto")
        |> render(:tags_input_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def tags_input_form_submit(conn, %{"tags_native" => native_params}) do
    tags = Map.get(native_params, "tags", []) |> List.wrap()

    conn
    |> put_flash(:info, "Submitted: tags=#{inspect(tags)}")
    |> redirect(to: ~p"/tags-input/form#tags-input-form-native")
  end

  def tags_input_form_submit(conn, _params) do
    conn
    |> put_flash(:error, "Unknown form submission")
    |> redirect(to: ~p"/tags-input/form")
  end

  def radio_group_page(conn, _params) do
    render(conn, :radio_group_page)
  end

  def radio_group_styling_page(conn, _params) do
    render(conn, :radio_group_styling_page)
  end

  defp assign_radio_group_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.RadioGroupDemo.form_ecto())
    |> assign(:phoenix_heex, E2eWeb.Demos.RadioGroupDemo.form_phoenix_heex())
    |> assign(:phoenix_elixir, E2eWeb.Demos.RadioGroupDemo.form_phoenix_elixir())
    |> assign(:ecto_heex, E2eWeb.Demos.RadioGroupDemo.form_ecto_heex())
    |> assign(:ecto_elixir, E2eWeb.Demos.RadioGroupDemo.form_ecto_elixir())
    |> assign(:native_heex, E2eWeb.Demos.RadioGroupDemo.form_native_heex())
    |> assign(:native_elixir, E2eWeb.Demos.RadioGroupDemo.form_native_elixir())
  end

  def radio_group_form_page(conn, _params) do
    phoenix_form =
      Phoenix.Component.to_form(%{"choice" => ""},
        as: :radio_group_phoenix,
        id: "radio-group-form-phoenix"
      )

    ecto_form =
      %E2e.Form.RadioGroupForm{}
      |> E2e.Form.RadioGroupForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :radio_group_ecto, id: "radio-group-form-ecto")

    conn
    |> assign_radio_group_form_docs(nil)
    |> render(:radio_group_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
  end

  def radio_group_form_submit(conn, %{"radio_group_phoenix" => %{"choice" => choice}}) do
    conn
    |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
    |> redirect(to: ~p"/radio-group/form#radio-group-form-phoenix")
  end

  def radio_group_form_submit(conn, %{"radio_group_ecto" => ecto_params}) do
    changeset =
      %E2e.Form.RadioGroupForm{}
      |> E2e.Form.RadioGroupForm.changeset_validate(ecto_params)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      conn
      |> put_flash(:info, "Submitted: choice=#{inspect(data.choice)}")
      |> redirect(to: ~p"/radio-group/form#radio-group-form-ecto")
    else
      changeset = Map.put(changeset, :action, :insert)

      ecto_form =
        Phoenix.Component.to_form(changeset,
          as: :radio_group_ecto,
          id: "radio-group-form-ecto"
        )

      phoenix_form =
        Phoenix.Component.to_form(%{"choice" => ""},
          as: :radio_group_phoenix,
          id: "radio-group-form-phoenix"
        )

      conn
      |> assign_radio_group_form_docs("radio-group-form-ecto")
      |> render(:radio_group_form_page, phoenix_form: phoenix_form, ecto_form: ecto_form)
    end
  end

  def radio_group_form_submit(conn, %{"user" => user_params}) do
    choice = Map.get(user_params, "choice", "")

    conn
    |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
    |> redirect(to: ~p"/radio-group/form#radio-group-form-native")
  end

  def radio_group_form_submit(conn, _params) do
    conn
    |> put_flash(:info, "Submitted: choice=#{inspect("")}")
    |> redirect(to: ~p"/radio-group/form#radio-group-form-native")
  end

  def timer_page(conn, _params) do
    render(conn, :timer_page)
  end

  def timer_styling_page(conn, _params) do
    render(conn, :timer_styling_page)
  end

  def toast_anatomy_page(conn, _params) do
    render(conn, :toast_anatomy_page)
  end

  def tooltip_page(conn, _params) do
    render(conn, :tooltip_page)
  end

  def tooltip_styling_page(conn, _params) do
    render(conn, :tooltip_styling_page)
  end

  def templates_page(conn, _params) do
    template_carousel_items = [
      Corex.Image.new("/images/templates/soonex/preview-hero.png",
        alt: ~t"Hero section"
      ),
      Corex.Image.new("/images/templates/soonex/preview-highlights.png",
        alt: ~t"Highlights section"
      ),
      Corex.Image.new("/images/templates/soonex/preview-waitlist.png",
        alt: ~t"Waitlist section"
      )
    ]

    conn
    |> assign(:page_title, ~t"Templates · Corex")
    |> assign(:seo, E2eWeb.SEO.templates())
    |> assign(:template_carousel_items, template_carousel_items)
    |> render(:templates_page)
  end
end
