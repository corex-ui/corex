defmodule Corex.PinInputTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.PinInput
  alias Corex.PinInput.Connect

  describe "pin_input/1" do
    test "renders" do
      html = render_component(&PinInput.pin_input/1, id: "pin-basic", name: "pin", count: 4)
      assert html =~ ~r/data-scope="pin-input"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders full options" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input
              id="pin-full"
              name="otp"
              count={4}
              value="12"
              otp
              mask
              type="alphanumeric"
              placeholder="○"
              invalid
              errors={["Invalid code"]}
              select_on_focus
            >
              <:label>Enter code</:label>
              <:error :let={msg}>{msg}</:error>
            </PinInput.pin_input>
            """
          end,
          %{}
        )

      assert html =~ "Invalid code"
      assert html =~ "○"
      assert html =~ ~S(data-select-on-focus)
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "pin-input:test-pin"
      assert result["data-scope"] == "pin-input"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-pin", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "pin-input:test-pin:label"
    end
  end

  describe "Connect.props/1" do
    test "maps list value and options" do
      result =
        Connect.props(%{
          id: "pin",
          value: ["1", "2"],
          count: 4,
          disabled: true,
          invalid: true,
          required: true,
          read_only: true,
          mask: true,
          otp: true,
          blur_on_complete: true,
          select_on_focus: true,
          name: "code",
          form: "f",
          dir: "rtl",
          orientation: "vertical",
          type: "number",
          placeholder: "○",
          on_value_change: "vc",
          on_value_change_client: "vcc",
          on_value_complete: "done",
          on_value_complete_client: "done-client"
        })

      assert result["data-controlled"] == nil
      assert result["data-default-value"] == ~S(["1","2","",""])
      assert result["data-value"] == nil
      assert result["data-orientation"] == "vertical"
      assert result["data-dir"] == "rtl"
      assert result["data-on-value-change"] == "vc"
      assert result["data-on-value-complete"] == "done"
      assert result["data-on-value-complete-client"] == "done-client"
    end

    test "controlled uses data-value" do
      result =
        Connect.props(%{
          id: "pin",
          controlled: true,
          value: ["1", "2"],
          count: 4,
          disabled: false,
          invalid: false,
          required: false,
          read_only: false,
          mask: false,
          otp: false,
          blur_on_complete: false,
          select_on_focus: false,
          name: nil,
          form: nil,
          dir: "ltr",
          orientation: "horizontal",
          type: "numeric",
          placeholder: "○",
          on_value_change: nil,
          on_value_change_client: nil,
          on_value_complete: nil,
          on_value_complete_client: nil
        })

      assert result["data-controlled"] == ""
      assert result["data-value"] == ~S(["1","2","",""])
      assert result["data-default-value"] == nil
    end

    test "form_field uses data-value and data-controlled" do
      result =
        Connect.props(%{
          id: "pin",
          form_field: true,
          value: ["1"],
          count: 4,
          disabled: false,
          invalid: false,
          required: false,
          read_only: false,
          mask: false,
          otp: false,
          blur_on_complete: false,
          select_on_focus: false,
          name: "user[code]",
          form: "user",
          dir: "ltr",
          orientation: "horizontal",
          type: "numeric",
          placeholder: "○",
          on_value_change: nil,
          on_value_change_client: nil,
          on_value_complete: nil,
          on_value_complete_client: nil
        })

      assert result["data-controlled"] == ""
      assert result["data-form-field"] == "true"
      assert result["data-value"] == ~S(["1","","",""])
      assert result["data-default-value"] == nil
    end

    test "renders on_value_complete_client on host" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input
              id="pin-complete-client"
              count={4}
              class="pin-input"
              on_value_complete_client="pin-complete"
            />
            """
          end,
          %{}
        )

      assert html =~ ~S(data-on-value-complete-client="pin-complete")
    end
  end

  describe "Connect.control/1 and hidden_input/1 and input/1" do
    test "return part attributes" do
      base = %{id: "pin", dir: "ltr", orientation: "horizontal"}

      control = Connect.control(base)
      assert control["data-part"] == "control"

      hidden =
        Connect.hidden_input(Map.merge(base, %{name: "otp", value: "12"}))

      assert hidden["type"] == "hidden"
      assert hidden["value"] == "12"

      input =
        Connect.input(Map.merge(base, %{index: 0, aria_label: "Digit 1"}))

      assert input["data-index"] == "0"
      assert input["aria-label"] == "Digit 1"
    end
  end

  describe "Connect ignore helpers" do
    test "return JS for ignore functions" do
      base = %{id: "pin", dir: "ltr", index: 0}

      for fun <- [
            &Connect.ignore_root/1,
            &Connect.ignore_label/1,
            &Connect.ignore_hidden_input/1,
            &Connect.ignore_control/1,
            &Connect.ignore_input/1
          ] do
        assert %Phoenix.LiveView.JS{} = fun.(base)
      end
    end
  end

  describe "clear/1 and clear/2" do
    test "return JS and push socket event" do
      assert %Phoenix.LiveView.JS{} = PinInput.clear("pin-1")
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = PinInput.clear(socket, "pin-1")
    end
  end

  describe "value/1 value/2 value/3" do
    test "return JS and push socket event" do
      assert %Phoenix.LiveView.JS{} = PinInput.value("pin-1")
      assert %Phoenix.LiveView.JS{} = PinInput.value("pin-1", respond_to: :client)

      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = PinInput.value(socket, "pin-1")
      assert %Phoenix.LiveView.Socket{} = PinInput.value(socket, "pin-1", respond_to: :both)
    end
  end

  describe "pin_input/1 form field" do
    test "renders from form field" do
      form = Phoenix.Component.to_form(%{"code" => "12"}, as: :user)

      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input field={@form[:code]} count={4}>
              <:label>Code</:label>
            </PinInput.pin_input>
            """
          end,
          %{form: form}
        )

      assert html =~ "Code"
      assert html =~ ~S(data-scope="pin-input")
      assert html =~ ~r/data-default-value=/
      refute html =~ ~r/data-controlled/
      refute html =~ ~S(data-value=")
    end

    test "renders error part when field has visible errors" do
      import Ecto.Changeset

      changeset =
        {%{}, %{code: :string}}
        |> cast(%{"code" => ""}, [:code])
        |> validate_required([:code])

      form = Phoenix.Component.to_form(changeset, as: :user, action: :validate)
      field = form[:code]
      assert Phoenix.Component.used_input?(field)

      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input field={@field} count={4}>
              <:label>Code</:label>
              <:error :let={msg}>{msg}</:error>
            </PinInput.pin_input>
            """
          end,
          %{field: field}
        )

      refute html =~ ~r/\bdata-invalid=""/
      assert html =~ ~S(data-part="error")
      assert html =~ "blank"
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = PinInput.set_value("pin-1", "1234")
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = PinInput.set_value(socket, "pin-1", "1234")
    end
  end
end
