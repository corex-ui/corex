defmodule Mix.Corex.DesignComponentsTest do
  use ExUnit.Case, async: false

  alias Mix.Corex.DesignComponents

  @required_hosts ~W(
    data-table data-list number-input date-picker password-input
    dialog checkbox native-input select
    layout-heading button link icon
  )a

  setup do
    tmp = Path.join(System.tmp_dir!(), "corex_design_comp_#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(tmp, "config"))
    shell = Mix.shell()
    Mix.shell(Mix.Shell.Quiet)

    on_exit(fn ->
      Mix.shell(shell)
      File.rm_rf(tmp)
    end)

    {:ok, tmp: tmp}
  end

  test "live and html hosts cover gen templates and inputs" do
    for host <- @required_hosts do
      assert host in DesignComponents.live_hosts()
      assert host in DesignComponents.html_hosts()
    end
  end

  test "ensure!/2 appends missing hosts to corex_design components", %{tmp: tmp} do
    File.write!(Path.join(tmp, "config/config.exs"), """
    config :corex_design,
      components: [:toast, :button]
    """)

    File.cd!(tmp, fn ->
      assert :ok =
               DesignComponents.ensure!(
                 [:"data-table", :"number-input", :button],
                 build: false
               )

      body = File.read!("config/config.exs")
      assert body =~ ~S(:"data-table")
      assert body =~ ~S(:"number-input")
      assert Regex.scan(~r/:button/, body) |> length() == 1
    end)
  end

  test "ensure!/2 appends data-list from ensure_for_live!", %{tmp: tmp} do
    File.write!(Path.join(tmp, "config/config.exs"), """
    config :corex_design,
      components: [:toast, :button, :dialog]
    """)

    File.cd!(tmp, fn ->
      assert :ok = DesignComponents.ensure_for_live!(build: false)
      body = File.read!("config/config.exs")
      assert body =~ ~S(:"data-list")
      assert body =~ ~S(:"data-table")
      assert body =~ ~S(:"date-picker")
      assert body =~ ~S(:"password-input")
      assert body =~ ":select"
      assert body =~ ":icon"
    end)
  end

  test "ensure!/2 is a no-op without corex_design config", %{tmp: tmp} do
    File.write!(Path.join(tmp, "config/config.exs"), "import_config \"\#{config_env()}.exs\"\n")

    File.cd!(tmp, fn ->
      assert :ok = DesignComponents.ensure!([:"data-table"], build: false)
      refute File.read!("config/config.exs") =~ "data-table"
    end)
  end

  test "ensure!/2 leaves ~w components lists for manual update", %{tmp: tmp} do
    File.write!(Path.join(tmp, "config/config.exs"), """
    config :corex_design,
      components: ~w(toast button)a
    """)

    File.cd!(tmp, fn ->
      assert :ok = DesignComponents.ensure!([:"data-list"], build: false)
      refute File.read!("config/config.exs") =~ "data-list"
    end)
  end

  test "ensure!/2 rebuilds empty or trailing-comma component lists without leading comma", %{
    tmp: tmp
  } do
    File.write!(Path.join(tmp, "config/config.exs"), """
    config :corex_design,
      components: [
      ]
    """)

    File.cd!(tmp, fn ->
      assert :ok = DesignComponents.ensure!([:"data-table", :button], build: false)
      body = File.read!("config/config.exs")
      assert body =~ ~S(components: [:"data-table", :button])
      refute body =~ "[,"
    end)
  end
end
