defmodule Corex.ToastTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Toast.Anatomy.Group
  alias Corex.Toast.Connect

  describe "create/5" do
    test "returns JS command for info type" do
      js = Corex.Toast.create("layout-toast", "Title", "Description", :info, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for success type" do
      js = Corex.Toast.create("layout-toast", "Saved!", "Done", :success, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for error type" do
      js = Corex.Toast.create("layout-toast", "Error", "Failed", :error, [])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for loading type with infinite duration" do
      js =
        Corex.Toast.create("layout-toast", "Loading", nil, :loading, duration: :infinity)

      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command with custom duration" do
      js = Corex.Toast.create("layout-toast", "Title", nil, :info, duration: 3000)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS with id and action in detail" do
      js =
        Corex.Toast.create("layout-toast", "T", "D", :info,
          id: "t1",
          action: %{label: "Go", effects: [%{kind: :push, event: "e", value: %{}}]}
        )

      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "create/6" do
    test "returns modified socket" do
      socket = %Phoenix.LiveView.Socket{}

      result =
        Corex.Toast.create(socket, "layout-toast", "Title", "Desc", :success, duration: 5000)

      assert %Phoenix.LiveView.Socket{} = result
    end

    test "handles unknown types gracefully" do
      socket = %Phoenix.LiveView.Socket{}

      result =
        Corex.Toast.create(socket, "layout-toast", "Title", "Desc", :unknown, duration: 5000)

      assert %Phoenix.LiveView.Socket{} = result
    end

    test "accepts error and info types" do
      socket = %Phoenix.LiveView.Socket{}

      result1 =
        Corex.Toast.create(socket, "layout-toast", "Error", "Desc", :error, duration: 5000)

      result2 = Corex.Toast.create(socket, "layout-toast", "Info", "Desc", :info, duration: 5000)
      assert %Phoenix.LiveView.Socket{} = result1
      assert %Phoenix.LiveView.Socket{} = result2
    end

    test "accepts infinite duration" do
      socket = %Phoenix.LiveView.Socket{}

      result =
        Corex.Toast.create(socket, "layout-toast", "Loading", nil, :info, duration: :infinity)

      assert %Phoenix.LiveView.Socket{} = result
    end

    test "passes loading: true in opts" do
      socket = %Phoenix.LiveView.Socket{}

      result =
        Corex.Toast.create(socket, "layout-toast", "Wait", nil, :info,
          duration: :infinity,
          loading: true
        )

      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "update/3 and update/4" do
    test "client returns JS" do
      js = Corex.Toast.update("layout-toast", "x", %{title: "Hi"})
      assert %Phoenix.LiveView.JS{} = js
    end

    test "server returns socket" do
      socket = %Phoenix.LiveView.Socket{}

      assert %Phoenix.LiveView.Socket{} =
               Corex.Toast.update(socket, "layout-toast", "x", %{title: "Hi"})
    end
  end

  describe "remove/2 and remove/3" do
    test "client returns JS" do
      js = Corex.Toast.remove("layout-toast", "x")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "server returns socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Corex.Toast.remove(socket, "layout-toast", "x")
    end
  end

  describe "dismiss/2 and dismiss/3" do
    test "client returns JS" do
      js = Corex.Toast.dismiss("layout-toast", "x")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "server returns socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Corex.Toast.dismiss(socket, "layout-toast", "x")
    end
  end

  describe "create_toast/5 delegates to create/5" do
    test "returns JS" do
      assert %Phoenix.LiveView.JS{} =
               Corex.Toast.create_toast("layout-toast", "A", "B", :info, [])
    end
  end

  describe "push_toast/6 delegates to create/6" do
    test "returns socket" do
      socket = %Phoenix.LiveView.Socket{}

      assert %Phoenix.LiveView.Socket{} =
               Corex.Toast.push_toast(socket, "layout-toast", "A", "B", :info, 4000, [])
    end
  end

  describe "toast_group/1" do
    test "renders toast group" do
      result =
        render_component(&Corex.Toast.toast_group/1, id: "layout-toast")

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

    test "renders toast group with flash structs" do
      result =
        render_component(&Corex.Toast.toast_group/1,
          id: "layout-toast",
          flash: %{info: "Hello", error: "Oops"},
          flash_info: %Corex.Flash.Info{title: "Info", type: :success, duration: 1000},
          flash_error: %Corex.Flash.Error{title: "Alert", type: :error, duration: :infinity}
        )

      assert [_] = find_in_html(result, ~s([data-flash-info-duration="1000"]))
      assert [_] = find_in_html(result, ~s([data-flash-error-duration="infinity"]))
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

    test "handles explicit types" do
      result =
        render_component(&Corex.Toast.toast_client_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :success
        )

      assert result =~ ~s(&quot;type&quot;:&quot;success&quot;)

      result =
        render_component(&Corex.Toast.toast_client_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :error
        )

      assert result =~ ~s(&quot;type&quot;:&quot;error&quot;)

      result =
        render_component(&Corex.Toast.toast_client_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :unknown_type
        )

      assert result =~ ~s(&quot;type&quot;:&quot;info&quot;)
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

    test "handles explicit types" do
      result =
        render_component(&Corex.Toast.toast_server_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :success
        )

      assert result =~ ~s(&quot;type&quot;:&quot;success&quot;)

      result =
        render_component(&Corex.Toast.toast_server_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :info
        )

      assert result =~ ~s(&quot;type&quot;:&quot;info&quot;)

      result =
        render_component(&Corex.Toast.toast_server_error/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :unknown_type
        )

      assert result =~ ~s(&quot;type&quot;:&quot;error&quot;)
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

    test "handles explicit types" do
      result =
        render_component(&Corex.Toast.toast_connected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :error
        )

      assert result =~ ~s(&quot;type&quot;:&quot;error&quot;)

      result =
        render_component(&Corex.Toast.toast_connected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :info
        )

      assert result =~ ~s(&quot;type&quot;:&quot;info&quot;)

      result =
        render_component(&Corex.Toast.toast_connected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :unknown_type
        )

      assert result =~ ~s(&quot;type&quot;:&quot;success&quot;)
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

    test "handles explicit types" do
      result =
        render_component(&Corex.Toast.toast_disconnected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :success
        )

      assert result =~ ~s(&quot;type&quot;:&quot;success&quot;)

      result =
        render_component(&Corex.Toast.toast_disconnected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :error
        )

      assert result =~ ~s(&quot;type&quot;:&quot;error&quot;)

      result =
        render_component(&Corex.Toast.toast_disconnected/1,
          toast_group_id: "layout-toast",
          title: "Error",
          type: :unknown_type
        )

      assert result =~ ~s(&quot;type&quot;:&quot;info&quot;)
    end
  end

  describe "Connect.group/1 and Connect.ignore_group/1" do
    test "group maps anatomy attrs" do
      m = Connect.group(%Group{id: "g1"})
      assert m["id"] == "toast:g1:group"
      assert m["data-scope"] == "toast"
      assert m["data-part"] == "group"
    end

    test "ignore_group returns JS" do
      js = Connect.ignore_group(%Group{id: "g1"})
      assert %Phoenix.LiveView.JS{} = js
    end
  end
end
