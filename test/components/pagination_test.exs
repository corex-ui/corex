defmodule Corex.PaginationTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Pagination
  alias Corex.Pagination.Anatomy.{NextTrigger, PrevTrigger, SsrPageItem}
  alias Corex.Pagination.Connect

  describe "pagination/1" do
    test "renders when more than one page" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_pagination/1,
          count: 50,
          page_size: 10
        )

      assert html =~ ~r/data-scope="pagination"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/phx-hook="Pagination"/
      assert html =~ ~r/data-part="item"/
      assert html =~ ~r/data-pagination-part="page"/
      assert html =~ "pagination:pagination-test:item:1"
      assert html =~ "pagination:pagination-test:item:5"
    end

    test "marks current page on the server" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_pagination/1,
          count: 50,
          page_size: 10,
          page: 3
        )

      assert html =~ ~r/data-part="item"[^>]*data-selected/
      assert html =~ ~r/aria-current="page"/
    end

    test "hidden when only one page" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_pagination/1, count: 5, page_size: 10)

      refute html =~ ~r/data-scope="pagination"/
    end

    test "link mode with patch redirect emits phx-link on navigable anchors" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_pagination_link_patch/1,
          count: 50,
          page_size: 10
        )

      assert html =~ ~S(data-phx-link="patch")
      assert html =~ ~S(data-phx-link-state="push")
      assert html =~ ~S(data-part="prev-trigger")
      assert html =~ ~S(data-part="next-trigger")
      assert html =~ ~S(data-part="item")
    end
  end

  describe "Connect link redirect attrs" do
    test "prev_trigger with patch redirect" do
      attrs =
        Connect.prev_trigger(%PrevTrigger{
          id: "p1",
          dir: "ltr",
          disabled: false,
          aria_label: "Previous",
          href: "/items?page=1&page_size=10",
          redirect: "patch",
          tag: "link"
        })

      assert attrs["data-phx-link"] == "patch"
      assert attrs["data-phx-link-state"] == "push"
    end

    test "prev_trigger disabled link omits aria-label" do
      attrs =
        Connect.prev_trigger(%PrevTrigger{
          id: "p1",
          dir: "ltr",
          disabled: true,
          aria_label: "Previous",
          href: nil,
          redirect: "patch",
          tag: "link"
        })

      refute Map.has_key?(attrs, "aria-label")
      assert attrs["data-disabled"] == ""
    end

    test "next_trigger disabled link omits aria-label" do
      attrs =
        Connect.next_trigger(%NextTrigger{
          id: "p1",
          dir: "ltr",
          disabled: true,
          aria_label: "Next",
          href: nil,
          redirect: "patch",
          tag: "link"
        })

      refute Map.has_key?(attrs, "aria-label")
      assert attrs["data-disabled"] == ""
    end

    test "root aria-label is unique per id" do
      attrs =
        Connect.root(%Corex.Pagination.Anatomy.Root{
          id: "results",
          dir: "ltr",
          aria_label: "Pagination"
        })

      assert attrs["aria-label"] == "Pagination (results)"
    end

    test "next_trigger with navigate redirect" do
      attrs =
        Connect.next_trigger(%NextTrigger{
          id: "p1",
          dir: "ltr",
          disabled: false,
          aria_label: "Next",
          href: "/items?page=2&page_size=10",
          redirect: "navigate",
          tag: "link"
        })

      assert attrs["data-phx-link"] == "redirect"
      assert attrs["data-phx-link-state"] == "push"
    end

    test "ssr_page_item with href redirect has no phx-link" do
      attrs =
        Connect.ssr_page_item(%SsrPageItem{
          id: "p1",
          dir: "ltr",
          page: 2,
          index: 1,
          selected: false,
          aria_label: "Page 2",
          href: "/items?page=2&page_size=10",
          redirect: "href",
          tag: "link"
        })

      refute Map.has_key?(attrs, "data-phx-link")
    end
  end

  describe "Connect.props/1" do
    test "controlled page uses data-page not data-default-page" do
      props =
        Connect.props(%Corex.Pagination.Anatomy.Props{
          id: "p1",
          count: 100,
          page: 2,
          page_size: 10,
          controlled: true,
          controlled_page_size: false,
          type: "button"
        })

      assert props["data-page"] == "2"
      assert props["data-default-page"] == nil
      assert props["data-controlled"] == ""
    end

    test "uncontrolled page uses data-default-page" do
      props =
        Connect.props(%Corex.Pagination.Anatomy.Props{
          id: "p1",
          count: 100,
          page: 2,
          page_size: 10,
          controlled: false,
          controlled_page_size: false,
          type: "button"
        })

      assert props["data-page"] == nil
      assert props["data-default-page"] == "2"
    end

    test "controlled page size uses data-page-size" do
      props =
        Connect.props(%Corex.Pagination.Anatomy.Props{
          id: "p1",
          count: 100,
          page: 1,
          page_size: 25,
          controlled: false,
          controlled_page_size: true,
          type: "button"
        })

      assert props["data-page-size"] == "25"
      assert props["data-default-page-size"] == nil
      assert props["data-controlled-page-size"] == ""
    end

    test "omits data-to for disallowed base URL" do
      props =
        Connect.props(%Corex.Pagination.Anatomy.Props{
          id: "p1",
          count: 100,
          type: "link",
          to: "javascript:alert(1)"
        })

      assert props["data-to"] == nil
    end

    test "includes data-to for allowed base URL" do
      props =
        Connect.props(%Corex.Pagination.Anatomy.Props{
          id: "p1",
          count: 100,
          type: "link",
          to: "/items"
        })

      assert props["data-to"] == "/items"
    end
  end

  describe "set_page/2" do
    test "returns JS command" do
      assert %Phoenix.LiveView.JS{} = Pagination.set_page("my-pagination", 3)
    end
  end

  describe "set_page/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Pagination.set_page(socket, "my-pagination", 3)
    end
  end

  describe "pagination edge cases" do
    test "link mode renders ellipsis and page anchors" do
      html =
        render_component(
          &CorexTest.ComponentHelpers.render_pagination_link_patch/1,
          count: 500,
          page_size: 10,
          page: 25
        )

      assert html =~ ~S(data-part="ellipsis")
      assert html =~ ~S(<a )
      assert html =~ ~S(data-pagination-part="page")
    end

    test "hidden when count is zero" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_pagination/1,
          count: 0,
          page_size: 10
        )

      refute html =~ ~S(data-scope="pagination")
    end
  end

  describe "navigation API helpers" do
    test "set_page_size/2 and /3" do
      assert %Phoenix.LiveView.JS{} = Pagination.set_page_size("pg", 25)

      assert %Phoenix.LiveView.Socket{} =
               Pagination.set_page_size(%Phoenix.LiveView.Socket{}, "pg", 25)
    end

    test "go_to_next_page/1 and /2" do
      assert %Phoenix.LiveView.JS{} = Pagination.go_to_next_page("pg")

      assert %Phoenix.LiveView.Socket{} =
               Pagination.go_to_next_page(%Phoenix.LiveView.Socket{}, "pg")
    end

    test "go_to_prev_page/1 and /2" do
      assert %Phoenix.LiveView.JS{} = Pagination.go_to_prev_page("pg")

      assert %Phoenix.LiveView.Socket{} =
               Pagination.go_to_prev_page(%Phoenix.LiveView.Socket{}, "pg")
    end

    test "go_to_first_page/1 and /2" do
      assert %Phoenix.LiveView.JS{} = Pagination.go_to_first_page("pg")

      assert %Phoenix.LiveView.Socket{} =
               Pagination.go_to_first_page(%Phoenix.LiveView.Socket{}, "pg")
    end

    test "go_to_last_page/1 and /2" do
      assert %Phoenix.LiveView.JS{} = Pagination.go_to_last_page("pg")

      assert %Phoenix.LiveView.Socket{} =
               Pagination.go_to_last_page(%Phoenix.LiveView.Socket{}, "pg")
    end
  end
end
