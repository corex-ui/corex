defmodule Mix.Corex.LocaleFlagsTest do
  use ExUnit.Case, async: false

  @tmp Path.join(System.tmp_dir!(), "corex_locale_flags_#{System.unique_integer([:positive])}")

  setup do
    File.rm_rf!(@tmp)
    File.mkdir_p!(Path.join(@tmp, "lib"))

    on_exit(fn -> File.rm_rf(@tmp) end)
    :ok
  end

  test "layout_locale_assigns?/1 follows layout locale opts" do
    assert Mix.Corex.layout_locale_assigns?(locale: true)
    refute Mix.Corex.layout_locale_assigns?([])
    refute Mix.Corex.layout_locale_assigns?(mode: true)
  end

  test "layout_locale_paths? is false when path_prefixes are configured" do
    File.cd!(@tmp, fn ->
      File.write!("lib/corex_web.ex", """
      defmodule CorexWeb do
        def verified_routes do
          quote do
            use Phoenix.VerifiedRoutes,
              path_prefixes: [{CorexWeb.Locale, :current, []}]
          end
        end
      end
      """)

      assert Mix.Corex.verified_routes_path_prefixes?(CorexWeb)
      assert Mix.Corex.locale_scoped_routes?(CorexWeb, locale: true)
      refute Mix.Corex.layout_locale_paths?(CorexWeb, locale: true)
      assert Mix.Corex.layout_locale_assigns?(locale: true)
    end)
  end

  test "layout_locale_paths? is true for locale layout without path_prefixes" do
    File.cd!(@tmp, fn ->
      File.write!("lib/corex_web.ex", """
      defmodule CorexWeb do
        def verified_routes do
          quote do
            use Phoenix.VerifiedRoutes, endpoint: CorexWeb.Endpoint
          end
        end
      end
      """)

      refute Mix.Corex.verified_routes_path_prefixes?(CorexWeb)
      assert Mix.Corex.layout_locale_paths?(CorexWeb, locale: true)
    end)
  end
end
