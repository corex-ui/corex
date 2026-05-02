Code.require_file("mix_helper.exs", __DIR__)

defmodule Corex.New.PostGenerateTest do
  use ExUnit.Case, async: false

  import MixHelper

  alias Corex.New.PostGenerate

  describe "init_git/1" do
    test "is a no-op in a directory that's already a git repo" do
      in_tmp(:git_already, fn ->
        File.mkdir_p!(".git")
        assert :ok == (PostGenerate.init_git(File.cwd!()) || :ok)
      end)
    end
  end
end
