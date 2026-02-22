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

  def checkbox_page(conn, _params) do
    render(conn, :checkbox_page)
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

  def date_picker_page(conn, _params) do
    render(conn, :date_picker_page)
  end

  def signature_page(conn, _params) do
    render(conn, :signature_page)
  end

  def menu_page(conn, _params) do
    render(conn, :menu_page)
  end

  def tree_view_page(conn, _params) do
    render(conn, :tree_view_page)
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

  def editable_page(conn, _params) do
    render(conn, :editable_page, value_text: "My custom value")
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

  def password_input_page(conn, _params) do
    render(conn, :password_input_page)
  end

  def pin_input_page(conn, _params) do
    render(conn, :pin_input_page)
  end

  def radio_group_page(conn, _params) do
    render(conn, :radio_group_page)
  end

  def timer_page(conn, _params) do
    render(conn, :timer_page)
  end
end
