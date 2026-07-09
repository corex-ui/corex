defmodule Corex.ConnectReadonlyContractTest do
  use ExUnit.Case, async: true

  @components_root Path.join(Application.app_dir(:corex), "lib/components")
  @design_root Application.app_dir(:corex_design, "priv/css")

  test "hook connect modules do not emit data-read-only on props" do
    for path <- Path.wildcard(Path.join(@components_root, "**/connect.ex")) do
      content = File.read!(path)

      if content =~ "def props" do
        refute content =~ ~S("data-read-only"),
               "#{path} must use data-readonly, not data-read-only"
      end
    end
  end

  test "design css does not use data-read-only" do
    for path <- Path.wildcard(Path.join(@design_root, "**/*.css")) do
      refute File.read!(path) =~ "data-read-only",
             "#{path} must use [data-readonly], not [data-read-only]"
    end
  end

  test "connect root sets data-readonly when props has read_only" do
    for path <- Path.wildcard(Path.join(@components_root, "**/connect.ex")) do
      content = File.read!(path)

      if content =~ "read_only" and content =~ "def props" and content =~ "def root" do
        assert content =~ ~S/data-readonly" => get_boolean(assigns.read_only)/,
               "#{path} root/1 must set data-readonly from read_only"
      end
    end
  end
end
