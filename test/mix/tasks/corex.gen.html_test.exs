defmodule Mix.Tasks.Corex.Gen.HtmlTest do
  use ExUnit.Case, async: false

  import MixGenHelpers

  alias Mix.Corex.Gen.Inputs
  alias Mix.Phoenix.{Context, Schema}
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

    assert Enum.any?(inputs, &(&1 =~ ~S(type="text") and &1 =~ ~S(<:label>Name</:label>)))
    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ ~S(<:label>Age</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~S(step=) and &1 =~ ~S(<:label>Price</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~S(step=) and &1 =~ ~S(<:label>Amount</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "checkbox" and &1 =~ ~S(<:label>Active</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~S(type="textarea") and &1 =~ ~S(<:label>Description</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "date_picker" and &1 =~ ~S(<:label>Birthdate</:label>)))
    assert Enum.any?(inputs, &(&1 =~ ~S(type="time") and &1 =~ ~S(<:label>Started at</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~S(type="datetime-local") and &1 =~ ~S(<:label>Created at</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ ~S(type="datetime-local") and &1 =~ ~S(<:label>Updated at</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "<.select" and &1 =~ "multiple" and &1 =~ "deselectable" and
                 &1 =~ "close_on_select={false}" and &1 =~ ~S(<:label>Roles</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "select" and &1 =~ ~S(placeholder: "Choose a value") and
                 &1 =~ ~S(<:label>Status</:label>))
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

  test "files_to_be_generated/1 with web namespace" do
    schema = %Schema{
      singular: "post",
      plural: "posts",
      web_path: "admin",
      web_namespace: "Admin"
    }

    context = %Context{
      schema: schema,
      context_app: :corex
    }

    paths =
      context
      |> Html.files_to_be_generated()
      |> Enum.map(fn {_, _, path} -> path end)

    assert Enum.any?(paths, &String.contains?(&1, "controllers/admin"))
  end

  test "inputs/1 renders references as number_input" do
    schema = %Schema{
      attrs: [author_id: {:references, :authors}],
      module: MyApp.Author
    }

    inputs = Html.inputs(schema)
    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ "Author"))
    refute Enum.any?(inputs, &(&1 =~ ~S(type="text") and &1 =~ "Author"))
  end

  test "inputs/1 renders redact fields as password_input" do
    schema = %Schema{
      attrs: [secret: :string],
      redacts: [:secret],
      module: MyApp.User
    }

    inputs = Html.inputs(schema)
    assert Enum.any?(inputs, &(&1 =~ "password_input" and &1 =~ "Secret"))
  end

  test "display_expr/5 formats array fields" do
    schema = %Schema{attrs: [tags: {:array, :string}], module: MyApp.User, redacts: []}

    assert Inputs.display_expr("user", :tags, {:array, :string}, schema) =~
             "Enum.join(user.tags"

    redact_schema = %Schema{attrs: [secret: :string], redacts: [:secret], module: MyApp.User}

    assert Inputs.display_expr("@user", :secret, :string, redact_schema, :show) ==
             "\"••••••••\""
  end

  test "run/1 raises without attributes" do
    assert_raise Mix.Error, ~r/No attributes provided/, fn ->
      run_generator("corex.gen.html", ["Blog", "Empty", "empties", "--no-context"])
    end
  end

  test "run/1 generates controller and templates" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "GenWidget#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"
      paths = html_paths(tmp, singular)

      run_generator("corex.gen.html", [
        "Catalog",
        schema,
        plural,
        "label:string",
        "--no-context"
      ])

      controller = Enum.find(paths, &String.ends_with?(&1, "_controller.ex"))
      assert File.exists?(controller)
      assert File.exists?(Enum.find(paths, &String.ends_with?(&1, "index.html.heex")))
      assert File.read!(controller) =~ "Catalog"
    end)
  end

  test "run/1 with layout locale and theme opts prints locale routes" do
    prev_generators = Application.get_env(:corex, :generators)
    prev_themes = Application.get_env(:corex, :themes)

    on_exit(fn ->
      restore_env(:corex, :generators, prev_generators)
      restore_env(:corex, :themes, prev_themes)
    end)

    Application.put_env(:corex, :generators, layout: [locale: true, theme: true])
    Application.put_env(:corex, :themes, ["neo", "uno"])

    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "GenLocale#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"

      output =
        run_generator(
          "corex.gen.html",
          ["Blog", schema, plural, "title:string", "--no-context"],
          loud: true
        )

      assert output =~ "/:locale"
      assert File.exists?(Path.join([tmp, "web/controllers", "#{singular}_controller.ex"]))
    end)
  end

  test "run/1 with admin web namespace prints scoped routes" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "GenReport#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"
      paths = html_paths(tmp, singular, "admin")

      output =
        run_generator(
          "corex.gen.html",
          [
            "Reports",
            schema,
            plural,
            "title:string",
            "--web",
            "admin",
            "--no-context"
          ],
          loud: true
        )

      assert output =~ "scope \"/admin\""
      assert Enum.any?(paths, &File.exists?/1)
    end)
  end

  defp restore_env(app, key, prev) do
    case prev do
      nil -> Application.delete_env(app, key)
      val -> Application.put_env(app, key, val)
    end
  end

  defp html_paths(tmp, singular, web_path \\ nil) do
    controller_root =
      if web_path do
        Path.join([tmp, "web/controllers", web_path])
      else
        Path.join([tmp, "web/controllers"])
      end

    html_dir =
      if web_path do
        Path.join([controller_root, "#{singular}_html"])
      else
        Path.join([controller_root, "#{singular}_html"])
      end

    test_root =
      if web_path do
        Path.join([tmp, "test/controllers", web_path])
      else
        Path.join([tmp, "test/controllers"])
      end

    [
      Path.join(controller_root, "#{singular}_controller.ex"),
      Path.join(controller_root, "#{singular}_html.ex"),
      Path.join(html_dir, "index.html.heex"),
      Path.join(html_dir, "show.html.heex"),
      Path.join(test_root, "#{singular}_controller_test.exs")
    ]
  end
end
