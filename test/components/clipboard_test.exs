defmodule Corex.ClipboardTest do
  use CorexTest.ComponentCase, async: true
  use Phoenix.Component

  import Corex.Clipboard

  alias Corex.Clipboard
  alias Corex.Clipboard.Connect

  defp clipboard_copy_copied_slots(assigns) do
    ~H"""
    <.clipboard id="cb-slots" value="v">
      <:copy><span id="copy-x">c</span></:copy>
      <:copied><span id="copied-x">d</span></:copied>
    </.clipboard>
    """
  end

  defp clipboard_input_false(assigns) do
    ~H"""
    <.clipboard id="cb-no-input" value="only-trigger" input={false}>
      <:copy><span>a</span></:copy>
      <:copied><span>b</span></:copied>
    </.clipboard>
    """
  end

  describe "clipboard/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_clipboard/1, [])
      assert html =~ ~r/data-scope="clipboard"/
      assert html =~ ~r/data-part="root"/
    end

    test "raises when no copy, copied, or trigger content" do
      assert_raise ArgumentError, fn ->
        render_component(&Clipboard.clipboard/1, %{
          value: "x",
          label: [],
          copy: [],
          copied: [],
          trigger: []
        })
      end
    end

    test "renders copy and copied surfaces when slots are used" do
      html = rendered_to_string(clipboard_copy_copied_slots(%{}))

      assert html =~ ~r/data-part="copy"/
      assert html =~ ~r/data-part="copied"/
      assert html =~ ~r/copy-x/
      assert html =~ ~r/copied-x/
    end

    test "omits input when input is false" do
      html = rendered_to_string(clipboard_input_false(%{}))

      refute html =~ ~r/data-part="input"/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = Clipboard.set_value("my-clipboard", "hello")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Clipboard.set_value(socket, "my-clipboard", "world")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-clipboard", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "clipboard:test-clipboard"
      assert result["data-scope"] == "clipboard"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes" do
      assigns = %{id: "test-clipboard", dir: "ltr", value: "copy-me"}
      result = Connect.input(assigns)
      assert result["id"] == "clipboard:test-clipboard:input"
      assert result["value"] == "copy-me"
    end
  end

  describe "Connect.props/1" do
    test "sets default value and omits controlled keys" do
      assigns = %Corex.Clipboard.Anatomy.Props{
        id: "x",
        value: "hello",
        timeout: nil,
        trigger_aria_label: nil,
        input_aria_label: nil,
        dir: "ltr",
        orientation: "horizontal",
        on_copy: nil,
        on_copy_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == "hello"
      refute Map.has_key?(result, "data-controlled")
      refute Map.has_key?(result, "data-value")
    end
  end

  describe "Connect.copy_part/1" do
    test "returns copy surface attributes" do
      assigns = %{id: "t", dir: "ltr", orientation: "horizontal"}
      result = Connect.copy_part(assigns)
      assert result["data-part"] == "copy"
      assert result["id"] == "clipboard:t:copy"
    end
  end

  describe "Connect.copied_part/1" do
    test "returns copied surface attributes" do
      assigns = %{id: "t", dir: "ltr", orientation: "horizontal"}
      result = Connect.copied_part(assigns)
      assert result["data-part"] == "copied"
      assert result["id"] == "clipboard:t:copied"
    end
  end
end
