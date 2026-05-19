defmodule Corex.ImageTest do
  use ExUnit.Case, async: true

  alias Corex.Image

  test "new/2 builds struct with defaults" do
    assert %Image{src: "/a.jpg", alt: "", class: nil} = Image.new("/a.jpg")
  end

  test "new/2 accepts alt and class" do
    assert %Image{src: "/a.jpg", alt: "A", class: "w-full"} =
             Image.new("/a.jpg", alt: "A", class: "w-full")
  end
end
