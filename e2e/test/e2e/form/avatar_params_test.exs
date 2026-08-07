defmodule E2e.Form.AvatarParamsTest do
  use ExUnit.Case, async: true

  alias E2e.Form.AvatarParams

  test "promotes avatar_label when avatar key is absent" do
    assert AvatarParams.normalize(%{"avatar_label" => "photo.png"}) == %{
             "avatar" => "photo.png",
             "avatar_label" => "photo.png"
           }
  end

  test "keeps explicit empty avatar and drops stale avatar_label" do
    assert AvatarParams.normalize(%{"avatar" => "", "avatar_label" => "stale.png"}) == %{
             "avatar" => ""
           }
  end

  test "keeps non-empty avatar and drops label" do
    assert AvatarParams.normalize(%{"avatar" => "kept.png", "avatar_label" => "stale.png"}) == %{
             "avatar" => "kept.png"
           }
  end

  test "uses Plug.Upload filename" do
    upload = %Plug.Upload{filename: "up.png", path: "/tmp/x", content_type: "image/png"}

    assert AvatarParams.normalize(%{"avatar" => upload, "avatar_label" => "stale.png"}) == %{
             "avatar" => "up.png"
           }
  end
end
