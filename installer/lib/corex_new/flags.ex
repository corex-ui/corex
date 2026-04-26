defmodule Corex.New.Flags do
  @moduledoc false

  @keys_igniter_only [
    :dev_corex,
    :design,
    :designex,
    :no_design,
    :mode,
    :theme,
    :lang,
    :mcp,
    :replace,
    :no_replace
  ]

  @doc """
  Options intended only for `mix igniter.install corex` (and path target via `:dev_corex`).
  Excludes nothing that `mix phx.new` / `phx.new.web` need (e.g. `:skills` is merged in separately).
  """
  def base_igniter_option_keys, do: @keys_igniter_only

  @doc """
  Keyword for Corex install: Igniter task flags + `:dev_corex` for package target only.
  `:replace` defaults to true; `:no_replace` sets `:replace` false.
  `:skills` is added here because it maps to both `igniter.install` **`--no-skills`** and, for `corex.new`, `phx.new` **`--no-agents-md`**.
  """
  def igniter_install_opts(all_opts) when is_list(all_opts) do
    for_install =
      all_opts
      |> Keyword.take(@keys_igniter_only ++ [:skills])
      |> Keyword.put_new(:replace, true)

    if all_opts[:no_replace] == true do
      Keyword.put(for_install, :replace, false)
    else
      for_install
    end
  end

  @doc """
  Options for `PhxWrapper.build_phx_new_argv/2` and `build_phx_new_web_argv/2`: full CLI opts
  minus keys that only affect Igniter (so they never appear in a `phx.new` argv by accident).

  Keeps `:skills` so `phx_new_content_flags/1` can still emit `--no-agents-md` when `skills: false`.
  """
  def phx_new_cli_opts(all_opts) when is_list(all_opts) do
    Keyword.drop(all_opts, @keys_igniter_only)
  end
end
