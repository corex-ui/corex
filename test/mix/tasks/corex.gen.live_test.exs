defmodule Mix.Tasks.Corex.Gen.LiveTest do
  use ExUnit.Case

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
             &(&1 =~ ~S(type="select") and &1 =~ ~S(multiple) and &1 =~ ~S(<:label>Roles</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "select" and &1 =~ ~S(placeholder: "Choose a value") and
                 &1 =~ ~S(<:label>Status</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ ~S(type="text") and &1 =~ ~S(<:label>User</:label>)))

    # Map is ignored
    refute Enum.any?(inputs, &(&1 =~ "Data"))
  end
end
