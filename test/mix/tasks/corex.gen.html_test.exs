defmodule Mix.Tasks.Corex.Gen.HtmlTest do
  use ExUnit.Case

  alias Mix.Phoenix.Schema
  alias Mix.Tasks.Corex.Gen.Html

  test "inputs/1 generates proper native_input blocks" do
    schema = %Schema{
      attrs: [
        name: :string,
        age: :integer,
        price: :float,
        amount: :decimal,
        active: :boolean,
        description: :text,
        birthdate: :date,
        started_at: :time,
        created_at: :utc_datetime,
        updated_at: :naive_datetime,
        roles: {:array, :string},
        status: {:enum, [:open, :closed]},
        data: :map
      ],
      module: MyApp.StatusEnum
    }

    inputs = Html.inputs(schema)

    assert Enum.any?(inputs, &(&1 =~ ~s(type="text") and &1 =~ ~s(<:label>Name</:label>)))
    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ ~s(<:label>Age</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~s(step=) and &1 =~ ~s(<:label>Price</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~s(step=) and &1 =~ ~s(<:label>Amount</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "checkbox" and &1 =~ ~s(<:label>Active</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="textarea") and &1 =~ ~s(<:label>Description</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "date_picker" and &1 =~ ~s(<:label>Birthdate</:label>)))
    assert Enum.any?(inputs, &(&1 =~ ~s(type="time") and &1 =~ ~s(<:label>Started at</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="datetime-local") and &1 =~ ~s(<:label>Created at</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="datetime-local") and &1 =~ ~s(<:label>Updated at</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="select") and &1 =~ ~s(multiple) and &1 =~ ~s(<:label>Roles</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "select" and &1 =~ ~s(placeholder: "Choose a value") and
                 &1 =~ ~s(<:label>Status</:label>))
           )

    # Map is ignored
    refute Enum.any?(inputs, &(&1 =~ "Data"))
  end

  test "indent_inputs/2 indents blocks" do
    inputs = ["<.native_input>\n  <:label>Name</:label>\n</.native_input>"]
    indented = Html.indent_inputs(inputs, 4)

    assert indented == [
             [
               "    ",
               "<.native_input>",
               "\n",
               "      <:label>Name</:label>\n    </.native_input>"
             ]
           ]
  end

  test "files_to_be_generated/1" do
    schema = %Schema{
      singular: "user",
      plural: "users",
      web_path: "user"
    }

    context = %Mix.Phoenix.Context{
      schema: schema,
      context_app: :my_app,
      generate?: true
    }

    files = Html.files_to_be_generated(context)

    paths = Enum.map(files, fn {_type, _name, path} -> path end)
    assert Enum.any?(paths, &String.ends_with?(&1, "user_controller.ex"))
    assert Enum.any?(paths, &String.ends_with?(&1, "user_html.ex"))
    assert Enum.any?(paths, &String.ends_with?(&1, "index.html.heex"))
  end
end
