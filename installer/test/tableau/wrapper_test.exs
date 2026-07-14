defmodule Corex.New.Tableau.WrapperTest do
  use ExUnit.Case, async: true

  alias Corex.New.Tableau.Wrapper

  test "build_tableau_new_argv uses basename and correct flags" do
    argv = Wrapper.build_tableau_new_argv("/tmp/my_blog")
    assert argv == ["my_blog", "--template", "heex", "--js", "esbuild", "--css", "tailwind"]

    argv_rel = Wrapper.build_tableau_new_argv("sites/my_blog")
    assert argv_rel == ["my_blog", "--template", "heex", "--js", "esbuild", "--css", "tailwind"]
  end
end
