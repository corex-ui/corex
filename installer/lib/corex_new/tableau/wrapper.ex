defmodule Corex.New.Tableau.Wrapper do
  @moduledoc false

  alias Corex.New.PhxWrapper

  def ensure_tableau_new! do
    case System.cmd("mix", ["help", "tableau.new"], stderr_to_stdout: true) do
      {_, 0} ->
        :ok

      {out, _} ->
        Mix.raise("""
        Tableau installer is not available. Install it with:

            mix archive.install hex tableau_new

        #{out}
        """)
    end
  end

  def build_tableau_new_argv(path) do
    [Path.basename(path), "--template", "heex", "--js", "esbuild", "--css", "tailwind"]
  end

  def tableau_new!(parent_dir, argv) when is_binary(parent_dir) and is_list(argv) do
    PhxWrapper.pty_cmd_stream!(["tableau.new" | argv], parent_dir)
  end
end
