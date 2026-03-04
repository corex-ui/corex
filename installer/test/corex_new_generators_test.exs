Code.require_file("mix_helper.exs", __DIR__)

defmodule Corex.New.ProjectTest do
  use ExUnit.Case, async: true

  test "Project predicates return binding values" do
    project = %Corex.New.Project{
      binding: [
        ecto: true,
        html: true,
        gettext: true,
        live: true,
        dashboard: false,
        javascript: true,
        css: true,
        mailer: true
      ],
      opts: [verbose: true]
    }

    assert Corex.New.Project.ecto?(project) == true
    assert Corex.New.Project.html?(project) == true
    assert Corex.New.Project.gettext?(project) == true
    assert Corex.New.Project.live?(project) == true
    assert Corex.New.Project.dashboard?(project) == false
    assert Corex.New.Project.javascript?(project) == true
    assert Corex.New.Project.css?(project) == true
    assert Corex.New.Project.mailer?(project) == true
    assert Corex.New.Project.verbose?(project) == true
  end

  test "Project.verbose? defaults to false" do
    project = %Corex.New.Project{opts: []}
    assert Corex.New.Project.verbose?(project) == false
  end

  test "Project.join_path expands path with bindings" do
    project = %Corex.New.Project{
      project_path: "/tmp/proj",
      app_path: "/tmp/proj",
      web_path: "/tmp/proj",
      lib_web_name: "myapp_web"
    }

    assert Corex.New.Project.join_path(project, :project, "config/config.exs") == "/tmp/proj/config/config.exs"
    assert Corex.New.Project.join_path(project, :web, "lib/:lib_web_name/endpoint.ex") == "/tmp/proj/lib/myapp_web/endpoint.ex"
  end
end

defmodule Corex.New.GeneratorsTest do
  use ExUnit.Case, async: false
  import MixHelper

  describe "Corex.New.Mailer.prepare_project/1" do
    test "sets in_umbrella and paths for umbrella context" do
      in_tmp("mailer prepare_project", fn ->
        base_path = Path.join(File.cwd!(), "apps/myapp")
        File.mkdir_p!(base_path)

        project =
          Corex.New.Project.new(base_path, [])
          |> Map.put(:binding, [ecto: true, html: true])
          |> Corex.New.Mailer.prepare_project()

        assert project.in_umbrella? == true
        assert project.app_path == Path.expand(base_path)
        assert project.project_path == Path.dirname(Path.dirname(Path.expand(base_path)))
      end)
    end
  end

  describe "Corex.New.Ecto.prepare_project/1" do
    test "sets in_umbrella and paths for umbrella context" do
      in_tmp("ecto prepare_project", fn ->
        base_path = Path.join(File.cwd!(), "apps/myapp")
        File.mkdir_p!(base_path)

        project =
          Corex.New.Project.new(base_path, [])
          |> Map.put(:binding, [ecto: true, html: true])
          |> Corex.New.Ecto.prepare_project()

        assert project.in_umbrella? == true
        assert project.app_path == Path.expand(base_path)
        assert project.project_path == Path.dirname(Path.dirname(Path.expand(base_path)))
      end)
    end
  end

  describe "Corex.New.Generator.config_inject/3" do
    test "raises when import Config is missing" do
      in_tmp("config_inject missing import", fn ->
        config_path = Path.join(File.cwd!(), "config")
        File.mkdir_p!(config_path)
        File.write!(Path.join(config_path, "config.exs"), "config :app, :key, :value\n")

        assert_raise Mix.Error, ~r/Could not find "import Config"/, fn ->
          Corex.New.Generator.config_inject(config_path, "config.exs", "\n# injected\n")
        end
      end)
    end

    test "creates file when file does not exist" do
      in_tmp("config_inject missing file", fn ->
        config_path = Path.join(File.cwd!(), "config")
        File.mkdir_p!(config_path)

        Corex.New.Generator.config_inject(config_path, "config.exs", "\nconfig :app, :key, :value\n")

        assert File.exists?(Path.join(config_path, "config.exs"))
        content = File.read!(Path.join(config_path, "config.exs"))
        assert content =~ "config :app, :key, :value"
      end)
    end
  end

  describe "Corex.New.Generator.prod_only_config_inject/3" do
    test "raises when prod block is missing" do
      in_tmp("prod_config_inject missing block", fn ->
        config_path = Path.join(File.cwd!(), "config")
        File.mkdir_p!(config_path)
        File.write!(Path.join(config_path, "runtime.exs"), "import Config\nconfig :app, :key, :value\n")

        assert_raise Mix.Error, ~r/Could not find "if config_env\(\) == :prod do"/, fn ->
          Corex.New.Generator.prod_only_config_inject(config_path, "runtime.exs", "\n# prod config\n")
        end
      end)
    end

    test "creates file when file does not exist" do
      in_tmp("prod_config_inject missing file", fn ->
        config_path = Path.join(File.cwd!(), "config")
        File.mkdir_p!(config_path)

        Corex.New.Generator.prod_only_config_inject(config_path, "runtime.exs", "\nconfig :app, :key, :value\n")

        assert File.exists?(Path.join(config_path, "runtime.exs"))
        content = File.read!(Path.join(config_path, "runtime.exs"))
        assert content =~ "if config_env() == :prod do"
        assert content =~ "config :app, :key, :value"
      end)
    end
  end

  describe "Corex.New.Generator maybe_heex_attr_gettext/2" do
    test "gettext true returns gettext call" do
      assert Corex.New.Generator.maybe_heex_attr_gettext("Hello", true) == ~s|{gettext("Hello")}|
    end

    test "gettext false returns inspect" do
      assert Corex.New.Generator.maybe_heex_attr_gettext("Hello", false) == "\"Hello\""
    end
  end

  describe "Corex.New.Generator maybe_eex_gettext/2" do
    test "gettext true returns gettext call" do
      assert Corex.New.Generator.maybe_eex_gettext("Hello", true) == ~s|{gettext("Hello")}|
    end

    test "gettext false returns message" do
      assert Corex.New.Generator.maybe_eex_gettext("Hello", false) == "Hello"
    end
  end

  describe "Corex.New.Generator.in_umbrella?/1" do
    test "returns true when app_path is inside umbrella structure" do
      in_tmp("in_umbrella true", fn ->
        File.write!("mix.exs", "defmodule Umbrella.MixProject do use Mix.Project end")
        File.mkdir_p!("apps/myapp")
        app_path = Path.join(File.cwd!(), "apps/myapp")

        assert Corex.New.Generator.in_umbrella?(app_path) == true
      end)
    end

    test "returns false when not inside umbrella structure" do
      in_tmp("in_umbrella false", fn ->
        File.mkdir_p!("myapp")
        app_path = Path.join(File.cwd!(), "myapp")

        assert Corex.New.Generator.in_umbrella?(app_path) == false
      end)
    end
  end
end
