defmodule Corex.TooltipTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Tooltip, only: [tooltip: 1]

  alias Corex.Tooltip.Anatomy.Props
  alias Corex.Tooltip.Connect

  describe "tooltip/1" do
    test "renders trigger and content" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-unit">
              <:trigger><span>Hover</span></:trigger>
              <:content><span>Details</span></:content>
            </.tooltip>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="tooltip")
      assert html =~ ~S(id="tooltip:tip-unit:popper")
      assert html =~ "Hover"
      assert html =~ "Details"
      assert html =~ ~S(data-part="arrow")
    end

    test "omits arrow when show_arrow is false" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-no-arrow" show_arrow={false}>
              <:trigger>T</:trigger>
              <:content>C</:content>
            </.tooltip>
            """
          end,
          %{}
        )

      refute html =~ ~S(data-part="arrow")
    end

    test "renders multiple triggers with distinct ids and data-value" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-multi" show_arrow={false}>
              <:trigger value="x">A</:trigger>
              <:trigger value="y">B</:trigger>
              <:content>Shared</:content>
            </.tooltip>
            """
          end,
          %{}
        )

      assert html =~ ~S(id="tooltip:tip-multi:trigger:x")
      assert html =~ ~S(id="tooltip:tip-multi:trigger:y")
      assert html =~ ~S(data-value="x")
      assert html =~ ~S(data-value="y")
      assert html =~ "Shared"
    end

    test "raises when multiple triggers omit value" do
      assert_raise ArgumentError, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-bad" show_arrow={false}>
              <:trigger>A</:trigger>
              <:trigger>B</:trigger>
              <:content>C</:content>
            </.tooltip>
            """
          end,
          %{}
        )
      end
    end

    test "renders span trigger and controlled open" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-span" controlled open={true} trigger_tag={:span}>
              <:trigger><span>Hover</span></:trigger>
              <:content><span>Open</span></:content>
            </.tooltip>
            """
          end,
          %{}
        )

      assert html =~ "<span"
      refute html =~ ~S(<button type="button")
    end

    test "raises when multiple triggers reuse value" do
      assert_raise ArgumentError, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-dup" show_arrow={false}>
              <:trigger value="same">A</:trigger>
              <:trigger value="same">B</:trigger>
              <:content>C</:content>
            </.tooltip>
            """
          end,
          %{}
        )
      end
    end
  end

  describe "Connect.trigger_id/2" do
    test "nil value uses single-trigger id suffix" do
      assert Connect.trigger_id("t1", nil) == "tooltip:t1:trigger"
    end

    test "value appends to id" do
      assert Connect.trigger_id("t1", "v") == "tooltip:t1:trigger:v"
    end
  end

  describe "Connect.props/1" do
    test "maps props to data attributes" do
      m =
        Connect.props(%Props{
          id: "id1",
          positioning: %Corex.Positioning{placement: "top-start"},
          on_open_change: "evt"
        })

      assert m["id"] == "id1"
      assert m["data-position-placement"] == "top-start"
      assert m["data-on-open-change"] == "evt"
    end

    test "maps on_trigger_value_change to data attribute" do
      m =
        Connect.props(%Props{
          id: "id1",
          positioning: %Corex.Positioning{},
          on_trigger_value_change: "tooltip_trigger"
        })

      assert m["data-on-trigger-value-change"] == "tooltip_trigger"
    end

    test "maps on_trigger_value_change_client to data attribute" do
      m =
        Connect.props(%Props{
          id: "id1",
          positioning: %Corex.Positioning{},
          on_trigger_value_change_client: "tooltip_trigger_client"
        })

      assert m["data-on-trigger-value-change-client"] == "tooltip_trigger_client"
    end

    test "maps delays and close flags" do
      m =
        Connect.props(%Props{
          id: "id1",
          positioning: %Corex.Positioning{},
          open_delay: 100,
          close_delay: 50,
          close_on_escape: false,
          close_on_click: true,
          close_on_pointer_down: true,
          close_on_scroll: false,
          interactive: true,
          disabled: true,
          dir: "rtl"
        })

      assert m["data-open-delay"] == 100
      assert m["data-close-delay"] == 50
      assert m["data-close-on-escape"] == nil
      assert m["data-interactive"] == ""
      assert m["data-dir"] == "rtl"
    end
  end

  describe "Connect.trigger/1" do
    test "span trigger omits type button" do
      t = Connect.trigger(%{id: "t", open: true, disabled: false, dir: "ltr", tag: :span})
      refute Map.has_key?(t, "type")
      assert t["data-state"] == "open"
    end

    test "button trigger includes type and disabled tabindex" do
      t = Connect.trigger(%{id: "t", open: false, disabled: true, dir: "ltr", tag: :button})
      assert t["type"] == "button"
      assert t["tabindex"] == -1
      assert t["data-value"] == nil
    end

    test "includes data-value when set" do
      t = Connect.trigger(%{id: "t", open: true, disabled: false, value: "x"})
      assert t["data-value"] == "x"
    end

    test "focusable false sets tabindex -1" do
      t =
        Connect.trigger(%{
          id: "t",
          open: false,
          disabled: false,
          focusable: false,
          dir: "ltr",
          tag: :button
        })

      assert t["tabindex"] == -1
    end

    test "explicit tabindex overrides focusable" do
      t =
        Connect.trigger(%{
          id: "t",
          open: false,
          disabled: false,
          focusable: true,
          tabindex: -1,
          dir: "ltr",
          tag: :button
        })

      assert t["tabindex"] == -1
    end

    test "disabled wins over focusable" do
      t =
        Connect.trigger(%{
          id: "t",
          open: false,
          disabled: true,
          focusable: true,
          tabindex: 0,
          dir: "ltr",
          tag: :button
        })

      assert t["tabindex"] == -1
    end
  end

  describe "Connect ignore and part helpers" do
    test "return attrs and ignore JS" do
      base = %{id: "t", dir: "ltr", open: true, disabled: false, orientation: "vertical"}

      assert Connect.positioner(base)["id"] == "tooltip:t:popper"
      assert Connect.content(base)["data-part"] == "content"
      assert Connect.arrow(base)["data-part"] == "arrow"
      assert Connect.arrow_tip(base)["data-part"] == "arrow-tip"

      for fun <- [
            &Connect.ignore_trigger/1,
            &Connect.ignore_positioner/1,
            &Connect.ignore_content/1,
            &Connect.ignore_arrow/1,
            &Connect.ignore_arrow_tip/1
          ] do
        assert %Phoenix.LiveView.JS{} = fun.(Map.put(base, :value, nil))
      end
    end
  end

  describe "set_open/2 and set_open/3" do
    test "returns JS for client toggle" do
      assert %Phoenix.LiveView.JS{} = Corex.Tooltip.set_open("tip-x", true)
    end

    test "pushes server event on socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Corex.Tooltip.set_open(socket, "tip-x", false)
    end
  end
end
