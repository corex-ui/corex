defmodule E2eWeb.ShowcasesLiveTest do
  use E2eWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias E2e.Tetrex
  alias E2e.Tetrex.Registry
  alias E2e.Tetrex.Session
  alias E2e.Tetrex.Store
  alias E2eWeb.TetrexPresence

  setup do
    for %{id: id} <- Registry.list_active() do
      Session.kill(id)
      Registry.unregister(id)
    end

    :ok
  end

  defp tetrex_game_id_from(html) when is_binary(html) do
    case Regex.run(~r{/showcases/tetrex/([A-Za-z0-9_-]+)}, html) do
      [_, id] -> id
      _ -> flunk("expected tetrex game id in rendered HTML")
    end
  end

  defp save_top_game(id, score) do
    base = %{Tetrex.new() | score: score, status: :game_over}
    client = Tetrex.to_client(base)
    mid = Tetrex.to_client(Tetrex.command(Tetrex.new(), :left))
    Store.finalize(id, score, [mid, client], client)
  end

  test "showcases index mounts with blog layout" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases")
    assert html =~ ~S(id="showcases-page")
    assert html =~ "Tetrex"
    assert html =~ ~S(class="blog")
    refute html =~ "Leaderboard"
  end

  test "showcases index has Play for tetrex" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases")
    assert html =~ "/showcases/tetrex"
    assert html =~ "Play"
    refute html =~ ~S(class="blog__card__arrow")
  end

  test "showcases index has Live demo and GitHub for soonex" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases")
    assert html =~ "Live demo"
    assert html =~ "https://corex-ui.github.io/soonex/"
    assert html =~ "https://github.com/corex-ui/soonex"
  end

  test "redirects games to showcases" do
    conn = build_conn() |> get("/en/games")
    assert redirected_to(conn) == "/en/showcases"
  end

  test "redirects games tetrex to showcases tetrex" do
    conn = build_conn() |> get("/en/games/tetrex/new")
    assert redirected_to(conn) == "/en/showcases/tetrex/new"
  end

  test "tetrex index lists active session" do
    id = Registry.new_id()
    :ok = Session.ensure_started(id)

    {:ok, player, _html} = live(build_conn(), "/en/showcases/tetrex/#{id}")
    render(player)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex")
    assert html =~ id
    assert html =~ "Watch"
    assert html =~ "Watchers"
    assert html =~ ~S(id="tetrex-live")
  end

  test "closing player game removes session from live list" do
    id = Registry.new_id()
    :ok = Session.ensure_started(id)

    {:ok, view, _html} = live(build_conn(), "/en/showcases/tetrex/#{id}")
    render(view)
    view_ref = Process.monitor(view.pid)
    %{proxy: {_ref, _topic, proxy_pid}} = view
    Phoenix.LiveViewTest.ClientProxy.stop(proxy_pid, :shutdown)
    assert_receive {:DOWN, ^view_ref, :process, _, _}, 1000
    assert_wait_until(fn -> id not in TetrexPresence.live_player_game_ids() end)

    refute id in TetrexPresence.live_player_game_ids()
  end

  test "closing player game archives for watch game over overlay" do
    id = Registry.new_id()
    :ok = Session.ensure_started(id)

    game = %{Tetrex.new() | score: 9000}
    :ok = Session.sync(id, Tetrex.to_client(game))

    {:ok, view, _html} = live(build_conn(), "/en/showcases/tetrex/#{id}")
    render(view)
    :ok = Session.stop(id)
    view_ref = Process.monitor(view.pid)
    %{proxy: {_ref, _topic, proxy_pid}} = view
    Phoenix.LiveViewTest.ClientProxy.stop(proxy_pid, :shutdown)
    assert_receive {:DOWN, ^view_ref, :process, _, _}, 1000

    assert_wait_until(fn ->
      case Store.get(id) do
        %{status: "game_over"} -> true
        _ -> false
      end
    end)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/#{id}/watch")
    assert html =~ "Game over"
    refute html =~ "Start"
  end

  defp assert_wait_until(fun, attempts \\ 100) do
    if fun.() do
      :ok
    else
      if attempts > 0 do
        Process.sleep(10)
        assert_wait_until(fun, attempts - 1)
      else
        flunk("condition not met in time")
      end
    end
  end

  test "tetrex new renders board and keyboard on first paint" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/new")
    assert html =~ ~S(id="tetrex-cabinet")
    assert html =~ "game-0-0"
    assert html =~ ~S(>Keyboard<)
    assert html =~ "Start"
  end

  test "tetrex new redirects to game id when connected" do
    {:ok, view, _html} = live(build_conn(), "/en/showcases/tetrex/new")
    assert tetrex_game_id_from(render(view)) != ""
  end

  test "tetrex show mounts board cells" do
    id = Registry.create()
    :ok = Session.ensure_started(id)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/#{id}")
    assert html =~ ~S(id="tetrex-cabinet")
    assert html =~ ~S(id="tetrex-score")
    assert html =~ "game-0-0"
    assert html =~ "Start"
  end

  test "watch mode hides move controls" do
    id = Registry.create()
    :ok = Session.ensure_started(id)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/#{id}/watch")
    assert html =~ "LIVE"
    refute html =~ ~S(>Keyboard<)
  end

  test "archived ended game in top 10 shows congratulations and replay link" do
    save_top_game("arch1", 4200)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/arch1")
    assert html =~ "Congratulations"
    assert html =~ "Watch replay"
    assert html =~ "New game"
    assert html =~ "Game over"
    refute html =~ "Start"
  end

  test "archived ended game below top 10 shows game over without congratulations" do
    for i <- 1..10, do: save_top_game("fill#{i}", 5000 + i)

    now = DateTime.utc_now() |> DateTime.truncate(:second)
    client = Tetrex.to_client(%{Tetrex.new() | score: 100, status: :game_over})

    %E2e.Tetrex.Game{
      id: "below10",
      score: 100,
      status: "game_over",
      client_state: client,
      frames: [client],
      player_name: "Low",
      ended_at: now,
      inserted_at: now,
      updated_at: now
    }
    |> E2e.Repo.insert!()

    refute Store.on_leaderboard?("below10")

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/below10")
    assert html =~ "Game over"
    refute html =~ "Congratulations"
    refute html =~ "Watch replay"
    refute html =~ ~S(id="tetrex-overlay-player-name")
  end

  test "replay route shows controls without game over overlay" do
    save_top_game("arch2", 4200)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/arch2/replay")
    assert html =~ ~S(id="tetrex-replay-controls")
    assert html =~ ~S(id="tetrex-replay-play")
    assert html =~ ~S(id="tetrex-replay-end-overlay")
    assert html =~ "Watch again"
    refute html =~ ~S(data-replay-action="play")
    refute html =~ ~S(id="tetrex-overlay")
    refute html =~ "Start"
  end

  test "replay ignores active session for same id" do
    save_top_game("stale1", 9000)
    :ok = Session.ensure_started("stale1")

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/stale1/replay")
    assert html =~ ~S(id="tetrex-replay-controls")
    refute html =~ ~S(id="tetrex-overlay")
  end

  test "missing game shows unavailable overlay" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/nope-id")
    assert html =~ "Game unavailable"
    refute html =~ "Loading game"
    refute html =~ ~S(id="tetrex-board")
  end

  test "tetrex index lists leaderboard with replay link" do
    save_top_game("top1", 9000)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex")
    assert html =~ "Leaderboard"
    assert html =~ "top1"
    assert html =~ ~S(/showcases/tetrex/top1/replay)
    assert html =~ ~S(id="tetrex-leaderboard")
  end

  test "finalize assigns random player name" do
    save_top_game("named1", 8000)

    record = Store.get("named1")
    assert is_binary(record.player_name)
    assert record.player_name != ""
  end

  test "new game page does not show player name editor in sidebar" do
    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/new")
    refute html =~ ~S(id="tetrex-overlay-player-name")
    refute html =~ ~S(id="tetrex-player-name")
  end

  test "game over overlay shows editable player name for owned leaderboard game" do
    game_id = "owned-go-#{System.unique_integer([:positive])}"
    E2e.Tetrex.OwnershipStore.claim(%{}, game_id)
    save_top_game(game_id, 99_999_999)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex/#{game_id}")

    assert html =~ "Congratulations"
    assert html =~ ~S(id="tetrex-overlay-player-name")
    assert html =~ ~S(data-on-value-change="tetrex_player_name_changed")
    refute html =~ ~S(id="tetrex-player-name")
  end

  test "leaderboard shows plain name for unowned game" do
    save_top_game("named2", 8500)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex")
    assert html =~ "named2"
    refute html =~ ~S(id="tetrex-player-named2")
  end

  test "leaderboard shows editable name for owned game" do
    E2e.Repo.delete_all(E2e.Tetrex.Game)

    game_id = "owned-#{System.unique_integer([:positive])}"
    E2e.Tetrex.OwnershipStore.claim(%{}, game_id)
    save_top_game(game_id, 99_999_999)

    {:ok, _view, html} = live(build_conn(), "/en/showcases/tetrex")

    assert html =~ ~s(id="tetrex-player-#{game_id}")
    assert html =~ ~S(data-on-value-change="tetrex_player_name_changed")
  end

  test "redirects templates to showcases" do
    conn = build_conn() |> get("/en/templates")
    assert redirected_to(conn) == "/en/showcases"
  end
end
