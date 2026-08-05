defmodule E2eWeb.FlagpackHelpers do
  @moduledoc false

  @doc """
  Converts a country value to a Flagpack flag atom.

  Ensures Flagpack is loaded first so alpha-3 atoms like `:fra` exist before
  `String.to_existing_atom/1` runs.
  """
  def flag_name(value) do
    Code.ensure_loaded!(Flagpack)
    String.to_existing_atom(to_string(value))
  end
end
