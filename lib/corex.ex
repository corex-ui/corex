defmodule Corex do
  @moduledoc false

  @components %{
    accordion:
      {Corex.Accordion,
       [
         accordion: 1,
         accordion_trigger: 1,
         accordion_content: 1,
         accordion_skeleton: 1
       ]},
    combobox: {Corex.Combobox, [combobox: 1]},
    switch: {Corex.Switch, [switch: 1]},
    toggle_group: {Corex.ToggleGroup, [toggle_group: 1]},
    toast:
      {Corex.Toast,
       [
         toast_group: 1,
         toast_client_error: 1,
         toast_server_error: 1,
         toast_connected: 1,
         toast_disconnected: 1
       ]},
    form: {Corex.Form, [get_form_id: 1]},
    select: {Corex.Select, [select: 1]},
    checkbox: {Corex.Checkbox, [checkbox: 1]}
  }

  defmacro __using__(opts \\ []) do
    only = Keyword.get(opts, :only, :all)
    except = Keyword.get(opts, :except, [])
    prefix = Keyword.get(opts, :prefix)

    # Filter components based on only/except
    selected_components =
      @components
      |> Enum.filter(fn {component_name, _} ->
        include?(component_name, only, except)
      end)

    if prefix do
      # Generate wrapper functions with prefix
      wrappers =
        for {_component_name, {mod, functions}} <- selected_components,
            {func_name, arity} <- functions do
          prefixed_name = :"#{prefix}_#{func_name}"

          # Generate the appropriate number of arguments
          args = Macro.generate_arguments(arity, __MODULE__)

          quote do
            defdelegate unquote(prefixed_name)(unquote_splicing(args)),
              to: unquote(mod),
              as: unquote(func_name)
          end
        end

      # Generate aliases
      aliases =
        for {_component_name, {mod, _functions}} <- selected_components do
          quote do
            alias unquote(mod)
          end
        end

      quote do
        unquote_splicing(wrappers)
        unquote_splicing(aliases)
      end
    else
      # Normal import without prefix
      imports =
        for {_component_name, {mod, functions}} <- selected_components do
          quote do
            import unquote(mod), only: unquote(functions)
          end
        end

      aliases =
        for {_component_name, {mod, _functions}} <- selected_components do
          quote do
            alias unquote(mod)
          end
        end

      quote do
        unquote_splicing(imports)
        unquote_splicing(aliases)
      end
    end
  end

  defp include?(_name, :all, []), do: true
  defp include?(name, :all, except), do: name not in except
  defp include?(name, only, _except) when is_list(only), do: name in only
end
