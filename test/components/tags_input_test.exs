defmodule Corex.TagsInputTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Corex.Heroicon
  import Corex.TagsInput

  alias Corex.TagsInput

  describe "tags_input/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_tags_input/1, [])
      assert html =~ ~r/data-scope="tags-input"/
      assert html =~ ~r/phx-hook="TagsInput"/
      assert html =~ ~r/data-templates="tags-input"/
      refute html =~ "data-tags-items-mount"
      assert html =~ ~r/data-part="control"[^>]*>[\s\n]*<span[^>]*data-part="item"/
      assert html =~ "alpha"
      assert html =~ "beta"
    end

    test "renders default placeholder on main input from SSR" do
      html = render_component(&CorexTest.ComponentHelpers.render_tags_input/1, [])
      assert html =~ "data-translation="
      assert html =~ "deleteTagTriggerLabel"
      assert html =~ "tagEdited"
      refute html =~ "data-placeholder="
      assert html =~ ~r/data-part="input"/
      assert html =~ "placeholder="
      assert html =~ "Add a tag"
      assert html =~ ~S(aria-label="Delete tag alpha")
    end

    test "translation attr merges placeholder" do
      assigns =
        assign(%{__changed__: %{}},
          id: "ti",
          value: [],
          translation: %Corex.TagsInput.Translation{placeholder: "Pick tags"}
        )

      html =
        rendered_to_string(~H"""
        <.tags_input id={@id} value={@value} translation={@translation}>
          <:close><.heroicon name="hero-x-mark" /></:close>
        </.tags_input>
        """)

      assert html =~ "Pick tags"
    end

    test "scalar placeholder overrides merged translation" do
      assigns =
        assign(%{__changed__: %{}},
          id: "ti",
          value: [],
          translation: %Corex.TagsInput.Translation{placeholder: "From translation"},
          placeholder: "From attr"
        )

      html =
        rendered_to_string(~H"""
        <.tags_input id={@id} value={@value} translation={@translation} placeholder={@placeholder}>
          <:close><.heroicon name="hero-x-mark" /></:close>
        </.tags_input>
        """)

      assert html =~ "From attr"
      refute html =~ "From translation"
    end

    test "encodes tags as JSON on data-default-tags when uncontrolled" do
      assigns = assign(%{__changed__: %{}}, id: "ti", value: ["a,b", "c"])

      html =
        rendered_to_string(~H"""
        <.tags_input id={@id} value={@value}>
          <:close><.heroicon name="hero-x-mark" /></:close>
        </.tags_input>
        """)

      assert html =~ "data-default-tags"
      assert html =~ "&quot;a,b&quot;"
      assert html =~ "&quot;c&quot;"
    end

    test "controlled uses data-tags" do
      assigns = assign(%{__changed__: %{}}, id: "ti", controlled: true, value: ["x"])

      html =
        rendered_to_string(~H"""
        <.tags_input id={@id} controlled={@controlled} value={@value}>
          <:close><.heroicon name="hero-x-mark" /></:close>
        </.tags_input>
        """)

      assert html =~ ~r/data-controlled/
      assert html =~ "data-tags"
      assert html =~ "&quot;x&quot;"
    end

    test "renders hidden input when name is set" do
      assigns = assign(%{__changed__: %{}}, id: "ti", value: [], name: "kw")

      html =
        rendered_to_string(~H"""
        <.tags_input id={@id} value={@value} name={@name}>
          <:close><.heroicon name="hero-x-mark" /></:close>
        </.tags_input>
        """)

      assert html =~ ~r/name="kw"/
      assert html =~ ~r/data-part="value-input"/
      assert html =~ ~r/data-part="value-input"[^>]*type="text"/
      assert html =~ ~r/data-part="value-input"[^>]*hidden="true"/
      assert html =~ ~r/data-part="hidden-input"/
    end
  end

  describe "tags_input/1 field" do
    test "shows error slot when field is used and has errors" do
      import Ecto.Changeset

      cs =
        {%{}, %{tags: :string}}
        |> cast(%{"tags" => ""}, [:tags])
        |> validate_required([:tags])
        |> Map.put(:action, :insert)

      form = to_form(cs, as: :ex, id: "tf")
      assigns = assign(%{__changed__: %{}}, form: form)

      html =
        rendered_to_string(~H"""
        <.tags_input field={@form[:tags]} class="tags-input">
          <:close><.heroicon name="hero-x-mark" /></:close>
          <:error :let={msg}>
            <span data-test="err">{msg}</span>
          </:error>
        </.tags_input>
        """)

      assert html =~ ~r/data-part="error"/
      assert html =~ "data-test=\"err\""
    end

    test "hides errors when field is not used" do
      import Ecto.Changeset

      cs =
        {%{}, %{tags: :string}}
        |> cast(%{}, [:tags])
        |> validate_required([:tags])
        |> Map.put(:action, :validate)

      form = to_form(cs, as: :ex, id: "tf")
      assigns = assign(%{__changed__: %{}}, form: form)

      html =
        rendered_to_string(~H"""
        <.tags_input field={@form[:tags]} class="tags-input">
          <:close><.heroicon name="hero-x-mark" /></:close>
          <:error :let={msg}>
            <span data-test="err">{msg}</span>
          </:error>
        </.tags_input>
        """)

      refute html =~ "data-test=\"err\""
    end

    test "hidden form input ignores LiveView patches to value and uses text type for used_input tracking" do
      form = to_form(%{"tags" => "alpha,beta"}, as: :user, id: "user")
      assigns = %{field: form[:tags]}

      html =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.TagsInput.tags_input field={@field}>
              <:close><.heroicon name="hero-x-mark" /></:close>
            </Corex.TagsInput.tags_input>
            """
          end,
          assigns
        )

      assert html =~
               ~r/<input\b(?=[^>]*\btype="text")(?=[^>]*\bname="user\[tags\]")(?=[^>]*\bvalue="alpha,beta")[^>]*\bdata-part="value-input"/

      assert html =~
               ~r/<input\b(?=[^>]*\bdata-part="value-input")[^>]*\bphx-mounted="[^"]*ignore_attrs[^"]*value/
    end
  end

  describe "set_value/2" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = TagsInput.set_value("tid", ["a"])
    end
  end

  describe "set_value/3" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = TagsInput.set_value(socket, "tid", ["a"])
    end
  end

  describe "clear_value/1" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = TagsInput.clear_value("tid")
    end
  end

  describe "clear_value/2" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = TagsInput.clear_value(socket, "tid")
    end
  end

  describe "add_value/2" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = TagsInput.add_value("tid", "lorem")
    end
  end

  describe "add_value/3" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = TagsInput.add_value(socket, "tid", "lorem")
    end
  end

  describe "remove_value/2" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} = TagsInput.remove_value("tid", "lorem")
    end
  end

  describe "remove_value/3" do
    test "pushes event" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = TagsInput.remove_value(socket, "tid", "lorem")
    end
  end
end
