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
    changeset =
      %E2e.Form.Combobox{}
      |> E2e.Form.Combobox.changeset(%{"country" => ""})

    validate_changeset =
      %E2e.Form.Combobox{}
      |> E2e.Form.Combobox.changeset_validate(%{"country" => ""})

    form =
      Phoenix.Component.to_form(changeset,
        as: :combobox_changeset,
        id: "combobox-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :combobox_validate,
        id: "combobox-validate-form"
      )

    conn
    |> assign_combobox_form_docs(nil)
    |> render(:combobox_form_page, form: form, validate_form: validate_form)
  end

  defp assign_combobox_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.ComboboxDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.ComboboxDemo.form_doc_controller_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.ComboboxDemo.form_doc_controller_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.ComboboxDemo.form_doc_controller_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.ComboboxDemo.form_doc_controller_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.ComboboxDemo.form_doc_controller_native_heex())
  end

  def combobox_form_submit(conn, params) do
    cond do
      is_map(params["combobox_changeset"]) ->
        changeset =
          %E2e.Form.Combobox{}
          |> E2e.Form.Combobox.changeset(params["combobox_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): country=#{inspect(data.country)}")
          |> redirect(to: ~p"/combobox/form#combobox-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :combobox_changeset,
              id: "combobox-changeset-form"
            )

          validate_form =
            %E2e.Form.Combobox{}
            |> E2e.Form.Combobox.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :combobox_validate,
              id: "combobox-validate-form"
            )

          conn
          |> assign_combobox_form_docs("combobox-form-changeset")
          |> render(:combobox_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["combobox_validate"]) ->
        changeset =
          %E2e.Form.Combobox{}
          |> E2e.Form.Combobox.changeset_validate(params["combobox_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (validated): country=#{inspect(data.country)}")
          |> redirect(to: ~p"/combobox/form#combobox-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :combobox_validate,
              id: "combobox-validate-form"
            )

          form =
            %E2e.Form.Combobox{}
            |> E2e.Form.Combobox.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :combobox_changeset,
              id: "combobox-changeset-form"
            )

          conn
          |> assign_combobox_form_docs("combobox-form-validate")
          |> render(:combobox_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["combobox_native"]) ->
        native = params["combobox_native"] || %{}
        country = native["country"] || ""

        conn
        |> put_flash(:info, "Submitted (native): country=#{inspect(country)}")
        |> redirect(to: ~p"/combobox/form#combobox-form-controller")

      true ->
        combobox_params = params["combobox"] || %{}
        country = combobox_params["country"] || ""

        conn
        |> put_flash(:info, "Submitted: country=#{inspect(country)}")
        |> redirect(to: ~p"/combobox/form")
    end
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
    |> assign(:changeset_heex, E2eWeb.Demos.CheckboxDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.CheckboxDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.CheckboxDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.CheckboxDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.CheckboxDemo.form_native_heex())
  end

  def checkbox_form_page(conn, _params) do
    changeset =
      %E2e.Form.Terms{}
      |> E2e.Form.Terms.changeset(%{})

    validate_changeset =
      %E2e.Form.Terms{}
      |> E2e.Form.Terms.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :terms_changeset,
        id: "checkbox-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :terms_validate,
        id: "checkbox-validate-form"
      )

    conn
    |> assign_checkbox_form_docs(nil)
    |> render(:checkbox_form_page, form: form, validate_form: validate_form)
  end

  def checkbox_form_submit(conn, params) do
    cond do
      is_map(params["terms_changeset"]) ->
        changeset =
          %E2e.Form.Terms{}
          |> E2e.Form.Terms.changeset(params["terms_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): terms=#{inspect(data.terms)}")
          |> redirect(to: ~p"/checkbox/form#checkbox-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :terms_changeset,
              id: "checkbox-changeset-form"
            )

          validate_form =
            %E2e.Form.Terms{}
            |> E2e.Form.Terms.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :terms_validate,
              id: "checkbox-validate-form"
            )

          conn
          |> assign_checkbox_form_docs("checkbox-form-changeset")
          |> render(:checkbox_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["terms_validate"]) ->
        changeset =
          %E2e.Form.Terms{}
          |> E2e.Form.Terms.changeset_validate(params["terms_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (validated): terms=#{inspect(data.terms)}")
          |> redirect(to: ~p"/checkbox/form#checkbox-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :terms_validate,
              id: "checkbox-validate-form"
            )

          form =
            %E2e.Form.Terms{}
            |> E2e.Form.Terms.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :terms_changeset,
              id: "checkbox-changeset-form"
            )

          conn
          |> assign_checkbox_form_docs("checkbox-form-validate")
          |> render(:checkbox_form_page, form: form, validate_form: validate_form)
        end

      true ->
        terms =
          get_in(params, ["terms", "terms"]) || params["terms"] ||
            get_in(params, ["user", "terms"])

        conn
        |> put_flash(:info, "Submitted: terms=#{inspect(terms)}")
        |> redirect(to: ~p"/checkbox/form#checkbox-form-controller")
    end
  end

  defp assign_switch_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.SwitchDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.SwitchDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.SwitchDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.SwitchDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.SwitchDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.SwitchDemo.form_native_heex())
  end

  def switch_form_page(conn, _params) do
    changeset =
      %E2e.Form.Preferences{}
      |> E2e.Form.Preferences.changeset(%{})

    validate_changeset =
      %E2e.Form.Preferences{}
      |> E2e.Form.Preferences.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :preferences_changeset,
        id: "switch-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :preferences_validate,
        id: "switch-validate-form"
      )

    conn
    |> assign_switch_form_docs(nil)
    |> render(:switch_form_page, form: form, validate_form: validate_form)
  end

  def switch_form_submit(conn, params) do
    cond do
      is_map(params["preferences_changeset"]) ->
        changeset =
          %E2e.Form.Preferences{}
          |> E2e.Form.Preferences.changeset(params["preferences_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(
            :info,
            "Submitted (changeset): notifications=#{inspect(data.notifications)}"
          )
          |> redirect(to: ~p"/switch/form#switch-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :preferences_changeset,
              id: "switch-changeset-form"
            )

          validate_form =
            %E2e.Form.Preferences{}
            |> E2e.Form.Preferences.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :preferences_validate,
              id: "switch-validate-form"
            )

          conn
          |> assign_switch_form_docs("switch-form-changeset")
          |> render(:switch_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["preferences_validate"]) ->
        changeset =
          %E2e.Form.Preferences{}
          |> E2e.Form.Preferences.changeset_validate(params["preferences_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(
            :info,
            "Submitted (validated): notifications=#{inspect(data.notifications)}"
          )
          |> redirect(to: ~p"/switch/form#switch-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :preferences_validate,
              id: "switch-validate-form"
            )

          form =
            %E2e.Form.Preferences{}
            |> E2e.Form.Preferences.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :preferences_changeset,
              id: "switch-changeset-form"
            )

          conn
          |> assign_switch_form_docs("switch-form-validate")
          |> render(:switch_form_page, form: form, validate_form: validate_form)
        end

      true ->
        notifications = get_in(params, ["user", "notifications"])

        conn
        |> put_flash(:info, "Submitted: notifications=#{inspect(notifications)}")
        |> redirect(to: ~p"/switch/form#switch-form-controller")
    end
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
    |> assign(:changeset_heex, E2eWeb.Demos.SelectDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.SelectDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.SelectDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.SelectDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.SelectDemo.form_native_heex())
  end

  def select_form_page(conn, _params) do
    changeset =
      %E2e.Form.SelectForm{}
      |> E2e.Form.SelectForm.changeset(%{})

    validate_changeset =
      %E2e.Form.SelectForm{}
      |> E2e.Form.SelectForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :select_changeset,
        id: "select-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :select_validate,
        id: "select-validate-form"
      )

    conn
    |> assign_select_form_docs(nil)
    |> render(:select_form_page, form: form, validate_form: validate_form)
  end

  def select_form_submit(conn, params) do
    cond do
      is_map(params["select_changeset"]) ->
        changeset =
          %E2e.Form.SelectForm{}
          |> E2e.Form.SelectForm.changeset(params["select_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): country=#{inspect(data.country)}")
          |> redirect(to: ~p"/select/form#select-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :select_changeset,
              id: "select-changeset-form"
            )

          validate_form =
            %E2e.Form.SelectForm{}
            |> E2e.Form.SelectForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :select_validate,
              id: "select-validate-form"
            )

          conn
          |> assign_select_form_docs("select-form-changeset")
          |> render(:select_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["select_validate"]) ->
        changeset =
          %E2e.Form.SelectForm{}
          |> E2e.Form.SelectForm.changeset_validate(params["select_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (validated): country=#{inspect(data.country)}")
          |> redirect(to: ~p"/select/form#select-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :select_validate,
              id: "select-validate-form"
            )

          form =
            %E2e.Form.SelectForm{}
            |> E2e.Form.SelectForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :select_changeset,
              id: "select-changeset-form"
            )

          conn
          |> assign_select_form_docs("select-form-validate")
          |> render(:select_form_page, form: form, validate_form: validate_form)
        end

      true ->
        country = get_in(params, ["user", "country"]) || ""

        conn
        |> put_flash(:info, "Submitted: country=#{inspect(country)}")
        |> redirect(to: ~p"/select/form#select-form-controller")
    end
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
    |> assign(:changeset_heex, E2eWeb.Demos.AngleSliderDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.AngleSliderDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.AngleSliderDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.AngleSliderDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.AngleSliderDemo.form_native_heex())
  end

  def angle_slider_form_page(conn, _params) do
    changeset =
      %E2e.Form.AngleSliderForm{}
      |> E2e.Form.AngleSliderForm.changeset(%{})

    validate_changeset =
      %E2e.Form.AngleSliderForm{}
      |> E2e.Form.AngleSliderForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :angle_slider_changeset,
        id: "angle-slider-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :angle_slider_validate,
        id: "angle-slider-validate-form"
      )

    conn
    |> assign_angle_slider_form_docs(nil)
    |> render(:angle_slider_form_page, form: form, validate_form: validate_form)
  end

  def angle_slider_form_submit(conn, params) do
    cond do
      is_map(params["angle_slider_changeset"]) ->
        changeset =
          %E2e.Form.AngleSliderForm{}
          |> E2e.Form.AngleSliderForm.changeset(params["angle_slider_changeset"] || %{})

        if changeset.valid? do
          angle = get_in(params, ["angle_slider_changeset", "angle"]) || "0"

          conn
          |> put_flash(:info, "Submitted (changeset): angle=#{angle}")
          |> redirect(to: ~p"/angle-slider/form#angle-slider-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :angle_slider_changeset,
              id: "angle-slider-changeset-form"
            )

          validate_form =
            %E2e.Form.AngleSliderForm{}
            |> E2e.Form.AngleSliderForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :angle_slider_validate,
              id: "angle-slider-validate-form"
            )

          conn
          |> assign_angle_slider_form_docs("angle-slider-form-changeset")
          |> render(:angle_slider_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["angle_slider_validate"]) ->
        changeset =
          %E2e.Form.AngleSliderForm{}
          |> E2e.Form.AngleSliderForm.changeset_validate(params["angle_slider_validate"] || %{})

        if changeset.valid? do
          angle = get_in(params, ["angle_slider_validate", "angle"]) || "0"

          conn
          |> put_flash(:info, "Submitted (validated): angle=#{angle}")
          |> redirect(to: ~p"/angle-slider/form#angle-slider-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :angle_slider_validate,
              id: "angle-slider-validate-form"
            )

          form =
            %E2e.Form.AngleSliderForm{}
            |> E2e.Form.AngleSliderForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :angle_slider_changeset,
              id: "angle-slider-changeset-form"
            )

          conn
          |> assign_angle_slider_form_docs("angle-slider-form-validate")
          |> render(:angle_slider_form_page, form: form, validate_form: validate_form)
        end

      true ->
        angle = get_in(params, ["angle_slider_form", "angle"]) || "0"

        conn
        |> put_flash(:info, "Submitted: angle=#{angle}")
        |> redirect(to: ~p"/angle-slider/form#angle-slider-form-controller")
    end
  end

  defp assign_color_picker_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.ColorPickerDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.ColorPickerDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.ColorPickerDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.ColorPickerDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.ColorPickerDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.ColorPickerDemo.form_native_heex())
  end

  def color_picker_form_page(conn, _params) do
    form =
      %E2e.Form.ColorPickerForm{}
      |> E2e.Form.ColorPickerForm.changeset(%{})
      |> Phoenix.Component.to_form(
        as: :color_picker_changeset,
        id: "color-picker-changeset-form"
      )

    validate_form =
      %E2e.Form.ColorPickerForm{}
      |> E2e.Form.ColorPickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(
        as: :color_picker_validate,
        id: "color-picker-validate-form"
      )

    conn
    |> assign_color_picker_form_docs(nil)
    |> render(:color_picker_form_page, form: form, validate_form: validate_form)
  end

  def color_picker_form_submit(conn, params) do
    cond do
      is_map(params["color_picker_changeset"]) ->
        changeset =
          %E2e.Form.ColorPickerForm{}
          |> E2e.Form.ColorPickerForm.changeset(params["color_picker_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): color=#{data.color}")
          |> redirect(to: ~p"/color-picker/form#color-picker-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :color_picker_changeset,
              id: "color-picker-changeset-form"
            )

          validate_form =
            %E2e.Form.ColorPickerForm{}
            |> E2e.Form.ColorPickerForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :color_picker_validate,
              id: "color-picker-validate-form"
            )

          conn
          |> assign_color_picker_form_docs("color-picker-form-changeset")
          |> render(:color_picker_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["color_picker_validate"]) ->
        changeset =
          %E2e.Form.ColorPickerForm{}
          |> E2e.Form.ColorPickerForm.changeset_validate(params["color_picker_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (validated): color=#{data.color}")
          |> redirect(to: ~p"/color-picker/form#color-picker-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :color_picker_validate,
              id: "color-picker-validate-form"
            )

          form =
            %E2e.Form.ColorPickerForm{}
            |> E2e.Form.ColorPickerForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :color_picker_changeset,
              id: "color-picker-changeset-form"
            )

          conn
          |> assign_color_picker_form_docs("color-picker-form-validate")
          |> render(:color_picker_form_page, form: form, validate_form: validate_form)
        end

      true ->
        color = get_in(params, ["color_picker_form", "color"]) || "#3b82f6"

        conn
        |> put_flash(:info, "Submitted: color=#{color}")
        |> redirect(to: ~p"/color-picker/form#color-picker-form-controller")
    end
  end

  def date_picker_page(conn, _params) do
    render(conn, :date_picker_page)
  end

  defp assign_date_picker_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.DatePickerDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.DatePickerDemo.form_doc_controller_changeset_heex())
    |> assign(
      :changeset_elixir,
      E2eWeb.Demos.DatePickerDemo.form_doc_controller_changeset_elixir()
    )
    |> assign(:validate_heex, E2eWeb.Demos.DatePickerDemo.form_doc_controller_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.DatePickerDemo.form_doc_controller_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.DatePickerDemo.form_doc_native_heex())
  end

  def date_picker_form_page(conn, _params) do
    form =
      %E2e.Form.DatePickerForm{}
      |> E2e.Form.DatePickerForm.changeset(%{})
      |> Phoenix.Component.to_form(as: :date_picker_changeset, id: "date-picker-changeset-form")

    validate_form =
      %E2e.Form.DatePickerForm{}
      |> E2e.Form.DatePickerForm.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :date_picker_validate, id: "date-picker-validate-form")

    conn
    |> assign_date_picker_form_docs(nil)
    |> render(:date_picker_form_page, form: form, validate_form: validate_form)
  end

  def date_picker_form_submit(conn, params) do
    cond do
      is_map(params["date_picker_changeset"]) ->
        changeset =
          %E2e.Form.DatePickerForm{}
          |> E2e.Form.DatePickerForm.changeset(params["date_picker_changeset"] || %{})

        if changeset.valid? do
          date = get_in(params, ["date_picker_changeset", "date"]) || ""

          conn
          |> put_flash(:info, "Submitted (changeset): date=#{date}")
          |> redirect(to: ~p"/date-picker/form#date-picker-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :date_picker_changeset,
              id: "date-picker-changeset-form"
            )

          validate_form =
            %E2e.Form.DatePickerForm{}
            |> E2e.Form.DatePickerForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :date_picker_validate,
              id: "date-picker-validate-form"
            )

          conn
          |> assign_date_picker_form_docs("date-picker-form-changeset")
          |> render(:date_picker_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["date_picker_validate"]) ->
        changeset =
          %E2e.Form.DatePickerForm{}
          |> E2e.Form.DatePickerForm.changeset_validate(params["date_picker_validate"] || %{})

        if changeset.valid? do
          date = get_in(params, ["date_picker_validate", "date"]) || ""

          conn
          |> put_flash(:info, "Submitted (validated): date=#{date}")
          |> redirect(to: ~p"/date-picker/form#date-picker-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :date_picker_validate,
              id: "date-picker-validate-form"
            )

          form =
            %E2e.Form.DatePickerForm{}
            |> E2e.Form.DatePickerForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :date_picker_changeset,
              id: "date-picker-changeset-form"
            )

          conn
          |> assign_date_picker_form_docs("date-picker-form-validate")
          |> render(:date_picker_form_page, form: form, validate_form: validate_form)
        end

      true ->
        date = get_in(params, ["date_picker_form", "date"]) || ""

        conn
        |> put_flash(:info, "Submitted: date=#{date}")
        |> redirect(to: ~p"/date-picker/form#date-picker-form-controller")
    end
  end

  def signature_page(conn, _params) do
    render(conn, :signature_page)
  end

  defp assign_signature_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.SignatureDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.SignatureDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.SignatureDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.SignatureDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.SignatureDemo.form_validate_elixir())
  end

  def signature_form_page(conn, _params) do
    changeset =
      %E2e.Form.SignatureForm{}
      |> E2e.Form.SignatureForm.changeset(%{})

    validate_changeset =
      %E2e.Form.SignatureForm{}
      |> E2e.Form.SignatureForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :signature_changeset,
        id: "signature-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :signature_validate,
        id: "signature-validate-form"
      )

    conn
    |> assign_signature_form_docs(nil)
    |> render(:signature_form_page, form: form, validate_form: validate_form)
  end

  def signature_form_submit(conn, params) do
    cond do
      is_map(params["signature_changeset"]) ->
        changeset =
          %E2e.Form.SignatureForm{}
          |> E2e.Form.SignatureForm.changeset(params["signature_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)
          preview = preview_sig(data.signature)

          conn
          |> put_flash(:info, "Submitted (changeset): signature=#{preview}")
          |> redirect(to: ~p"/signature/form#signature-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :signature_changeset,
              id: "signature-changeset-form"
            )

          validate_form =
            %E2e.Form.SignatureForm{}
            |> E2e.Form.SignatureForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :signature_validate,
              id: "signature-validate-form"
            )

          conn
          |> assign_signature_form_docs("signature-form-changeset")
          |> render(:signature_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["signature_validate"]) ->
        changeset =
          %E2e.Form.SignatureForm{}
          |> E2e.Form.SignatureForm.changeset_validate(params["signature_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)
          preview = preview_sig(data.signature)

          conn
          |> put_flash(:info, "Submitted (validated): signature=#{preview}")
          |> redirect(to: ~p"/signature/form#signature-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :signature_validate,
              id: "signature-validate-form"
            )

          form =
            %E2e.Form.SignatureForm{}
            |> E2e.Form.SignatureForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :signature_changeset,
              id: "signature-changeset-form"
            )

          conn
          |> assign_signature_form_docs("signature-form-validate")
          |> render(:signature_form_page, form: form, validate_form: validate_form)
        end

      true ->
        sig = get_in(params, ["user", "signature"]) || ""
        preview = preview_sig(sig)

        conn
        |> put_flash(:info, "Submitted: signature=#{preview}")
        |> redirect(to: ~p"/signature/form")
    end
  end

  defp preview_sig(sig) when is_binary(sig) and sig != "" do
    String.slice(sig, 0, 30) <> "..."
  end

  defp preview_sig(_), do: "(empty)"

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

  def data_table_page(conn, _params) do
    render(conn, :data_table_page)
  end

  def editable_page(conn, _params) do
    render(conn, :editable_page, value_text: "My custom value")
  end

  def editable_styling_page(conn, _params) do
    render(conn, :editable_styling_page)
  end

  def editable_form_page(conn, _params) do
    form =
      %E2e.Form.EditableForm{}
      |> E2e.Form.EditableForm.changeset(%{"text" => ""})
      |> Phoenix.Component.to_form(as: :editable_form, id: "editable-form")

    render(conn, :editable_form_page, form: form)
  end

  def editable_form_submit(conn, params) do
    text = get_in(params, ["editable_form", "text"]) || ""

    conn
    |> put_flash(:info, "Submitted: text=#{inspect(text)}")
    |> redirect(to: ~p"/editable/form")
  end

  def native_input_page(conn, _params) do
    render(conn, :native_input_page)
  end

  defp assign_native_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.NativeInputDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.NativeInputDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.NativeInputDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.NativeInputDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.NativeInputDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.NativeInputDemo.form_native_heex())
  end

  defp native_input_profile_forms do
    form =
      %E2e.Form.NativeInputProfile{}
      |> E2e.Form.NativeInputProfile.changeset(%{})
      |> Phoenix.Component.to_form(as: :profile_changeset, id: "native-input-changeset-form")

    validate_form =
      %E2e.Form.NativeInputProfile{}
      |> E2e.Form.NativeInputProfile.changeset_validate(%{})
      |> Phoenix.Component.to_form(as: :profile_validate, id: "native-input-validate-form")

    {form, validate_form}
  end

  def native_input_form_page(conn, _params) do
    {form, validate_form} = native_input_profile_forms()

    conn
    |> assign_native_input_form_docs(nil)
    |> render(:native_input_form_page, form: form, validate_form: validate_form)
  end

  def native_input_form_submit(conn, params) do
    cond do
      is_map(params["profile_changeset"]) ->
        case E2e.Form.NativeInputProfile.changeset(
               %E2e.Form.NativeInputProfile{},
               params["profile_changeset"] || %{}
             ) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(
              :info,
              "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(data)}"
            )
            |> redirect(to: ~p"/native-input/form#native-input-form-changeset")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :profile_changeset,
                id: "native-input-changeset-form"
              )

            {_, validate_form} = native_input_profile_forms()

            conn
            |> assign_native_input_form_docs("native-input-form-changeset")
            |> render(:native_input_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["profile_validate"]) ->
        case E2e.Form.NativeInputProfile.changeset_validate(
               %E2e.Form.NativeInputProfile{},
               params["profile_validate"] || %{}
             ) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(
              :info,
              "Submitted (strict): #{E2e.Form.NativeInputProfile.format_for_toast(data)}"
            )
            |> redirect(to: ~p"/native-input/form#native-input-form-validate")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            validate_form =
              Phoenix.Component.to_form(changeset,
                as: :profile_validate,
                id: "native-input-validate-form"
              )

            {form, _} = native_input_profile_forms()

            conn
            |> assign_native_input_form_docs("native-input-form-validate")
            |> render(:native_input_form_page, form: form, validate_form: validate_form)
        end

      true ->
        profile = params["profile"] || %{}

        conn
        |> put_flash(:info, "Submitted: #{E2e.Form.NativeInputProfile.format_for_toast(profile)}")
        |> redirect(to: ~p"/native-input/form#native-input-form-native")
    end
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
    |> assign(:changeset_heex, E2eWeb.Demos.NumberInputDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.NumberInputDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.NumberInputDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.NumberInputDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.NumberInputDemo.form_native_heex())
  end

  defp number_input_pair_forms do
    form =
      %E2e.Form.NumberInputForm{}
      |> E2e.Form.NumberInputForm.changeset(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_changeset, id: "number-input-changeset-form")

    validate_form =
      %E2e.Form.NumberInputForm{}
      |> E2e.Form.NumberInputForm.changeset_validate(%{"value" => "1234"})
      |> Phoenix.Component.to_form(as: :number_input_validate, id: "number-input-validate-form")

    {form, validate_form}
  end

  def number_input_form_page(conn, _params) do
    {form, validate_form} = number_input_pair_forms()

    conn
    |> assign_number_input_form_docs(nil)
    |> render(:number_input_form_page, form: form, validate_form: validate_form)
  end

  def number_input_form_submit(conn, params) do
    cond do
      is_map(params["number_input_changeset"]) ->
        case E2e.Form.NumberInputForm.changeset(
               %E2e.Form.NumberInputForm{},
               params["number_input_changeset"] || %{}
             ) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted: #{E2e.Form.NumberInputForm.format_for_toast(data)}")
            |> redirect(to: ~p"/number-input/form#number-input-form-changeset")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :number_input_changeset,
                id: "number-input-changeset-form"
              )

            {_, validate_form} = number_input_pair_forms()

            conn
            |> assign_number_input_form_docs("number-input-form-changeset")
            |> render(:number_input_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["number_input_validate"]) ->
        case E2e.Form.NumberInputForm.changeset_validate(
               %E2e.Form.NumberInputForm{},
               params["number_input_validate"] || %{}
             ) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(
              :info,
              "Submitted (strict): #{E2e.Form.NumberInputForm.format_for_toast(data)}"
            )
            |> redirect(to: ~p"/number-input/form#number-input-form-validate")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            validate_form =
              Phoenix.Component.to_form(changeset,
                as: :number_input_validate,
                id: "number-input-validate-form"
              )

            {form, _} = number_input_pair_forms()

            conn
            |> assign_number_input_form_docs("number-input-form-validate")
            |> render(:number_input_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["number_input_form"]) ->
        value = get_in(params, ["number_input_form", "value"]) || "0"

        conn
        |> put_flash(:info, "Submitted: value=#{value}")
        |> redirect(to: ~p"/number-input/form")

      true ->
        value = params["value"] || "0"

        conn
        |> put_flash(:info, "Submitted: value=#{value}")
        |> redirect(to: ~p"/number-input/form#number-input-form-native")
    end
  end

  def file_upload_page(conn, _params) do
    render(conn, :file_upload_page)
  end

  defp assign_file_upload_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.FileUploadDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.FileUploadDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.FileUploadDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.FileUploadDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.FileUploadDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.FileUploadDemo.form_native_heex())
  end

  def file_upload_form_page(conn, _params) do
    changeset =
      %E2e.Form.FileUploadForm{}
      |> E2e.Form.FileUploadForm.changeset(%{})

    validate_changeset =
      %E2e.Form.FileUploadForm{}
      |> E2e.Form.FileUploadForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :file_upload_changeset,
        id: "file-upload-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :file_upload_validate,
        id: "file-upload-validate-form"
      )

    conn
    |> assign_file_upload_form_docs(nil)
    |> render(:file_upload_form_page, form: form, validate_form: validate_form)
  end

  def file_upload_form_submit(conn, params) do
    cond do
      is_map(params["file_upload_changeset"]) ->
        nested = params["file_upload_changeset"] || %{}
        upload = nested["attachment"]

        changeset =
          %E2e.Form.FileUploadForm{}
          |> E2e.Form.FileUploadForm.changeset(nested)

        if changeset.valid? do
          conn
          |> put_flash(
            :info,
            "Submitted (changeset): attachment=#{file_upload_attachment_label(upload)}"
          )
          |> redirect(to: ~p"/file-upload/form#file-upload-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :file_upload_changeset,
              id: "file-upload-changeset-form"
            )

          validate_form =
            %E2e.Form.FileUploadForm{}
            |> E2e.Form.FileUploadForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :file_upload_validate,
              id: "file-upload-validate-form"
            )

          conn
          |> assign_file_upload_form_docs("file-upload-form-changeset")
          |> render(:file_upload_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["file_upload_validate"]) ->
        nested = params["file_upload_validate"] || %{}
        upload = nested["attachment"]

        changeset =
          %E2e.Form.FileUploadForm{}
          |> E2e.Form.FileUploadForm.changeset_validate(nested)

        if changeset.valid? do
          conn
          |> put_flash(
            :info,
            "Submitted (validated): attachment=#{file_upload_attachment_label(upload)}"
          )
          |> redirect(to: ~p"/file-upload/form#file-upload-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :file_upload_validate,
              id: "file-upload-validate-form"
            )

          form =
            %E2e.Form.FileUploadForm{}
            |> E2e.Form.FileUploadForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :file_upload_changeset,
              id: "file-upload-changeset-form"
            )

          conn
          |> assign_file_upload_form_docs("file-upload-form-validate")
          |> render(:file_upload_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["user"]) ->
        upload = get_in(params, ["user", "avatar"])

        conn
        |> put_flash(:info, "Submitted (native): avatar=#{file_upload_attachment_label(upload)}")
        |> redirect(to: ~p"/file-upload/form#file-upload-form-controller")

      true ->
        conn
        |> put_flash(:error, "Unexpected form payload")
        |> redirect(to: ~p"/file-upload/form")
    end
  end

  defp file_upload_attachment_label(%Plug.Upload{filename: name})
       when is_binary(name) and name != "",
       do: name

  defp file_upload_attachment_label(_), do: "(none)"

  def password_input_page(conn, _params) do
    render(conn, :password_input_page)
  end

  defp assign_password_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.PasswordInputDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.PasswordInputDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.PasswordInputDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.PasswordInputDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.PasswordInputDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.PasswordInputDemo.form_native_heex())
  end

  def password_input_form_page(conn, _params) do
    changeset =
      %E2e.Form.PasswordInputForm{}
      |> E2e.Form.PasswordInputForm.changeset(%{})

    validate_changeset =
      %E2e.Form.PasswordInputForm{}
      |> E2e.Form.PasswordInputForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :password_input_changeset,
        id: "password-input-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :password_input_validate,
        id: "password-input-validate-form"
      )

    conn
    |> assign_password_input_form_docs(nil)
    |> render(:password_input_form_page, form: form, validate_form: validate_form)
  end

  def password_input_form_submit(conn, params) do
    cond do
      is_map(params["password_input_changeset"]) ->
        changeset =
          %E2e.Form.PasswordInputForm{}
          |> E2e.Form.PasswordInputForm.changeset(params["password_input_changeset"] || %{})

        if changeset.valid? do
          conn
          |> put_flash(:info, "Submitted (changeset): password=***")
          |> redirect(to: ~p"/password-input/form#password-input-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :password_input_changeset,
              id: "password-input-changeset-form"
            )

          validate_form =
            %E2e.Form.PasswordInputForm{}
            |> E2e.Form.PasswordInputForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :password_input_validate,
              id: "password-input-validate-form"
            )

          conn
          |> assign_password_input_form_docs("password-input-form-changeset")
          |> render(:password_input_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["password_input_validate"]) ->
        changeset =
          %E2e.Form.PasswordInputForm{}
          |> E2e.Form.PasswordInputForm.changeset_validate(
            params["password_input_validate"] || %{}
          )

        if changeset.valid? do
          conn
          |> put_flash(:info, "Submitted (validated): password=***")
          |> redirect(to: ~p"/password-input/form#password-input-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :password_input_validate,
              id: "password-input-validate-form"
            )

          form =
            %E2e.Form.PasswordInputForm{}
            |> E2e.Form.PasswordInputForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :password_input_changeset,
              id: "password-input-changeset-form"
            )

          conn
          |> assign_password_input_form_docs("password-input-form-validate")
          |> render(:password_input_form_page, form: form, validate_form: validate_form)
        end

      true ->
        password = get_in(params, ["user", "password"]) || ""

        message =
          if password == "", do: "Submitted: password=", else: "Submitted: password=***"

        conn
        |> put_flash(:info, message)
        |> redirect(to: ~p"/password-input/form#password-input-form-controller")
    end
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
    |> redirect(to: ~p"/pin-input/form")
  end

  defp assign_tags_input_form_docs(conn, scroll_to) do
    conn
    |> assign(:scroll_to, scroll_to)
    |> assign(:form_ecto, E2eWeb.Demos.TagsInputDemo.form_ecto())
    |> assign(:changeset_heex, E2eWeb.Demos.TagsInputDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.TagsInputDemo.form_changeset_elixir())
    |> assign(:native_heex, E2eWeb.Demos.TagsInputDemo.form_native_heex())
  end

  def tags_input_form_page(conn, _params) do
    form =
      %E2e.Form.TagsInputForm{}
      |> E2e.Form.TagsInputForm.changeset_validate(%{"tags" => "alpha,beta"})
      |> Phoenix.Component.to_form(as: :tags_input_changeset, id: "tags-input-changeset-form")

    conn
    |> assign_tags_input_form_docs(nil)
    |> render(:tags_input_form_page, form: form)
  end

  def tags_input_form_submit(conn, params) do
    cond do
      is_map(params["tags_input_changeset"]) ->
        case E2e.Form.TagsInputForm.changeset_validate(
               %E2e.Form.TagsInputForm{},
               params["tags_input_changeset"] || %{}
             ) do
          %Ecto.Changeset{valid?: true} = changeset ->
            data = Ecto.Changeset.apply_changes(changeset)

            conn
            |> put_flash(:info, "Submitted (changeset): tags=#{inspect(data.tags)}")
            |> redirect(to: ~p"/tags-input/form#tags-input-form-changeset")

          changeset ->
            changeset = Map.put(changeset, :action, :insert)

            form =
              Phoenix.Component.to_form(changeset,
                as: :tags_input_changeset,
                id: "tags-input-changeset-form"
              )

            conn
            |> assign_tags_input_form_docs("tags-input-form-changeset")
            |> render(:tags_input_form_page, form: form)
        end

      is_map(params["tags_native"]) ->
        tags = get_in(params, ["tags_native", "tags"]) || ""

        conn
        |> put_flash(:info, "Submitted (native): tags=#{inspect(tags)}")
        |> redirect(to: ~p"/tags-input/form#tags-input-form-native")

      true ->
        conn
        |> put_flash(:error, "Unknown form submission")
        |> redirect(to: ~p"/tags-input/form")
    end
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
    |> assign(:changeset_heex, E2eWeb.Demos.RadioGroupDemo.form_changeset_heex())
    |> assign(:changeset_elixir, E2eWeb.Demos.RadioGroupDemo.form_changeset_elixir())
    |> assign(:validate_heex, E2eWeb.Demos.RadioGroupDemo.form_validate_heex())
    |> assign(:validate_elixir, E2eWeb.Demos.RadioGroupDemo.form_validate_elixir())
    |> assign(:native_heex, E2eWeb.Demos.RadioGroupDemo.form_native_heex())
  end

  def radio_group_form_page(conn, _params) do
    changeset =
      %E2e.Form.RadioGroupForm{}
      |> E2e.Form.RadioGroupForm.changeset(%{})

    validate_changeset =
      %E2e.Form.RadioGroupForm{}
      |> E2e.Form.RadioGroupForm.changeset_validate(%{})

    form =
      Phoenix.Component.to_form(changeset,
        as: :radio_group_changeset,
        id: "radio-group-changeset-form"
      )

    validate_form =
      Phoenix.Component.to_form(validate_changeset,
        as: :radio_group_validate,
        id: "radio-group-validate-form"
      )

    conn
    |> assign_radio_group_form_docs(nil)
    |> render(:radio_group_form_page, form: form, validate_form: validate_form)
  end

  def radio_group_form_submit(conn, params) do
    cond do
      is_map(params["radio_group_changeset"]) ->
        changeset =
          %E2e.Form.RadioGroupForm{}
          |> E2e.Form.RadioGroupForm.changeset(params["radio_group_changeset"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): choice=#{inspect(data.choice)}")
          |> redirect(to: ~p"/radio-group/form#radio-group-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :radio_group_changeset,
              id: "radio-group-changeset-form"
            )

          validate_form =
            %E2e.Form.RadioGroupForm{}
            |> E2e.Form.RadioGroupForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :radio_group_validate,
              id: "radio-group-validate-form"
            )

          conn
          |> assign_radio_group_form_docs("radio-group-form-changeset")
          |> render(:radio_group_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["radio_group_validate"]) ->
        changeset =
          %E2e.Form.RadioGroupForm{}
          |> E2e.Form.RadioGroupForm.changeset_validate(params["radio_group_validate"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (validated): choice=#{inspect(data.choice)}")
          |> redirect(to: ~p"/radio-group/form#radio-group-form-validate")
        else
          changeset = Map.put(changeset, :action, :insert)

          validate_form =
            Phoenix.Component.to_form(changeset,
              as: :radio_group_validate,
              id: "radio-group-validate-form"
            )

          form =
            %E2e.Form.RadioGroupForm{}
            |> E2e.Form.RadioGroupForm.changeset(%{})
            |> Phoenix.Component.to_form(
              as: :radio_group_changeset,
              id: "radio-group-changeset-form"
            )

          conn
          |> assign_radio_group_form_docs("radio-group-form-validate")
          |> render(:radio_group_form_page, form: form, validate_form: validate_form)
        end

      is_map(params["radio_group_form"]) ->
        changeset =
          %E2e.Form.RadioGroupForm{}
          |> E2e.Form.RadioGroupForm.changeset(params["radio_group_form"] || %{})

        if changeset.valid? do
          data = Ecto.Changeset.apply_changes(changeset)

          conn
          |> put_flash(:info, "Submitted (changeset): choice=#{inspect(data.choice)}")
          |> redirect(to: ~p"/radio-group/form#radio-group-form-changeset")
        else
          changeset = Map.put(changeset, :action, :insert)

          form =
            Phoenix.Component.to_form(changeset,
              as: :radio_group_changeset,
              id: "radio-group-changeset-form"
            )

          validate_form =
            %E2e.Form.RadioGroupForm{}
            |> E2e.Form.RadioGroupForm.changeset_validate(%{})
            |> Phoenix.Component.to_form(
              as: :radio_group_validate,
              id: "radio-group-validate-form"
            )

          conn
          |> assign_radio_group_form_docs("radio-group-form-changeset")
          |> render(:radio_group_form_page, form: form, validate_form: validate_form)
        end

      true ->
        choice = get_in(params, ["user", "choice"]) || ""

        conn
        |> put_flash(:info, "Submitted: choice=#{inspect(choice)}")
        |> redirect(to: ~p"/radio-group/form#radio-group-form-controller")
    end
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
      %{url: "/images/templates/soonex/preview-hero.png", alt: gettext("Hero section")},
      %{
        url: "/images/templates/soonex/preview-highlights.png",
        alt: gettext("Highlights section")
      },
      %{url: "/images/templates/soonex/preview-waitlist.png", alt: gettext("Waitlist section")}
    ]

    conn
    |> assign(:page_title, gettext("Templates · Corex"))
    |> assign(:template_carousel_items, template_carousel_items)
    |> render(:templates_page)
  end
end
