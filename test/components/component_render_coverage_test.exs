defmodule Corex.ComponentRenderCoverageTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component

  alias Corex.{
    Combobox,
    DatePicker,
    NativeInput,
    PasswordInput,
    PinInput,
    Select,
    Toggle,
    Tooltip,
    Tree,
    TreeView
  }

  describe "tree_view slots and compound" do
    test "renders custom item and branch slots" do
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
            <TreeView.tree_view id="tv-slots" items={@items} expanded_value={["p"]} multiple>
              <:label class="tree-label">Files</:label>
              <:branch :let={b}><span data-branch>{b.label}</span></:branch>
              <:branch_indicator>›</:branch_indicator>
              <:item :let={item}><em data-leaf>{item.label}</em></:item>
              <:item_indicator>•</:item_indicator>
            </TreeView.tree_view>
            """
          end,
          %{items: items}
        )

      assert html =~ "Files"
      assert html =~ ~S(data-branch)
      assert html =~ ~S(data-leaf)
      assert html =~ "Child"
    end

    test "renders with animation js options" do
      items = Tree.new([%{label: "A", value: "a"}])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <TreeView.tree_view
              id="tv-anim"
              items={@items}
              animation="js"
              animation_options={%Corex.Animation.Height{duration: 0.2}}
            />
            """
          end,
          %{items: items}
        )

      assert html =~ ~S(data-animation="js")
      assert html =~ "data-anim-height-duration"
    end
  end

  describe "form controls" do
    test "native_input variants" do
      for {type, attrs} <- [
            {"hidden", [type: "hidden", name: "h", value: "v"]},
            {"number", [type: "number", name: "n", value: "2"]},
            {"color", [type: "color", name: "c", value: "#fff"]},
            {"range", [type: "range", name: "r", value: "50"]},
            {"datetime-local", [type: "datetime-local", name: "dt", value: "2020-01-01T00:00"]}
          ] do
        html = render_component(&NativeInput.native_input/1, attrs)
        assert html =~ type
      end

      error_html =
        render_component(&NativeInput.native_input/1,
          type: "text",
          name: "user[x]",
          errors: ["bad"]
        )

      assert error_html =~ "bad"
    end

    test "password_input with field and errors" do
      form = to_form(%{"password" => nil}, as: :user, errors: [password: {"too short", []}])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <PasswordInput.password_input field={@form[:password]}>
              <:label>Password</:label>
              <:visible_indicator>Show</:visible_indicator>
              <:hidden_indicator>Hide</:hidden_indicator>
              <:error :let={msg}>{msg}</:error>
            </PasswordInput.password_input>
            """
          end,
          %{form: form}
        )

      assert html =~ "too short"
    end

    test "pin_input controlled with mask" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <PinInput.pin_input
              id="pin-mask"
              controlled
              value="12"
              mask
              type="alphanumeric"
              placeholder="○"
              name="code"
              count={4}
            >
              <:label>Code</:label>
            </PinInput.pin_input>
            """
          end,
          %{}
        )

      assert html =~ "○"
      assert html =~ "controlled"
    end

    test "select grouped with field" do
      form = to_form(%{"country" => "fra"}, as: :user)

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Select.select
              field={@form[:country]}
              items={
                Corex.List.new([
                  %{value: "fra", label: "France", group: "EU"},
                  %{value: "usa", label: "USA", group: "NA"}
                ])
              }
              controlled
              value={["fra"]}
            >
              <:trigger>Country</:trigger>
              <:item :let={item}>{item.label}</:item>
            </Select.select>
            """
          end,
          %{form: form}
        )

      assert html =~ "France"
      assert html =~ ~S(data-part="item-group")
    end

    test "combobox with clear and multiple" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Combobox.combobox
              id="cb-cov"
              items={Corex.List.new([%{label: "A", value: "a"}, %{label: "B", value: "b"}])}
              multiple
              value={["a"]}
              controlled
              open
            >
              <:trigger>Pick</:trigger>
              <:clear_trigger>×</:clear_trigger>
              <:item :let={item}>{item.label}</:item>
            </Combobox.combobox>
            """
          end,
          %{}
        )

      assert html =~ "×"
      assert html =~ "×"
    end

    test "date_picker open with presets" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <DatePicker.date_picker
              id="dp-cov"
              value="2024-06-01"
              open
              controlled
              presets={["2024-01-01", "2024-12-31"]}
            />
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="date-picker")
      assert html =~ "2024"
    end

    test "toggle controlled with label" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Toggle.toggle id="tog-cov" controlled pressed aria_label="Mute">
              Mute
            </Toggle.toggle>
            """
          end,
          %{}
        )

      assert html =~ "Mute"
      assert html =~ ~S(data-scope="toggle")
    end

    test "tooltip with arrow and controlled" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Tooltip.tooltip id="tip-cov" controlled open>
              <:trigger>Hover</:trigger>
              <:content>Tip body</:content>
            </Tooltip.tooltip>
            """
          end,
          %{}
        )

      assert html =~ "Tip body"
      assert html =~ ~S(data-scope="tooltip")
    end
  end
end
