defmodule Mix.Tasks.Corex.Gen.LiveTest do
  use ExUnit.Case, async: false

  import MixGenHelpers

  alias Mix.Phoenix.Schema
  alias Mix.Tasks.Corex.Gen.Live

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
        user_id: {:references, :users},
        data: :map
      ],
      module: MyApp.StatusEnum
    }

    inputs = Live.inputs(schema)

    assert Enum.any?(inputs, &(&1 =~ ~S(type="text") and &1 =~ ~S(<:label>Name</:label>)))
    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ ~S(<:label>Age</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~S(step=) and &1 =~ ~S(<:label>Price</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "checkbox" and &1 =~ ~S(<:label>Active</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~S(type="textarea") and &1 =~ ~S(<:label>Description</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "date_picker" and &1 =~ ~S(<:label>Birthdate</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ "<.select" and &1 =~ "multiple" and &1 =~ "deselectable" and
                 &1 =~ ~S(<:label>Roles</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "select" and &1 =~ ~S(placeholder: "Choose a value") and
                 &1 =~ ~S(<:label>Status</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ ~S(<:label>User</:label>)))
    refute Enum.any?(inputs, &(&1 =~ ~S(type="text") and &1 =~ ~S(<:label>User</:label>)))

    refute Enum.any?(inputs, &(&1 =~ "Data"))
  end

  test "run/1 raises without attributes" do
    assert_raise Mix.Error, ~r/No attributes provided/, fn ->
      run_generator("corex.gen.live", ["Live", "Empty", "empties", "--no-context"])
    end
  end

  test "run/1 rejects form as schema name" do
    assert_raise Mix.Error, ~r/cannot use form as the schema name/, fn ->
      run_generator("corex.gen.live", ["Shop", "Form", "forms", "name:string", "--no-context"])
    end
  end

  test "run/1 with web namespace generates namespaced live views" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "GenEntry#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"
      paths = live_paths(tmp, singular, "admin")

      output =
        run_generator(
          "corex.gen.live",
          [
            "Ledger",
            schema,
            plural,
            "label:string",
            "--web",
            "admin",
            "--no-context"
          ],
          loud: true
        )

      assert output =~ "scope \"/admin\""
      assert File.exists?(List.first(paths))
    end)
  end

  test "run/1 generates live views" do
    with_test_output(fn tmp ->
      n = System.unique_integer([:positive])
      schema = "GenNote#{n}"
      singular = Phoenix.Naming.underscore(schema)
      plural = singular <> "s"

      run_generator("corex.gen.live", [
        "Notes",
        schema,
        plural,
        "body:string",
        "--no-context"
      ])

      live_dir = Path.join([tmp, "web/live", "#{singular}_live"])
      assert File.exists?(Path.join(live_dir, "index.ex"))
      assert File.exists?(Path.join(live_dir, "show.ex"))
      assert File.exists?(Path.join(live_dir, "form.ex"))
      assert File.read!(Path.join(live_dir, "index.ex")) =~ "data_table"
      assert File.read!(Path.join(live_dir, "form.ex")) =~ "native_input"
    end)
  end

  defp live_paths(tmp, singular, web_path) do
    live_dir =
      if web_path do
        Path.join([tmp, "web/live", web_path, "#{singular}_live"])
      else
        Path.join([tmp, "web/live", "#{singular}_live"])
      end

    test_file =
      if web_path do
        Path.join([tmp, "test/live", web_path, "#{singular}_live_test.exs"])
      else
        Path.join([tmp, "test", "#{singular}_live_test.exs"])
      end

    [
      Path.join(live_dir, "index.ex"),
      Path.join(live_dir, "show.ex"),
      Path.join(live_dir, "form.ex"),
      test_file
    ]
  end
end
