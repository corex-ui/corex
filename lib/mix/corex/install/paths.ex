defmodule Mix.Corex.Install.Paths do
  @moduledoc false

  def web_ex_dir(igniter, web_mod) do
    loc = Igniter.Project.Module.proper_location(igniter, web_mod)
    Path.join(Path.dirname(loc), Path.basename(loc, ".ex"))
  end
end
