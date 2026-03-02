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

      assert [_] = find_in_html(result, ~s(a[href="/about"]))
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

      assert [_] = find_in_html(result, ~s(a[target="_blank"][rel="noopener noreferrer"]))
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

      assert [_] = find_in_html(result, ~s(a[download="report.pdf"]))
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

      assert [_] = find_in_html(result, ~s(a[aria-label="View profile"]))
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
  end
end
