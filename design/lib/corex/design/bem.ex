defmodule Corex.Design.Bem do
  @moduledoc false

  alias Corex.Bem
  alias Corex.Design.Selector

  defdelegate step(axis, value), to: Bem
  defdelegate axis_name(axis), to: Bem
  defdelegate modifier_class(base, axis, value), to: Bem

  def host_selector(id, axis, value) when is_atom(id) and is_atom(axis) do
    name = Selector.class_name(id)
    ".#{name}.#{name}--#{Bem.step(axis, value)}"
  end
end
