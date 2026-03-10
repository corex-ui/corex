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

    inputs = Live.inputs(schema) |> Enum.reject(&is_nil/1)

    assert Enum.any?(inputs, &(&1 =~ ~s(type="text") and &1 =~ ~s(<:label>Name</:label>)))
    assert Enum.any?(inputs, &(&1 =~ "number_input" and &1 =~ ~s(<:label>Age</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ "number_input" and &1 =~ ~s(step=) and &1 =~ ~s(<:label>Price</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "checkbox" and &1 =~ ~s(<:label>Active</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="textarea") and &1 =~ ~s(<:label>Description</:label>))
           )

    assert Enum.any?(inputs, &(&1 =~ "date_picker" and &1 =~ ~s(<:label>Birthdate</:label>)))

    assert Enum.any?(
             inputs,
             &(&1 =~ ~s(type="select") and &1 =~ ~s(multiple) and &1 =~ ~s(<:label>Roles</:label>))
           )

    assert Enum.any?(
             inputs,
             &(&1 =~ "select" and &1 =~ ~s(placeholder: "Choose a value") and
                 &1 =~ ~s(<:label>Status</:label>))
           )

    # Map and references are ignored/nil
    refute Enum.any?(inputs, &(&1 =~ "Data"))
    refute Enum.any?(inputs, &(&1 =~ "User"))
  end
end
