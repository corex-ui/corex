defmodule Corex.NavigateTest do
  use CorexTest.ComponentCase, async: true

  defp render_with_captured_stderr(fun) do
    parent = self()
    ref = make_ref()

    _ =
      ExUnit.CaptureIO.capture_io(:stderr, fn ->
        send(parent, {ref, fun.()})
      end)

    receive do
      {^ref, result} -> result
    after
      1000 -> flunk("timeout")
    end
  end

  describe "navigate/1" do
    test "renders href link by default" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/about",
          type: "href",
          external: false,
          download: nil,
          aria_label: nil
        )

      assert [_] = find_in_html(result, ~S(a[href="/about"]))
      assert text_in_html(result) =~ "Link text"
    end

    test "renders navigate link" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/dashboard",
          type: "navigate",
          external: false,
          download: nil,
          aria_label: nil
        )

      assert [_] = find_in_html(result, "[data-phx-link]")
    end

    test "renders external link with target and rel" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "https://example.com",
          type: "href",
          external: true,
          download: nil,
          aria_label: nil
        )

      assert [_] = find_in_html(result, ~S(a[target="_blank"][rel="noopener noreferrer"]))
    end

    test "renders link with download attribute" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/file.pdf",
          type: "href",
          external: false,
          download: "report.pdf",
          aria_label: nil
        )

      assert [_] = find_in_html(result, ~S(a[download="report.pdf"]))
    end

    test "renders link with aria_label" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/profile",
          type: "href",
          external: false,
          download: nil,
          aria_label: "View profile"
        )

      assert [_] = find_in_html(result, ~S(a[aria-label="View profile"]))
    end

    test "renders patch link" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/items",
          type: "patch",
          external: false,
          download: nil,
          aria_label: nil
        )

      assert [_] = find_in_html(result, "[data-phx-link]")
    end

    test "renders link with download boolean" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/file.pdf",
          type: "href",
          external: false,
          download: true,
          aria_label: nil
        )

      assert [_] = find_in_html(result, "a[download]")
    end

    test "drops replace when type href" do
      result =
        render_with_captured_stderr(fn ->
          render_component(&CorexTest.ComponentHelpers.render_navigate_replace/1, to: "/")
        end)

      assert [_] = find_in_html(result, "a[href='/']")
    end

    test "drops method when type navigate" do
      result =
        render_with_captured_stderr(fn ->
          render_component(&CorexTest.ComponentHelpers.render_navigate_method/1, to: "/")
        end)

      assert [_] = find_in_html(result, "[data-phx-link]")
    end

    test "drops external when type patch" do
      result =
        render_with_captured_stderr(fn ->
          render_component(&CorexTest.ComponentHelpers.render_navigate_external_patch/1, to: "/")
        end)

      assert [_] = find_in_html(result, "[data-phx-link]")
    end

    test "default appearance stamps data-link" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate_styled/1, %{})

      assert [link] = find_in_html(result, "a")
      assert Floki.attribute([link], "data-link") != []
      refute Floki.attribute([link], "data-button") != []
    end

    test "as button stamps data-button modifiers" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate_styled/1,
          as: "button",
          semantic: "accent",
          variant: "solid",
          size: "lg"
        )

      assert [link] = find_in_html(result, "a")
      assert Floki.attribute([link], "data-button") != []
      assert Enum.any?(Floki.attribute([link], "data-button-semantic"), &(&1 == "accent"))
      assert Enum.any?(Floki.attribute([link], "data-button-variant"), &(&1 == "solid"))
    end

    test "disabled navigate omits href and sets aria-disabled" do
      result =
        render_component(&CorexTest.ComponentHelpers.render_navigate/1,
          to: "/about",
          type: "href",
          external: false,
          download: nil,
          aria_label: nil,
          disabled: true
        )

      refute result =~ ~S(href="/about")
      assert [_] = find_in_html(result, ~S(a[aria-disabled="true"]))
    end

    test "omits href for disallowed destination" do
      result =
        render_with_captured_stderr(fn ->
          render_component(&CorexTest.ComponentHelpers.render_navigate/1,
            to: "javascript:alert(1)",
            type: "href",
            external: false,
            download: nil,
            aria_label: nil
          )
        end)

      refute result =~ "javascript:alert(1)"
      assert text_in_html(result) =~ "Link text"
    end
  end
end
