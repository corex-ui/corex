defmodule Corex.AvatarTest do
  use ExUnit.Case, async: true

  alias Corex.Avatar.Connect

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
