defmodule Corex.Item do
  @moduledoc false

  @shared_fields [:value, :label, :disabled, :meta]
  @navigation_fields [:to, :redirect, :new_tab, :group]

  @doc """
  The fields every item struct carries.
  """
  @spec shared_fields() :: [atom()]
  def shared_fields, do: @shared_fields

  @doc """
  The fields carried by the item structs that support redirect-on-select.
  """
  @spec navigation_fields() :: [atom()]
  def navigation_fields, do: @navigation_fields

  @doc """
  Generates a unique `:value` for an item that was built without one.
  """
  @spec generate_value(String.t()) :: String.t()
  def generate_value(prefix) when is_binary(prefix) do
    "#{prefix}-#{System.unique_integer([:positive])}"
  end

  @doc """
  Asserts that a component's `:items` assign holds structs of `module`.

  Returns `assigns` unchanged so it can sit in an assign pipeline. Options:

  - `:component` (required) - name used in the error message
  - `:required` - when true, a `nil` `:items` raises instead of passing through
  - `:example` (required) - the `Corex.*.new/1` snippet shown in the error
  """
  @spec assert_items!(map(), module(), keyword()) :: map()
  def assert_items!(assigns, module, opts) when is_atom(module) and is_list(opts) do
    component = Keyword.fetch!(opts, :component)
    example = Keyword.fetch!(opts, :example)

    case assigns do
      %{items: nil} ->
        if Keyword.get(opts, :required, false) do
          raise ArgumentError, required_message(component, module, example)
        else
          assigns
        end

      %{items: items} when is_list(items) ->
        Enum.each(items, &assert_item!(&1, module, example))
        assigns

      %{items: items} ->
        raise ArgumentError, not_a_list_message(component, module, items, example)

      assigns ->
        assigns
    end
  end

  defp assert_item!(item, module, example) do
    if is_struct(item, module) do
      :ok
    else
      raise ArgumentError, """
      Invalid item in :items. Expected #{struct_name(module)} struct, got: #{inspect(item)}

      #{builder_hint(module)}
      #{example}
      """
    end
  end

  defp required_message(component, module, example) do
    """
    #{component} requires :items to be a list of #{struct_name(module)} structs.

    Example:
    #{example}
    """
  end

  defp not_a_list_message(component, module, items, example) do
    """
    #{component} :items must be a list of #{struct_name(module)} structs, got: #{inspect(items)}

    #{builder_hint(module)}
    #{example}
    """
  end

  defp struct_name(module), do: "%#{inspect(module)}{}"

  defp builder_hint(module) do
    builder = module |> Module.split() |> Enum.drop(-1) |> Enum.join(".")
    "Please use #{builder}.new/1:"
  end
end
