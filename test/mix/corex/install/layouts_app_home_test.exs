defmodule Mix.Corex.Install.LayoutsAppHomeTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Layouts

  describe "build_replaced_home/4" do
    test "wraps starter body in <Layouts.app> with flash only by default" do
      out = Layouts.build_replaced_home([], [], false, "my_app_web")

      assert out =~ ~r/<Layouts\.app\b/
      assert out =~ "flash={@flash}"
      refute out =~ "current_scope"
      refute out =~ "path={"
      refute out =~ "mode="
      refute out =~ "theme="
      assert out =~ "</Layouts.app>"
      assert out =~ "Welcome to Corex"
    end

    test "adds path attr only when --lang is enabled" do
      out = Layouts.build_replaced_home([], [], true, "my_app_web")

      assert out =~ "path={@path}"
      refute out =~ "mode="
      refute out =~ "theme="
    end

    test "adds mode attr only when --mode is enabled (uses @mode form)" do
      out = Layouts.build_replaced_home([], [mode: true], false, "my_app_web")

      assert out =~ "mode={@mode}"
      refute out =~ ~s|assigns[:mode]|
      refute out =~ "theme="
      refute out =~ "path={"
    end

    test "adds theme attr only when themes are present (uses @theme form)" do
      out = Layouts.build_replaced_home(["neo"], [], false, "my_app_web")

      assert out =~ "theme={@theme}"
      refute out =~ ~s|assigns[:theme]|
      refute out =~ "mode="
      refute out =~ "path={"
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
