defmodule E2eWeb.DocA11yRoutesTest do
  use ExUnit.Case, async: true

  test "all doc paths are unique and locale-prefixed" do
    paths = E2eWeb.DocA11yRoutes.all() |> Enum.map(&elem(&1, 0))
    assert length(paths) == length(Enum.uniq(paths))
    assert Enum.all?(paths, &String.starts_with?(&1, "/en/"))
  end

  test "for_slug returns only matching component paths" do
    tabs = E2eWeb.DocA11yRoutes.for_slug("tabs")
    assert Enum.all?(tabs, fn {path, _} -> String.contains?(path, "/tabs/") end)
    assert Enum.any?(tabs, fn {path, _} -> String.ends_with?(path, "/anatomy") end)
  end

  test "ready selectors are non-empty strings" do
    assert Enum.all?(E2eWeb.DocA11yRoutes.all(), fn {_, ready} ->
             is_binary(ready) and ready != ""
           end)
  end

  test "pilot ComponentBehaviorSpec paths match DocA11yRoutes" do
    Localize.put_locale(:en)

    for {slug, comp} <- [
          {"angle-slider", :angle_slider},
          {"checkbox", :checkbox},
          {"listbox", :listbox},
          {"switch", :switch},
          {"combobox", :combobox}
        ],
        key <- [:anatomy, :api, :events] do
      {path, ready} = E2eWeb.ComponentBehaviorSpec.page(comp, key)

      assert Enum.any?(E2eWeb.DocA11yRoutes.for_slug(slug), fn {p, r} ->
               p == path and r == ready
             end),
             "missing DocA11yRoutes entry for #{slug} #{key}: #{path} #{ready}"
    end

    for {slug, comp} <- [
          {"angle-slider", :angle_slider},
          {"checkbox", :checkbox},
          {"switch", :switch},
          {"combobox", :combobox}
        ],
        key <- [:playground, :patterns] do
      {path, ready} = E2eWeb.ComponentBehaviorSpec.page(comp, key)

      assert Enum.any?(E2eWeb.DocA11yRoutes.for_slug(slug), fn {p, r} ->
               p == path and r == ready
             end),
             "missing DocA11yRoutes entry for #{slug} #{key}: #{path} #{ready}"
    end

    for key <- [:anatomy, :api, :events, :playground, :patterns, :animation] do
      {path, ready} = E2eWeb.ComponentBehaviorSpec.page(:accordion, key)

      assert Enum.any?(E2eWeb.DocA11yRoutes.for_slug("accordion"), fn {p, r} ->
               p == path and r == ready
             end),
             "missing DocA11yRoutes entry for accordion #{key}: #{path} #{ready}"
    end
  end
end
