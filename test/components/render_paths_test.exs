defmodule Corex.ComponentRenderPathsTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.{AngleSlider, Carousel, Content, Menu, PinInput, Tabs, Timer, Tree, TreeView}
  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label, Root}
  alias Corex.PinInput.Connect, as: PinConnect
  alias Corex.Timer.Anatomy.{ActionTrigger, Item, ItemLabel, Segment, Separator}
  alias Corex.Timer.Connect, as: TimerConnect

  describe "tabs compound and skeleton" do
    test "compound mode renders subcomponents" do
      items =
        Content.new([
          %{value: "a", label: "A", content: "A content"},
          %{value: "b", label: "B", content: "B content"}
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Tabs.tabs id="compound-tabs" compound :let={ctx} value="a" items={@items}>
              <Tabs.tabs_root ctx={ctx}>
                <Tabs.tabs_list ctx={ctx}>
                  <Tabs.tabs_trigger ctx={ctx} value="a">Tab A</Tabs.tabs_trigger>
                  <Tabs.tabs_trigger ctx={ctx} value="b">Tab B</Tabs.tabs_trigger>
                  <Tabs.tabs_indicator ctx={ctx} />
                </Tabs.tabs_list>
                <Tabs.tabs_content ctx={ctx} value="a">Panel A</Tabs.tabs_content>
                <Tabs.tabs_content ctx={ctx} value="b">Panel B</Tabs.tabs_content>
              </Tabs.tabs_root>
            </Tabs.tabs>
            """
          end,
          %{items: items}
        )

      assert html =~ "Tab A"
      assert html =~ "Panel A"
      assert html =~ ~s(data-part="item-indicator")
    end

    test "tabs_skeleton renders loading parts" do
      html = render_component(&Tabs.tabs_skeleton/1, count: 2)
      assert html =~ ~s(data-loading)
      assert html =~ ~s(data-part="item-trigger")
    end

    test "tabs with controlled and multiple" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Tabs.tabs
              id="ctrl-tabs"
              controlled
              value="tab-1"
              multiple
              items={@items}
            />
            """
          end,
          %{
            items:
              Content.new([
                %{value: "tab-1", label: "One", content: "1"},
                %{value: "tab-2", label: "Two", content: "2"}
              ])
          }
        )

      assert html =~ "data-controlled"
    end
  end

  describe "tree_view compound" do
    test "compound mode renders branch and item" do
      items =
        Tree.new([
          %{
            label: "Parent",
            value: "p",
            children: [%{label: "Child", value: "c"}]
          }
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <TreeView.tree_view :let={ctx} compound id="compound-tree" items={@items}>
              <TreeView.tree_view_root ctx={ctx}>
                <TreeView.tree_view_branch
                  :let={branch}
                  :for={item <- ctx.items}
                  ctx={ctx}
                  item={item}
                >
                  <TreeView.tree_view_branch_trigger branch={branch}>
                    {item.label}
                  </TreeView.tree_view_branch_trigger>
                  <TreeView.tree_view_branch_content branch={branch}>
                    <TreeView.tree_view_item
                      :for={child <- item.children || []}
                      ctx={ctx}
                      item={child}
                    >
                      {child.label}
                    </TreeView.tree_view_item>
                  </TreeView.tree_view_branch_content>
                </TreeView.tree_view_branch>
              </TreeView.tree_view_root>
            </TreeView.tree_view>
            """
          end,
          %{items: items}
        )

      assert html =~ "Parent"
      assert html =~ "Child"
    end
  end

  describe "timer connect paths" do
    test "item, segment, separator, and action_trigger attrs" do
      id = "timer-paths"

      item = TimerConnect.item(%Item{id: id, type: "seconds", value: 5, hidden: true})
      assert item["hidden"] == ""
      assert item["style"] =~ "5"

      segment = TimerConnect.segment(%Segment{id: id, type: "minutes", hidden: true})
      assert segment["hidden"] == ""

      sep = TimerConnect.separator(%Separator{id: "timer:#{id}:sep", hidden: true})
      assert sep["hidden"] == ""

      trigger =
        TimerConnect.action_trigger(%ActionTrigger{
          id: id,
          action: "start",
          hidden: true,
          orientation: "horizontal"
        })

      assert trigger["hidden"] == ""

      label = TimerConnect.item_label(%ItemLabel{id: id, type: "hours"})
      assert label["data-part"] == "item-label"

      assert %Phoenix.LiveView.JS{} = TimerConnect.ignore_item(%Item{id: id, type: "seconds"})

      assert %Phoenix.LiveView.JS{} =
               TimerConnect.ignore_segment(%Segment{id: id, type: "minutes"})

      assert %Phoenix.LiveView.JS{} =
               TimerConnect.ignore_separator(%Separator{id: "timer:#{id}:sep"})

      assert %Phoenix.LiveView.JS{} =
               TimerConnect.ignore_item_label(%ItemLabel{id: id, type: "hours"})

      assert %Phoenix.LiveView.JS{} =
               TimerConnect.ignore_action_trigger(%ActionTrigger{id: id, action: "pause"})
    end
  end

  describe "menu render paths" do
    test "renders Tree.Item entries with redirect and nested indicator" do
      items = [
        %Corex.Tree.Item{value: "edit", label: "Edit", redirect: true},
        %Corex.Tree.Item{
          value: "share",
          label: "Share",
          children: [%Corex.Tree.Item{value: "messages", label: "Messages", new_tab: true}]
        }
      ]

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="menu-items" class="menu" items={@items}>
              <:trigger>Actions</:trigger>
              <:nested_indicator>→</:nested_indicator>
            </Menu.menu>
            """
          end,
          %{items: items}
        )

      assert html =~ "Edit"
      assert html =~ "Messages"
      assert html =~ "→"
    end

    test "renders custom item slot" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu
              id="menu-slot"
              items={Corex.Tree.new([%{label: "Plain", value: "plain"}])}
            >
              <:trigger>Open</:trigger>
              <:item :let={item}>{item.label}!</:item>
            </Menu.menu>
            """
          end,
          %{}
        )

      assert html =~ "Plain!"
    end
  end

  describe "carousel render paths" do
    test "renders map slide entries" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Carousel.carousel
              id="carousel-maps"
              items={[@slide_a, @slide_b]}
              page={1}
            >
              <:prev_trigger>Prev</:prev_trigger>
              <:next_trigger>Next</:next_trigger>
            </Carousel.carousel>
            """
          end,
          %{
            slide_a: %{url: "/a.jpg", alt: "Slide A"},
            slide_b: %{"url" => "/b.jpg", "alt" => "Slide B"}
          }
        )

      assert html =~ "Slide A"
      assert html =~ "/b.jpg"
      assert html =~ ~s(data-part="indicator")
    end

    test "compound mode renders carousel subcomponents" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Carousel.carousel id="compound-carousel" compound :let={ctx} item_count={2}>
              <Carousel.carousel_root ctx={ctx}>
                <Carousel.carousel_item_group ctx={ctx}>
                  <Carousel.carousel_item ctx={ctx} index={0}>One</Carousel.carousel_item>
                  <Carousel.carousel_item ctx={ctx} index={1}>Two</Carousel.carousel_item>
                </Carousel.carousel_item_group>
                <Carousel.carousel_control ctx={ctx}>
                  <Carousel.carousel_prev_trigger ctx={ctx}>Prev</Carousel.carousel_prev_trigger>
                  <Carousel.carousel_indicator_group ctx={ctx}>
                    <Carousel.carousel_indicator ctx={ctx} index={0} />
                    <Carousel.carousel_indicator ctx={ctx} index={1} />
                  </Carousel.carousel_indicator_group>
                  <Carousel.carousel_next_trigger ctx={ctx}>Next</Carousel.carousel_next_trigger>
                </Carousel.carousel_control>
              </Carousel.carousel_root>
            </Carousel.carousel>
            """
          end,
          %{}
        )

      assert html =~ "One"
      assert html =~ ~s(data-part="indicator-group")
    end
  end

  describe "angle_slider compound" do
    test "compound mode renders root and control" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <AngleSlider.angle_slider
              id="compound-angle"
              compound
              :let={ctx}
              value={30}
              name="angle"
            >
              <AngleSlider.angle_slider_root ctx={ctx}>
                <AngleSlider.angle_slider_label ctx={ctx}>Angle</AngleSlider.angle_slider_label>
                <AngleSlider.angle_slider_control ctx={ctx}>
                  <AngleSlider.angle_slider_thumb ctx={ctx} />
                </AngleSlider.angle_slider_control>
              </AngleSlider.angle_slider_root>
            </AngleSlider.angle_slider>
            """
          end,
          %{}
        )

      assert html =~ "Angle"
      assert html =~ ~s(data-part="thumb")
    end

    test "compound mode with markers, value text, and hidden input" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <AngleSlider.angle_slider
              id="compound-angle-full"
              compound
              :let={ctx}
              value={45}
              name="angle"
              marker_values={[0, 180]}
            >
              <AngleSlider.angle_slider_root ctx={ctx}>
                <AngleSlider.angle_slider_marker_group ctx={ctx}>
                  <AngleSlider.angle_slider_marker ctx={ctx} value={0} />
                  <AngleSlider.angle_slider_marker ctx={ctx} value={180} />
                </AngleSlider.angle_slider_marker_group>
                <AngleSlider.angle_slider_value_text ctx={ctx} />
                <AngleSlider.angle_slider_hidden_input ctx={ctx} />
              </AngleSlider.angle_slider_root>
            </AngleSlider.angle_slider>
            """
          end,
          %{}
        )

      assert html =~ ~s(data-part="marker")
      assert html =~ "45"
      assert html =~ ~s(type="hidden")
    end

    test "angle_slider_skeleton renders loading markup" do
      html = render_component(&AngleSlider.angle_slider_skeleton/1, [])
      assert html =~ ~s(data-loading)
      assert html =~ ~s(data-part="marker-group")
    end
  end

  describe "angle_slider default render paths" do
    test "renders value_text slot and errors" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <AngleSlider.angle_slider
              id="angle-full"
              value={120}
              name="angle"
              marker_values={[0, 90, 180]}
              errors={["Too low"]}
              invalid
            >
              <:label>Heading</:label>
              <:value_text class="angle-value">Custom</:value_text>
              <:error :let={msg}>{msg}</:error>
            </AngleSlider.angle_slider>
            """
          end,
          %{}
        )

      assert html =~ "Heading"
      assert html =~ "Custom"
      assert html =~ "120"
      assert html =~ "Too low"
      assert html =~ ~s(data-part="marker-group")
    end
  end

  describe "timer render paths" do
    test "renders countdown timer with segments" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Timer.timer
              id="countdown"
              countdown
              start_ms={90_000}
              target_ms={0}
              segments={[:hours, :minutes, :seconds]}
            >
              <:start_trigger>Start</:start_trigger>
              <:pause_trigger>Pause</:pause_trigger>
              <:resume_trigger>Resume</:resume_trigger>
              <:reset_trigger>Reset</:reset_trigger>
            </Timer.timer>
            """
          end,
          %{}
        )

      assert html =~ ~s(data-timer-segment)
      assert html =~ ~s(data-type="hours")
      assert html =~ "Start"
    end

    test "renders separator and unit labels" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Timer.timer id="timer-labels" start_ms={3_661_000}>
              <:separator>:</:separator>
              <:hour_label>H</:hour_label>
              <:minute_label>M</:minute_label>
              <:second_label>S</:second_label>
            </Timer.timer>
            """
          end,
          %{}
        )

      assert html =~ ":"
      assert html =~ ~s(data-part="item-label")
      assert html =~ ~s(data-type="hours")
      assert html =~ ~s(data-part="separator")
    end
  end

  describe "file_upload paths" do
    test "renders full file upload helper" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_full/1, [])
      assert html =~ "Attachment"
      assert html =~ ~s(data-scope="file-upload")
    end

    test "renders file upload with form field" do
      html = render_component(&CorexTest.ComponentHelpers.render_file_upload_with_field/1, [])
      assert html =~ "Avatar"
    end
  end

  describe "pin_input render paths" do
    test "renders label, hidden input, and digit fields" do
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
              type="numeric"
              invalid
              errors={["Invalid"]}
            >
              <:label>Code</:label>
              <:error :let={msg}>{msg}</:error>
            </PinInput.pin_input>
            """
          end,
          %{}
        )

      assert html =~ "Code"
      assert html =~ "Invalid"
      assert html =~ ~s(data-part="control")
      assert html =~ ~s(autocomplete="one-time-code")
    end

    test "pin connect helpers" do
      id = "pin-connect"

      assert PinConnect.root(%Root{id: id})["data-part"] == "root"
      assert PinConnect.label(%Label{id: id})["id"] =~ "label"

      assert PinConnect.hidden_input(%HiddenInput{id: id, name: "pin", value: "1"})["value"] ==
               "1"

      assert PinConnect.control(%Control{id: id})["data-part"] == "control"
      assert PinConnect.input(%Input{id: id, index: 0, aria_label: "Digit 1"})["id"] =~ "input"

      assert %Phoenix.LiveView.JS{} = PinConnect.ignore_root(%Root{id: id})
      assert %Phoenix.LiveView.JS{} = PinConnect.ignore_label(%Label{id: id})

      assert %Phoenix.LiveView.JS{} =
               PinConnect.ignore_hidden_input(%HiddenInput{id: id, name: "pin", value: ""})

      assert %Phoenix.LiveView.JS{} = PinConnect.ignore_control(%Control{id: id})

      assert %Phoenix.LiveView.JS{} =
               PinConnect.ignore_input(%Input{id: id, index: 0, aria_label: "Digit 1"})
    end
  end
end
