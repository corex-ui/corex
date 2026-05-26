defmodule Corex.EditableTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Editable
  alias Corex.Editable.Connect

  describe "editable/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_editable/1, [])
      assert html =~ ~r/data-scope="editable"/
      assert html =~ ~r/data-part="root"/
    end

    test "uses default translation when not provided" do
      Application.delete_env(:phoenix, :gettext_backend)
      html = render_component(&CorexTest.ComponentHelpers.render_editable/1, [])
      assert html =~ ~r/aria-label="editable input"/
    end

    test "uses custom translation when provided" do
      translation = %Corex.Editable.Translation{input: "Custom input"}

      html =
        render_component(&CorexTest.ComponentHelpers.render_editable_with_translation/1,
          translation: translation
        )

      assert html =~ ~r/aria-label="Custom input"/
    end

    test "renders error part when errors and error slot are set" do
      html = render_component(&CorexTest.ComponentHelpers.render_editable_with_errors/1, [])
      assert html =~ ~r/data-part="error"/
      assert html =~ "blank"
    end

    test "renders form-value hidden input when name is set" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_editable/1, %{
          name: "title",
          value: "Hello"
        })

      assert html =~ ~r/id="test-editable-value"/
      assert html =~ ~r/name="title"/
      assert html =~ ~r/data-part="form-value"/
      refute html =~ ~r/data-part="input"[^>]*name=/
    end

    test "renders form-value hidden input for form field" do
      form =
        Phoenix.Component.to_form(%{"text" => "Hi"},
          as: :editable_phoenix,
          id: "editable-form-phoenix"
        )

      html =
        render_component(&CorexTest.ComponentHelpers.render_editable_with_field/1, %{
          field: form[:text]
        })

      assert html =~ ~r/id="editable-form-phoenix_text-value"/
      assert html =~ ~r/name="editable_phoenix\[text\]"/
      assert html =~ ~r/value="Hi"/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = Editable.set_value("my-editable", "Hello")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Editable.set_value(socket, "my-editable", "Hello")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-editable", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "editable:test-editable"
      assert result["data-scope"] == "editable"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.form_value/1" do
    test "returns hidden form submit attributes" do
      result =
        Connect.form_value(%Corex.Editable.Anatomy.FormValue{
          id: "my-editable",
          name: "user[title]",
          value: "Hi",
          form: nil
        })

      assert result["id"] == "my-editable-value"
      assert result["name"] == "user[title]"
      assert result["value"] == "Hi"
      assert result["type"] == "hidden"
    end
  end

  describe "Connect.area/1" do
    test "returns area attributes" do
      assigns = %{
        id: "test-editable",
        dir: "ltr",
        editing: false,
        empty: false,
        auto_resize: true
      }

      result = Connect.area(assigns)
      assert result["data-scope"] == "editable"
      assert result["data-part"] == "area"
    end
  end
end
