defmodule Mix.Corex.Install.LayoutsReplacedHomeTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Layouts

  describe "build_replaced_home/4" do
    test "wraps starter body in <Layouts.app> with flash + current_scope only by default" do
      out = Layouts.build_replaced_home([], [], false, "my_app_web")

      assert out =~ ~r/<Layouts\.app\b/
      assert out =~ "flash={@flash}"
      assert out =~ "current_scope={assigns[:current_scope]}"
      refute out =~ "path={assigns[:path]}"
      refute out =~ "mode="
      refute out =~ "theme="
      assert out =~ "</Layouts.app>"
      assert out =~ "Welcome to Corex"
    end

    test "adds path attr only when --lang is enabled" do
      out = Layouts.build_replaced_home([], [], true, "my_app_web")

      assert out =~ "path={assigns[:path]}"
      refute out =~ "mode="
      refute out =~ "theme="
    end

    test "adds mode attr only when --mode is enabled" do
      out = Layouts.build_replaced_home([], [mode: true], false, "my_app_web")

      assert out =~ "mode={assigns[:mode] || \"light\"}"
      refute out =~ "theme="
      refute out =~ "path={assigns[:path]}"
    end

    test "adds theme attr only when themes are present" do
      out = Layouts.build_replaced_home(["neo"], [], false, "my_app_web")

      assert out =~ "theme={assigns[:theme] || \"neo\"}"
      refute out =~ "mode="
      refute out =~ "path={assigns[:path]}"
    end

    test "rewrites corex.html.heex to home.html.heex in the demo body" do
      out = Layouts.build_replaced_home([], [], false, "my_app_web")

      assert out =~ "home.html.heex"
      refute out =~ "corex.html.heex"
    end

    test "interpolates the web directory name into the demo body" do
      out = Layouts.build_replaced_home([], [], false, "custom_web")

      assert out =~ "custom_web"
    end

    test "uses no-design starter body when --no-design" do
      out = Layouts.build_replaced_home([], [design: false], false, "my_app_web")

      assert out =~ ~r/<\.accordion id="welcome-accordion"\s*>/
    end

    test "uses design starter body when design is on" do
      out = Layouts.build_replaced_home([], [design: true], false, "my_app_web")

      assert out =~ ~s|<.accordion id="welcome-accordion" class="accordion">|
    end
  end
end
