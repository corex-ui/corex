defmodule Corex.New.Flags do
  @moduledoc false

  @keys_igniter_only [
    :dev_corex,
    :design,
    :designex,
    :mode,
    :theme,
    :lang,
    :mcp
  ]

  @doc """
  Options intended only for `mix igniter.install corex` (and path target via `:dev_corex`).
  """
  def base_igniter_option_keys, do: @keys_igniter_only

  @doc """
  Keyword for Corex install: Igniter task flags + `:dev_corex` for package target only.
  """
  def igniter_install_opts(all_opts) when is_list(all_opts) do
    Keyword.take(all_opts, @keys_igniter_only)
  end

  @doc """
  Options for `PhxWrapper.build_phx_new_argv/2` and `build_phx_new_web_argv/2`: full CLI opts
  minus keys that only affect Igniter (so they never appear in a `phx.new` argv by accident).
  """
  def phx_new_cli_opts(all_opts) when is_list(all_opts) do
    Keyword.drop(all_opts, @keys_igniter_only)
  end
end
