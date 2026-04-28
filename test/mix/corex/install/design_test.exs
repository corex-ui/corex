defmodule Mix.Corex.Install.DesignTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Design

  describe "add_design_files/2" do
    test "with --no-design: igniter unchanged, no files queued, no daisy removal scheduled" do
      igniter = Igniter.new() |> Design.add_design_files(design: false)

      assert igniter.tasks == []
      assert igniter.rewrite.sources == %{}
    end

    test "with --design: schedules creation of priv/design files (excluding design/ subtree)" do
      igniter = Igniter.new() |> Design.add_design_files(design: true)

      created_paths = Map.keys(igniter.rewrite.sources)

      assert created_paths != []

      assert Enum.all?(created_paths, &String.starts_with?(&1, "assets/corex/")),
             "expected all created paths under assets/corex/, got: #{inspect(created_paths)}"

      refute Enum.any?(created_paths, &String.starts_with?(&1, "assets/corex/design/")),
             "expected no design/ token files when --designex is off, got: #{inspect(created_paths)}"
    end

    test "with --design --designex: includes design/ subtree" do
      igniter = Igniter.new() |> Design.add_design_files(design: true, designex: true)
      created_paths = Map.keys(igniter.rewrite.sources)

      if File.dir?(Path.join([:code.priv_dir(:corex), "design", "design"])) do
        assert Enum.any?(created_paths, &String.starts_with?(&1, "assets/corex/design/")),
               "expected at least one design/ token file when --designex is on, got: #{inspect(created_paths)}"
      end

      assert Enum.all?(created_paths, &String.starts_with?(&1, "assets/corex/"))
    end
  end
end
