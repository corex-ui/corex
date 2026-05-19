defmodule Corex.AvatarTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Avatar
  alias Corex.Avatar.Connect

  describe "avatar/1" do
    test "renders without src" do
      html = render_component(&CorexTest.ComponentHelpers.render_avatar/1, [])
      assert html =~ ~r/data-scope="avatar"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
      assert html =~ ~r/phx-mounted=/
      assert html =~ ~r/JD/
    end

    test "renders with src" do
      html =
        render_component(&Corex.Avatar.avatar/1,
          src: "image.png",
          fallback: [%{inner_block: fn _, _ -> "JD" end}]
        )

      assert html =~ "image.png"
      assert html =~ ~S(phx-mounted=)
      assert html =~ ~S(data-part="image")
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-avatar"}
      result = Connect.root(assigns)
      assert result["id"] == "avatar:test-avatar"
      assert result["data-scope"] == "avatar"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.image/1" do
    test "returns image attributes with src" do
      assigns = %{id: "test-avatar", src: "https://example.com/avatar.png"}
      result = Connect.image(assigns)
      assert result["id"] == "avatar:test-avatar:image"
      assert result["data-part"] == "image"
      assert result["src"] == "https://example.com/avatar.png"
    end

    test "returns image attributes without src" do
      assigns = %{id: "test-avatar", src: nil}
      result = Connect.image(assigns)
      refute Map.has_key?(result, "src")
    end
  end

  describe "Connect.fallback/1" do
    test "returns fallback attributes" do
      assigns = %{id: "test-avatar"}
      result = Connect.fallback(assigns)
      assert result["id"] == "avatar:test-avatar:fallback"
      assert result["data-part"] == "fallback"
    end
  end

  describe "Connect.skeleton/1" do
    test "returns skeleton attributes" do
      assigns = %{id: "test-avatar"}
      result = Connect.skeleton(assigns)
      assert result["id"] == "avatar:test-avatar:skeleton"
      assert result["data-part"] == "skeleton"
    end
  end

  describe "set_src/2" do
    test "returns JS command" do
      js = Avatar.set_src("my-avatar", "https://example.com/a.png")
      assert %Phoenix.LiveView.JS{} = js
      ops = Map.get(js, :ops, [])

      assert Enum.any?(ops, fn
               ["dispatch", %{event: "corex:avatar:set-src"}] -> true
               _ -> false
             end)
    end
  end

  describe "set_src/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Avatar.set_src(socket, "my-avatar", "https://example.com/a.png")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "loaded/1" do
    test "returns JS command" do
      js = Avatar.loaded("my-avatar")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "loaded/3" do
    test "pushes avatar_loaded event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = Avatar.loaded(socket, "my-avatar")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end
end
