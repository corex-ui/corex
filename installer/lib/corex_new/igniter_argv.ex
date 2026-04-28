defmodule Corex.New.IgniterArgv do
  @moduledoc false

  @group "corex"

  @doc """
  Maps keyword options to argv for the Corex part of `mix igniter.install corex …`.
  `Mix.Tasks.Corex.Install` uses `group: :corex`, so disambiguated flags are `--corex.…` (see `Igniter.Util.Info`).

  These are appended to the `mix igniter.install corex …` invocation.
  """
  def to_argv(keyword) when is_list(keyword) do
    p = &"--#{@group}.#{&1}"

    keyword
    |> Enum.flat_map(fn
      {:design, true} -> []
      {:design, false} -> [p.("no-design")]
      {:designex, true} -> [p.("designex")]
      {:designex, false} -> []
      {:replace, true} -> [p.("replace")]
      {:replace, false} -> []
      {:mode, true} -> [p.("mode")]
      {:mode, false} -> []
      {:theme, true} -> [p.("theme")]
      {:theme, false} -> []
      {:lang, true} -> [p.("lang")]
      {:lang, false} -> []
      {:mcp, false} -> [p.("no-mcp")]
      {:mcp, true} -> []
      {:dev_corex, _} -> []
      _ -> []
    end)
  end
end
