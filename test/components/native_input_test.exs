defmodule Corex.NativeInputTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component
  import Ecto.Changeset

  defmodule UserForm do
    use Ecto.Schema

    embedded_schema do
      field(:email, :string)
    end
  end

  describe "native_input/1" do
    test "renders text input" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "text",
          id: "name",
          name: "user[name]",
          value: "John"
        )

      elements =
        find_in_html(result, ~S([data-scope="native-input"] input[type=text][name="user[name]"]))

      assert [_] = elements
      assert Floki.attribute(elements, "value") == ["John"]
    end

    test "renders textarea" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "textarea",
          name: "user[bio]",
          value: "Hello"
        )

      assert [_] = find_in_html(result, ~S(textarea[name="user[bio]"]))
    end

    test "renders checkbox" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "checkbox",
          name: "user[agree]",
          value: true
        )

      assert [_] = find_in_html(result, ~S(input[type=checkbox][name="user[agree]"]))
    end

    test "renders select with options" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "select",
          name: "user[role]",
          options: [Admin: "admin", User: "user"],
          prompt: "Choose..."
        )

      assert [_] = find_in_html(result, ~S(select[name="user[role]"]))
    end

    test "renders radio with options" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "radio",
          name: "user[size]",
          options: [Small: "s", Medium: "m", Large: "l"],
          value: "m"
        )

      assert find_in_html(result, ~S(input[type=radio][name="user[size]"])) != []
    end

    test "radio with form field uses field value for checked state" do
      form = %Phoenix.HTML.Form{id: "profile", name: "profile", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :size,
        id: "profile_size",
        name: "profile[size]",
        value: "l",
        errors: []
      }

      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input
              type="radio"
              field={@field}
              options={[Small: "s", Medium: "m", Large: "l"]}
            />
            """
          end,
          %{field: field}
        )

      assert find_in_html(result, ~S(input[type=radio][value=l][checked])) != []
      refute find_in_html(result, ~S(input[type=radio][value=m][checked])) != []
    end

    test "renders with form field" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :email,
        id: "user_email",
        name: "user[email]",
        value: "test@example.com",
        errors: []
      }

      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "email",
          field: field
        )

      assert [_] =
               find_in_html(
                 result,
                 ~S(input[type=email][name="user[email]"][value="test@example.com"])
               )
    end

    test "renders with form field with multiple true" do
      form = %Phoenix.HTML.Form{id: "user", name: "user", data: %{}, params: %{}}

      field = %Phoenix.HTML.FormField{
        form: form,
        field: :roles,
        id: "user_roles",
        name: "user[roles]",
        value: [],
        errors: []
      }

      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "select",
          multiple: true,
          field: field,
          options: ["Admin", "User"]
        )

      assert [_] = find_in_html(result, ~S(select[name="user[roles][]"]))
    end

    test "renders with icon" do
      assigns = %{}

      result =
        render_component(
          fn _assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="email" name="email">
              <:icon>Icon Content</:icon>
            </Corex.NativeInput.native_input>
            """
          end,
          assigns
        )

      assert result =~ "Icon Content"
      refute result =~ "data-no-icon"
    end

    test "renders additional input types" do
      for {type, attrs} <- [
            {"week", [type: "week", name: "w", value: "2024-W01"]},
            {"month", [type: "month", name: "m", value: "2024-01"]},
            {"time", [type: "time", name: "t", value: "12:00"]},
            {"url", [type: "url", name: "u", value: "https://x.com"]},
            {"search", [type: "search", name: "s", value: "q"]},
            {"date", [type: "date", name: "d", value: "2024-01-01"]},
            {"datetime-local", [type: "datetime-local", name: "dt", value: "2024-01-01T12:00"]},
            {"color", [type: "color", name: "c", value: "#ff0000"]},
            {"number", [type: "number", name: "n", value: "1"]},
            {"hidden", [type: "hidden", name: "h", value: "x"]},
            {"password", [type: "password", name: "p", value: "secret"]}
          ] do
        result = render_component(&Corex.NativeInput.native_input/1, attrs)
        assert find_in_html(result, ~s(input[type=#{type}])) != []
      end
    end

    test "renders errors without :error slot" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "text",
          name: "user[name]",
          errors: ["can't be blank"]
        )

      assert result =~ "can&#39;t be blank"
      assert [_] = find_in_html(result, ~S([data-part="error"]))
    end

    test "renders checkbox with label slot and invalid state" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="checkbox" name="user[agree]" invalid>
              <:label>I agree</:label>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "I agree"
      assert result =~ "data-invalid"
      assert [_] = find_in_html(result, ~S(input[type=hidden][value=false]))
    end

    test "renders checkbox errors without error slot" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "checkbox",
          name: "user[agree]",
          errors: ["must accept"]
        )

      assert result =~ "must accept"
    end

    test "renders select errors without error slot" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "select",
          name: "user[role]",
          options: [Admin: "admin"],
          errors: ["pick one"]
        )

      assert result =~ "pick one"
    end

    test "renders radio without value and errors without error slot" do
      result =
        render_component(&Corex.NativeInput.native_input/1,
          type: "radio",
          name: "user[size]",
          options: [Small: "s", Large: "l"],
          errors: ["pick size"]
        )

      assert result =~ "pick size"
      assert find_in_html(result, ~S(input[type=radio][value=s])) != []
      refute result =~ ~S(checked="checked")
    end

    test "renders checkbox with custom error slot" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="checkbox" name="user[agree]" errors={["required"]}>
              <:label>I agree</:label>
              <:error :let={msg}>Error: {msg}</:error>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "Error: required"
    end

    test "renders select with label and error slots" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input
              type="select"
              name="user[role]"
              options={[Admin: "admin"]}
              prompt="Choose"
              errors={["pick one"]}
            >
              <:label>Role</:label>
              <:error :let={msg}>{msg}</:error>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "Role"
      assert result =~ "pick one"
      assert [_] = find_in_html(result, ~S(option[value=""]))
    end

    test "renders radio with label, error slot, and invalid" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input
              type="radio"
              name="user[size]"
              options={[Small: "s", Large: "l"]}
              value="s"
              invalid
              errors={["required"]}
            >
              <:label>Size</:label>
              <:error :let={msg}>{msg}</:error>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "Size"
      assert result =~ "data-has-items"
      assert result =~ "required"
    end

    test "renders textarea with label class and error slot" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="textarea" name="user[bio]" value="Hi" invalid errors={["too short"]}>
              <:label class="label-class">Bio</:label>
              <:error :let={msg} class="err-class">{msg}</:error>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "Bio"
      assert result =~ "too short"
      assert result =~ "label-class"
      assert [_] = find_in_html(result, ~S(textarea[name="user[bio]"]))
    end

    test "renders text input with label class and tel type" do
      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="tel" name="user[phone]" value="+1">
              <:label class="phone-label">Phone</:label>
            </Corex.NativeInput.native_input>
            """
          end,
          %{}
        )

      assert result =~ "phone-label"
      assert [_] = find_in_html(result, ~S(input[type=tel]))
    end

    test "shows field errors when field is used" do
      changeset =
        %UserForm{}
        |> cast(%{"email" => ""}, [:email])
        |> validate_required([:email])

      form = to_form(changeset, as: :user, action: :validate)
      field = form[:email]
      assert Phoenix.Component.used_input?(field)

      result =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.NativeInput.native_input type="email" field={@field} class="native-input">
              <:label>Email</:label>
              <:error :let={msg}>{msg}</:error>
            </Corex.NativeInput.native_input>
            """
          end,
          %{field: field}
        )

      assert result =~ "can&#39;t be blank"
    end
  end
end
