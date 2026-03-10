defmodule Corex.AvatarTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Avatar.Connect

  describe "avatar/1" do
    test "renders without src" do
      html = render_component(&CorexTest.ComponentHelpers.render_avatar/1, [])
      assert html =~ ~r/data-scope="avatar"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/JD/
    end

    test "renders with src" do
      html =
        render_component(&Corex.Avatar.avatar/1,
          src: "image.png",
          fallback: [%{inner_block: fn _, _ -> "JD" end}]
        )

      assert html =~ "image.png"
      # skeleton is visible
      assert html =~ ~s(data-state="visible")
      # fallback is hidden
      assert html =~ ~s(data-state="hidden")
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
end
