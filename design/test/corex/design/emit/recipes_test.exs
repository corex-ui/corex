defmodule Corex.Design.Emit.RecipesTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Emit.Recipes

  describe "generate/1" do
    test "emits nothing but the layer wrapper for no components" do
      assert Recipes.generate([]) == """
             @layer components {
             @media (prefers-reduced-motion: reduce) {
               [data-theme] {
                 --duration-fast: 0.01ms;
                 --duration-normal: 0.01ms;
                 --duration-slow: 0.01ms;
               }
             }

             @media (prefers-contrast: more) {
               [data-theme] {
                 --ring-width: 3px;
                 --border-width: 1.5px;
               }
             }

             }
             """
    end

    test "wraps every rule in the components layer" do
      css = Recipes.generate(["button"])

      assert String.starts_with?(css, "@layer components {\n")
      assert String.ends_with?(css, "}\n")
    end

    test "seeds the control palette on each requested host" do
      css = Recipes.generate(["button", "badge"])

      assert css =~ ".badge,\n.button {"
      assert css =~ "--ctl-fill: var(--color-ink);"
    end

    test "gives a variant host the soft idle defaults" do
      css = Recipes.generate(["button"])

      assert css =~ ".button:not(.ui-solid):not(.ui-ghost) {"
      assert css =~ "--ctl-bg: var(--color-ui);"
    end

    test "omits the soft idle block for a host with no variant axis" do
      css = Recipes.generate(["marquee"])

      refute css =~ ":not(.ui-solid):not(.ui-ghost)"
    end

    test "scopes part selectors to the host and its data-scope" do
      css = Recipes.generate(["select"])

      assert css =~ ~s|.select :where([data-scope="select"][data-part="trigger"])|
    end

    test "emits open-state chrome only for hosts that have a trigger" do
      assert Recipes.generate(["select"]) =~ ~s|:is([data-state="open"]) {|
      refute Recipes.generate(["marquee"]) =~ ~s|:is([data-state="open"]) {|
    end

    test "emits selection chrome only for hosts that have a selectable part" do
      assert Recipes.generate(["select"]) =~ "--ctl-fill-ink"
      refute Recipes.generate(["marquee"]) =~ "background-color: var(--ctl-fill);"
    end

    test "accepts atom ids as the config does" do
      assert Recipes.generate([:button]) == Recipes.generate(["button"])
    end

    test "orders hosts independently of the order requested" do
      assert Recipes.generate(["badge", "button"]) == Recipes.generate(["button", "badge"])
    end

    test "names pre.code rather than .code for the code host" do
      css = Recipes.generate(["code"])

      assert css =~ "pre.code {"
      refute css =~ "\n.code {"
    end
  end

  describe "write!/2" do
    @tag :tmp_dir
    test "writes a banner followed by the generated rules", %{tmp_dir: tmp_dir} do
      Recipes.write!(tmp_dir, ["button"])

      css = File.read!(Path.join(tmp_dir, "recipes.css"))

      assert String.starts_with?(css, "/* Corex generated recipes - do not edit */\n")
      assert css =~ "@layer components {"
    end

    @tag :tmp_dir
    test "is idempotent", %{tmp_dir: tmp_dir} do
      Recipes.write!(tmp_dir, ["button"])
      first = File.read!(Path.join(tmp_dir, "recipes.css"))

      Recipes.write!(tmp_dir, ["button"])

      assert File.read!(Path.join(tmp_dir, "recipes.css")) == first
    end
  end
end
