defmodule Corex.ToastTest do
  use CorexTest.ComponentCase, async: true

  describe "create_toast/5" do
    test "returns JS command for info type" do
      js = Corex.Toast.create_toast("layout-toast", "Title", "Description", :info, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for success type" do
      js = Corex.Toast.create_toast("layout-toast", "Saved!", "Done", :success, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for error type" do
      js = Corex.Toast.create_toast("layout-toast", "Error", "Failed", :error, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for loading type with infinite duration" do
      js =
        Corex.Toast.create_toast("layout-toast", "Loading", nil, :loading, duration: :infinity)

      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command with custom duration" do
      js = Corex.Toast.create_toast("layout-toast", "Title", nil, :info, duration: 3000)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "push_toast/6" do
    test "returns modified socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Corex.Toast.push_toast(socket, "layout-toast", "Title", "Desc", :success, 5000)
      assert %Phoenix.LiveView.Socket{} = result
    end

    test "accepts infinite duration" do
      socket = %Phoenix.LiveView.Socket{}
      result = Corex.Toast.push_toast(socket, "layout-toast", "Loading", nil, :loading, :infinity)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "toast_group/1" do
    test "renders toast group" do
      result = render_component(&Corex.Toast.toast_group/1, id: "layout-toast")
      assert [_] = find_in_html(result, ~s([data-scope="toast"][data-part="group"]))
    end

    test "renders toast group with flash" do
      result =
        render_component(&Corex.Toast.toast_group/1,
          id: "layout-toast",
          flash: %{info: "Hello", error: "Oops"}
        )

      assert [_] = find_in_html(result, ~s([data-scope="toast"]))
    end
  end

  describe "toast_client_error/1" do
    test "renders with phx-disconnected" do
      result =
        render_component(&Corex.Toast.toast_client_error/1,
          toast_group_id: "layout-toast",
          title: "Client Error",
          description: "Reconnecting"
        )

      assert [_] = find_in_html(result, "[phx-disconnected]")
    end
  end

  describe "toast_server_error/1" do
    test "renders with phx-disconnected" do
      result =
        render_component(&Corex.Toast.toast_server_error/1,
          toast_group_id: "layout-toast",
          title: "Server Error",
          description: "Retrying"
        )

      assert [_] = find_in_html(result, "[phx-disconnected]")
    end
  end

  describe "toast_connected/1" do
    test "renders with phx-connected" do
      result =
        render_component(&Corex.Toast.toast_connected/1,
          toast_group_id: "layout-toast",
          title: "Connected",
          description: "Back online"
        )

      assert [_] = find_in_html(result, "[phx-connected]")
    end
  end

  describe "toast_disconnected/1" do
    test "renders with phx-disconnected" do
      result =
        render_component(&Corex.Toast.toast_disconnected/1,
          toast_group_id: "layout-toast",
          title: "Disconnected",
          description: "Lost connection"
        )

      assert [_] = find_in_html(result, "[phx-disconnected]")
    end
  end
end
