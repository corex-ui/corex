defmodule Test.Support.ConnectProps do
  @moduledoc false

  def default_select(overrides \\ %{}) do
    Map.merge(
      %{
        id: "test-select",
        items: [%{id: "a", label: "A"}],
        invalid: false,
        read_only: false,
        disabled: false,
        name: nil,
        placeholder: nil,
        close_on_select: true,
        loop_focus: false,
        multiple: false,
        form: nil,
        required: false,
        value: [],
        controlled: false,
        dir: "ltr",
        positioning: nil,
        on_value_change: nil,
        on_value_change_client: nil,
        redirect: false,
        deselectable: false
      },
      Map.new(overrides)
    )
  end

  def default_combobox(overrides \\ %{}) do
    Map.merge(
      %{
        id: "test",
        items: [%{id: "a", label: "A"}],
        value: [],
        dir: "ltr",
        controlled: false,
        invalid: false,
        read_only: false,
        disabled: false,
        name: nil,
        placeholder: nil,
        always_submit_on_enter: false,
        auto_focus: false,
        close_on_select: false,
        input_behavior: "autohighlight",
        loop_focus: false,
        multiple: false,
        form: nil,
        required: false,
        positioning: nil,
        on_open_change: nil,
        on_open_change_client: nil,
        on_input_value_change: nil,
        on_value_change: nil,
        on_value_change_client: nil,
        filter: true,
        redirect: false
      },
      Map.new(overrides)
    )
  end
end
